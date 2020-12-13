addpath('classes/statistics-model')
clear

food_quantity_array = [1,2,3,4,5,6,7,8,9,10,20,30,40,50,60,70,80,90,100];
mean_food_array = zeros(1,length(food_quantity_array));
mean_adult_bugs = zeros(1,length(food_quantity_array));

for i_simulation = 1:length(food_quantity_array)-4
    food_quantity = food_quantity_array(i_simulation);
    load(sprintf('statistics/food_quantity%d.mat', food_quantity));
    mean_food_array(i_simulation) = mean(statistics.available_food);
    mean_adult_bugs(i_simulation) = mean(statistics.n_adult_bugs_data);
end

plot(mean_food_array, mean_adult_bugs, 'x');
