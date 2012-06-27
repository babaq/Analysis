% 2007-09-17 by Zhang Li

% Grating Orientation and Direction Selectivity Tuning Function of time course

function GTCc()
DataDir=input('Input The Full Data Directory Name : ','s');
cd (deblank(DataDir));
clear DataDir;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Experiment Block Name without suffix and file name extention which is '.csv'
BlockName=input('Input the Experiment Block Name : ','s');
% For Different Recording Conditions
RecordType=input('Input Recording Types -- Single(1) or Double(2) : ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for rt=1:RecordType
    BlockName_Mark=['_',BlockName,'_mark'];
    if (RecordType==1)
        BlockName_Snip=['_',BlockName,'_snip_os'];
    else
        BlockName_Snip=['_',BlockName,'_sp',int2str(rt),'__os'];
    end


ReadData_GTCc;
ProcessMarker_GTCc;

ResultDir=[BlockName_Snip,'_GTCc'];
mkdir(ResultDir);      % Directory for saving the time course results
cd(deblank(ResultDir));

Bin=0.05;            % Bin Time to analysis time course
Bin_number=floor(0.5/Bin); % 500ms is enough for cumulation of response property

% Cause the use of TDT OpenSorter we only analysis the data with SortCode>=1
for z=1:Max_Sort
        evalc(['spike=Spike_',int2str(z),]);
        
        for Bn=1:Bin_number
    ProcessSpike_GTCc;   
    VisualizeResult_GTCc_TuningCurve;
        end
end
end


