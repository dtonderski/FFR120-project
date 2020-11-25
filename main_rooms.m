addpath('classes/house-model')
addpath('classes/human-model')


clear
house = House(100,100);
house = house.add_walls_around_house;
house = house.add_room("Kitchen", [2,2], [50, 50], [1 1 1]);
house = house.add_door([51, 21], [51, 31]);
house = house.add_hiding_place([2,2],[5,5]);

human = Human([2 2], house);
house = house.add_human(human);

human = Human([51 21], house);
house = house.add_human(human);

human = Human([89 75], house);
house = house.add_human(human);


for t = 1:1000
    clf
    hold on
    house = house.move_humans();
    house.show_house();
    house.show_humans();
    shg;
end

