classdef Human
    %HUMAN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position
        house
    end
    
    methods
        function obj = Human(position, house)
            obj.position = position;
            obj.house = house;
        end
        
        function obj = assignHouse(obj, house)
            obj.house = house;
        end
        
        function obj = move(obj)
            current_house = obj.house;
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
    end
end

