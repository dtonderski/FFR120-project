classdef Egg
    %EGG Summary of this class goes here
    
    
    properties
        quantity {mustBeNumeric}
        age {mustBeNumeric}
        egg_location
    end
    
    methods
        function obj = Egg(x,y,quantity)
            obj.quantity = quantity;
            obj.egg_location = [x,y];
            obj.age = 1;
        end
        
        function obj = hatch(obj)
            if obj.quantity > 0
                obj.age = obj.age + 1;
            end
        end
        
        function obj = remove_quantity_of_eggs(obj,remove_quantity)
            remove_all = 0;
            current_quantity = obj.quantity;
            obj.quantity = max(0,current_quantity - remove_quantity);
        end
            
    end
        
        methods(Static)       
            function [egg_list, bug_list] = update_eggs(egg_list,bug_list,hatch_age,hatch_probability,house)
                egg_to_remove_indices = [];
                for egg_index = 1:length(egg_list)
                    bug_egg = egg_list(egg_index);
                    bug_egg = bug_egg.hatch();
                    if bug_egg.age == hatch_age
                        egg_quantity = bug_egg.quantity;
                        hatch_number = fix(egg_quantity*hatch_probability);
                        for hatch_index = 1:hatch_number
                            bug_list = [bug_list, Bug(bug_egg.egg_location(1), bug_egg.egg_location(2), house)];
                        end
                        bug_egg = bug_egg.remove_quantity_of_eggs(egg_quantity);
                    end
                    if bug_egg.quantity <= 0
                        egg_to_remove_indices = [egg_to_remove_indices, egg_index];
                    end                    
                    egg_list(egg_index) = bug_egg;
                end
                
                egg_list(egg_to_remove_indices) = [];
            end
            
            
            function p = show_eggs(egg_list, marker_type, marker_size)
                n_eggs = length(egg_list);
                X = zeros(1, n_eggs);
                Y = zeros(1, n_eggs);
                cmap = colormap(bone(51));
                color(1,:) = [1 1 1];
                for i = 1:n_eggs
                    egg = egg_list(i);
                    X(i) = egg.egg_location(1);
                    Y(i) = egg.egg_location(2);
                    color(i,:) = cmap(egg.age+1,:);
                end
                
                p = scatter(X,Y,marker_size,color,marker_type);
            end
        end
end