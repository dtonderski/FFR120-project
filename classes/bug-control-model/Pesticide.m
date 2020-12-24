classdef Pesticide
    
    properties
        room
        human
        lattice
    end
    
    methods
        function obj = Pesticide(house)
            obj.lattice = zeros(size(house.lattice_with_rooms));
        end
        
        function obj = spray_pesticide_in_room(obj, room, human, cover_probability)
            obj.room = room;
            obj.human = human;
            %room_in_house = house.find_room(obj.room.room_name);
            for x = room.room_start_house(1):room.room_stop_house(1)
                for y = room.room_start_house(2):room.room_stop_house(2)
                    x_room = x - room.room_start_house(1) + 1;
                    y_room = y - room.room_start_house(2) + 1;
                    if room.lattice_with_furniture(x_room,y_room) == -1
                        if rand < cover_probability
                            obj.lattice(x,y) = 1;
                        end
                    elseif room.lattice_with_furniture(x_room,y_room) == 0
                        obj.lattice(x,y) = 1;
                    end
                end
            end
        end
        
        function obj = remove_pesticide(obj,house)
            obj.lattice = zeros(size(house.lattice_with_rooms));
        end
        
        function p = show_pesticide(obj, markerType, markerSize, color)
            [X,Y] = find(obj.lattice);
            p = scatter(X,Y, markerSize, markerType, color);
        end
        
    end
    
end