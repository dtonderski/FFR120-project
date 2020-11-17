addpath('classes/house-model')
house = House(10,10);
house = house.add_room("Kitchen", [1,1], [3,3]);
house = house.add_room("Hall", [4,1], [6,10]);
house = house.add_wall([7 1], [7 10]);
disp(house.lattice_with_rooms)
house.is_traversable(7,1)

imshow((house.lattice_with_rooms+1)/5, 'InitialMagnification', 'fit')


