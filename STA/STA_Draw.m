function STA_Draw(stadata,STAData,delay,hseg,ch_n1,ch_n2,sort,sti)
% STA_Draw.m
% 2011-03-27 by Zhang Li
% Draw Spike-Tiggered Averaing


if ch_n1==0 % For Each Channal
    ch1 = 'Each';
else
    ch1 = int2str(ch_n1);
end

if strcmpi(sort,'NOSORT')
    errordlg('NO SORT DATA TO SHOW !','Data Error');
    return;
elseif strcmpi(sort,'MU')
    sort_n = STAData.Snip.ppsortn(ch_n2);
else
    sort_n = str2double(sort(3:end));
end

if strcmp(sti,'ALL')
    sti_n = 0;
else
    sti_n = str2double(sti);
end

textsize = 14;
fig_name = [STAData.Mark.extype,'__',STAData.Snip.spevent,...
    '__( C-',ch1,' ^ C-',int2str(ch_n2),'_U-',sort,' )__S-',sti,'__',delay,'msDelay'];
scnsize = get(0,'ScreenSize');
output{1} = STAData.OutputDir;
output{2} = fig_name;
output{3} = STAData.Dinf.tank;
output{4} = STAData.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sti_max = STAData.Mark.stimuli;
column = 4;
if mod(sti_max,column)==0
    row = sti_max/column;
else
    row = floor(sti_max/column)+1;
end

sta = stadata{ch_n2,sort_n};
hsegn = str2double(hseg);
segl = size(sta{1},2);
hsegl = (segl-1)/2;
x = (-hsegl:hsegl);

if sti_n==0 % All Stimuli
    for s=1:sti_max
        Y(s,:) = mean(sta{s});
        Ysd(s,:) = std(sta{s});
        Trign(s) = size(sta{s},1);
        Yse(s,:) = Ysd(s,:)/sqrt(Trign(s));
    end
    ylim = 1.1*max(max(abs(Y)))+0.001;
    for s=1:sti_max
        subplot(row,column,s);
        
        y = Y(s,:);
        trign = Trign(s);
        yse = Yse(s,:);
        
        plot([0 0],[-ylim ylim],'-k','LineWidth',2);
        hold on;
        plot([-hsegl hsegl],[0 0],'-k','LineWidth',2);
        hold on;
        errorbar(x,y,yse,'.g','LineWidth',1);
        hold on;
        plot(x,y,'-b','LineWidth',2);
        
        set(gca,'LineWidth',2,'FontSize',textsize,'XLim',[-hsegl hsegl],'YLim',[-ylim ylim],...
            'XTick',[-hsegl 0 hsegl],'XTickLabel',[-hsegn 0 hsegn]);
        title(int2str(s),'Interpreter','none','FontWeight','bold','FontSize',textsize);
        ylabel('STA (\muV)','FontSize',textsize);
        xlabel('Time (ms)','FontSize',textsize);
        
        axis off;
    end
else % Single Stimuli
    y = mean(sta{sti_n});
    ysd = std(sta{sti_n});
    trign = size(sta{sti_n},1);
    yse = ysd/sqrt(trign);
    ylim = 1.1*max(abs(y))+0.001;
    
    plot([0 0],[-ylim ylim],'-k','LineWidth',2);
    hold on;
    plot([-hsegl hsegl],[0 0],'-k','LineWidth',2);
    hold on;
    errorbar(x,y,yse,'.g','LineWidth',1);
    hold on;
    plot(x,y,'-b','LineWidth',2);
    
    annotation(hWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
        'String',{[' TriggerN = ',num2str(trign)]},...
        'FitHeightToText','off','Position',[0.75 0.85 0.25 0.07]);
    
    set(gca,'LineWidth',2,'FontSize',textsize,'Box','on','XLim',[-hsegl hsegl],'YLim',[-ylim ylim],...
        'XTick',[-hsegl 0 hsegl],'XTickLabel',[-hsegn 0 hsegn]);
    title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
    ylabel('STA (\muV)','FontSize',textsize);
    xlabel('Time (ms)','FontSize',textsize);
end



function Win_CloseRequestFcn(hObject, eventdata, handles)

SaveFigure(hObject);

delete(hObject);