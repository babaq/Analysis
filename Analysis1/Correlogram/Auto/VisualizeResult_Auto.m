% VisualizeResult_Auto.m %

disp('  Visualizing Result_Auto ...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while (nStimuli~=0)
    show_id=input(['Which Stimuli to Plot(1-',int2str(nStimuli),',p to Pass) : '],'s');
    if (show_id=='p')
        break;
    else
        Y=zeros(1,bin_number);     % for spike event coincidences for each stimulus presentation
        X=-N/binwidth:N/binwidth-1; % for correlation time lags (ms)
                
        % new figure for plot
        Describe_All=['( ',BlockName_Snip,' )','_SC_A_nS_',show_id,'_Auto'];
        Describe_All_Data=['( ',BlockName_Snip,' )','_SC_A','_Auto'];
        Describe_Sort=['( ',BlockName_Snip,' )','_SC_',int2str(z),'_nS_',show_id,'_Auto'];
        Describe_Sort_Data=['( ',BlockName_Snip,' )','_SC_',int2str(z),'_Auto'];
        
        if(z==-1)
            hF=figure('Name',Describe_All,'NumberTitle','off');
        else
            hF=figure('Name',Describe_Sort,'NumberTitle','off');
        end 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for j=1:bin_number
            Y(j)=bin_Dirac(j,str2double(show_id));
        end
        
        hAuto=bar(X,Y,1);  
        
        if(z==-1)
            title(Describe_All,'Interpreter','none','FontWeight','bold','FontSize',10);
        else
            title(Describe_Sort,'Interpreter','none','FontWeight','bold','FontSize',10);
        end
                
        Y(N/binwidth+1)=0;  % eliminate 0 ms lag value
        
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
%         f=0;    % when Auto correlation, f=0
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
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Save the figure and Data !
        if (z==-1)
            saveas(hF,Describe_All,'fig'); 
            evalc(['Y_A_',show_id,'=Y;']);
            save(Describe_All_Data,'X','Y_A_*');
        else
            saveas(hF,Describe_Sort,'fig'); 
            evalc(['Y_SC_',int2str(z),'_',show_id,'=Y;']);
            save(Describe_Sort_Data,'X','Y_SC_*');
        end 
                
    end
end
