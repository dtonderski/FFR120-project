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

time_constant = 6; % time steps in one hour
environment = Environment(house, time_constant); 

human1 = Human(house.find_room('Living area'), 'Bedroom 1');
human2 = Human(house.find_room('Kitchen'),'Bedroom 2');
%human3 = Human(house.find_room('Toilet'));

human_list = [human1, human2]; %, human3];

bug1 = Bug(2,2, house, time_constant);
bug2 = Bug(3,3, house, time_constant);
bug3 = Bug(4,4, house, time_constant);
bug4 = Bug(5,5, house, time_constant);

bug1.age = randi([1,bug1.death_age],1);
bug2.age = randi([1,bug2.death_age],1);
bug3.age = randi([1, bug3.death_age],1);
bug4.age = randi([1, bug4.death_age],1);
% bug1.age = bug1.adult_age;
% bug2.age = bug2.death_age - 10;
% bug1.hunger = 4315;
bug_list = [bug1,bug2, bug3, bug4];


egg = Egg(0,0,0,time_constant);
egg_list = [egg];

sticky_pads = Sticky_pads(house);
%sticky_pads = sticky_pads.add_sticky_pad([15,15]);

food_lattice = Food_lattice(house);
%food_lattice = human1.litter(food_lattice, 100, 4);

randomActivity = 0;


reproduction_hunger = 14*24*time_constant;  % no food for continuous 2 weeks, cannot reproduce
minEggs = 30;
maxEggs = 120;
reproduction_interval = 30*24*time_constant; % 30 days
hatch_probability = 0.5;
hungry_move_threshold = time_constant;
max_move_out_of_hiding_probability = 0.05;
max_move_out_of_hiding_probability_if_human_in_room = 0;
max_change_room_probability = 0.01;
max_change_rooms_if_no_food_probability = 0.05;
max_moving_probability = [max_move_out_of_hiding_probability, max_move_out_of_hiding_probability_if_human_in_room, max_change_room_probability, max_change_rooms_if_no_food_probability];
notice_probability = 0.5;
kill_if_noticed_probability = 0.2;
time_steps = 20000;
should_plot = false;


statistics = Statistics(bug_list, time_steps, house, time_constant);


figure(1)
[p1, p2, p3, p4, p5] = show_all(house, human_list, food_lattice, bug_list, egg_list, sticky_pads, time_constant);

start_time = tic;


for t = 1:time_steps
    tic
    [environment] = Environment.update_environment(environment);
    [human_list, food_lattice] = Human.update_humans(human_list, house, environment, food_lattice, room_list);
    [bug_list, egg_list, food_lattice, sticky_pads, killed_bugs] = Bug.update_bugs(bug_list, egg_list,     ...
                room_list, human_list, reproduction_interval, reproduction_hunger, minEggs, maxEggs,                ...
                hungry_move_threshold, environment, house, food_lattice, sticky_pads,                               ...
                max_moving_probability, notice_probability, kill_if_noticed_probability);
    
    [egg_list, bug_list] = Egg.update_eggs(egg_list,bug_list,hatch_probability,house,time_constant);
    

    t1 = toc;
    statistics = statistics.update_statistics(bug_list, t, food_lattice, time_constant);
    t2 = toc;
    
    if should_plot
        [p1, p2, p3, p4, p5] = update_plot(human_list, food_lattice, bug_list, egg_list, sticky_pads, p1, p2, p3, p4, p5, time_constant);
        title(get_title(t, bug_list, environment), 'interpreter', 'latex');
        shg;
    end
    if length(bug_list) < 1 && length(egg_list) < 1
        break
    end
    t3 = toc;
    fprintf('t is %d, n_bugs = %d, Iteration time - %.5f. Calculation time - %.5f. Statistics time - %.5f.\n', t, length(bug_list), t3, t1, t2-t1)
end
fprintf('Simulation completed. Total time - %.5f. Number of time steps - %d.\n', toc(start_time), t)

%%
figure
statistics.show_heatmap;

function [p1, p2, p3, p4, p5] = show_all(house, human_list, food_lattice, bug_list, egg_list, sticky_pads ,time_constant)
    clf
    hold on
    house.show_house();
    p1 = Human.show_humans(human_list, 'x', 1000, 'black');
    p2 = food_lattice.show_food('.', 1000, 'blue');
    p5 = sticky_pads.show_pads('.', 1000, 'cyan');
    p3 = Bug.show_bugs(bug_list, '.', 1000,time_constant);
    p4 = Egg.show_eggs(egg_list,'.',300,time_constant);
end

function [p1, p2, p3, p4, p5] = update_plot(human_list, food_lattice, bug_list, egg_list, sticky_pads, p1, p2, p3, p4, p5,time_constant)
    hold on
    delete(p1);
    delete(p2);
    delete(p3);
    delete(p4);
    delete(p5);
    p1 = Human.show_humans(human_list, 'x', 1000, 'black');
    p2 = food_lattice.show_food('.', 1000, 'blue');
    p5 = sticky_pads.show_pads('.', 1000, 'cyan');
    p3 = Bug.show_bugs(bug_list, '.', 1000,time_constant);
    p4 = Egg.show_eggs(egg_list,'.',300,time_constant);  
end

function title = get_title(t, bug_list, environment)
    title = sprintf('$t = %d, n_{bugs} = %d$, night = %d', t, length(bug_list), environment.night);
end