classdef Bug
    %BUG Summary of this class goes here
    % x,y             - position of bug on lattice
    % age             - age of the bug controls death and reproduction
    % hunger          - bug dies when hunger reaches some value
    % in_hiding_place - boolean that says whether a bug is currently in a
    %                   hiding place
    
    properties
        x {mustBeNumeric}
        y {mustBeNumeric}
        age {mustBeNumeric}
        hunger {mustBeNumeric}
        in_hiding_place
    end
    
    methods
        function obj = Bug(x,y, house)
            obj.x = x;
            obj.y = y;
            obj.age = 0;
            obj.in_hiding_place = house.is_hiding_place(x,y);
        end
        
        function obj = move(obj, house, food_lattice, moveOutOfHidingPlaceProbability)
            if obj.in_hiding_place
                if rand < moveOutOfHidingPlaceProbability
                    food_locations_in_room = house.get_food_locations_in_current_room(obj.x, obj.y, food_lattice);
                    food_location_index = randi([1, size(food_locations_in_room, 1)]);
                    obj.x = food_locations_in_room(food_location_index, 1);
                    obj.y = food_locations_in_room(food_location_index, 2);
                    obj.in_hiding_place = false;
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
        
    end
    
    methods(Static)
        function bug_list = update_bugs(bug_list, reproduction_age, death_age,  reproduction_number, house, food_lattice, move_out_of_hiding_place_probability, reproduction_probability)
            bugs_to_kill_indices = [];
            for bug_index = 1:length(bug_list)
                bug = bug_list(bug_index);
                bug = bug.move(house, food_lattice, move_out_of_hiding_place_probability);
                bug = bug.grow();
                bug_list(bug_index) = bug;
                if bug.age >= death_age
                    bugs_to_kill_indices = [bugs_to_kill_indices, bug_index];
                elseif bug.age > reproduction_age
                    if rand < reproduction_probability
                        for i = 1:reproduction_number
                            bug_list = [bug_list, Bug(bug.x, bug.y, house)];
                        end
                    end
                end
            end
            bug_list(bugs_to_kill_indices) = [];
        end
        
        function p = show_bugs(bug_list, marker_type, marker_size, color)
            n_bugs = length(bug_list);
            X = zeros(1, n_bugs);
            Y = zeros(1, n_bugs);
            for i = 1:n_bugs
                bug = bug_list(i);
                X(i) = bug.x;
                Y(i) = bug.y;
            end
            p = scatter(X,Y,marker_size,marker_type,color);
        end
    end
end
