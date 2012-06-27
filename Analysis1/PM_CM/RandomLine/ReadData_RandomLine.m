% ReadData_RandomLine.m %

% Load the Exported Data from TDT OpenEx using ASC¢ò Data file type %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read Specific Data from the Input Data Files %
disp('  Reading Data ... ');
DataMark=csvread([BlockName_Mark,'.csv'],1,3);             % Stimulus Marker with full tags
marker=DataMark(:,1)';
clear DataMark;
%-----------------------------------------------------------
DataSnip=csvread([BlockName_Snip,'.csv'],1,3);             % Spike Snip with full tags
spike=DataSnip(:,1)';                                      % Spike SortCode_All
SnipSortCode=DataSnip(:,3)';                               % Spike SortCode
clear DataSnip;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Max_Sort=max(SnipSortCode);

if(Max_Sort==31)      % Check if sorted spike have overlap(using TDT OpenSorter)
    disp('    Spike Overlap Occurred !');
    disp('    Treat Overlap as Unsorted(sortcode_0) !');
end

s=length(spike);              % Get the number of spike snip times(sec)

index=find(SnipSortCode==31);
for i=1:length(index)
    SnipSortCode(index(i))=0;    % Treat Overlap as unsorted(SortCode=0)
end

Max_Sort=max(SnipSortCode);  %  Refresh overlap handled new Max_Sort

if(Max_Sort>=31)               % Check if Spike Sorting is correct
    disp('           SortCode Error -- Too many SortCode !');
    disp('  Max_Sort');
    disp(Max_Sort);
    break;
end

hWaitBar=waitbar(0,'Reading Spikes ...');

for j=0:Max_Sort
    sort_spike_name=['Spike_',int2str(j)];
    evalc([sort_spike_name,'=zeros(1,s)']);       % Create each sortcode spike 
    index=find(SnipSortCode==j);
    for i=1:length(index)
        evalc([sort_spike_name,'(',int2str(i),')','=spike','(',int2str(index(i)),')']);
    end
        waitbar((j+1)/(Max_Sort+1),hWaitBar);
end

close(hWaitBar);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




