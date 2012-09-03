function tdata = SCTC(scps,DataSet,freqrange,lag_n,bin_n,ch_n1,sort1,ch_n2,sort2)
% SCTC.m
% 2011-03-28 by Zhang Li
% Spike Trian Correlation Power TuningCurve Function

if nargin < 3
    prompt = {'Start Freq{ 1 - 200 } : ','End Freq{ 1 - 200 } : '};
    dlg_title = 'Spike Train Correlation Power Tuning Curve';
    num_lines = 1;
    def = {'1','200'};
    input = inputdlg(prompt,dlg_title,num_lines,def);
    freqrange(1) = str2double(input{1});
    freqrange(2) = str2double(input{2});
elseif nargin > 3
    scps = corrps([],DataSet,lag_n,bin_n,ch_n1,sort1,ch_n2,sort2);
end

ps = getps(scps,freqrange);
power = double(ps{1}.data);
trial = size(power,1);
stimuli = size(power,2);
for s=1:stimuli
    for t=1:trial
        tdata{1,1}(t,s) = sum(squeeze(power(t,s,:)));
    end
end
tdata{2,1}.params = ps{2}.params;
tdata{2,1}.freqrange = freqrange;



