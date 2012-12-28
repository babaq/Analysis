classdef Spike < handle
    %SPIKE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        channel
        fs
        value
        time
        delay
        sort
    end
    
    methods
        function sp = Spike(c,t,s)
            if nargin==0
                return;
            else
                sp.channel = c;
                sp.time = t;
                sp.sort = s;
            end
        end
    end
    
end

