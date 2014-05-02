function [ vlblock ] = Prepare( vlblock,varargin )
%PREPARE Prepare VLab Block Data
%   Time Units are all ms

p = inputParser;
addRequired(p,'vlblock');
addParameter(p,'nivs','');
parse(p,vlblock,varargin{:});
vlblock = p.Results.vlblock;
nivs = p.Results.nivs;


import Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

if isa(vlblock,'char')
    vlblock = ReadVLBlock(vlblock,true);
end

disp(['Preparing Block Data: ',vlblock.source,' ...']);
% Prepare Condition Test Data
cts = struct2table(vlblock.data.condtests);
cts.Properties.VariableNames{'m_wFigDelay'} = 'figdelay';
cts.Properties.VariableNames{'m_dTime'} = 'condtestdur';
cts.condtestdur = double(cts.condtestdur);
cts.dtoa = [cts.m_fA_X cts.m_fA_Y];
cts.hv0 = [cts.m_fB_X cts.m_fB_Y];
if ~isa(cts.hv0,'double')
    cts.hv0 = double(cts.hv0);
end
cts(:,{'m_fB_X','m_fB_Y','m_fA_X','m_fA_Y'}) = [];
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
cts.timestamp = double(cts.timestamp);
vlblock.startime = cts.timestamp(1);
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
cts.figontime = cellfun(@(x,y)double(y(x==VLabGlobal.FIG_ON)),cts.fpaction,cts.fptime,'uniformoutput',false);
cts.figofftime = cellfun(@(x,y)double(y(x==VLabGlobal.FIG_OFF)),cts.fpaction,cts.fptime,'uniformoutput',false);
cts.targetontime = cellfun(@(x,y)double(y(x==VLabGlobal.TARGET_ON)),cts.fpaction,cts.fptime,'uniformoutput',false);
cts.figfixontime = cellfun(@(x,y)double(y(x==VLabGlobal.FIGFIX_ACQUIRED)),cts.fpaction,cts.fptime,'uniformoutput',false);
cts.figfixofftime = cellfun(@(x,y)double(y(x==VLabGlobal.FIGFIX_LOST)),cts.fpaction,cts.fptime,'uniformoutput',false);
cts.fixontime = cellfun(@(x,y)double(y(x==VLabGlobal.FIX_ACQUIRED)),cts.fpaction,cts.fptime,'uniformoutput',false);
cts.testontime = cellfun(@(x)double(x(1)),cts.fptime,'uniformoutput',false);
cts.testofftime = cellfun(@(x)double(x(end)),cts.fptime,'uniformoutput',false);

% Convert Raw Eye Point to Relative Value of Fixation Point
    function ep = ConvertEyeCoor(h,v,h0,v0,dtoah,dtoav,dtoah2,dtoav2)
        x = (h0 + h) * dtoah + (v0 + v) * dtoah2;
        y = (v0 + v) * dtoav + (h0 + h) * dtoav2;
        ep = double([x y]);
    end
if isa(cts.m_wEyePointX{1},'uint16')
    cts.m_wEyePointX = cellfun(@(x)double(x),cts.m_wEyePointX,'uniformoutput',false);
    cts.m_wEyePointY = cellfun(@(x)double(x),cts.m_wEyePointY,'uniformoutput',false);
end
cts.eyepoint = cellfun(@ConvertEyeCoor,cts.m_wEyePointX,cts.m_wEyePointY,num2cell(cts.hv0(:,1)),num2cell(cts.hv0(:,2)),...
    num2cell(cts.dtoa(:,1)),num2cell(cts.dtoa(:,2)),num2cell(cts.dtoa2(:,1)),num2cell(cts.dtoa2(:,2)),'uniformoutput',false);
if isa(cts.eyepointtime,'cell')
    cts.eyepointtime = cellfun(@(x)double(x),cts.eyepointtime,'uniformoutput',false);
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
    function aac = activechannel(ac)
        ac = cell2mat(ac);
        aac = ac(1,:);
        for i = 2:size(ac,1)
            aac = or(aac,ac(i,:));
        end
    end
vlblock.param.ActiveChannel = activechannel(cts.activechannel);
% Parsing Spike Events and Times
cts.spikeevent = cellfun(@(x)cell2mat(arrayfun(@(y)logical(bitget(y,1:16)),x,'uniformoutput',false)),...
    cts.spikeevent,'uniformoutput',false);
    function cst = ParseSpikeTime(ac,se,st)
        st = double(st)*Analysis.IO.VLabIO.VLabGlobal.TICK;
        chn = length(ac);
        cst = cell(1,chn);
        for i = 1:chn
            if ac(i) && ~isempty(st)
                cst{1,i} = st(se(:,i));
            end
        end
    end
cts.spike = cellfun(@ParseSpikeTime,cts.activechannel,cts.spikeevent,cts.spiketime,'uniformoutput',false);

% Merge condition tests timeline
cts.timestamp = cts.timestamp - vlblock.startime;
cts.figontime = arrayfun(@(x,y)x{1}+y,cts.figontime,cts.timestamp,'uniformoutput',false);
cts.figofftime = arrayfun(@(x,y)x{1}+y,cts.figofftime,cts.timestamp,'uniformoutput',false);
cts.figfixontime = arrayfun(@(x,y)x{1}+y,cts.figfixontime,cts.timestamp,'uniformoutput',false);
cts.figfixofftime = arrayfun(@(x,y)x{1}+y,cts.figfixofftime,cts.timestamp,'uniformoutput',false);
cts.targetontime = arrayfun(@(x,y)x{1}+y,cts.targetontime,cts.timestamp,'uniformoutput',false);
cts.fixontime = arrayfun(@(x,y)x{1}+y,cts.fixontime,cts.timestamp,'uniformoutput',false);
cts.eyepointtime = arrayfun(@(x,y)x{1}+y,cts.eyepointtime,cts.timestamp,'uniformoutput',false);
cts.testontime = arrayfun(@(x,y)x{1}+y,cts.testontime,cts.timestamp,'uniformoutput',false);
cts.testofftime = arrayfun(@(x,y)x{1}+y,cts.testofftime,cts.timestamp,'uniformoutput',false);

    function cs = mergespike(spike,ts,ac)
        cs = cell(1,Analysis.IO.VLabIO.VLabGlobal.SUPPORTCHANNEL);
        for i=1:length(spike)
            for j=1:Analysis.IO.VLabIO.VLabGlobal.SUPPORTCHANNEL
                st = spike{i}{j};
                if ac{i}(j) && ~isempty(st)
                    cs{j} = cat(1,cs{j}, st + ts(i));
                end
            end
        end
    end
vlblock.data.cellspike = mergespike(cts.spike,cts.timestamp,cts.activechannel);
vlblock.data.eyepoint = cell2mat(cellfun(@(x,y)[x y],cts.eyepointtime,cts.eyepoint,'uniformoutput',false));
% Remove Redundant Data
cts(:,{'activechannel','comment','spikeevent','spiketime','dtoa','hv0','dtoa2','eyepointtime','eyepoint','spike'}) = [];
% Remove Unused Data
cts(:,{'figdelay','keytime','keyaction','lfpfs','lfpchannels','lfpgain','lfpsample'}) = [];
vlblock.data.condtests = cts;


% Parsing Data Source
[path,name,ext] = fileparts(vlblock.source);
vlblock.param.DataPath = path;
vlblock.param.DataFile = name;
vlblock.param.DataExt = ext;
% Parsing Block Repeat
t1 = strfind(vlblock.source,vlblock.name);
if ~isempty(t1)
    t2 = strfind(vlblock.source,'.');
    vlblock.param.Repeat = str2double(vlblock.source(t1(end)+length(vlblock.name):t2(end)-1));
end
% Prepare Param
vlblock.param.IsRandom = logical(str2double(vlblock.param.IsRandom));
vlblock.param.IsBalanced = logical(str2double(vlblock.param.IsBalanced));
vlblock.param.SimulateParam = orderfields(trystr2num(vlblock.param.SimulateParam));
vlblock.param.SubjectParam = orderfields(trystr2double(vlblock.param.SubjectParam));
vlblock.param.AccumTimes = str2double(vlblock.param.AccumTimes);
vlblock.param.TrialN = str2double(vlblock.param.AccumedTimes);
vlblock.param = rmfield(vlblock.param,'AccumedTimes');
vlblock.param.SimulateFile = vlblock.param.IVFile;
vlblock.param = rmfield(vlblock.param,'IVFile');
vlblock.param.IsConditionFile = logical(str2double(vlblock.param.UseCustomItems));
vlblock.param = rmfield(vlblock.param,'UseCustomItems');
vlblock.param.ConditionFile = vlblock.param.CustomItems;
vlblock.param = rmfield(vlblock.param,'CustomItems');
vlblock.param.Begin = str2double(vlblock.param.Begin);
vlblock.param.End = str2double(vlblock.param.End);
vlblock.param.Step = str2double(vlblock.param.Step);
vlblock.param.IndieVar = vlblock.param.Param2Change;
vlblock.param = rmfield(vlblock.param,'Param2Change');
vlblock.param.StartTime = vlblock.startime;
if (vlblock.param.IsConditionFile && ~isempty(vlblock.param.ConditionFile)) || ~isempty(vlblock.param.IndieVar)
    vlblock.param.Condition = UnfoldCond(vlblock.param.Condition);
    UnfoldSubCond(vlblock);
    [vlblock.param.IVSpace,vlblock.param.IndieVar,vlblock.param.IVValue,vlblock.param.IV2C]...
        = Cond2IV(vlblock.param.Condition,vlblock.param.TestType,nivs);
else
    vlblock.param.Condition = table;
end

vlblock.param.IsPrepared = true;
vlblock.param = orderfields(vlblock.param);
disp('Done.');
end