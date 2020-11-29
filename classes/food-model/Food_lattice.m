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
        
        function obj = clean_area(obj, area_start, area_stop)
            indices_to_remove = [];
            for i_food_location = 1:size(obj.food_locations, 1)
                food_location = obj.food_locations(i_food_location,:);
                
                if all(food_location <= area_stop & food_location >= area_start)
                    obj.lattice(food_location(1), food_location(2)) = 0;
                    indices_to_remove = [indices_to_remove, i_food_location];
                end
            end
            obj.food_locations(indices_to_remove, :) = [];
        end
        
        function obj = add_food_area(obj, area_start, area_stop, quantity, numberOfLocations)
            placedOutFood = 0;
            for i = 1:numberOfLocations
                if i == numberOfLocations
                    quantityInLocation = quantity - placedOutFood;
                else
                    quantityInLocation = randi([1, quantity - placedOutFood - (numberOfLocations - i)]);
                    placedOutFood = placedOutFood + quantityInLocation;
                end
                x = randi([area_start(1), area_stop(1)]);
                y = randi([area_start(2), area_stop(2)]);
                obj = add_food(obj, [x,y],quantityInLocation);
            end
        end
        
        function obj = remove_food(obj, location)
            current_food = obj.lattice(location(1), location(2));
            if current_food ~= 0
                index = ismember(obj.food_locations, location, 'rows');
                obj.lattice(location(1), location(2)) = 0;
                obj.food_locations(index, :) = [];
            end

        end
        
        function p = show_food(obj, markerType, markerSize, color)
            n_locations = size(obj.food_locations,1);
            X = zeros(n_locations,1);
            Y = zeros(n_locations,1);
            for i_location = 1:n_locations
                location = obj.food_locations(i_location,:);
                X(i_location) = location(1);
                Y(i_location) = location(2);
            end

            p = scatter(X,Y, markerSize, markerType, color);
        end
        
        function food_locations_in_area = get_food_locations_in_area(obj, area_start, area_stop)
            food_locations_in_area = [];
            for i_food_location = 1:size(obj.food_locations, 1)
                food_location = obj.food_locations(i_food_location,:);
                if all(food_location <= area_stop & food_location >= area_start)
                    food_locations_in_area = [food_locations_in_area; food_location(1), food_location(2)];
                end
            end
        end
    end
end

