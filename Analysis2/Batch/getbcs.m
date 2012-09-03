function getbcs(FBCS)
% getbcs.m %
% 2012-04-09 by Zhang Li
% Get filtered batched centersurround result according to channal and sort

extent = FBCS{end,1}.extent;
delay = FBCS{end,1}.delay;
issps = FBCS{end,1}.issps;
pret = FBCS{end,1}.pret;
post = FBCS{end,1}.post;
batchpath = FBCS{end,1}.batchpath;
unit = FBCS{end,1}.unit;
stitype = FBCS{end,1}.stitype;
freqrange = FBCS{end,1}.freqrange;

sn = size(FBCS,1)-1;
% unfold each channal and sort of filter batch result
vsn=1;
for i=1:sn
    sessioninfo = FBCS{i,1};
    unitresult = FBCS{i,2};
    lfpresult = FBCS{i,3};
    
    chn = size(unitresult,1);
    sortn = size(unitresult,2);
    
    for ch = 1:chn
        for sort = 1:sortn
            cur = unitresult{ch,sort};
            cfr = lfpresult{ch,sort};
            if ~isempty(cur) && ~isempty(cfr)
                disp(['Get FBCS Result --> Session ',num2str(i),' - Channal ',num2str(ch),' - Sort ',num2str(sort)]);
                
                tb=cur.block;
                tb.ch = ch;
                if isfield(cur.block,'unitinfo')
                    tb.meanspikewave = cur.block.unitinfo.meanspikewave;
                    tb.sortid = cur.block.unitinfo.sortid;
                    tb.smoothspikewave = cur.block.unitinfo.spikewaveinfo.smoothspikewave;
                    tb.spikeduration = cur.block.unitinfo.spikewaveinfo.spikeduration;
                    tb.halfspikewidth = cur.block.unitinfo.spikewaveinfo.halfspikewidth;
                    tb.halfafterspikewidth = cur.block.unitinfo.spikewaveinfo.halfafterspikewidth;
                    tb.amplituderatio = cur.block.unitinfo.spikewaveinfo.amplituderatio;
                    tb = rmfield(tb,'unitinfo');
                end
                tb.sessionindex = sessioninfo.sessionindex;
                tb.session = sessioninfo.session;
                tb.site = sessioninfo.site;
                tb.subject = sessioninfo.subject;
                tb.datatank = sessioninfo.datatank;
                SBCS{vsn,1} = tb;
                
                tb = cfr.block;
                tb.ch = ch;
                tb.sessionindex = sessioninfo.sessionindex;
                tb.session = sessioninfo.session;
                tb.site = sessioninfo.site;
                tb.subject = sessioninfo.subject;
                tb.datatank = sessioninfo.datatank;
                SBCS{vsn,2} = tb;
                
                vsn = vsn+1;
            end
        end
    end
    
end

SBCS{vsn,1} = FBCS{end,1};

save(fullfile(batchpath,...
    ['SBCS_',num2str(extent),'_',num2str(delay),...
    '_',num2str(issps),'_',num2str(round(pret*10)),'_',num2str(round(post*10)),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'.mat']),...
    'SBCS');