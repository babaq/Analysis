function suTargetIndex = suTargetList(SBE,varargin)
% suTargetList.m %
% 2011-10-15 Zhang Li
% Generate Single-Unit Type Target Data Index from unfold Batch Experiment

extent = SBE{end,1}.extent;
delay = SBE{end,1}.delay;
stiend = SBE{end,1}.stiend;
batchpath = SBE{end,1}.batchpath;
unit = SBE{end,1}.unit;
stitype = SBE{end,1}.stitype;
freqrange = SBE{end,1}.freqrange;
issps = SBE{end,1}.issps;

for type = 1:2
    suindex = varargin{type};
    for i=suindex
        cur = SBE{i,1};
        
        if isfield(cur,'meanspikewave')
            ti.meanspikewave = cur.meanspikewave;
            ti.smoothspikewave = cur.smoothspikewave;
            ti.spikeduration = cur.spikeduration;
            ti.halfspikewidth = cur.halfspikewidth;
            ti.halfafterspikewidth = cur.halfafterspikewidth;
            ti.amplituderatio = cur.amplituderatio;
        end
        ti.sessionindex = cur.sessionindex;
        ti.session = cur.session;
        ti.site = cur.site;
        ti.subject = cur.subject;
        ti.datatank = cur.datatank;
        ti.ch = cur.ch;
        ti.sortid = cur.sortid;
        ti.blockid = cur.blockid;
        ti.sti = cur.sti;
        
        td{i,1} = ti;
        
    end
    
    vti = cellfun(@(x)~isempty(x),td);
    suTargetIndex{type,1} = td(vti);
    td = [];
end


suTargetIndex{end+1,1} = SBE{end,1};

save(fullfile(batchpath,...
    ['suTargetIndex_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),'_',num2str(issps),'_',unit,'_',stitype,'_',num2str(freqrange),'.mat']),...
    'suTargetIndex');