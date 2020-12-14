addpath('classes/statistics-model')
clear

food_quantity_array = [1,2,3,4,5,6,7,8,9,10,20,30,40,50,60,70,80,90,100];
simulation_to_show = 19;
time_constant = 6;

mean_food_array = zeros(1,length(food_quantity_array));
mean_adult_bugs = zeros(1,length(food_quantity_array));

for i_simulation = 1:length(food_quantity_array)
    food_quantity = food_quantity_array(i_simulation);
    load(sprintf('statistics/food_quantity%d.mat', food_quantity));
    mean_food_array(i_simulation) = mean(statistics.available_food);
    mean_adult_bugs(i_simulation) = mean(statistics.n_adult_bugs_data);
end
figure(1)
clf
plot(mean_food_array, mean_adult_bugs, 'x');
xlabel('Mean amount of available food');
ylabel('Mean number of alive adult bugs');
%%
figure(2)
clf
load(sprintf('statistics/food_quantity%d.mat', food_quantity_array(simulation_to_show)));
hold on
plot([1:length(statistics.n_adult_bugs_data)]*24*time_constant, statistics.n_adult_bugs_data)
plot(statistics.n_bug_data)

legend('Alive adult bugs','Alive bugs')
xlabel('Time step')
ylabel('Number of bugs')
