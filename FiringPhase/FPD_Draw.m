function FPD_Draw(fpddata,FPData,delay,bin,ch,sort,sti)
% FPD_Draw.m
% 2008-10-17 by Zhang Li
% Draw Firing Phase Distribution


bin_n = str2double(bin);
ch_n = str2double(ch);
if strcmpi(sti,'ALL')
    sti_n = 0;
else
    sti_n = str2double(sti);
end
fig_name = [FPData.Mark.extype,'__',FPData.Snip.spevent,...
    '__( C-',ch,'_U-',sort,' )__S-',sti,'__',delay,'delay__',bin,'degbin_FPD'];
scnsize = get(0,'ScreenSize');
output{1} = FPData.OutputDir;
output{2} = fig_name;
output{3} = FPData.Dinf.tank;
output{4} = FPData.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','P_Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@PWin_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(sort,'NO SORT !')
    errordlg('NO SORT DATA TO SHOW !','Data Error ');
    return;
end
if strcmp(sort,'MUA') % MUA
    fpd = squeeze(fpddata(ch_n,end,:));
else
    if strcmp(sort,'SU')
        sort_n = 1;
    else
        sort_n = str2double(sort(end));
    end
    fpd = squeeze(fpddata(ch_n,sort_n,:));
end

c=4;
if sti_n==0 % All Stimuli
    if mod(FPData.Mark.stimuli,c)==0
        row = FPData.Mark.stimuli/c;
    else
        row = floor(FPData.Mark.stimuli/c)+1;
    end
    
    for s=1:FPData.Mark.stimuli
        subplot(row,c,s);
        
        Y = fpd{s}{1};
        X = (0:length(Y)-1) * (bin_n * pi/180);
        P = fpd{s}{3};
        
        fit = FourierFit(X,Y);
        Y_fit = fit(X);
        pPhase = X(Y_fit == max(Y_fit))/pi;
        lStrength = max(Y_fit) - min(Y_fit);
        
        plot(X,Y);
        hold on;
        plot(fit,'fit',0.95);
        legend off;
        
        
        %set(gca,'XTick',0:pi/2:2*pi,'XLim',[0 2*pi],'YLim',[0 0.01],'XTickLabel',{'0';'pi/2';'pi';'3pi/2';'2pi'});
        set(gca,'XTick',0:pi/2:2*pi,'XLim',[0 2*pi],'YLim',[0 0.02],'XTickLabel',{'0';'pi/2';'pi';'3pi/2';'2pi'},...
            'Position',[0.04+0.24*mod(s-1,c) 0.88-0.136*floor((s-1)/c) 0.2 0.136]);
        %title(int2str(s),'Interpreter','none','FontWeight','bold','FontSize',10);
        ylabel('Probability');
        xlabel('Phase [rad]');
        
        annotation(PWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',7,...
            'String',{[' P_r = ',num2str(P)],[' P_p = ',num2str(pPhase),' \pi'],[' LS = ',num2str(lStrength)]},...
            'FitHeightToText','off','Position',[0.18+0.24*mod(s-1,c) 0.92-0.135*floor((s-1)/c) 0.20 0.05]);
        
        axis off;
    end
else % Single Stimuli
    Y = fpd{sti_n}{1};
    X = (0:length(Y)-1) * (bin_n * pi/180);
    P = fpd{sti_n}{3};
    
    fit = FourierFit(X,Y);
    Y_fit = fit(X);
    pPhase = X(Y_fit == max(Y_fit))/pi;
    lStrength = max(Y_fit) - min(Y_fit);
    
    plot(X,Y);
    hold on;
    plot(fit,'fit',0.95);
    legend off;
    
    %             set(gca,'XTick',0:pi/2:2*pi,'XLim',[0 2*pi],'YLim',[0 1.2*max(Y)+0.001],...
    %                 'XTickLabel',{'0';'pi/2';'pi';'3pi/2';'2pi'});
    set(gca,'XTick',0:pi/2:2*pi,'XLim',[0 2*pi],'YLim',[0 1.2*max(Y)+0.001],'Position',[0.04,0.06,0.92,0.89],...
        'XTickLabel',{'0';'pi/2';'pi';'3pi/2';'2pi'});
    title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);
    ylabel('Probability');
    xlabel('Phase [rad]');
    
    annotation(PWin,'textbox','LineStyle','none','Interpreter','tex',...
        'String',{[' Rayleigh P = ',num2str(P)],[' PreferPhase = ',num2str(pPhase),' \pi'],[' LockStrength = ',num2str(lStrength)]},...
        'FitHeightToText','off','Position',[0.1 0.85 0.25 0.07]);
end



function PWin_CloseRequestFcn(hObject, eventdata, handles)

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

