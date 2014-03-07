function [ cst, win ] = cutst( st, starttime, endtime )
%CUTST Summary of this function goes here
%   Detailed explanation goes here

% Cutting no spikes(NaN) results no spikes(NaN)
if isnan(st)
    cst = st;
else
    cst = st(starttime <= st & st < endtime);
end

win = [starttime endtime];
end

