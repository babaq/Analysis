function [ param,cspike,clfp ] = Organize( block,badstatus )
%ORGANIZE Organize Prepared Data According to Experiment Design
%

import Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

if nargin < 2
    badstatus = {'Early','EarlyHold','EarlyRelease'};
end

chn = VLabGlobal.SUPPORTCHANNEL;
param = block.param;
cond = param.Condition;
cts = block.data.condtests;
tn = param.TrialN;
cn = height(cond);
cspike = cell(tn,cn);
clfp = cell(tn,cn);
figontime = cell(tn,cn);
figofftime = cell(tn,cn);

    function gs = GoodStatus(status,bs)
        gs = false;
        for bsi = 1: length(bs)
            gs = gs | status == bs{bsi};
        end
        gs = ~gs;
    end

gsidx = GoodStatus(cts.status,badstatus);
for c=1:cn
    cidx = cts.condidx == c;
    cgsidx = cidx&gsidx;
    tidx = cts.trialidx(cgsidx);
    if ~isempty(tidx)
        cs = cts.spike(cgsidx);
        font = cts.figontime(cgsidx);
        fofft = cts.figofftime(cgsidx);
        for i=1:length(tidx)
            t = tidx(i);
            figontime{t,c} = font{i};
            figofftime{t,c} = fofft{i};
            for j = 1:chn
                csc = cs{i}{j};
                % Task trial was tested, mark no spikes as NaN
                if isempty(csc)
                    csc = NaN;
                end
                cspike{t,c,j} = csc;
            end
        end
    end
end

block.data.spike = cspike;
block.data.lfp = clfp;
block.data.figontime = figontime;
block.data.figofftime = figofftime;
block.param.AnalysisParam.BadStatus = badstatus;
block.param.AnalysisParam.GoodStatusIndex = gsidx;
param = block.param;
end

