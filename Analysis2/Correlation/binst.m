function bst = binst(st,onofftime,bw)
% binst.m
% 2011-04-03 by Zhang Li
% Convert Spike Train to Bined Spike Train Sequence

if isempty(st)
    bst = [];
    return;
end

if nargin < 3
    bw = 0.001; % binary bin width (sec)
end

bin = onofftime(1):bw:onofftime(2);
bst = histc(st,bin);
bst(end) = [];