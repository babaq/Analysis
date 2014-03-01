function [ output_args ] = plotcond( data,param,range,delay,cell,vp )
%PLOTCOND Summary of this function goes here
%   Detailed explanation goes here

import Analysis.* Analysis.Visualization.*

spike = data.spike;
subparam = param.SubjectParam;
minconddur = str2double(subparam.MinCondDur);
datafile = param.DataFile;
vp = visprofile(vp);
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

data = mfr(data,param,range,delay);
pdata = data(:,:,cell);

plotname = [datafile,'_U',cellstring,'_D',num2str(delay),'_COND'];
hf = newfig(plotname);

pdata = cell2mat(pdata);
Y = mean(pdata);
Yse = ste(pdata);
ylimmax = 1.1*max(Y+Yse)+0.5;
ylimmin = min(0,1.1*min(Y-Yse)-0.5);
X = 1:length(Y);

he = errorbar(X,Y,Yse,'ok');
set(he,'LineWidth',vp.errorbarwidth,'MarkerSize',vp.markersize,...
    'MarkerEdgeColor','k','MarkerFaceColor','k');
hold on;
hc = plot(X,Y,'-k','LineWidth',vp.linewidth);

set(gca,'tickdir','out','Box','off','FontSize',vp.textsize,'LineWidth',vp.axiswidth,...
    'YLim',[ylimmin ylimmax]);
xlabel('Condition','FontSize',vp.textsize);
ylabel('Firing Rate (spikes/sec)','FontSize',vp.textsize);
title(plotname,'Interpreter','none','FontWeight','bold','FontSize',vp.titlesize);

end

