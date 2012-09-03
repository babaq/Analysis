function ScatterHistogram2(si,xtype,ytype,x,y,lim)
% ScatterHistogram2.m
% 2011-05-08 by Zhang Li
% Draw a scatter with 2 histogram on side

extent = si.info.extent;
delay = si.info.delay;
stiend = si.info.stiend;
pret = si.info.pret;
post = si.info.post;
batchpath = si.info.batchpath;
unit = si.info.unit;
stitype = si.info.stitype;
freqrange = si.info.freqrange;
ssttype = si.info.ssttype;

if nargin < 2
    xtype = 'sis';
    ytype = 'sif';
end
if strcmp(xtype(end),'s')
    xt = 'Unit';
elseif strcmp(xtype(end),'f')
    xt = 'LFP';
else
    xt = 'Unit Power';
end
if strcmp(ytype(end),'s')
    yt = 'Unit';
elseif strcmp(ytype(end),'f')
    yt = 'LFP';
else
    yt = 'Unit Power';
end
if nargin < 4
    switch xtype
        case {'sis','sif','sisc'}
            x = si.(xtype);
            step = 0.5;
            limlow = si.bin(1);
            lim = si.bin(end);
            bin = si.bin;
            xu = [xt,' SI'];
        case {'fgs','fgf','fgsc'}
            x = si.(xtype);
            step = 0.5;
            limlow = 0;
            lim = 1;
            bin = (0:0.1:1);
            xu = [xt,' Fit Adj-R^2'];
        case {'maxs','mins','maxf','minf','maxsc','minsc','res','ris','ref','rif','resc','risc'}
            x = si.(xtype);
            step = stiend/2;
            limlow = 0;
            lim = stiend+0.5;
            bin = (0:0.1:1)*stiend;
            xu = 'Stimulus Diameter (degrees)';
    end
    switch ytype
        case {'sis','sif','sisc'}
            y = si.(ytype);
            [bin limlow lim] = fbin(x,y);
            
            yu = [yt,' SI'];
        case {'fgs','fgf','fgsc'}
            y = si.(ytype);
            yu = [yt,' Fit Adj-R^2'];
        case {'maxs','mins','maxf','minf','maxsc','minsc','res','ris','ref','rif','resc','risc'}
            y = si.(ytype);
            yu = 'Stimulus Diameter (degrees)';
    end
end

    function [bin limlow lim] = fbin(x,y)
        bmax = max(max(x),max(y));
        bmin = min(min(x),min(y));
        bmin = floor(bmin*10)/10;
        bmax = floor(bmax*10)/10;
        bin = (bmin:0.1:bmax+0.2);
        limlow = bin(1);
        lim = bin(end);
    end

titlesize = 14;
textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',num2str(round(pret*10)),'_',num2str(round(post*10)),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_',xtype,'_',ytype,'_',ssttype,'_SH2'];
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
n = length(x);
mcolor = [0.15 0.25 0.45];
bw = bin(2)-bin(1);
binx = bin(1:end-1)+bw/2;

[r rp] = corr(x',y','type','spearman','rows','pairwise','tail','ne');

d = histc(x,bin);
xdist = d(1:end-1);
xmd = median(x);
xm = mean(x);
xsd = std(x);
ylimx = max(xdist);

d = histc(y,bin);
ydist = d(1:end-1);
ymd = median(y);
ym = mean(y);
ysd = std(y);
ylimy = max(ydist);

p = signrank(x,y,'method','exact','alpha',0.05);
% p = signrank(xdist,ydist,'method','exact','alpha',0.05);
% p = signtest(xdist,ydist,'method','exact','alpha',0.05);
% [h p] = ttest(xdist,ydist,0.05,'both');
% [h p] = ttest(x,y,0.05,'left');
%% Draw Scatter
axes('position',[0.2 0.1 0.5 0.56]);
plot((limlow:2*lim),(limlow:2*lim),'-k','Linewidth',linewidth);
hold on;
plot(x,y,'o','Linewidth',errorbarwidth,'MarkerSize',7,'MarkerEdgeColor',mcolor,'MarkerFaceColor',mcolor);
set(gca,'LineWidth',axiswidth,'FontSize',textsize,'YLim',[limlow lim],'XLim',[limlow lim],'XTick',(limlow:step:lim),'YTick',(limlow:step:lim),'DataAspectRatio',[1 1 1]);
ylabel(yu,'FontSize',textsize);
xlabel(xu,'FontSize',textsize);
%% Draw X Histogram
axes('position',[0.2 0.68 0.5 0.28]);
hB = bar(binx,xdist,1);
set(hB,'edgecolor','none','facecolor',mcolor);
hold on;
plot([xmd xmd],[0 ylimx],'k','Linewidth',linewidth);
set(gca,'LineWidth',axiswidth,'FontSize',textsize,'tickdir','out','XTick',[],'YTick',ylimx,'XLim',[limlow lim],'YLim',[0 ylimx],'box','off','PlotBoxAspectRatio',[2 1 1]);
ylabel('Number of Cells','FontSize',textsize);
%% Draw Y Histogram
axes('position',[0.64 0.1 0.28 0.56]);
hB = barh(binx,ydist,1);
set(hB,'edgecolor','none','facecolor',mcolor);
hold on;
plot([0 ylimy],[ymd ymd],'k','Linewidth',linewidth);
set(gca,'LineWidth',axiswidth,'FontSize',textsize,'tickdir','out','YTick',[],'XTick',ylimy,'YLim',[limlow lim],'XLim',[0 ylimy],'box','off','PlotBoxAspectRatio',[1 2 1]);
xlabel('Number of Cells','FontSize',textsize);
%% Add Statistics
annotation('textbox',[0.58 0.80 0.1 0.1],'FontSize',textsize,...
    'string',{['n=',num2str(n)],['p=',num2str(p)],['r_s=',num2str(r),' (p_s=',num2str(rp),')'],...
    ['x_m=',num2str(xm),' (x_s_d=',num2str(xsd),')'],['y_m=',num2str(ym),' (y_s_d=',num2str(ysd),')']},'LineStyle','none');

end % eof