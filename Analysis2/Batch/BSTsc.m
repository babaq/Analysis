% BSizeTuning.m %
% 2012-04-03 by Zhang Li
% Batch Size Tuning simple-complex cell
import Analysis.Core.*

if isempty(varargin)
    extent = 0; % ms
    delay = 0; % ms
    stiend = 30; % possible maximum size(degree)
    issps = 0; % which spike train spectrum method
    pret = 0;
    post = 0;
    isrmspike = 0;
else
    extent=varargin{1};
    delay = varargin{2};
    stiend = varargin{3};
    issps = varargin{4};
    pret = varargin{5};
    post = varargin{6};
    if pret==0 && post==0
        isrmspike = 0;
    else
        isrmspike = 1;
    end
end

freqlim = [0 150];
ptrange{1} = [15 30];
ptrange{2} = [30 100];
ptrange{3} = [100 150];

% ptrange{1} = [30 60];
% ptrange{2} = [60 100];

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
    
    tbi = cellfun(@(x)~isempty(x)&&strcmp(x.extype,'RF_Size'),SessionIndex{i,3}.block);
    targetblock = SessionIndex{i,3}.block(tbi);
    bn = length(targetblock);
    % batch each valid block for current session
    for j=1:bn
        blockid = targetblock{j}.id;
        unitinfo = targetblock{j}.unitinfo;
        t = [currenttank,'__',currentsession,'-',num2str(blockid),'__',spevent];
        load(fullfile(rootpath,currentsubject,[t,'.mat']));
        disp('==============================================================================');
        disp(['Size Tuning Batching --> ',currentsubject,'__',t,' ...']);
        
        t= cellfun(@(x)strcmp(x,'TemporalFreq'),DataSet.Mark.ckey(:,1));
        tf = DataSet.Mark.ckey{t,2};
        if tf==0
            blocktype = 'static';
            continue;
        else
            blocktype = 'drifting';
        end
        
            DataSet = PreProcess(DataSet,extent,delay,1);
        
        
        stc = STC(DataSet);
        bin = 5; % ms
        psthdata = CalcPSTH(DataSet,bin);
        
        
        for ch = 1:DataSet.Snip.chn
            
            % mu result, treat Only One sort as MU, regardless of its real unittype
            for sort = DataSet.Snip.ppsortn(ch)
                
                % get size tuning result
                tc = stc{ch,sort};
                pd = psthdata{ch,sort};
                
                % if Cell Test Failed, exclude current block
                if celltest(tc,'t')
                    muresult{ch,1}.block{j}.sortid = sort; % PreProcessed Sort ID
                    
                    mtc = mean(tc,1);
                    os = find(mtc==max(mtc(2:end)));
                    ifr = squeeze(mean(pd));
                    blank = mean(ifr(1,:));
                    cn = floor(1000/tf/bin);
                    ca = cac(ifr(os,:)-blank,cn);
                    [f0 , f1] = f0f1(ca);
                    
                    setc = ste(tc,0,1);
                    sti = DataSet.Mark.condtable{1};
                    [curvefit,goodness,fitinfo] = SizeTuningFit(sti,mtc,'dog');
                    [si s_max s_min] = SI(mtc,sti,stiend);
                    
                    muresult{ch,1}.block{j}.blockid = blockid;
                    muresult{ch,1}.block{j}.blocktype = blocktype;
                    muresult{ch,1}.block{j}.tc = tc;
                    muresult{ch,1}.block{j}.mtc = mtc;
                    %                     muresult{ch,1}.block{j}.setc = setc;
                    muresult{ch,1}.block{j}.si = [si s_max s_min];
                    muresult{ch,1}.block{j}.sc = [f0 f1];
                    muresult{ch,1}.block{j}.curvefit = curvefit;
                    muresult{ch,1}.block{j}.goodness = goodness;
                    muresult{ch,1}.block{j}.sti = sti;
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
                    tc = stc{ch,sort};
                    pd = psthdata{ch,sort};
                    
                    % if Cell Test Failed or maximum mean firing rate less than 10 spikes/sec, exclude current block
                    if celltest(tc,'t') %&& max(mtc) >= 10
                        % save valid single-unit info
                        suresult{ch,sort}.block{j}.unitinfo = unitinfo{ch,sort};
                        
                        mtc = mean(tc,1);
                        os = find(mtc==max(mtc(2:end)));
                    ifr = squeeze(mean(pd));
                    blank = mean(ifr(1,:));
                    cn = floor(1000/tf/bin);
                    ca = cac(ifr(os,:)-blank,cn);
                    [f0 , f1] = f0f1(ca);
                    
                        setc = ste(tc,0,1);
                        sti = DataSet.Mark.condtable{1};
                        [curvefit,goodness,fitinfo] = SizeTuningFit(sti,mtc,'dog');
                        [si s_max s_min] = SI(mtc,sti,stiend);
                        
                        suresult{ch,sort}.block{j}.blockid = blockid;
                        suresult{ch,sort}.block{j}.blocktype = blocktype;
                        suresult{ch,sort}.block{j}.tc = tc;
                        suresult{ch,sort}.block{j}.mtc = mtc;
                        %                         suresult{ch,sort}.block{j}.setc = setc;
                        suresult{ch,sort}.block{j}.si = [si s_max s_min];
                        suresult{ch,sort}.block{j}.sc = [f0 f1];
                        suresult{ch,sort}.block{j}.curvefit = curvefit;
                        suresult{ch,sort}.block{j}.goodness = goodness;
                        suresult{ch,sort}.block{j}.sti = sti;
                    else
                        disp(['The neural signal in Ch-',num2str(ch),'__Sort-',num2str(sort),...
                            ' is NOT significently modulated and will be deleted.'])
                    end
                end
            end
            
            
        end
        
        % clear memory for efficiency
        clear DataSet stc wtc sctc lfppsd lfpps wps scpsd scps ps;
    end
    
    % save critical session info
    sinfo.sessionindex = i;
    sinfo.session = currentsession;
    sinfo.site  = SessionIndex{i,3}.site;
    sinfo.subject = currentsubject;
    sinfo.datatank = currenttank;
    
    BST{i,1} = sinfo;
    BST{i,2}=muresult;
    BST{i,3}=suresult;
    BST{i,4}=lfpresult;
    
end

BST{sn+1,1}.method = Method;
BST{sn+1,1}.exid = str2double(exid);
BST{sn+1,1}.extent = extent;
BST{sn+1,1}.delay = delay;
BST{sn+1,1}.stiend = stiend;
BST{sn+1,1}.issps = issps;
BST{sn+1,1}.pret = pret;
BST{sn+1,1}.post = post;
BST{sn+1,1}.rootpath = rootpath;
BST{sn+1,1}.batchpath = batchpath;
BST{sn+1,1}.spevent = spevent;
f = ['BST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',num2str(issps),'_',num2str(round(pret*10)),'_',num2str(round(post*10)),'.mat'];
save(fullfile(batchpath,f),'BST');
