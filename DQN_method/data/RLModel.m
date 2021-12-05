classdef RLModel
    properties
        data
        allPos
        avgPos
        avgPosAll
        stdPos
        minTime
        maxTime
        avgTimeToFail
    end
    
    methods
        %%  Constructor
        function obj = RLModel(inCSV)
            tbl = readtable(inCSV);
            obj.data = obj.separateRuns(tbl);
            [obj.minTime, obj.maxTime, obj.allPos, obj.avgPos, obj.stdPos] = obj.averagePolePositionMin();
            obj.avgTimeToFail = obj.averageTimeToFail();
            obj.avgPosAll = obj.averagePolePositionMax();
        end
        
        %% Plot every run in obj.data
        function plotAllRuns(obj)
            for i = 1:length(obj.data)
                plot(obj.data{i}.time_s_, obj.data{i}.pole_ang_rad_)
                hold on
            end      
        end
        
        %% Plot average of all runs (0-minTime)
        function plotAveragePosMin(obj)
            lw = 2;
            plot(obj.minTime, obj.avgPos, "LineWidth", lw)
        end
        
        %% Plot average of all runs (0-maxTime)
        function plotAveragePosMax(obj)
            lw = 2;
            plot(obj.maxTime, obj.avgPosAll, "LineWidth", lw)
        end
        
        %% Plot box plot of position
        function plotBoxplotPos(obj, skip)
            
            j = 1;
            for i = 1:skip:size(obj.allPos, 2)
                pos(:,j) = obj.allPos(:,i);
                t(j) = obj.minTime(i);
                j = j+1;
            end
            lbl  = t;


            boxplot(pos, 'Labels', lbl);
        end
        
        %% Separate every run into its own cell array
        function cellOfTables = separateRuns(obj, indat)
            
            numRuns = max(indat.runNumber);
            runNumbers = 0:1:numRuns;
            cellOfTables = {table};
            
            for i = 1:length(runNumbers)
                idx = indat.runNumber == runNumbers(i);
                cellOfTables{i} = indat(idx,:);
            end
        end
        
        %% Find average pole position and assign to obj.avgPos
        function [mintime, maxtime, all_pos, pos_avg, pos_std] = averagePolePositionMin(obj)
            indat = obj.data;
            
            minLength = length(indat{1}.time_s_);
            maxLength = length(indat{1}.time_s_);
            for i = 1:length(indat)
                curLength = length(indat{i}.time_s_);
                
                if curLength < minLength
                    shortIndex = i;
                end
                if curLength > maxLength
                    longIndex = i;
                end
                
                minLength = min(curLength, minLength);
                maxLength = max(curLength, minLength);
            end
            
            for i = 1:length(indat)
                pos_temp(:,i) = indat{i}.pole_ang_rad_(1:minLength);
            end
            
            mintime = indat{shortIndex}.time_s_;
            maxtime = indat{longIndex}.time_s_;
            pos_avg = mean(pos_temp, 2);
            pos_std = std(pos_temp, 0, 2);
            all_pos = pos_temp';
        end
        
        %% Find average position for every time step
        function avgPosAll = averagePolePositionMax(obj)
            
            for i = 1:length(obj.maxTime)
                sum = 0;
                n = 0;
                
                for j = 1:length(obj.data)
                    if length(obj.data{j}.time_s_) >= i
                        sum = sum + obj.data{j}.pole_ang_rad_(i);
                        n = n + 1;
                    end
                end
                
                avgPosAll(i) = sum / n;
            end
        end
        
        %% Find average time to failure for all runs and assign to obj.avgTimeToFail
        function avgTime = averageTimeToFail(obj)
            indat = obj.data;
            sumTime = 0;
            
            for i = 1:size(indat)
                sumTime = sumTime + indat{i}.time_s_(end);
            end
            
            avgTime = sumTime / i;
        end
    end
    
    methods(Static)
        
    end
    
end
