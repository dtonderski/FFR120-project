clear all
clc
addpath('classes/bug-model')
<<<<<<< Updated upstream
addpath('classes/house-model')
AREA_SIZE = 10;
=======
addpath('classes/food-model')
addpath('classes/bug-control-model')
addpath('classes/enviroment-model')

clear

room_list = Room.create_deafult_room_list();

house = House.create_default_house(room_list);

human1 = Human(house.find_room("Living area"),"Bedroom 1");
human2 = Human(house.find_room("Kitchen"),"Bedroom 2");

human_list = [human1, human2];

bug1 = Bug(20, 30, house);
bug2 = Bug(35, 40, house);
bug1.age = randi([1,bug1.death_age],1);
bug2.age = randi([1,bug2.death_age],1);
% bug1.age = bug1.reproduction_age - 1;
% bug2.age = bug2.death_age - 10;
bug_list = [bug1,bug2];
>>>>>>> Stashed changes

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

<<<<<<< Updated upstream
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

=======
food_lattice = Food_lattice(house);

time_constant = 6; % time steps in one hour
environment = Environment(house, time_constant); 

reproduction_hunger = 201.6;  % no food for continuous 2 weeks, cannot repro    duce
minEggs = 30;
maxEggs = 120;
reproduction_interval = 4320; % 30 days
hatch_probability = 0.5;
hungry_move_threshold = 0.6;
move_out_of_hiding_probability = 0.2;
move_out_of_hiding_probability_if_human_in_room = 0.001;
move_randomly_at_day_probability = 0.01;
move_randomly_at_night_probability = 1;
change_room_probability = 0.01;
change_rooms_if_no_food_probability = 1;
time_steps = 1000;
>>>>>>> Stashed changes

while (time <= numberOfTime)

<<<<<<< Updated upstream
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
=======
for t = 1:time_steps
    tic
    [environment] = Environment.update_environment(environment);
    
    [bug_list, egg_list, food_lattice, sticky_pads] = Bug.update_bugs(bug_list, egg_list, room_list,                ...
                human_list, reproduction_interval, reproduction_hunger, minEggs, maxEggs, hungry_move_threshold,    ...
                environment, house, food_lattice, sticky_pads, move_out_of_hiding_probability,                      ...
                move_randomly_at_day_probability, move_randomly_at_night_probability,change_room_probability,       ...
                change_rooms_if_no_food_probability, move_out_of_hiding_probability_if_human_in_room);
    
    [egg_list, bug_list] = Egg.update_eggs(egg_list,bug_list,hatch_probability,house);
    
    [human_list, food_lattice] = Human.update_humans(human_list, house, environment, food_lattice, room_list);
    toc
    [p1, p2, p3, p4, p5] = update_plot(human_list, food_lattice, bug_list, egg_list, sticky_pads, p1, p2, p3, p4, p5);
    
    title(sprintf('$t = %d, n_{bugs} = %d$, night = %d, weekend = %d', t, length(bug_list), environment.determine_night().night, environment.determine_weekend().weekend), 'interpreter', 'latex');
    if length(bug_list) < 1 && length(egg_list) < 1
            break
>>>>>>> Stashed changes
    end
    
    time = time + 1;
end
