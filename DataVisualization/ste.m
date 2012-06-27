function [se sd sn] = ste(varargin)
% ste.m
% 2011-07-09 by Zhang Li
% Get Standard Error, Standard Deviation and Sample Size

x = varargin{1};
vn = length(varargin);
if vn>2
    dim = varargin{3};
else
    dim=1;
end
sn = size(x,dim);

if vn<2 % vn=1
    sd = std(varargin{1});
elseif vn>2 % vn=3
    sd = std(varargin{1},varargin{2},varargin{3});
else % vn=2
    sd = std(varargin{1},varargin{2});
end
    
se = sd/sqrt(sn);
