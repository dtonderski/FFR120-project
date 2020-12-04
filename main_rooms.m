addpath('classes/house-model')
addpath('classes/human-model')
addpath('classes/bug-model')
addpath('classes/food-model')
addpath('classes/bug-control-model')



clear all

house = House(100,100);
house = house.add_walls_around_house;

kitchen  = Room("Kitchen", [2,2], [50, 40], [1 1 1]);
bedroom1 = Room("Bedroom 1", [2, 60], [40, 99], [1 1 1]);
bedroom2 = Room("Bedroom 2", [41, 60], [80, 99], [1 1 1]);
toilet   = Room("Toilet", [81,60], [99, 99], [1 1 1]);
closet   = Room("Closet", [2,42], [20, 58], [1 1 1]);
livingarea = Room("Living area", [52,2], [99, 40], [1 1 1]);
hallway = Room("Hallway", [22,42], [99, 58], [1 1 1]);

room_list = [kitchen, bedroom1, bedroom2, toilet, closet, livingarea, hallway];
for room = room_list
    house = house.add_room(room);
end

house = house.add_door([51, 21], [51, 31]);
house = house.add_door([30, 59], [35, 59]);
house = house.add_door([70, 59], [75, 59]);
house = house.add_door([88, 59], [93, 59]);
house = house.add_door([21, 47], [21, 52]);
house = house.add_door([60, 41], [80, 41]);
house = house.add_hiding_place([2 2], [10 10]);

human1 = Human(livingarea);
%human2 = Human(bedroom2);
%human3 = Human(toilet);
human_list = [human1]; %human2]%, human3];

bug1 = Bug(20, 20, house);
bug2 = Bug(35, 40, house);
bug_list = [bug1, bug2];

egg = Egg(0,0,0);
egg_list = [egg];

sticky_pads = Sticky_pads(house);
sticky_pads = sticky_pads.add_sticky_pad([15,15]);

food_lattice = Food_lattice(house);
%food_lattice = human1.litter(food_lattice, 100, 4);

breakfast_probability = 0.9;

reproduction_age = 20;
reproduction_hunger = 0.4;
death_hunger = 1;
maxEggs = 10;
hatch_age = 30;
reproduction_probability = 0.1;
hatch_probability = 0.1;
death_age = 100;
move_out_of_hiding_place_probability = 0.1;

[p1, p2, p3, p4, p5] = show_all(house, human_list, food_lattice, bug_list, egg_list, sticky_pads);

for t = 1:150
    [bug_list, egg_list, food_lattice, sticky_pads] = Bug.update_bugs(bug_list, egg_list, reproduction_age, reproduction_probability, reproduction_hunger, maxEggs, death_age, death_hunger, house, food_lattice, sticky_pads, move_out_of_hiding_place_probability);
    
    [egg_list, bug_list] = Egg.update_eggs(egg_list,bug_list,hatch_age,hatch_probability,house);

    % show_all(house, human_list, food_lattice, bug_list);
    
    % human behaviour should depend on the time instead of probabilty
    [human_list, food_lattice] = Human.update_humans(human_list, bedroom1, kitchen, livingarea, hallway, food_lattice, breakfast_probability);
    
    [p1, p2, p3, p4, p5] = update_plot(human_list, food_lattice, bug_list, egg_list, sticky_pads, p1, p2, p3, p4, p5);
    
    title(sprintf('$t = %d, n_{bugs} = %d$', t, length(bug_list)), 'interpreter', 'latex');
    if length(bug_list) < 1 && length(egg_list) < 1
        break
    end
    %disp(max(max(food_lattice.lattice)))
    shg
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


