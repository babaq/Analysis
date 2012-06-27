function PSTHTM(DataSet,ch_n,sort,bin_n)
% PSTHTM.m
% 2011-03-25 by Zhang Li
% Draw PSTH Tuning Map

if nargin>1
    ch = num2str(ch_n);
    bin = num2str(bin_n);
else
    prompt = {['Which Channal { 1 - ',num2str(DataSet.Snip.chn),' } :'],['Which Sort { ',num2str(DataSet.Snip.sortn),' } :'],...
        'Bin (ms) :'};
    dlg_title = 'Draw PSTH Tuning Map';
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
cu = 'spikes/sec';
psthdata = CalcPSTH(DataSet,bin_n);

textsize = 14;
fig_name = [DataSet.Mark.extype,'__',DataSet.Snip.spevent,...
    '__( C-',ch,'_U-',sort,' )__',bin,'msBin__PSTHTM'];
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
y = squeeze(mean(psthdata{ch_n,sort_n}))';
X = (0:size(y,1)-1) * bin_n;
color_n = 256;
cm = jet(color_n);

mmin = min(min(y));
mmax = max(max(y));
mrange = mmax-mmin;
y = mat2gray(y,[mmin mmax]);
[y, m] = gray2ind(y,color_n);

image([0 (DataSet.Mark.stimuli-1)/2],[0 max(X)],y);
colormap(cm);

tickn = (0:0.25:1);
tick = tickn*(color_n-1)+1;
tickny = round(mmin + tickn * mrange);
for t=1:length(tickn)
    ticklabel{t} = num2str(tickny(t));
end
colorbar('LineWidth',2,'FontSize',textsize,'YTick',tick,'YTickLabel',ticklabel);

switch DataSet.Mark.extype
    case {'fGrating','fGrating_Surround'}
    case 'RF_Size'
        labelx = 'Stimulus Diameter (degrees)';
        
        annotation(hWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
            'String',{cu},'FitHeightToText','off','Position',[0.8645 0.895 0.25 0.07])
    otherwise
end

set(gca,'LineWidth',2,'FontSize',textsize,'box','off','YDir','normal','tickdir','out');
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
ylabel('Time (ms)','FontSize',textsize);
xlabel(labelx,'FontSize',textsize);



function Win_CloseRequestFcn(hObject, eventdata, handles)

SaveFigure(hObject);

delete(hObject);

