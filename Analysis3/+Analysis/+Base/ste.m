function [ se, sd, n ] = ste( varargin )
%STE Summary of this function goes here
%   Detailed explanation goes here

vn = length(varargin);
x = varargin{1};
if vn == 1
    flag = 0;
    dim = 1;
end
if vn == 2
    flag = varargin{2};
    dim = 1;
end
if vn == 3
    flag = varargin{2};
    dim = varargin{3};
end
n = size(x,dim);
sd = std(x,flag,dim);
se = sd/sqrt(n);

end

