function [ isin ] = inrange( xyz,o,r )
%INRANGE Summary of this function goes here
%   Detailed explanation goes here

ed = @(p1,p2)sqrt(sum((p2-p1).^2));

isin = false;
for i=1:size(xyz,1)
    if ed(xyz(i,:),o) > r
        return;
    end
end
isin = true;
end

