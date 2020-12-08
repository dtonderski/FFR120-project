classdef Bug
    %BUG Summary of this class goes here
    % x,y             - position of bug on lattice
    % age             - age of the bug controls death and reproduction
    % hunger          - bug dies when hunger reaches some value
    % in_hiding_place - boolean that says whether a bug is currently in a
    %                   hiding place
    % drug_resistance - probability that bug resists pesticide
    % on_sticky_pad
    
    properties
        x {mustBeNumeric}
        y {mustBeNumeric}
        age {mustBeNumeric}
        hunger {mustBeNumeric}
        in_hiding_place
        drug_resistance {mustBeNumeric}
        on_sticky_pad
        room
        death_age {mustBeNumeric}
        reproduction_age {mustBeNumeric}
        adult_age {mustBeNumeric}
    end
    
    methods
        function obj = Bug(x,y, house)
            obj.x = x;
            obj.y = y;
            obj.age = 0;
            obj.hunger = 0;
            obj.in_hiding_place = house.is_hiding_place(x,y);
            obj.on_sticky_pad = 0;
            obj.room = house.room_list(house.lattice_with_rooms(obj.x,obj.y));
            obj.death_age = randi([14400,28800],1); %100-200 days; timestep = 10 min
            obj.adult_age = randi([5760,obj.death_age],1);% 40 days
            obj.reproduction_age = obj.adult_age + 1008; % can reproduce after being an adult for 1 week
        end
        
        function obj = change_room_to_random_different(obj, room_list)
            choose_two_rooms = randperm(length(room_list)-1,2);
            if isequal(obj.room.room_name, room_list(choose_two_rooms(1)).room_name)
                new_room_index = choose_two_rooms(2);
            else
                new_room_index = choose_two_rooms(1);
            end
            obj.room = room_list(new_room_index);
        end
        
        function obj = move_randomly_within_room(obj)
            room_start = obj.room.room_start_house;
            room_stop = obj.room.room_stop_house;

            obj.x = room_start(1) + fix(rand * (room_stop(1) - room_start(1)) + 1);
            obj.y = room_start(2) + fix(rand * (room_stop(2) - room_start(2)) + 1);
        end
        
        function [obj, sticky_pads] = check_if_on_sticky_pad(obj, sticky_pads)
            if sticky_pads.lattice(obj.x,obj.y) > 0 
                obj.on_sticky_pad = true;
                sticky_pads = sticky_pads.add_bug_to_sticky_pad([obj.x, obj.y]);
            end
        end
        
        function [obj,sticky_pads] = random_move(obj,house,room_list,sticky_pads,change_room_probability)
            
            if obj.on_sticky_pad
                return
            end
            if rand < change_room_probability 
                obj = change_room_to_random_different(obj, room_list);
            end      
            
            obj = move_randomly_within_room(obj);
            [obj, sticky_pads] = check_if_on_sticky_pad(obj, sticky_pads);
            
            obj.in_hiding_place = house.is_hiding_place(obj.x,obj.y);

        end

        function [obj, sticky_pads] = regular_move(obj, house, room_list, food_lattice, human_list, sticky_pads, ...
                            move_out_of_hiding_probability, change_room_probability, change_rooms_if_no_food_probability, ...
                            move_out_of_hiding_probability_if_human_in_room)       
            % if bug is stuck - don't move
            % else if rand < change room probability - change position to 
            %   random position in new room
            % else if object is in hiding place
            %   if human in room, don't move
            %   if rand < moveOutOfHidingPlaceProbability, 
            %       if there are foods or sticky pads in room
            %           move to random
            %       else
            %           if rand < change_rooms_if_no_food_probability
            %               move to random room
            %           else
            %               stay still
            %   
            % else (object isn't in a hiding place, but isn't stuck or
            %       supposed to move out of the hiding place):
            %   if there are hiding places in the room: move to random 
            %       hiding place within room
            %   else 
            %       if there are no foods or sticky pads in the room
            %           if rand < change_rooms_if_no_food_probability
            %                   move to random room
            %       else
            %           call random_move
            
            if obj.on_sticky_pad
                return
            elseif rand < change_room_probability
                obj = change_room_to_random_different(obj, room_list);
                obj = move_randomly_within_room(obj);
                [obj, sticky_pads] = check_if_on_sticky_pad(obj, sticky_pads);
                obj.in_hiding_place = house.is_hiding_place(obj.x,obj.y);
            elseif obj.in_hiding_place
                for human = human_list
                    if isequal(human.room.room_name, obj.room.room_name) && human.sleeping
                        if rand > move_out_of_hiding_probability_if_human_in_room
                            return
                        end
                    end
                end
                if rand < move_out_of_hiding_probability
                    food_locations_in_room = house.get_food_locations_in_current_room(obj.x, obj.y, food_lattice);
                    free_sticky_pad_locations_in_room = house.get_free_sticky_pad_locations_in_current_room(obj.x, obj.y, sticky_pads); 
                    locations = [free_sticky_pad_locations_in_room;food_locations_in_room];
                    
                    if ~isempty(locations)
                        new_location_index = randi([1, size(locations, 1)]);
                        obj.x = locations(new_location_index, 1);
                        obj.y = locations(new_location_index, 2);
                        obj.in_hiding_place = house.is_hiding_place(obj.x,obj.y);
                        [obj, sticky_pads] = check_if_on_sticky_pad(obj, sticky_pads);
                    elseif rand < change_rooms_if_no_food_probability
                        obj = change_room_to_random_different(obj, room_list);
                        obj = move_randomly_within_room(obj);
                        [obj, sticky_pads] = check_if_on_sticky_pad(obj, sticky_pads);
                        obj.in_hiding_place = house.is_hiding_place(obj.x,obj.y);
                    end

                end
            else
                [locations_x, locations_y] = house.get_hidden_locations_in_room(obj.room.room_name);
                if ~isempty(locations_x)
                    new_location_index = randi([1 size(locations_x, 1)]);
                    obj.x = locations_x(new_location_index);
                    obj.y = locations_y(new_location_index);
                    [obj, sticky_pads] = check_if_on_sticky_pad(obj, sticky_pads);
                    obj.in_hiding_place = true;
                else
                    food_locations_in_room = house.get_food_locations_in_current_room(obj.x, obj.y, food_lattice);
                    free_sticky_pad_locations_in_room = house.get_free_sticky_pad_locations_in_current_room(obj.x, obj.y, sticky_pads); 

                    if isempty(food_locations_in_room) && isempty(free_sticky_pad_locations_in_room)
                        if rand < change_rooms_if_no_food_probability
                            obj = change_room_to_random_different(obj, room_list);
                            obj = move_randomly_within_room(obj);
                            [obj, sticky_pads] = check_if_on_sticky_pad(obj, sticky_pads);
                            obj.in_hiding_place = house.is_hiding_place(obj.x,obj.y);
                        else
                            [obj,sticky_pads] = random_move(obj,house,room_list,sticky_pads,change_room_probability);
                        end
                    else
                        [obj,sticky_pads] = random_move(obj,house,room_list,sticky_pads,change_room_probability);
                    end
                end
            end
        end
        
        function [obj, sticky_pads] = hungry_move(obj,house,sticky_pads,food_lattice)
            % this function works if the bug is very hungry. if food/sticky pad in
            % current room, must move to the food; else move to food/sticky pad in
            % other rooms
             if obj.on_sticky_pad
                return
             else
                 food_locations_in_room = house.get_food_locations_in_current_room(obj.x, obj.y, food_lattice);
                 free_sticky_pad_locations_in_room = house.get_free_sticky_pad_locations_in_current_room(obj.x, obj.y, sticky_pads);
                 locations = [free_sticky_pad_locations_in_room;food_locations_in_room];
                 if ~isempty(locations)
                     new_location_index = randi([1, size(locations, 1)]);
                     obj.x = locations(new_location_index, 1);
                     obj.y = locations(new_location_index, 2);
                   
                 else
                     food_locations_in_house = food_lattice.food_locations;
                     sticky_pad_locations_in_house = sticky_pads.pad_locations;
                     all_locations_in_house = [food_locations_in_house;sticky_pad_locations_in_house];
                     index = randi([1,size(all_locations_in_house,1)]);
                     obj.x = all_locations_in_house(index,1);
                     obj.y = all_locations_in_house(index,2);                    
                 end
                 obj.in_hiding_place = house.is_hiding_place(obj.x,obj.y);
                 [obj, sticky_pads] = check_if_on_sticky_pad(obj, sticky_pads);
             end
        end
                 
        function obj = grow(obj)
            obj.age = obj.age + 1;
        end
        
        function [obj,food_lattice] = consume(obj,food_lattice)
            % bug must eat on average once a day, or it will eventually die
            obj.hunger = obj.hunger + 1; % no food for one day -> hunger += 144;1 week,1008;2 weeks, 2016,;1 month 4320
            food_locations_in_house = food_lattice.food_locations;
            for i = 1:size(food_locations_in_house,1)
                if (obj.x == food_locations_in_house(i,1)&&obj.y==food_locations_in_house(i,2))
                    obj.hunger = max(0,obj.hunger-144); % eat once is enough for one day?
                    food_lattice = food_lattice.remove_quantity_of_food(food_locations_in_house(i,:),1);
                    break;
                end
            end
        end
        
        function egg = lay_eggs(obj, quantity)
            egg = Egg(obj.x,obj.y,quantity);
        end
        
        function [death_standard,death_hunger] = update_death(obj)
            if obj.age >= obj.adult_age && obj.age <= obj.death_age
                death_hunger = 4320;
            elseif obj.age < obj.adult_age
                death_hunger = 1008 + 3312 * obj.age / obj.adult_age;
            end
            if obj.age >= obj.death_age || obj.hunger >= death_hunger
                death_standard = 1;
            else
                death_standard = 0;
            end         
        end
    end
    
    methods(Static)
        function [bug_list,egg_list,food_lattice, sticky_pads] = update_bugs(bug_list, egg_list, room_list,         ...
                human_list, reproduction_interval, reproduction_hunger, minEggs, maxEggs, hungry_move_threshold,    ...
                environment, house, food_lattice, sticky_pads, move_out_of_hiding_probability,                      ...
                move_randomly_at_day_probability, move_randomly_at_night_probability,change_room_probability,       ...
                change_rooms_if_no_food_probability, move_out_of_hiding_probability_if_human_in_room)
    
            bugs_to_kill_indices = [];
            for bug_index = 1:length(bug_list)
                bug = bug_list(bug_index);                
                [death_standard,death_hunger] = update_death(bug);
                if death_standard == 1
                    bugs_to_kill_indices = [bugs_to_kill_indices, bug_index];
                elseif death_standard == 0
                    if bug.hunger >= (death_hunger - hungry_move_threshold)
                        [bug, sticky_pads] = bug.hungry_move(house,sticky_pads,food_lattice);
                    elseif (environment.night && rand < move_randomly_at_night_probability) || ...
                            (~environment.night && rand < move_randomly_at_day_probability)
                        [bug, sticky_pads] = bug.random_move(house,room_list,sticky_pads,change_room_probability);
                    else
                        [bug, sticky_pads] = bug.regular_move(house, room_list, food_lattice, human_list, sticky_pads, ...
                            move_out_of_hiding_probability, change_room_probability, change_rooms_if_no_food_probability, ...
                            move_out_of_hiding_probability_if_human_in_room);  
                    end
                    [bug,food_lattice] = bug.consume(food_lattice);
                    bug = bug.grow();
                    
                    if bug.age == bug.reproduction_age
                        if bug.in_hiding_place && bug.hunger < reproduction_hunger
                            numberOfEggs = randi([minEggs,maxEggs],1);
                            egg = bug.lay_eggs(numberOfEggs);
                            egg_list = [egg_list,egg];
                            bug.reproduction_age = bug.age + reproduction_interval;
                        else
                            bug.reproduction_age = bug.reproduction_age + 1;
                        end
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
            cmap = colormap(summer(200));
            for i = 1:n_bugs
                bug = bug_list(i);
                X(i) = bug.x;
                Y(i) = bug.y;
                color(i,:) = cmap(fix(bug.age/144) + 1,:);
            end
            p = scatter(X,Y,marker_size,color,marker_type);
        end
    end
end
