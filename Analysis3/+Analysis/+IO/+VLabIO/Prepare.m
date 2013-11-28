function [ pblock ] = Prepare( vlblock )
%PREPARE Organize VLab Data According to Experiment Design
%   Detailed explanation goes here

import Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

if isa(vlblock,'char')
    vlblock = ReadVLBlock(vlblock,1);
end

disp('Preparing Block Data ...');
cts = struct2table(vlblock.condtests);
cts.Properties.VariableNames{'m_wFigDelay'} = 'figdelay';
cts.Properties.VariableNames{'m_dTime'} = 'time';
cts.a = [cts.m_fA_X cts.m_fA_Y];
cts.b = [cts.m_nB_X cts.m_nB_Y];
cts(:,{'m_nB_X','m_nB_Y','m_fA_X','m_fA_Y'}) = [];
cts.Properties.VariableNames{'m_nItem'} = 'item';
cts.Properties.VariableNames{'m_nSet'} = 'set';
cts.Properties.VariableNames{'m_nStatus'} = 'status';
cts.Properties.VariableNames{'m_nResponseTime'} = 'responsetime';
cts.v = [cts.m_nV1 cts.m_nV2 cts.m_nV3];
cts(:,{'m_nV1','m_nV2','m_nV3'}) = [];
cts.Properties.VariableNames{'m_ucActiveChannel'} = 'activechannel';
cts.Properties.VariableNames{'m_szComment'} = 'comment';
cts.r = [cts.m_fR_X cts.m_fR_Y];
cts(:,{'m_fR_X','m_fR_Y'}) = [];
cts.Properties.VariableNames{'m_dTimeStamp'} = 'timestamp';
cts.Properties.VariableNames{'m_nLFPSampleRate'} = 'lfpfs';
cts.Properties.VariableNames{'m_nLFPChannels'} = 'lfpchannels';
cts.Properties.VariableNames{'m_nLFPGain'} = 'lfpgain';
cts.Properties.VariableNames{'m_wSpikeEvent'} = 'spikeevent';
cts.Properties.VariableNames{'m_dSpikeTime'} = 'spiketime';
cts.eyepoint = [cts.m_wEyePointX cts.m_wEyePointY];
cts(:,{'m_wEyePointX','m_wEyePointY'}) = [];
cts.Properties.VariableNames{'m_wEyePointTime'} = 'eyepointtime';
cts.Properties.VariableNames{'m_dKeyTime'} = 'keytime';
cts.Properties.VariableNames{'m_nKeyAction'} = 'keyaction';
cts.Properties.VariableNames{'m_dFPTime'} = 'fptime';
cts.Properties.VariableNames{'m_bFPAction'} = 'fpaction';
cts.Properties.VariableNames{'m_nLFPSample'} = 'lfpsample';
cts.condtestn = (1:height(cts))';
cts.item = cts.item + 1;

% Parsing FPAction and FPTime
cts.figontime = cellfun(@(x,y)y(x==VLabGlobal.FIG_ON),cts.fpaction,cts.fptime,'uniformoutput',false);
cts.figofftime = cellfun(@(x,y)y(x==VLabGlobal.FIG_OFF),cts.fpaction,cts.fptime,'uniformoutput',false);
cts.targetontime = cellfun(@(x,y)y(x==VLabGlobal.TARGET_ON),cts.fpaction,cts.fptime,'uniformoutput',false);
% for i=1:height(cts)
%
%
%     % Process Spike
%     se = cts(i).m_wSpikeEvent;
%     st = cts(i).m_dSpikeTime;
%     condtests.spikeevent{i,1} = se;
%     condtests.spiketime{i,1} = (st/VLabGlobal.TICK)-figontime;
%
% end

pblock = vlblock;
pblock.condtests = cts;
pblock.param.Condition = UnfoldCond(pblock.param.Condition);

end