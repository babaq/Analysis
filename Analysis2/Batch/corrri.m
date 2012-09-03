function corrri(ri,xtype,ytype,x,y,lim)
% corrri.m %
% 2012-05-09 by Zhang Li
% Draw Batch Statistics

extent = ri.info.extent;
delay = ri.info.delay;
batchpath = ri.info.batchpath;
unit = ri.info.unit;
stitype = ri.info.stitype;
freqrange = ri.info.freqrange;
srstype = ri.info.srstype;

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
        case {'adirs','adirf'}
            xx = ri.(xtype(1:end-1));
            x = xx(:,1);
            y = xx(:,2);
            step = 90;
            lim = [0 360];
            xu = [xt,' Asymmetry Direction'];
            yu = [yt,' Asymmetry Direction'];
        case {'asis','asif'}
            xx = ri.(xtype(1:end-1));
            x = xx(:,1);
            y = xx(:,2);
            step = 0.2;
            lim = [0 1];
            xu = [xt,' Asymmetry Suppression Index'];
            yu = [yt,' Asymmetry Suppression Index'];
        case {'fgs','fgf','fgsc'}
            x = ri.(xtype);
            step = 0.5;
            limlow = 0;
            lim = 1;
            xu = [xt,' Fit Adj-R^2'];
        case {'maxs','mins','maxf','minf','maxsc','minsc','res','ris','ref','rif','resc','risc'}
            x = ri.(xtype);
            step = stiend/2;
            limlow = 0;
            lim = stiend+0.5;
            xu = 'Stimulus Diameter (degrees)';
    end
    switch ytype
        case {'cvs','cvf','cvsc'}
            yy = ri.(ytype);
            y = yy(:,1);
            yu = [yt,' CV'];
        case {'foos','foof','foosc'}
            yy = ri.(ytype);
            y = yy(:,1);
            vf = vf | yy(:,3)>thrars;
            yu = [yt,' Optimal Orientation'];
        case {'fgs','fgf','fgsc'}
            y = ri.(ytype);
            yu = [yt,' Fit Adj-R^2'];
        case {'maxs','mins','maxf','minf','maxsc','minsc','res','ris','ref','rif','resc','risc'}
            y = ri.(ytype);
            yu = 'Stimulus Diameter (degrees)';
    end
end



if size(x,2)>size(x,1)
    x = x';
end
if size(y,2)>size(y,1)
    y = y';
end
n = length(x);
mcolor = [0.15 0.25 0.45];
switch ytype
    case {'adirf'}
        [r rp] = circ_corrcc(deg2rad(x),deg2rad(y));
        p = NaN;
    otherwise
        [h p] = ttest(x,y,0.05,'both');
        [r rp] = corr(x,y,'type','pearson','rows','pairwise','tail','ne');
end

textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fig_name = ['SBRS_',num2str(extent),'_',num2str(delay),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_',xtype,'_',ytype,'_',srstype];
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
    'string',{['n=',num2str(n)],['p=',num2str(p)],['r=',num2str(r),' (p_r=',num2str(rp),')']});
ylabel(yu,'FontSize',textsize);
xlabel(xu,'FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
