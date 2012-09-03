function distci(ci,type,dist,bin)
% distci.m %
% 2012-04-09 by Zhang Li
% Draw CenterSurround Statistics

extent = ci.info.extent;
delay = ci.info.delay;
batchpath = ci.info.batchpath;
unit = ci.info.unit;
stitype = ci.info.stitype;
freqrange = ci.info.freqrange;
scstype = ci.info.scstype;

if nargin < 3
    switch type
        case {'sis','sif','sisc'}
            dist = ci.(type);
            bin = ci.bin;
            xu = 'SI';
        case {'foos','foof','foosc'}
            xx = ci.(type);
            dist = xx(:,1);
            bin = (0:10:180);
            xu = 'Optimal Orientation';
        case {'foosfoof'}
            xx = ci.('foos');
            xx = xx(:,1);
            yy = ci.('foof');
            yy = yy(:,1);
            
            [rc pc] = circ_corrcc(deg2rad(xx*2), deg2rad(yy*2));
            [h p] = ttest(xx,yy,0.05,'both');
            
            dist = abs(xx-yy);
            dist(dist>90) = dist(dist>90)-180;
            dist = abs(dist);
            bin = (0:10:90);
            xu = 'Orientation Difference';
        case {'maxs','mins','maxf','minf','maxsc','minsc','res','ris','ref','rif','resc','risc'}
            dist = ci.(type);
            bin = (0:0.1:1)*stiend;
            xu = 'Stimulus Diameter (degrees)';
        case 'site'
            dist = ci.(type);
            bin = (0:0.1:1)*(max(dist)+100);
            xu = 'Recording Site Depth (\mum)';
    end
end
yu = 'Number of Cells';

switch type
    case {'foos','foof','foosc','foosfoof'}
        md = circ_median(deg2rad(dist));
        md = rad2deg(md);
    otherwise
        md = median(dist);
end
n = length(dist);
d = histc(dist,bin);
y = d(1:end-1);
ylim = max(y);
bw = bin(2)-bin(1);
x = bin(1:end-1)+bw/2;


textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fig_name = ['SBCS_',num2str(extent),'_',num2str(delay),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_',type,'_',scstype];
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
mcolordb = [0.15 0.25 0.45];
mcolorg = [0.25 0.85 0.35];
mcolorr = [0.85 0.15 0.05];

switch type
    case 'site'
        hB = barh(x,y,1);
        set(hB,'edgecolor','none','facecolor',mcolorb);
        hold on;
        plot([0 ylim],[md md],'k','Linewidth',2);
        set(gca,'LineWidth',2,'FontSize',textsize,'tickdir','out',...
            'XLim',[0 ylim],'box','off','YDir','reverse');
        temp = xu;
        xu = yu;
        yu = temp;
    otherwise
        hB = bar(x,y,1);
        set(hB,'edgecolor','k','facecolor',mcolordb);
        hold on;
        plot([md md],[0 ylim],'r','Linewidth',linewidth);
        set(gca,'LineWidth',axiswidth,'FontSize',textsize,'tickdir','out','YLim',[0 ylim],'box','off',...
            'Xtick',bin(1:3:end),'xlim',[bin(1) bin(end)]);
end


annotation('textbox',[0.18 0.8 0.1 0.1],'FontSize',textsize,'LineStyle','none',...
    'string',{['n=',num2str(n)],['p=',num2str(p)],['\Delta_m_d=',num2str(md),' \circ'],...
    ['r_c=',num2str(rc),' (p_c=',num2str(pc),')']});
ylabel(yu,'FontSize',textsize);
xlabel(xu,'FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
