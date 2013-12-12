function [ cspike,clfp,oblock ] = Organize( block,badstatus )
%ORGANIZE Organize Prepared Data According to Experiment Design
%   

import Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

if nargin < 2
    badstatus = {'Early','Miss','Fail','EarlyHold'};
end

param = block.param;
cond = param.Condition;
cts = block.data.condtests;
tn = param.TrialN;
cn = height(cond);
cspike = cell(tn,cn);
clfp = cell(tn,cn);

    function gs = GoodStatus(status,bs)
        gs = false;
        for bsi = 1: length(bs)
            gs = gs | status == bs{bsi};
        end
        gs = ~gs;
    end

for c=1:cn
    cidx = cts.condidx == c;
    gsidx = GoodStatus(cts.status,badstatus);
    cgsidx = cidx&gsidx;
    tidx = cts.trialidx(cgsidx);
    if ~isempty(tidx)
        cs = cts.spike(cgsidx);
        for i=1:length(tidx)
            t = tidx(i);
            cspike{t,c} = cs{i};
        end
    end
end

oblock = block;
oblock.data.cspike = cspike;
oblock.data.clfp = clfp;
oblock.param.AnalysisParam.BadStatus = badstatus;
end

