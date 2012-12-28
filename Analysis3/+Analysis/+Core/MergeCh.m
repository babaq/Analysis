function [ ch ] = MergeCh( ch1,ch2 )
%MERGECH Summary of this function goes here
%   Detailed explanation goes here

if ch1.index ~= ch2.index
    warning('Channel %d and %d are different, merge failed.',ch1.index,ch2.index);
    return;
end

if isempty(ch1.signal);
    if ~isempty(ch2.signal);
        ch1.signal = ch2.signal;
    end
end
if isempty(ch1.spiketrains);
    if ~isempty(ch2.spiketrains);
        ch1.spiketrains = ch2.spiketrains;
    end
end
ch = ch1;
end

