addpath('classes/house-model')
addpath('classes/human-model')
addpath('classes/bug-model')
addpath('classes/food-model')


clear

house = House(100,100);
house = house.add_walls_around_house;

kitchen  = Room("Kitchen", [2,2], [50, 40], [1 1 1]);
bedroom1 = Room("Bedroom 1", [2, 60], [40, 99], [1 1 1]);
bedroom2 = Room("Bedroom 2", [41, 60], [80, 99], [1 1 1]);
toilet   = Room("Toilet", [81,60], [99, 99], [1 1 1]);
closet   = Room("Closet", [2,42], [20, 58], [1 1 1]);

room_list = [kitchen, bedroom1, bedroom2, toilet, closet];
for room = room_list
    house = house.add_room(room);
end

house = house.add_door([51, 21], [51, 31]);
house = house.add_door([30, 59], [35, 59]);
house = house.add_door([70, 59], [75, 59]);
house = house.add_door([88, 59], [93, 59]);
house = house.add_door([21, 47], [21, 52]);
house = house.add_hiding_place([2 2], [10 10]);

human1 = Human(kitchen);
human2 = Human(bedroom2);
human3 = Human(toilet);
human_list = [human1, human2, human3];

bug1 = Bug(20, 20, house);
bug2 = Bug(35, 40, house);
bug_list = [bug1, bug2];

food_lattice = Food_lattice(house);
food_lattice = human1.litter(food_lattice, 100, 4);

reproduction_age = 1;
death_age = 100;
reproduction_number = 1;
move_out_of_hiding_place_probability = 0.1;
reproduction_probability = 0.01;

[p1, p2, p3] = show_all(house, human_list, food_lattice, bug_list);

for t = 1:100
    bug_list = Bug.update_bugs(bug_list, reproduction_age, death_age,  reproduction_number, house, food_lattice, move_out_of_hiding_place_probability, reproduction_probability);
    % show_all(house, human_list, food_lattice, bug_list);
    [p1, p2, p3] = update_plot(human_list, food_lattice, bug_list, p1, p2, p3);
    
    title(sprintf('$t = %d, n_{bugs} = %d$', t, length(bug_list)), 'interpreter', 'latex');
    if length(bug_list) < 1
        break
    end
    pause(0.1)
end

function [p1, p2, p3] = show_all(house, human_list, food_lattice, bug_list)
    clf
    hold on
    house.show_house();
    p1 = Human.show_humans(human_list, 'x', 1000, 'black');
    p2 = food_lattice.show_food('.', 1000, 'blue');
    p3 = Bug.show_bugs(bug_list, '.', 1000, 'green');
end

function [p1, p2, p3] = update_plot(human_list, food_lattice, bug_list, p1, p2, p3)
    hold on
    delete(p1);
    delete(p2);
    delete(p3);
    p1 = Human.show_humans(human_list, 'x', 1000, 'black');
    p2 = food_lattice.show_food('.', 1000, 'blue');
    p3 = Bug.show_bugs(bug_list, '.', 1000, 'green');
    
end


