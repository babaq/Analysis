classdef EventSeries < handle
    %EVENTSERIES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        Events
    end
    
    methods
        function es = EventSeries(n)
            import Analysis.Core.Event
            es.Events = Event.empty;
            if nargin==1
                es.name = n;
            end
        end
        function ts = Times(obj)
            ne = length(obj.Events);
            ts = zeros(ne,1);
            for i=1:ne
                ts(i) = obj.Events(i).time;
            end
        end
        function vs = Values(obj)
            ne = length(obj.Events);
            vs = zeros(ne,1);
            for i=1:ne
                vs(i) = obj.Events(i).value;
            end
        end
    end
    
end

