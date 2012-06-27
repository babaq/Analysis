function Batch()
% Batch.m %
% 2007 July 17 by Zhang Li
% Batch Data through BatchList files and Save the Batch Results
% in Microsoft Excel (.xls) spreadsheet files

cd (deblank('E:\Experiment\Exported Data\BatchList_Files')); % where the BatchList file is 

% BatchList file name without extention ".txt"
BatchList_name=input('Input the Full BatchList File Name : ','s'); 
fid=fopen([BatchList_name,'.txt']);
BatchList=textscan(fid,'%q %q %q %q');
fclose(fid);

%cd ..

ListSize=length(BatchList{1,1}); % How many Data files to be processed

hWaitBar=waitbar(0,'Processing  ...');

% Structure for transform the parameters
para_struct.BatchList_name=BatchList_name;
para_struct.BatchList_DataDir='NULL';
para_struct.BatchList_MarkerName='NULL';
para_struct.BatchList_SnipName='NULL';
para_struct.BatchList_StiType='NULL';
para_struct.DataIndex=0;

clear BatchList_name;

for ls=1:ListSize
    para_struct.BatchList_DataDir=BatchList{1,1}{ls,1};
    para_struct.BatchList_MarkerName=BatchList{1,2}{ls,1};
    para_struct.BatchList_SnipName=BatchList{1,3}{ls,1};
    para_struct.BatchList_StiType=BatchList{1,4}{ls,1};
    para_struct.DataIndex=ls;
    
    % Do corresponding analysis
    method=para_struct.BatchList_StiType;
    switch method
        case 'B_Grating'
            B_Grating(para_struct);
        case 'B_Plaid'
            B_Plaid(para_struct);
        case 'B_RandomLine'
            B_RandomLine(para_struct);
        otherwise
                       
    end
                   
    waitbar(ls/ListSize,hWaitBar,['Processing  ',int2str(ls+1),'/',int2str(ListSize),'  ...']);
    
end
    
close(hWaitBar);

%%%%%%%%%%%%%-----BatchList File Format-----%%%%%%%%%%%%%%%%
 
 % DataDir   MarkerName    SnipName     StiType
 %  "..."      "..."        "..."        "..."
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % DataDir is the Full Directory in which Data file located 
 
 % MarkerName is the marker file without "_mark.csv" suffix and it is also
 % the Experiment Block Name which is also the Experiment Stimulus
 % parameter file name
 
 % SnipName is the snip file name only without the file extention ".csv"
 
 % StiType is the Experiment Stimulus Type which is also the corresponding
 % analysis program function name
 