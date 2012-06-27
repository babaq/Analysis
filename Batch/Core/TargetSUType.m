function varargout = TargetSUType(TBE,sulist)
% TargetSUType.m %
% 2011-10-15 Zhang Li
% Generate Target Data Single-Unit Type Index from Target unfold Batch Experiment

extent = TBE{end,1}.extent;
delay = TBE{end,1}.delay;
stiend = TBE{end,1}.stiend;
batchpath = TBE{end,1}.batchpath;
unit = TBE{end,1}.unit;
stitype = TBE{end,1}.stitype;
freqrange = TBE{end,1}.freqrange;
issps = TBE{end,1}.issps;


for type = 1:2
    sutd = sulist{type};
    
    vn = 1;
    for i = 1:length(sutd)
        td = sutd{i};
        ti = cellfun(@(x)(x.sessionindex==td.sessionindex) & (x.blockid==td.blockid) & (x.sortid==td.sortid),TBE(1:end-1));
        
        ti = find(ti==1);
        if ~isempty(ti)
            idx(vn)=ti;
            vn = vn + 1;
        end
        
    end
    varargout{type} = idx;
    idx=[];
end
