clear all
clc
% addpath('classes/bug-model')
% addpath('classes/house-model')
AREA_SIZE = 10;

numberOfBugs = 1;
time = 1;
numberOfTime = 100;
numberOfSteps = 30;
numberOfRandomSteps = 30;
currentPositionX = zeros(numberOfSteps,1);
currentPositionY = zeros(numberOfSteps,1);

initialPosition = randi(AREA_SIZE,1,2);
X = [];
Y = [];

bug(1) = Bug(initialPosition(1), initialPosition(1), AREA_SIZE);
X = [X;bug(1).row];
Y = [Y;bug(1).col];

figure(1)
hold on
plot(X,Y,'.')
axis([0,AREA_SIZE,0,AREA_SIZE])
axis equal square
box on
title(['Simulation step = ' num2str(time)])
xlabel('X')
ylabel('Y')


while (time <= numberOfTime)

    validStandard = 1;    
    numberOfBugs = numel(bug);
    for nBug = 1:numberOfBugs
        validStandard = input('Whether the place is valid or not? ');
        bug(nBug) = bug(nBug).move(validStandard);
        X(nBug) = bug(nBug).row;
        Y(nBug) = bug(nBug).col;
        bug(nBug) = bug(nBug).grow();
        if (bug(nBug).age == 3)
            bug(numberOfBugs+1) = Bug(bug(numberOfBugs).row,bug(numberOfBugs).col,AREA_SIZE);
            X = [X;bug(numberOfBugs+1).row];
            Y = [Y;bug(numberOfBugs+1).col];
        end
        
        if (bug(nBug).age >= 10)
            bug(nBug) = bug(nBug).die;
        end
    end
    
    X = mod(X,AREA_SIZE);
    Y = mod(Y,AREA_SIZE);    
    
    % Plot
    if rem(time,1)==0
        cla
        plot(X,Y,'o','MarkerFaceColor','r')
        title(['Simulation step = ' num2str(time)])
        axis([0,AREA_SIZE,0,AREA_SIZE])
        drawnow update
    end
    
    time = time + 1;
end
