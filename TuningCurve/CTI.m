function [M,SD,SE] = CTI(tdata,DataSet,ch_n,sort,ispolar)
% CTI.m
% 2009-06-30 by Zhang Li
% Draw Conditional Tuning Image
%
% tdata --- Stimulus Response from STC/WTC(DataSet)
% DataSet --- Whole DataSet
% ch_n --- Which Channal(int)
% sort --- Which Sort(string)
% ispolar --- if Draw in polar(bool)


if nargin<2
    disp('No Valid Arguments !');
    warndlg('No Valid Arguments !','Warnning');
    return;
end
type = tdata{end,1}.tmtype;
if nargin>2
    ch = num2str(ch_n);
else
    prompt = {['Which Channal { 0_ALL - ',num2str(DataSet.Snip.chn),' } :'],['Which Sort { ',num2str(DataSet.Snip.sortn),' } :'],'Is Polar { 0 - 1 } :'};
    dlg_title = 'Draw';
    num_lines = 1;
    def = {'1',type,'0'};
    input = inputdlg(prompt,dlg_title,num_lines,def);
    ch = input{1};
    sort = input{2};
    ispolar = str2double(input{3});
    ch_n = str2double(ch);
end

if DataSet.Mark.stimuli==1
    disp('Only One Stimulus !');
    warndlg('Only One Stimulus !','No Tuning');
    return;
end

if ispolar==1
    isp = '_TuningMap_p';
else
    isp = '_TuningMap';
end

tdata = ctc(tdata,DataSet);
c1 = DataSet.Mark.condtable{1};
c2 = DataSet.Mark.condtable{2};
tickx = 1:length(c2);
ticklabelx = cellfun(@(x)num2str(x),num2cell(c2),'uniformoutput',0);
ticklabelx{1} = 'NoSurround';
ticky = 1:length(c1);
ticklabely = cellfun(@(x)num2str(x),num2cell(c1),'uniformoutput',0);
ticklabely{1} = 'NoCenter';
textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
switch type
    case 'mfr'
        fig_name = [DataSet.Mark.extype,' __ ',DataSet.Snip.spevent,...
            ' __( C-',ch,'__U-',sort,' )',isp];
        yu = 'Firing Rate (spike/sec)';
        dec = 1;
    case 'rms'
        t = '_RMS';
        yu = 'uV';
        dec = 10;
        fig_name = [DataSet.Mark.extype,' __ ',DataSet.Wave.wvevent,...
            ' __( C-',ch,' )',t,isp];
    otherwise
        t = ['_',num2str(tdata{end,1}.freqrange(1)),'-',num2str(tdata{end,1}.freqrange(2)),'Hz'];
        yu = 'Power (uV2)';
        dec = 10;
        fig_name = [DataSet.Mark.extype,' __ ',DataSet.Wave.wvevent,...
            ' __( C-',ch,' )',t,isp];
end


scnsize = get(0,'ScreenSize');
output{1} = DataSet.OutputDir;
output{2} = fig_name;
output{3} = DataSet.Dinf.tank;
output{4} = DataSet.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86],...
    'Tag','T_Win',...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
color_n = 256;
cm = jet(color_n);


if ch_n==0 % Show All Channal
    for i=1:ch_max
        fr = tdata{i,end};
        
        fr = fr/max(max(fr));                     % Normalize
        mfr = mean(fr);                          % Mean firing rate for Stimuli of Trials
        sd = std(fr);                             % Standard Deviation for Stimuli
        se = sd/sqrt(DataSet.Mark.trial);          % Standard Error for Stimuli
        spon = mfr(1);                           % Background spontaneous firing rate
        mfr = circshift(mfr,[0 -1]);
        mfr(end) = mfr(1);
        se = circshift(se,[0 -1]);
        se(end) = se(1);
        
        if ispolar
            polar(0,1); % make all curves visible
            hold on;
            polar(theta,spon*ones(1,length(theta)),['-',cs(i)]);      % plot spontaneous firing rate
            hold on;
            hTuning=polar(theta,mfr,['-o',cs(i)]);        % plot polar tuning curve
            set(hTuning,'LineWidth',1,'MarkerSize',1);
            hold on;
        else
            plot([0 360],[spon spon],['-',cs(i)]);      % plot spontaneous firing rate
            hold on;
            hTuning=errorbar(sti,mfr,se,['-o',cs(i)]);   % plot Tuning curve
            set(hTuning,'LineWidth',1,'MarkerSize',1);
            hold on;
        end
    end
    
    ylabel('Firing Rate (spike/sec)');
    
    if isinfo && ~ispolar
        set(gca,'Box','off','XTick',[],'XLim',[-10 370],'YLim',[0 1]);
        axes('YAxisLocation','right','Color','none');
        for i=1:ch_max
            fr = tdata{i,end};
            Is = ITC(fr);                        % Information of Stimuli
            Is = Is/max(Is);                     % Normalize
            Ispon = Is(1);                       % Information of Background
            Is = circshift(Is,[0 -1]);
            Is(end) = Is(1);
            
            line('XData',[0 360],'YData',[Ispon Ispon],'Color',cs(i),'LineStyle',':');
            hITuning=line('XData',sti,'YData',Is,'Color',cs(i),'LineStyle',':','Marker','o');
            set(hITuning,'LineWidth',1,'MarkerSize',1);
        end
        set(gca,'XTick',[],'XLim',[-10 370],'YLim',[0 1]);
        ylabel('Information (bit)');
    end
    
else % Show single channal
    
    if strcmp(sort,'NO SORT !')
        errordlg('NO SORT DATA TO SHOW !','Data Error');
        return;
    end
    if strcmp(sort,'MU') || strcmp(sort,'rms') || strcmp(sort,'pspower') || strcmp(sort,'psdpower') % MU/Wave
        fr = tdata{ch_n,end};
    else % SU
        if strcmp(sort,'SU')
            sort_n = 1;
        else
            sort_n = str2double(sort(3:end));
        end
        fr = tdata{ch_n,sort_n};
    end
    
    M = squeeze(mean(fr));
    SD = squeeze(std(fr));
    SE = SD/sqrt(DataSet.Mark.trial);
    
    
    mmin = min(min(M));
    mmax = max(max(M));
    y = mat2gray(M,[mmin mmax]);
    mrange = mmax-mmin;
    [y, m] = gray2ind(y,color_n);
    
    %image([1 length(c2)],[1 length(c1)],y);
    image([1 length(c2)],[1 length(c1)],interp2(y,4,'cubic'));
    colormap(cm);
    
    tickn = (0:0.25:1);
    tick = tickn*(color_n-1)+1;
    tickny = round((mmin + tickn * mrange)*dec)/dec;
    for t=1:length(tickn)
        ticklabel{t} = num2str(tickny(t));
    end
    colorbar('LineWidth',axiswidth,'FontSize',textsize,'YTick',tick,'YTickLabel',ticklabel);
    
    annotation(hWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
        'String',{yu},'FitHeightToText','off','Position',[0.8645 0.895 0.25 0.07])
    
    set(gca,'LineWidth',axiswidth,'FontSize',textsize,'box','off','YDir','reverse',...
        'tickdir','out','Xtick',tickx,'xticklabel',ticklabelx,'ytick',ticky,'yticklabel',ticklabely);
    xlabel('Orientation Relative To Center (degrees)','FontSize',textsize);
    ylabel('Center Orientation (degrees)','FontSize',textsize);
    title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
    
end