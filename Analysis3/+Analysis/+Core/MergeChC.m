function [ chc ] = MergeChC( chc1,chc2 )
%MERGECHC Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Core.MergeCh

if ~strcmp(chc1.name,chc2.name)
    warning('ChannelCluster %s and %s are different, merge failed.',chc1.name,chc2.name);
    return;
end

if isempty(chc1.channels)
    if ~isempty(chc2.channels)
        chc1.channels = chc2.channels;
    end
elseif ~isempty(chc2.channels)
    for i=1:length(chc1.channels)
        chc1.channels(i) = MergeCh(chc1.channels(i),chc2.channels(i));
    end
end
chc = chc1;
end

