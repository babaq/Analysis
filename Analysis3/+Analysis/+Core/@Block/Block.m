classdef Block < handle
    %BLOCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        description
        source
        startime
        stoptime
        duration
        settings
        eventseriesgroup
        epochseriesgroup
        cellassemblegroup
        channelclustergroup
    end
    
    methods
        function blk = Block(n)
            import Analysis.Core.*
            blk.eventseriesgroup = EventSeries.empty;
            blk.epochseriesgroup = EpochSeries.empty;
            blk.cellassemblegroup = CellAssemble.empty;
            blk.channelclustergroup = ChannelCluster.empty;
            if nargin==0
                return;
            end
            if nargin==1
                blk.name = n;
            end
        end
    end
    
end

