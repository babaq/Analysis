function Apower(psd,DataSet,ch_n,trial_n,sti_n,stop_freq)
% Apower.m
% 2008-10-15 by Zhang Li
% Draw Averaged Wave Power Spectrum Density


if nargin<2
    disp('No Valid Arguments !');
    warndlg('No Valid Arguments !','Warnning');
    return;
elseif nargin>2
    ch = num2str(ch_n);
    trial = num2str(trial_n);
    sti = num2str(sti_n);
else
    prompt = {['Which Channal { 1 - ',num2str(DataSet.Wave.chn),' } :'],['Which Trial { 0_Average - ',num2str(DataSet.Mark.trial),' } :'],...
              ['Which Stimulus { 0_ALL - ',num2str(DataSet.Mark.stimuli),' } :'],'Stop Frequency :'};
    dlg_title = 'Draw';
    num_lines = 1;
    def = {'1','0','0','200'};
    input = inputdlg(prompt,dlg_title,num_lines,def);
    ch = input{1};
    trial = input{2};
    sti = input{3};
    stop_freq = str2double(input{4});
    ch_n = str2double(ch);
    trial_n = str2double(trial);
    sti_n = str2double(sti);
end
if DataSet.Mark.stimuli==1
    sti = '1';
    sti_n = 1;
end


X = psd{ch_n,1,1}.frequencies(psd{ch_n,1,1}.frequencies<=stop_freq);
power = zeros(DataSet.Mark.trial,DataSet.Mark.stimuli,length(X));
for s = 1:DataSet.Mark.stimuli
    for t=1:DataSet.Mark.trial
        power(t,s,:) = psd{ch_n,t,s}.data(psd{ch_n,t,s}.frequencies<=stop_freq);
    end
end

fig_name = [DataSet.Mark.extype,' __ ',DataSet.Wave.wvevent,...
    ' __( C-',ch,'_S-',sti,' )__T-',trial,'__PSD'];
scnsize = get(0,'ScreenSize');
output{1} = DataSet.OutputDir;
output{2} = fig_name;
output{3} = DataSet.Dinf.tank;
output{4} = DataSet.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','P_Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@PWin_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y = squeeze(mean(power));
Y_sd = squeeze(std(power,0));
Y_se = Y_sd/sqrt(DataSet.Mark.trial);
MAXP = max(max(Y))+mean(mean(Y_se));
        
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
            y = squeeze(power(trial_n,j,:));
            plot(X,y,'r','LineWidth',1);
        end
        
        set(gca,'XLim',[0 stop_freq],'YLim',[0 MAXP+0.01]);
        title(int2str(j),'Interpreter','none','FontWeight','bold','FontSize',10);
        ylabel('Power/Frequency [dB/Hz]');
        xlabel('Frequency [Hz]');

        axis off;
    end
else % Single Stimuli
    if trial_n==0
        y = Y(sti_n,:);
        y_se = Y_se(sti_n,:);

        errorbar(X,y,y_se,'.b');
        hold on;
        plot(X,y,'r','LineWidth',1);
    else
        y = squeeze(power(trial_n,sti_n,:));
        plot(X,y,'r','LineWidth',1);
    end
    
    set(gca,'box','off','XLim',[0 stop_freq],'YLim',[0 1.2*max(y)+0.01]);
    title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);
    ylabel('Power/Frequency [dB/Hz]');
    xlabel('Frequency [Hz]');
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

