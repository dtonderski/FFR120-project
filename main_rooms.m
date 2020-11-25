addpath('classes/house-model')

clear
house = House(100,100);
house = house.add_walls_around_house;
house = house.add_room("Kitchen", [2,2], [50, 50], [1 1 1]);
house = house.add_door([51, 21], [51, 31]);
house = house.add_hiding_place([2,2],[5,5]);

clf
house.show_house();

