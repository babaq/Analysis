function wps = powerspectrum(DataSet,which,varargin)
% powerspectrum.m
% 2011-03-15 by Zhang Li
% Calculate Wave Power Spectrum

if isfield(DataSet,'Wave')
    if nargin < 3
        if nargin<2
            selection = questdlg('Which Power Spectrum ?',...
                'Multitaper Power Spectrum',...
                'PowerSpectrum','PowerSpectrumDensity','PowerSpectrum');
            
            if strcmp(selection,'PowerSpectrum')
                which = 'ps';
            else
                which = 'psd';
            end
        end
        
        TW = 2.5;
        params.tapers = [TW 2*TW-1];
        params.Fs = DataSet.Wave.fs;
        params.fpass = [0 200];
        params.pad = 5;
    else
        params = varargin{1};
    end
    
    switch which
        case 'ps'
            
            %hWaitBar=waitbar(0,'Wave Power Spectrum Analysis ... ');
            for i=1:DataSet.Wave.chn
                for s=1:DataSet.Mark.stimuli
                    for t=1:DataSet.Mark.trial
                        
                        w = DataSet.Wave.wave{i}.ppwave{t,s};
                        [spec freq] = mtspectrumc(w,params);
                        wps{i}{t,s}.frequencies = freq;
                        wps{i}{t,s}.data = spec;
                    end
                end
                %waitbar(i/DataSet.Wave.chn,hWaitBar);
            end
            %close(hWaitBar);
            
            wps{DataSet.Wave.chn+1}.pstype = 'ps';
        case 'psd'
            pm = spectrum.mtm(params.tapers(1),'adapt');
            
            %hWaitBar=waitbar(0,'Wave Power Spectrum Density Analysis ... ');
            for i=1:DataSet.Wave.chn
                for s=1:DataSet.Mark.stimuli
                    for t=1:DataSet.Mark.trial
                        
                        w = DataSet.Wave.wave{i}.ppwave{t,s};
                        N = length(w);
                        nfft = max(N,2^(nextpow2(N)+params.pad));
                        wps{i}{t,s} = psd(pm,w,'Fs',params.Fs,'NFFT',nfft,'ConfLevel',0.95);
                    end
                end
                %waitbar(i/DataSet.Wave.chn,hWaitBar);
            end
            %close(hWaitBar);
            
            wps{DataSet.Wave.chn+1}.pstype = 'psd';
    end
    
else
    disp('No Valid Data !');
    warndlg('No Valid Data !','Warnning');
end
