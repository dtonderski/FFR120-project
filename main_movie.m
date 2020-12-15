addpath('classes/house-model')
addpath('classes/human-model')
addpath('classes/bug-model')
addpath('classes/food-model')
addpath('classes/bug-control-model')
addpath('classes/enviroment-model')
addpath('classes/statistics-model')

clear

time_constant = 6; % time steps in one hour
reproduction_hunger = 14*24*time_constant;  % no food for continuous 2 weeks, cannot reproduce
minEggs = 30;
maxEggs = 120;
reproduction_interval = 30*24*time_constant; % 30 days
hatch_probability = 1; % video change
hungry_move_threshold = time_constant;
max_move_out_of_hiding_probability = 0.05;
max_move_out_of_hiding_probability_if_human_in_room = 0;
max_change_room_probability = 0.01;
max_change_rooms_if_no_food_probability = 0.05;
moving_night_factor = 15;
max_moving_probability = [max_move_out_of_hiding_probability, max_move_out_of_hiding_probability_if_human_in_room, max_change_room_probability, max_change_rooms_if_no_food_probability];
notice_probability = 0.5;
kill_if_noticed_probability = 0.2;
time_steps = 145;
should_plot = true;

kitchen_rate = 0.2;
livingarea_rate = 0.05;
hallway_rate = 0.05;
toilet_rate = 0.05;
bedroom_rate = 0.01;
food_rate = [kitchen_rate, livingarea_rate, hallway_rate, toilet_rate, bedroom_rate];

food_quantity_array = 5;%[1,2,3,4,5,6,7,8,9,10,20,30,40,50,60,70,80,90,100];
n_food_locations_array = min(round(food_quantity_array/2), 10);


myVideo = VideoWriter('Human_bugs_model_2fps');
myVideo.FrameRate = 2; 
open(myVideo)


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

    
    % video tweaks
    bug1 = Bug(2,2, house, time_constant);
    bug1.age = bug1.death_age-110;
    bug1.hunger = 4260;
    bug_list = [bug1];
    
    
    egg = Egg(20,5,1,time_constant);
    egg.age = egg.hatch_age-125;
    egg_list = [egg];

    sticky_pads = Sticky_pads(house);

    food_lattice = Food_lattice(house);
    food_lattice = food_lattice.add_food([10,10],1);
    food_lattice = food_lattice.add_food([15,15],1);
    food_lattice = food_lattice.add_food([90,85],1);


    statistics = Statistics(bug_list, time_steps, house, time_constant);

    figure(1)
    figure('units','pixels','position',[0 0 1480 1080]) 
    [p1, p2, p3, p4, p5] = show_all(house, human_list, food_lattice, bug_list, egg_list, sticky_pads, time_constant);

    start_time = tic;

    for t = 1:time_steps
        tic
        [environment] = Environment.update_environment(environment);

        [human_list, food_lattice] = Human.update_humans(human_list, house, environment, food_lattice, room_list,   ...
            food_rate, food_quantity, n_food_locations);

        [bug_list, egg_list, food_lattice, sticky_pads, killed_bugs] = Bug.update_bugs(bug_list, egg_list,     ...
                    room_list, human_list, reproduction_interval, reproduction_hunger, minEggs, maxEggs,                ...
                    hungry_move_threshold, environment, house, food_lattice, sticky_pads,                               ...
                    max_moving_probability, moving_night_factor, kill_if_noticed_probability);

        [egg_list, bug_list] = Egg.update_eggs(egg_list,bug_list,hatch_probability,house,time_constant);


        t1 = toc;
        statistics = statistics.update_statistics(bug_list, t, food_lattice, time_constant);
        t2 = toc;

        if should_plot
            [p1, p2, p3, p4, p5] = update_plot(human_list, food_lattice, bug_list, egg_list, sticky_pads,environment, p1, p2, p3, p4, p5, time_constant);
        end
        
        % Create movie
        frame = getframe(gcf); %get frame
        writeVideo(myVideo, frame);
        
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

close(myVideo)

function [p1, p2, p3, p4, p5] = show_all(house, human_list, food_lattice, bug_list, egg_list, sticky_pads,time_constant)
    clf
    hold on
    house.show_house();
    p1 = Human.show_humans(human_list, 'x', 1000, 'black');
    p2 = food_lattice.show_food('d', 50, 'blue');
    p5 = sticky_pads.show_pads('.', 1000, 'cyan');
    p3 = Bug.show_bugs(bug_list, '.', 2500,time_constant);
    p4 = Egg.show_eggs(egg_list,'o',100,time_constant);
    set(gca,'YTick',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[]);
    set(gca,'XTickLabel',[]);
    %title(get_title(environment), 'interpreter', 'latex');
    shg;
end

function [p1, p2, p3, p4, p5] = update_plot(human_list, food_lattice, bug_list, egg_list, sticky_pads,environment, p1, p2, p3, p4, p5,time_constant)
    hold on
    delete(p1);
    delete(p2);
    delete(p3);
    delete(p4);
    delete(p5);
    p1 = Human.show_humans(human_list, 'x', 1000, 'black');
    p2 = food_lattice.show_food('d', 50, 'blue');
    p5 = sticky_pads.show_pads('.', 1000, 'cyan');
    p3 = Bug.show_bugs(bug_list, '.', 2500,time_constant);
    p4 = Egg.show_eggs(egg_list,'o',100,time_constant);  
    title(get_title(environment), 'interpreter', 'latex', 'fontsize', 20);
    shg;
end

function title = get_title(environment)
    title = sprintf('Day %d of simulation, time is %s.', environment.week*7 + environment.day, environment.get_time_string);
end