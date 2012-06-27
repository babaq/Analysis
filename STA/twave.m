function tw = twave(DataSet,hseg_n,extent_n,delay_n,ch_w)
% twave.m
% 2011-03-27 by Zhang Li
% Organize Spike Triggered Wave Segment

if ~isfield(DataSet.Snip,'ppsortn')
    DataSet = PreProcess(DataSet,extent_n,delay_n,1);
end
ext = 1.5;
wextent_n = ext*hseg_n+extent_n;
ppdsw = PreProcess(DataSet,wextent_n,delay_n,2);
hsegn = hseg_n/1000; % sec
wextentn = wextent_n/1000; % sec
delayn = delay_n/1000; % sec

segl = floor(hsegn*2*DataSet.Wave.fs);
if mod(segl,2)==0
    segl = segl + 1;
end

for i=1:DataSet.Snip.chn
    
    if ch_w==0 % For Each Same Channal
        chw = i;
    else
        chw = ch_w;
    end
    
    for j=1:DataSet.Snip.ppsortn(i)
        for s=1:DataSet.Mark.stimuli
            for t=1:DataSet.Mark.trial
                st = DataSet.Snip.snip{i,j}.ppspike{t,s};
                for k=1:length(st)
                    stastart = st(k)-hsegn;
                    wstart = DataSet.Mark.on(t,s)-wextentn+delayn;
                    a = round((stastart-wstart)*DataSet.Wave.fs);
                    b = a+segl-1;
                    tw{i,j}{t,s}(k,:) = ppdsw.Wave.wave{chw}.ppwave{t,s}(a:b);
                end
            end
        end
    end
end