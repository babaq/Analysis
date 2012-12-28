classdef Channel < handle
    %CHANNEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        index
        coordinate
        signal
        spiketrains
    end
    
    methods
        function ch = Channel(i,s)
            import Analysis.Core.SpikeTrain
            ch.spiketrains = SpikeTrain.empty;
            if nargin==1
                ch.index=i;
            end
            if nargin==2
                ch.index=i;
                ch.signal = s;
            end
        end
    end
    
end

