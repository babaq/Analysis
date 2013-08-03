function [ bst ] = binst( st,range,bw )
%BINST Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    bw = 0.001; % binary spike train
end

bin = range(1):bw:range(2);
bst = histc(st,bin);
bst(end) = [];
end

