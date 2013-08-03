function [ rap ] = reshapeap( aptimes,on,off,shifts,duration )
%RESHAPEAP Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Base.*

if nargin == 4
    duration = [0 0];
end
if duration(1)<=0 && duration(2)<=0
    type = 'onoff';
end
if duration(1)>0 && duration(2)<=0
    type = 'ondur';
end
if duration(1)<=0 && duration(2)>0
    type = 'offdur';
end

trialn = size(on,1);
stin = size(on,2);
switch type
    case 'ondur'
        for t = 1:trialn
            for s = 1:stin
                [rap.apt{t,s},rap.win(t,s,:)] = caponduration(aptimes,on(t,s),shifts(1),duration(1));
            end
        end
    case 'offdur'
        for t = 1:trialn
            for s = 1:stin
                [rap.apt{t,s},rap.win(t,s,:)] = capoffduration(aptimes,off(t,s),shifts(2),duration(2));
            end
        end
    otherwise
        for t = 1:trialn
            for s = 1:stin
                [rap.apt{t,s},rap.win(t,s,:)] = caponoff(aptimes,[on(t,s) off(t,s)],shifts);
            end
        end
end

