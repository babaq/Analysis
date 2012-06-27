function tdata = STC(DataSet)
% STC.m
% 2008-09-10 by Zhang Li
% TuningCurve Function for Different Stimuli Modulation


msegt = DataSet.Dinf.msegt;

for i=1:DataSet.Snip.chn
    for j=1:DataSet.Snip.ppsortn(i);
        tdata{i,j}=zeros(DataSet.Mark.trial,DataSet.Mark.stimuli);
    end
end

for i=1:DataSet.Snip.chn
    for j=1:DataSet.Snip.ppsortn(i);
        for t=1:DataSet.Mark.trial
            for s=1:DataSet.Mark.stimuli

                spike = DataSet.Snip.snip{i,j}.ppspike{t,s};
                spike_count=length(spike(spike~=0));
                tdata{i,j}(t,s)=spike_count/msegt;

            end
        end
    end
end

tdata{DataSet.Snip.chn+1,1}.tmtype = 'mfr';

