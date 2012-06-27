function [po osi] = OI(mr,sti)
% OI.m
% 2011-10-23 by Zhang Li
% Orientation Tuning Parameters

por = max(mr);

pd = sti(mr==pdr);

npdr = mr(mod(pd+pi,2*pi)==sti);

dsi = 1-(npdr/pdr);



