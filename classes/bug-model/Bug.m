classdef Bug
    properties
        row {mustBeNumeric}
        col {mustBeNumeric}
        latticesize {mustBeNumeric}
        latticenum {mustBeNumeric}
        age {mustBeNumeric}


    end
    methods
        function obj = Bug(row,col,lat)
            obj.row = row;
            obj.col = col;
            obj.latticesize = lat;
            obj.latticenum = lat*(row -1)+col;
            obj.age = 0;
        end
        function obj = move(obj,validStandard)
            
            r = rand;
            if (r < validStandard)
                moveDirection = randi(4);
                if moveDirection == 1
                    obj.row = obj.row - 1;
                    obj.col = obj.col;
                elseif moveDirection == 2
                    obj.row = obj.row + 1;
                    obj.col = obj.col;
                elseif moveDirection == 3
                    obj.col = obj.col - 1;
                    obj.row = obj.row;
                elseif moveDirection == 4
                    obj.col = obj.col + 1;
                    obj.row = obj.row;
                else
                    obj.row = obj.row;
                    obj.col = obj.col;
                end
            else
                obj.row = obj.row;
                obj.col = obj.col;
            end
        end

        function obj = grow(obj)
            
            obj.age = obj.age + 1;
        end
        
        function obj = die(obj)
            obj.row = NaN;
            obj.col = NaN;
        end
    end
end
