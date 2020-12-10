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
        function obj = Bug(x,y, house, time_constant)
            obj.x = x;
            obj.y = y;
            obj.age = 0;
            obj.hunger = 0;
            obj.in_hiding_place = house.is_hiding_place(x,y);
            obj.on_sticky_pad = 0;
            obj.room = house.room_list(house.lattice_with_rooms(obj.x,obj.y));
            obj.death_age = randi([100*24*time_constant,200*24*time_constant],1); %100-200 days; timestep = 10 min
            obj.adult_age = randi([40*24*time_constant,80*24*time_constant],1);% 40-80 days
            obj.reproduction_age = obj.adult_age + 7*24*time_constant; % can reproduce after being an adult for 1 week
        end
        
        function obj = change_room_to_random_different(obj, room_list, human_list)
            n_rooms = length(room_list)-1;
            all_rooms(n_rooms) = {''};
            for i_room = 1:n_rooms
                all_rooms(i_room) = {room_list(i_room).room_name};
            end
            
            n_humans = length(human_list);
            busy_rooms(n_humans+1) = {''};
            for i_human = 1:n_humans
                busy_rooms(i_human) = {human_list(i_human).room.room_name};
            end
            busy_rooms(n_humans+1) = {obj.room.room_name};
            available_rooms = setdiff(all_rooms, busy_rooms);
            
            new_room_index = randi(length(available_rooms));
            obj.room = room_list(new_room_index);
        end
        
        function obj = move_randomly_within_room(obj)
            room_start = obj.room.room_start_house;
            room_stop = obj.room.room_stop_house;

            obj.x = room_start(1) + fix(rand * (room_stop(1) - room_start(1)+1));
            obj.y = room_start(2) + fix(rand * (room_stop(2) - room_start(2)+1));
        end
        
        function [obj, sticky_pads] = check_if_on_sticky_pad(obj, sticky_pads)
            if sticky_pads.lattice(obj.x,obj.y) > 0 
                obj.on_sticky_pad = true;
                sticky_pads = sticky_pads.add_bug_to_sticky_pad([obj.x, obj.y]);
            end
        end
        
        function [obj,sticky_pads] = random_move(obj,house,room_list, human_list,sticky_pads,change_room_probability)
            
            if obj.on_sticky_pad
                return
            end
            if rand < change_room_probability 
                obj = change_room_to_random_different(obj, room_list, human_list);
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
                obj = change_room_to_random_different(obj, room_list, human_list);
                obj = move_randomly_within_room(obj);
                [obj, sticky_pads] = check_if_on_sticky_pad(obj, sticky_pads);
                obj.in_hiding_place = house.is_hiding_place(obj.x,obj.y);
            elseif obj.in_hiding_place
                for human = human_list
                    if isequal(human.room.room_name, obj.room.room_name) && ~human.sleeping
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
                        obj = change_room_to_random_different(obj, room_list, human_list);
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
                            obj = change_room_to_random_different(obj, room_list, human_list);
                            obj = move_randomly_within_room(obj);
                            [obj, sticky_pads] = check_if_on_sticky_pad(obj, sticky_pads);
                            obj.in_hiding_place = house.is_hiding_place(obj.x,obj.y);
                        else
                            [obj,sticky_pads] = random_move(obj,house,room_list,human_list,sticky_pads,change_room_probability);
                        end
                    else
                        [obj,sticky_pads] = random_move(obj,house,room_list,human_list,sticky_pads,change_room_probability);
                    end
                end
            end
        end
        
        function [obj, sticky_pads] = hungry_move(obj,house,room_list,human_list, sticky_pads,food_lattice)
            % this function works if the bug is very hungry. if food/sticky pad in
            % current room, must move to the food/sticky pad; else move to a random
            % room
             if obj.on_sticky_pad
                return
             else
                 food_locations_in_room = house.get_food_locations_in_current_room(obj.x, obj.y, food_lattice);
                 free_sticky_pad_locations_in_room = house.get_free_sticky_pad_locations_in_current_room(obj.x, obj.y, sticky_pads);
                 all_locations_in_room = [free_sticky_pad_locations_in_room;food_locations_in_room];
                 if ~isempty(all_locations_in_room)
                     new_location_index = randi([1, size(all_locations_in_room, 1)]);
                     obj.x = all_locations_in_room(new_location_index, 1);
                     obj.y = all_locations_in_room(new_location_index, 2);
                     
                 else
                     obj = change_room_to_random_different(obj, room_list, human_list);
                     obj = move_randomly_within_room(obj);
                 end
                 obj.in_hiding_place = house.is_hiding_place(obj.x,obj.y);
                 [obj, sticky_pads] = check_if_on_sticky_pad(obj, sticky_pads);
             end
        end
                 
        function obj = grow(obj)
            obj.age = obj.age + 1;
        end
        
        function [obj,food_lattice] = consume(obj,food_lattice,time_constant)
            % bug must eat on average once a day, or it will eventually die
            obj.hunger = obj.hunger + 1; % no food for one day -> hunger += 144;1 week,1008;2 weeks, 2016,;1 month 4320
            food_locations_in_house = food_lattice.food_locations;
            for i = 1:size(food_locations_in_house,1)
                if (obj.x == food_locations_in_house(i,1)&&obj.y==food_locations_in_house(i,2))
                    obj.hunger = max(0,(obj.hunger - 24 * time_constant)); % eat once is enough for one day?
                    food_lattice = food_lattice.remove_quantity_of_food(food_locations_in_house(i,:),1);
                    break;
                end
            end
        end
        
        function egg = lay_eggs(obj, quantity,time_constant)
            egg = Egg(obj.x,obj.y,quantity,time_constant);
        end
        
        function [death_standard,death_hunger, human_list] = update_death(obj, ...
                human_list, notice_probability, kill_if_noticed_probability,   ...
                environment)
            time_constant = environment.time_constant;
                
            if obj.age >= obj.adult_age && obj.age <= obj.death_age
                death_hunger = 30 * 24 * time_constant;
            elseif obj.age < obj.adult_age
                death_hunger = 7 * 24 * time_constant + 23 * 24 * time_constant * obj.age / obj.adult_age;
            end
            if obj.age >= obj.death_age || obj.hunger >= death_hunger
                death_standard = 1;
            else
                death_standard = 0;
                for i_human = 1:length(human_list)
                    human = human_list(i_human);
                    if isequal(obj.room.room_name, human.room.room_name) && ~obj.in_hiding_place && ~human.sleeping     
                        fprintf('Bug is in room %s at the same time as human!\n', obj.room.room_name)
                        %pause()
                        if rand < notice_probability
                            % human.noticed_bug = 1;
                            if rand < kill_if_noticed_probability
                                fprintf('Bug is kil in room %s.\n', obj.room.room_name)
                                death_standard = 1;
                            end
                        end
                    end
                    %human_list(i_human) = human;
                end
            end         
        end
    end
    
    methods(Static)
        function [bug_list, egg_list, food_lattice, sticky_pads, killed_bugs] = update_bugs(bug_list, egg_list,     ...
                room_list, human_list, reproduction_interval, reproduction_hunger, minEggs, maxEggs,                ...
                hungry_move_threshold, environment, house, food_lattice, sticky_pads,                               ...
                max_moving_probability, notice_probability, kill_if_noticed_probability)
            
            bugs_to_kill_indices = [];
            for bug_index = 1:length(bug_list)
                bug = bug_list(bug_index);
                
                [death_standard,death_hunger, human_list] = bug.update_death(  ...
                    human_list, notice_probability, kill_if_noticed_probability,   ...
                    environment);
                
                if death_standard == 1
                    bugs_to_kill_indices = [bugs_to_kill_indices, bug_index];
                elseif death_standard == 0
                    if bug.hunger >= (death_hunger - hungry_move_threshold)
                        [bug, sticky_pads] = bug.hungry_move(house,room_list,human_list, sticky_pads,food_lattice);
                    else
                        if environment.night
                            moving_probability = 10 .* max_moving_probability .* bug.hunger ./ death_hunger;
                        elseif ~environment.night
                            moving_probability = max_moving_probability .* bug.hunger ./ death_hunger;
                        end
                        move_out_of_hiding_probability = moving_probability(1);
                        move_out_of_hiding_probability_if_human_in_room = moving_probability(2);
                        change_room_probability = moving_probability(3);
                        change_rooms_if_no_food_probability = moving_probability(4);
                        [bug, sticky_pads] = bug.regular_move(house, room_list, food_lattice, human_list, sticky_pads, ...
                            move_out_of_hiding_probability, change_room_probability, change_rooms_if_no_food_probability, ...
                            move_out_of_hiding_probability_if_human_in_room);
                    end
                    [bug,food_lattice] = bug.consume(food_lattice,environment.time_constant);
                    bug = bug.grow();
                    
                    if bug.age == bug.reproduction_age
                        if bug.in_hiding_place && bug.hunger < reproduction_hunger
                            numberOfEggs = randi([minEggs,maxEggs],1);
                            egg = bug.lay_eggs(numberOfEggs,environment.time_constant);
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
            killed_bugs = bugs_to_kill_indices;
        end
        
        function p = show_bugs(bug_list, marker_type, marker_size,time_constant)
            n_bugs = length(bug_list);
            X = zeros(1, n_bugs);
            Y = zeros(1, n_bugs);
            color(1,:) = [1 1 1];
            cmap = colormap(summer(200));
            for i = 1:n_bugs
                bug = bug_list(i);
                X(i) = bug.x;
                Y(i) = bug.y;
                color(i,:) = cmap(fix(bug.age/24/time_constant) + 1,:);
            end
            p = scatter(X,Y,marker_size,color,marker_type);
        end
    end
end
