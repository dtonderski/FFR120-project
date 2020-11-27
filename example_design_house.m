
addpath('classes/house-model')
addpath('classes/human-model')
addpath('classes/bug-model')

house = House(100,100);
house = house.add_walls_around_house;

house = house.add_room("Kitchen", [2,2], [50, 40], [1 1 1]);
house = house.add_room("Bedroom 1", [2,60], [40, 99], [1 1 1]);
house = house.add_room("Bedroom 2", [41,60], [80, 99], [1 1 1]);
house = house.add_room("Toilet", [81,60], [99, 99], [1 1 1]);
house = house.add_room("Closet", [2,42], [20, 58], [1 1 1]);
house = house.add_room("Living area", [52,2], [99, 40], [1 1 1]);
house = house.add_room("Hallway", [22,42], [99, 58], [1 1 1]);

house = house.add_door([51, 21], [51, 31]);
house = house.add_door([30, 59], [35, 59]);
house = house.add_door([70, 59], [75, 59]);
house = house.add_door([88, 59], [93, 59]);
house = house.add_door([21, 47], [21, 52]);
house = house.add_door([60, 41], [80, 41]);


human = Human([10 10], house);
house = house.add_human(human);

human.clean(house,"Kitchen");

clf
hold on
house.show_house();
house.show_humans();
