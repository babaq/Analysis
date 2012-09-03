function PSTH_Draw(psthdata,PSTHData,delay,bin,ch,sort,sti)
% PSTH_Draw.m
% 2011-04-11 by Zhang Li
% Draw PSTH


bin_n = str2double(bin);
ch_n = str2double(ch);
if strcmpi(sort,'NOSORT')
    errordlg('NO SORT DATA TO SHOW !','Data Error');
    return;
elseif strcmpi(sort,'MU')
    sort_n = PSTHData.Snip.ppsortn(ch_n);
else
    sort_n = str2double(sort(3:end));
end
if strcmpi(sti,'ALL')
    sti_n = 0;
else
    sti_n = str2double(sti);
end

textsize = 14;
fig_name = [PSTHData.Mark.extype,'__',PSTHData.Snip.spevent,...
        '__( C-',ch,'_U-',sort,' )__S-',sti,'_',delay,'msDelay_',bin,'msBin'];
scnsize = get(0,'ScreenSize');
output{1} = PSTHData.OutputDir;
output{2} = fig_name;
output{3} = PSTHData.Dinf.tank;
output{4} = PSTHData.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y = squeeze(mean(psthdata{ch_n,sort_n}));
Ysd = squeeze(std(psthdata{ch_n,sort_n}));
Yse = Ysd/sqrt(PSTHData.Mark.trial);
X = (0:size(Y,2)-1) * bin_n;
barcolor = [0.15 0.25 0.45];

if sti_n==0 % All Stimuli
    column = 4;
    if mod(PSTHData.Mark.stimuli,column)==0
        row = PSTHData.Mark.stimuli/column;
    else
        row = floor(PSTHData.Mark.stimuli/column)+1;
    end
    ylim = 1.1*max(max(Y))+0.001;
    
    for s=1:PSTHData.Mark.stimuli
        subplot(row,column,s);
        
        y = Y(s,:);
        yse = Yse(s,:);
        
%         errorbar(X,y,yse,'.g');
%         hold on;
        hB = bar(X,y,1);
        
        set(hB,'edgecolor','none','facecolor',barcolor);
        set(gca,'tickdir','out','LineWidth',2,'FontSize',textsize,'XTick',0:200:max(X),'XLim',[0 max(X)],'YLim',[0 ylim]);
        title(int2str(s),'Interpreter','none','FontWeight','bold','FontSize',textsize);
        ylabel('PSTH (spikes/sec)','FontSize',textsize);
        xlabel('Time (ms)','FontSize',textsize);
        
        axis off;
    end
else % Single Stimuli
    y = Y(sti_n,:);
    yse = Yse(sti_n,:);
    ylim = 1.1*max(y)+0.001;
    
%     errorbar(X,y,yse,'.g');
%     hold on;
    hB = bar(X,y,1);
    
    set(hB,'edgecolor','none','facecolor',barcolor);
    set(gca,'tickdir','out','LineWidth',2,'FontSize',textsize,'box','off','XTick',0:200:max(X),'XLim',[0 max(X)],'YLim',[0 ylim]);
    title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
    ylabel('PSTH (spikes/sec)','FontSize',textsize);
    xlabel('Time (ms)','FontSize',textsize);
end



function Win_CloseRequestFcn(hObject, eventdata, handles)

SaveFigure(hObject);

delete(hObject);
