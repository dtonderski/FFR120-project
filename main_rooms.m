addpath('classes/house-model')
addpath('classes/human-model')
addpath('classes/bug-model')


clear
house = House(100,100);
house = house.add_walls_around_house;
house = house.add_room("Kitchen", [2,2], [50, 40], [1 1 1]);
house = house.add_room("Bedroom 1", [2,60], [40, 99], [1 1 1]);
house = house.add_room("Bedroom 2", [41,60], [80, 99], [1 1 1]);
house = house.add_room("Toilet", [81,60], [99, 99], [1 1 1]);
house = house.add_room("Closet", [2,42], [20, 58], [1 1 1]);

house = house.add_door([51, 21], [51, 31]);
house = house.add_door([30, 59], [35, 59]);
house = house.add_door([70, 59], [75, 59]);
house = house.add_door([88, 59], [93, 59]);
house = house.add_door([21, 47], [21, 52]);

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
    bug(1) = bug(1).move(1,house);
    numOfBug = numel(bug);
    for index = 1:numOfBug
        bug(index) = bug(index).move(1,house);
        bug(index) = bug(index).grow();
        bug(index) = bug(index).move(1,house);
        X(index) = [bug(index).row];
        Y(index) = [bug(index).col];
        if bug(index).age == 40
            numOfBug = numel(bug);
            randombugnum = randi(2);
            for i = 1:randombugnum
                bug(numOfBug+i) = Bug(bug(index).row, bug(index).col, 100); 
            end
        end
        if bug(index).age == 60
            bug(index) = bug(index).die();
        end
    end
    %X = [bug(1).row];
    %Y = [bug(1).col];
    scatter(X,Y,10,'g','filled')
    shg;
end

