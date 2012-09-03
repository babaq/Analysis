function sfcdata = sfc(DataSet,ch_s,sorts,ch_w,varargin)
% sfc.m
% 2011-03-22 by Zhang Li
% Spike Field Coherency Function


extent = DataSet.Dinf.extent;
delay = DataSet.Dinf.delay;
if isfield(DataSet,'Wave') && isfield(DataSet,'Snip')
    if nargin < 5
        TW = 5;
        params.tapers = [TW 2*TW-1];
        params.Fs = DataSet.Wave.fs;
        params.fpass = [0 200];
        params.pad = 5;
    else
        params = varargin{1};
    end
    bw = 1/params.Fs;
    if ischar(sorts)
        if strcmpi(sorts,'MU')
            sort_n=DataSet.Snip.ppsortn(ch_s);
        else
            sort_n = str2double(sorts(3:end));
        end
    else
        sort_n = sorts;
    end
    
    for s=1:DataSet.Mark.stimuli
        for t=1:DataSet.Mark.trial
            
            w = DataSet.Wave.wave{ch_w}.ppwave{t,s};
            st = DataSet.Snip.snip{ch_s,sort_n}.ppspike{t,s};
            
%             onofftime = [DataSet.Mark.on(t,s)-extent+delay DataSet.Mark.off(t,s)+extent+delay];
%             st = binst(st,onofftime,bw);
%             dl = min(length(w),length(st));
%             w = w(1:dl);
%             st = st(1:dl);
%             [c phi s12 s1 s2 f] = coherencycpb(w,st',params);
            
            st = st - (DataSet.Mark.on(t,s)-extent+delay);
            [c phi s12 s1 s2 f] = coherencycpt(w,st',params);
            
            sfcdata{1}{t,s}.phase = phi;
            sfcdata{1}{t,s}.frequencies = f;
            sfcdata{1}{t,s}.data = c;
        end
    end
    
    sfcdata{2}.params.ch_s = ch_s;
    sfcdata{2}.params.sorts = sorts;
    sfcdata{2}.params.ch_w = ch_w;
    sfcdata{2}.params.type = 'sfc';
    
else
    disp('No Valid Data !');
    warndlg('No Valid Data !','Warnning');
end
