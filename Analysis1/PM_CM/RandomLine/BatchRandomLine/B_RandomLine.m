% B_RandomLine.m %
% 2007-04-11 
% Zhang Li

% RandomLine Function for analysis of pattern motion and component motion for Batch

function B_RandomLine(para_struct)
cd (deblank(para_struct.BatchList_DataDir));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BlockName_Mark=['_',para_struct.BatchList_MarkerName,'_mark'];

BlockName_Snip=['_',para_struct.BatchList_SnipName];
    
ReadData_B_RandomLine;
ProcessMarker_B_RandomLine;

% Cause the use of TDT OpenSorter we only analysis the data with SortCode>=1
for z=1:Max_Sort
        
    evalc(['spike=Spike_',int2str(z),]);
        
    ProcessSpike_B_RandomLine;
end
