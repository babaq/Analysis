% Sort.m %
% 2007-08-25
% Zhang Li

% Sort Function for re-save sorted spike to singel unit for further single
% unit analysis using TDT OpenEx ASC¢ò Data type

function Sort()
DataDir=input('Input The Data Directory : ','s');
cd (deblank(DataDir));
clear DataDir;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Experiment Block Name without suffix and file name extention which is '.csv'
BlockName=input('Input the Experiment Block Name : ','s');
% For Different Recording Conditions
RecordType=input('Input Recording Types -- Single(1) or Double(2) : ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for rt=1:RecordType
    if (RecordType==1)
        BlockName_Snip=['_',BlockName,'_snip_os'];
    else
        BlockName_Snip=['_',BlockName,'_sp',int2str(rt),'__os'];
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the Exported Data from TDT OpenEx using ASC¢ò Data type
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

s=length(spike);              % Get the number of spike snip

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

hWaitBar=waitbar(0,'Re-Saving SingleUnit Spikes ...');

% Cause the use of TDT OpenSorter we only analysis the singel unit with SortCode>=1
for j=1:Max_Sort
    sort_spike_name=['Spike_',int2str(j)];
    evalc([sort_spike_name,'=zeros(1,s)']);       % Create each sortcode spike 
    index=find(SnipSortCode==j);
    for i=1:length(index)
        evalc([sort_spike_name,'(',int2str(i),')','=spike','(',int2str(index(i)),')']);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    evalc(['spike_sort=Spike_',int2str(j),]);
    spike_sort_data=zeros(s,3);
    spike_sort_data(:,1)=spike_sort;
    spike_sort_data(:,3)=spike_sort*0+j;
        
    if (RecordType==1)
        dlmwrite(['_',BlockName,'_SC_',int2str(j),'_Snip_OS.csv'],spike_sort_data,'roffset',1,'coffset',3,'precision',15);
    else
        dlmwrite(['_',BlockName,'_SC_',int2str(j),'_Sp',int2str(rt),'__OS.csv'],spike_sort_data,'roffset',1,'coffset',3,'precision',15);
    end
    
    waitbar((j+1)/(Max_Sort+1),hWaitBar);
end

close(hWaitBar);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
