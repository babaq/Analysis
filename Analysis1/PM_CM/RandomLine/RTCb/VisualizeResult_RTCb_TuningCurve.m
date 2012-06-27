% VisualizeResult_RTCb_TuningCurve.m %

% Plot the Processed Result

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X=zeros(1,(nStimuli_each+1));        % x axes for real Stimuli degrees plus Control
Y_90=zeros(1,(nStimuli_each+1));     % y1 axes for mean firing rate of 90
Z_90=zeros(1,(nStimuli_each+1));     % error bar for SD or SE of 90
Y_45=zeros(1,(nStimuli_each+1));     % y2 axes for mean firing rate of 45
Z_45=zeros(1,(nStimuli_each+1));     % error bar for SD or SE of 45
SPON=zeros(1,(nStimuli_each+1));     % line for background firing rate


for i=1:(nStimuli_each+1)    % Translate Code to real Stimuli degrees
    X(i)=(360/(nStimuli_each))*(i-1);  
    SPON(i)=spon;
end

for i=1:nStimuli_each
    Y_90(i)=m_fr_90(i);
    Z_90(i)=se_90(i);
    Y_45(i)=m_fr_45(i);
    Z_45(i)=se_45(i);
end


Y_90(nStimuli_each+1)=m_fr_90(1);  % Plus 360=0(deg)
Z_90(nStimuli_each+1)=se_90(1);
Y_45(nStimuli_each+1)=m_fr_45(1);
Z_45(nStimuli_each+1)=se_45(1);


% new figure for plot
Describe_Sort=['( ',BlockName_Snip,' )','_SC_',int2str(z),'_(',int2str(s),')_(',...
               num2str((Bn-1)*Bin*1000),'--',num2str(Bn*Bin*1000),'ms)'];
hF=figure('Name',Describe_Sort,'NumberTitle','off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hLine=plot(X,SPON,'-m');      % plot background firing rate

title(Describe_Sort,'Interpreter','none','FontWeight','bold','FontSize',10);
xlabel('Direction(deg)');
ylabel('Firing Rate(spikes/s)');
hold all;                    % for adding Grating Part and Plaid Part

hTuning_90=errorbar(X,Y_90,Z_90,'-ob');   % plot 90 Part
set(hTuning_90,'LineWidth',1.5,'MarkerSize',1.5,'MarkerEdgeColor','k','MarkerFaceColor','k');
hold all;

hTuning_45=errorbar(X,Y_45,Z_45,'-or');   % plot 45 Part
set(hTuning_45,'LineWidth',1.5,'MarkerSize',1.5,'MarkerEdgeColor','k','MarkerFaceColor','k');

hCurrentAxes=gca;
legend(hCurrentAxes,'Background','90(deg)','45(deg)',0);
legend('boxoff');
set(hCurrentAxes,'XTick',X(1:2:end));


annotation(hF,'textbox','LineStyle','none',...
           'String',{[' DI_9_0 = ',num2str(DI90)],[' DI_4_5 = ',num2str(DI45)]},...
           'FitHeightToText','on','Position',[0.122 0.8528 0.2023 0.06802]);

       
% Save the figure !
saveas(hF,Describe_Sort,'fig');  
saveas(hF,Describe_Sort,'png');


