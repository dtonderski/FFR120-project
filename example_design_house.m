
addpath('classes/house-model')
addpath('classes/human-model')
addpath('classes/bug-model')

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
outside = Room("Out", [91,42], [99, 58], [1 1 1]);



room_list = [kitchen, bedroom1, bedroom2, toilet, closet, livingarea, hallway, outside];
for room = room_list
    house = house.add_room(room);
end

house = house.add_door([51, 21], [51, 31]);
house = house.add_door([30, 59], [35, 59]);
house = house.add_door([70, 59], [75, 59]);
house = house.add_door([83, 59], [88, 59]);
house = house.add_door([21, 47], [21, 52]);
house = house.add_door([60, 41], [80, 41]);

% kitchen
house = house.add_hiding_place([2 2], [8 40]);
house = house.add_hiding_place([9 2], [40 8]);
% toilet
house = house.add_hiding_place([81 90], [99 99]);
house = house.add_hiding_place([81 67], [84 83]);
house = house.add_hiding_place([93 60], [98 65]);

% living area
%house = house.add_hiding_place([60 10], [70, 20]);

% bedroom1 
% house = house.add_hiding_place([10 90], [20 95]);



clf
hold on
house.show_house();

