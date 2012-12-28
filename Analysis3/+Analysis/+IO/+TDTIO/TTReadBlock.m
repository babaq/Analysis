function [ bdata ] = TTReadBlock( TX,blockname,events,options )
%TTREADBLOCK Read events records in a block
%input:
%   events   string cell indicating events to read
%   options  read options to each event
%           optional default: readoptions = 'filtered'
%                             isreadspikewave = true
import Analysis.Core.* Analysis.IO.TDTIO.* Analysis.IO.TDTIO.TTankX.*

if ~SelectBlock(TX,blockname,true);
    error('Block: %s Selection Failed.',blockname);
end
evn = length(events);
if nargin < 4
    for i=1:evn
        opt.readoptions = 'FILTERED';
        opt.isreadspikewave = true;
        options{i} = opt;
    end
end

bdata = Block(blockname);
t1 = CurBlockStartTime(TX);
t2 = CurBlockStopTime(TX);
bdata.startime = FancyTime(TX,t1,Globals.TimeFormat);
bdata.stoptime = FancyTime(TX,t2,Globals.TimeFormat);
bdata.duration = t2-t1;
for i = 1:evn
    edata = TTReadEvent(TX,events{i},options{i});
    if isa(edata,'EventSeries');
        bdata.eventseriesgroup(end+1,1) = edata;
    end
    if isa(edata,'ChannelCluster');
        bdata.channelclustergroup(end+1,1) = edata;
    end
    if isa(edata,'EpochSeries');
        bdata.epochseriesgroup(end+1,1) = edata;
    end
    if isa(edata,'CellAssemble');
        bdata.cellassemblegroup(end+1,1) = edata;
    end
end
bdata.channelclustergroup = MergeCCG(bdata.channelclustergroup);
