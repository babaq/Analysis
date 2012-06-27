function RawData_Draw(RawData,ch,sti,extent)
% RawData_Draw.m
% 2008-10-08 by Zhang Li
% Draw Raw Data

%% Draw Raw Data
wph = 0.05; % Wave plot height
sph = 0.03; % Spike plot height
sh = 0.03; % Spike height
subp_n = 0;
datatype = 0;
if isfield(RawData,'Snip')
    subp_n = subp_n + RawData.Mark.trial;
    datatype = datatype+1;
    color_table='rgbkycm';
    event = RawData.Snip.spevent;
end
if isfield(RawData,'Wave')
    subp_n = subp_n + RawData.Mark.trial;
    datatype = datatype+2;
    event = RawData.Wave.wvevent;
end

if subp_n~=RawData.Mark.trial % Snip and Wave
    
    selection = questdlg('Which Part of DataSet To Show ?',...
        'Which Part ...',...
        'Snip','Wave','Both','Both');
    if strcmp(selection,'Snip')
        subp_n = RawData.Mark.trial;
        datatype = 1;
        event = RawData.Snip.spevent;
    elseif strcmp(selection,'Wave')
        subp_n = RawData.Mark.trial;
        datatype = 2;
    else
        event = [RawData.Wave.wvevent,RawData.Snip.spevent];
    end
end

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
DWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','D_Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@DWin_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if (isp || isph) % power or phase
    if datatype>1
        if isp % Power

            selection = questdlg('Which Power Spectral Density Method To Use ?',...
                'PSD',...
                'Multitaper','Modified Covariance','Multitaper');

            if strcmp(selection,'Multitaper')
                hs = spectrum.mtm(2,'adapt');
            else
                hs = spectrum.mcov(35);
            end


            prompt = {['Which Trial { 0_Average - ',num2str(RawData.Mark.trial),' } :'],'Stop Frequency :'};
            dlg_title = 'Trial';
            num_lines = 1;
            def = {'0','200'};
            input = inputdlg(prompt,dlg_title,num_lines,def);
            trial = input{1};
            s_freq = str2double(input{2});
            trial_n = str2double(trial);

            % first trial
            power1 =psd(hs,squeeze(rawdata.Wave.waveform(ch_n,1,sti_n,:)),...
                'Fs',RawData.Wave.samplefreq,'NFFT',floor(RawData.Wave.samplefreq));
            X1 = power1.frequencies(power1.frequencies<=s_freq);
            Y1 = power1.data(power1.frequencies<=s_freq);

            power = zeros(RawData.Mark.trial,length(X1));
            power(1,:) = Y1;

            % the other trial
            for i=2:RawData.Mark.trial
                temp = psd(hs,squeeze(rawdata.Wave.waveform(ch_n,i,sti_n,:)),...
                    'Fs',RawData.Wave.samplefreq,'NFFT',floor(RawData.Wave.samplefreq));
                y = temp.data(temp.frequencies<=s_freq);
                power(i,:) = y;
            end


            if trial_n==0 % Power Average
                Y = mean(power);
                Y_sd = std(power);

                errorbar(X1,Y,Y_sd,'.b');
                hold on;
                plot(X1,Y,'r','LineWidth',1);

                name = [name,'__T-Average'];
                set(gca,'XLim',[0 s_freq],'YLim',[0 1.2*max(Y)+0.01]);
            else
                plot(X1,power(trial_n,:),'r','LineWidth',1);
                name = [name,'__T-',trial];
            end
            output{2} = name;
            set(DWin,'UserData',output);
            title(name,'Interpreter','none','FontWeight','bold','FontSize',10);
            ylabel('Power/Frequency [dB/Hz]');
            xlabel('Frequency [Hz]');
        end
        
        if isph % Phase
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
        end

    else
        errordlg('No WaveData for Power or Phase !','No Wave !');
    end

else
    
    if subp_n==RawData.Mark.trial % Snip or Wave
        for i=1:17%RawData.Mark.trial
            subplot(17,1,i);
            stilast = rawdata.Mark.markoff(i,sti_n) - rawdata.Mark.markon(i,sti_n);
            if datatype==1 % Snip
                plot([extent_n extent_n],[0 1],':m','LineWidth',1);
                hold on;
                plot([extent_n extent_n]+stilast*1000,[0 1],':m','LineWidth',1);
                hold on;
                for j=1:rawdata.Snip.sortnumber(ch_n)  % each snip unit
                    X = squeeze(rawdata.Snip.snip(ch_n,j,i,sti_n,:));
                    X = X(X~=0);
                    X = (X-rawdata.Mark.markon(i,sti_n))*1000+extent_n;

                    Y = ones(length(X),1);
                    stem(X,Y,['.',color_table(j)],'LineWidth',1,'MarkerSize',1,...
                        'MarkerEdgeColor',color_table(j),'MarkerFaceColor',color_table(j));
                    hold on;
                end
                ylabel(['Trial',int2str(i)]);
                xlabel('Time [ms]');
                
                            set(gca,'TickDir','out','YLim',[0 1],'XTick',0:250:(stilast*1000+2*extent_n),...
                                'XLim',[0 (stilast*1000+2*extent_n)],'Position',[0.04,0.905-(i-1)*sph,0.92,sh]);
                            
%                 set(gca,'TickDir','out','YLim',[0 1],'XTick',0:250:(stilast*1000+2*extent_n),...
%                     'XLim',[0 (stilast*1000+2*extent_n)]);
                axis off;
            else % Wave
                Y = squeeze(rawdata.Wave.waveform(ch_n,i,sti_n,:));
                datalength = floor((stilast+2*extent_n/1000)*rawdata.Wave.samplefreq);

                plot([extent_n extent_n],[-200 200],':m','LineWidth',1);
                hold on;
                plot([extent_n extent_n]+stilast*1000,[-200 200],':m','LineWidth',1);
                hold on;

                Y = Y(1:datalength);
                X = (0:(datalength-1)) * (1/rawdata.Wave.samplefreq)*1000; % convert to ms
                plot(X,Y,'b');

                ylabel('uV');
                xlabel('Time [ms]');
                
                            set(gca,'XTick',0:250:max(X),'XLim',[0 max(X)],'YLim',[-170 170],...
                                'Position',[0.04,0.905-(i-1)*wph,0.92,wph]);
                            
                %set(gca,'XTick',0:250:max(X),'XLim',[0 max(X)],'YLim',[-180 180]);
                axis off;
            end

            if i==1 % title
                title(name,'Interpreter','none','FontWeight','bold','FontSize',10);
            end
        end
    else % Snip and Wave
        for i=1:20%RawData.Mark.trial
            stilast = rawdata.Mark.markoff(i,sti_n) - rawdata.Mark.markon(i,sti_n);
            subplot(20,1,2*i-1); % Wave
            Y = squeeze(rawdata.Wave.waveform(ch_n,i,sti_n,:));
            datalength = floor((stilast+2*extent_n/1000)*rawdata.Wave.samplefreq);

            plot([extent_n extent_n],[-200 200],':m','LineWidth',1);
            hold on;
            plot([extent_n extent_n]+stilast*1000,[-200 200],':m','LineWidth',1);
            hold on;

            Y = Y(1:datalength);
            X = (0:(datalength-1)) * (1/rawdata.Wave.samplefreq)*1000; % convert to ms
            plot(X,Y,'b');

            ylabel('uV');
            xlabel('Time [ms]');
            
                    set(gca,'XTick',0:250:max(X),'XLim',[0 max(X)],'YLim',[-200 200],...
                        'Position',[0.04,0.905-(i-1)*(wph+sph),0.92,wph]);
                    
            %set(gca,'XTick',0:250:max(X),'XLim',[0 max(X)],'YLim',[-200 200]);
            axis off;
            if i==1 % title
                title(name,'Interpreter','none','FontWeight','bold','FontSize',10);
            end


            subplot(20,1,2*i); % Snip
            plot([extent_n extent_n],[0 1],':m','LineWidth',1);
            hold on;
            plot([extent_n extent_n]+stilast*1000,[0 1],':m','LineWidth',1);
            hold on;
            for j=1:rawdata.Snip.sortnumber(ch_n)  % each snip unit
                X = squeeze(rawdata.Snip.snip(ch_n,j,i,sti_n,:));
                X = X(X~=0);
                X = (X-rawdata.Mark.markon(i,sti_n))*1000+extent_n;

                Y = ones(length(X),1);
                stem(X,Y,['.',color_table(j)],'LineWidth',1,'MarkerSize',1,...
                    'MarkerEdgeColor',color_table(j),'MarkerFaceColor',color_table(j));
                hold on;
            end
            ylabel(['Trial',int2str(i)]);
            xlabel('Time [ms]');
            
                    set(gca,'TickDir','out','YLim',[0 1],'XTick',0:250:(stilast*1000+2*extent_n),...
                        'XLim',[0 (stilast*1000+2*extent_n)],'Position',[0.04,0.905-sph-(i-1)*(sph+wph),0.92,sh]);
                    
%             set(gca,'TickDir','out','YLim',[0 1],'XTick',0:250:(stilast*1000+2*extent_n),...
%                 'XLim',[0 (stilast*1000+2*extent_n)]);
            axis off;
        end
    end
end



%% Save Figure
function DWin_CloseRequestFcn(hObject, eventdata, handles)

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



