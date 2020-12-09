classdef Human
    %HUMAN Summary of this class goes here
    %   room        - the room that the human is currently in
    %   sleeping    - boolean that says whether the human is sleeping
    
    
    properties
        room
        activity
        time_active
        random_activity

        bedroom_name
        sleeping
    end
    
    methods
        function obj = Human(room, bed_OneOrTwo)
            obj.room = room;
            obj.activity = false;
            obj.time_active = 0;
            obj.random_activity = 0;
            obj.bedroom_name = bed_OneOrTwo;
            obj.sleeping = false;
        end
                
        function obj = change_room(obj, room)
            obj.room = room;
        end
        
        function obj= active(obj,condition)
            obj.activity = condition;
        end

        function food_lattice = clean(obj, food_lattice)
            food_lattice = food_lattice.clean_area(obj.room.room_start_house, obj.room.room_stop_house);
        end
        
        function food_lattice = litter(obj, food_lattice, quantity, numberOfLocations)
            food_lattice = food_lattice.add_food_area(obj.room.room_start_house, obj.room.room_stop_house, quantity, numberOfLocations);      
        end
    end
    
    methods(Static)
    
        function [human_list, food_lattice] = update_humans(human_list, house, environment, food_lattice, room_list)
            
                
            for human_index = 1:length(human_list)
                human = human_list(human_index);
%               
                if environment.weekend == false
                    
                    if environment.time_step_current_day <= 8*environment.time_constant
                        
                        if ~isequal(human.room.room_name, human.bedroom_name)
                        human = human.change_room(house.find_room(human.bedroom_name));
                        human.sleeping = true;
                        end
                        
                    end
                
                    if environment.time_step_current_day <= 9*environment.time_constant && environment.time_step_current_day > 8*environment.time_constant
                        human.sleeping = false;      
                        % go eat 
                        human = human.change_room(house.find_room("Kitchen")); 
                        if rand < 0.2 % probability of leaving crumbs/food
                            food_lattice = human.litter(food_lattice, 100, 1);
                        end

                    end 

                    if environment.time_step_current_day <= 17*environment.time_constant && environment.time_step_current_day > 9*environment.time_constant
                        human = human.change_room(house.find_room("Out"));
                    end

                    %%% ACTIVITY PART %%%
                    if environment.time_step_current_day <= 24*environment.time_constant && environment.time_step_current_day > 17*environment.time_constant         
                        if human.activity == false
                            human.random_activity = rand;
                        end 
                        
                        % just add more if you want to 
                        if human.time_active < 1*environment.time_constant && (human.random_activity < 0.1)
                        human = human.active(true);
                        human = human.change_room(house.find_room("Toilet"));
                        human.time_active = human.time_active +1; 
                        
                        elseif human.time_active < 2*environment.time_constant && (human.random_activity > 0.1 && human.random_activity < 0.3)
                        human = human.active(true);
                        human = human.change_room(house.find_room("Out"));
                        human.time_active = human.time_active +1; 
                       
                        elseif human.time_active < 3*environment.time_constant && (human.random_activity > 0.3 && human.random_activity < 0.5)
                        human = human.active(true);
                        human = human.change_room(house.find_room("Living area"));
                        human.time_active = human.time_active +1; 
                            if rand < 0.3 % probability of leaving crumbs/food
                                food_lattice = human.litter(food_lattice, 100, 1);
                            end
                        
                        elseif human.time_active < 2*environment.time_constant && (human.random_activity > 0.5 && human.random_activity < 0.8)
                        human = human.active(true);
                        human = human.change_room(house.find_room("Kitchen"));
                        human.time_active = human.time_active +1; 
                            if rand < 0.1 % probability of leaving crumbs/food
                                food_lattice = human.litter(food_lattice, 100, 1);
                            end
                        
%%%%%%%%%%%%%%%%%%%%%%%% %%% Cleaning a random room %%%

                        elseif human.time_active < 1*environment.time_constant && (human.random_activity > 0.8)
                            
                        clean_random = ceil(rand*length(room_list)); % randomize the room to clean
                        clean_room = room_list(clean_random).room_name;
                        human = human.change_room(house.find_room(clean_room));
                        food_lattice = human.clean(food_lattice);
                        human.time_active = human.time_active +1; 
                        
%%%%%%%%%%%%%%%%%%%%%%%% %%%
                        else % break when done with activity
                            human = human.active(false);
                            human = human.change_room(house.find_room("Hallway"));
                            human.time_active = 0;
                        
                        end
                    else
                        human = human.active(false);
                        human.time_active = 0;    
                    end


                % behaviour during the weekend    
                % assumptions : 
                % NO CLEANING DURING WEEKEND
                % Sleep a little longer
                % instead of work have an activity
                
                else %(enviroment.weekend == true)

                    if environment.time_step_current_day <= 9*environment.time_constant
                        
                        if human.room.room_name ~= human.bedroom_name
                        human = human.change_room(house.find_room(human.bedroom_name));
                        human.sleeping = true;
                        end
                        
                    end
                    


                    if environment.time_step_current_day <= 10*environment.time_constant && environment.time_step_current_day > 9*environment.time_constant
                        human = human.change_room(house.find_room("Kitchen"));    
                        if rand < 0.1 % probability of leaving crumbs/food
                            food_lattice = human.litter(food_lattice, 100, 1);
                        end
                    end
                    
                    %%% ACTIVITY PART %%%
                    if environment.time_step_current_day <= 24*environment.time_constant && environment.time_step_current_day > 10*environment.time_constant         
                        if human.activity == false
                            human.random_activity = rand;
                        end 
                        
                         % just add more if you want to 
                        if human.time_active < 1*environment.time_constant && (human.random_activity < 0.1)
                        human = human.active(true);
                        human = human.change_room(house.find_room("Toilet"));
                        human.time_active = human.time_active +1; 
                        
                        elseif human.time_active < 5*environment.time_constant && (human.random_activity > 0.1 && human.random_activity < 0.5)
                        human = human.active(true);
                        human = human.change_room(house.find_room("Out"));
                        human.time_active = human.time_active +1; 
                       
                        elseif human.time_active < 3*environment.time_constant && (human.random_activity > 0.5 && human.random_activity < 0.8)
                        human = human.active(true);
                        human = human.change_room(house.find_room("Living area"));
                        human.time_active = human.time_active +1; 
                            if rand < 0.2 % probability of leaving crumbs/food
                                food_lattice = human.litter(food_lattice, 100, 1);
                            end
                        
                        elseif human.time_active < 2*environment.time_constant && (human.random_activity > 0.8)
                        human = human.active(true);
                        human = human.change_room(house.find_room("Kitchen"));
                        human.time_active = human.time_active +1; 
                            if rand < 0.2 % probability of leaving crumbs/food
                                food_lattice = human.litter(food_lattice, 100, 1);
                            end
                        
                        else % break when done with activity
                            human = human.active(false);
                            human = human.change_room(house.find_room("Hallway"));
                            human.time_active = 0;
                    
                        end
                    else
                        human = human.active(false);
                        human.time_active = 0;
                    end
                    
                end
                
                human_list(human_index) = human;
            end 

        end
        
  
        function p = show_humans(human_list, marker_type, marker_size, color)
            n_humans = length(human_list);
            X = zeros(1, n_humans);
            Y = zeros(1, n_humans);
            for i = 1:n_humans
                room_center = (human_list(i).room.room_stop_house + human_list(i).room.room_start_house)/2;
                X(i) = room_center(1);
                Y(i) = room_center(2);
            end
            p = scatter(X,Y,marker_size,marker_type,color);
        end
    end
end

