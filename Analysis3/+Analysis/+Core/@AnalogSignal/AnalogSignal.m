classdef AnalogSignal < handle
    %ANALOGSIGNAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        description
        channel
        fs
        value
        startime
    end
    
    methods
        function as = AnalogSignal(n,c,f,v,t)
            if nargin~=0
                as.name = n;
                as.channel = c;
                as.fs = f;
                as.value = v;
                as.startime = t;
            end
        end
    end
    
end

