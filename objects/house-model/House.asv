classdef House
    %HOUSE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x_dim
        y_dim
        lattice;
    end
    
    methods
        function obj = House(x_dim,y_dim)
            %HOUSE Construct an instance of this class
            %   Detailed explanation goes here
            obj.x_dim = x_dim;
            obj.y_dim = y_dim;
            obj.lattice = initialize_lattice(obj);
        end        
        
        function lattice = initialize_lattice(obj)
            lattice(obj.x_dim, obj.y_dim) = Vertex();
        end    
        
        function vertex = get_vertex(obj, x_coordinate, y_coordinate)
            vertex = obj.lattice(x_coordinate, y_coordinate);
        end
    end
end

