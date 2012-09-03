function SPTC(sps,DataSet,freqrange,ch,sort)
% SPTC.m
% 2011-06-27 by Zhang Li
% Draw Spike Trian Power Spectrum Tuning Curve

if nargin < 3
    prompt = {'Start Frequency :','Stop Frequency :'};
    dlg_title = 'Spike Train Power Spectrum Tuning Curve';
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
%pu = 'Power (dB)';
pu = 'Normalized Power';

titlesize = 14;
textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fig_name = [DataSet.Mark.extype,'__',DataSet.Snip.spevent,...
    '__( C-',num2str(ch),'_U-',sort,' )__SPTC'];
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
Y = fmean(ps{1}.data);
%Y = 10*log10(Y); % Convert to dB

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
    %ls{j} = [num2str(sti(s)),' \circ'];
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
