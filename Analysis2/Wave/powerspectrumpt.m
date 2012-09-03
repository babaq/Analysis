function sps = powerspectrumpt(DataSet,varargin)
% powerspectrumpt.m
% 2011-07-15 by Zhang Li
% Calculate Spike Train Power Spectrum

if isfield(DataSet,'Snip')
    if nargin < 2
        params.tapers = [4 7];
        params.Fs = DataSet.Snip.fs;
        params.fpass = [0 200];
        params.pad = 5;
    else
        params = varargin{1};
    end
    
    %hWaitBar=waitbar(0,'Spike Train Power Spectrum Analysis ... ');
    for i=1:DataSet.Snip.chn
        for j=1:DataSet.Snip.ppsortn(i)
            for s=1:DataSet.Mark.stimuli
                for t=1:DataSet.Mark.trial
                    
                    spike = DataSet.Snip.snip{i,j}.ppspike{t,s};
                    [spec freq] = mtspectrumpt(spike,params);
                    sps{i,j}{t,s}.frequencies = freq;
                    sps{i,j}{t,s}.data = spec;
                end
            end
        end
        %waitbar(i/DataSet.Snip.chn,hWaitBar);
    end
    %close(hWaitBar);
    
    sps{DataSet.Snip.chn+1,1}.pstype = 'ps';
else
    disp('No Valid Data !');
    warndlg('No Valid Data !','Warnning');
end
