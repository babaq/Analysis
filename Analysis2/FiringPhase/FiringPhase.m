function FiringPhase(DataSet,args)
% FiringPhase.m
% 2008-10-17 by Zhang Li
% Gate to FiringPhase GUI

global FPData;

if ( isfield(DataSet,'Snip') && isfield(DataSet.Wave,'phase') )
    
    FPData = DataSet;
    
    % GUI Interface to FiringPhase
    MainFPhase;
else
    disp('Needed Data Incomplete !');
    errordlg('Need Both Snip and WavePhase Data !','Data Error');
end

end % end of function





