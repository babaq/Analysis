function [ ccg ] = MergeCCG( ccgroup )
%MERGECCG Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Base.MergeChC

ccname = arrayfun(@(x)x.name,ccgroup,'uniformoutput',false);
ucc = unique(ccname);

for i=1:length(ucc)
    idx = cellfun(@(x)strcmp(x,ucc{i}),ccname);
    subccg = ccgroup(idx);
    cc = subccg(1);
    for j=2:length(subccg)
        cc = MergeChC(cc,subccg(j));
    end
    ccg(i,1)=cc;
end

end

