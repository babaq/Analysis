function TargetIndex = TargetList(SBE)
% TargetList.m %
% 2011-04-15 Zhang Li
% Generate Target Data Index from unfold Batch Experiment

method = SBE{end,1}.method;
extent = SBE{end,1}.extent;
delay = SBE{end,1}.delay;
switch method
    case 'st'
        stiparam = SBE{end,1}.stiend;
    case 'dg'
        stiparam = SBE{end,1}.stin;
end
batchpath = SBE{end,1}.batchpath;
unit = SBE{end,1}.unit;
stitype = SBE{end,1}.stitype;
freqrange = SBE{end,1}.freqrange;
issps = SBE{end,1}.issps;
pret = SBE{end,1}.pret;
post = SBE{end,1}.post;

sn = size(SBE,1)-1;
for i=1:sn
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
    TargetIndex{i,1} = ti;
    
end

TargetIndex{sn+1,1} = SBE{end,1};

save(fullfile(batchpath,...
    [upper(method),'TargetIndex_',num2str(extent),'_',num2str(delay),'_',num2str(stiparam),...
    '_',num2str(issps),'_',num2str(round(pret*10)),'_',num2str(round(post*10)),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'.mat']),...
    'TargetIndex');