classdef Lattice
    %LATTICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        hidden_lattice;
        traversable_lattice;
        room_lattice;
        rooms;
    end
    
    methods
        function obj = Lattice(varargin)
            %LATTICE Construct an instance of this class
            %   Detailed explanation goes here
            if nargin==2
                x_dim = varargin{1};
                y_dim = varargin{2};
                obj.hidden_lattice = zeros(x_dim, y_dim);
                obj.traversable_lattice = ones(x_dim, y_dim);
                obj.room_lattice = zeros(x_dim, y_dim);
                obj.rooms = '';
            end
        end
    end
end

