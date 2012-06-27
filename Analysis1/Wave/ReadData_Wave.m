% ReadData_Wave.m %
% Load the Exported Data from TDT OpenEx using ASC¢ò Data type %

disp('  Reading Data ... ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DataMark=csvread([BlockName_Mark,'.csv'],1,3);    % Stimulus Marker with full tags
marker=DataMark(:,1)';
clear DataMark;
clear BlockName_Mark;
%-----------------------------------------------------
DataWave=csvread([BlockName_Wave,'.csv'],1,3);    % Wave with full tags
wave_time=DataWave(:,1)';                         % datapoint cluster time
samplefreq=DataWave(1,4);                         % datapoint sampling freqency
datapoint=DataWave(1,5);                          % number of datapoint of each time cluster
wave_data=DataWave(:,6:6+(datapoint-1))';         % waveform u-votage data
clear DataWave;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
