function FPH_Draw(fphdata,FPData,delay,bin,ch,sort,sti)
% FPH_Draw.m
% 2008-10-17 by Zhang Li
% Draw Firing Phase Histogram

%% Draw FPH
bin_n = str2double(bin);
ch_n = str2double(ch);
sort_max = FPData.Snip.sortnumber(ch_n);
if strcmpi(sti,'ALL')
    sti_n = 0;
else
    sti_n = str2double(sti);
end
fig_name = [FPData.Mark.stitypestring,'__',FPData.Snip.spevent,...
        '__( C-',ch,'_U-',sort,' )__S-',sti,'__',delay,'ms__',bin,'deg_FPH'];
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
    elseif strcmp(sort,'MUA') % MUA
        if sti_n==0 % All Stimuli
            if mod(FPData.Mark.nstimuli,4)==0
                row = FPData.Mark.nstimuli/4;
            else
                row = floor(FPData.Mark.nstimuli/4)+1;
            end

            for s=1:FPData.Mark.nstimuli
                subplot(row,4,s);

                fph=0;
                for i=1:sort_max
                    fph = fph+fphdata{ch_n,i,s};
                end
                Y = mean(fph);
                Y_se = std(fph)/sqrt(FPData.Mark.trial);
                X = (0:length(Y)-1) * (bin_n * pi/180);
                
%                 errorbar(X,Y,Y_se,'.g');
%                 hold on;
                bar(X,Y,1);

                set(gca,'XTick',0:pi/2:2*pi,'XLim',[0 2*pi],'YLim',[0 2],...
                    'XTickLabel',{'0';'pi/2';'pi';'3pi/2';'2pi'});
                title(int2str(s),'Interpreter','none','FontWeight','bold','FontSize',10);
                ylabel('Spikes');
                xlabel('Phase [rad]');

                axis off;
            end
        else % Single Stimuli
            fph=0;
            for i=1:sort_max
                fph = fph+fphdata{ch_n,i,sti_n};
            end
            Y = mean(fph);
            Y_se = std(fph)/sqrt(FPData.Mark.trial);
            X = (0:length(Y)-1) * (bin_n * pi/180);

            errorbar(X,Y,Y_se,'.g');
            hold on;
            bar(X,Y,1);

%             set(gca,'XTick',0:pi/2:2*pi,'XLim',[0 2*pi],'YLim',[0 1.2*max(Y)+0.001],...
%                 'XTickLabel',{'0';'pi/2';'pi';'3pi/2';'2pi'});
            set(gca,'XTick',0:pi/2:2*pi,'XLim',[0 2*pi],'YLim',[0 1.2*max(Y)+0.001],'Position',[0.04,0.06,0.92,0.89],...
                'XTickLabel',{'0';'pi/2';'pi';'3pi/2';'2pi'});
            title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);
            ylabel('Spikes');
            xlabel('Phase [rad]');
        end
    else % SUA
        if strcmp(sort,'SU')
            sort_n = 1;
        else
            sort_n = str2double(sort(end));
        end
        if sti_n==0 % All Stimuli
            if mod(FPData.Mark.nstimuli,4)==0
                row = FPData.Mark.nstimuli/4;
            else
                row = floor(FPData.Mark.nstimuli/4)+1;
            end

            for s=1:FPData.Mark.nstimuli
                subplot(row,4,s);

                Y = mean(fphdata{ch_n,sort_n,s});
                Y_se = std(fphdata{ch_n,sort_n,s})/sqrt(FPData.Mark.trial);
                X = (0:length(Y)-1) * (bin_n * pi/180);
                
%                 errorbar(X,Y,Y_se,'.g');
%                 hold on;
                bar(X,Y,1);

                set(gca,'XTick',0:pi/2:2*pi,'XLim',[0 2*pi],'YLim',[0 1],...
                    'XTickLabel',{'0';'pi/2';'pi';'3pi/2';'2pi'});
                title(int2str(s),'Interpreter','none','FontWeight','bold','FontSize',10);
                ylabel('Spikes');
                xlabel('Phase [rad]');

                axis off;
            end
        else % Single Stimuli
            Y = mean(fphdata{ch_n,sort_n,sti_n});
            Y_se = std(fphdata{ch_n,sort_n,sti_n})/sqrt(FPData.Mark.trial);
            X = (0:length(Y)-1) * (bin_n * pi/180);

            errorbar(X,Y,Y_se,'.g');
            hold on;
            bar(X,Y,1);

%             set(gca,'XTick',0:pi/2:2*pi,'XLim',[0 2*pi],'YLim',[0 1.2*max(Y)+0.001],...
%                 'XTickLabel',{'0';'pi/2';'pi';'3pi/2';'2pi'});
            set(gca,'XTick',0:pi/2:2*pi,'XLim',[0 2*pi],'YLim',[0 1.2*max(Y)+0.001],'Position',[0.04,0.06,0.92,0.89],...
                'XTickLabel',{'0';'pi/2';'pi';'3pi/2';'2pi'});
            title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);
            ylabel('Spikes');
            xlabel('Phase [rad]');
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

