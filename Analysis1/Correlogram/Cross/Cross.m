% Cross.m %
% 2007-08-12
% Zhang Li

% Cross Correlation Histogram Function

function Cross()
DataDir=input('Input The Data Directory : ','s');
cd (deblank(DataDir));
clear DataDir;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ReadData_Cross;
ProcessMarker_Cross;

ProcessSpike_Cross;       
VisualizeResult_Cross;
