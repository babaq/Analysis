function [ n nb nmed nmax ] = histd( x,edges )
%HISTD Summary of this function goes here
%   Detailed explanation goes here

n = histc(x,edges);
n = n(1:end-1);
nb = edges(1:end-1)+(edges(2)-edges(1))/2;
nmed = median(x);
nmax = max(n);

end

