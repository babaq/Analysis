function [ cst, win ] = cutst( st, starttime, endtime )
%CUTST Summary of this function goes here
%   Detailed explanation goes here

cst = st(starttime <= st & st < endtime);
win = [starttime endtime];
end

