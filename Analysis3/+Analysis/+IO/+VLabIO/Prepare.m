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
cts.Properties.VariableNames{'m_dTime'} = 'condtestdur';
cts.condtestdur = single(cts.condtestdur);
cts.dtoa = [cts.m_fA_X cts.m_fA_Y];
cts.hv0 = [cts.m_nB_X cts.m_nB_Y];
if isa(cts.hv0,'int32')
    cts.hv0 = single(cts.hv0);
end
cts(:,{'m_nB_X','m_nB_Y','m_fA_X','m_fA_Y'}) = [];
cts.Properties.VariableNames{'m_nItem'} = 'condidx';
cts.Properties.VariableNames{'m_nSet'} = 'trialidx';
cts.Properties.VariableNames{'m_nStatus'} = 'status';
cts.Properties.VariableNames{'m_nResponseTime'} = 'responsetime';
cts.v = [cts.m_nV1 cts.m_nV2 cts.m_nV3];
cts(:,{'m_nV1','m_nV2','m_nV3'}) = [];
cts.Properties.VariableNames{'m_ucActiveChannel'} = 'activechannel';
cts.Properties.VariableNames{'m_szComment'} = 'comment';
cts.dtoa2 = [cts.m_fR_X cts.m_fR_Y];
cts(:,{'m_fR_X','m_fR_Y'}) = [];
cts.Properties.VariableNames{'m_dTimeStamp'} = 'timestamp';
cts.Properties.VariableNames{'m_nLFPSampleRate'} = 'lfpfs';
cts.Properties.VariableNames{'m_nLFPChannels'} = 'lfpchannels';
cts.Properties.VariableNames{'m_nLFPGain'} = 'lfpgain';
cts.Properties.VariableNames{'m_wSpikeEvent'} = 'spikeevent';
cts.Properties.VariableNames{'m_dSpikeTime'} = 'spiketime';
cts.Properties.VariableNames{'m_wEyePointTime'} = 'eyepointtime';
cts.Properties.VariableNames{'m_dKeyTime'} = 'keytime';
cts.Properties.VariableNames{'m_nKeyAction'} = 'keyaction';
cts.Properties.VariableNames{'m_dFPTime'} = 'fptime';
cts.Properties.VariableNames{'m_bFPAction'} = 'fpaction';
cts.Properties.VariableNames{'m_nLFPSample'} = 'lfpsample';
cts.condtestidx = (1:height(cts))';
cts.condidx = cts.condidx + 1;
cts.trialidx = cts.trialidx + 1;

% Parsing FPAction and FPTime
cts.figontime = cellfun(@(x,y)single(y(x==VLabGlobal.FIG_ON)),cts.fpaction,cts.fptime,'uniformoutput',false);
cts.figofftime = cellfun(@(x,y)single(y(x==VLabGlobal.FIG_OFF)),cts.fpaction,cts.fptime,'uniformoutput',false);
cts.targetontime = cellfun(@(x,y)single(y(x==VLabGlobal.TARGET_ON)),cts.fpaction,cts.fptime,'uniformoutput',false);

% Convert Raw Eye Point to Relative Value of Fixation Point
    function ep = ConvertEyeCoor(h,v,h0,v0,dtoah,dtoav,dtoah2,dtoav2)
        x = (h0 + h) * dtoah + (v0 + v) * dtoah2;
        y = (v0 + v) * dtoav + (h0 + h) * dtoav2;
        r = sqrt(x.^2+y.^2);
        ep = [x y r];
    end
cts.eyepoint = cellfun(@ConvertEyeCoor,cts.m_wEyePointX,cts.m_wEyePointY,num2cell(cts.hv0(:,1)),num2cell(cts.hv0(:,2)),...
    num2cell(cts.dtoa(:,1)),num2cell(cts.dtoa(:,2)),num2cell(cts.dtoa2(:,1)),num2cell(cts.dtoa2(:,2)),'uniformoutput',false);
cts.eyepointtime = cellfun(@(x)single(x),cts.eyepointtime,'uniformoutput',false);
cts(:,{'m_wEyePointX','m_wEyePointY'}) = [];

% Parsing TASKTRIAL Status
cts.status = categorical(cts.status,...
    [VLabGlobal.TASKTRIAL_NONE ;
    VLabGlobal.TASKTRIAL_EARLY ;
    VLabGlobal.TASKTRIAL_HIT ;
    VLabGlobal.TASKTRIAL_MISS ;
    VLabGlobal.TASKTRIAL_CONTINUE ;
    VLabGlobal.TASKTRIAL_END ;
    VLabGlobal.TASKTRIAL_FAIL ;
    VLabGlobal.TASKTRIAL_REPEAT ;
    VLabGlobal.TASKTRIAL_EARLY_HOLD;
    VLabGlobal.TASKTRIAL_EARLY_RELEASE],...
    {'None';
    'Early';
    'Hit';
    'Miss';
    'Continue';
    'End';
    'Fail';
    'Repeat';
    'EarlyHold';
    'EarlyRelease'});
% Parsing Channel Bits
cts.activechannel = arrayfun(@(x)logical(bitget(x,1:8)),cts.activechannel,'uniformoutput',false);
% Parsing Spike Events and Times
cts.spikeevent = cellfun(@(x)cell2mat(arrayfun(@(y)logical(bitget(y,1:16)),x,'uniformoutput',false)),...
    cts.spikeevent,'uniformoutput',false);
cts.spiketime = cellfun(@(x)single(x)*VLabGlobal.TICK,cts.spiketime,'uniformoutput',false);
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
% Parsing Block Repeat
t1 = strfind(pblock.source,pblock.name);
if ~isempty(t1)
    t2 = strfind(pblock.source,'.');
    pblock.param.Repeat = str2double(pblock.source(t1(end)+length(pblock.name):t2(end)-1));
end

pblock.param.IsPrepared = true;
pblock.param = orderfields(pblock.param);
pblock.paramsim = orderfields(pblock.paramsim);
pblock.paramsub = orderfields(pblock.paramsub);
end