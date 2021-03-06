function sudistsi(si,type,ei,ii)
% sudistsi.m %
% 2011-06-09 by Zhang Li
% Draw Size Tuning Single-Unit Statistics

extent = si.info.extent;
delay = si.info.delay;
stiend = si.info.stiend;
batchpath = si.info.batchpath;
unit = si.info.unit;
stitype = si.info.stitype;
freqrange = si.info.freqrange;
ssttype = si.info.ssttype;

switch type
    case {'sis','sif','sisc'}
        x = si.(type);
        step = 0.5;
        [bin limlow lim] = fbin(x);
        xu = 'SI';
    case {'fgs','fgf','fgsc'}
        x = si.(type);
        step = 0.5;
            limlow = 0;
            lim = 1;
        bin = (0:0.1:1);
        xu = 'Fit Adj-R^2';
    case {'maxs','mins','maxf','minf','maxsc','minsc','res','ris','ref','rif','resc','risc'}
        x = si.(type);
        step = stiend/2;
            limlow = 0;
            lim = stiend+0.5;
        bin = (0:0.1:1)*stiend;
        xu = 'Stimulus Diameter (degrees)';
    case 'site'
        x = si.(type);
        bin = (0:0.1:1)*(max(x)+100);
        xu = 'Recording Site Depth (\mum)';
end
yu = 'Number of Cells';

function [bin limlow lim] = fbin(x)
        bmax = max(x);
        bmin = min(x);
        bmin = floor(bmin*10)/10;
        bmax = floor(bmax*10)/10;
        bin = (bmin:0.1:bmax+0.2);
        limlow = bin(1);
        lim = bin(end);
    end

[ed dx edm edmax] = dist(x(ei),bin);
[id dx idm idmax] = dist(x(ii),bin);
ne = length(ei);
ni = length(ii);

    function [d dx dm dmax] = dist(x,bin)
        d = histc(x,bin);
        d = d(1:end-1);
        dx = bin(1:end-1)+(bin(2)-bin(1))/2;
        dm = median(x);
        dmax = max(d);
    end


textsize = 14;
fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_su_',type,'_',ssttype];
scnsize = get(0,'ScreenSize');
output{1} = batchpath;
output{2} = fig_name;
output{3} = unit;
output{4} = stitype;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mcolorb = [0.15 0.25 0.55];
mcolorg = [0.25 0.85 0.35];
mcolorr = [0.85 0.15 0.05];
ylim = round(1.2*max(edmax,idmax));
p = ranksum(x(ei),x(ii),'method','exact','alpha',0.05);

switch type
    case 'site'
        hB = barh(dx,[ed' id'],2.2,'grouped');
        set(hB(1),'edgecolor','none','facecolor',mcolorr);
        set(hB(2),'edgecolor','none','facecolor',mcolorb);
        set(gca,'box','off','LineWidth',2,'FontSize',textsize,'tickdir','out',...
            'YLim',[bin(1) bin(end)],'XLim',[0 ylim],'YDir','reverse');
        temp = xu;
        xu = yu;
        yu = temp;
    otherwise
        hB = bar(dx,[ed' id'],2.2,'grouped');
        set(hB(1),'edgecolor','none','facecolor',mcolorr);
        set(hB(2),'edgecolor','none','facecolor',mcolorb);
        set(gca,'box','off','LineWidth',2,'FontSize',textsize,'tickdir','out',...
            'XLim',[limlow lim],'XTick',(limlow:step:lim),'YLim',[0 ylim],'YTick',ylim);
end

annotation('textbox',[0.18 0.8 0.1 0.1],'FontSize',textsize,'LineStyle','none',...
    'string',{['\color[rgb]{',num2str(mcolorr),'}n_e=',num2str(ne)],...
    ['\color[rgb]{',num2str(mcolorb),'}n_i=',num2str(ni)],['\color{black}p=',num2str(p)]});
ylabel(yu,'FontSize',textsize);
xlabel(xu,'FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);

end %eof