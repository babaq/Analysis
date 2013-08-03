 function [ pc ] = ParseC( st,isapinfo )
%PARSEC Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Core.* Analysis.Base.*
if nargin==1
    isapinfo = true;
end

if isnetype(st,'SpikeTrain')
    pc = Cell();
    pc.channel = st.spikes(1).channel;
    pc.sort = st.spikes(1).sort;
    pc.aptimes = st.Times();
    if isapinfo
        pc.apinfo = spiketraininfo(st);
    end
end

