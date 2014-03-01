function [ idx ] = drv( p,n )
%DRV Generate Discret Random Variable
%   Detailed explanation goes here

if sum(p) ~= 1
    error('sum(p) ~= 1');
end
if nargin <2
    n=1;
end

bin = [0 cumsum(p)];
x=rand(1,n);
[c,idx] = histc(x,bin);
idx = idx';
end

