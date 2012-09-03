function spikeisi = isist(spiketrain)
% isist.m
% 2011-04-09 by Zhang Li
% Get Inter-Spike-Intervals of a spike train

st = sort(spiketrain);
spikeisi = diff(st);
