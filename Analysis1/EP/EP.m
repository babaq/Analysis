% EP.m %
% 2007-06-11
% Zhang Li

% Event and sPSTH Function(EP) for nStimuli

function EP()
DataDir=input('Input The Data Directory : ','s');
cd (deblank(DataDir));
clear DataDir;

ReadData_EP;
ProcessMarker_EP;

for z=-1:Max_Sort
    if(z~=-1)
        evalc(['spike=Spike_',int2str(z),]);
        disp(['    For Spike_',int2str(z),'  !']);
    else
        disp('    For Spike_all  !');
    end
    ProcessSpike_EP;       % For spikes with no sorting(z=-1) and each SortCode(z>-1)
    VisualizeResult_EP;
end
