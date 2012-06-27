% 2007 July 18 by Zhang Li
% Add this directory in the matlab path

% Grating Orientation and Direction Selectivity Tuning Function For Batch

%function B_Grating(DataDir,MarkerName,SnipName)
function B_Grating(para_struct)
cd (deblank(para_struct.BatchList_DataDir));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BlockName_Mark=['_',para_struct.BatchList_MarkerName,'_mark'];

BlockName_Snip=['_',para_struct.BatchList_SnipName];


ReadData_B_Grating;
ProcessMarker_B_Grating;

% Cause the use of TDT OpenSorter we only analysis the data with SortCode>=1
for z=1:Max_Sort
    evalc(['spike=Spike_',int2str(z),]);
    ProcessSpike_B_Grating;
end



