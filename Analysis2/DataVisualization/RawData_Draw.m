function RawData_Draw(rawdata,extent,ch,sti,snipmethod,wavemethod)
% RawData_Draw.m
% 2011-04-08 by Zhang Li
% Draw Raw Data


mcolorb = [0.15 0.25 0.55];
mcolorg = [0.15 0.75 0.25];
mcolorr = [0.85 0.15 0.05];

ch_n = str2double(ch);
sti_n = str2double(sti);
extent_n = str2double(extent);
if nargin < 5
    snipmethod = 'subplot';
    wavemethod = 'holdon';
elseif nargin < 6
    wavemethod = 'holdon';
end

% Check DataSet
subp_n = 0;
event = '';
datatype = 3; % No Data
if isfield(rawdata,'Snip')
    subp_n = subp_n + rawdata.Mark.trial;
    datatype = datatype-2;
    event = [event,rawdata.Snip.spevent];
end
if isfield(rawdata,'Wave')
    subp_n = subp_n + rawdata.Mark.trial;
    datatype = datatype-1;
    event = [event,rawdata.Wave.wvevent];
end
if datatype == 3 % No Data
    errordlg('NO DATA TO SHOW !','Data Error');
    return;
end

if datatype == 0 % Have Both Snip and Wave, give a chance to choose which
    selection = questdlg('Which Part of DataSet To Show ?',...
        'Which Part ...',...
        'Snip','Wave','Both','Both');
    if strcmp(selection,'Snip')
        subp_n = rawdata.Mark.trial;
        datatype = 1;
        event = rawdata.Snip.spevent;
    elseif strcmp(selection,'Wave')
        subp_n = rawdata.Mark.trial;
        datatype = 2;
        event = rawdata.Wave.wvevent;
    end
end

titlesize = 14;
textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fig_name = [rawdata.Mark.extype,'__',event,...
    '__( C-',ch,' )__( S-',sti,' )__',extent,'msExtent_RawData'];
scnsize = get(0,'ScreenSize');
output{1} = rawdata.OutputDir;
output{2} = fig_name;
output{3} = rawdata.Dinf.tank;
output{4} = rawdata.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
al = 0.04; % Axis left Position
at = 0.95; % Axis Top Position
aw = 0.92; % Axis Width
wph = 0.04; % Wave plot height
sph = 0.03; % Spike plot height
sh = 0.03; % Spike height
ylim = 200;
Yn = (subp_n-1)*2*ylim;
cs='rgbycm';

if datatype>0 % Snip or Wave
    %subp_n = 17;
    jump = 1;
    pn = 1;
    for i=1:jump:subp_n
        stidurms = (rawdata.Mark.off(i,sti_n) - rawdata.Mark.on(i,sti_n))*1000; % ms
        
        if datatype==1 % Snip
            switch snipmethod
                case 'subplot'
                    subplot(subp_n,1,i);
                    for j=1:rawdata.Snip.sortn(ch_n)  % each snip unit
                        X = rawdata.Snip.snip{ch_n,j}.ppspike{i,sti_n};
                        if ~isempty(X)
                            X = (X-rawdata.Mark.on(i,sti_n))*1000+extent_n;
                            
                            Y = ones(length(X),1);
                            hS = stem(X,Y,cs(j),'LineWidth',linewidth,'Marker','none');
                            delete(get(hS,'Baseline'));
                            hold on;
                        end
                    end
                    plot([extent_n extent_n],[0 1],'-k','LineWidth',errorbarwidth);
                    hold on;
                    plot([extent_n extent_n]+stidurms,[0 1],'-k','LineWidth',errorbarwidth);
                    
                    ylabel(['Trial ',int2str(i)],'FontSize',textsize);
                    xlabel('Time (ms)','FontSize',textsize);
                    set(gca,'box','off','LineWidth',axiswidth,'FontSize',textsize,'TickDir','out','YLim',[0 1],'XTick',0:200:stidurms+2*extent_n,...
                        'XLim',[0 stidurms+2*extent_n],'Position',[al,at-pn*sph,aw,sh]);
                    
                    %             set(gca,'box','off','LineWidth',2,'FontSize',textsize,'TickDir','out','YLim',[0 1],'XTick',0:200:stidurms+2*extent_n,...
                    %                 'XLim',[0 stidurms+2*extent_n]);
                    
                    axis off;
            end
        else % Wave
            Y = rawdata.Wave.wave{ch_n}.ppwave{i,sti_n};
            X = (0:length(Y)-1) * (1/rawdata.Wave.fs)*1000; % convert to ms
            switch wavemethod
                case 'subplot'
                    subplot(subp_n,1,i);
                    
                    plot(X,Y,'-b','LineWidth',2);
                    hold on;
                    plot([extent_n extent_n],[-ylim ylim],'-k','LineWidth',1);
                    hold on;
                    plot([extent_n extent_n]+stidurms,[-ylim ylim],'-k','LineWidth',1);
                    
                    ylabel('LFP (\muV)','FontSize',textsize);
                    xlabel('Time (ms)','FontSize',textsize);
                    set(gca,'box','off','LineWidth',2,'FontSize',textsize,'XTick',0:200:max(X),'XLim',[0 max(X)],'YLim',[-ylim ylim],...
                        'Position',[al,at-i*wph,aw,wph]);
                    
                    %             set(gca,'box','off','LineWidth',2,'FontSize',textsize,'XTick',0:200:max(X),'XLim',[0 max(X)],'YLim',[-ylim ylim]);
                    
                    axis off;
                case 'holdon'
                    plot(X,Yn-(i-1)*2*ylim+Y,'-b','LineWidth',linewidth);
                    hold on;
                    plot([extent_n extent_n],Yn-(i-1)*2*ylim+[-ylim ylim],'-k','LineWidth',errorbarwidth);
                    hold on;
                    plot([extent_n extent_n]+stidurms,Yn-(i-1)*2*ylim+[-ylim ylim],'-k','LineWidth',errorbarwidth);
                    hold on;
                    
                    ylabel('LFP (\muV)','FontSize',textsize);
                    xlabel('Time (ms)','FontSize',textsize);
                    set(gca,'box','off','LineWidth',axiswidth,'FontSize',textsize,'XTick',0:200:max(X),'XLim',[0 max(X)],'YLim',[-4*ylim Yn+4*ylim],...
                        'Position',[al,at-i*wph,aw,i*wph]);
                    
                    axis off;
            end
        end
        
        if i==1 % title
            title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',titlesize);
        end
        pn = pn + 1;
    end
    
else % Snip and Wave
    
    wph = 0.03; % Wave plot height
    sph = 0.02; % Spike plot height
    sh = 0.02; % Spike height
    %subp_n = 20;
    jump = 1;
    pn = 1;
    for i=1:jump:subp_n/2
        stidurms = (rawdata.Mark.off(i,sti_n) - rawdata.Mark.on(i,sti_n))*1000; % ms
        subplot(subp_n,1,2*i-1); % Wave -- 1, 3, 5, ...
        
        Y = rawdata.Wave.wave{ch_n}.ppwave{i,sti_n};
        X = (0:length(Y)-1) * (1/rawdata.Wave.fs)*1000; % convert to ms
        plot(X,Y,'-b','LineWidth',2);
        hold on;
        plot([extent_n extent_n],[-ylim ylim],'-k','LineWidth',1);
        hold on;
        plot([extent_n extent_n]+stidurms,[-ylim ylim],'-k','LineWidth',1);
        
        ylabel('LFP (\muV)','FontSize',textsize);
        xlabel('Time (ms)','FontSize',textsize);
        
        set(gca,'box','off','LineWidth',2,'FontSize',textsize,'XTick',0:200:max(X),'XLim',[0 max(X)],'YLim',[-ylim ylim],...
            'Position',[al,at-pn*(wph+sph),aw,wph]);
        
        axis off;
        
        if i==1 % title
            title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',titlesize);
        end
        
        
        subplot(subp_n,1,2*i); % Snip -- 2, 4, 6, ...
        
        for j=1:rawdata.Snip.sortn(ch_n)  % each snip unit
            X = rawdata.Snip.snip{ch_n,j}.ppspike{i,sti_n};
            if ~isempty(X)
                X = (X-rawdata.Mark.on(i,sti_n))*1000+extent_n;
                
                Y = ones(length(X),1);
                hS = stem(X,Y,cs(j),'LineWidth',2,'Marker','none');
                delete(get(hS,'Baseline'));
                hold on;
            end
        end
        plot([extent_n extent_n],[0 1],'-k','LineWidth',1);
        hold on;
        plot([extent_n extent_n]+stidurms,[0 1],'-k','LineWidth',1);
        
        ylabel(['Trial ',int2str(i)],'FontSize',textsize);
        xlabel('Time (ms)','FontSize',textsize);
        
        set(gca,'box','off','LineWidth',2,'FontSize',textsize,'TickDir','out','YLim',[0 1],'XTick',0:200:stidurms+2*extent_n,...
            'XLim',[0 stidurms+2*extent_n],'Position',[al,at-pn*(sph+wph)-sph,aw,sh]);
        
        axis off;
        pn = pn + 1;
    end
end

