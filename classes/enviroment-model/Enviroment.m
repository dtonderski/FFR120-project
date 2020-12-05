classdef Enviroment
    %ENVIROMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        house
        time_step
        day
        week
        night
        weekend
        % future maybe add more
    end
    
    methods
        function obj = Enviroment(house)
            obj.house = house;
            obj.time_step = 0;
            obj.day = 1;
            obj.week = 0;
            obj.night = false;
            obj.weekend = false;
        end
        
        
        function obj = increase_time(obj)
            obj.time_step = obj.time_step +1;
        end
        
        function obj = increase_day(obj)
            obj.day = obj.day +1;
        end
        
        function obj = increase_week(obj)
            obj.week = obj.week +1;
        end
        
        function obj = determine_night(obj)

            if obj.time_step < 8
                obj.night = true;
            else
                obj.night = false;
            end
            
        end
        
        function obj = determine_weekend(obj)

            if obj.day/6 == 1 || obj.day/7 == 1 
                obj.weekend = true;
            else
                obj.night = false;
            end
            
        end
            

        
        
    end
end

