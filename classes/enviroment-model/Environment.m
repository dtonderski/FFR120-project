classdef Environment
    %ENVIROMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        house
        time_step_current_day
        time_constant
        day
        week
        night
        weekend
        
        % future maybe add more
    end
    
    methods
        function obj = Environment(house, time_constant)
            obj.house = house;
            obj.time_step_current_day = 0;
            obj.time_constant = time_constant;
            obj.day = 1;
            obj.week = 0;
            obj.night = false;
            obj.weekend = false;
        end
        
        
        function obj = increase_time(obj)
            obj.time_step_current_day = obj.time_step_current_day +1;
        end
        
        function obj = increase_day(obj)
            obj.day = obj.day +1;
        end
        
        function obj = increase_week(obj)
            obj.week = obj.week +1;
        end
        
%         % update the day and week
        function obj = update_day(obj)
            if obj.time_step_current_day/(24*obj.time_constant) == 1
                obj = obj.increase_day();
                obj.time_step_current_day = 0;
            end
        end

        function obj = update_week(obj)
            if obj.day/7 == 1
                obj = obj.increase_week();
                obj.day = 1;
            end
        end
        
%         
        function obj = determine_night(obj)

            if obj.time_step_current_day < 8*obj.time_constant
                obj.night = true;
            else
                obj.night = false;
            end
            
        end
        
        function obj = determine_weekend(obj)

            if obj.day/6 == 1 || obj.day/7 == 1 
                obj.weekend = true;
            else
                obj.weekend = false;
            end
        end      
        
        function timeString = get_time_string(obj)
            time = obj.time_step_current_day-1;
            minutes = mod(time, obj.time_constant)*10;
            hours = ((time-minutes/10) / (obj.time_constant));
            timeString = sprintf('%02d:%02d', hours, minutes);
        end
    end
    
    methods(Static)
        
        function environment = update_environment(environment)
            % this might be fucked up idk
            environment = environment.update_day();
            environment = environment.update_week();

            environment = environment.increase_time();
            environment = environment.determine_weekend();
            environment = environment.determine_night();

        end
        
    end
    

        
end

