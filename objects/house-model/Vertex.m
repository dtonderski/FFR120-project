classdef Vertex
    %VERTEX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        hidden;
        traversable;
        room;
    end
    
    methods
        function obj = Vertex(varargin)
            %VERTEX Construct an instance of this class
            %   Detailed explanation goes here

            if nargin>2
                obj.hidden = varargin{1};
                obj.traversable = varargin{2};
                obj.room = varargin{3};
            else
                obj.hidden = false;
                obj.traversable = true;
            end

        end
    end
end

