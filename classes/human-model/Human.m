classdef Human
    %HUMAN Summary of this class goes here
    %   room        - the room that the human is currently in
    %   sleeping    - boolean that says whether the human is sleeping
    
    
    properties
        room
        sleeping
    end
    
    methods
        function obj = Human(room)
            obj.room = room;
        end
                
        function obj = change_room(obj, room)
            obj.room = room;
        end
        
        function [food_lattice] = clean(obj, food_lattice)
            food_lattice = food_lattice.clean_area(obj.room.room_start_house, obj.room.room_stop_house);           
        end
        
        function food_lattice = litter(obj, food_lattice, quantity, numberOfLocations)
            food_lattice = food_lattice.add_food_area(obj.room.room_start_house, obj.room.room_stop_house, quantity, numberOfLocations);    
        end
    end
    
    methods(Static)
        
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

