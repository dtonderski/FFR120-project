classdef Human
    %HUMAN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position
    end
    
    methods
        function obj = Human(position)
            obj.position = position;
        end
        
        function obj = assignHouse(obj, house)
            obj.house = house;
        end
        
        function obj = move_random(obj, house)
            current_house = house;
            while true
                direction = randi([1 2]);
                newPosition = obj.position;
                newPosition(direction) = newPosition(direction) + randi([0 1])*2-1;

                if(current_house.is_traversable(newPosition(1), newPosition(2)))
                    obj.position = newPosition;
                    return;
                end
            end        
        end
        
        function show_human(obj, markerType, markerSize)
            plot(obj.position(1), obj.position(2), markerType, 'MarkerSize', markerSize)
        end
        
        function obj = clean(obj, house, clean_room)
            
            for rooms = 1:length(house.room_list)
                if isequal(house.room_list(1,rooms).room_name, clean_room)
                    
                disp('Remove food and other trash')
                end
            end
        end
    end
end

