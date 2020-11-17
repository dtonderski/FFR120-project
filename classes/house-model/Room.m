classdef Room
    %ROOM Summary of this class goes here
    %   room_name        - name of the room
    %   room_start_house - coordinate of the start point of the room in the house
    %   room_stop_house  - coordinate of the end point of the room in the house
    %   lattice_with_furniture          - room lattice
    
    
    properties
        room_name
        room_start_house
        room_stop_house
        lattice_with_furniture
        furniture_list
        
    end
    
    methods
        function obj = Room(room_name, room_start, room_stop)
            %ROOM Construct an instance of this class
            %   Detailed explanation goes here
            obj.room_name = room_name;
            obj.room_start_house = room_start;
            obj.room_stop_house = room_stop;
            obj.lattice_with_furniture = zeros(room_stop(1) - room_start(1) + 1, room_stop(2) - room_start(2) + 1);
            obj.furniture_list = [];
        end
        
        function traversable = is_traversable(obj, x, y)
            x_room = x - obj.room_start_house(1) + 1;
            y_room = y - obj.room_start_house(2) + 1;
            
            furniture_number = obj.lattice_with_furniture(x_room,y_room);
            
            if furniture_number == 0
                traversable = true;
                return
            elseif furniture_number == -1
                traversable = false;
                return
            else
                furniture = obj.furniture_list(furniture_number);
                traversable = furniture.is_traversable(x,y);
            end
        end
    end
end

