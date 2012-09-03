function sfcs = SSFC(SFC)
% SSFC.m %
% 2010/10/12 by Zhang Li
% Statistics of Batched Size Tuning Spike Field Coherence

sn = size(SFC,1)-2;
freq = SFC{end,1};
freqrange = SFC{end-1,1};
stin = 21;

freqindex = (freq>=freqrange(1)) & (freq<=freqrange(2));
freq = freq(freqindex);
fn = length(freq);
temp = zeros(sn,fn,stin);

for i = 1:sn
    for s = 1:stin
        t=SFC{i,1}.sfc{s};
        temp(i,:,s)=t(freqindex);
    end
end

sfcs.sfc = temp;
sfcs.freq = freq;
