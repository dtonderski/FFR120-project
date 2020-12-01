classdef Human
    %HUMAN Summary of this class goes here
    %   room        - the room that the human is currently in
    %   sleeping    - boolean that says whether the human is sleeping
    
    
    properties
        room
        sleeping
        cycle
        day
    end
    
    methods
        function obj = Human(room)
            obj.room = room;
            obj.cycle = 0;
            obj.day = 0;
        end
                
        function obj = change_room(obj, room)
            obj.room = room;
        end
        
        function obj = time(obj)    
            obj.cycle = obj.cycle + 1;
        end
        
        function obj = increase_day(obj)
            obj.day = obj.day +1;
        end
        

        function [food_lattice] = clean(obj, food_lattice)
            % works fine
            food_lattice = food_lattice.clean_area(obj.room.room_start_house, obj.room.room_stop_house);
        end
        
        function food_lattice = litter(obj, food_lattice, quantity, numberOfLocations)
            food_lattice = food_lattice.add_food_area(obj.room.room_start_house, obj.room.room_stop_house, quantity, numberOfLocations);      
        end
    end
    
    methods(Static)
%         
        function [human_list, food_lattice] = update_humans(human_list, bedroom1, kitchen, livingarea, hallway, food_lattice, breakfast_probability)
            
            for human_index = 1:length(human_list)
                human = human_list(human_index);
                human = human.time();
                
                if human.cycle <= 8 % divide with something appropriate to create a day cycle 
                      if human.room.room_name ~= "Bedroom 1"
                          human = human.change_room(bedroom1);
                      end
                end
                
                if human.cycle <= 9 && human.cycle > 8
                    human = human.change_room(kitchen);    
                    food_lattice = human.litter(food_lattice, 100, 4);
                end 
              
                if human.cycle <= 17 && human.cycle > 9
                    human = human.change_room(hallway);
                end
                
                if human.cycle <= 24 && human.cycle > 17
                    human = human.change_room(livingarea);
                    % generating food in the living area
                    r = rand;
                    if r <= 0.95
                        food_lattice = human.litter(food_lattice, 100, 4);
                    end 
                    % probability of cleaning it up
                    clean_r = rand;
                    if clean_r <= 0.9
                    food_lattice = human.clean(food_lattice);
                    end
                end
                
                if human.cycle/24 == 1
                    human = human.increase_day();
                    human.cycle = 0;
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

