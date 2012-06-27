function psthdata = CalcPSTH(DataSet)
% CalcPSTH.m
% 2008-10-11 by Zhang Li
% Calculate Peri-Stimulus Time Histogram

% Show Result
contents = get(handles.ch_n,'String');
ch_n = get(handles.ch_n,'Value');
ch = contents{ch_n};

contents = get(handles.sort_n,'String');
sort = contents{get(handles.sort_n,'Value')};
if strcmp(sort,'SU')
    sort_n = 1;
else
    sort_n = str2double(sort(end));
end

contents = get(handles.bin_n,'String');
bin = contents{get(handles.bin_n,'Value')};
bin_n = str2double(bin);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isstruct(psthdata) % Calculate New PSTH
    stilast_m = min(min(PSTHData.Mark.markoff - PSTHData.Mark.markon));
    
    if isfield(PSTHData,'Snip')
        psthdata.Snip = cell(1,PSTHData.Mark.nstimuli);
        sl = floor(stilast_m*1000/bin_n);
        
        
        for s=1:PSTHData.Mark.nstimuli
            
            psthdata.Snip{1,s} = zeros(PSTHData.Mark.trial,sl);
            
            for i=1:PSTHData.Mark.trial
                if strcmp(sort,'MUA')
                    data=0;
                    for j=1:PSTHData.Snip.sortnumber(ch_n)
                        data = cat(1,data,squeeze(PSTHData.Snip.snip(ch_n,j,i,s,:)));
                    end
                    sp=data(data~=0);
                else
                    data = squeeze(PSTHData.Snip.snip(ch_n,sort_n,i,s,:));
                    sp=data(data~=0);
                end

                stilast = PSTHData.Mark.markoff(i,s)-PSTHData.Mark.markon(i,s);
                binwidth = stilast/sl;

                bin = (PSTHData.Mark.markon(i,s):binwidth:PSTHData.Mark.markoff(i,s));
                n=histc(sp,bin);

                if isempty(n)
                    n=zeros(1,sl);
                else
                    n=n(1:sl);
                    if ( size(n,1) > size(n,2) )
                        n=n';
                    end
                end
                    
                psthdata.Snip{1,s}(i,:) = n;
            end
        end
    end
    
    
    if isfield(PSTHData,'Wave')
        wl = floor(stilast_m*PSTHData.Wave.samplefreq);
        psthdata.Wave = cell(1,PSTHData.Mark.nstimuli);
        
        for s=1:PSTHData.Mark.nstimuli
            
            psthdata.Wave{1,s} = zeros(PSTHData.Mark.trial,wl);
            
            for i=1:PSTHData.Mark.trial 
                psthdata.Wave{1,s}(i,:) = squeeze( PSTHData.Wave.waveform(ch_n,i,s,1:wl) )';
            end
        end  
    end
           
    
          
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

contents = get(handles.sti_n,'String');
sti_n=get(handles.sti_n,'Value');
sti = contents{sti_n};
sti_max = size(contents)-1;
sti_max = sti_max(1);
sti_n=sti_n-1;


if isfield(PSTHData,'Snip')
    event = PSTHData.Snip.spevent;
else
    event = PSTHData.Wave.wvevent;
end

isp=get(handles.power,'Value');
isph=get(handles.phase,'Value');
if isp
    p='__Power';
elseif isph
    p='__Phase';
else
    p='';
end

name = [get(handles.stiname,'String'),'__',event,...
        '__( C-',ch,'_U-',sort,' )__S-',sti,'__',delay,'ms__',num2str(bin_n),'ms',p];

scnsize = get(0,'ScreenSize');
output{1} = PSTHData.OutputDir;
output{2} = name;
output{3} = PSTHData.Dinf.tank;
output{4} = PSTHData.Dinf.block;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Show Data %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','P_Win', ...
    'Name',name,...
    'CloseRequestFcn',@PWin_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if PSTHData.Mark.nstimuli==1  % rMode
    sti_n = 1;
end


if isfield(PSTHData,'Snip') % Snip

    if sti_n==0 % All Stimuli
        if mod(sti_max,4)==0
            row = sti_max/4;
        else
            row = floor(sti_max/4)+1;
        end

        for j=1:sti_max
            subplot(row,4,j);

            Y = mean(psthdata.Snip{1,j});
            Y_se = std(psthdata.Snip{1,j})/sqrt(PSTHData.Mark.trial);
            X = (1:length(Y)) * bin_n;
            
%             errorbar(X,Y,Y_se,'.g');
%             hold on;
            bar(X,Y,1);

            set(gca,'XTick',0:250:max(X),'XLim',[0 max(X)],'YLim',[0 1]);
   
            title(int2str(j),'Interpreter','none','FontWeight','bold','FontSize',10);
            ylabel('Spikes');
            xlabel('Time [ms]');

            axis off;

        end

    else % Single Stimuli

        Y = mean(psthdata.Snip{1,sti_n});
        Y_se = std(psthdata.Snip{1,sti_n})/sqrt(PSTHData.Mark.trial);
        X = (1:length(Y)) * bin_n;
        
        errorbar(X,Y,Y_se,'.g');
        hold on;
        bar(X,Y,1);

        %set(gca,'XTick',0:250:max(X),'XLim',[0 max(X)],'YLim',[0 1.2*max(Y)+0.01]);
        
        set(gca,'XTick',0:250:max(X),'XLim',[0 max(X)],'YLim',[0 1.2*max(Y)+0.01],'Position',[0.04,0.06,0.92,0.89]);
        
        title(name,'Interpreter','none','FontWeight','bold','FontSize',10);
        ylabel('Spikes');
        xlabel('Time [ms]');

    end

else % Wave
    
    if sti_n==0 % All Stimuli
        if mod(sti_max,4)==0
            row = sti_max/4;
        else
            row = floor(sti_max/4)+1;
        end

        if isp % power

            selection = questdlg('Which Power Spectral Density Method To Use ?',...
                'PSD',...
                'Multitaper','Modified Covariance','Multitaper');

            if strcmp(selection,'Multitaper')
                hs = spectrum.mtm(2,'adapt');
            else
                hs = spectrum.mcov(35);
            end


            prompt = {'Stop Frequency :'};
            dlg_title = 'Stop Freq';
            num_lines = 1;
            def = {'200'};
            input = inputdlg(prompt,dlg_title,num_lines,def);
            s_freq = str2double(input{1});

            
            
            for j=1:sti_max
                subplot(row,4,j);

                power1 =psd(hs,mean(psthdata.Wave{1,j}),...
                    'Fs',PSTHData.Wave.samplefreq,'NFFT',floor(PSTHData.Wave.samplefreq));
                X1 = power1.frequencies(power1.frequencies<=s_freq);
                Y1 = power1.data(power1.frequencies<=s_freq);

                plot(X1,Y1,'r','LineWidth',1);

                set(gca,'YLim',[0 500]);
                title(int2str(j),'Interpreter','none','FontWeight','bold','FontSize',10);
                ylabel('Power/Frequency [dB/Hz]');
                xlabel('Frequency [Hz]');

                axis off;
            end
            
        elseif isph % phase
            
            for j=1:sti_max
                subplot(row,4,j);
                
                Y = angle(hilbert(mean(psthdata.Wave{1,j})));
                Y = pha2con(Y);
                X = (0:(length(Y)-1)) * (1/PSTHData.Wave.samplefreq)*1000;

                plot(X,Y,'r','LineWidth',2);
                set(gca,'XLim',[0 max(X)],'YLim',[-pi/2 2*pi+(pi/2)]);

                title(int2str(j),'Interpreter','none','FontWeight','bold','FontSize',10);
                ylabel('Phase [Rad]');
                xlabel('Time [ms]');

                axis off;
            end
            
        else % wave PSTH
            
            for j=1:sti_max
                subplot(row,4,j);

                Y = mean(psthdata.Wave{1,j});
                Y_se = std(psthdata.Wave{1,j});
                %Y_se = std(psthdata.Wave{1,j})/sqrt(PSTHData.Mark.trial);
                X = (0:(length(Y)-1)) * (1/PSTHData.Wave.samplefreq)*1000; % convert to ms

                errorbar(X,Y,Y_se,'.g');
                hold on;
                plot(X,Y,'b','LineWidth',2);

                set(gca,'XTick',0:250:max(X),'XLim',[0 max(X)],'YLim',[-120 120]);
                title(int2str(j),'Interpreter','none','FontWeight','bold','FontSize',10);
                ylabel('uV');
                xlabel('Time [ms]');


                axis off;
            end

        end

    else % Single Stimuli
        if isp % Power

            selection = questdlg('Which Power Spectral Density Method To Use ?',...
                'PSD',...
                'Multitaper','Modified Covariance','Multitaper');

            if strcmp(selection,'Multitaper')
                hs = spectrum.mtm(2,'adapt');
            else
                hs = spectrum.mcov(35);
            end



            prompt = {'Stop Frequency :'};
            dlg_title = 'Stop Freq';
            num_lines = 1;
            def = {'200'};
            input = inputdlg(prompt,dlg_title,num_lines,def);
            s_freq = str2double(input{1});


            power1 =psd(hs,mean(psthdata.Wave{1,sti_n}),...
                'Fs',PSTHData.Wave.samplefreq,'NFFT',floor(PSTHData.Wave.samplefreq));
            X1 = power1.frequencies(power1.frequencies<=s_freq);
            Y1 = power1.data(power1.frequencies<=s_freq);

            plot(X1,Y1,'r','LineWidth',1);

            title(name,'Interpreter','none','FontWeight','bold','FontSize',10);
            ylabel('Power/Frequency [dB/Hz]');
            xlabel('Frequency [Hz]');
            
        elseif isph % Phase
            Y = angle(hilbert(mean(psthdata.Wave{1,sti_n})));
            Y = pha2con(Y);
            X = (0:(length(Y)-1)) * (1/PSTHData.Wave.samplefreq)*1000;

            plot(X,Y,'r','LineWidth',2);
            set(gca,'XTick',0:250:max(X),'XLim',[0 max(X)],'YLim',[-pi/2 2*pi+(pi/2)],'YTick',(-pi/2:pi/2:2*pi+(pi/2)),...
                'YTickLabel',{'3pi/2';'0';'pi/2';'pi';'3pi/2';'2pi';'pi/2'},'Position',[0.04,0.06,0.92,0.89]);
            
            title(name,'Interpreter','none','FontWeight','bold','FontSize',10);
            ylabel('Phase [Rad]');
            xlabel('Time [ms]');
        else
            Y = mean(psthdata.Wave{1,sti_n});
            Y_se = std(psthdata.Wave{1,sti_n});
            %Y_se = std(psthdata.Wave{1,sti_n})/sqrt(PSTHData.Mark.trial);
            X = (0:(length(Y)-1)) * (1/PSTHData.Wave.samplefreq)*1000; % convert to ms

            errorbar(X,Y,Y_se,'.g');
            hold on;
            plot(X,Y,'b','LineWidth',2);

            %set(gca,'XTick',0:250:max(X),'XLim',[0 max(X)],'YLim',[-(1.2*max(abs(Y))+0.01) 1.2*max(abs(Y))+0.01]);

            set(gca,'XTick',0:250:max(X),'XLim',[0 max(X)],'YLim',[-(1.2*max(abs(Y))+0.01) 1.2*max(abs(Y))+0.01],...
                'Position',[0.04,0.06,0.92,0.89]);

            title(name,'Interpreter','none','FontWeight','bold','FontSize',10);
            ylabel('uV');
            xlabel('Time [ms]');
        end

    end
end



end % end of function





