function Batch(Method,TargetIndex,varargin)
% Batch.m %
% 2011-04-02 Zhang Li
% Batch Analysis


Method = lower(Method);
blocktypeerror = 0;

if isempty(TargetIndex)
    [sifilename,rootpath] = uigetfile({'*.mat';'*.*'},'MultiSelect', 'off','Select SessionIndex');
    t1 = findstr('__',sifilename);
    t2 = findstr('.',sifilename);
    f = sifilename(1:t2(end)-1);
    exid = sifilename(t1(1)+2:t1(2)-1);
    blocktype = sifilename(t1(2)+2:t1(3)-1);
    spevent = sifilename(t1(3)+2:t2(end)-1);
    SessionIndex = load(fullfile(rootpath,sifilename));
    SessionIndex = SessionIndex.(f);
    batchpath=fullfile(rootpath,['BatchResult_',exid],spevent);
    if ~exist(batchpath,'dir')
        mkdir(batchpath);
    end
    
    switch Method
        case 'st'
            if strcmpi(blocktype,'ALL') || strcmpi(blocktype,'RF_Size')
                BSizeTuning;
            else
                blocktypeerror = 1;
            end
        case 'dg'
            if strcmpi(blocktype,'ALL') || strcmpi(blocktype,'mdGrating')
                BDGrating;
            else
                blocktypeerror = 1;
            end
        case 'sfc'
            BSFC;
        case 'fp'
            BFiringPhase;
        case 'ft'
            BFiltering;
        case 'cs'
            if strcmpi(blocktype,'ALL') || strcmpi(blocktype,'RF_Size')
                BCenterSurround;
            else
                blocktypeerror = 1;
            end
        case 'rs'
            if strcmpi(blocktype,'ALL') || strcmpi(blocktype,'RF_Surround')
                BRFSurround;
            else
                blocktypeerror = 1;
            end
        case 'stsc'
            BSTsc;
    end
else
    switch Method
        case 'sfc'
            TBSFC;
    end
end

if blocktypeerror
    disp('SessionIndex Has No Valid Block Type Info !');
    errordlg('SessionIndex Has No Valid Block Type Info !','Block Type Error');
end