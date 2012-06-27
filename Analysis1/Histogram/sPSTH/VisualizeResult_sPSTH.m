% VisualizeResult_sPSTH.m %

disp('  Visualizing Result_sPSTH ...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while (nStimuli~=0)
    show_id=input(['Which Stimuli to Plot(1-',int2str(nStimuli),',p to Pass) : '],'s');
    if (show_id=='p')
        break;
    else
        Y=zeros(1,bin_number);     % for spike event coincidences for each stimulus presentation
                
        % new figure for plot
        Describe_All=['( ',BlockName_Snip,' )','_SC_A_nS_',show_id,'_sPSTH'];
        Describe_Sort=['( ',BlockName_Snip,' )','_SC_',int2str(z),'_nS_',show_id,'_sPSTH'];
        
        if(z==-1)
            hF=figure('Name',Describe_All,'NumberTitle','off');
        else
            hF=figure('Name',Describe_Sort,'NumberTitle','off');
        end 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for j=1:bin_number
            Y(j)=bin_Dirac(j,str2double(show_id));
        end
        
        hsPSTH=bar(Y,1);  
        
        if(z==-1)
            title(Describe_All,'Interpreter','none','FontWeight','bold','FontSize',10);
        else
            title(Describe_Sort,'Interpreter','none','FontWeight','bold','FontSize',10);
        end
        
        ylabel(['Coincidences of ',int2str(nTrial),' Trials']);
        xlabel('Time [ms]');
        hCurrentAxes=gca;
        set(hCurrentAxes,'XTick',0:250:bin_number,'XLim',[0 bin_number],'YLim',[0 1.2*max(Y)+0.01]);
        
        % Save the figure !
        if (z==-1)
            saveas(hF,Describe_All,'fig'); 
        else
            saveas(hF,Describe_Sort,'fig'); 
        end 
    end
end
