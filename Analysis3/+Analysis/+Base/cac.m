function [ ca,sd, nc] = cac( x,cn )
%CAC Summary of this function goes here
%   Detailed explanation goes here

n = length(x);
nc = floor(n/cn);

vx = reshape(x(1:nc*cn),cn,nc);
ca = mean(vx,2);
sd = std(vx,0,2);
end

