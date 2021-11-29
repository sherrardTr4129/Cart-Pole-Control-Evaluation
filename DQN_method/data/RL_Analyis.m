%% Analysis Script
clear;
clc;

%% Extract data from .csv files

% Column Names: 
%   runNumber, time_s_, cart_pos_m_, cart_vel_m_s_, pole_ang_rad_,
%   pole_ang_rad_s_
model50_tbl = readtable('model_50_data.csv');
model100_tbl = readtable('model_100_data.csv');
model250_tbl = readtable('model_250_data.csv');
model500_tbl = readtable('model_500_data.csv');
model2500_tbl = readtable('model_2500_data.csv');

% Modify tables --> turn each table into a cell array of tables, where each cell index is a new run
tbl_50 = separateRuns(model50_tbl);
tbl_100 = separateRuns(model100_tbl);
tbl_250 = separateRuns(model250_tbl);
tbl_500 = separateRuns(model500_tbl);
tbl_2500 = separateRuns(model2500_tbl);

%% Plots
n = 0;
% Pole angle vs. Time
n = n+1;
figure(n)
plot(tbl_50{1}.time_s_, tbl_50{1}.pole_ang_rad_)
hold on
plot(tbl_100{1}.time_s_, tbl_100{1}.pole_ang_rad_)
plot(tbl_250{1}.time_s_, tbl_250{1}.pole_ang_rad_)
plot(tbl_500{1}.time_s_, tbl_500{1}.pole_ang_rad_)
plot(tbl_2500{1}.time_s_, tbl_2500{1}.pole_ang_rad_)
legend('50 Iterations','100 Iterations', '250 Iterations', '500 Iterations', '2500 Iterations')
hold off

% Pole angle for all runs + average pole angle for all runs
n = n+1;
figure(n)
hold on
plotAllRuns(tbl_50)
[t_pos50, poleAng_avg50, poleAng_std50] = averagePolePosition(tbl_50);
plot(t_pos50, poleAng_avg50, 'LineWidth', 1.5, 'Color', 'b')
hold off

n = n+1;
figure(n)
hold on
plotAllRuns(tbl_100)
[t_pos100, poleAng_avg100, poleAng_std100] = averagePolePosition(tbl_100);
plot(t_pos100, poleAng_avg100, 'LineWidth', 1.5, 'Color', 'b')
hold off

n = n+1;
figure(n)
hold on
plotAllRuns(tbl_250)
[t_pos250, poleAng_avg250, poleAng_std250] = averagePolePosition(tbl_250);
plot(t_pos250, poleAng_avg250, 'LineWidth', 1.5, 'Color', 'b')
hold off

n = n+1;
figure(n)
hold on
plotAllRuns(tbl_500)
[t_pos500, poleAng_avg500, poleAng_std500] = averagePolePosition(tbl_500);
plot(t_pos500, poleAng_avg500, 'LineWidth', 1.5, 'Color', 'b')
hold off

n = n+1;
figure(n)
hold on
plotAllRuns(tbl_2500)
[t_pos2500, poleAng_avg2500, poleAng_std2500] = averagePolePosition(tbl_2500);
plot(t_pos2500, poleAng_avg2500, 'LineWidth', 1.5, 'Color', 'b')
hold off

