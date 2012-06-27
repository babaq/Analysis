function Corr_Draw(cdata,CorrData,delay,lag,bin,ch_1,sort1,ch_2,sort2,sti,isauto,isfit)
% Corr_Draw.m
% 2011-04-03 by Zhang Li
% Draw Cross/Auto Correlation


lag_n = str2double(lag);
bin_n = str2double(bin);

if strcmp(sti,'ALL')
    sti_n = 0;
else
    sti_n = str2double(sti);
end
sti_max = CorrData.Mark.stimuli;

textsize = 14;
fig_name = [CorrData.Mark.extype,'__',CorrData.Snip.spevent,...
    '__( C-',ch_1,'_U-',sort1,' ^ C-',ch_2,'_U-',sort2,' )__S-',sti,'_',delay,'msDelay_',bin,'msBin'];
scnsize = get(0,'ScreenSize');
output{1} = CorrData.OutputDir;
output{2} = fig_name;
output{3} = CorrData.Dinf.tank;
output{4} = CorrData.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin = figure('Units','pixels',...
    'Position',[150 30 scnsize(3)*0.85 scnsize(4)*0.86], ...
    'Tag','Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cdata = squeeze(mean(cdata.data));
centerindex = floor(lag_n/bin_n)+1;
barcolor = [0.15 0.25 0.45];


if strcmp(ch_1,ch_2) && strcmp(sort1,sort2) % Auto Correlation
    if isauto % Normalize
        for s=1:CorrData.Mark.stimuli
            cdata(s,:) = (cdata(s,:)/cdata(s,centerindex))*100;
            cdata(s,centerindex) = (cdata(s,centerindex-1)+cdata(s,centerindex+1))/2;
        end
        labely = 'Correlation (Percent of TotalSpikes)';
    end
else
    labely = 'Correlation (Coincidence/Sweep)';
end

column = 4;
if sti_n==0 % All Stimuli
    if mod(sti_max,column)==0
        row = sti_max/column;
    else
        row = floor(sti_max/column)+1;
    end

    ymax = max(max(cdata));
    for s=1:sti_max
        subplot(row,column,s);
        X = (-lag_n:bin_n:lag_n);
        Y = cdata(s,:);
        
        plot([0 0],[0 1.05*ymax+0.001],'k','LineWidth',1);
        hold on;
        hC = bar(X,Y,1);
        hold on;

        set(gca,'LineWidth',2,'FontSize',textsize,'box','off','XTick',-lag_n:50:lag_n,'XLim',[-lag_n lag_n],...
            'tickdir','out','YLim',[0 1.05*ymax+0.001]);
        set(hC,'edgecolor','none','facecolor',barcolor);
        title(int2str(s),'Interpreter','none','FontWeight','bold','FontSize',textsize);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if isfit
            ind=find(Y==max(Y));
            f=X(ind(1));

            [curve_fit,goodness,fit_info]=GaborFit(X,Y,max(Y),lag_n/bin_n,f);
            disp(curve_fit);
            disp(goodness);
            disp(fit_info);

            % add Correlation Fitting Curve
            hCFit=plot(curve_fit,'-r','fit',0.95);
            set(hCFit,'LineWidth',2);
            legend off;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ylabel(labely,'FontSize',textsize);
        xlabel('Time (ms)','FontSize',textsize);

        axis off;
    end

else % Single Stimuli

    X = (-lag_n:bin_n:lag_n);
    Y = cdata(sti_n,:);
    plot([0 0],[0 1.1*max(Y)+0.001],'k','LineWidth',2);
    hold on;
    hC = bar(X,Y,1);
    hold on;

    set(gca,'LineWidth',2,'FontSize',textsize,'box','off','XTick',-lag_n:50:lag_n,'XLim',[-lag_n lag_n],...
        'tickdir','out','YLim',[0 1.1*max(Y)+0.001]);
    set(hC,'edgecolor','none','facecolor',barcolor);
    title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isfit
        ind=find(Y==max(Y));
        f=X(ind(1));

        [curve_fit,goodness,fit_info]=GaborFit(X,Y,max(Y),lag_n/bin_n,f);
        disp(curve_fit);
        disp(goodness);
        disp(fit_info);

        % add Correlation Fitting Curve
        hCFit=plot(curve_fit,'-r','fit',0.95);
        set(hCFit,'LineWidth',2);
        legend off;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ylabel(labely,'FontSize',textsize);
    xlabel('Time (ms)','FontSize',textsize);

end


function Win_CloseRequestFcn(hObject, eventdata, handles)

SaveFigure(hObject);

delete(hObject);