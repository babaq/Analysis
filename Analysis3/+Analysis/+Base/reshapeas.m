function [ ras ] = reshapeas( as,on,off,shifts,fs,asstarttime,duration )
%RESHAPEAS Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Base.*

if nargin == 6
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
                [ras.as{t,s},ras.win(t,s,:)] = casonduration(as,on(t,s),shifts(1),duration(1),fs,asstarttime);
            end
        end
    case 'offdur'
        for t = 1:trialn
            for s = 1:stin
                [ras.as{t,s},ras.win(t,s,:)] = casoffduration(as,off(t,s),shifts(2),duration(2),fs,asstarttime);
            end
        end
    otherwise
        for t = 1:trialn
            for s = 1:stin
                [ras.as{t,s},ras.win(t,s,:)] = casonoff(as,[on(t,s) off(t,s)],shifts,fs,asstarttime);
            end
        end
end

