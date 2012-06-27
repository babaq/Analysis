% 2007 May 05 by Zhang Li
% Add this directory in the matlab path

% Plaid Function for analysis of pattern motion and component motion For Batch

function B_Plaid(para_struct)
cd (deblank(para_struct.BatchList_DataDir));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BlockName_Mark=['_',para_struct.BatchList_MarkerName,'_mark'];

BlockName_Snip=['_',para_struct.BatchList_SnipName];

    
ReadData_B_Plaid;
ProcessMarker_B_Plaid;

% Cause the use of TDT OpenSorter we only analysis the data with SortCode>=1
for z=1:Max_Sort
        
    evalc(['spike=Spike_',int2str(z),]);
        
    ProcessSpike_B_Plaid;
end




