function wstps = stpsd(DataSet,window,step,varargin)
% stpsd.m
% 2011-04-16 by Zhang Li
% Calculate Short-Time Wave Power Spectrum

if isfield(DataSet,'Wave')
    if nargin < 4
        params.tapers = [4 7];
        params.Fs = DataSet.Wave.fs;
        params.fpass = [0 200];
        params.pad = 5;
    else
        params = varargin{1};
    end
    movingwin = [window step];
    
    %hWaitBar=waitbar(0,'Short-Time Wave Power Spectrum Analysis ... ');
    for i=1:DataSet.Wave.chn
        for s=1:DataSet.Mark.stimuli
            for t=1:DataSet.Mark.trial
                
                w = DataSet.Wave.wave{i}.ppwave{t,s};
                [spec time freq] = mtspecgramc(w,movingwin/1000,params);
                wstps{i}{t,s}.frequencies = freq;
                wstps{i}{t,s}.data = spec;
                wstps{i}{t,s}.time = time;
            end
        end
        %waitbar(i/DataSet.Wave.chn,hWaitBar);
    end
    %close(hWaitBar);
    
    wstps{DataSet.Wave.chn+1}.movingwin = movingwin;
    
else
    disp('No Valid Data !');
    warndlg('No Valid Data !','Warnning');
end
