function sfcdata = stasfc(DataSet,hseg_n,extent_n,delay_n,ch_s,sorts,ch_w)
% stasfc.m
% 2011-05-22 by Zhang Li
% Spike Field Coherence Function via spike-triggered averaging


stadata = CalcSTA(DataSet,hseg_n,extent_n,delay_n,ch_w);

if ischar(sorts)
    if strcmpi(sorts,'MU')
        sort_n=DataSet.Snip.ppsortn(ch_s);
    else
        sort_n = str2double(sorts(3:end));
    end
else
    sort_n = sorts;
end

Fs = DataSet.Wave.fs;
hsegn = hseg_n/1000; % sec
segl = floor(hsegn*2*Fs);
if mod(segl,2)==0
    segl = segl + 1;
end

tapers = dpsschk([4 7],segl,Fs);
nfft = max(2^(nextpow2(segl)+2),segl);
f = Fs/2*linspace(0,1,nfft/2+1);
freqindex = (f>=0) & (f<=200);

for s=1:DataSet.Mark.stimuli
    trign = size(stadata{ch_s,sort_n}{s},1);
    for t=1:trign
        ws = stadata{ch_s,sort_n}{s}(t,:);
        spec = mtfftc(ws,tapers,nfft,Fs);
        spec = mean(spec,2);
        spec = spec(1:nfft/2+1);
        phase = angle(spec);
        data = spec./abs(spec);
        sfcdata{1}.phase{s}(t,:) = phase(freqindex);
        sfcdata{1}.data{s}(t,:) = data(freqindex);
    end
end

sfcdata{2}.params.ch_s = ch_s;
sfcdata{2}.params.sorts = sorts;
sfcdata{2}.params.ch_w = ch_w;
sfcdata{2}.frequencies = f(freqindex);
sfcdata{2}.params.type = 'stasfc';
