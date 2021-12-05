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

% Plot Average Position
fignum = fignum + 1;
figure(fignum)
Model50.plotAveragePos();
hold on
Model100.plotAveragePos();
Model250.plotAveragePos();
Model500.plotAveragePos();
Model2500.plotAveragePos();
lgd = legend('50 Iterations','100 Iterations', '250 Iterations', '500 Iterations', '2500 Iterations');
lgd.FontSize = 14;
title("Average Pole Position Across All Runs")
xlabel("Time (s)")
ylabel("Pole Angle (radians)")
hold off

% Plot average time to fail
avgTimeToFail = [Model50.avgTimeToFail, Model100.avgTimeToFail, Model250.avgTimeToFail, ...
    Model500.avgTimeToFail, Model2500.avgTimeToFail];
fignum = fignum + 1;
figure(fignum)
plot(numIters, avgTimeToFail)
title("Average Time to Failure Across All Models")
xlabel("Number of Iterations to Train Model")
ylabel("Time to Failure (s)")

% Box Plots
fignum = fignum + 1;
figure(fignum)
Model50.plotBoxplotPos();
title("Pole Position of All Runs from 50 Iteration Model")
xlabel("Time (s)")
ylabel("Pole Angle (radians)")

fignum = fignum + 1;
figure(fignum)
Model100.plotBoxplotPos();
title("Pole Position of All Runs from 100 Iteration Model")
xlabel("Time (s)")
ylabel("Pole Angle (radians)")

fignum = fignum + 1;
figure(fignum)
Model250.plotBoxplotPos();
title("Pole Position of All Runs from 250 Iteration Model")
xlabel("Time (s)")
ylabel("Pole Angle (radians)")

fignum = fignum + 1;
figure(fignum)
Model500.plotBoxplotPos();
title("Pole Position of All Runs from 500 Iteration Model")
xlabel("Time (s)")
ylabel("Pole Angle (radians)")

fignum = fignum + 1;
figure(fignum)
Model2500.plotBoxplotPos();
title("Pole Position of All Runs from 2500 Iteration Model")
xlabel("Time (s)")
ylabel("Pole Angle (radians)")

