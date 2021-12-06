classdef RLModel
    properties
        data
        allPolePos
        allCartPos
        avgPolePos
        avgPolePosAll
        avgCartPos
        avgCartPosAll
        stdPolePos
        stdCartPos
        minTime
        maxTime
        avgTimeToFail
    end
    
    methods
        %%  Constructor
        function obj = RLModel(inCSV)
            tbl = readtable(inCSV);
            obj.data = obj.separateRuns(tbl);
            [obj.minTime, obj.maxTime, obj.allPolePos, obj.avgPolePos, obj.stdPolePos] = obj.averagePolePositionMin();
            [obj.allCartPos, obj.avgCartPos, obj.stdCartPos] = obj.averageCartPositionMin();
            obj.avgTimeToFail = obj.averageTimeToFail();
            obj.avgPolePosAll = obj.averagePolePositionMax();
        end
        
        %% Plot every run pole pos in obj.data
        function plotAll_PolePos(obj)
            for i = 1:length(obj.data)
                plot(obj.data{i}.time_s_, obj.data{i}.pole_ang_rad_)
                hold on
            end      
        end
        
        %% Plot every run cart pos in obj.data
        function plotAll_CartPos(obj)
            for i = 1:length(obj.data)
                plot(obj.data{i}.time_s_, obj.data{i}.cart_pos_m_)
                hold on
            end      
        end
        
        %% Plot average pole pos of all runs (0-minTime)
        function plotAveragePolePosMin(obj)
            lw = 2;
            plot(obj.minTime, obj.avgPolePos, "LineWidth", lw)
        end
        
        %% Plot average cart pos of all runs (0-minTime)
        function plotAverageCartPosMin(obj)
            lw = 2;
            plot(obj.minTime, obj.avgCartPos, "LineWidth", lw)
        end
        
        %% Plot average of all runs (0-maxTime)
        function plotAveragePosMax(obj)
            lw = 2;
            plot(obj.maxTime, obj.avgPolePosAll, "LineWidth", lw)
        end
        
        %% Plot box plot of position
        function plotBoxplotPolePos(obj, skip)
            
            j = 1;
            for i = 1:skip:size(obj.allPolePos, 2)
                pos(:,j) = obj.allPolePos(:,i);
                t(j) = obj.minTime(i);
                j = j+1;
            end
            lbl  = t;


            boxplot(pos, 'Labels', lbl);
        end
        
        %% Plot box plot of position
        function plotBoxplotCartPos(obj, skip)
            
            j = 1;
            for i = 1:skip:size(obj.allCartPos, 2)
                pos(:,j) = obj.allCartPos(:,i);
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
        
        %% Find average pole position and assign to obj.avgPolePos
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
        
        %% Find average pole position and assign to obj.avgPolePos
        function [all_pos, pos_avg, pos_std] = averageCartPositionMin(obj)
            indat = obj.data;
            len = length(obj.minTime);
            
            for i = 1:length(indat)
                pos_temp(:,i) = indat{i}.cart_pos_m_(1:len);
            end
            
            pos_avg = mean(pos_temp, 2);
            pos_std = std(pos_temp, 0, 2);
            all_pos = pos_temp';
        end
        
        %% Find average position for every time step
        function avgPolePosAll = averagePolePositionMax(obj)
            
            for i = 1:length(obj.maxTime)
                sum = 0;
                n = 0;
                
                for j = 1:length(obj.data)
                    if length(obj.data{j}.time_s_) >= i
                        sum = sum + obj.data{j}.pole_ang_rad_(i);
                        n = n + 1;
                    end
                end
                
                avgPolePosAll(i) = sum / n;
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
