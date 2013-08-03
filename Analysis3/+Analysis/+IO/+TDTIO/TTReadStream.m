function [ chc ] = TTReadStream( TTX,eventname,options,varargin )
%TTREADSTREAM Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Core.* Analysis.IO.TDTIO.* Analysis.IO.TDTIO.TTank.*

if nargin<3
    options.readoptions = 'FILTERED';
end
if nargin == 4
    evinfov = varargin{1};
end
evinfob = BNEvInfo(CurBlockNotes(TTX),eventname);

chc = ChannelCluster('all');
for i = 1:evinfob.NumChan
    ResetFilters(TTX);
    if ~SetFilterWithDescEx(TTX,['chan=',num2str(i)]);
        error('Filter Failed.');
    end
    segn=ReadEventsV(TTX,TGlobal.MaxRead,eventname, 0, 0, 0, 0,options.readoptions);
    if segn == TGlobal.MaxRead
        warning('Maximum number of records(%d) is returned indicating more records in the event',...
            segn);
    elseif segn==0
        error('NO Records Retrieved.');
    end
    temp = ParseEvV(TTX,0,segn);
    temp = reshape(temp,1,[]);
    
    as = AnalogSignal(eventname,i,evinfob.SampleFreq,temp,evinfov.time);
    chc.channels(i,1) = Channel(i,as);
end
ResetFilters(TTX);

