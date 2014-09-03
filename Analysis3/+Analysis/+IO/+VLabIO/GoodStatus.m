function [ gs ] = GoodStatus( status,bs )
%GOODSTATUS Summary of this function goes here
%   Detailed explanation goes here

gs = false;
for bsi = 1: length(bs)
    gs = gs | status == bs{bsi};
end
gs = ~gs;

end

