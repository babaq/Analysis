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
        function ts = Times(obj)
            nsp = length(obj.spikes);
            ts = zeros(nsp,1);
            for i = 1:nsp
                ts(i) = obj.spikes(i).time;
            end
        end
    end
    
end

