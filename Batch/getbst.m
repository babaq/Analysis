function getbst(FBST)
% getbst.m %
% 2011-04-09 by Zhang Li
% Get filtered batched size tuning result according to channal and sort

extent = FBST{end,1}.extent;
delay = FBST{end,1}.delay;
stiend = FBST{end,1}.stiend;
issps = FBST{end,1}.issps;
pret = FBST{end,1}.pret;
post = FBST{end,1}.post;
batchpath = FBST{end,1}.batchpath;
unit = FBST{end,1}.unit;
stitype = FBST{end,1}.stitype;
freqrange = FBST{end,1}.freqrange;

sn = size(FBST,1)-1;
% unfold each channal and sort of filter batch result
vsn=1;
for i=1:sn
    sessioninfo = FBST{i,1};
    unitresult = FBST{i,2};
    lfpresult = FBST{i,3};
    
    chn = size(unitresult,1);
    sortn = size(unitresult,2);
    
    for ch = 1:chn
        for sort = 1:sortn
            cur = unitresult{ch,sort};
            cfr = lfpresult{ch,sort};
            if ~isempty(cur) && ~isempty(cfr)
                disp(['Get FBST Result --> Session ',num2str(i),' - Channal ',num2str(ch),' - Sort ',num2str(sort)]);
                
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
                SBST{vsn,1} = tb;
                
                tb = cfr.block;
                tb.ch = ch;
                tb.sessionindex = sessioninfo.sessionindex;
                tb.session = sessioninfo.session;
                tb.site = sessioninfo.site;
                tb.subject = sessioninfo.subject;
                tb.datatank = sessioninfo.datatank;
                SBST{vsn,2} = tb;
                
                vsn = vsn+1;
            end
        end
    end
    
end

SBST{vsn,1} = FBST{end,1};

save(fullfile(batchpath,...
    ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',num2str(issps),'_',num2str(round(pret*10)),'_',num2str(round(post*10)),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'.mat']),...
    'SBST');