function [ cst,cstidx, win ] = cutst( st, starttime, endtime )
%CUTST Summary of this function goes here
%   Detailed explanation goes here

rn = length(starttime);
if rn ~= length(endtime)
    error('Start Time and End Time Do Not Match.');
end
cst = cell(rn,1);
cstidx = cell(rn,1);
for i=1:rn
    tcstidx = find(starttime(i) <= st & st < endtime(i));
    tcst = st(tcstidx);
    cstidx{i,1} = tcstidx;
    % Mark No Spike as NaN
    if isempty(tcst)
        tcst = NaN;
    end
    cst{i,1} = tcst;
end

win = [starttime endtime];
end

