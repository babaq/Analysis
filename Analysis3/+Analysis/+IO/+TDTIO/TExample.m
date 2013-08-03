function [ block ] = TExample(  )
%TEXAMPLE Summary of this function goes here
%   Detailed explanation goes here

import Analysis.Core.* Analysis.Base.* Analysis.IO.TDTIO.* Analysis.IO.TDTIO.TTank.*
blocksource.server = 'Local';
blocksource.tank = 'Single_M_DT1_111809';

tx = TTX();
ConnectServer(tx);
OpenTank(tx,blocksource.tank,'R');

block = TTReadBlock(tx,blocksource,'(Q1_4)-1',{'Mark' 'SP01_O' 'FP01'});
block.config = ParseES(block.eventseriesgroup,'StiLib');
block.cellassemblegroup = ParseCAGccg(block.channelclustergroup);

CloseTank(tx);
ReleaseServer(tx);
end

