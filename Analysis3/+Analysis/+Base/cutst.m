function [ cst, win ] = cutst( st, starttime, endtime )
%CUTST Summary of this function goes here
%   Detailed explanation goes here

cst = st(starttime <= st & st < endtime);
% Mark No Spike as NaN
if isempty(cst)
    cst = NaN;
end
win = [starttime endtime];
end

