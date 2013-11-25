function [ pblock ] = Prepare( vlblock )
%PREPARE Organize VLab Data According to Experiment Design
%   Detailed explanation goes here

import Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

cts = vlblock.condtests;
for i=1:length(cts)
    condtests.figdelay(i,1) = cts(i).m_wFigDelay;
    condtests.time(i,1) = cts(i).m_dTime;
    condtests.a(i,:) = [cts(i).m_fA_X cts(i).m_fA_Y];
    condtests.b(i,:) = [cts(i).m_nB_X cts(i).m_nB_Y];
    
    condtests.item(i,1) = cts(i).m_nItem;
    condtests.set(i,1) = cts(i).m_nSet;
    condtests.status(i,1) = cts(i).m_nStatus;
    condtests.responsetime(i,1) = cts(i).m_nResponseTime;
    condtests.v(i,:) = [cts(i).m_nV1 cts(i).m_nV2 cts(i).m_nV3];
    condtests.r(i,:) = [cts(i).m_fR_X cts(i).m_fR_Y];
    
    condtests.activechannel(i,1) = cts(i).m_ucActiveChannel;
    condtests.timestamp(i,1) = cts(i).m_dTimeStamp;
    
    condtests.eyepoint{i,1} = [cts(i).m_wEyePointX cts(i).m_wEyePointY];
    condtests.eyepointtime{i,1} = cts(i).m_wEyePointTime;
    
%     condtests.keytime(i,1) = cts(i).m_dKeyTime;
%     condtests.keyaction(i,1) = cts(i).m_nKeyAction;

    
    % Parsing FPAction and FPTime
    fpt = cts(i).m_dFPTime;
    fpa = cts(i).m_bFPAction;
    condtests.fptime{i,1} = fpt;
    condtests.fpaction{i,1} = fpa;
    
    condtests.endtime(i,1) = fpt(end);
    figontime = ParseFP(fpt,fpa,VLabGlobal.FIG_ON);
    condtests.figontime(i,1) = figontime;
    targetontime = ParseFP(fpt,fpa,VLabGlobal.TARGET_ON);
    condtests.targetontime(i,1) = targetontime;
    figofftime = ParseFP(fpt,fpa,VLabGlobal.FIG_OFF);
    condtests.figofftime(i,1) = figofftime;
    
    % Process Spike
    se = cts(i).m_wSpikeEvent;
    st = cts(i).m_dSpikeTime;
    condtests.spikeevent{i,1} = se;
    condtests.spiketime{i,1} = (st/VLabGlobal.TICK)-figontime;
    
end

pblock = vlblock;
pblock.condtests = condtests;

    function fptime = ParseFP(fpt,fpa,action)
        fptime = fpt(fpa==action);
        if isempty(fptime)
            fptime = VLabGlobal.INVALIDTIME;
        end
    end
end

