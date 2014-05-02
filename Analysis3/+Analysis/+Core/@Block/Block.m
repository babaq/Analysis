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
        param
        data
        eventseriesgroup
        epochseriesgroup
        cellassemblegroup
        channelclustergroup
    end
    
    methods
        function blk = Block(n,s)
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
            if nargin==2
                blk.name = n;
                blk.source = s;
            end
        end
        function dataset = CoreData(block)
            dataset.param = Analysis.Base.trytable2struct(block.param);
            dataset.data = Analysis.Base.trytable2struct(block.data);
        end
        function save(block,filefullname)
            save(filefullname,'block',Analysis.Core.Global.MatVersion);
        end
    end
    
end

