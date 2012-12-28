classdef Event < handle
    %EVENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        value
        time
    end
    
    methods
        function e = Event(t,v)
            if nargin==1
                e.time = t;
            end
            if nargin==2
                e.time = t;
                e.value = v;
            end
        end
    end
    
end

