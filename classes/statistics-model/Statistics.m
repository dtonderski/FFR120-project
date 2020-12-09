classdef Statistics
    %STATISTICS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        heatmap_data;
        n_bug_data;
        alive_bugs;
        next_bug_index;
    end
    
    methods
        function obj = Statistics(bug_list, time_steps, house)
            n_bugs = length(bug_list);          
            
            obj.n_bug_data = zeros(1, time_steps+1);
            obj.n_bug_data(1) = n_bugs;
            
            obj.heatmap_data = zeros(house.x_size, house.y_size);
            for i_bug = obj.alive_bugs
                bug = bug_list(i_bug);
                obj.heatmap_data(bug.x, bug.y) = obj.heatmap_data(bug.x, bug.y) + 1;
            end
        end
        
        function obj = update_statistics(obj, bug_list, t)
            obj.n_bug_data(t+1) = length(bug_list);
            for bug = bug_list
                obj.heatmap_data(bug.x, bug.y) = obj.heatmap_data(bug.x, bug.y) + 1;  
            end
        end
        
        
        function show_heatmap(obj)
            clf
            x = size(obj.heatmap_data,1);
            y = size(obj.heatmap_data,2);            
            show_heatmap_data = flipud(obj.heatmap_data');
            map=colormap(heatmap(show_heatmap_data)); 
            map(1,:)=1;
            
            heatmap(1:x, y:-1:1,flipud(obj.heatmap_data'), 'GridVisible', 'off', 'Colormap', map);
        end
        
    end
end

