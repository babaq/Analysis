function [ bdata ] = TTReadBlock( TTX,blocksource,blockname,events,options )
%TTREADBLOCK Read events records in a block
%input:
%   events   string cell indicating events to read
%   options  read options to each event
%           optional default: readoptions = 'filtered'
%                             isreadspikewave = true
import Analysis.Core.* Analysis.Base.* Analysis.IO.TDTIO.* Analysis.IO.TDTIO.TTank.*

if ~SelectBlock(TTX,blockname,true);
    error('Block: %s Selection Failed.',blockname);
end
evn = length(events);
if nargin < 5
    for i=1:evn
        opt.readoptions = 'FILTERED';
        opt.isreadspikewave = true;
        
        options{i} = opt;
    end
end

bdata = Block(blockname,blocksource);
t1 = CurBlockStartTime(TTX);
t2 = CurBlockStopTime(TTX);
bdata.startime = FancyTime(TTX,t1,TGlobal.TimeFormat);
bdata.stoptime = FancyTime(TTX,t2,TGlobal.TimeFormat);
bdata.duration = t2-t1;
for i = 1:evn
    edata = TTReadEvent(TTX,events{i},options{i});
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
