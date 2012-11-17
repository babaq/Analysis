function [ c,ww ] = closmooth( varargin )
%CLOSMOOTH Summary of this function goes here
%   Detailed explanation goes here

y = varargin{1};
n = length(y);
y = [y;y;y];
varargin{1}=y;
[c,ww] = smooth(varargin{1},varargin{2},varargin{3});
c = c(n+1:2*n);
end

