function [ param,data ] = Organize( block,badstatus,figvalid )
%ORGANIZE Organize Prepared Data According to Experiment Design
%

import Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

if nargin < 2
    badstatus = {'Early','EarlyHold','EarlyRelease'};
    figvalid = true;
elseif nargin < 3
    figvalid = true;
end

disp(['Organizing Block Data: ',block.source,' ...']);
chn = VLabGlobal.SUPPORTCHANNEL;
param = block.param;
ac = param.ActiveChannel;
cond = param.Condition;
cts = block.data.condtests;
tn = param.TrialN;
cn = height(cond);
valididx = false(tn,cn,chn);
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
        font = cts.figontime(cgsidx);
        fofft = cts.figofftime(cgsidx);
        for i=1:length(tidx)
            t = tidx(i);
            v = true;
            if figvalid
                v = v & ~isempty(font{i}) & ~isempty(fofft{i});
            end
            figontime{t,c} = font{i};
            figofftime{t,c} = fofft{i};
            for j = 1:chn
                valididx(t,c,j) = v & ac(j);
            end
        end
    end
end

block.data.valididx = valididx;
block.data.figontime = figontime;
block.data.figofftime = figofftime;
block.param.AnalysisParam.BadStatus = badstatus;
block.param.AnalysisParam.GoodStatusIndex = gsidx;
block.param.AnalysisParam.FigValid = figvalid;
param = block.param;
data = block.data;
disp('Done.');
end

