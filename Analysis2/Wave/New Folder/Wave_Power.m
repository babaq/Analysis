function Wave_Power(P_Obj,DataSet)
% Wave_Power.m
% 2008-10-12 by Zhang Li
% Wave Power

%% Draw Wave Power
prompt = {['Which Channal { 1 - ',num2str(DataSet.Wave.chnumber),' } :'],['Which Stimulus { 0_ALL - ',num2str(DataSet.Mark.nstimuli),' } :'],...
          ['Which Trial { 0_Average - ',num2str(DataSet.Mark.trial),' } :'],'Stop Frequency :'};
dlg_title = 'Draw';
num_lines = 1;
def = {'1','0','0','250'};
input = inputdlg(prompt,dlg_title,num_lines,def);
ch = input{1};
sti = input{2};
trial = input{3};
stop_freq = str2double(input{4});
ch_n = str2double(ch);
sti_n = str2double(sti);
trial_n = str2double(trial);

X = P_Obj{ch_n,1}(1,1).frequencies(P_Obj{ch_n,1}(1,1).frequencies<=stop_freq);
power = zeros(RawData.Mark.nstimuli,length(X),RawData.Mark.trial);
for s = RawData.Mark.nstimuli
    for i=1:RawData.Mark.trial
        power(s,:,i) = P_Obj{ch_n,s}(i,1).data(P_Obj{ch_n,s}(i,1).frequencies<=stop_freq);
    end
end
    
    
fig_name = ['( ',DataSet.Mark.stitypestring,' )__( ',DataSet.Wave.wvevent,...
    ' )__( C-',ch,' )__( S-',sti,' )__T-',trial];
scnsize = get(0,'ScreenSize');
output{1} = RawData.OutputDir;
output{2} = fig_name;
output{3} = RawData.Dinf.tank;
output{4} = RawData.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','P_Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@PWin_CloseRequestFcn,...
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
            Y = mean(power,3);
            Y = Y(j,:);
            Y_sd = std(power,3);
            Y_sd = Y_sd(j,:);

            errorbar(X,Y,Y_sd,'.b');
            hold on;
            plot(X,Y,'r','LineWidth',1);
  
        else
            plot(X,power(j,:,trial_n),'r','LineWidth',1);
        end
        
        set(gca,'XLim',[0 stop_freq],'YLim',[0 1.2*max(Y)+0.01]);
        title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);
        ylabel('Power/Frequency [dB/Hz]');
        xlabel('Frequency [Hz]');

        axis off;
    end
else % Single Stimuli
    if trial_n==0
        Y = mean(power,3);
        Y = Y(sti_n,:);
        Y_sd = std(power,3);
        Y_sd = Y_sd(sti_n,:);

        errorbar(X,Y,Y_sd,'.b');
        hold on;
        plot(X,Y,'r','LineWidth',1);

    else
        plot(X,power(sti_n,:,trial_n),'r','LineWidth',1);
    end
end


%% Save Figure
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



