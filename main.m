clear all
clc
addpath('classes/bug-model')
addpath('classes/house-model')
AREA_SIZE = 10;

house = House(10,10);
house = house.add_room("Kitchen", [1,1], [3,3]);
house = house.add_room("Hall", [4,1], [6,10]);
%house = house.add_wall([7 1], [7 10]);
house.is_traversable(7,1);


numberOfSteps = 1000;
numberOfRandomSteps = 0;
currentPositionX = zeros(numberOfSteps,1);
currentPositionY = zeros(numberOfSteps,1);

initialPosition = [1,1];
currentPositionX(1) = initialPosition(1);
currentPositionY(1) = initialPosition(2);
%%
bug1 = Bug(currentPositionX(1), currentPositionY(1), AREA_SIZE);
% figure();
% axis([0.5 AREA_SIZE+0.5 0.5 AREA_SIZE+0.5]);
% h = line('XData',[],'YData',[],'color','b','marker','.','markersize',30);
% set(h,'XData',bug1.row,'YData',bug1.col);

validStandard = 1;
i = 1;
while (~isempty(validStandard) && i < numberOfSteps)
    if (i <= numberOfRandomSteps)
        bug1 = bug1.move(validStandard);
    else
        validStandard = house.is_traversable(bug1.row, bug1.col);
        bug1 = bug1.move(validStandard);
    end
%     set(h,'XData',bug1.row,'YData',bug1.col);
%     drawnow
    pause(0.00001)
    clf
    imshow(flipud((house.lattice_with_rooms'+1)/5), 'InitialMagnification', 'fit')
    hold on
    scatter(bug1.row, bug1.col, 'x')
    i = i+1;
end
