function STPSD_Draw(stps,DataSet,ch_n,trial_n,sti_n,freqrange,timerange,isdiff)
% STPSD_Draw.m
% 2011-04-18 by Zhang Li
% Draw Short-Time Power Spectrum


if nargin>2
    ch = num2str(ch_n);
    trial = num2str(trial_n);
    sti = num2str(sti_n);
else
    prompt = {['Which Channal { 1 - ',num2str(DataSet.Wave.chn),' } :'],['Which Trial { 0_Average - ',num2str(DataSet.Mark.trial),' } :'],...
        ['Which Stimulus { 0_ALL - ',num2str(DataSet.Mark.stimuli),' } :'],'Start Frequency :','Stop Frequency :',...
        'Start Time (ms) :','Stop Time (ms) :','If Subtract BaseLine :'};
    dlg_title = 'Draw Short-Time Power Spectrum';
    num_lines = 1;
    def = {'1','0','0','0','200','0','600','1'};
    input = inputdlg(prompt,dlg_title,num_lines,def);
    ch = input{1};
    trial = input{2};
    sti = input{3};
    freqrange = [str2double(input{4}) str2double(input{5})];
    timerange = [str2double(input{6}) str2double(input{7})];
    isdiff = str2double(input{8});
    ch_n = str2double(ch);
    trial_n = str2double(trial);
    sti_n = str2double(sti);
end
if DataSet.Mark.stimuli==1
    sti = '1';
    sti_n = 1;
end

STPS = getps(stps,DataSet,freqrange,timerange);
T = STPS{end}.time*1000; % ms
F = STPS{end}.frequencies;
p = fm(STPS{ch_n}.data);
window = STPS{end}.movingwin(1);
step = STPS{end}.movingwin(2);
if isdiff
    p = 10*log10(p);
    for i =2: size(p,2)
        p(:,i,:,:) = p(:,i,:,:)-p(:,1,:,:);
    end
end
Y = squeeze(mean(p));
yu = 'dB';

fig_name = [DataSet.Mark.extype,'__',DataSet.Wave.wvevent,...
    '__( C-',ch,'_S-',sti,' )__T-',trial,'_',num2str(window),'msWindow_',num2str(step),'msStep'];
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
color_n = 256;
cm = jet(color_n);

if sti_n==0 % All Stimuli
    
    if mod(DataSet.Mark.stimuli,4)==0
        row = DataSet.Mark.stimuli/4;
    else
        row = floor(DataSet.Mark.stimuli/4)+1;
    end
    
    for j=1:DataSet.Mark.stimuli
        subplot(row,4,j);
        
        if trial_n==0
            y = Y(j,:);
            y_se = Y_se(j,:);
            
            errorbar(X,y,y_se,'.b');
            hold on;
            plot(X,y,'r','LineWidth',1);
        else
            y = squeeze(stpower(trial_n,j,:));
            plot(X,y,'r','LineWidth',1);
        end
        
        set(gca,'XLim',[0 stop_freq],'YLim',[0 MAXP+0.01]);
        title(int2str(j),'Interpreter','none','FontWeight','bold','FontSize',10);
        ylabel('Power/Frequency [dB/Hz]');
        xlabel('Frequency [Hz]');
        
        axis off;
    end
    
else % Single Stimuli
    if trial_n == 0
        y = squeeze(Y(sti_n,:,:))';
    else
        y = squeeze(p(trial_n,sti_n,:,:))';
    end
    
    mmin = min(min(y));
    mmax = max(max(y));
    mrange = mmax-mmin;
    y = mat2gray(y,[mmin mmax]);
    [y, m] = gray2ind(y,color_n);
    
    image([0 max(T)],[freqrange(1) freqrange(2)],y);
    colormap(cm);
    
    tickn = (0:0.25:1);
    tick = tickn*(color_n-1)+1;
    tickny = round((mmin + tickn * mrange)*100)/100;
    for t=1:length(tickn)
        ticklabel{t} = num2str(tickny(t));
    end
    colorbar('YTick',tick,'YTickLabel',ticklabel);
    
    annotation(hWin,'textbox','LineStyle','none','Interpreter','tex',...
        'String',{yu},'FitHeightToText','off','Position',[0.8645 0.895 0.25 0.07]);
    
    set(gca,'box','off','YDir','normal','tickdir','out');
    title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);
    ylabel('Frequency (Hz)');
    xlabel('Time (ms)');
    
end


function Win_CloseRequestFcn(hObject, eventdata, handles)

SaveFigure(hObject);

delete(hObject);
