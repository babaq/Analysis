function AWTM(w,DataSet,ch_n,trial_n)
% AWTM.m
% 2011-04-10 by Zhang Li
% Draw Average Waveform Tuning Map

if isempty(w)
    w = wave(DataSet);
end
if nargin>2
    ch = num2str(ch_n);
    trial = num2str(trial_n);
else
    prompt = {['Which Channal { 1 - ',num2str(DataSet.Wave.chn),' } :'],['Which Trial { 0_Average - ',num2str(DataSet.Mark.trial),' } :']};
    dlg_title = 'Draw Average Wave Tuning Map';
    num_lines = 1;
    def = {'1','0'};
    input = inputdlg(prompt,dlg_title,num_lines,def);
    ch = input{1};
    trial = input{2};
    ch_n = str2double(ch);
    trial_n = str2double(trial);
end
if DataSet.Mark.stimuli==1
    disp('No Tuning !');
    warndlg('Only One Stimulus !','No Tuning');
    return;
end
yu = '\muV';

textsize = 14;
fig_name = [DataSet.Mark.extype,'__',DataSet.Wave.wvevent,...
    '__( C-',ch,' )__T-',trial,'_AWTM'];
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

color_n = 256;
cm = jet(color_n);

if trial_n==0 % Trial Average Wave
    y = Y';
else % single trial Wave
    y = squeeze(w{ch_n}(trial_n,:,:))';
end

mmax = max(max(abs(y)));
mmin = -mmax;
mrange = mmax-mmin;
y = mat2gray(y,[mmin mmax]);
[y, m] = gray2ind(y,color_n);

image([0 (DataSet.Mark.stimuli-1)/2],[0 max(X)],y);
colormap(cm);

tickn = (0:0.25:1);
tick = tickn*(color_n-1)+1;
tickny = round((mmin + tickn * mrange)*100)/100;
for t=1:length(tickn)
    ticklabel{t} = num2str(tickny(t));
end
colorbar('LineWidth',2,'FontSize',textsize,'YTick',tick,'YTickLabel',ticklabel);

switch DataSet.Mark.extype
    case {'fGrating','fGrating_Surround'}
    case 'RF_Size'
        labelx = 'Stimulus Diameter (degrees)';
        
        annotation(hWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
            'String',{yu},'FitHeightToText','off','Position',[0.8645 0.895 0.25 0.07])
    otherwise
end

set(gca,'LineWidth',2,'FontSize',textsize,'box','off','YDir','normal','tickdir','out');
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
ylabel('Time (ms)','FontSize',textsize);
xlabel(labelx,'FontSize',textsize);




function Win_CloseRequestFcn(hObject, eventdata, handles)

SaveFigure(hObject);

delete(hObject);

