function [time, pos_avg, pos_std] = averagePolePosition(tbl)

% Average Pole angle at each time step 
minLength = length(tbl{1}.time_s_);
for i = 1:length(tbl)
    curLength = length(tbl{i}.time_s_);
    minLength = min(curLength, minLength);
end

for i = 1:length(tbl)
    pos_temp(:,i) = tbl{i}.pole_ang_rad_(1:minLength);
end

time = tbl{i}.time_s_(1:minLength);
pos_avg = mean(pos_temp, 2);
pos_std = std(pos_temp, 0, 2);

end