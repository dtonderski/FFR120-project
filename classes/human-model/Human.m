classdef Human
    %HUMAN Summary of this class goes here
    %   room        - the room that the human is currently in
    %   sleeping    - boolean that says whether the human is sleeping
    
    
    properties
        room
        activity
        time_active
        random_activity
    end
    
    methods
        function obj = Human(room)
            obj.room = room;
            obj.activity = false;
            obj.time_active = 0;
            obj.random_activity = 0;
        end
                
        function obj = change_room(obj, room)
            obj.room = room;
        end
        
        function obj= active(obj,condition)
            obj.activity = condition;
        end
        
        
        %%%  Should this be static methods or methods in the enviroment? %%% 
        function time_step = get_time_step(obj, enviroment)
            time_step = enviroment.time_step;
        end
        
        function day = get_day(obj, enviroment)
            day = enviroment.day;
        end
        
        function week = get_week(obj, enviroment)
            week = enviroment.week;
        end
        %%% %%% %%% %%% %%% 
         

        function [food_lattice] = clean(obj, food_lattice)
            % works fine
            food_lattice = food_lattice.clean_area(obj.room.room_start_house, obj.room.room_stop_house);
        end
        
        function food_lattice = litter(obj, food_lattice, quantity, numberOfLocations)
            food_lattice = food_lattice.add_food_area(obj.room.room_start_house, obj.room.room_stop_house, quantity, numberOfLocations);      
        end
    end
    
    methods(Static)
    
        function [human_list, food_lattice, enviroment] = update_humans(human_list, house, enviroment, food_lattice)
            
                enviroment = enviroment.increase_time();
                enviroment = enviroment.determine_weekend();
               
                
            for human_index = 1:length(human_list)
                human = human_list(human_index);
%               
                if enviroment.weekend == false
                    
                    if human.get_time_step(enviroment) <= 8 % divide with something appropriate to create a day cycle 
                          if human.room.room_name ~= "Bedroom 1"
                              human = human.change_room(house.find_room("Bedroom 1"));
                          end
                    end
                
                    if human.get_time_step(enviroment) <= 9 && human.get_time_step(enviroment) > 8
                        human = human.change_room(house.find_room("Kitchen"));    
                        food_lattice = human.litter(food_lattice, 100, 4);
                    end 

                    if human.get_time_step(enviroment) <= 17 && human.get_time_step(enviroment) > 9
                        human = human.change_room(house.find_room("Out"));
                    end

                    %%% ACTIVITY PART %%%
                    if human.get_time_step(enviroment) <= 24 && human.get_time_step(enviroment) > 17         
                        if human.activity == false
                            human.random_activity = rand;
                        end 
                        
                        % just add more if you want to 
                        if human.time_active < 1 && (human.random_activity < 0.1)
                        human = human.active(true);
                        human = human.change_room(house.find_room("Toilet"));
                        human.time_active = human.time_active +1; 
                        
                        elseif human.time_active < 2 && (human.random_activity > 0.1 && human.random_activity < 0.3)
                        human = human.active(true);
                        human = human.change_room(house.find_room("Out"));
                        human.time_active = human.time_active +1; 
                       
                        elseif human.time_active < 3 && (human.random_activity > 0.3 && human.random_activity < 0.5)
                        human = human.active(true);
                        human = human.change_room(house.find_room("Living area"));
                        human.time_active = human.time_active +1; 
                        
                        elseif human.time_active < 2 && (human.random_activity > 0.5 && human.random_activity < 0.8)
                        human = human.active(true);
                        human = human.change_room(house.find_room("Kitchen"));
                        human.time_active = human.time_active +1; 
                        
                        %%% Cleaning a random room %%%
                        elseif human.time_active < 1 && (human.random_activity > 0.8)
                            
                        %clean_random = ceil(rand*length(room.room_list));
                        human = human.change_room(house.find_room("Kitchen"));
                        food_lattice = human.clean(food_lattice);
                        human.time_active = human.time_active +1; 

                        else % break when done with activity
                            human = human.active(false);
                            human = human.change_room(house.find_room("Hallway"));
                            human.time_active = 0;
                        end        
                    end


                % behaviour during the weekend    
                % assumptions : 
                % NO CLEANING DURING WEEKEND
                % Sleep a little longer
                % instead of work have an activity
                
                else %(enviroment.weekend == true)
                    if human.get_time_step(enviroment) <= 9 % * time_constant (add)
                          if human.room.room_name ~= "Bedroom 1"
                              human = human.change_room(house.find_room("Bedroom 1"));
                          end
                    end
                    
                    if human.get_time_step(enviroment) <= 10 && human.get_time_step(enviroment) > 9
                        human = human.change_room(house.find_room("Kitchen"));    
                        food_lattice = human.litter(food_lattice, 100, 4);
                    end
                    
                    %%% ACTIVITY PART %%%
                    if human.get_time_step(enviroment) <= 24 && human.get_time_step(enviroment) > 10         
                        if human.activity == false
                            human.random_activity = rand;
                        end 
                        
                        % just add more if you want to 
                        if human.time_active < 1 && (human.random_activity > 0.3 && human.random_activity < 0.5)
                        human = human.active(true);
                        human = human.change_room(house.find_room("Toilet"));
                        human.time_active = human.time_active +1; 
                        
                        elseif human.time_active < 5 && human.random_activity > 0.5
                        human = human.active(true);
                        human = human.change_room(house.find_room("Out"));
                        human.time_active = human.time_active +1; 

                        
                        elseif human.time_active < 5 && human.random_activity < 0.3
                        human = human.active(true);
                        human = human.change_room(house.find_room("Living area"));
                        human.time_active = human.time_active +1; 
                        

                        else % break when done with activity
                            human = human.active(false);
                            human = human.change_room(house.find_room("Hallway"));
                            human.time_active = 0;
                        end        
                    end
                end
                
                human_list(human_index) = human;
            end 
     
            % update the day and week
            if human.get_day(enviroment)/7 == 1
                enviroment = enviroment.increase_week();
            end

            if human.get_time_step(enviroment)/(24) == 1
                enviroment = enviroment.increase_day();
                enviroment.time_step = 0;
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

