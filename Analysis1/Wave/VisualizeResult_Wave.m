% VisualizeResult_Wave.m %

disp('  Visualizing Result_Wave ...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while (nStimuli~=0)
    show_id=input(['Which Stimuli to Show(1-',int2str(nStimuli),',p to Pass) : '],'s');
    if (show_id=='p')
        break;
    else
        Y=zeros(1,max_datapoint);
        Y_0=zeros(1,max_datapoint);
        X=zeros(1,max_datapoint);      
          
        % new figure for plot
        Describe=['( ',BlockName_Wave,' )','_nS_',show_id,'_Wave'];
        hF=figure('Name',Describe,'NumberTitle','off');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:max_datapoint
            Y(i)=wave(1,str2double(show_id),i);
            X(i)=i*(1/samplefreq)*1000;    % convert to ms
        end
        
        hY_0=plot(X,Y_0,'r','LineWidth',2);
        hold on;
        
        hWave=plot(X,Y,'b');  
        
        title(Describe,'Interpreter','none','FontWeight','bold','FontSize',10);
                
        ylabel('uV');
        xlabel('Time [ms]');
        hCurrentAxes=gca;
        set(hCurrentAxes,'XTick',0:250:stimulus_last_max,'XLim',[0 stimulus_last_max],'YLim',[-(1.2*max(abs(Y))+0.01) 1.2*max(abs(Y))+0.01]);
         
        % Save the figure !
        saveas(hF,Describe,'fig'); 
        
    end
end
