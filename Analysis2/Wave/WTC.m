function tdata = WTC(DataSet,type,psd,freq_range)
% WTC.m
% 2011-03-13 by Zhang Li
% Wave TuningCurve Function for Different Stimuli Modulation


for i=1:DataSet.Wave.chn
    tdata{i,1}=zeros(DataSet.Mark.trial,DataSet.Mark.stimuli);
end
%% Measure Wave RMS
if strcmpi(type,'rms')
    for i=1:DataSet.Wave.chn
        for s=1:DataSet.Mark.stimuli
            for t=1:DataSet.Mark.trial
                tdata{i,1}(t,s) = rms(DataSet.Wave.wave{i}.ppwave{t,s});
            end
        end
    end
    tdata{DataSet.Wave.chn+1,1}.tmtype = type;
end


%% Measure Wave Average Power Under Certain Frequency Range
if strcmpi(type,'power')
    
    if nargin>2
        wps = psd;
    else
        wps = powerspectrum(DataSet);
    end
    pstype = wps{end}.pstype;
    
    if nargin <4
        prompt = {'Start Freq{ 1 - 200 } : ','End Freq{ 1 - 200 } : '};
        dlg_title = 'Average Power Frequency Range';
        num_lines = 1;
        def = {'1','200'};
        input = inputdlg(prompt,dlg_title,num_lines,def);
        freqrange = [str2double(input{1}) str2double(input{2})];
    else
        freqrange = freq_range;
    end
    
    
    if strcmpi(pstype,'ps')
        ps = getps(wps,freqrange);
        for i=1:DataSet.Wave.chn
            for s=1:DataSet.Mark.stimuli
                for t=1:DataSet.Mark.trial
                    tdata{i,1}(t,s) = sum(squeeze(ps{i}.data(t,s,:)));
                end
            end
        end
        tdata{DataSet.Wave.chn+1,1}.tmtype = 'pspower';
    else
        for i=1:DataSet.Wave.chn
            for s=1:DataSet.Mark.stimuli
                for t=1:DataSet.Mark.trial
                    tdata{i,1}(t,s) = avgpower(wps{i}{t,s},freqrange);
                end
            end
        end
        tdata{DataSet.Wave.chn+1,1}.tmtype = 'psdpower';
    end
    
    tdata{DataSet.Wave.chn+1,1}.freqrange = freqrange;
end