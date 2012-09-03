% BSFC.m %
% 2011-04-24 by Zhang Li
% Batch Spike Field Coherence

if isempty(varargin)
    extent = 0; % ms
    delay = 0; % ms
    stiend = 30; % possible maximum size(degree)
    ch_w = 0; % each channal wave
else
    extent=varargin{1};
    delay = varargin{2};
    stiend = varargin{3};
    ch_w = varargin{4};
end

sn=size(SessionIndex,1);
% batch each session
for i=1:sn
    currentsubject = SessionIndex{i,1};
    currenttank = SessionIndex{i,2};
    currentsession = SessionIndex{i,3}.session;
    % reset session result for each new session
    muresult = [];
    suresult = [];
    
    tbi = cellfun(@(x)~isempty(x)&&strcmp(x.extype,'RF_Size'),SessionIndex{i,3}.block);
    targetblock = SessionIndex{i,3}.block(tbi);
    bn = length(targetblock);
    % batch each valid block for current session
    for j=1:bn
        blockid = targetblock{j}.id;
        t = [currenttank,'__',currentsession,'-',num2str(blockid)];
        load(fullfile(rootpath,currentsubject,[t,'.mat']));
        disp(['Size Tuning SFC Batching --> ',currentsubject,'__',t,' ...']);
        
        t= cellfun(@(x)strcmp(x,'TemporalFreq'),DataSet.Mark.ckey(:,1));
        if DataSet.Mark.ckey{t,2}==0
            blocktype = 'static';
        else
            blocktype = 'drifting';
        end
        
        DataSet = PreProcess(DataSet,extent,delay,0);
        % Processing Firing Rate Size Tuning
        stc = STC(DataSet);
        
        for ch = 1:DataSet.Snip.chn
            if ch_w==0 % each channal
                chw = ch;
            else
                chw = ch_w;
            end
            
            % mu result
            for sort = DataSet.Snip.ppsortn(ch)
                
                % get size tuning result
                tc = stc{ch,sort};
                trial = size(tc,1);
                mtc = mean(tc,1);
                % if maximum mean firing rate less than 10 spikes/sec, exclude current block
                if max(mtc) > 10
                    
                    sdtc = std(tc,0,1);
                    sti = DataSet.Mark.condtable{1};
                    [curvefit,goodness,fitinfo] = SizeTuningFit(sti,mtc,'dog');
                    [si s_max s_min] = SI(mtc,sti,stiend);
                    
                    muresult{ch,1}.block{j}.blockid = blockid;
                    muresult{ch,1}.block{j}.blocktype = blocktype;
                    muresult{ch,1}.block{j}.trial = trial;
                    muresult{ch,1}.block{j}.mtc = mtc;
                    muresult{ch,1}.block{j}.sdtc = sdtc;
                    muresult{ch,1}.block{j}.si = [si s_max s_min];
                    muresult{ch,1}.block{j}.curvefit = curvefit;
                    muresult{ch,1}.block{j}.goodness = goodness;
                    muresult{ch,1}.block{j}.sti = sti;
                    
                    % Processing Spike Field Coherence
                    sfcdata = sfc(DataSet,ch,sort,chw);
                    sfcs = getps(sfcdata,DataSet,[0 150]);
                    cs = double(fm(sfcs{1}.data));
                    ps = double(fm(sfcs{1}.phase));
                    trial = size(cs,1);
                    % excluded none significent coherence block
                    if trial >= 5
                        muresult{ch,1}.block{j}.sfc.trial = trial;
                        muresult{ch,1}.block{j}.sfc.data = squeeze(mean(cs,1));
                        muresult{ch,1}.block{j}.sfc.sd = squeeze(std(cs,0,1));
                        mu = circ_mean(ps,[],1);
                        muresult{ch,1}.block{j}.sfc.phase = squeeze(mu);
                        [s s0] = circ_std(ps,[],[],1);
                        muresult{ch,1}.block{j}.sfc.psd = squeeze(s0);
                        muresult{ch,1}.block{j}.sfc.frequencies = sfcs{end}.frequencies;
                    end
                end
            end
            
            % su result
            sua = SessionIndex{i,3}.su(ch,:); % current channal all sort
            sui = cellfun(@(x)~isempty(x),sua); % valid sort index
            su = sua(sui); % valid single-unit sort
            if ~isempty(su) % have valid sort
                sui = cellfun(@(x)x.sortid,su);
                for sort = sui
                    
                    % get size tuning result
                    tc = stc{ch,sort};
                    trial = size(tc,1);
                    mtc = mean(tc,1);
                    % if maximum mean firing rate less than 10 spikes/sec, exclude current block
                    if max(mtc) > 10
                        % save valid single-unit info
                        suresult{ch,sort}.su = SessionIndex{i,3}.su{ch,sort};
                        
                        sdtc = std(tc,0,1);
                        sti = DataSet.Mark.condtable{1};
                        [curvefit,goodness,fitinfo] = SizeTuningFit(sti,mtc,'dog');
                        [si s_max s_min] = SI(mtc,sti,stiend);
                        
                        suresult{ch,sort}.block{j}.blockid = blockid;
                        suresult{ch,sort}.block{j}.blocktype = blocktype;
                        suresult{ch,sort}.block{j}.trial = trial;
                        suresult{ch,sort}.block{j}.mtc = mtc;
                        suresult{ch,sort}.block{j}.sdtc = sdtc;
                        suresult{ch,sort}.block{j}.si = [si s_max s_min];
                        suresult{ch,sort}.block{j}.curvefit = curvefit;
                        suresult{ch,sort}.block{j}.goodness = goodness;
                        suresult{ch,sort}.block{j}.sti = sti;
                        
                        % Processing Spike Field Coherence
                        sfcdata = sfc(DataSet,ch,sort,chw);
                        sfcs = getps(sfcdata,DataSet,[0 150]);
                        cs = double(fm(sfcs{1}.data));
                        ps = double(fm(sfcs{1}.phase));
                        trial = size(cs,1);
                        % excluded none significent coherence block
                        if trial >= 5
                            suresult{ch,sort}.block{j}.sfc.trial = trial;
                            suresult{ch,sort}.block{j}.sfc.data = squeeze(mean(cs,1));
                            suresult{ch,sort}.block{j}.sfc.sd = squeeze(std(cs,0,1));
                            mu = circ_mean(ps,[],1);
                            suresult{ch,sort}.block{j}.sfc.phase = squeeze(mu);
                            [s s0] = circ_std(ps,[],[],1);
                            suresult{ch,sort}.block{j}.sfc.psd = squeeze(s0);
                            suresult{ch,sort}.block{j}.sfc.frequencies = sfcs{end}.frequencies;
                        end
                    end
                end
            end
            
        end
        
        % clear memory for efficiency
        clear DataSet stc sfcdata sfcs cs ps;
    end
    
    % save critical session info
    sinfo.sessionindex = i;
    sinfo.session = currentsession;
    sinfo.site  = SessionIndex{i,3}.site;
    sinfo.subject = currentsubject;
    sinfo.datatank = currenttank;
    
    BSTSFC{i,1} = sinfo;
    BSTSFC{i,2}=muresult;
    BSTSFC{i,3}=suresult;
    
end

BSTSFC{sn+1,1}.exid = str2double(exid);
BSTSFC{sn+1,1}.extent = extent;
BSTSFC{sn+1,1}.delay = delay;
BSTSFC{sn+1,1}.stiend = stiend;
BSTSFC{sn+1,1}.rootpath = rootpath;
p = fullfile(rootpath,batchpath);
BSTSFC{sn+1,1}.batchpath = p;
f = ['BSTSFC_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),'_',num2str(ch_w),'.mat'];
save(fullfile(p,f),'BSTSFC');
