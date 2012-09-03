function SPTM(sps,DataSet,freqrange,ch,sort)
% SPTM.m
% 2011-06-26 by Zhang Li
% Draw Spike Trian Power Spectrum Tuning Map

if nargin < 3
    prompt = {'Start Frequency :','Stop Frequency :'};
    dlg_title = 'Spike Train Power Spectrum Tuning Map';
    num_lines = 1;
    def = {'0','200'};
    input = inputdlg(prompt,dlg_title,num_lines,def);
    freqrange(1) = str2double(input{1});
    freqrange(2) = str2double(input{2});
end
if nargin > 3
    sps = pspt(DataSet,ch,sort);
else
    ch = sps{end}.params.ch;
    sort = sps{end}.params.sort;
end


if DataSet.Mark.stimuli==1
    disp('No Tuning !');
    warndlg('Only One Stimulus !','No Tuning');
    return;
end

ps = getps(sps,freqrange);
X = ps{end}.frequencies;
pu = 'dB';

textsize = 14;
fig_name = [DataSet.Mark.extype,'__',DataSet.Snip.spevent,...
    '__( C-',num2str(ch),'_U-',sort,' )__SPTM'];
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
y = fmean(ps{1}.data)';
color_n = 256;
cm = jet(color_n);

y = 10*log10(y); % Convert to dB
mmin = min(min(y));
mmax = max(max(y));
mrange = mmax-mmin;
y = mat2gray(y,[mmin mmax]);
[y, m] = gray2ind(y,color_n);

image([0 (DataSet.Mark.stimuli-1)/2],[freqrange(1) freqrange(2)],y);
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
            'String',{pu},'FitHeightToText','off','Position',[0.8645 0.895 0.25 0.07])
    otherwise
end

set(gca,'LineWidth',2,'FontSize',textsize,'box','off','YDir','normal','tickdir','out');
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
ylabel('Frequency (Hz)','FontSize',textsize);
xlabel(labelx,'FontSize',textsize);
