function sps = pspt(DataSet,ch,sort,varargin)
% pspt.m
% 2011-06-26 by Zhang Li
% Calculate Spike Train Power Spectrum

if ischar(sort)
    if strcmp(sort,'NOSORT')
        errordlg('NO SORT DATA TO SHOW !','Data Error ');
        return;
    end
    if strcmpi(sort,'MU')
        sort_n = 0;
    else
        sort_n = str2double(sort(3:end));
    end
else
    sort_n = sort;
end
if sort_n==0 % MU
    sort_n = DataSet.Snip.ppsortn(ch);
end
if nargin < 4
    bw = 0.001;
    TW = 3.5;
    params.tapers = [TW 2*TW-1];
    params.Fs = 1/bw;
    params.fpass = [0 200];
    params.pad = 5;
else
    params = varargin{1};
    bw = 1/params.Fs;
end

extent = DataSet.Dinf.extent;
delay = DataSet.Dinf.delay;
leastspike = 3;
ps = cell(DataSet.Mark.trial,DataSet.Mark.stimuli);
for s=1:DataSet.Mark.stimuli
    for t=1:DataSet.Mark.trial
        
        spike = DataSet.Snip.snip{ch,sort_n}.ppspike{t,s};
        spike = double(spike);
        %         if length(spike) >= leastspike
        %             onofftime = [DataSet.Mark.on(t,s)-extent+delay DataSet.Mark.off(t,s)+extent+delay];
        %             bst = binst(spike,onofftime,bw);
        %             [spec freq R] = mtspectrumpb(bst',params);
        %             ps{t,s}.frequencies = freq;
        %             ps{t,s}.data = spec/R;
        %         end
        if length(spike) >= leastspike
            [spec freq R] = mtspectrumpt(spike,params);
            ps{t,s}.frequencies = freq;
            ps{t,s}.data = spec/R;
        end
    end
end

sps{1} = ps;
sps{2}.params.ch = ch;
sps{2}.params.sort = sort;
