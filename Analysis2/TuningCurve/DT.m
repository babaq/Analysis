function [pd dsi osi] = DT(mr,sti)
% DT.m
% 2011-10-23 by Zhang Li
% Direction Tuning Parameters

pdr = max(mr);
pd = sti(mr==pdr);
npdr = mr(mod(pd+180,360)==sti);

dsi = 1-(npdr/pdr);

osi = 0;


