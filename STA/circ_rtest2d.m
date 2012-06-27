function [pval z] = circ_rtest2d(alpha)
% circ_rtest2d.m
% 2011-05-27 by Zhang Li
% Rayleigh test for non-uniformity of circular data, 2D version.

sn = size(alpha,2);
for s = 1:sn
    [pval(s) z(s)] = circ_rtest(alpha(:,s));
end