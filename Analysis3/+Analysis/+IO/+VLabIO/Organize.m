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
ctsseq = cell(tn,cn);

gsidx = GoodStatus(cts.status,badstatus);
for c=1:cn
    cidx = cts.condidx == c;
    ci = find(cidx);
    font = cts.figontime(ci);
    fofft = cts.figofftime(ci);
    ti = cts.trialidx(cidx);
    for i=1:length(ti)
        t = ti(i);
        v = true;
        ctsseq{t,c} = ci(i);
        figontime{t,c} = font{i};
        figofftime{t,c} = fofft{i};
        v = v & gsidx(ci(i));
        if figvalid
            v = v & ~isempty(font{i}) & ~isempty(fofft{i});
        end
        for j = 1:chn
            valididx(t,c,j) = v & ac(j);
        end
    end
end


block.data.valididx = valididx;
block.data.figontime = figontime;
block.data.figofftime = figofftime;
block.data.ctsseq = ctsseq;
block.param.AnalysisParam.BadStatus = badstatus;
block.param.AnalysisParam.GoodStatusIndex = gsidx;
block.param.AnalysisParam.FigValid = figvalid;
param = block.param;
data = block.data;
disp('Done.');
end

