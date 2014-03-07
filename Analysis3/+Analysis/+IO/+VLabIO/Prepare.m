function [ pblock ] = Prepare( vlblock )
%PREPARE Prepare VLab Block Data
%   Time Units are all ms

import Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

if isa(vlblock,'char')
    vlblock = ReadVLBlock(vlblock,true);
end

disp('Preparing Block Data ...');
% Prepare Condition Test Data
cts = struct2table(vlblock.data.condtests);
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
if isa(cts.m_wEyePointX{1},'uint16')
    cts.m_wEyePointX = cellfun(@(x)single(x),cts.m_wEyePointX,'uniformoutput',false);
    cts.m_wEyePointY = cellfun(@(x)single(x),cts.m_wEyePointY,'uniformoutput',false);
end
cts.eyepoint = cellfun(@ConvertEyeCoor,cts.m_wEyePointX,cts.m_wEyePointY,num2cell(cts.hv0(:,1)),num2cell(cts.hv0(:,2)),...
    num2cell(cts.dtoa(:,1)),num2cell(cts.dtoa(:,2)),num2cell(cts.dtoa2(:,1)),num2cell(cts.dtoa2(:,2)),'uniformoutput',false);
if isa(cts.eyepointtime,'cell')
    cts.eyepointtime = cellfun(@(x)single(x),cts.eyepointtime,'uniformoutput',false);
end
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
    VLabGlobal.TASKTRIAL_EARLY_RELEASE ;
    VLabGlobal.TASKTRIAL_DONE],...
    {'None';
    'Early';
    'Hit';
    'Miss';
    'Continue';
    'End';
    'Fail';
    'Repeat';
    'EarlyHold';
    'EarlyRelease';
    'Done'});
% Parsing Key Action
if ~isa(cts.keytime,'cell')
    cts.keyaction = categorical(cts.keyaction,...
        [VLabGlobal.KEY_Forward ;
        VLabGlobal.KEY_Backward ;
        VLabGlobal.KEY_Center ;
        VLabGlobal.KEY_Left ;
        VLabGlobal.KEY_Right],...
        {'Forward';
        'Backward';
        'Center';
        'Left';
        'Right'});
end
% Parsing Channel Bits
cts.activechannel = arrayfun(@(x)logical(bitget(x,1:VLabGlobal.SUPPORTCHANNEL)),cts.activechannel,'uniformoutput',false);
% Parsing Spike Events and Times
cts.spikeevent = cellfun(@(x)cell2mat(arrayfun(@(y)logical(bitget(y,1:16)),x,'uniformoutput',false)),...
    cts.spikeevent,'uniformoutput',false);
    function cst = ParseSpikeTime(ac,se,st,fot)
        st = single(st)*Analysis.IO.VLabIO.VLabGlobal.TICK;
        % Convert time relative to FigureOnTime, if it exists
        if ~isempty(fot)
            st = st - fot;
        end
        chn = length(ac);
        cst = cell(1,chn);
        for i = 1:chn
            if ac(i) && ~isempty(st)
                cst{1,i} = st(se(:,i));
            end
        end
    end
cts.spike = cellfun(@ParseSpikeTime,cts.activechannel,cts.spikeevent,cts.spiketime,cts.figontime,'uniformoutput',false);

% Remove Redundant Data
cts(:,{'activechannel','comment','spikeevent','spiketime','dtoa','hv0','dtoa2'}) = [];
pblock = vlblock;
pblock.data.condtests = cts;

% Parsing Data Source
[path,name,ext] = fileparts(pblock.source);
pblock.param.DataPath = path;
pblock.param.DataFile = name;
pblock.param.DataExt = ext;
% Parsing Block Repeat
t1 = strfind(pblock.source,pblock.name);
if ~isempty(t1)
    t2 = strfind(pblock.source,'.');
    pblock.param.Repeat = str2double(pblock.source(t1(end)+length(pblock.name):t2(end)-1));
end
% Prepare Param
pblock.param.AccumTimes = str2double(pblock.param.AccumTimes);
pblock.param.TrialN = str2double(pblock.param.AccumedTimes);
pblock.param = rmfield(pblock.param,'AccumedTimes');
pblock.param.SimulateFile = pblock.param.IVFile;
pblock.param = rmfield(pblock.param,'IVFile');
pblock.param.IsConditionFile = logical(str2double(pblock.param.UseCustomItems));
pblock.param = rmfield(pblock.param,'UseCustomItems');
pblock.param.ConditionFile = pblock.param.CustomItems;
pblock.param = rmfield(pblock.param,'CustomItems');
pblock.param.Begin = str2double(pblock.param.Begin);
pblock.param.End = str2double(pblock.param.End);
pblock.param.Step = str2double(pblock.param.Step);
pblock.param.IndieVar = pblock.param.Param2Change;
pblock.param = rmfield(pblock.param,'Param2Change');
if (pblock.param.IsConditionFile && ~isempty(pblock.param.ConditionFile)) || ~isempty(pblock.param.IndieVar)
    pblock.param.Condition = UnfoldCond(pblock.param.Condition);
    [pblock.param.IVSpace,pblock.param.IndieVar,pblock.param.IVValue,pblock.param.IV2C]...
        = Cond2IV(pblock.param.Condition,pblock.param.TestType);
end

pblock.param.IsRandom = logical(str2double(pblock.param.IsRandom));
pblock.param.IsBalanced = logical(str2double(pblock.param.IsBalanced));
pblock.param.IsPrepared = true;
pblock.param = orderfields(pblock.param);
pblock.param.SimulateParam = orderfields(pblock.param.SimulateParam);
pblock.param.SubjectParam = orderfields(pblock.param.SubjectParam);
end