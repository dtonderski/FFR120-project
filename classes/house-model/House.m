classdef House
    %HOSUE1Q Summary of this class goes here
    %   x_size             - house size x
    %   y_size             - house size y
    %   room_list          - list with all the rooms in the house
    %   lattice_with_rooms - lattice with:
    %                           walls = -1
    %                           floor = 0
    %                           room  = other
    
    properties
        x_size
        y_size
        room_list
        lattice_with_rooms
    end
    
    methods
        function obj = House(x_size, y_size)
            obj.x_size = x_size;
            obj.y_size = y_size;
            obj.room_list  = [];
            obj.lattice_with_rooms = zeros(x_size, y_size);
        end
        
        function obj = add_room(obj, room_name, room_start, room_stop)
            %METHOD1 Summary of this method goes here
            %   roomName  = string
            %   roomStart = [x,y]
            %   roomStop  = [x,y]
            existing_number_rooms = length(obj.room_list);
            room = Room(room_name, room_start, room_stop);
            obj.room_list = [obj.room_list, room];
            obj.lattice_with_rooms(room_start(1):room_stop(1), room_start(2):room_stop(2)) = ...
                ones(room_stop(1) - room_start(1) + 1, room_stop(2) - room_start(2) + 1)*(existing_number_rooms + 1);
        end
        function traversable = is_traversable(obj, x,y)
            room_number = obj.lattice_with_rooms(x,y);
            
            if room_number == 0
                traversable = true;
                return
            elseif room_number == -1
                traversable = false;
                return
            else
                room = obj.room_list(room_number);
                traversable = room.is_traversable(x,y);
            end
        end
        
        function obj = add_wall(obj, wall_start, wall_stop)
            obj.lattice_with_rooms(wall_start(1):wall_stop(1), wall_start(2):wall_stop(2)) = ...
                ones(wall_stop(1) - wall_start(1) + 1, wall_stop(2) - wall_start(2) + 1)*(-1);
        end
    end
end

