classdef Food_lattice
    %FOOD_LATTICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        lattice
        food_locations
    end
    
    methods
        function obj = Food_lattice(house)
            obj.lattice = zeros(size(house.lattice_with_rooms));
        end
        
        function obj = add_food(obj, location, quantity)
            current_food = obj.lattice(location(1), location(2));
            if current_food == 0
                obj.food_locations = [obj.food_locations;location];                
            end
            current_food = current_food + quantity;
            obj.lattice(location(1), location(2)) = current_food;
        end
        

        function remove_food(obj, location)
            current_food = obj.lattice(location(1), location(2));
            if current_food ~= 0
                index = ismember(obj.food_locations, location, 'rows');
                obj.food_lattice(location(1), location(2)) = 0;
                obj.food_locations(index, :) = [];
            end

        end
        
        function show_food(obj, markerType, markerSize, color)
            for i_location = 1:size(obj.food_locations,1)
                location = obj.food_locations(i_location,:);
                plot(location(1), location(2), markerType, 'MarkerSize', markerSize, 'Color', color)
            end
        end
        
        
    end
end

