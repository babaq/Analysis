function FPHTC_Draw(tdata,TCData,ch,sort,delay,ispolar)
% FPTC_Draw.m
% 2009-01-11 by Zhang Li
% Draw FPHTC TuningCurve

%% Draw Tuning Curve
type = '_fp';

if ispolar
    isp = '_p';
else
    isp = '';
end

if strcmpi(ch,'ALL')
    ch_n = 0;
else
    ch_n = str2double(ch);
end
ch_max = TCData.Snip.chnumber;

fig_name = ['( ',TCData.Mark.stitypestring,' )__( ',TCData.Snip.spevent,...
        ' )__( C-',ch,' )__( U-',sort,' )__',delay,'ms',isp,type];
scnsize = get(0,'ScreenSize');
output{1} = TCData.OutputDir;
output{2} = fig_name;
output{3} = TCData.Dinf.tank;
output{4} = TCData.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','T_Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@TWin_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nsti=(0:360/(TCData.Mark.nstimuli-1):360);
theta = nsti*(2*pi/360);
cs='rgbkycm'; % color sequence

if ch_n==0 % Show All Channal
    for i=1:ch_max
        fpm = tdata{i,end};
        
        mfpm = cmean(fpm);
        sdfp = cstd(fpm);
        mfpm = pha2con(mfpm); 
        spon = mfpm(1);
            
        mfpm = circshift(mfpm,[0 -1]);
        mfpm(end) = mfpm(1);
        sdfp = circshift(sdfp,[0 -1]);
        sdfp(end) = sdfp(1);
        
        if ispolar
            polar(0,2*pi); % make all curves visible
            hold on;
            hTuning=polar(theta,mfpm,['-o',cs(i)]);
            set(hTuning,'LineWidth',1,'MarkerSize',1);
            hold on;
            polar(theta,spon*ones(1,length(theta)),['-',cs(i)]);
        else
            plot([0 360],[spon spon],['-',cs(i)]);
            hold on;
            hTuning=errorbar(nsti,mfpm,sdfp,['-o',cs(i)]);
            set(hTuning,'LineWidth',1,'MarkerSize',1);
            hold on;
        end
    end
    
    if ispolar
        set(gca,'XTick',nsti(1:2:end));
    else
        set(gca,'Box','off','XTick',[],'XLim',[-10 370],'YLim',[-pi/2 2*pi+(pi/2)],...
            'YTick',(-pi/2:pi/2:2*pi+(pi/2)),'YTickLabel',{'3pi/2';'0';'pi/2';'pi';'3pi/2';'2pi';'pi/2'});
        ylabel('Firing Phase [Rad]');
        
        newaxis = axes('YAxisLocation','right','Color','none');
        for i=1:ch_max
            fpm = tdata{i,end};

            Is = ITC(fpm);                             % Information of nStimuli
            Is = Is/max(Is);                           % Normalize
            Ispon = Is(1);                             % Information of Background
            
            Is = circshift(Is,[0 -1]);
            Is(end) = Is(1);
            

            line('XData',[0 360],'YData',[Ispon Ispon],'Color',cs(i),'LineStyle',':');
            hITuning=line('XData',nsti,'YData',Is,'Color',cs(i),'LineStyle',':','Marker','o');
            set(hITuning,'LineWidth',1,'MarkerSize',1);
        end
        set(gca,'XTick',nsti(1:2:end),'XLim',[-10 370]);
    end
    
else % Show single channal
    
    if strcmpi(sort,'NO SORT !')
        errordlg('NO SORT DATA TO SHOW !','Data Error ');
    elseif strcmpi(sort,'MUA') % MUA
        fpm = tdata{ch_n,end};
    else % SUA
        if strcmpi(sort,'SU')
            sort_n = 1;
        else
            sort_n = str2double(sort(end));
        end
        fpm = tdata{ch_n,sort_n};
    end
    
    mfpm = cmean(fpm);
    sdfp = cstd(fpm);
    mfpm = pha2con(mfpm);
    spon = mfpm(1);
    
    Is = ITC(fpm);                        % Information of nStimuli
    AIs = mean(Is);                       % Average Information of nStimuli
    Hs = entropy(TCData.Mark.sequence);
    Ispon = Is(1);                        % Information of Background
        
    
    mfpm = circshift(mfpm,[0 -1]);
    mfpm(end) = mfpm(1);
    sdfp = circshift(sdfp,[0 -1]);
    sdfp(end) = sdfp(1);
    Is = circshift(Is,[0 -1]);
    Is(end) = Is(1);
    
    if ispolar
        polar(0,2*pi); % make all curves visible
        hold on;
        hTuning=polar(theta,mfpm,'-ok');
        set(hTuning,'LineWidth',1.5,'MarkerSize',1.5,'MarkerEdgeColor','r','MarkerFaceColor','r');
        hold on;
        polar(theta,spon*ones(1,length(theta)),'-b');
        set(gca,'XTick',nsti(1:2:end));
    else
        plot([0 360],[spon spon],'-k');
        hold on;
        hTuning=errorbar(nsti,mfpm,sdfp,'-ok');
        set(hTuning,'LineWidth',1.5,'MarkerSize',1.5,'MarkerEdgeColor','r','MarkerFaceColor','r');
        
        set(gca,'Box','off','XTick',[],'XLim',[-10 370],'YLim',[-pi/2 2*pi+(pi/2)],...
            'YTick',(-pi/2:pi/2:2*pi+(pi/2)),'YTickLabel',{'3pi/2';'0';'pi/2';'pi';'3pi/2';'2pi';'pi/2'});
        ylabel('Firing Phase [Rad]');
        
        newaxis = axes('YAxisLocation','right','Color','none');

        line('XData',[0 360],'YData',[Ispon Ispon],'Color','b','LineStyle','-');  
        hITuning=line('XData',nsti,'YData',Is,'Color','b','LineStyle','-','Marker','o');
        set(hITuning,'LineWidth',1.5,'MarkerSize',1.5,'MarkerEdgeColor','g','MarkerFaceColor','g');
        ylabel('Information(bit)');
        %set(gca,'XTick',nsti(1:2:end),'XLim',[-10 370],'YLim',[0 Hs]);
        set(gca,'XTick',nsti(1:2:end),'XLim',[-10 370]);
        
        annotation(TWin,'textbox','LineStyle','none','Interpreter','tex',...
                'String',{[' H(S) = ',num2str(Hs),' bit'],[' I(R,S) = ',num2str(AIs),' bit']},...
                'FitHeightToText','off','Position',[0.15 0.85 0.25 0.07]);
    end
    
end

xlabel('Direction [Deg]');
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);


 
%% Save Figure
function TWin_CloseRequestFcn(hObject, eventdata, handles)

selection = questdlg('Do you want to save this figure ?',...
                     'Close This Figure ...',...
                     'Yes','No','No');
if strcmp(selection,'Yes')
    output = get(hObject,'UserData');
    outputdir = output{1};
    figname = output{2};
    tank = output{3};
    block = output{4};
    
    cd(outputdir);
    if (exist(tank,'dir'))
        cd(tank);
    else
        mkdir(tank);
        cd(tank);
    end
    if (exist(block,'dir'))
        cd(block);
    else
        mkdir(block);
        cd(block);
    end
    saveas(hObject,figname,'fig');
    saveas(hObject,figname,'png');
    
    cd(outputdir);
end

delete(hObject);


