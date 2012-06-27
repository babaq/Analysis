function distri(ri,type,dist,bin)
% distri.m %
% 2012-05-09 by Zhang Li
% Draw RF_Surround Statistics

extent = ri.info.extent;
delay = ri.info.delay;
batchpath = ri.info.batchpath;
unit = ri.info.unit;
stitype = ri.info.stitype;
freqrange = ri.info.freqrange;
srstype = ri.info.srstype;

if nargin < 3
    switch type
        case {'av'}
            dist = ri.(type);
            avs = dist(:,1);
            avf = dist(:,2);
        case {'da','dar'}
            dist = ri.adir;
            asi = ri.asi;
            ts = dist(:,1);
            tf = dist(:,2);
            as = asi(:,1);
            af = asi(:,2);
        case {'foosfoof'}
            xx = ri.('foos');
            xx = xx(:,1);
            yy = ri.('foof');
            yy = yy(:,1);
            dist = abs(xx-yy);
            dist(dist>90) = dist(dist>90)-180;
            dist = abs(dist);
            bin = (0:10:90);
            xu = 'Orientation Difference';
        case {'maxs','mins','maxf','minf','maxsc','minsc','res','ris','ref','rif','resc','risc'}
            dist = ri.(type);
            bin = (0:0.1:1)*stiend;
            xu = 'Stimulus Diameter (degrees)';
        case 'site'
            dist = ri.(type);
            bin = (0:0.1:1)*(max(dist)+100);
            xu = 'Recording Site Depth (\mum)';
    end
end

n = length(dist);


textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fig_name = ['SBRS_',num2str(extent),'_',num2str(delay),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_',type,'_',srstype];
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
    case 'av'
        hc = compass(avs);
        set(hc,'color',mcolorr,'Linewidth',linewidth);
        hold on;
        hc = compass(avf);
        set(hc,'color',mcolordb,'Linewidth',linewidth);
        set(gca,'LineWidth',axiswidth,'FontSize',textsize,'YLim',[-1 1],'box','off',...
            'xlim',[-1 1]);
    case 'da'
        [pus z] = circ_rtest(deg2rad(ts));
        [puf z] = circ_rtest(deg2rad(tf));
%         [pus m] = circ_otest(deg2rad(ts));
%         [puf m] = circ_otest(deg2rad(tf));

        hp = polar(deg2rad(ts),as,'o');
        set(hp,'MarkerSize',7,'MarkerEdgeColor',mcolorr,'MarkerFaceColor',mcolorr);
        hold on;
        hp = polar(deg2rad(tf),af,'o');
        set(hp,'MarkerSize',7,'MarkerEdgeColor',mcolordb,'MarkerFaceColor',mcolordb);
        set(gca,'LineWidth',axiswidth,'FontSize',textsize,'YLim',[-1 1],'box','off',...
            'xlim',[-1 1]);
        annotation('textbox',[0.68 0.8 0.1 0.1],'FontSize',textsize,'LineStyle','none',...
            'string',{['p_u_s=',num2str(pus)],['p_u_f=',num2str(puf)]});
    case 'dar'
        binw = 30*(2*pi/360);
        bin = 0:binw:2*pi;
        binx = bin+binw/2;
        binx(end) = binx(1);
        smoothn = 7;
        thr = 0.25;
        tys = ts(as<thr);
        tyf = tf(af<thr);
        
        [pus z] = circ_rtest(deg2rad(tys));
        [puf z] = circ_rtest(deg2rad(tyf));
        [pus m] = circ_otest(deg2rad(tys));
        [puf m] = circ_otest(deg2rad(tyf));
%         [pus U UC] = circ_raotest(deg2rad(tys));
%         [puf U UC] = circ_raotest(deg2rad(tyf));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        ys = histc(deg2rad(tys),bin);
            ys(end) = ys(1);
            ys = smooth(ys,smoothn,'sgolay');
            ys(end) = ys(1);
            
            hp=polar(binx,ys');
            set(hp,'color',mcolorr,'linewidth',linewidth);
            hold on;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            yf = histc(deg2rad(tyf),bin);
            yf(end) = yf(1);
            yf = smooth(yf,smoothn,'sgolay');
            yf(end) = yf(1);
            
            hp=polar(binx,yf');
            set(hp,'color',mcolordb,'linewidth',linewidth);
            hold on;
            
        set(gca,'LineWidth',axiswidth,'FontSize',textsize,'box','off');
        annotation('textbox',[0.68 0.8 0.1 0.1],'FontSize',textsize,'LineStyle','none',...
            'string',{['p_u_s=',num2str(pus)],['p_u_f=',num2str(puf)]});
end


annotation('textbox',[0.18 0.8 0.1 0.1],'FontSize',textsize,'string',['n=',num2str(n)],'LineStyle','none');
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
