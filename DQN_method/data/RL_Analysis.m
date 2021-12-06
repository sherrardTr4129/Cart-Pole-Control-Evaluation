clear;
clc;

csv_50 = 'model_50_data.csv';
csv_100 = 'model_100_data.csv';
csv_250 = 'model_250_data.csv';
csv_500 = 'model_500_data.csv';
csv_2500 = 'model_2500_data.csv';
numIters = [50, 100, 250, 500, 2500];
showTitle = true;

Model50 = RLModel(csv_50);
Model100 = RLModel(csv_100);
Model250 = RLModel(csv_250);
Model500 = RLModel(csv_500);
Model2500 = RLModel(csv_2500);
fignum = 0;

%% Plot all runs
fignum = fignum + 1;
Model50.plotAll_PolePos()
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
if showTitle
    title('50 Iteration Model: All Pole Positions', 'FontSize', 14)
end
hold off

%% Plot all runs
fignum = fignum + 1;
Model50.plotAll_CartPos()
xlabel("Time (s)", 'FontSize', 14)
ylabel("Cart Position (m)", 'FontSize', 14)
if showTitle
    title('50 Iteration Model: All Cart Positions', 'FontSize', 14)
end
hold off

%%
fignum = fignum + 1;
Model100.plotAll_PolePos()
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
if showTitle
    title('100 Iteration Model: All Pole Positions', 'FontSize', 14)
end
hold off

%% Plot all runs
fignum = fignum + 1;
Model100.plotAll_CartPos()
xlabel("Time (s)", 'FontSize', 14)
ylabel("Cart Position (m)", 'FontSize', 14)
if showTitle
    title('100 Iteration Model: All Cart Positions', 'FontSize', 14)
end
hold off

%%
fignum = fignum + 1;
Model500.plotAll_PolePos()
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
if showTitle
    title('500 Iteration Model: All Pole Positions', 'FontSize', 14)
end
hold off

%% Plot all runs
fignum = fignum + 1;
Model500.plotAll_CartPos()
xlabel("Time (s)", 'FontSize', 14)
ylabel("Cart Position (m)", 'FontSize', 14)
if showTitle
    title('500 Iteration Model: All Cart Positions', 'FontSize', 14)
end
hold off

%%
fignum = fignum + 1;
Model2500.plotAll_PolePos()
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
if showTitle
    title('2500 Iteration Model: All Pole Positions', 'FontSize', 14)
end
hold off

%% Plot all runs
fignum = fignum + 1;
Model100.plotAll_CartPos()
xlabel("Time (s)", 'FontSize', 14)
ylabel("Cart Position (m)", 'FontSize', 14)
if showTitle
    title('2500 Iteration Model: All Cart Positions', 'FontSize', 14)
end
hold off

%% Plot Average Position 
fignum = fignum + 1;
figure(fignum)
Model50.plotAveragePolePosMin();
hold on
Model100.plotAveragePolePosMin();
Model250.plotAveragePolePosMin();
Model500.plotAveragePolePosMin();
Model2500.plotAveragePolePosMin();
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
Model50.plotBoxplotPolePos(1);
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)

fignum = fignum + 1;
figure(fignum)
Model50.plotBoxplotCartPos(1);
xlabel("Time (s)", 'FontSize', 14)
ylabel("Cart Position (m)", 'FontSize', 14)
title('Cart Position Model 50', 'FontSize', 14)
%%
fignum = fignum + 1;
figure(fignum)
Model100.plotBoxplotPolePos(1);
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
%%
fignum = fignum + 1;
figure(fignum)
Model250.plotBoxplotPolePos(1);
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
%%
fignum = fignum + 1;
figure(fignum)
Model500.plotBoxplotPolePos(1);
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)
%%
fignum = fignum + 1;
figure(fignum)
Model2500.plotBoxplotPolePos(1);
xlabel("Time (s)", 'FontSize', 14)
ylabel("Pole Angle (radians)", 'FontSize', 14)

