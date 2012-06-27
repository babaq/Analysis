% ReadData_Cross.m %
% Load the Exported Data from TDT OpenEx using ASC¢ò Data type

MarkerName=input('Input the Data Marker Name : ','s');
DataName_mark=['_',MarkerName,'_mark.csv'];
Spike1Name=input('Input the Data Spike1 Name : ','s');
DataName_spike1=['_',Spike1Name,'_os.csv'];
Spike2Name=input('Input the Data Spike2 Name : ','s');
DataName_spike2=['_',Spike2Name,'_os.csv'];

disp('  Reading Data ... ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DataMark=csvread(DataName_mark,1,3);        % Stimulus Marker with full tags
marker=DataMark(:,1)';
clear MarkerName;
clear DataName_mark;
clear DataMark;
%-----------------------------------------------------
DataSnip1=csvread(DataName_spike1,1,3);     % Spike Snip1 with full tags
spike1=DataSnip1(:,1)';                                                                
clear DataSnip1;
clear DataName_spike1;
%-----------------------------------------------------
DataSnip2=csvread(DataName_spike2,1,3);     % Spike Snip2 with full tags
spike2=DataSnip2(:,1)';                                                                 
clear DataSnip2;
clear DataName_spike2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
