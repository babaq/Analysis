function [ m,se ] = meanr( x,varargin )
%MEANR Summary of this function goes here
%   Detailed explanation goes here

rdim = cell2mat(varargin);
xsize = size(x);
y = reshape(x,[xsize(rdim) prod(xsize)/prod(xsize(rdim))]);
ysize = size(y);
mdim = length(ysize);
m = mean(y,mdim);
se = Analysis.Base.ste(y,0,mdim);

end

