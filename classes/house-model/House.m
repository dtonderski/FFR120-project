classdef House
    %HOUSE Summary of this class goes here
    %   x_size             - house size x
    %   y_size             - house size y
    %   room_list          - list with all the rooms in the house
    %   lattice_with_rooms - lattice with:
    %                           floor = 0
    %                           room  = other
    
    properties
        x_size
        y_size
        room_list
        lattice_with_rooms
        hiding_places
    end
    
    methods
        function obj = House(x_size, y_size)
            obj.x_size = x_size;
            obj.y_size = y_size;
            obj.room_list  = [];
            obj.lattice_with_rooms = zeros(x_size, y_size);
        end
        
        function obj = edit_room(obj,room)
            for i_room = 1:length(obj.room_list)
                if isequal(room.room_name, obj.room_list(i_room).room_name)
                    room_index = i_room;
                    break;
                end
            end
            obj.room_list(room_index) = room;
        end
        
        function room = find_room(obj, room_name)
            for i_room = 1:length(obj.room_list)
                if isequal(room_name, obj.room_list(i_room).room_name)
                    room = obj.room_list(i_room);
                    return
                end
            end
            error("Couldn't find room!");
        end
        
        function obj = add_room(obj, room)
            %METHOD1 Summary of this method goes here
            %   roomName  = string
            %   roomStart = [x,y]
            %   roomStop  = [x,y]
            existing_number_rooms = length(obj.room_list);
            obj.room_list = [obj.room_list, room];
            
            room_start = room.room_start_house;
            room_stop = room.room_stop_house;
            
            obj.lattice_with_rooms(room_start(1):room_stop(1), room_start(2):room_stop(2)) = ...
                (existing_number_rooms + 1);
                
            if ~(isequal(room.room_name, 'wall') || isequal(room.room_name, 'door'))
                x_start = room_start(1) - 1;
                x_stop  = room_stop (1) + 1;
                y_start = room_start(2) - 1;
                y_stop  = room_stop(2) + 1;
                obj = obj.add_wall([x_start, y_start], [x_stop , y_start]);
                obj = obj.add_wall([x_start, y_start], [x_start, y_stop ]);
                obj = obj.add_wall([x_start, y_stop ], [x_stop , y_stop ]);
                obj = obj.add_wall([x_stop , y_start], [x_stop,  y_stop ]);
            end
        end
        
        function obj = add_hiding_place(obj, hiding_place_start, hiding_place_stop)
            i_room = obj.lattice_with_rooms(hiding_place_start(1), hiding_place_start(2));
            if ~all(obj.lattice_with_rooms(hiding_place_start(1):hiding_place_stop(1),...
                    hiding_place_start(2):hiding_place_stop(2)) == i_room)
                error('A hiding place cannot span multiple rooms/walls/doors!')
            end
            
            room = obj.room_list(i_room);
            
            room = room.add_hiding_place(hiding_place_start, hiding_place_stop);
            
            
            obj.room_list(i_room) = room;
            
            obj.hiding_places = [obj.hiding_places; hiding_place_start, hiding_place_stop];
            
        end
        
        function obj = add_wall(obj, wall_start, wall_stop)
            wall = Room('wall', wall_start, wall_stop, [0 0 0]);
            obj = obj.add_room(wall);
        end
        
        function obj = add_walls_around_house(obj)
            obj = obj.add_wall([1,1], [obj.x_size, 1]);
            obj = obj.add_wall([1,1], [1, obj.y_size]);
            obj = obj.add_wall([obj.x_size,1], [obj.x_size,obj.y_size]);
            obj = obj.add_wall([1,obj.y_size], [obj.x_size,obj.y_size]);
        end
        
        function obj = add_door(obj, door_start, door_stop)
            %NOTE - doors must be added at the end, as they will be
            %overwritten otherwise.
            door = Room('door', door_start, door_stop, [1 1 1]);
            obj = obj.add_room(door);
        end
        
        function traversable = is_traversable(obj, x,y)
            room_number = obj.lattice_with_rooms(x,y);
            
            if room_number == 0
                traversable = true;
                return
            else
                room = obj.room_list(room_number);
                traversable = room.is_traversable(x,y);
            end
        end
      
        function show_house(obj)
            doors = [];
            for room = obj.room_list
                room_name = room.room_name;
                if isequal(room_name, doors)
                    doors = [doors, room];
                end
                room.show_room()
            end
            
            for door = doors
                door.show_room()
            end
            
            xlim([0, obj.x_size+1])
            ylim([0, obj.y_size+1])
        end
        
        function food_locations_in_room = get_food_locations_in_current_room(obj, x, y, food_lattice)
            current_room = obj.room_list(obj.lattice_with_rooms(x,y));
            food_locations_in_room = food_lattice.get_food_locations_in_area(current_room.room_start_house, current_room.room_stop_house);
        end
        
        function free_sticky_pad_locations_in_room = get_free_sticky_pad_locations_in_current_room(obj, x, y, sticky_pads)
            current_room = obj.room_list(obj.lattice_with_rooms(x,y));
            free_sticky_pad_locations_in_room = sticky_pads.get_free_sticky_pad_locations_in_area(current_room.room_start_house, current_room.room_stop_house);
        end
        
        function hidden = is_hiding_place(obj, x, y)
            room_number = obj.lattice_with_rooms(x,y);
            
            if room_number == 0
                hidden = false;
                return
            else
                room = obj.room_list(room_number);
                hidden = room.is_hiding_place(x,y);
            end
        end
        

    end
    
    methods(Static)
        function house = create_default_house(room_list)
            house = House(100,100);
            house = house.add_walls_around_house;
            for room = room_list
                house = house.add_room(room);
            end

            house = house.add_door([51, 21], [51, 31]);
            house = house.add_door([30, 59], [35, 59]);
            house = house.add_door([70, 59], [75, 59]);
            house = house.add_door([83, 59], [88, 59]);
            house = house.add_door([21, 47], [21, 52]);
            house = house.add_door([60, 41], [80, 41]);

            house = house.add_door([51, 21], [51, 31]);
            house = house.add_door([30, 59], [35, 59]);
            house = house.add_door([70, 59], [75, 59]);
            house = house.add_door([83, 59], [88, 59]);
            house = house.add_door([21, 47], [21, 52]);
            house = house.add_door([60, 41], [80, 41]);

            % kitchen
            house = house.add_hiding_place([2 2], [8 40]);
            house = house.add_hiding_place([9 2], [40 8]);
            % toilet
            house = house.add_hiding_place([81 90], [99 99]);
            house = house.add_hiding_place([81 67], [84 83]);
            house = house.add_hiding_place([93 60], [98 65]);


            house = house.add_hiding_place([60 10], [70, 20]);
            house = house.add_hiding_place([10 90], [20 95]);
            
        end
    end
end

