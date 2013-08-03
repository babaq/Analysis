function [ time ] = FancyTime( TTX, elapsedtime, format )
%FANCYTIME converts a time in double format to string format based on the user¡¯s
%           specifications. The input argument Time is assumed to be the total elapsed time
%           from 12:00 AM January 1st, 1970 up to the event of interest
%intput:
%  format 
%       Year Month Day Hours Minutes Seconds frac/Sec DofW
%         Y    O    D    H      M       S       U       W
%       for example, 'Y/O/D, H:M:S, W'

time = TTX.FancyTime(elapsedtime,format);
end

