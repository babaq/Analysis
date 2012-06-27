% Event.m %
% 2007-08-14 
% Zhang Li

% Event Function is to show spike events along the time course of simuli presentation

function Event()
DataDir=input('Input The Data Directory : ','s');
cd (deblank(DataDir));
clear DataDir;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BlockName=input('Input the Experiment Block Name : ','s');
% For Different Recording Conditions
RecordType=input('Input Recording Types -- Single(1) or Double(2) : ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sortcode is usually <=6,S for sorting spike of each data
S=cell(RecordType,7);

for rt=1:RecordType
    BlockName_Mark=['_',BlockName,'_mark.csv'];
    if (RecordType==1)
        BlockName_Snip=['_',BlockName,'_snip'];
    else
        BlockName_Snip=['_',BlockName,'_sp',int2str(rt),'_'];
    end

ReadData_Event;
ProcessMarker_Event;

for z=0:Max_Sort  % no need of z=-1(sortcode_all) for event function
    evalc(['spike=Spike_',int2str(z),]);
    disp(['    For Spike_',int2str(z),'  !']);
    
    ProcessSpike_Event;       % For spikes with no sorting(z=-1) and each SortCode(z>-1)
    
end
end

VisualizeResult_Event;   % summarize the results
