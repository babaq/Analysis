function getbrs(FBRS)
% getbrs.m %
% 2012-04-09 by Zhang Li
% Get filtered batched RF_Surround result according to channal and sort

extent = FBRS{end,1}.extent;
delay = FBRS{end,1}.delay;
pret = FBRS{end,1}.pret;
post = FBRS{end,1}.post;
batchpath = FBRS{end,1}.batchpath;
unit = FBRS{end,1}.unit;
stitype = FBRS{end,1}.stitype;
freqrange = FBRS{end,1}.freqrange;

sn = size(FBRS,1)-1;
% unfold each channal and sort of filter batch result
vsn=1;
for i=1:sn
    sessioninfo = FBRS{i,1};
    unitresult = FBRS{i,2};
    lfpresult = FBRS{i,3};
    
    chn = size(unitresult,1);
    sortn = size(unitresult,2);
    
    for ch = 1:chn
        for sort = 1:sortn
            cur = unitresult{ch,sort};
            cfr = lfpresult{ch,sort};
            if ~isempty(cur) && ~isempty(cfr)
                disp(['Get FBRS Result --> Session ',num2str(i),' - Channal ',num2str(ch),' - Sort ',num2str(sort)]);
                
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
                SBRS{vsn,1} = tb;
                
                tb = cfr.block;
                tb.ch = ch;
                tb.sessionindex = sessioninfo.sessionindex;
                tb.session = sessioninfo.session;
                tb.site = sessioninfo.site;
                tb.subject = sessioninfo.subject;
                tb.datatank = sessioninfo.datatank;
                SBRS{vsn,2} = tb;
                
                vsn = vsn+1;
            end
        end
    end
    
end

SBRS{vsn,1} = FBRS{end,1};

save(fullfile(batchpath,...
    ['SBRS_',num2str(extent),'_',num2str(delay),...
    '_',num2str(round(pret*10)),'_',num2str(round(post*10)),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'.mat']),...
    'SBRS');