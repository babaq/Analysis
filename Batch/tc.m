function tc(si,isfit,ei,ii)
% tc.m
% 2011-05-30 by Zhang Li
% Draw Batch Average Tuning Curve


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

extent = si.info.extent;
delay = si.info.delay;
stiend = si.info.stiend;
pret = si.info.pret;
post = si.info.post;
batchpath = si.info.batchpath;
unit = si.info.unit;
stitype = si.info.stitype;
ssttype = si.info.ssttype;
freqrange = si.info.freqrange;

if nargin > 2
    temp = si.tcs(ei,:);
    tcs = mean(temp,1);
    tcses = ste(temp,0,1);
    temp = si.tcs(ii,:);
    tcf = mean(temp,1);
    tcsef = ste(temp,0,1);
    tcsc = tcf;
    tcsesc = tcsef;
    issu = '_su';
else
    
    tcs = si.mtcs;
    tcses = si.tcses;
    tcf = si.mtcf;
    tcsef = si.tcsef;
    tcsc = si.mtcsc;
    tcsesc = si.tcsesc;
    issu = '';
end
sti = si.sti;
stin = length(sti);
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
    x = sti;
    ys = tcs;
    yf = tcf;
    ysc = tcsc;
    ars='';
end
[sis maxs mins] = SI(ys,x);
[sif maxf minf] = SI(yf,x);
[sisc maxsc minsc] = SI(ysc,x);


titlesize = 14;
textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',num2str(round(pret*10)),'_',num2str(round(post*10)),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_TC_',ssttype,isf,issu];
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

hE=errorbar(sti,tcs,tcses,'o','LineWidth',errorbarwidth,'color',mcolorr);
set(hE,'MarkerSize',7,'MarkerEdgeColor',mcolorr,'MarkerFaceColor',mcolorr);
hold on;
plot(x,ys,'-','Linewidth',linewidth,'color',mcolorr);
hold on;

hE=errorbar(sti,tcf,tcsef,'o','LineWidth',errorbarwidth,'color',mcolorb);
set(hE,'MarkerSize',7,'MarkerEdgeColor',mcolorb,'MarkerFaceColor',mcolorb);
hold on;
plot(x,yf,'-','Linewidth',linewidth,'color',mcolorb);
hold on;

hE=errorbar(sti,tcsc,tcsesc,'o','LineWidth',errorbarwidth,'color',mcolorg);
set(hE,'MarkerSize',7,'MarkerEdgeColor',mcolorg,'MarkerFaceColor',mcolorg);
hold on;
plot(x,ysc,'-','Linewidth',linewidth,'color',mcolorg);

set(gca,'LineWidth',axiswidth,'FontSize',textsize,'box','off','YTick',[-0.5 -0.25 0 0.5 1],'YLim',[-0.25 1],...
    'XTick',sti(1:2:end),'XLim',[min(sti)-max(sti)/40 max(sti)*(41/40)]);

annotation('textbox',[0.54 0.8 0.4 0.1],'FontSize',textsize,'LineStyle','none',...
    'string',{['SI = \color[rgb]',mcr,num2str(round(sis*100)/100),'\color{black}, \color[rgb]',mcb,num2str(round(sif*100)/100),'\color{black}, \color[rgb]',mcg,num2str(round(sisc*100)/100)],...
    ['\color{black}S_m_a_x = \color[rgb]',mcr,num2str(round(maxs*10)/10),' \circ\color{black}, \color[rgb]',mcb,num2str(round(maxf*10)/10),' \circ\color{black}, \color[rgb]',mcg,num2str(round(maxsc*10)/10),' \circ'],...
    ['\color{black}S_m_i_n = \color[rgb]',mcr,num2str(round(mins*10)/10),' \circ\color{black}, \color[rgb]',mcb,num2str(round(minf*10)/10),' \circ\color{black}, \color[rgb]',mcg,num2str(round(minsc*10)/10),' \circ'],ars});
ylabel('Normalized Response','FontSize',textsize);
xlabel('Stimulus Diameter (degrees)','FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',titlesize);
