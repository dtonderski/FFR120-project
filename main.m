addpath('classes/house-model')
addpath('classes/human-model')
addpath('classes/bug-model')
addpath('classes/food-model')
addpath('classes/bug-control-model')
addpath('classes/enviroment-model')
addpath('classes/statistics-model')

clear

time_constant = 6; % time steps in one hour
drug_resistance = 0.05;
reproduction_hunger = 14*24*time_constant;  % no food for continuous 2 weeks, cannot reproduce
minEggs = 30;
maxEggs = 120;
reproduction_interval = 30*24*time_constant; % 30 days
hatch_probability = 0.5;
hungry_move_threshold = time_constant;
night_day_ratio = 10;
max_move_out_of_hiding_probability = 0.05;
max_move_out_of_hiding_probability_if_human_in_room = 0;
max_change_room_probability = 0.01;
max_change_rooms_if_no_food_probability = 0.05;
max_moving_probability = [max_move_out_of_hiding_probability, max_move_out_of_hiding_probability_if_human_in_room, max_change_room_probability, max_change_rooms_if_no_food_probability];
notice_probability = 0.5;
kill_if_noticed_probability = 0.2;
time_steps = 105120;
should_plot = true;

kitchen_rate = 0.1;
livingarea_rate = 0.05;
hallway_rate = 0.05;
toilet_rate = 0.05;
bedroom_rate = 0.01;
food_rate = [kitchen_rate, livingarea_rate, hallway_rate, toilet_rate, bedroom_rate];

food_quantity_array = 20;%[1,2,3,4,5,6,7,8,9,10,20,30,40,50,60,70,80,90,100];
n_food_locations_array = min(round(food_quantity_array/2), 10);

spray_notice_ratio = 0.1;
cover_probability = 0.8;

for i_simulation = 1:length(food_quantity_array)
    food_quantity = food_quantity_array(i_simulation);
    n_food_locations = n_food_locations_array(i_simulation);

    room_list = Room.create_deafult_room_list();

    house = House.create_default_house(room_list);

    environment = Environment(house, time_constant); 

    human1 = Human(house.find_room('Living area'), 'Bedroom 1');
    human2 = Human(house.find_room('Kitchen'),'Bedroom 2');
    %human3 = Human(house.find_room('Toilet'));

    human_list = [human1, human2]; %, human3];

    bug1 = Bug(2,2, house, time_constant, drug_resistance);
    bug2 = Bug(3,3, house, time_constant, drug_resistance);
    bug3 = Bug(4,4, house, time_constant, drug_resistance);
    bug4 = Bug(5,5, house, time_constant, drug_resistance);

    bug1.age = randi([1,bug1.death_age],1);
    bug2.age = randi([1,bug2.death_age],1);
    bug3.age = randi([1, bug3.death_age],1);
    bug4.age = randi([1, bug4.death_age],1);

    bug_list = [bug1,bug2, bug3, bug4];

    egg = Egg(1,1,0,time_constant);
    egg_list = [egg];

    sticky_pads = Sticky_pads(house);

    food_lattice = Food_lattice(house);
    
    pesticide = Pesticide(house);




    statistics = Statistics(bug_list, time_steps, house, time_constant);

    figure(1)
    [p1, p2, p3, p4, p5, p6] = show_all(house, human_list, food_lattice, bug_list, egg_list, sticky_pads, pesticide, time_constant);

    start_time = tic;

    for t = 1:time_steps
        tic
        [environment] = Environment.update_environment(environment);

        [human_list, food_lattice, pesticide] = Human.update_humans(human_list, house, environment, food_lattice, room_list,   ...
            food_rate, food_quantity, n_food_locations, pesticide, cover_probability, spray_notice_ratio);

        [bug_list, egg_list, food_lattice, sticky_pads, killed_bugs, human_list] = Bug.update_bugs(bug_list, egg_list,     ...
                    room_list, human_list, reproduction_interval, reproduction_hunger, minEggs, maxEggs,                ...
                    hungry_move_threshold, environment, house, food_lattice, sticky_pads,                               ...
                    max_moving_probability, night_day_ratio, notice_probability, kill_if_noticed_probability, pesticide);

        [egg_list, bug_list] = Egg.update_eggs(egg_list,bug_list,hatch_probability,house,time_constant, pesticide);

        t1 = toc;
        statistics = statistics.update_statistics(bug_list, t, food_lattice, time_constant);
        t2 = toc;

        if should_plot
            [p1, p2, p3, p4, p5, p6] = update_plot(human_list, food_lattice, bug_list, egg_list, sticky_pads,environment, pesticide, p1, p2, p3, p4, p5, p6, time_constant);
        end
        
        pesticide = pesticide.remove_pesticide(house);

        if length(bug_list) < 1 && length(egg_list) < 1
            break
        end
        t3 = toc;
        if mod(t,1000) == 1
            fprintf('Simulation %d. t is %d, n_bugs = %d, Iteration time - %.5f.\n', i_simulation, t, length(bug_list), t3)
        end
    end
    fprintf('Simulation %d completed. Total time - %.5f. Number of time steps - %d.\n', i_simulation, toc(start_time), t)
    save(sprintf('statistics/food_quantity%d.mat', food_quantity), 'statistics');
end

function [p1, p2, p3, p4, p5, p6] = show_all(house, human_list, food_lattice, bug_list, egg_list, sticky_pads,pesticide,time_constant)
    clf
    hold on
    house.show_house();
    p1 = Human.show_humans(human_list, 'x', 1000, 'black');
    p2 = food_lattice.show_food('d', 15, 'blue');
    p5 = sticky_pads.show_pads('.', 1000, 'cyan');
    p3 = Bug.show_bugs(bug_list, '.', 1000,time_constant);
    p4 = Egg.show_eggs(egg_list,'o',15,time_constant);
    p6 = pesticide.show_pesticide('.',10,'yellow');
    set(gca,'YTick',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[]);
    set(gca,'XTickLabel',[]);
    %title(get_title(environment), 'interpreter', 'latex');
    shg;
end

function [p1, p2, p3, p4, p5, p6] = update_plot(human_list, food_lattice, bug_list, egg_list, sticky_pads,environment, pesticide, p1, p2, p3, p4, p5,p6,time_constant)
    hold on
    delete(p1);
    delete(p2);
    delete(p3);
    delete(p4);
    delete(p5);
    delete(p6);
    p1 = Human.show_humans(human_list, 'x', 1000, 'black');
    p2 = food_lattice.show_food('d', 20, 'blue');
    p5 = sticky_pads.show_pads('.', 1000, 'cyan');
    p3 = Bug.show_bugs(bug_list, '.', 1000,time_constant);
    p4 = Egg.show_eggs(egg_list,'o',20,time_constant);
    p6 = pesticide.show_pesticide('.',10,'yellow');
    title(get_title(environment), 'interpreter', 'latex', 'fontsize', 20);
    shg;
end

function title = get_title(environment)
    title = sprintf('Day %d of simulation, time is %s.', environment.week*7 + environment.day, environment.get_time_string);
end