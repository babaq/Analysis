function [ edata ] = TTReadScalar( TX,eventname,options,varargin )
%TTREADSCALAR Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Core.* Analysis.IO.TDTIO.* Analysis.IO.TDTIO.TTankX.*

if nargin<3
    options.readoptions = 'ALL';
end
if nargin == 4
    evinfov = varargin{1};
end
nevent = ReadEventsV(TX,Globals.MaxRet,eventname,0,0,0,0,options.readoptions);
if nevent == Globals.MaxRet
    warning('Maximum number of records(%d) is returned indicating more records in the event',...
        nevent);
elseif nevent==0
    warning('NO Records Retrieved.');
    return;
end

times = ParseEvInfoV(TX,0,nevent,6);
values = ParseEvInfoV(TX,0,nevent,7);
edata = EventSeries(eventname);
for i=1:nevent
    edata.Events(i,1) = Event(times(1,i),values(1,i));
end

end

