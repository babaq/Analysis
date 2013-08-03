function [ capt, win ] = cutaptimes( aptimes, starttime, endtime )
%CUTAPTIMES Summary of this function goes here
%   Detailed explanation goes here

capt = aptimes(starttime <= aptimes & aptime < endtime);
win = [starttime endtime];
end

