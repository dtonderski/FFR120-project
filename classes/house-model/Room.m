classdef Room
    %ROOM Summary of this class goes here
    %   room_name              - name of the room
    %   room_start_house       - coordinate of the start point of the room in the house
    %   room_stop_house        - coordinate of the end point of the room in the house
    %   lattice_with_furniture - room lattice:
    %                            hiding_place = -1 
    %                            floor = 0
    %                            furniture  = other    
    
    properties
        room_name
        room_start_house
        room_stop_house
        lattice_with_furniture
        furniture_list
        room_color
        hiding_place_color = [1 0 0]
    end
    
    methods
        function obj = Room(room_name, room_start, room_stop, room_color)
            %ROOM Construct an instance of this class
            %   Detailed explanation goes here
            obj.room_name = room_name;
            obj.room_start_house = room_start;
            obj.room_stop_house = room_stop;
            obj.room_color = room_color;
            obj.lattice_with_furniture = zeros(room_stop(1) - room_start(1) + 1, room_stop(2) - room_start(2) + 1);
            obj.furniture_list = [];
        end
        
        function obj = add_hiding_place(obj, hiding_place_start, hiding_place_stop)
            hiding_place_start_room = hiding_place_start - obj.room_start_house + 1;
            hiding_place_stop_room = hiding_place_stop - obj.room_start_house +1;
            
            obj.lattice_with_furniture(hiding_place_start_room(1):hiding_place_stop_room(1),...
                                       hiding_place_start_room(2):hiding_place_stop_room(2)) = -1;
        end
        
        function traversable = is_traversable(obj, x, y)
            
            if isequal(obj.room_name, 'wall')
                traversable = false;
                return
            elseif isequal(obj.room_name, 'door')
                traversable = true;
                return
            end
            
            x_room = x - obj.room_start_house(1) + 1;
            y_room = y - obj.room_start_house(2) + 1;

            
            furniture_number = obj.lattice_with_furniture(x_room,y_room);

            if furniture_number == -1 || furniture_number == 0
                traversable = true;
                return
            else
                furniture = obj.furniture_list(furniture_number);
                traversable = furniture.is_traversable(x,y);
            end
        end
        
        function hidden = is_hiding_place(obj,x,y)
            x_room = x - obj.room_start_house(1) + 1;
            y_room = y - obj.room_start_house(2) + 1;
            
            hidden = obj.lattice_with_furniture(x_room,y_room) == -1;
        end
        
        function show_room(obj)
            position_vector = [obj.room_start_house - 1/2, obj.room_stop_house-obj.room_start_house + 1];
            rectangle('Position', position_vector, 'FaceColor', obj.room_color, 'LineStyle', 'none');

            if ~(isequal(obj.room_name, 'wall') || isequal(obj.room_name, 'door'))
                text_pos = (obj.room_start_house + obj.room_stop_house)/2;
                text(text_pos(1), text_pos(2), obj.room_name, 'HorizontalAlignment','center', 'VerticalAlignment', 'middle');
            end
            
            [row_hidden, col_hidden] = find(obj.lattice_with_furniture == -1);
            for i = 1:length(row_hidden)
                x = row_hidden(i) + obj.room_start_house(1) - 1;
                y = col_hidden(i) + obj.room_start_house(2) - 1;
                position_vector = [x-1/2, y-1/2, 1, 1];
                rectangle('Position', position_vector, 'FaceColor', obj.hiding_place_color, 'LineStyle', 'none')
            end
            
        end
        
    end
    
    methods(Static)
        
        function room_list = create_deafult_room_list()
            kitchen  = Room("Kitchen", [2,2], [50, 40], [1 1 1]);
            bedroom1 = Room("Bedroom 1", [2, 60], [40, 99], [1 1 1]);
            bedroom2 = Room("Bedroom 2", [41, 60], [80, 99], [1 1 1]);
            toilet   = Room("Toilet", [81,60], [99, 99], [1 1 1]);
            closet   = Room("Closet", [2,42], [20, 58], [1 1 1]);
            livingarea = Room("Living area", [52,2], [99, 40], [1 1 1]);
            hallway = Room("Hallway", [22,42], [90, 58], [1 1 1]);
            % Must be last!
            outside = Room("Out", [92,42], [99, 58], [1 1 1]);
            
            room_list = [kitchen, bedroom1, bedroom2, toilet, closet, livingarea, hallway, outside];
        end
    end
end

