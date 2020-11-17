clear all
clc
AREA_SIZE = 10;

numberOfSteps = 1000;
numberOfRandomSteps = 50;
currentPositionX = zeros(numberOfSteps,1);
currentPositionY = zeros(numberOfSteps,1);

initialPosition = randi(AREA_SIZE,1,2);
currentPositionX(1) = initialPosition(1);
currentPositionY(1) = initialPosition(2);

bug1 = Bug(currentPositionX(1), currentPositionY(1), AREA_SIZE);
figure();
axis([0.5 AREA_SIZE+0.5 0.5 AREA_SIZE+0.5]);
h = line('XData',[],'YData',[],'color','b','marker','.','markersize',30);
set(h,'XData',bug1.row,'YData',bug1.col);

validStandard = 1;
i = 1;
while (~isempty(validStandard) && i < numberOfSteps)
    if (i <= numberOfRandomSteps)
        bug1 = bug1.move(validStandard);
    else
        validStandard = input('Whether the place is valid or not? ');
        bug1 = bug1.move(validStandard);
    end
    set(h,'XData',bug1.row,'YData',bug1.col);
    drawnow
    pause(0.1)
    i = i+1;
end
