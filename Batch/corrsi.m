function corrsi(si,xtype,ytype,x,y,lim)
% corrsi.m %
% 2011-04-09 by Zhang Li
% Draw Size Tuning Statistics

extent = si.info.extent;
delay = si.info.delay;
stiend = si.info.stiend;
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
    xt = 'Unit Auto-Correlation';
end
if strcmp(ytype(end),'s')
    yt = 'Unit';
elseif strcmp(ytype(end),'f')
    yt = 'LFP';
else
    yt = 'Unit Auto-Correlation';
end
if nargin < 4
    switch xtype
        case {'sis','sif','sisc'}
            x = si.(xtype);
            step = 0.5;
            limlow = si.bin(1);
            lim = si.bin(end);
            xu = [xt,' SI'];
        case {'fgs','fgf','fgsc'}
            x = si.(xtype);
            step = 0.5;
            limlow = 0;
            lim = 1;
            xu = [xt,' Fit Adj-R^2'];
        case {'maxs','mins','maxf','minf','maxsc','minsc','res','ris','ref','rif','resc','risc'}
            x = si.(xtype);
            step = stiend/2;
            limlow = 0;
            lim = stiend+0.5;
            xu = 'Stimulus Diameter (degrees)';
    end
    switch ytype
        case {'sis','sif','sisc'}
            y = si.(ytype);
            yu = [yt,' SI'];
        case {'fgs','fgf','fgsc'}
            y = si.(ytype);
            yu = [yt,' Fit Adj-R^2'];
        case {'maxs','mins','maxf','minf','maxsc','minsc','res','ris','ref','rif','resc','risc'}
            y = si.(ytype);
            yu = 'Stimulus Diameter (degrees)';
    end
end

n = length(x);
mcolor = [0.15 0.25 0.45];
[r rp] = corr(x',y','type','spearman','rows','pairwise','tail','ne');

textsize = 14;
fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_',xtype,'_',ytype,'_',ssttype];
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
plot((limlow:2*lim),(limlow:2*lim),'-k','Linewidth',2);
hold on;
plot(x,y,'o','Linewidth',1,'MarkerSize',7,'MarkerEdgeColor',mcolor,'MarkerFaceColor',mcolor);
set(gca,'LineWidth',2,'FontSize',textsize,'YLim',[limlow lim],'XLim',[limlow lim],'XTick',(limlow:step:lim),'YTick',(limlow:step:lim),...
    'DataAspectRatio',[1 1 1]);

annotation('textbox',[0.24 0.8 0.1 0.1],'FontSize',textsize,'string',{['n=',num2str(n)],['r_s=',num2str(r)],['p=',num2str(rp)]},'LineStyle','none');
ylabel(yu,'FontSize',textsize);
xlabel(xu,'FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
