% VisualizeResult_Event.m %

disp('  Visualizing Result_Event ...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while (nStimuli~=0)
    show_id=input(['Which Stimuli to Show(1-',int2str(nStimuli),',p to Pass) : '],'s');
    if (show_id=='p')
        break;
    else
        X=zeros(1,max_spike_count);     % x axes for spike time from stimulus presentation
        Y=ones(1,max_spike_count);      % y axes for Event
                
        hF=figure('Position',[180,40,700,640]);     % new figure for plot
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for i=1:nTrial
            subplot(nTrial*RecordType,1,i)
            %%%%%%%%%%%%%%%%%%%%%%%
            l=1;
            while (isempty(S{1,l})==0)  % how many sortcode
                l=l+1;
            end
            L=l-1;
            %%%%%%%%%%%%%%%%%%%%%%%
            for k=1:L  % plot each sortcode spike in one trial
                for j=1:max_spike_count
                    X(j)=S{1,k}(i,str2double(show_id),j);
                end
                color_table=['g','b','r','k','y','m','c'];
                
                hEvent=stem(X,Y,['-',color_table(k)]);
                set(hEvent,'LineWidth',1,'MarkerSize',1,'MarkerEdgeColor',color_table(k),'MarkerFaceColor',color_table(k));
                hold on;
            end
            %%%%%%%%%%%%%%%%%%%%%
            if (i==1)
                if (RecordType==1)
                    title(['( _',BlockName,'_snip )','_nS_',show_id,'_Event'],'Interpreter','none','FontWeight','bold','FontSize',10);
                else
                    title(['( _',BlockName,'_sp1_ )','_nS_',show_id,'_Event'],'Interpreter','none','FontWeight','bold','FontSize',10);
                end
            end
            ylabel(['Trial',int2str(i)]);
            hCurrentAxes=gca;
            set(hCurrentAxes,'XTick',[],'YTick',[],'Position',[0.12,0.91-(i-1)*0.053,0.78,0.053]);
            
            if (i==nTrial)
                xlabel('Time [ms]');
                set(hCurrentAxes,'XTick',0:250:stimulus_last_max,'YTick',[],'TickDir','out');
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if (RecordType==2)  % add the second data for double recording
            for i=1:nTrial
            subplot(nTrial*RecordType,1,i+nTrial)
            %%%%%%%%%%%%%%%%%%%%%%%
            l=1;
            while (isempty(S{2,l})==0)  % how many sortcode
                l=l+1;
            end
            L=l-1;
            %%%%%%%%%%%%%%%%%%%%%%%
            for k=1:L  % plot each sortcode spike in one trial
                for j=1:max_spike_count
                    X(j)=S{2,k}(i,str2double(show_id),j);
                end
                color_table=['g','b','r','k','y','m','c'];
                
                hEvent=stem(X,Y,['-',color_table(k)]);
                set(hEvent,'LineWidth',1,'MarkerSize',1,'MarkerEdgeColor',color_table(k),'MarkerFaceColor',color_table(k));
                hold on;
            end
            %%%%%%%%%%%%%%%%%%%%%
            if (i==1)
                title(['( _',BlockName,'_sp2_ )','_nS_',show_id,'_Event'],'Interpreter','none','FontWeight','bold','FontSize',10);
            end
            ylabel(['Trial',int2str(i)]);
            hCurrentAxes=gca;
            set(hCurrentAxes,'XTick',[],'YTick',[],'Position',[0.12,0.91-(i+nTrial+3)*0.053,0.78,0.053]);
            
            if (i==nTrial)
                xlabel('Time [ms]');
                set(hCurrentAxes,'XTick',0:250:stimulus_last_max,'YTick',[],'TickDir','out');
            end
            end
        end
        %%%%%%%%%%%%%%%%%%%
        annotation(hF,'textbox','LineStyle','none',...
           'String',{'SortCode: 0 1 2 3 4 5 6','   Color:    g b r k y m c'},...
           'FitHeightToText','off','Position',[0.1492 0.5631 0.2151 0.06802]);
    end
end
