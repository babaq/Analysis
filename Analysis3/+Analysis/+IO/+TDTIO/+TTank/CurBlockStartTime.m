function [ starttime ] = CurBlockStartTime( TTX )
%CURBLOCKSTARTTIME returns the start time of the selected block in seconds. The
%               returned value is the elapsed time in seconds from 12:00 AM January 1st, 1970
%                to the start of the block. Pass the result through FancyTime to convert the result
%                 into a date/time string.
%   Detailed explanation goes here

starttime = TTX.CurBlockStartTime();
end

