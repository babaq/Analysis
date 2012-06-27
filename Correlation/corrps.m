function scps = corrps(cdata,DataSet,lag_n,bin_n,ch_n1,sort1,ch_n2,sort2)
% corrps.m
% 2011-03-26 by Zhang Li
% Calculate Spike Train Correlation Power Spectrum

if nargin > 2
    cdata = CalcCorr(DataSet,lag_n,bin_n,ch_n1,sort1,ch_n2,sort2,1);
end

params.tapers = [2 3];
params.Fs = 1000/cdata.params.bin_n;
params.fpass = [0 200];
params.pad = 5;

for s=1:DataSet.Mark.stimuli
    for t=1:DataSet.Mark.trial
        
        sc = squeeze(cdata.data(t,s,:));
        [spec freq] = mtspectrumc(sc,params);
        scps{1}{t,s}.frequencies = freq;
        scps{1}{t,s}.data = spec;
    end
end

scps{2}.params = cdata.params;
