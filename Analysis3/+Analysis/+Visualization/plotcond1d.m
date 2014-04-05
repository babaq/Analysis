function [ processdata ] = plotcond1d( data,param,range,delay,cell,xvar,vps,varargin )
%PLOTCOND1D Summary of this function goes here
%   Detailed explanation goes here

import Analysis.* Analysis.Base.* Analysis.Visualization.*

ivn = length(param.IndieVar);
xvidx = find(xvar==categorical(param.IndieVar));
if isempty(xvidx)
    if isempty(xvar)
        if ivn==1
            xvar = param.IndieVar{1};
            xvidx = 1;
        end
    else
        error(['Test do not have independent variable: ',xvar]);
    end
end
% Parsing Extra Variables
if mod(length(varargin),2) ~= 0
    varargin{end+1} = [];
end
evars = reshape(varargin,2,[])';
plotsuffixe=[];
evaridx = [];
for e=1:size(evars,1)
    evar = evars{e,1};
    evarv = categorical(evars{e,2});
    evidx = find(evar==categorical(param.IndieVar));
    if isempty(evidx)
        error(['Test do not have independent variable: ',evar]);
    end
    evv = param.IVValue{evidx};
    evvidx = find(evarv==categorical(evv));
    if isempty(evvidx)
        if ~isempty(evarv)
            error(['Variable do not have value: ',char(evarv)]);
        else
            evvidx = 1:length(evv);
        end
    end
    evaridx{e,1} = evidx;
    evaridx{e,2} = evvidx;
    plotsuffixe = [plotsuffixe,'_',evar,'=',char(evarv)];
end

vi = data.valididx;
subparam = param.SubjectParam;
minconddur = str2double(subparam.MinCondDur);
iv2c = param.IV2C;
datafile = param.DataFile;
vp = visprofile(vps);
if ischar(range)
    range = [0 minconddur];
end

celln = length(cell);
if celln == 1
    if cell == 0
        celln = size(vi,3);
        cellstring = 'all';
        cell = 1:celln;
    else
        cellstring = num2str(cell);
    end
else
    cellstring = num2str(cell);
end

%% Processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
processdata = mfr(data,param,range,delay);
condn = size(processdata,2);
pdata = processdata(:,:,cell);
pdata = cell2matnn(pdata);

if isempty(xvar)
    labelx = 'Condition';
    plotsuffixx = '_COND';
    X = 1:condn;
else
    labelx = addunit(fullvarname(xvar));
    plotsuffixx = ['_',xvar];
    X = param.IVValue{xvidx};
end
xn = length(X);
if isa(X,'cell')
    xticklabel = X;
    X = 1:xn;
else
    xticklabel = cellstr(categorical(X));
end
xlim = [min(X)-(max(X)-min(X))/20, max(X)+(max(X)-min(X))/20];
xtickidx = 1:floor(xn/min(vp.maxtickn,xn)):xn;

if isempty(xvar)
    [Y,Yse,ft] = fmean1(pdata,2);
else
    [ivm,ivse,ftn] = cellfmean1(iv2ct(pdata,iv2c),2);
    evaridx = cell2mat(evaridx);
    [Y,Yse,ft] = fmean1(ivm,xvidx,evaridx);
    if ivn==1
        Yse = ivse;
    else
    end
end
ylim = [min(0,1.1*min(Y-Yse)-0.5), 1.1*max(Y+Yse)+0.5];

%% Ploting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotname = [datafile,'_U',cellstring,'_D',num2str(delay),plotsuffixx,plotsuffixe];
hf = newfig(plotname);
he = errorbar(X,Y,Yse,'ok');
set(he,'LineWidth',vp.errorbarwidth,'MarkerSize',vp.markersize,...
    'MarkerEdgeColor','k','MarkerFaceColor','k');
hold on;
hc = plot(X,Y,'-k','LineWidth',vp.linewidth);

set(gca,'tickdir','out','Box','off','FontSize',vp.textsize,'LineWidth',vp.axiswidth,...
    'YLim',ylim,'XLim',xlim,'XTick',X(xtickidx),'XTickLabel',xticklabel(xtickidx));
xlabel(labelx,'FontSize',vp.textsize);
ylabel('Firing Rate (spikes/sec)','FontSize',vp.textsize);
title(plotname,'Interpreter','none','FontWeight','bold','FontSize',vp.titlesize);

end

