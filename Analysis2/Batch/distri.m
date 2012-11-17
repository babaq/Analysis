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
            dist2 = ri.([type,'2']);
            avs2 = dist2(:,1);
            avf2 = dist2(:,2);
            dist4 = ri.([type,'4']);
            avs4 = dist4(:,1);
            avf4 = dist4(:,2);
        case {'da','dar','dsi'}
            dist = ri.adir;
            asi = ri.asi;
            ts = dist(:,1);
            tf = dist(:,2);
            as = asi(:,1);
            af = asi(:,2);
            dist2 = ri.adir2;
            asi2 = ri.asi2;
            ts2 = dist2(:,1);
            tf2 = dist2(:,2);
            as2 = asi2(:,1);
            af2 = asi2(:,2);
            dist4 = ri.adir4;
            asi4 = ri.asi4;
            ts4 = dist4(:,1);
            tf4 = dist4(:,2);
            as4 = asi4(:,1);
            af4 = asi4(:,2);
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
mcolorg = [0.15 0.55 0.15];
mcolory = [0.75 0.65 0.05];
mcolorr = [0.85 0.15 0.05];
mcolorm = [0.70 0.15 0.70];
mcolork = [0.15 0.70 0.70];

switch type
    case 'site'
        hB = barh(x,y,1);
        set(hB,'edgecolor','none','facecolor',mcolorb);
        hold on;
        plot([0 nlim],[md md],'k','Linewidth',2);
        set(gca,'LineWidth',2,'FontSize',textsize,'tickdir','out',...
            'XLim',[0 nlim],'box','off','YDir','reverse');
        temp = xu;
        xu = yu;
        yu = temp;
    case 'av'
        hc = compass(avs);
        set(hc,'color',mcolorr,'Linewidth',linewidth);
        hold on;
        hc = compass(avf);
        set(hc,'color',mcolordb,'Linewidth',linewidth);
        
        hc = compass(avs2);
        set(hc,'color',mcolory,'Linewidth',linewidth);
        hold on;
        hc = compass(avf2);
        set(hc,'color',mcolorg,'Linewidth',linewidth);
        
%         hc = compass(avs4);
%         set(hc,'color',mcolorm,'Linewidth',linewidth);
%         hold on;
%         hc = compass(avf4);
%         set(hc,'color',mcolork,'Linewidth',linewidth);
        
        set(gca,'LineWidth',axiswidth,'FontSize',textsize,'YLim',2*[-1 1],'box','off',...
            'xlim',2*[-1 1]);
    case 'da'
        thr = 0.0;
        [pus z] = circ_rtest(deg2rad(ts(as>thr)));
        [puf z] = circ_rtest(deg2rad(tf(af>thr)));
        [pus2 z2] = circ_rtest(deg2rad(ts2(as2>thr))*2);
        [puf2 z2] = circ_rtest(deg2rad(tf2(af2>thr))*2);
%         [pus m] = circ_otest(deg2rad(ts));
%         [puf m] = circ_otest(deg2rad(tf));


         
        tt = deg2rad(tf2);
        hp = polar(tt,af2,'s');
        set(hp,'MarkerSize',7,'MarkerEdgeColor',mcolorg,'MarkerFaceColor',mcolorg,'Linewidth',linewidth);
        hold on;
        tt = deg2rad(ts2);
        hp = polar(tt,as2,'s');
        set(hp,'MarkerSize',7,'MarkerEdgeColor',mcolory,'MarkerFaceColor',mcolory,'Linewidth',linewidth);
       
        tt = deg2rad(ts);
        hp = polar(tt,as,'o');
        set(hp,'MarkerSize',7,'MarkerEdgeColor',mcolorr,'MarkerFaceColor',mcolorr,'Linewidth',linewidth);
        hold on;
        tt = deg2rad(tf);
        hp = polar(tt,af,'o');
        set(hp,'MarkerSize',7,'MarkerEdgeColor',mcolordb,'MarkerFaceColor',mcolordb,'Linewidth',linewidth);
        
        
        set(gca,'LineWidth',axiswidth,'FontSize',textsize,'YLim',[-1 1],'box','off',...
            'xlim',[-1 1]);
        annotation('textbox',[0.68 0.8 0.1 0.1],'FontSize',textsize,'LineStyle','none',...
            'string',{['p_u_s=',num2str(pus)],['p_u_f=',num2str(puf)],...
            ['p_u_s_2=',num2str(pus2)],['p_u_f_2=',num2str(puf2)]});
    case 'dsi'
        bin = 0:0.2:1;
        [ds dxs dms dmaxs] = histd(as,bin);
        [df dxf dmf dmaxf] = histd(af,bin);
        [ds2 dxs2 dms2 dmaxs2] = histd(as2,bin);
        [df2 dxf2 dmf2 dmaxf2] = histd(af2,bin);
        nlim = round(1.1*max([dmaxs dmaxf dmaxs2 dmaxf2]));
        
        plot([dms dms],[0 nlim],'color',mcolorr,'Linewidth',linewidth);
        hold on;
        plot([dmf dmf],[0 nlim],'color',mcolorb,'Linewidth',linewidth);
        hold on;
        plot([dms2 dms2],[0 nlim],'color',mcolory,'Linewidth',linewidth);
        hold on;
        plot([dmf2 dmf2],[0 nlim],'color',mcolorg,'Linewidth',linewidth);
        hold on;
        hB = bar(dxs,[ds df ds2 df2],2.2,'grouped');
        set(hB(1),'edgecolor','none','facecolor',mcolorr);
        set(hB(2),'edgecolor','none','facecolor',mcolorb);
        set(hB(3),'edgecolor','none','facecolor',mcolory);
        set(hB(4),'edgecolor','none','facecolor',mcolorg);
        set(gca,'box','off','LineWidth',axiswidth,'FontSize',textsize,'tickdir','out',...
            'XLim',[0 1],'XTick',bin,'YLim',[0 nlim],'YTick',nlim);
        
        ylabel('Number','FontSize',textsize);
xlabel('ASI','FontSize',textsize);
    case 'dar'
        binw = 30*(2*pi/360);
        bin = 0:binw:2*pi;
        binx = bin+binw/2;
        binx(end) = binx(1);
        thr = 0.0;
        tys = ts(as>thr);
        tyf = tf(af>thr);
        tys2 = ts2(as2>thr);
        tyf2 = tf2(af2>thr);
        
        [pus z] = circ_rtest(deg2rad(tys)*4);
        [puf z] = circ_rtest(deg2rad(tyf)*2);
        [pus2 z2] = circ_rtest(deg2rad([tys2;tys2+180])*4);
        [puf2 z2] = circ_rtest(deg2rad([tyf2;tyf2+180])*4);
%         [pus m] = circ_otest(deg2rad(tys));
%         [puf m] = circ_otest(deg2rad(tyf));
%         [pus U UC] = circ_raotest(deg2rad(tys));
%         [puf U UC] = circ_raotest(deg2rad(tyf));
smoothn = 3;
method = 'sgolay';
b=1;
        
ys2 = histd(deg2rad([tys2; tys2+180]),bin);
ys2 = closmooth(ys2,smoothn,method);
        ys2 = [ys2;ys2(1)];
        ys2 = ys2+b;
            
            hp=polar(binx,ys2');
            set(hp,'color',mcolory,'linewidth',linewidth);
            hold on;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            yf2 = histd(deg2rad([tyf2; tyf2+180]),bin);
            yf2 = closmooth(yf2,smoothn,method);
        yf2 = [yf2;yf2(1)];
        yf2 = yf2+b;
            
            hp=polar(binx,yf2');
            set(hp,'color',mcolorg,'linewidth',linewidth);
            hold on;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ys = histd(deg2rad(tys),bin);
        ys = closmooth(ys,smoothn,method);
        ys = [ys;ys(1)];
        ys = ys+b;
            
            hp=polar(binx,ys');
            set(hp,'color',mcolorr,'linewidth',linewidth);
            hold on;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            yf = histd(deg2rad(tyf),bin);
            yf = closmooth(yf,smoothn,method);
        yf = [yf;yf(1)];
        yf = yf +b;
            
            hp=polar(binx,yf');
            set(hp,'color',mcolordb,'linewidth',linewidth);
            hold on;
            %%%%%%%%%%%%%
            tt = [0:0.01:2*pi 0];
            hp=polar(tt,b*ones(size(tt)));
            set(hp,'color','k','linewidth',linewidth);
            hold on;
            
        set(gca,'LineWidth',axiswidth,'FontSize',textsize,'box','off');
        annotation('textbox',[0.68 0.8 0.1 0.1],'FontSize',textsize,'LineStyle','none',...
            'string',{['ASI>',num2str(thr)],['p_u_s=',num2str(pus)],['p_u_f=',num2str(puf)],...
            ['p_u_s_2=',num2str(pus2)],['p_u_f_2=',num2str(puf2)]});
end

annotation('textbox',[0.18 0.8 0.1 0.1],'FontSize',textsize,'string',['n=',num2str(n)],'LineStyle','none');
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
