function plotAllRuns(tbl)

for i = 1:length(tbl)
    plot(tbl{i}.time_s_, tbl{i}.pole_ang_rad_)
end

end