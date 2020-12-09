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
            obj.alive_bugs = 1:n_bugs;
            
            obj.n_bug_data = zeros(1, time_steps);
            obj.n_bug_data(1) = n_bugs;
            
            obj.heatmap_data = zeros(house.x_size, house.y_size, n_bugs);
            for i_bug = obj.alive_bugs
                bug = bug_list(i_bug);
                obj.heatmap_data(bug.x, bug.y, i_bug) = obj.heatmap_data(bug.x, bug.y) + 1;
            end
            obj.next_bug_index = n_bugs+1;
        end
        
        function obj = update_statistics(obj, bug_list, t, killed_bugs)
            n_bugs = length(bug_list);
            obj.n_bug_data(t+1) = n_bugs;
            
            new_next_bug_index = obj.next_bug_index+length(killed_bugs)+(n_bugs - length(obj.alive_bugs));

            obj.alive_bugs = [obj.alive_bugs, obj.next_bug_index:new_next_bug_index-1];
            obj.next_bug_index = new_next_bug_index;
            obj.alive_bugs(killed_bugs) = [];
            assert(length(obj.alive_bugs) == n_bugs)
            for i_bug = 1:n_bugs
                bug = bug_list(i_bug);
                obj.heatmap_data(bug.x, bug.y, obj.alive_bugs(i_bug)) = obj.heatmap_data(bug.x, bug.y, obj.alive_bugs(i_bug)) + 1;       
                fprintf('Heatmap data for bug %d - %d nonzero.\n', i_bug, length(find(obj.heatmap_data(:,:,i_bug) > 0)))
            end
        end
        
        function show_heatmap(obj, i_bug)
            clf
            x = size(obj.heatmap_data,1);
            y = size(obj.heatmap_data,2);
            heatmap(1:x, y:-1:1,flipud(obj.heatmap_data(:,:,i_bug)'), 'GridVisible', 'off');
        end
    end
end

