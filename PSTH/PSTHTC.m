function PSTHTC(DataSet,ch_n,sort,bin_n)
% PSTHTC.m
% 2011-04-16 by Zhang Li
% Draw PSTH Tuning Curve

if nargin>1
    ch = num2str(ch_n);
    bin = num2str(bin_n);
else
    prompt = {['Which Channal { 1 - ',num2str(DataSet.Snip.chn),' } :'],['Which Sort { ',num2str(DataSet.Snip.sortn),' } :'],...
              'Bin (ms) :'};
    dlg_title = 'Draw PSTH Tuning Curve';
    num_lines = 1;
    def = {'1','MU','5'};
    input = inputdlg(prompt,dlg_title,num_lines,def);
    ch = input{1};
    sort = input{2};
    bin = input{3};
    ch_n = str2double(ch);
    bin_n = str2double(bin);
end
if DataSet.Mark.stimuli==1
    disp('No Tuning !');
    warndlg('Only One Stimulus !','No Tuning');
    return;
end
if strcmpi(sort,'MU')
    sort_n = DataSet.Snip.ppsortn(ch_n);
else
    sort_n = str2double(sort(3:end));
end
yu = 'PSTH (spikes/sec)';
psthdata = CalcPSTH(DataSet,bin_n);

textsize = 14;
fig_name = [DataSet.Mark.extype,'__',DataSet.Snip.spevent,...
    '__( C-',ch,'_U-',sort,' )__',bin,'msBin_PSTHTC'];
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
Y = squeeze(mean(psthdata{ch_n,sort_n}));
Ysd = squeeze(std(psthdata{ch_n,sort_n}));
Yse = Ysd/sqrt(DataSet.Mark.trial);
X = (0:size(Y,2)-1) * bin_n;

ac = [0.8 0.8 0.8]; % Axis Color
bc = [1 0.1 0.1]; % Begin Color
ec = [0.1 0.1 1]; % End Color
sti = DataSet.Mark.condtable{1};
cm = makeColorMap(bc,0.9*[1 1 1],ec,DataSet.Mark.stimuli-1);
step = 2; j = 1;
for s=1:step:DataSet.Mark.stimuli
    y = Y(s,:);
    y = smooth(y,9,'sgolay');
    yse = Yse(s,:);
    if s==1 % background
        cc = [0.3 0.3 0.3];
    else
        cc = cm(s-1,:);
    end
%     errorbar(X,y,yse,'.','color',cc);
%     hold on;
    plot(X,y,'color',cc,'linewidth',2.5);
    hold on;
    ls{j} = ['\color[rgb]','{',num2str(cc),'}',num2str(sti(s)),' \circ'];
    j = j + 1;
end

ylim = 1.1*max(max(Y))+0.001;
switch DataSet.Mark.extype
    case 'RF_Size'
        legend(ls,'Location','NorthEastOutside');
        legend show;
        legend boxoff;
    otherwise
end

set(gca,'LineWidth',2,'FontSize',textsize,'box','off','color',ac,...
    'XTick',0:200:max(X),'XLim',[0 max(X)],'YLim',[0 ylim]);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
ylabel(yu,'FontSize',textsize);
xlabel('Time (ms)','FontSize',textsize);


function Win_CloseRequestFcn(hObject, eventdata, handles)

SaveFigure(hObject);

delete(hObject);

