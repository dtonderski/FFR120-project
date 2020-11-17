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
            obj.lattice = Lattice(x_dim, y_dim);
        end
        
        function hidden = get_hidden(obj, x, y)
            hidden = obj.lattice.hidden_lattice(x,y);
        end
        
        function traversable = get_traversable(obj, x, y)
            traversable = obj.lattice.traversable_lattice(x,y);
            if x > 128 || x < 1 || y > 128 || y < 1
                traversable = 0;
            end
        end
        
    end
end

