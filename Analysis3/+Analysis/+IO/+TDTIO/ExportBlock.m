function [  ] = ExportBlock( TTX,blocksource,blockname,events,options,exportpath )
%EXPORTBLOCK Summary of this function goes here
%   Detailed explanation goes here

import Analysis.Core.* Analysis.Base.* Analysis.IO.TDTIO.* Analysis.IO.TDTIO.TTank.*

block = TTReadBlock(TTX,blocksource,blockname,events,options);
block.config = ParseES(block.eventseriesgroup,options.esformat);
block.cellassemblegroup = ParseCAGccg(block.channelclustergroup);

filename = [block.source.tank,'__',block.name,'.mat'];
save(fullfile(exportpath,filename),'block');
end

