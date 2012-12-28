classdef SpikeTrain < handle
    %SPIKETRAIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        spikes
    end
    
    methods
        function st = SpikeTrain(n)
            import Analysis.Core.Spike
            st.spikes = Spike.empty;
            if nargin==1
                st.name = n;
            end
        end
        function stt = SpikeTrainTime(obj)
            nsp = length(obj.spikes);
            stt = zeros(nsp,1);
            for i = 1:nsp
                stt(i) = obj.spikes(i).time;
            end
        end
    end
    
end

