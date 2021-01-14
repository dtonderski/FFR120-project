addpath('classes/statistics-model')
clear

food_quantity_array = [1,2,3,4,6,7,8,9,10,30,40,50,60,70,80,90,100];
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
xlabel('Mean amount of available food');
ylabel('Mean number of alive adult bugs');
Const = polyfit(log(mean_food_array),log(mean_adult_bugs), 1);
m = Const(1);
k = Const(2);
YBL = mean_food_array.^m.*exp(k);

loglog(mean_food_array, mean_adult_bugs, 'rx', 'MarkerSize', 20, 'LineWidth', 1);
hold on
loglog(mean_food_array, YBL, 'b', 'LineWidth', 2)

legend(sprintf('$y = %.2f x ^{%.2f}$', exp(k), m), "Data", 'interpreter', 'latex', 'location', 'north');
set(gca, 'FontSize', 16)
grid on 
title('\textbf{Food usage}', 'interpreter', 'latex', 'fontsize', 18);
xlabel('Mean amount of available food')
ylabel('Mean number of alive adult bugs')

%%
food_quantity_array = [1,2,3,4,6,7,8,9,10,30,40,50,60,70,80,90,100];
simulation_to_show = 17;
figure(2)
clf
load(sprintf('statistics/food_quantity%d.mat', food_quantity_array(simulation_to_show)));
time_constant = 6;

hold on
plot([1:length(statistics.n_adult_bugs_data)]*24*time_constant, statistics.n_adult_bugs_data, 'b', 'linewidth', 2)
plot(statistics.n_bug_data, 'r', 'linewidth', 2)

legend('Alive adult bugs','Alive bugs', 'interpreter', 'latex', 'location', 'northwest')
xlabel('Time step')
ylabel('Number of bugs')
set(gca, 'FontSize', 16)

title('\textbf{Alive bugs}', 'interpreter', 'latex', 'fontsize', 18);
xlim([1, length(statistics.n_bug_data)])
grid on
%%
figure(3)
clf
heatmap = statistics.show_heatmap;
heatmap.XDisplayLabels(:) = {''};
heatmap.YDisplayLabels(:) = {''};
heatmap.FontSize = 16;
a2 = axes('Position', heatmap.Position);               %new axis on top
a2.Color = 'none';                               %new axis transparent
a2.YTick = [];                %set y ticks to number of rows
a2.XTick = [];                                   %Remove xtick
title('\textbf{Heatmap}', 'interpreter', 'latex', 'fontsize', 18)

%% # of bugs vs spray-notice-ratio
figure(4)
clear all
clf
notice_probability_array = [1e-6,1,1e-1,1e-2,5e-3,2e-3,1e-3,1e-4,1e-5];
document_name_array = [0,0,1,2,53,23,3,4,5];
time_constant = 6;

mean_adult_bugs = zeros(1,length(notice_probability_array));
max_adult_bugs = zeros(1,length(notice_probability_array));
mean_bugs = zeros(1,length(notice_probability_array));
max_bugs = zeros(1,length(notice_probability_array));

load('statistics/pesticide_food20_notice0.mat');
mean_adult_bugs(1) = mean(statistics.n_adult_bugs_data);
max_adult_bugs(1) = max(statistics.n_adult_bugs_data);
mean_bugs(1) = mean(statistics.n_bug_data);
max_bugs(1) = max(statistics.n_bug_data);
    
for i_simulation = 2:length(notice_probability_array)
    document_name = document_name_array(i_simulation);
    load(sprintf('statistics/pesticide_food20_notice-%d.mat', document_name));
    mean_adult_bugs(i_simulation) = mean(statistics.n_adult_bugs_data);
    max_adult_bugs(i_simulation) = max(statistics.n_adult_bugs_data);
    mean_bugs(i_simulation) = mean(statistics.n_bug_data);
    max_bugs(i_simulation) = max(statistics.n_bug_data);
end

loglog(notice_probability_array, mean_adult_bugs,'bo', 'MarkerSize', 10, 'LineWidth', 1);
hold on
loglog(notice_probability_array, mean_bugs, 'rx', 'MarkerSize', 20, 'LineWidth', 1);
xlabel('spray-notice ratio'); 
ylabel('Mean number of bugs');
legend('Alive adult bugs','Alive bugs', 'southwest');
xticklabels({'0','10^{-5}','10^{-4}','10^{-3}','10^{-2}','10^{-1}','1'});
title('\textbf{Effect of spray-notice ratio}', 'interpreter', 'latex', 'fontsize', 18);
set(gca, 'FontSize', 16)

%% # of bugs vs hiding-place-cover-probability
figure(5)
clear all
clf
cover_probability_array = 0.0:0.1:1.0;
time_constant = 6;

mean_adult_bugs = zeros(1,length(cover_probability_array));
max_adult_bugs = zeros(1,length(cover_probability_array));
mean_bugs = zeros(1,length(cover_probability_array));
max_bugs = zeros(1,length(cover_probability_array));

for i_simulation = 1:length(cover_probability_array)
    cover_probability = cover_probability_array(i_simulation);
    load(sprintf('statistics/pesticide_cover_%.1f.mat', cover_probability));
    mean_adult_bugs(i_simulation) = mean(statistics.n_adult_bugs_data);
    mean_bugs(i_simulation) = mean(statistics.n_bug_data);
end

semilogy(cover_probability_array, mean_adult_bugs,'bo', 'MarkerSize', 10, 'LineWidth', 1);
hold on
semilogy(cover_probability_array, mean_bugs, 'rx', 'MarkerSize', 20, 'LineWidth', 1);
xlabel('Pesticide cover percentage in hiding places');
ylabel('Mean number of bugs');
legend('Alive adult bugs','Alive bugs', 'location', 'southwest');
title('\textbf{Effect of cover percentage}', 'interpreter', 'latex', 'fontsize', 18);
set(gca, 'FontSize', 16)
