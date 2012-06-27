function Wave_Phase(RawData,ch,sti,extent)
% Wave_Phase.m
% 2008-10-12 by Zhang Li
% Draw Wave Phase

%% Draw Wave Phase
if isfield(RawData,'Wave')
    ch_n = str2double(ch);
    sti_n = str2double(sti);

    fig_name = ['( ',RawData.Mark.stitypestring,' )__( ',event,...
        ' )__( C-',ch,' )__( S-',sti,' )__',extent,'ms'];
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

    if isfield(rawdata.Wave,'wavephase')

        prompt = {['Which Trial { 0_Average - ',num2str(RawData.Mark.trial),' } :']};
        dlg_title = 'Trial';
        num_lines = 1;
        def = {'0'};
        input = inputdlg(prompt,dlg_title,num_lines,def);
        trial = input{1};
        trial_n = str2double(trial);


        if trial_n==0 % Phase Average

            phasedata = [];
            for i=1:RawData.Mark.trial
                phasedata = cat(1,phasedata,squeeze(rawdata.Wave.wavephase(ch_n,i,sti_n,:))');
            end
            Y = cmean(phasedata);
            Y_sd = cstd(phasedata);
            Y = pha2con(Y);
            X = (0:(length(Y)-1)) * (1/rawdata.Wave.samplefreq)*1000;

            errorbar(X,Y,Y_sd,'.b');
            hold on;
            plot(X,Y,'r','LineWidth',2);

            name = [name,'__T-Average'];
            set(gca,'XTick',0:250:max(X),'XLim',[0 max(X)],'YLim',[-pi/2 2*pi+(pi/2)],'YTick',(-pi/2:pi/2:2*pi+(pi/2)),...
                'YTickLabel',{'3pi/2';'0';'pi/2';'pi';'3pi/2';'2pi';'pi/2'},'Position',[0.04,0.06,0.92,0.89]);
        else
            Y = squeeze(rawdata.Wave.wavephase(ch_n,trial_n,sti_n,:))';
            X = (0:(length(Y)-1)) * (1/rawdata.Wave.samplefreq)*1000;

            plot(X,Y,'r','LineWidth',2);
            name = [name,'__T-',trial];
            set(gca,'XTick',0:250:max(X),'XLim',[0 max(X)],'YLim',[-pi/2 2*pi+(pi/2)],'YTick',(-pi/2:pi/2:2*pi+(pi/2)),...
                'YTickLabel',{'3pi/2';'0';'pi/2';'pi';'3pi/2';'2pi';'pi/2'},'Position',[0.04,0.06,0.92,0.89]);
        end
        output{2} = name;
        set(DWin,'UserData',output);
        title(name,'Interpreter','none','FontWeight','bold','FontSize',10);
        ylabel('Phase [Rad]');
        xlabel('Time [ms]');
    else
        errordlg('Filter Wave First !','No WavePhase !');
    end
else
    disp('No Valid Data !');
    errordlg('No WaveData for Phase !','No Wave !');
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



