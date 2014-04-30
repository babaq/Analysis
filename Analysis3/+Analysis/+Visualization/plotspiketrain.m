function [ output_args ] = plotspiketrain( data,param,range,trial,condition,cell,vps )
%PLOTSPIKETRAIN Summary of this function goes here
%   Detailed explanation goes here

import Analysis.Visualization.* Analysis.*

vi = data.valididx;
subparam = param.SubjectParam;
maxpreicidur = subparam.MaxPreICIDur;
maxsuficidur = subparam.MaxSufICIDur;
maxconddur = subparam.MaxCondDur;
datafile = param.DataFile;
vp = visprofile(vps);
if ischar(range)
    range = [-maxpreicidur maxconddur + maxsuficidur];
end

trialn = length(trial);
if trialn == 1
    if trial == 0
        trialn = size(vi,1);
        trialstring = 'all';
        trial = 1:trialn;
    else
        trialstring = num2str(trial);
    end
else
    trialstring = num2str(trial);
end
condn = length(condition);
if condn == 1
    if condition == 0
        condn = size(vi,2);
        condstring = 'all';
        condition = 1:condn;
    else
        condstring = num2str(condition);
    end
else
    condstring = num2str(condition);
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
spike = cutbin(data,param,range,[],false);
%% Ploting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotname = [datafile,'_T',trialstring,'_C',condstring,'_U',cellstring];
hf = newfig(plotname);
al = 0.04; % Axis Left Position
at = 0.95; % Axis Top Position
aw = 0.92; % Axis Width
wph = 0.04; % Wave Plot Height
sph = 0.03; % Spike Plot Height
sh = 0.03; % Spike Height
for i = 1:trialn
    subplot(trialn,1,i);
    X = spike{trial(i),condition,cell};
    Y = ones(size(X));
    ht = stem(X,Y,'LineWidth',vp.linewidth,'Marker','None');
    delete(get(ht,'Baseline'));
    hold on;
    plot([0 0],[0 1],'-k','LineWidth',vp.errorbarwidth);
    ylabel(['Trial ',num2str(trial(i))],'FontSize',vp.textsize);
    xlabel('Time (ms)','FontSize',vp.textsize);
    set(gca,'box','off','LineWidth',vp.axiswidth,'FontSize',vp.textsize,...
        'TickDir','out','YLim',[0 1],'XLim',range,...
        'Position',[al,at-i*sph,aw,sh]);
    axis off;
    if i==1 % title
        title(plotname,'Interpreter','none','FontWeight','bold','FontSize',vp.titlesize);
    end
end

end

