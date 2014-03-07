function [ bst ] = binst( st,range,bw )
%BINST Summary of this function goes here
%   Detailed explanation goes here

if isempty(st)
    bst = st;
    return;
end

if nargin < 3
    bw = 0.001; % binary spike train
end

bin = range(1):bw:range(2);
% It's safe to interpret no spikes(NaN) to zero bin counts.
bst = histc(st,bin);
bst(end) = [];
end

