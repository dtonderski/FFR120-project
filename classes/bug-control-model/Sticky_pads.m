classdef Sticky_pads
    %STICKY-PADS Summary of this class goes here
    
    properties
        lattice
        pad_locations
    end
    
    methods
        function obj = Sticky_pads(house)
            obj.lattice = zeros(size(house.lattice_with_rooms));
        end
        
        function obj = add_sticky_pad(obj, location)
            if obj.lattice(location(1), location(2)) ~= 0
                fprintf('x = %d, y = %d already contains a sticky pad!\n', location(1), location(2));
            else
                obj.lattice(location(1), location(2)) = 1;
                obj.pad_locations = [obj.pad_locations; location];
            end
        end
        
        function obj = remove_sticky_pads_area(obj, area_start, area_stop)
            indices_to_remove = [];
            for i_pad_location = 1:size(obj.pad_locations,1)
                pad_location = obj.pad_locations(i_pad_location,:);
                
                if all(pad_location <= area_stop & pad_location >= area_start)
                    obj.lattice(pad_location(1), pad_location(2)) = 0;
                    indices_to_remove = [indices_to_remove, i_food_location];
                end
            end
            obj.pad_locations(indices_to_remove, :) = [];
        end
        
        function obj = remove_sticky_pad(obj, location)
            [bool, index] = ismember(location, obj.pad_locations,'rows');
            if bool
                obj.lattice(location(1), location(2)) = 0;
                obj.pad_locations(index,:) = [];
            else
                fprintf('x = %d, y = %d contains no sticky pad!', location(1), location(2))
            end
        end

        function obj = add_bug_to_sticky_pad(obj, location)
            if ismember(location, obj.pad_locations,'rows')
                obj.lattice(location(1), location(2)) = 2;
            else
                fprintf('x = %d, y = %d contains no sticky pad!', location(1), location(2))
            end
        end
        
        function obj = remove_stuck_bugs_and_sticky_pads_area(obj, area_start, area_stop)
            for i_stuck_bug_location = 1:size(obj.stuck_bug_locations,1)
                stuck_bug_location = obj.stuck_bug_locations(i_stuck_bug_location,:);

                if all(stuck_bug_location <= area_stop & stuck_bug_location >= area_start)
                    obj.lattice(pad_location(1), pad_location(2)) = 0;
                    indices_to_remove = [indices_to_remove, i_food_location];
                    obj = obj.remove_sticky_pad(stuck_bug_location);
                end
            end
            obj.stuck_bug_locations(indices_to_remove, :) = [];

        end
        
        function p = show_pads(obj, markerType, markerSize, color)
            n_locations = size(obj.pad_locations,1);
            X = zeros(n_locations,1);
            Y = zeros(n_locations,1);
            for i_sticky_pad_location = 1:n_locations
                location = obj.pad_locations(i_sticky_pad_location,:);
                X(i_sticky_pad_location) = location(1);
                Y(i_sticky_pad_location) = location(2);
            end
            p = scatter(X,Y, markerSize, markerType, color);
        end
        
        function free_sticky_pad_locations_in_area = get_free_sticky_pad_locations_in_area(obj, area_start, area_stop)
            free_sticky_pad_locations_in_area = [];
            for i_sticky_pad_location = 1:size(obj.pad_locations, 1)
                sticky_pad_location = obj.pad_locations(i_sticky_pad_location,:);
                if all(sticky_pad_location <= area_stop & sticky_pad_location >= area_start) && obj.lattice(sticky_pad_location(1),sticky_pad_location(2)) == 1
                    free_sticky_pad_locations_in_area = [free_sticky_pad_locations_in_area; sticky_pad_location(1), sticky_pad_location(2)];
                end
            end
        end
        
    end
end

