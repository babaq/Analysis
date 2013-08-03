function [ sinfo ] = spiketraininfo( st,iswave )
%SPIKETRAININFO Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Core.* Analysis.Base.*
if nargin==1
    iswave = false;
end

if isnetype(st,'SpikeTrain')
    nsp = length(st.spikes);
    for i = 1:nsp
        [info,pi(i)] = spikewaveinfo(st.spikes(i),Global.MinFs,true);
        sinfo.amplituderatio(i) = info.amplituderatio;
        sinfo.spikeduration(i) = info.spikeduration;
        sinfo.halfspikewidth(i) = info.halfspikewidth;
        sinfo.halfafterspikewidth(i) = info.halfafterspikewidth;
        sw(:,i) = info.spikewave;
    end
    sinfo.dt = info.dt;
    if iswave
        sinfo.spikewave = sw;
    end
    sinfo.meanspikewave = meanspikewave(sw,pi);
end

