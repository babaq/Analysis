function [ edata ] = TTReadEvent( TX,eventname,options )
%TTREADEVENT Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Core.* Analysis.IO.TDTIO.* Analysis.IO.TDTIO.TTankX.*

if nargin<3
    options.readoptions = 'FILTERED';
    options.isreadspikewave = true;
end
nevent = ReadEventsV(TX,1,eventname,0,0,0,0,options.readoptions);
if nevent==0
    warning('NO Records Retrieved.');
    return;
end
evinfov = EvInfoV(TX,ParseEvInfoV(TX,0,0,0));
switch evinfov.evtype
    case 'Scalar'
        edata = TTReadScalar(TX,eventname,options,evinfov);
    case 'Stream'
        edata = TTReadStream(TX,eventname,options,evinfov);
    case 'Snip'
        edata = TTReadSnip(TX,eventname,options,evinfov);
end

end

