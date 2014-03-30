function [ bdata ] = ReadVLBlock( vlbfile,fastversion )
%READVLBLOCK Read VLab Binary file data into block object
% Fast version uses Mex function that could save ~50% space and ~80% time

if nargin ==1
    fastversion = true;
end

import Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

disp(['Reading VLab Binary File: ',vlbfile,' ...']);
if fastversion
    [ nTestType,szComment,nSpikeChannel,aTestType,aExpParam,aBehavParam,...
        aGraphParam,aTestSeries,aTrial,aFOREP,aResponseTime,aTrialStatus,aDepth2Match,...
        aCursorDepth,ucMajorChannel,nCellNum,ucElectrodeNum,nElectrodeDepth,fSpikeShape,...
        nSpikeShapeTimes,dSpikeShapeTimestamp,nSpikeShapeSampleRate] = ReadVLabData( vlbfile );
else
    [ nTestType,szComment,nSpikeChannel,aTestType,aExpParam,aBehavParam,...
        aGraphParam,aTestSeries,aTrial,aFOREP,aResponseTime,aTrialStatus,aDepth2Match,...
        aCursorDepth,ucMajorChannel,nCellNum,ucElectrodeNum,nElectrodeDepth,fSpikeShape,...
        nSpikeShapeTimes,dSpikeShapeTimestamp,nSpikeShapeSampleRate] = ReadVLB( vlbfile );
end
aExpParam     = ConvertParam(aExpParam);
aBehavParam   = ConvertParam(aBehavParam);
aGraphParam   = ConvertParam(aGraphParam);

blockname = aTestType{1};
blocksource = vlbfile;
bdata = Block(blockname,blocksource);

aExpParam.TestType = blockname;
aExpParam.DataSource = blocksource;
aExpParam.SpikeFs = nSpikeShapeSampleRate;
aExpParam.SpikeShape = fSpikeShape;
aExpParam.ElectrodeDepth = nElectrodeDepth;
aExpParam.ElectrodeNum = ucElectrodeNum;
aExpParam.CellNum = nCellNum;
aExpParam.SpikeShapeTimes = nSpikeShapeTimes;
aExpParam.SpikeShapeTimestamp = dSpikeShapeTimestamp;
aExpParam.MajorChannel = ucMajorChannel+1;

aExpParam.Condition = aTestSeries;
bdata.param = aExpParam;
bdata.param.SimulateParam = aGraphParam;
bdata.param.SubjectParam = aBehavParam;

bdata.param.AnalysisParam.IsFastRead = fastversion;

bdata.data.condtests = aTrial;

end

