% Wave.m %
% 2007-08-24 by Zhang Li
% Add this directory in the matlab path
% DataDir is the Directory in which you stored the Data Files

% Wave Function for averaging continous waveform of nTrails

function Wave()
DataDir=input('Input The Data Directory : ','s');
cd (deblank(DataDir));
clear DataDir;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Experiment Block Name without suffix and file name extention which is '.csv'
BlockName=input('Input the Experiment Block Name : ','s');
% For Different Recording Conditions
RecordType=input('Input Recording Types -- Single(1) or Double(2) : ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for rt=1:RecordType
    BlockName_Mark=['_',BlockName,'_mark'];
    if (RecordType==1)
        BlockName_Wave=['_',BlockName,'_LFPs'];
    else
        BlockName_Wave=['_',BlockName,'_LFP',int2str(rt),'_'];
    end

ReadData_Wave;
ProcessMarker_Wave;

ProcessWave_Wave;      
VisualizeResult_Wave;
end
end
