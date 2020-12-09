addpath('classes/house-model')
addpath('classes/human-model')
addpath('classes/bug-model')
addpath('classes/food-model')
addpath('classes/bug-control-model')
addpath('classes/enviroment-model')
addpath('classes/statistics-model')

clear

room_list = Room.create_deafult_room_list();

house = House.create_default_house(room_list);

human1 = Human(house.find_room("Living area"),1);
human2 = Human(house.find_room("Kitchen"),2);
%human3 = Human(house.find_room("Toilet"));

human_list = [human1, human2]; %, human3];

bug1 = Bug(1, 1, house);
bug2 = Bug(5, 5, house);
bug3 = Bug(2, 2, house);
bug4 = Bug(3, 3, house);
bug1.age = randi([1,bug1.death_age],1);
bug2.age = randi([1,bug2.death_age],1);
bug3.age = randi([1, bug3.death_age],1);
% bug1.age = bug1.reproduction_age - 1;
% bug2.age = bug2.death_age - 10;
bug_list = [bug1,bug2, bug3];

egg = Egg(0,0,0);
egg_list = [egg];

sticky_pads = Sticky_pads(house);
%sticky_pads = sticky_pads.add_sticky_pad([15,15]);

food_lattice = Food_lattice(house);
%food_lattice = human1.litter(food_lattice, 100, 4);

time_constant = 6; % time steps in one hour
environment = Environment(house, time_constant); 
randomActivity = 0;

reproduction_hunger = 201.6;  % no food for continuous 2 weeks, cannot reproduce
minEggs = 30;
maxEggs = 120;
reproduction_interval = 4320; % 30 days
hatch_probability = 0.5;
hungry_move_threshold = 0.6;
move_out_of_hiding_probability = 0.05;
move_out_of_hiding_probability_if_human_in_room = 0;
move_randomly_at_day_probability = 0.01;
move_randomly_at_night_probability = 1;
change_room_probability = 0.01;
change_rooms_if_no_food_probability = 0.05;
notice_probability = 0.5;
kill_if_noticed_probability = 0.2;
time_steps = 10000;

statistics = Statistics(bug_list, time_steps, house);

should_plot = false;

figure(1)
[p1, p2, p3, p4, p5] = show_all(house, human_list, food_lattice, bug_list, egg_list, sticky_pads);

start_time = tic;

for t = 1:time_steps
    tic
    [bug_list, egg_list, food_lattice, sticky_pads, killed_bugs] = Bug.update_bugs(bug_list, egg_list, room_list,   ...
                human_list, reproduction_interval, reproduction_hunger, minEggs, maxEggs, hungry_move_threshold,    ...
                environment, house, food_lattice, sticky_pads, move_out_of_hiding_probability,                      ...
                move_randomly_at_day_probability, move_randomly_at_night_probability,change_room_probability,       ...
                change_rooms_if_no_food_probability, move_out_of_hiding_probability_if_human_in_room,               ...
                notice_probability, kill_if_noticed_probability);
    
    [egg_list, bug_list] = Egg.update_eggs(egg_list,bug_list,hatch_probability,house);
    
    [human_list, food_lattice, environment] = Human.update_humans(human_list, house, environment, food_lattice);
    
    t1 = toc;
    statistics = statistics.update_statistics(bug_list, t, killed_bugs);
    t2 = toc;
    
    if should_plot
        [p1, p2, p3, p4, p5] = update_plot(human_list, food_lattice, bug_list, egg_list, sticky_pads, p1, p2, p3, p4, p5);
        title(get_title(t, bug_list, environment), 'interpreter', 'latex');
        shg;
    end
    if length(bug_list) < 1 && length(egg_list) < 1
        break
    end
    t3 = toc;
    fprintf('t is %d. Iteration time - %.5f. Calculation time - %.5f. Statistics time - %.5f.\n', t, t3, t1, t2-t1)
end
fprintf('Simulation completed. Total time - %.5f. Number of time steps - %d.\n', toc(start_time), t)
figure(3)
clf
[p1, p2, p3, p4, p5] = update_plot(human_list, food_lattice, bug_list, egg_list, sticky_pads, p1, p2, p3, p4, p5);
title(get_title(t, bug_list, environment), 'interpreter', 'latex');
%%
for i = 1:size(statistics.heatmap_data,3)
    figure(i+1)
    statistics.show_heatmap(i)
end

function [p1, p2, p3, p4, p5] = show_all(house, human_list, food_lattice, bug_list, egg_list, sticky_pads)
    clf
    hold on
    house.show_house();
    p1 = Human.show_humans(human_list, 'x', 1000, 'black');
    p2 = food_lattice.show_food('.', 1000, 'blue');
    p5 = sticky_pads.show_pads('.', 1000, 'cyan');
    p3 = Bug.show_bugs(bug_list, '.', 1000);
    p4 = Egg.show_eggs(egg_list,'.',300);
end

function [p1, p2, p3, p4, p5] = update_plot(human_list, food_lattice, bug_list, egg_list, sticky_pads, p1, p2, p3, p4, p5)
    hold on
    delete(p1);
    delete(p2);
    delete(p3);
    delete(p4);
    delete(p5);
    p1 = Human.show_humans(human_list, 'x', 1000, 'black');
    p2 = food_lattice.show_food('.', 1000, 'blue');
    p5 = sticky_pads.show_pads('.', 1000, 'cyan');
    p3 = Bug.show_bugs(bug_list, '.', 1000);
    p4 = Egg.show_eggs(egg_list,'.',300);  
end

function title = get_title(t, bug_list, environment)
    title = sprintf('$t = %d, n_{bugs} = %d$, night = %d', t, length(bug_list), environment.determine_night().night);
end