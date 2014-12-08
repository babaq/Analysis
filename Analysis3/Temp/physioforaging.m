function [ result ] = physioforaging( block, varargin )
%PHYSIOFORAGING Summary of this function goes here
%   Detailed explanation goes here

import Analysis.* Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

if isa(block,'cell')
    result = batch(block,{'physioforaging'},{varargin});
    return;
end

p = inputParser;
addRequired(p,'block');
addParameter(p,'nivs','');
addParameter(p,'range','d');
addParameter(p,'delay',50);
addParameter(p,'cell',1);
addParameter(p,'model','full');
addParameter(p,'display','on');
addParameter(p,'fixfactors',{'FigSide','EdgeContrast','RFTarget'});
addParameter(p,'fixseqfactors',{'ToPreRFFIG'});

parse(p,block,varargin{:});
block = p.Results.block;
nivs = p.Results.nivs;
range = p.Results.range;
delay = p.Results.delay;
cell = p.Results.cell;
anovamodel = p.Results.model;
displayanova = p.Results.display;
fixfactors = p.Results.fixfactors;
fixseqfactors = p.Results.fixseqfactors;

% [block.param.IVSpace,block.param.IndieVar,block.param.IVValue,block.param.IV2C]...
%     = Cond2IV(block.param.Condition,block.param.TestType,nivs);
% only analyze valid figure fixation
if isempty(block.param.AnalysisParam.BadStatus{1})
    disp('Exclude ''Early'' Test Trials ...');
    Organize(block,{'Early'});
end

%% Processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = block.data;
param = block.param;
cond = param.Condition;
cts = data.condtests;
ctsn = size(cts,1);
vi = data.valididx;
ctsseq = cell2matnn(data.ctsseq);
subparam = param.SubjectParam;
minfigfixdur = subparam.MinFigFixDur;
iv2c = param.IV2C;
if ischar(range)
    if range=='m'
        range = [0 minfigfixdur];
    else
        range = [0 minfigfixdur];
    end
end

processdata = mfr(data,param,range,delay);
pdata = processdata(:,:,cell);
pdata = cell2matnn(pdata);
pdcidx = arraypending(1:size(pdata,2),size(pdata,1));

% prepare all possible factors from fixation conditions
cond.RFTarget = double(cond.RFFIGTYPE == cond.REWARDTYPE);
cond.FixTarget = double(cond.FIXFIGTYPE == cond.REWARDTYPE);
cond.EdgeContrast = double(cond.ORFLIP == cond.REVCOL);
cond.FigSide = cond.ORFLIP;
% exclude no fig on RF conditions
ei = cond.RFFIGTYPE == -1;
epdata = pdata(:,~ei);
epdcidx = pdcidx(:,~ei);
ectsseq = ctsseq(:,~ei);
y = epdata(:);
vyidx = ~isnan(y);
vy = y(vyidx);
vytrans = anscombe(vy);
ycidx = epdcidx(:);
vycidx = ycidx(vyidx);
yctsidx = ectsseq(:);
vyctsidx = yctsidx(vyidx);
vycond = cond(vycidx,:);
fsvycondvi = table;
% prepare all possible factors from condition tests sequence
    function [pci,status] = precondi(ccs)
        if ccs==1
            pci = 0;
            status = categorical({'None'});
        else
            [t,pci]=find(ctsseq==(ccs-1));
            if cts.condidx0(ccs) ~= cts.condidx0(ccs-1)
                pci = 0;
                status = categorical({'None'});
            else
                status = cts.status(ccs-1);
            end
        end
    end
    function [sci,status] = sufcondi(ccs)
        if ccs==ctsn
            sci = 0;
            status = categorical({'None'});
        else
            [t,sci]=find(ctsseq==(ccs+1));
            if cts.condidx0(ccs) ~= cts.condidx0(ccs+1)
                sci = 0;
                status = categorical({'None'});
            else
                status = cts.status(ccs+1);
            end
        end
    end
vypci = arrayfun(@precondi,vyctsidx);
vysci = arrayfun(@sufcondi,vyctsidx);
    function vpci = vprecondi(ccs)
        while true
            [vpci,status] = precondi(ccs);
            if status == categorical({'Early'})
                ccs = ccs - 1;
            else
                break;
            end
        end
    end
    function vsci = vsufcondi(ccs)
        while true
            [vsci,status] = sufcondi(ccs);
            if status == categorical({'Early'})
                ccs = ccs + 1;
            else
                break;
            end
        end
    end
vyvpci = arrayfun(@vprecondi,vyctsidx);
vyvsci = arrayfun(@vsufcondi,vyctsidx);
    function prfft = prerffigtype(pci)
        if pci==0
            prfft = -1;
        else
            prfft = cond.RFFIGTYPE(pci);
        end
    end
    function srfft = sufrffigtype(sci)
        if sci==0
            srfft = -1;
        else
            srfft = cond.RFFIGTYPE(sci);
        end
    end
vycond.PreRFFIGTYPE = arrayfun(@prerffigtype,vypci);
fsvycondvi.PreRFFIGTYPE = vycond.PreRFFIGTYPE ~= -1;
vycond.vPreRFFIGTYPE = arrayfun(@prerffigtype,vyvpci);
vycond.SufRFFIGTYPE = arrayfun(@sufrffigtype,vysci);
fsvycondvi.SufRFFIGTYPE = vycond.SufRFFIGTYPE ~= -1;
vycond.vSufRFFIGTYPE = arrayfun(@sufrffigtype,vyvsci);
    function sffi = suffixfigidx(sci)
        if sci == 0
            sffi = -1;
        else
            sffi = cond.FIXFIGIDX(sci);
        end
    end
vycond.SufFIXFIGIDX = arrayfun(@suffixfigidx,vysci);
fsvycondvi.SufFIXFIGIDX = vycond.SufFIXFIGIDX ~= -1;
vycond.vSufFIXFIGIDX = arrayfun(@suffixfigidx,vyvsci);
fsvycondvi.vSufFIXFIGIDX = vycond.vSufFIXFIGIDX ~= -1;
vycond.ToPreRFFIG = double(vycond.RFFIGIDX == vycond.SufFIXFIGIDX);
fsvycondvi.ToPreRFFIG = vycond.SufFIXFIGIDX ~= -1;
vycond.vToPreRFFIG = double(vycond.RFFIGIDX == vycond.vSufFIXFIGIDX);
fsvycondvi.vToPreRFFIG = vycond.vSufFIXFIGIDX ~= -1;

vci = true(size(vy));
tfsvycondvi = fsvycondvi(:,fixseqfactors);
for i=1:size(tfsvycondvi,2)
    vci = vci & tfsvycondvi{:,i};
end

vcvy = vy(vci);
vcvytrans = vytrans(vci);
vcvyctsidx = vyctsidx(vci);
factors = [fixfactors fixseqfactors];
group = vycond{vci,factors};
group = mat2cell(group,size(group,1),ones(1,size(group,2)));

[p,anovatable,stats]=anovan(vcvy,group,'varnames',factors,'model',anovamodel,'display',displayanova);
[ptrans,anovatabletrans,statstrans]=anovan(vcvytrans,group,'varnames',factors,'model',anovamodel,'display',displayanova);
[c,m,h,gnames] = multcompare(stats,'display',displayanova,'estimate','anovan','dimension',1:size(group,2));
[ctrans,mtrans,htrans,gnamestrans] = multcompare(statstrans,'display',displayanova,'estimate','anovan','dimension',1:size(group,2));
result.y = vcvy;
result.ytrans = vcvytrans;
result.yctsidx = vcvyctsidx;
result.factors = factors;
result.group = group;
result.anova = anovatable;
result.anovatrans = anovatabletrans;
result.stats = stats;
result.statstrans = statstrans;
result.range = range;
result.delay = delay;

result.cellid = param.CellID;
result.testtype = param.TestType;
result.testrepeat = param.Repeat;

end