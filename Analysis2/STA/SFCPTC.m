function SFCPTC(sfcdata,DataSet,freqrange,ch_s,sorts,ch_w)
% SFCPTC.m
% 2011-03-27 by Zhang Li
% Draw Spike Field Coherence Phase Tuning Curve

if nargin < 3
    prompt = {'Start Frequency :','Stop Frequency :'};
    dlg_title = 'Spike Field Coherence Tuning Curve';
    num_lines = 1;
    def = {'0','200'};
    input = inputdlg(prompt,dlg_title,num_lines,def);
    freqrange(1) = str2double(input{1});
    freqrange(2) = str2double(input{2});
end
if nargin > 3
    sfcdata = sfc(DataSet,ch_s,sorts,ch_w);
end
ch_s = sfcdata{end}.params.ch_s;
sorts = sfcdata{end}.params.sorts;
ch_w = sfcdata{end}.params.ch_w;
sfctype = sfcdata{end}.params.type;


if DataSet.Mark.stimuli==1
    disp('No Tuning !');
    warndlg('Only One Stimulus !','No Tuning');
    return;
end
cu = 'Phase';

textsize = 14;
fig_name = [DataSet.Mark.extype,'__',DataSet.Snip.spevent,...
    '__( C-',num2str(ch_s),'_U-',sorts,' ^ C-',num2str(ch_w),' )__SFCPTC_',sfctype];
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
switch sfctype
    case 'sfc'
        P = getps(sfcdata,freqrange);
        X = P{end}.frequencies;
        Y = fmean(P{1}.phase,'c');
        smoothn = 600;
    case 'stasfc'
        X = sfcdata{end}.frequencies;
        freqindex = (X>=freqrange(1)) & (X<=freqrange(2));
        X = X(freqindex);
        P = sfcdata{1}.phase;
        for s=1:length(P)
            temp = P{s}(:,freqindex);
            temp = double(fm(temp));
            Y(s,:) = circ_mean(temp,[],1);
        end
        smoothn = 60;
end

ac = [0.8 0.8 0.8]; % Axis Color
bc = [1 0.1 0.1]; % Begin Color
ec = [0.1 0.1 1]; % End Color
sti = DataSet.Mark.condtable{1};
cm = makeColorMap(bc,0.9*[1 1 1],ec,DataSet.Mark.stimuli-1);
step = 2; j = 1;
for s=1:step:DataSet.Mark.stimuli
    y = Y(s,:);
    y = circ_smooth(y,smoothn);
    y = pha2con(y);
    if s==1 % background
        cc = [0.3 0.3 0.3];
    else
        cc = cm(s-1,:);
    end
    plot(X,y,'color',cc,'linewidth',2);
    hold on;
    ls{j} = ['\color[rgb]','{',num2str(cc),'}',num2str(sti(s)),' \circ'];
    j = j + 1;
end

switch DataSet.Mark.extype
    case 'RF_Size'
        legend(ls,'Location','NorthEastOutside');
        legend show;
        legend boxoff;
    otherwise
end

set(gca,'LineWidth',2,'FontSize',textsize,'box','off','color',ac,...
    'XTick',freqrange(1):(freqrange(2)-freqrange(1))/10:freqrange(2),'XLim',[freqrange(1) freqrange(2)]);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
ylabel(cu,'FontSize',textsize);
xlabel('Frequency (Hz)','FontSize',textsize);
