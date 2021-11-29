function cellOfTables = separateRuns(tbl)

numRuns = max(tbl.runNumber);
runNumbers = 0:1:numRuns;
cellOfTables = {table};

for i = 1:length(runNumbers)
    idx = tbl.runNumber == runNumbers(i);
    cellOfTables{i} = tbl(idx,:);    
end

end