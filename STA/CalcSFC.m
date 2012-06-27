function sfcdata = CalcSFC(DataSet,seg_n,ch_w,Method)
% CalcSFC.m
% 2010-09-22 by Zhang Li
% Spike Field Coherence Function

if nargin<4
    selection = questdlg('Which Power Spectral Density Method To Use ?',...
        'PSD',...
        'Multitaper','Modified Covariance','Multitaper');
    
    if strcmp(selection,'Multitaper')
        pm = spectrum.mtm(2,'adapt');
    else
        pm = spectrum.mcov(35);
    end
else
    Method = lower(Method);
    switch Method
        case 'mtm'
            pm = spectrum.mtm(2,'adapt');
        case 'mcov'
            pm = spectrum.mcov(35);
    end
end

stop_freq = 102;
stadata = CalcSTA(DataSet,seg_n,ch_w);
sfcdata = cell(DataSet.Snip.chn+1,max(DataSet.Snip.sortn)+1,DataSet.Mark.stimuli);

seg_l = floor((seg_n*2/1000)*DataSet.Wave.fs);
if mod(seg_l,2)==0
    seg_l = seg_l + 1;
end

for i=1:DataSet.Snip.chn
    for j=1:DataSet.Snip.sortn(i)
        for s=1:DataSet.Mark.stimuli
            stwdata=stadata{i,j,s};
            if isempty(stwdata)
                stwdata = zeros(1,seg_l);
            end
            
            for t=1:size(stwdata,1);
                stwp = psd(pm,squeeze(stwdata(t,:)),...
                    'Fs',DataSet.Wave.fs,'NFFT','Nextpow2','ConfLevel',0.95);
                if isempty(sfcdata{end,1,1})
                    freqindex = stwp.frequencies<=stop_freq;
                    sfcdata{end,1,1}=stwp.frequencies(freqindex);
                end
                sfcdata{i,j,s}.stwp(t,:)=stwp.data(freqindex);
            end
            sfcdata{i,j,s}.stw = stwdata;
            sta = mean(stwdata,1);
            sfcdata{i,j,s}.sta = sta;
            stap = psd(pm,squeeze(sta),...
                'Fs',DataSet.Wave.fs,'NFFT','Nextpow2','ConfLevel',0.95);
            sfcdata{i,j,s}.stap(1,:) = stap.data(freqindex);
            sfcdata{i,j,s}.sfc = sfcdata{i,j,s}.stap./mean(sfcdata{i,j,s}.stwp,1);
        end
    end
end

for i=1:DataSet.Snip.chn
    for s=1:DataSet.Mark.stimuli
        stwdata=stadata{i,end,s};
        if isempty(stwdata)
            stwdata = zeros(1,seg_l);
        end
        
        sfcdata{i,end,s}.stwp = sfcdata{i,1,s}.stwp;
        for j=2:DataSet.Snip.sortn(i)
            sfcdata{i,end,s}.stwp = cat(1,sfcdata{i,end,s}.stwp,sfcdata{i,j,s}.stwp);
        end
        
        sfcdata{i,end,s}.stw = stwdata;
        sta = mean(stwdata,1);
        sfcdata{i,end,s}.sta = sta;
        stap = psd(pm,squeeze(sta),...
            'Fs',DataSet.Wave.fs,'NFFT','Nextpow2','ConfLevel',0.95);
        sfcdata{i,end,s}.stap(1,:) = stap.data(freqindex);
        sfcdata{i,end,s}.sfc = sfcdata{i,end,s}.stap./mean(sfcdata{i,end,s}.stwp,1);
    end
end

