function [pval z] = circ_rtest3d(alpha)
% circ_rtest3d.m
% 2011-05-27 by Zhang Li
% Rayleigh test for non-uniformity of circular data, 3D version.

sn = size(alpha,2);
fn = size(alpha,3);
for s = 1:sn
    for f = 1:fn
        [pval(s,f) z(s,f)] = circ_rtest(alpha(:,s,f));
    end
end