function corrci(ci,xtype,ytype,x,y,lim)
% corrci.m %
% 2012-04-09 by Zhang Li
% Draw Batch Statistics

extent = ci.info.extent;
delay = ci.info.delay;
batchpath = ci.info.batchpath;
unit = ci.info.unit;
stitype = ci.info.stitype;
freqrange = ci.info.freqrange;
scstype = ci.info.scstype;

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
step = 0.2;
thrars = 0.3;
if nargin < 4
    switch xtype
        case {'cvs','cvf','cvsc'}
            xx = ci.(xtype);
            x = xx(:,1);
            step = 0.2;
            lim = [0.4 1];
            xu = [xt,' CV'];
        case {'foos','foof','foosc'}
            xx = ci.(xtype);
            x = xx(:,1);
            vf = xx(:,3)>thrars;
            step = 45;
            lim = [0 180];
            xu = [xt,' Optimal Orientation'];
        case {'fgs','fgf','fgsc'}
            x = ci.(xtype);
            step = 0.5;
            limlow = 0;
            lim = 1;
            xu = [xt,' Fit Adj-R^2'];
        case {'maxs','mins','maxf','minf','maxsc','minsc','res','ris','ref','rif','resc','risc'}
            x = ci.(xtype);
            step = stiend/2;
            limlow = 0;
            lim = stiend+0.5;
            xu = 'Stimulus Diameter (degrees)';
    end
    switch ytype
        case {'cvs','cvf','cvsc'}
            yy = ci.(ytype);
            y = yy(:,1);
            yu = [yt,' CV'];
        case {'foos','foof','foosc'}
            yy = ci.(ytype);
            y = yy(:,1);
            vf = vf | yy(:,3)>thrars;
            yu = [yt,' Optimal Orientation'];
        case {'fgs','fgf','fgsc'}
            y = ci.(ytype);
            yu = [yt,' Fit Adj-R^2'];
        case {'maxs','mins','maxf','minf','maxsc','minsc','res','ris','ref','rif','resc','risc'}
            y = ci.(ytype);
            yu = 'Stimulus Diameter (degrees)';
    end
end

switch ytype
    case {'foos','foof','foosc'}
        x = x(vf);
        y = y(vf);
end

if size(x,2)>size(x,1)
    x = x';
end
if size(y,2)>size(y,1)
    y = y';
end
n = length(x);
mcolor = [0.15 0.25 0.45];
[r rp] = corr(x,y,'type','pearson','rows','pairwise','tail','ne');
%p = signrank(x,y,'method','exact','alpha',0.05);
[h p] = ttest(x,y,0.05,'both');
xm = mean(x);
xsd = std(x);
ym = mean(y);
ysd = std(y);

textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fig_name = ['SBCS_',num2str(extent),'_',num2str(delay),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_',xtype,'_',ytype,'_',scstype];
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
plot((lim(1):2*lim(2)),(lim(1):2*lim(2)),'-k','Linewidth',linewidth);
hold on;
plot(x,y,'o','Linewidth',linewidth,'MarkerSize',7,'MarkerEdgeColor',mcolor,'MarkerFaceColor',mcolor);
set(gca,'LineWidth',axiswidth,'FontSize',textsize,'YLim',[lim(1) lim(2)],'XLim',[lim(1) lim(2)],...
    'XTick',(lim(1):step:lim(2)),'YTick',(lim(1):step:lim(2)),'DataAspectRatio',[1 1 1]);

annotation('textbox',[0.24 0.8 0.1 0.1],'FontSize',textsize,'LineStyle','none',...
    'string',{['n=',num2str(n)],['p=',num2str(p)],['r_p=',num2str(r),' (p_p=',num2str(rp),')'],...
    ['x_m=',num2str(xm),' (x_s_d=',num2str(xsd),')'],['y_m=',num2str(ym),' (y_s_d=',num2str(ysd),')']});
ylabel(yu,'FontSize',textsize);
xlabel(xu,'FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
