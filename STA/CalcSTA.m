function stadata = CalcSTA(DataSet,hseg_n,extent_n,delay_n,ch_w)
% CalcSTA.m
% 2011-03-27 by Zhang Li
% Spike-Tiggered Averaing Function

tw = twave(DataSet,hseg_n,extent_n,delay_n,ch_w);

for i=1:DataSet.Snip.chn
    for j=1:DataSet.Snip.ppsortn(i)
        for s=1:DataSet.Mark.stimuli
            twdata = [];
            for t=1:DataSet.Mark.trial
                twdata = cat(1,twdata,tw{i,j}{t,s});
            end
            stadata{i,j}{s} = twdata;
        end
    end
end