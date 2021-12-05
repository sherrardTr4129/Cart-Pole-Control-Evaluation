clear;
clc;

csv_50 = 'model_50_data.csv';
csv_100 = 'model_100_data.csv';
csv_250 = 'model_250_data.csv';
csv_500 = 'model_500_data.csv';
csv_2500 = 'model_2500_data.csv';
numIters = [50, 100, 250, 500, 2500];

Model50 = RLModel(csv_50);
Model100 = RLModel(csv_100);
Model250 = RLModel(csv_250);
Model500 = RLModel(csv_500);
Model2500 = RLModel(csv_2500);
fignum = 0;

%% Plot all runs
Model50.plotAllRuns()
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
hold off

%%
Model100.plotAllRuns()
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
hold off

%%
Model500.plotAllRuns()
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
hold off

%%
Model2500.plotAllRuns()
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
hold off

%% Plot Average Position 
fignum = fignum + 1;
figure(fignum)
Model50.plotAveragePosMin();
hold on
Model100.plotAveragePosMin();
Model250.plotAveragePosMin();
Model500.plotAveragePosMin();
Model2500.plotAveragePosMin();
lgd = legend('50 Iterations','100 Iterations', '250 Iterations', '500 Iterations', '2500 Iterations');
lgd.FontSize = 14;
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
hold off

%% Plot Average Position 
fignum = fignum + 1;
figure(fignum)
Model50.plotAveragePosMax();
hold on
Model100.plotAveragePosMax();
Model250.plotAveragePosMax();
Model500.plotAveragePosMax();
Model2500.plotAveragePosMax();
lgd = legend('50 Iterations','100 Iterations', '250 Iterations', '500 Iterations', '2500 Iterations');
lgd.FontSize = 14;
title("Average Pole Position Across All Runs t = 0 to maxTime")
xlabel("Time (s)")
ylabel("Pole Angle (radians)")
hold off

%% Plot average time to fail
avgTimeToFail = [Model50.avgTimeToFail, Model100.avgTimeToFail, Model250.avgTimeToFail, ...
    Model500.avgTimeToFail, Model2500.avgTimeToFail];
fignum = fignum + 1;
figure(fignum)
plot(numIters, avgTimeToFail)
title("Average Time to Failure Across All Models")
xlabel("Number of Iterations to Train Model")
ylabel("Time to Failure (s)")

%% Box Plots
fignum = fignum + 1;
figure(fignum)
Model50.plotBoxplotPos(1);
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
%%
fignum = fignum + 1;
figure(fignum)
Model100.plotBoxplotPos(1);
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
%%
fignum = fignum + 1;
figure(fignum)
Model250.plotBoxplotPos(1);
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
%%
fignum = fignum + 1;
figure(fignum)
Model500.plotBoxplotPos(1);
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
%%
fignum = fignum + 1;
figure(fignum)
Model2500.plotBoxplotPos(1);
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)

