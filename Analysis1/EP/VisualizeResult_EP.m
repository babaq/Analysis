% VisualizeResult_EP.m %

disp('  Visualizing Result_EP ...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while (nStimuli~=0)
    show_id=input(['Which Stimuli to Show(1-',int2str(nStimuli),',p to Pass) : '],'s');
    if (show_id=='p')
        break;
    else
        X=zeros(1,max_spike_count);     % for spike time from stimulus presentation
        Y=ones(1,max_spike_count);      % for spike event
        Z=zeros(1,bin_number);          % for spike event coincidences for each stimulus presentation
        
        % new figure for plot
        Describe_All=['( ',DataName_spike,' )','_SC_A_nS_',show_id,'_EP'];
        Describe_Sort=['( ',DataName_spike,' )','_SC_',int2str(z),'_nS_',show_id,'_EP'];
        
        if(z==-1)
            hF=figure('Name',Describe_All,'NumberTitle','off','Position',[180,50,700,620]);
        else
            hF=figure('Name',Describe_Sort,'NumberTitle','off','Position',[180,50,700,620]);
        end       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:(nTrial+1)
            subplot((nTrial+1),1,i)
            if (i~=(nTrial+1))
                for j=1:max_spike_count
                    X(j)=spike_time(i,str2double(show_id),j);
                end
                
                hEvent=stem(X,Y,'-b'); 
                set(hEvent,'LineWidth',1,'MarkerSize',1,'MarkerEdgeColor','b','MarkerFaceColor','b');
                
                if (i==1)
                    if(z==-1)
                        title(Describe_All,'Interpreter','none','FontWeight','bold','FontSize',10);
                    else
                        title(Describe_Sort,'Interpreter','none','FontWeight','bold','FontSize',10);
                    end
                end
                
            ylabel(['Trial',int2str(i)]);
            hCurrentAxes=gca;
            set(hCurrentAxes,'XTick',[],'YTick',[],'Position',[0.12,0.85-(i-1)*0.07,0.8,0.07]);
            else
                for k=1:bin_number
                    Z(k)=bin_Dirac(k,str2double(show_id));
                end
                
                hsPSTH=bar(Z,1);
                ylabel(['Coincidences of ',int2str(nTrial),' Trials']);
                xlabel('Time [10ms]');
                hCurrentAxes=gca;
                set(hCurrentAxes,'XTick',0:25:bin_number,'XLim',[0 bin_number],'YLim',[0 1.2*max(Z)+0.01],'Position',[0.12,0.85-(i-2)*0.07-0.5,0.8,0.5]);
                
                % Save the figure !
                if (z==-1)
                    saveas(hF,Describe_All,'fig'); 
                else
                    saveas(hF,Describe_Sort,'fig');
                end 
                
            end
        end  
    end
end
