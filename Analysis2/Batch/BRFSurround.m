% BRFSurround.m %
% 2012/05/03 by Zhang Li
% Batch RF_Surround Blocks

if isempty(varargin)
    extent = 0; % ms
    delay = 0; % ms
    pret = 0;
    post = 0;
    isrmspike = 0;
else
    extent=varargin{1};
    delay = varargin{2};
    pret = varargin{3};
    post = varargin{4};
    if pret==0 && post==0
        isrmspike = 0;
    else
        isrmspike = 1;
    end
end

freqlim = [0 150];
ptrange = [30 100];

sn=size(SessionIndex,1);
% batch each session
for i=1:sn
    currentsubject = SessionIndex{i,1};
    currenttank = SessionIndex{i,2};
    currentsession = SessionIndex{i,3}.session;
    % reset session result for each new session
    muresult = [];
    suresult = [];
    lfpresult = [];
    
    tbi = cellfun(@(x)~isempty(x)&&strcmp(x.extype,'RF_Surround'),SessionIndex{i,3}.block);
    targetblock = SessionIndex{i,3}.block(tbi);
    bn = length(targetblock);
    % batch each valid block for current session
    for j=1:bn
        blockid = targetblock{j}.id;
        unitinfo = targetblock{j}.unitinfo;
        t = [currenttank,'__',currentsession,'-',num2str(blockid),'__',spevent];
        load(fullfile(rootpath,currentsubject,[t,'.mat']));
        disp('==============================================================================');
        disp(['RF_Surround Batching --> ',currentsubject,'__',t,' ...']);
        
        t= cellfun(@(x)strcmp(x,'TemporalFreq'),DataSet.Mark.ckey(:,1));
        t = DataSet.Mark.ckey{t,2};
        if t==0
            blocktype = 'static';
        else
            blocktype = 'drifting';
        end
        
        if strcmp(DataSet.Mark.ticktype,'one')
            blocktype = [blocktype,'_one'];
            continue;
        else
            blocktype = [blocktype,'_two'];
        end
        
        if isrmspike
            DataSet = PreProcess(DataSet,extent,delay,0,pret,post);
        else
            DataSet = PreProcess(DataSet,extent,delay,0);
        end
        % Processing Firing Rate Size Tuning
        sm = RFMap_Grating(DataSet,'Snip');
        % Processing LFP Power Size Tuning
        TW = 2.5;
        params.tapers = [TW 2*TW-1];
        params.Fs = DataSet.Wave.fs;
        params.fpass = freqlim;
        params.pad = 5;
        fm = RFMap_Grating(DataSet,'power',params,ptrange);
        
        for ch = 1:DataSet.Snip.chn
            % lfp result first
            sti = DataSet.Mark.condtable;
            ckey = DataSet.Mark.ckey;
            lfpresult{ch,1}.block{j}.blockid = blockid;
            lfpresult{ch,1}.block{j}.blocktype = blocktype;
            lfpresult{ch,1}.block{j}.sti = sti;
            lfpresult{ch,1}.block{j}.ckey = ckey;
            lfpresult{ch,1}.block{j}.fm = fm{ch,1};
            lfpresult{ch,1}.block{j}.mfm = squeeze(mean(fm{ch,1}));
            lfpresult{ch,1}.block{j}.sefm = squeeze(ste(fm{ch,1}));
            
            
            % mu result, treat Only One sort as MU, regardless of its real unittype
            for sort = DataSet.Snip.ppsortn(ch)
                
                % get size tuning result
                smm = sm{ch,sort};
                smm = reshape(smm,size(smm,1),[]);
                
                % if Cell Test Failed, exclude current block
                if celltest(smm,'t')
                    muresult{ch,1}.block{j}.sortid = sort; % PreProcessed Sort ID
                    
                    muresult{ch,1}.block{j}.blockid = blockid;
                    muresult{ch,1}.block{j}.blocktype = blocktype;
                    muresult{ch,1}.block{j}.sti = sti;
                    muresult{ch,1}.block{j}.ckey = ckey;
                    muresult{ch,1}.block{j}.sm = sm{ch,sort};
                    muresult{ch,1}.block{j}.msm = squeeze(mean(sm{ch,sort}));
                    muresult{ch,1}.block{j}.sesm = squeeze(ste(sm{ch,sort}));
                    
                     % Processing Spike Train Power Size Tuning
                    TW = 3.5;
                    params.tapers = [TW 2*TW-1];
                    params.Fs = 1000; %DataSet.Wave.fs;
                    params.fpass = freqlim;
                    params.pad = 5;
                    if issps
                        scpsd = pspt(DataSet,ch,sort,params);
                    else
                        scpsd = corrps([],DataSet,200,1,ch,sort,ch,sort);
                    end
                    for pti = 1:length(ptrange)
                        sctc{pti} = SCTC(scpsd,DataSet,ptrange);
                        csctc{pti} = ctc(sctc{pti},DataSet);
                    end
                    % Spike Train Power Spectrum
                    scps = getps(scpsd,freqlim);
                    [mps se trial] = fmean(scps{1}.data);
                    mps = nan20(mps);
                    se = nan20(se);
                    
                    muresult{ch,1}.block{j}.scps.trial = trial;
                    muresult{ch,1}.block{j}.scps.data = mps;
                    muresult{ch,1}.block{j}.scps.se = se;
                    muresult{ch,1}.block{j}.scps.frequencies = scps{end}.frequencies;
                    
                    for fb = 1:length(sctc)
                        tc = sctc{fb}{1};
                        [mtc setc] = fmean2(tc);
                        mtc = reshape(mtc,length(sti{2}),length(sti{1}))';
                        setc = reshape(setc,length(sti{2}),length(sti{1}))';
                        mtc = nan20(mtc);
                        setc = nan20(setc);
                        
                        muresult{ch,1}.block{j}.sctc{fb}.freqrange = sctc{fb}{2}.freqrange;
                        muresult{ch,1}.block{j}.sctc{fb}.mtc = mtc;
                        muresult{ch,1}.block{j}.sctc{fb}.setc = setc;
                    end
                    
                else
                    disp(['The neural signal in Ch-',num2str(ch),'__Sort-MU',...
                        ' is NOT significently modulated and will be deleted.']);
                end
            end
            
            % su result
            sua = unitinfo(ch,:); % current channal all sort
            sui = cellfun(@(x)~isempty(x)&&strcmpi(x.unittype,'su'),sua); % valid sort index
            su = sua(sui); % valid single-unit sort
            if ~isempty(su) % have valid sort
                sui = cellfun(@(x)x.sortid,su);
                for sort = sui
                    
                    % get size tuning result
                    smm = sm{ch,sort};
                    smm = reshape(smm,size(smm,1),[]);
                    
                    % if Cell Test Failed or maximum mean firing rate less than 10 spikes/sec, exclude current block
                    if celltest(smm,'t') %&& max(mtc) >= 10
                        % save valid single-unit info
                        suresult{ch,sort}.block{j}.unitinfo = unitinfo{ch,sort};
                        
                        suresult{ch,sort}.block{j}.blockid = blockid;
                        suresult{ch,sort}.block{j}.blocktype = blocktype;
                        suresult{ch,sort}.block{j}.sti = sti;
                        suresult{ch,sort}.block{j}.ckey = ckey;
                        suresult{ch,sort}.block{j}.sm = sm{ch,sort};
                        suresult{ch,sort}.block{j}.msm = squeeze(mean(sm{ch,sort}));
                        suresult{ch,sort}.block{j}.sesm = squeeze(ste(sm{ch,sort}));
                        
                    else
                        disp(['The neural signal in Ch-',num2str(ch),'__Sort-',num2str(sort),...
                            ' is NOT significently modulated and will be deleted.'])
                    end
                end
            end
            
            
        end
        
        % clear memory for efficiency
        clear DataSet sm fm smm;
    end
    
    % save critical session info
    sinfo.sessionindex = i;
    sinfo.session = currentsession;
    sinfo.site  = SessionIndex{i,3}.site;
    sinfo.subject = currentsubject;
    sinfo.datatank = currenttank;
    
    BRS{i,1} = sinfo;
    BRS{i,2}=muresult;
    BRS{i,3}=suresult;
    BRS{i,4}=lfpresult;
    
end

BRS{sn+1,1}.method = Method;
BRS{sn+1,1}.exid = str2double(exid);
BRS{sn+1,1}.extent = extent;
BRS{sn+1,1}.delay = delay;
BRS{sn+1,1}.pret = pret;
BRS{sn+1,1}.post = post;
BRS{sn+1,1}.rootpath = rootpath;
BRS{sn+1,1}.batchpath = batchpath;
BRS{sn+1,1}.spevent = spevent;
f = ['BRS_',num2str(extent),'_',num2str(delay),...
    '_',num2str(round(pret*10)),'_',num2str(round(post*10)),'.mat'];
save(fullfile(batchpath,f),'BRS');