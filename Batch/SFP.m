function [fps sfp] = SFP(FP)
% SFP.m %
% 2010/08/26 by Zhang Li
% Statistics of Batched Size Tuning Firing Phase

sn = size(FP,1);
sfp = zeros(sn,4);

for i = 1:sn
    sfp(i,1)=pha2con(FP{i,1}.maxmp);
    sfp(i,2)=pha2con(FP{i,1}.minmp);
    sfp(i,3)=FP{i,1}.maxstd;
    sfp(i,4)=FP{i,1}.minstd;
end

fps.maxmp = sfp(:,1);
fps.minmp = sfp(:,2);
fps.maxstd = sfp(:,3);
fps.minstd = sfp(:,4);
fps.bin = (0:0.1:1);