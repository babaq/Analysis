function Aphase_Draw(wp,DataSet,ch_n,sti_n,trial_n)
% Aphase_Draw.m
% 2008-10-13 by Zhang Li
% Draw Averaged Wavephase

%% Draw Averaged Wavephase
if nargin<2
    disp('No Valid Arguments !');
    warndlg('No Valid Arguments !','Warnning');
    return;
elseif nargin>2
    ch = num2str(ch_n);
    sti = num2str(sti_n);
    trial = num2str(trial_n);
else
    prompt = {['Which Channal { 1 - ',num2str(DataSet.Wave.chnumber),' } :'],['Which Stimulus { 0_ALL - ',num2str(DataSet.Mark.nstimuli),' } :'],...
              ['Which Trial { 0_Average - ',num2str(DataSet.Mark.trial),' } :']};
    dlg_title = 'Draw';
    num_lines = 1;
    def = {'1','0','0'};
    input = inputdlg(prompt,dlg_title,num_lines,def);
    ch = input{1};
    sti = input{2};
    trial = input{3};
    ch_n = str2double(ch);
    sti_n = str2double(sti);
    trial_n = str2double(trial);
end
if DataSet.Mark.nstimuli==1
    sti = '1';
    sti_n = 1;
end

fig_name = [DataSet.Mark.stitypestring,'__',DataSet.Wave.wvevent,...
        '__( C-',ch,' )__S-',sti,'__T-',trial,'__Phase'];
scnsize = get(0,'ScreenSize');
output{1} = DataSet.OutputDir;
output{2} = fig_name;
output{3} = DataSet.Dinf.tank;
output{4} = DataSet.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
WWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','W_Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@WWin_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if sti_n==0 % All Stimuli
    if mod(DataSet.Mark.nstimuli,4)==0
        row = DataSet.Mark.nstimuli/4;
    else
        row = floor(DataSet.Mark.nstimuli/4)+1;
    end
    
    for j=1:DataSet.Mark.nstimuli
        subplot(row,4,j);

        if trial_n==0
            Y = cmean(wp{ch_n,j});
            Y_se = cstd(wp{ch_n,j});
            %Y_se = cstd(wp{ch_n,j})/sqrt(DataSet.Mark.trial);
            Y = pha2con(Y);
            X = (0:(length(Y)-1)) * (1/DataSet.Wave.samplefreq)*1000; % convert to ms

            errorbar(X,Y,Y_se,'.b');
            hold on;
            plot(X,Y,'r','LineWidth',2);
        else
            Y = wp{ch_n,j}(trial_n,:);
            Y = pha2con(Y);
            X = (0:(length(Y)-1)) * (1/DataSet.Wave.samplefreq)*1000;
            
            plot(X,Y,'r','LineWidth',2);
        end
        
        set(gca,'XLim',[0 max(X)],'XTick',0:250:max(X),'YLim',[-pi/2 2*pi+(pi/2)]);
        title(int2str(j),'Interpreter','none','FontWeight','bold','FontSize',10);
        ylabel('Phase [Rad]');
        xlabel('Time [ms]');

        axis off;
    end
else % Single Stimuli
    if trial_n==0
        Y = cmean(wp{ch_n,sti_n});
        Y_se = cstd(wp{ch_n,sti_n});
        %Y_se = cstd(wp{ch_n,sti_n})/sqrt(DataSet.Mark.trial);
        Y = pha2con(Y);
        X = (0:(length(Y)-1)) * (1/DataSet.Wave.samplefreq)*1000; % convert to ms

        errorbar(X,Y,Y_se,'.b');
        hold on;
        plot(X,Y,'r','LineWidth',2);
    else
        Y = wp{ch_n,sti_n}(trial_n,:);
        Y = pha2con(Y);
        X = (0:(length(Y)-1)) * (1/DataSet.Wave.samplefreq)*1000;

        plot(X,Y,'r','LineWidth',2);
    end
    
    set(gca,'XTick',0:250:max(X),'XLim',[0 max(X)],'YLim',[-pi/2 2*pi+(pi/2)],'YTick',(-pi/2:pi/2:2*pi+(pi/2)),...
                'YTickLabel',{'3pi/2';'0';'pi/2';'pi';'3pi/2';'2pi';'pi/2'},'Position',[0.04,0.06,0.92,0.89]);
    title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);
    ylabel('Phase [Rad]');
    xlabel('Time [ms]');
end



%% Save Figure
function WWin_CloseRequestFcn(hObject, eventdata, handles)

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


