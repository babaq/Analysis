function x = pha2con(x)
% pha2con.m
% 2011-04-18  Zhang Li
% Convert Phase Value to Phase Convention

x = mod(x+2*pi,2*pi);
% x(x<0) = x(x<0)+2*pi;