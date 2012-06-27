function WTC_Draw(tdata,DataSet,ch,ispolar,isfit)
% WTC_Draw.m
% 2011-03-13 by Zhang Li
% Draw Wave TuningCurve


if nargin < 4
    ispolar = 0;
    isfit = 0;
elseif nargin < 5
    isfit = 0;
end


if strcmpi(ch,'ALL')
    ch_n = 0;
else
    ch_n = str2double(ch);
end

if ispolar
    isp = '_p';
else
    isp = '';
end
if isfit
    isf = '_f';
else
    isf = '';
end
ch_max = DataSet.Wave.chn;

if DataSet.Mark.stimuli==1
    disp('Only One Stimulus !');
    warndlg('Only One Stimulus !','No Tuning');
    return;
end

tmtype = tdata{end}.tmtype;
if strcmp(tmtype,'rms')
    type = tmtype;
    labely = 'RMS (\muV)';
else
    freqrange = tdata{end}.freqrange;
    type = [num2str(freqrange(1)),'-',...
        num2str(freqrange(2)),'Hz_',tmtype];
    labely = 'Power (\muV^2)';
end

titlesize = 14;
textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fig_name = [DataSet.Mark.extype,'__',DataSet.Wave.wvevent,...
    '__( C-',ch,' )__',type,isp,isf];
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
cs='rgbkycm'; % color sequence

if ch_n==0 % Show All Channal
    for i=1:ch_max
        tdata{i} = tdata{i}/max(max(tdata{i})); % Normalize
        m_rms = mean(tdata{i});
        sd = std(tdata{i});
        se = sd/sqrt(DataSet.Mark.trial);
        spon = m_rms(1);
        
        m_rms = circshift(m_rms,[0 -1]);
        m_rms(end) = m_rms(1);
        se = circshift(se,[0 -1]);
        se(end) = se(1);
        
        if ispolar
            polar(0,1); % make all curves visible
            hold on;
            hTuning=polar(theta,m_rms,['-o',cs(i)]);
            set(hTuning,'LineWidth',1,'MarkerSize',1);
            hold on;
            polar(theta,spon*ones(1,length(theta)),['-',cs(i)]);
        else
            plot([0 360],[spon spon],['-',cs(i)]);
            hold on;
            hTuning=errorbar(nsti,m_rms,se,['-o',cs(i)]);
            set(hTuning,'LineWidth',1,'MarkerSize',1);
            hold on;
        end
    end
    
    if ispolar
        set(gca,'XTick',nsti(1:2:end));
    else
        set(gca,'Box','off','XTick',[],'XLim',[-10 370]);
        newaxis = axes('YAxisLocation','right','Color','none');
        for i=1:ch_max
            Is = ITC(tdata{i});                       % Information of nStimuli
            Is = Is/max(Is);                          % Normalize
            Ispon = Is(1);                            % Information of Background
            
            Is = circshift(Is,[0 -1]);
            Is(end) = Is(1);
            
            
            line('XData',[0 360],'YData',[Ispon Ispon],'Color',cs(i),'LineStyle',':');
            hITuning=line('XData',nsti,'YData',Is,'Color',cs(i),'LineStyle',':','Marker','o');
            set(hITuning,'LineWidth',1,'MarkerSize',1);
        end
        set(gca,'XTick',nsti(1:2:end),'XLim',[-10 370]);
    end
    
else % Show single channal
    
    mp = mean(tdata{ch_n});
    se = ste(tdata{ch_n});
    
    switch DataSet.Mark.extype
        case {'mdBar','mdGrating'}
            spon = mp(1);
            mp = circshift(mp,[0 -1]);
            mp(end) = mp(1);
            se = circshift(se,[0 -1]);
            se(end) = se(1);
            
            sti=DataSet.Mark.condtable{1};
            sti = circshift(sti,[0 -1]);
            theta = sti*(pi/180);
        case 'RF_Size'
            spon = mp(1);
            
            theta = (0:DataSet.Mark.stimuli-1)*(2*pi/DataSet.Mark.stimuli);
            sti = DataSet.Mark.condtable{1};
            if isfit
                [curvefit,goodness,fitinfo] = SizeTuningFit(sti,mp,'dog');
            end
        otherwise
            spon = 0;
            nsti = length(mp);
            sti=(0:nsti-1);
            theta = sti*(2*pi/nsti);
    end
    
    if ispolar
        hTuning=polar(theta,m,'-ok');
        set(hTuning,'LineWidth',1.5,'MarkerSize',1.5,'MarkerEdgeColor','r','MarkerFaceColor','r');
        hold on;
        polar(theta,spon*ones(1,length(theta)),'-b');
        set(gca,'XTick',sti(1:2:end));
    else
        plot([min(sti) max(sti)],[spon spon],':k','LineWidth',errorbarwidth);
        hold on;
        hTP=errorbar(sti,mp,se,'ok');
        set(hTP,'LineWidth',errorbarwidth,'MarkerSize',7,'MarkerEdgeColor','k','MarkerFaceColor','k');
        hold on;
        if isfit
            csti = sti(1):(sti(2)-sti(1))/100:sti(end);
            cmp = curvefit(csti);
            dtest=[' Adj-R^2 = ',num2str(round(goodness.adjrsquare*1000)/1000)];
        else
            csti = sti;
            cmp = mp;
            dtest = '';
        end
        hTC = plot(csti,cmp,'-k');
        set(hTC,'LineWidth',linewidth);
        switch DataSet.Mark.extype
            case 'RF_Size'
                [si s_max s_min] = SI(cmp,csti);
                annotation(hWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
                    'String',{[' SI = ',num2str(round(si*100)/100)],...
                    [' S_m_a_x = ',num2str(round(s_max*10)/10),' \circ'],...
                    [' S_m_i_n = ',num2str(round(s_min*10)/10),' \circ'],dtest},...
                    'FitHeightToText','off','Position',[0.75 0.85 0.25 0.07])
                labelx = 'Stimulus Diameter (degrees)';
            otherwise
        end
        
    end
end

set(gca,'LineWidth',axiswidth,'FontSize',textsize,'Box','off','XTick',sti(1:2:end),'XLim',[min(sti)-max(sti)/40 max(sti)*(41/40)]);
xlabel(labelx,'FontSize',textsize);
ylabel(labely,'FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',titlesize);
