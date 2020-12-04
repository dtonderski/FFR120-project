classdef Bug
    %BUG Summary of this class goes here
    % x,y             - position of bug on lattice
    % age             - age of the bug controls death and reproduction
    % hunger          - bug dies when hunger reaches some value
    % in_hiding_place - boolean that says whether a bug is currently in a
    %                   hiding place
    % drug_resistance - probability that bug resists pesticide
    % reproduce_procedure
    % egg_list
    
    properties
        x {mustBeNumeric}
        y {mustBeNumeric}
        age {mustBeNumeric}
        hunger {mustBeNumeric}
        in_hiding_place
        drug_resistance {mustBeNumeric}
        reproduce_procedure {mustBeNumeric}
        
    end
    
    methods
        function obj = Bug(x,y, house)
            obj.x = x;
            obj.y = y;
            obj.age = 0;
            obj.hunger = 0;
            obj.in_hiding_place = house.is_hiding_place(x,y);
            obj.reproduce_procedure = 0;
        end
        
        function obj = move(obj, house, food_lattice, moveOutOfHidingPlaceProbability)
            if obj.in_hiding_place
                if rand < moveOutOfHidingPlaceProbability
                    food_locations_in_room = house.get_food_locations_in_current_room(obj.x, obj.y, food_lattice);
                    if ~isempty(food_locations_in_room)
                        food_location_index = randi([1, size(food_locations_in_room, 1)]);
                        obj.x = food_locations_in_room(food_location_index, 1);
                        obj.y = food_locations_in_room(food_location_index, 2);
                        obj.in_hiding_place = false;
                    end
                end
            else
                hiding_place_index = randi([1, size(house.hiding_places, 1)]);
                new_location_x = randi(house.hiding_places(hiding_place_index, [1 3]));
                new_location_y = randi(house.hiding_places(hiding_place_index, [2 4]));
                obj.x = new_location_x;
                obj.y = new_location_y;
                obj.in_hiding_place = true;
            end
            
        end
        
        function obj = grow(obj)
            
            obj.age = obj.age + 1;
        end
        
        function [obj,food_lattice] = consume(obj,food_lattice)
            obj.hunger = obj.hunger + 0.014;  % less than 12h not eat food bug will die
            food_locations_in_house = food_lattice.food_locations;
            for i = 1:size(food_locations_in_house,1)
                if (obj.x == food_locations_in_house(i,1)&&obj.y==food_locations_in_house(i,2))
                    obj.hunger = max(0,obj.hunger-1);
                    food_lattice = food_lattice.remove_quantity_of_food(food_locations_in_house(i,:),1);
                    break;
                end
            end
        end
        
        function egg = lay_eggs(obj, quantity)
            egg = Egg(obj.x,obj.y,quantity);
        end
        
    end
    
    methods(Static)
        function [bug_list,egg_list,food_lattice] = update_bugs(bug_list, egg_list, reproduction_age, reproduction_probability, reproduction_hunger, maxEggs, death_age, death_hunger, house, food_lattice, move_out_of_hiding_place_probability)
            bugs_to_kill_indices = [];
            for bug_index = 1:length(bug_list)
                bug = bug_list(bug_index);
                bug = bug.move(house, food_lattice, move_out_of_hiding_place_probability);
                [bug,food_lattice] = bug.consume(food_lattice);
                bug = bug.grow();
                if bug.age >= death_age || bug.hunger >= death_hunger
                    bugs_to_kill_indices = [bugs_to_kill_indices, bug_index];
                end
                if bug.age > reproduction_age && bug.in_hiding_place && bug.hunger < reproduction_hunger
                    if rand < reproduction_probability                    
                        numberOfEggs = randi(maxEggs);
                        egg = bug.lay_eggs(numberOfEggs);
                        egg_list = [egg_list,egg];
                    end
                end
                bug_list(bug_index) = bug;
            end
            bug_list(bugs_to_kill_indices) = [];
        end
        
        function p = show_bugs(bug_list, marker_type, marker_size)
            n_bugs = length(bug_list);
            X = zeros(1, n_bugs);
            Y = zeros(1, n_bugs);
            color(1,:) = [1 1 1];
            cmap = colormap(summer(101));
            for i = 1:n_bugs
                bug = bug_list(i);
                X(i) = bug.x;
                Y(i) = bug.y;
                color(i,:) = cmap(bug.age+1,:);
            end
            p = scatter(X,Y,marker_size,color,marker_type);
        end
    end
end
