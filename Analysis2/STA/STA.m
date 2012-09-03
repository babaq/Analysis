function STA(DataSet,args)
% STA.m
% 2008-05-08 by Zhang Li
% Gate to STA GUI

global STAData;

if  isfield(DataSet,'Snip') && isfield(DataSet,'Wave') 
    
    STAData = DataSet;
    
    % GUI Interface to STA
    MainSTA;
else
    disp('Needed Data Incomplete !');
    errordlg('Need Both Snip and Wave Data !','Data Error');
end






