function WPTC(psd,DataSet,ch_n,trial_n,freqrange)
% WPTC.m
% 2011-03-27 by Zhang Li
% Draw Wave Power Spectrum Tuning Curve

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
    dlg_title = 'Power Spectrum Tuning Curve';
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
    pu = 'Power (dB)';
else
    pu = 'Power Density (dB/Hz)';
end

titlesize = 14;
textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fig_name = [DataSet.Mark.extype,'__',DataSet.Wave.wvevent,...
    '__( C-',ch,' )__T-',trial,'__PSTC_',pstype];
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
z = squeeze(mean(power));

if trial_n==0 % Trial Average ps
    Y = z;
else % single trial ps
    Y = squeeze(power(trial_n,:,:));
end
Y = 10*log10(Y); % Convert to dB
%pu = 'Power (uV^2)';

bc = [1 0.1 0.1];
ec = [0.1 0.1 1];
sti = DataSet.Mark.condtable{1};
cm = makeColorMap(bc,0.9*[1 1 1],ec,DataSet.Mark.stimuli-1);
step = 2; j = 1;
for s=1:step:DataSet.Mark.stimuli
    y = Y(s,:);
    if s==1 % background
        cc = [0.3 0.3 0.3];
    else
        cc = cm(s-1,:);
    end
    plot(X,y,'color',cc,'linewidth',linewidth);
    hold on;
    ls{j} = ['\color[rgb]','{',num2str(cc),'}',num2str(sti(s)),' \circ'];
    j = j + 1;
end

switch DataSet.Mark.extype
    case 'RF_Size'
        legend(ls);
        legend show;
        legend boxoff;
    otherwise
end

set(gca,'LineWidth',axiswidth,'FontSize',textsize,'box','off',...
    'XTick',freqrange(1):(freqrange(2)-freqrange(1))/10:freqrange(2),'XLim',[freqrange(1) freqrange(2)]);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',titlesize);
ylabel(pu,'FontSize',textsize);
xlabel('Frequency (Hz)','FontSize',textsize);
