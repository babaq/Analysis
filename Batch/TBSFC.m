% TBSFC.m %
% 2011-04-24 by Zhang Li
% Batch Spike Field Coherence according to TargetIndex

if isempty(varargin)
    ch_w = 0; % each channal wave
    sfctype = 'sfc';
    pret = 0;
    post = 0;
    isrmspike = 0;
else
    ch_w = varargin{1};
    sfctype = varargin{2};
    pret = varargin{3};
    post = varargin{4};
    if pret==0 && post==0
        isrmspike = 0;
    else
        isrmspike = 1;
    end
end

method = TargetIndex{end,1}.method;
extent = TargetIndex{end,1}.extent;
delay = TargetIndex{end,1}.delay;
switch method
    case 'st'
        stiparam = TargetIndex{end,1}.stiend;
    case 'dg'
        stiparam = TargetIndex{end,1}.stin;
end
rootpath = TargetIndex{end,1}.rootpath;
batchpath = TargetIndex{end,1}.batchpath;
unit = TargetIndex{end,1}.unit;
stitype = TargetIndex{end,1}.stitype;
freqrange = TargetIndex{end,1}.freqrange;
spevent = TargetIndex{end,1}.spevent;
issps = TargetIndex{end,1}.issps;

freqlim = [0 150];

sn=size(TargetIndex,1)-1;
% batch each session
vsn=1;
for i=1:sn
    ti = TargetIndex{i,1};
    currentsubject = ti.subject;
    currenttank = ti.datatank;
    currentsession = ti.session;
    blockid = ti.blockid;
    ch = ti.ch;
    sort = ti.sortid;
    
    t = [currenttank,'__',currentsession,'-',num2str(blockid),'__',spevent];
    load(fullfile(rootpath,currentsubject,[t,'.mat']));
    disp('==============================================================================');
    disp([upper(method),'->SFC Target Batching --> ',currentsubject,'__',t,' ...']);
    
    if isrmspike
        DataSet = PreProcess(DataSet,extent,delay,0,pret,post);
    else
        DataSet = PreProcess(DataSet,extent,delay,0);
    end
    if ch_w==0 % each channal
        chw = ch;
    else
        chw = ch_w;
    end
    % Processing Spike Field Coherence
    switch sfctype
        case 'sfc'
            TW = 5;
            params.tapers = [TW 2*TW-1];
            params.Fs = DataSet.Wave.fs;
            params.fpass = freqlim;
            params.pad = 5;
            
            sfcdata = sfc(DataSet,ch,sort,chw,params);
            sfcs = getps(sfcdata,freqlim);
            
            [mcs cse trial] = fmean(sfcs{1}.data);
            [mps psd trial] = fmean(sfcs{1}.phase,'c');
            [mcs isn]= nan20(mcs);
            [cse isn] = nan20(cse);
            [mps isn]= nan20(mps);
            [psd isn] = nan20(psd);
            if isn
                disp('Warning, NaN Convert to 0 !');
            end
            
            ti.c = sfcs{1}.data;
            ti.p = sfcs{1}.phase;
            ti.trial = trial;
            ti.data = mcs;
            ti.se = cse;
            ti.phase = mps;
            ti.psd = psd;
            ti.frequencies = sfcs{end}.frequencies;
            
            TBESFC{vsn,1} = ti;
            vsn = vsn + 1;
            
        case 'stasfc'
            sfcdata  = stasfc(DataSet,100,extent,delay,ch,sort,chw);
            
            X = sfcdata{end}.frequencies;
            freqindex = (X>=0) & (X<=150);
            ti.frequencies = X(freqindex);
            C = sfcdata{1}.data;
            P = sfcdata{1}.phase;
            for s=1:length(C)
                tempc = C{s}(:,freqindex);
                tempc = double(fm(tempc));
                trial = size(tempc,1);
                % excluded none significent coherence block
                if trial >= 5
                    ti.trial(s) = trial;
                    ti.data(s,:) = abs(mean(tempc,1));
                    tempp = P{s}(:,freqindex);
                    tempp = double(fm(tempp));
                    ti.phase(s,:) = circ_mean(tempp,[],1);
                end
            end
            TBESFC{vsn,1} = ti;
            vsn = vsn + 1;
    end
    
    % clear memory for efficiency
    clear DataSet sfcdata sfcs cs ps C P;
    
end

TBESFC{vsn,1} = TargetIndex{end,1};
TBESFC{vsn,1}.ch_w = ch_w;
TBESFC{vsn,1}.sfctype = sfctype;
TBESFC{vsn,1}.pret = pret;
TBESFC{vsn,1}.post = post;

save(fullfile(batchpath,...
    ['TB',upper(method),upper(Method),'_',num2str(extent),'_',num2str(delay),'_',num2str(stiparam),...
    '_',num2str(issps),'_',num2str(round(pret*10)),'_',num2str(round(post*10)),...
    '_',unit,'_',stitype,'_',num2str(freqrange),...
    '_',num2str(ch_w),'_',sfctype,'.mat']),...
    'TBESFC');