addpath('classes/house-model')
addpath('classes/human-model')
addpath('classes/bug-model')


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

bug(1) = Bug(20, 30, 100);
X = [bug(1).row];
Y = [bug(1).col];

for t = 1:2000
    clf
    hold on
    house = house.move_humans();
    house.show_house();
    house.show_humans();
    bug(1) = bug(1).move(1);
    numOfBug = numel(bug);
    for index = 1:numOfBug
        bug(index) = bug(index).move(1);
        bug(index) = bug(index).grow();
        bug(index) = bug(index).move(1);
        X(index) = [bug(index).row];
        Y(index) = [bug(index).col];
        if bug(index).age == 3
            bug(index+1) = Bug(bug(index).row, bug(index).col, 100);   
        end
    end
    %X = [bug(1).row];
    %Y = [bug(1).col];
    scatter(X,Y,2,'g','filled')
    shg;
end

