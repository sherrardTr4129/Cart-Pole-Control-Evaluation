classdef RLModel
    properties
        data
        allPos
        avgPos
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
            [obj.minTime, obj.maxTime, obj.allPos, obj.avgPos, obj.stdPos] = obj.averagePolePosition();
            obj.avgTimeToFail = obj.averageTimeToFail();
        end
        
        %% Plot every run in obj.data
        function plotAllRuns(obj)
            for i = 1:length(obj.data)
                plot(obj.data{i}.time_s_, obj.data{i}.pole_ang_rad_)
            end          
        end
        
        %% Plot average of all runs
        function plotAveragePos(obj)
            lw = 2;
            plot(obj.minTime, obj.avgPos, "LineWidth", lw)
        end
        
        %% Plot box plot of position
        function plotBoxplotPos(obj)
            timestep = obj.minTime(2) - obj.minTime(1);
            lbl = 0:timestep:obj.minTime(end);
            boxplot(obj.allPos, 'Labels', lbl);
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
        function [mintime, maxtime, all_pos, pos_avg, pos_std] = averagePolePosition(obj)
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
