function SFC_Draw(sfcdata,DataSet,ch_w,ch_s,sort,sti)
% SFC_Draw.m
% 2010-09-22 by Zhang Li
% Draw Spike Field Coherence


if ch_w==0 % For Each Channal
    ch1 = 'Each';
else
    ch1 = int2str(ch_w);
end

if strcmp(sti,'ALL')
    sti_n = 0;
else
    sti_n = str2double(sti);
end

fig_name = [DataSet.Mark.extype,'__',DataSet.Snip.spevent,...
    '__( C-',ch1,' ^ C-',int2str(ch_s),'_U-',sort,' )__S-',sti,'__','SFC'];
scnsize = get(0,'ScreenSize');
output{1} = DataSet.OutputDir;
output{2} = fig_name;
output{3} = DataSet.Dinf.tank;
output{4} = DataSet.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','S_Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@SWin_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sti_max = DataSet.Mark.stimuli;
column = 4;
if mod(sti_max,column)==0
    row = sti_max/column;
else
    row = floor(sti_max/column)+1;
end


if strcmp(sort,'NO SORT !')
    errordlg('NO SORT DATA TO SHOW !','Data Error ');
elseif strcmp(sort,'MUA') % MUA
    if sti_n==0 % All Stimuli
        
        for s=1:sti_max
            subplot(row,column,s);
            
            Y = sfcdata{ch_s,end,s}.sfc;
            X = sfcdata{end,1,1};
            
            plot(X,Y,'b','LineWidth',1);
            
            set(gca,'XLim',[X(1) X(end)],'YLim',[0 0.05]);
            title(int2str(s),'Interpreter','none','FontWeight','bold','FontSize',10);
            
            ylabel('Spike Field Coherence');
            xlabel('Frequency [Hz]');
            
            axis off;
        end
    else % Single Stimuli
        Y = sfcdata{ch_s,end,sti_n}.sfc;
        X = sfcdata{end,1,1};
        
        plot(X,Y,'b','LineWidth',1);
        
        set(gca,'XLim',[X(1) X(end)],'YLim',[0 0.05]);
        title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);
        
        ylabel('Spike Field Coherence');
        xlabel('Frequency [Hz]');
    end
else % SUA
    if strcmp(sort,'SU')
        sort_n = 1;
    else
        sort_n = str2double(sort(end));
    end
    if sti_n==0 % All Stimuli
        
        for s=1:sti_max
            subplot(row,column,s);
            
            Y = sfcdata{ch_s,sort_n,s}.sfc;
            X = sfcdata{end,1,1};
            
            plot(X,Y,'b','LineWidth',1);
            
            set(gca,'XLim',[X(1) X(end)],'YLim',[0 0.05]);
            title(int2str(s),'Interpreter','none','FontWeight','bold','FontSize',10);
            
            ylabel('Spike Field Coherence');
            xlabel('Frequency [Hz]');
            
            axis off;
        end
    else % Single Stimuli
        Y = sfcdata{ch_s,sort_n,sti_n}.sfc;
        X = sfcdata{end,1,1};
        
        plot(X,Y,'b','LineWidth',1);
        
        set(gca,'XLim',[X(1) X(end)],'YLim',[0 0.05]);
        title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);
        
        ylabel('Spike Field Coherence');
        xlabel('Frequency [Hz]');
    end
end



function SWin_CloseRequestFcn(hObject, eventdata, handles)

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

