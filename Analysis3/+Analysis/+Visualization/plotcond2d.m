function [ processdata ] = plotcond2d( data,param,range,delay,cell,xvar,yvar,vps,varargin )
%PLOTCOND2D Summary of this function goes here
%   Detailed explanation goes here

import Analysis.* Analysis.Base.* Analysis.Visualization.*

ivn = length(param.IndieVar);
xvidx = find(xvar==categorical(param.IndieVar));
yvidx = find(yvar==categorical(param.IndieVar));
if isempty(xvidx)
    if ~isempty(xvar)
        error(['Test do not have variable: ',xvar]);
    end
end
if isempty(yvidx)
    if ~isempty(yvar)
        error(['Test do not have variable: ',yvar]);
    end
end

is1d = true;
if isempty(xvar) && isempty(yvar)
    var1d = '';
elseif isempty(xvar) && ~isempty(yvar)
    var1d = yvar;
elseif ~isempty(xvar) && isempty(yvar)
    var1d = xvar;
else
    is1d = false;
end
if is1d
    plotcond1d(data,param,range,delay,cell,var1d,vps);
    return;
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
        error(['Test do not have variable: ',evar]);
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
%% Preparing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spike = data.spike;
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
        celln = size(spike,3);
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
pdata = processdata(:,:,cell);
pdata = cell2matnn(pdata);
[ivm,ivse,ftn] = cellfmean(iv2ct(pdata,iv2c));

labelx = addunit(fullvarname(xvar));
plotsuffixx = ['_',xvar];
X = param.IVValue{xvidx};
xn = length(X);
if isa(X,'cell')
    xticklabel = X;
    X = 1:xn;
else
    xticklabel = cellstr(categorical(X));
end
labely = addunit(fullvarname(yvar));
plotsuffixy = ['_',yvar];
Y = param.IVValue{yvidx};
yn = length(Y);
if isa(Y,'cell')
    yticklabel = Y;
    Y = 1:yn;
else
    yticklabel = cellstr(categorical(Y));
end
xtickidx = 1:floor(xn/min(vp.maxtickn,xn)):xn;
ytickidx = 1:floor(yn/min(vp.maxtickn,yn)):yn;

if ivn >= 2
    evaridx = cell2mat(evaridx);
    [Z,Zse,ft] = fmean2(ivm,yvidx,xvidx,evaridx);
else
    
end
%Z = interp2(Z,vp.interptime,'cubic');
mmin = min(min(Z));
mmax = max(max(Z));
mrange = mmax-mmin;
Z = mat2gray(Z,[mmin mmax]);
[Z, m] = gray2ind(Z,vp.colorn);

%% Ploting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotname = [datafile,'_U',cellstring,'_D',num2str(delay),plotsuffixx,plotsuffixy,plotsuffixe];
hf = newfig(plotname);
colmap = gray(vp.colorn);
hi = image([X(1) X(end)],[Y(1) Y(end)],Z);
colormap(colmap);
tickn = 0:0.25:1;
tick = tickn*(vp.colorn-1);
ticknz = round((mmin + tickn * mrange)*vp.rd)/vp.rd;
for t=1:length(tickn)
    ticklabel{t} = num2str(ticknz(t));
end
colorbar('LineWidth',vp.axiswidth,'FontSize',vp.textsize,'YTick',tick,'YTickLabel',ticklabel);

xlabel(labelx,'FontSize',vp.textsize);
ylabel(labely,'FontSize',vp.textsize);
set(gca,'tickdir','out','Box','off','FontSize',vp.textsize,'LineWidth',vp.axiswidth,...
    'Color',vp.axiscolor,'YDir','Normal','DataAspectRatio',[1 1 1],...
    'XTick',X(xtickidx),'XTickLabel',xticklabel(xtickidx),...
    'YTick',Y(ytickidx),'YTickLabel',yticklabel(ytickidx));
title(plotname,'Interpreter','none','FontWeight','bold','FontSize',vp.titlesize);
end
