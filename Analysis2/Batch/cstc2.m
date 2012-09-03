function cstc2(ci,isfit,ei,ii)
% cstc2.m
% 2012-04-30 by Zhang Li
% Draw Batch Average CenterSurround Tuning Curve


mcolorb = [0.15 0.25 0.55];
mcb = ['{',num2str(mcolorb),'}'];
mcolorg = [0.15 0.75 0.25];
mcg = ['{',num2str(mcolorg),'}'];
mcolorr = [0.85 0.15 0.05];
mcr = ['{',num2str(mcolorr),'}'];

if isfit
    isf = '_f';
else
    isf = '';
end

extent = ci.info.extent;
delay = ci.info.delay;
pret = ci.info.pret;
post = ci.info.post;
batchpath = ci.info.batchpath;
unit = ci.info.unit;
stitype = ci.info.stitype;
scstype = ci.info.scstype;
freqrange = ci.info.freqrange;

if nargin > 2
    temp = ci.tcs(ei,:);
    tcs = mean(temp,1);
    tcses = ste(temp,0,1);
    temp = ci.tcs(ii,:);
    tcf = mean(temp,1);
    tcsef = ste(temp,0,1);
    tcsc = tcf;
    tcsesc = tcsef;
    issu = '_su';
else
    oosurs = mean(ci.oosurs);
    oosurses = ste(ci.oosurs);
    oosurf = mean(ci.oosurf);
    oosursef = ste(ci.oosurf);
    oosursc = mean(ci.oosursc);
    oosursesc = ste(ci.oosursc);
    tcs = ci.mtcs;
    tcses = ci.tcses;
    tcf = ci.mtcf;
    tcsef = ci.tcsef;
    tcsc = ci.mtcsc;
    tcsesc = ci.tcsesc;
    sn = size(ci.oosurs,1);
    issu = '';
end

sti = ci.sti;
if isfit
    [scurvefit,sgoodness,sfitinfo] = SizeTuningFit(sti,tcs,'dog');
    [fcurvefit,fgoodness,ffitinfo] = SizeTuningFit(sti,tcf,'dog');
    [sccurvefit,scgoodness,scfitinfo] = SizeTuningFit(sti,tcsc,'dog');
    x = sti(1):(sti(2)-sti(1))/100:sti(end);
    ys = scurvefit(x);
    yf = fcurvefit(x);
    ysc = sccurvefit(x);
    arss=num2str(round(sgoodness.adjrsquare*1000)/1000);
    arsf=num2str(round(fgoodness.adjrsquare*1000)/1000);
    arssc=num2str(round(scgoodness.adjrsquare*1000)/1000);
    ars = ['\color{black}Adj-R^2 = \color[rgb]',mcr,arss,'\color{black}, \color[rgb]',mcb,arsf,'\color{black}, \color[rgb]',mcg,arssc];
else
    x = sti{2};
    x = circshift(x,[0 1]);
    x(:,[1 2]) = x(:,[2 1]);
    x(x>90) = 90-x(x>90);
    
    ys = oosurs;
    yses = oosurses;
    ys = circshift(ys,[0 1]);
    ys(:,[1 2]) = ys(:,[2 1]);
    nys = ys(:,1);
    ys(:,1) = ys(:,end);
    yses = circshift(yses,[0 1]);
    yses(:,[1 2]) = yses(:,[2 1]);
    nyses = yses(:,1);
    yses(:,1) = yses(:,end);
    
    yf = oosurf;
    ysef = oosursef;
    yf = circshift(yf,[0 1]);
    yf(:,[1 2]) = yf(:,[2 1]);
    nyf = yf(:,1);
    yf(:,1) = yf(:,end);
    ysef = circshift(ysef,[0 1]);
    ysef(:,[1 2]) = ysef(:,[2 1]);
    nysef = ysef(:,1);
    ysef(:,1) = ysef(:,end);
    
    ysc = oosursc;
    ysesc = oosursesc;
    ysc = circshift(ysc,[0 1]);
    ysc(:,[1 2]) = ysc(:,[2 1]);
    nysc = ysc(:,1);
    ysc(:,1) = ysc(:,end);
    ysesc = circshift(ysesc,[0 1]);
    ysesc(:,[1 2]) = ysesc(:,[2 1]);
    nysesc = ysesc(:,1);
    ysesc(:,1) = ysesc(:,end);
    
    x0 = x==0;
    x90=x==90;
    cs = abs(ys(x0)-ys(x90))/ys(x90);
    cf = abs(yf(x0)-yf(x90))/yf(x90);
    ps = signrank(ci.oosurs(:,2),ci.oosurs(:,4),'method','exact','alpha',0.05);
    pf = signrank(ci.oosurf(:,2),ci.oosurf(:,4),'method','exact','alpha',0.05);
%     [h ps] = ttest(ci.oosurs(:,2),ci.oosurs(:,4),0.05,'both');
%     [h pf] = ttest(ci.oosurf(:,2),ci.oosurf(:,4),0.05,'both');
    ars='';
end


textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
loc = 'northeastoutside';
fig_name = ['SBCS_',num2str(extent),'_',num2str(delay),...
    '_',num2str(round(pret*10)),'_',num2str(round(post*10)),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_CSTC2_',scstype,isf,issu];
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

% plot([x(1) x(end)],[nys nys],'Linewidth',linewidth,'color',mcolorr);
errorbar([x(1) x(end)],[nys nys],[nyses nyses],'Linewidth',linewidth,'color',mcolorr);
hold on;
hE=errorbar(x,ys,yses,'o','LineWidth',errorbarwidth,'color',mcolorr);
set(hE,'LineWidth',errorbarwidth,'MarkerSize',7,'MarkerEdgeColor',mcolorr,'MarkerFaceColor',mcolorr);
hold on;
hT = plot(x,ys,'-','Linewidth',linewidth,'color',mcolorr);
hold on;
h(1) = hT;
legendlabel{1} = 'Firing Rate';

% plot([x(1) x(end)],[nyf nyf],'Linewidth',linewidth,'color',mcolorb);
errorbar([x(1) x(end)],[nyf nyf],[nysef nysef],'Linewidth',linewidth,'color',mcolorb);
hold on;
hE=errorbar(x,yf,ysef,'o','LineWidth',errorbarwidth,'color',mcolorb);
set(hE,'LineWidth',errorbarwidth,'MarkerSize',7,'MarkerEdgeColor',mcolorb,'MarkerFaceColor',mcolorb);
hold on;
hT=plot(x,yf,'-','Linewidth',linewidth,'color',mcolorb);
hold on;
h(2) = hT;
legendlabel{2} = 'LFP Gamma Power';

% plot([x(1) x(end)],[nysc nysc],'Linewidth',linewidth,'color',mcolorg);
errorbar([x(1) x(end)],[nysc nysc],[nysesc nysesc],'Linewidth',linewidth,'color',mcolorg);
hold on;
hE=errorbar(x,ysc,ysesc,'o','LineWidth',errorbarwidth,'color',mcolorg);
set(hE,'LineWidth',errorbarwidth,'MarkerSize',7,'MarkerEdgeColor',mcolorg,'MarkerFaceColor',mcolorg);
hold on;
hT=plot(x,ysc,'-','Linewidth',linewidth,'color',mcolorg);
h(3) = hT;
legendlabel{3} = 'Spike Gamma Power';

set(gca,'LineWidth',axiswidth,'FontSize',textsize,'box','off',...
    'XTick',x);

legend(h,legendlabel);
%legend('location',loc);
legend('boxoff');

annotation('textbox',[0.24 0.8 0.3 0.1],'FontSize',textsize,'LineStyle','none',...
    'string',{['n=',num2str(sn)],['c_s=',num2str(cs)],['p_s=',num2str(ps)],...
    ['c_f=',num2str(cf)],['p_f=',num2str(pf)]});

annotation('textbox',[0.64 0.6 0.3 0.1],'FontSize',textsize,'LineStyle','none',...
    'string',{'Center alone'});

% annotation('textbox',[0.64 0.8 0.3 0.1],'FontSize',textsize,'LineStyle','none',...
%     'string',{['SI = \color[rgb]',mcr,num2str(round(sis*100)/100),'\color{black}, \color[rgb]',mcb,num2str(round(sif*100)/100),'\color{black}, \color[rgb]',mcg,num2str(round(sisc*100)/100)],...
%     ['\color{black}S_m_a_x = \color[rgb]',mcr,num2str(round(maxs*10)/10),' \circ\color{black}, \color[rgb]',mcb,num2str(round(maxf*10)/10),' \circ\color{black}, \color[rgb]',mcg,num2str(round(maxsc*10)/10),' \circ'],...
%     ['\color{black}S_m_i_n = \color[rgb]',mcr,num2str(round(mins*10)/10),' \circ\color{black}, \color[rgb]',mcb,num2str(round(minf*10)/10),' \circ\color{black}, \color[rgb]',mcg,num2str(round(minsc*10)/10),' \circ'],ars});

ylabel('Normalized Response','FontSize',textsize);
xlabel('Orientation Relative To Center (degrees)','FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
