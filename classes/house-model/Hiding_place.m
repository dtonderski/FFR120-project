classdef Hiding_place
    %HIDING_PLACE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        hiding_place_start_room
        hiding_place_stop_room
    end
    
    methods
        function obj = Hiding_place(inputArg1,inputArg2)
            %HIDING_PLACE Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

