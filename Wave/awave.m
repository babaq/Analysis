function awave(w,DataSet,ch_n,sti_n)
% awave.m
% 2011-04-12 by Zhang Li
% Draw Average Waveform


if isempty(w)
    w = wave(DataSet);
end
if nargin>2
    ch = num2str(ch_n);
    sti = num2str(sti_n);
else
    prompt = {['Which Channal { 1 - ',num2str(DataSet.Wave.chn),' } :'],['Which Stimulus { 0_ALL - ',num2str(DataSet.Mark.stimuli),' } :']};
    dlg_title = 'Draw Average Wave';
    num_lines = 1;
    def = {'1','0'};
    input = inputdlg(prompt,dlg_title,num_lines,def);
    ch = input{1};
    sti = input{2};
    ch_n = str2double(ch);
    sti_n = str2double(sti);
end
if DataSet.Mark.stimuli==1
    sti = '1';
    sti_n = 1;
end

textsize = 14;
fig_name = [DataSet.Mark.extype,'__',DataSet.Wave.wvevent,...
    '__( C-',ch,' )__S-',sti,'_AWave'];
scnsize = get(0,'ScreenSize');
output{1} = DataSet.OutputDir;
output{2} = fig_name;
output{3} = DataSet.Dinf.tank;
output{4} = DataSet.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y = squeeze(mean(w{ch_n}));
Ysd = squeeze(std(w{ch_n}));
Yse = Ysd/sqrt(DataSet.Mark.trial);
X = (0:(size(Y,2)-1)) * (1/DataSet.Wave.fs)*1000; % convert to ms

column = 4;
switch DataSet.Mark.extype
    case 'RF_Center'
        column = DataSet.Mark.key{3,2};
    case 'CenterSurround'
        column = length(DataSet.Mark.condtable{2});
end

if sti_n==0 % All Stimuli
    
    if mod(DataSet.Mark.stimuli,column)==0
        row = DataSet.Mark.stimuli/column;
    else
        row = floor(DataSet.Mark.stimuli/column)+1;
    end
    ylim = 1.1*max(max(abs(Y)))+0.001;
    for s=1:DataSet.Mark.stimuli
        subplot(row,column,s);
        
        y = Y(s,:);
        yse = Yse(s,:);
        
        errorbar(X,y,yse,'.g','LineWidth',1);
        hold on;
        plot(X,y,'-b','LineWidth',2);
        
        set(gca,'LineWidth',2,'FontSize',textsize,'XTick',0:200:max(X),'XLim',[0 max(X)],'YLim',[-ylim ylim]);
        title(int2str(s),'Interpreter','none','FontWeight','bold','FontSize',textsize);
        ylabel('MeanLFP (\muV)','FontSize',textsize);
        xlabel('Time (ms)','FontSize',textsize);
        
        axis off;
    end
else % Single Stimuli
    y = Y(sti_n,:);
    yse = Yse(sti_n,:);
    ylim = 1.1*max(abs(y))+0.001;
    
    errorbar(X,y,yse,'.g','LineWidth',1);
    hold on;
    plot(X,y,'-b','LineWidth',2);
    
    set(gca,'LineWidth',2,'FontSize',textsize,'box','off','XTick',0:200:max(X),'XLim',[0 max(X)],'YLim',[-ylim ylim]);
    title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
    ylabel('MeanLFP (\muV)','FontSize',textsize);
    xlabel('Time (ms)','FontSize',textsize);
end



function Win_CloseRequestFcn(hObject, eventdata, handles)

SaveFigure(hObject);

delete(hObject);
