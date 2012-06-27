% VisualizeResult_Cross.m %

disp('  Visualizing Result_Cross ...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while (nStimuli~=0)
    show_id=input(['Which Stimuli to Plot(1-',int2str(nStimuli),',p to Pass) : '],'s');
    if (show_id=='p')
        break;
    else
        Y=zeros(1,bin_number);      % for spike event coincidences for each stimulus presentation
        X=-N/binwidth:N/binwidth-1; % for correlation time lags (ms)  
        
        % new figure for plot
        Describe_All=['( ',Spike1Name,'  --  ',Spike2Name,' )',' _nS_',show_id,'_Cross'];
        Describe_Data=['( ',Spike1Name,'  --  ',Spike2Name,' )','_Cross'];
        hF=figure('Name',Describe_All,'NumberTitle','off');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for j=1:bin_number
            Y(j)=bin_Dirac(j,str2double(show_id));
        end
        
        hCross=bar(X,Y,1);  
        
        title(Describe_All,'Interpreter','none','FontWeight','bold','FontSize',10);
        hCurrentAxes=gca;
        set(hCurrentAxes,'XTick',-N/binwidth:50:N/binwidth,'XLim',[-N/binwidth,N/binwidth],'YLim',[0 1.2*max(Y)+0.01]);
        
        hold on;
        
        mlineY=0:1.2*max(Y)+0.01:1.2*max(Y)+0.01;
        mlineX=0*mlineY;    % for 0ms lag line
        plot(mlineX,mlineY,'r','LineWidth',2);
        hold on;
        
        % Correlogram Curve Fitting
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
        % use GaborFit function to fit
        % when Cross correlation, f=(max(Y) 's time)
%         ind=find(Y==max(Y));
%         f=X(ind(1)); 
%         
%         [curve_fit,goodness,fit_info]=GaborFit(X,Y,max(Y),N/binwidth,f);
%         disp(curve_fit);
%         disp(goodness);
%         
%         % add Correlogram Fitting Curve
%         hCFit=plot(curve_fit,'-k','fit',0.95);
%         set(hCFit,'LineWidth',2);
%         legend off;     % turn off legend from plot method call
        
        ylabel(['Coincidences of ',int2str(nTrial),' Trials']);
        xlabel('Time [ms]');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
        % Save the figure and data !
        saveas(hF,Describe_All,'fig');
        evalc(['Y_',show_id,'=Y;']);
        save(Describe_Data,'X','Y_*');
     
    end
end
