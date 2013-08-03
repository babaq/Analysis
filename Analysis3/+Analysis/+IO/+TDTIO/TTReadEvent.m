function [ edata ] = TTReadEvent( TTX,eventname,options )
%TTREADEVENT Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Core.* Analysis.IO.TDTIO.* Analysis.IO.TDTIO.TTank.*

if nargin<3
    options.readoptions = 'FILTERED';
    options.isreadspikewave = true;
end
nevent = ReadEventsV(TTX,1,eventname,0,0,0,0,options.readoptions);
if nevent==0
    warning('NO Records Retrieved.');
    return;
end
evinfov = EvInfoV(TTX,ParseEvInfoV(TTX,0,0,0));
switch evinfov.evtype
    case 'Scalar'
        edata = TTReadScalar(TTX,eventname,options,evinfov);
    case 'Stream'
        edata = TTReadStream(TTX,eventname,options,evinfov);
    case 'Snip'
        edata = TTReadSnip(TTX,eventname,options,evinfov);
end

end

