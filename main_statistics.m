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
%load(sprintf('statistics/food_quantity%d.mat', food_quantity_array(simulation_to_show)));
load(sprintf('statistics/pesticide_food20_notice-3.mat'), 'statistics');
time_constant = 6;

hold on
plot([1:length(statistics.n_adult_bugs_data)]*24*time_constant, statistics.n_adult_bugs_data)
plot(statistics.n_bug_data)

legend('Alive adult bugs','Alive bugs')
xlabel('Time step')
ylabel('Number of bugs')

%% # of bugs vs spray-notice-ratio
figure(3)
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

% hold on
% subplot(2,2,[1,2]);
loglog(notice_probability_array, mean_adult_bugs,'o',notice_probability_array, mean_bugs, 'x');
xlabel('spray-notice ratio'); 
ylabel('Mean number of bugs');
legend('Alive adult bugs','Alive bugs');
xticklabels({'0','10^{-5}','10^{-4}','10^{-3}','10^{-2}','10^{-1}','1'});
title('Bug control technique - Pesticide');
% subplot(2,2,3);
% semilogx(notice_probability_array, mean_adult_bugs,'o');
% xlabel('spray-notice ratio'); 
% ylabel('Mean number of adult bugs');
% xticks([10^-6,10^-5,10^-4,10^-3,10^-2,10^-1,1]);
% xticklabels({'0','10^{-5}','10^{-4}','10^{-3}','10^{-2}','10^{-1}','1'});
% subplot(2,2,4);
% semilogx(notice_probability_array, mean_bugs,'o');
% xlabel('spray-notice ratio'); 
% ylabel('Mean number of bugs');
% xticks([10^-6,10^-5,10^-4,10^-3,10^-2,10^-1,1]);
% xticklabels({'0','10^{-5}','10^{-4}','10^{-3}','10^{-2}','10^{-1}','1'});
% subplot(2,2,2);
% semilogx(notice_probability_array, max_adult_bugs, 'x');
% subplot(2,2,3);
% semilogx(notice_probability_array, mean_bugs, 'o');
% subplot(2,2,4);
% semilogx(notice_probability_array, max_bugs, 'x');
%% # of bugs vs hiding-place-cover-probability
figure(4)
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

% hold on
% subplot(2,2,[1,2]);
semilogy(cover_probability_array, mean_adult_bugs,'o',cover_probability_array, mean_bugs, 'x');
xlabel('Pesticide cover percentage in hiding places'); 
ylabel('Mean number of bugs');
legend('Alive adult bugs','Alive bugs');
title('Bug control technique - Pesticide');
% subplot(2,2,3);
% plot(cover_probability_array, mean_adult_bugs,'o');
% xlabel('Pesticide cover percentage in hiding places'); 
% ylabel('Mean number of adult bugs');
% subplot(2,2,4);
% plot(cover_probability_array, mean_bugs,'o');
% xlabel('Pesticide cover percentage in hiding places'); 
% ylabel('Mean number of bugs');