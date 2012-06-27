function WPTM(psd,DataSet,ch_n,trial_n,freqrange)
% WPTM.m
% 2011-03-08 by Zhang Li
% Draw Wave Power Spectrum Tuning Map

if nargin<2
    disp('No Valid Arguments !');
    warndlg('No Valid Arguments !','Warnning');
    return;
elseif nargin>2
    ch = num2str(ch_n);
    trial = num2str(trial_n);
else
    prompt = {['Which Channal { 1 - ',num2str(DataSet.Wave.chn),' } :'],['Which Trial { 0_Average - ',num2str(DataSet.Mark.trial),' } :'],...
              'Start Frequency :','Stop Frequency :'};
    dlg_title = 'Power Spectrum Tuning Map';
    num_lines = 1;
    def = {'1','0','0','200'};
    input = inputdlg(prompt,dlg_title,num_lines,def);
    ch = input{1};
    trial = input{2};
    freqrange(1) = str2double(input{3});
    freqrange(2) = str2double(input{4});
    ch_n = str2double(ch);
    trial_n = str2double(trial);
end

if DataSet.Mark.stimuli==1
    disp('No Tuning !');
    warndlg('Only One Stimulus !','No Tuning');
    return;
end


ps = getps(psd,freqrange);
pstype = ps{end}.pstype;
X = ps{end}.frequencies;
power = double(ps{ch_n}.data);
if strcmp(pstype,'ps')
    pu = 'dB';
else
    pu = 'dB/Hz';
end

textsize = 14;
fig_name = [DataSet.Mark.extype,'__',DataSet.Wave.wvevent,...
    '__( C-',ch,' )__T-',trial,'__PSTM_',pstype];
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
Y = squeeze(mean(power));
%Y = ssn(power);
color_n = 256;
cm = jet(color_n);

if trial_n==0 % Trial Average ps
    y = Y';
else % single trial ps
    y = squeeze(power(trial_n,:,:))';
end
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
