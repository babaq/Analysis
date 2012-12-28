classdef ChannelCluster < handle
    %CHANNELCLUSTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        channels
    end
    
    methods
        function chc = ChannelCluster(n)
            import Analysis.Core.Channel
            chc.channels = Channel.empty;
            if nargin==1
                chc.name = n;
            end
        end
    end
    
end

