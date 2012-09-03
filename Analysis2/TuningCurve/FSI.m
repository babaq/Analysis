function [si s_max s_min] = FSI(cf,sti,stiend)
% FSI.m
% 2009-12-03 by Zhang Li
% Size Tuning Supression Index according to size tuning curve fit

csti = sti(1):(sti(2)-sti(1))/100:sti(end);
cmr = cf(csti);
[si s_max s_min] = SI(cmr,csti,stiend);
