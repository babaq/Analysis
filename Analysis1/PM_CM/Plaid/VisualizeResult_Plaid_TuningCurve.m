% VisualizeResult_Plaid_TuningCurve.m %

% Plot the Processed Result
disp('  Visualizing Result_Plaid_TuningCurve ...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X=zeros(1,(nStimuli_each+1));     % x axes for real Stimuli degrees plus 360=0(deg)
Y_Grating=zeros(1,(nStimuli_each+1));     % y1 axes for mean firing rate of grating
Z_Grating=zeros(1,(nStimuli_each+1));     % error bar for SD or SE of grating
Y_Plaid=zeros(1,(nStimuli_each+1));     % y2 axes for mean firing rate of plaid
Z_Plaid=zeros(1,(nStimuli_each+1));     % error bar for SD or SE of plaid
SPON=zeros(1,(nStimuli_each+1));    % line for background firing rate


for i=1:(nStimuli_each+1)    % Translate Code to real Stimuli degrees
    X(i)=(360/(nStimuli_each))*(i-1);  
    SPON(i)=spon;
end

for i=1:nStimuli_each
    Y_Grating(i)=m_fr_grating(i);
    Z_Grating(i)=se_grating(i);
    Y_Plaid(i)=m_fr_plaid(i);
    Z_Plaid(i)=se_plaid(i);
end

Y_Grating(nStimuli_each+1)=m_fr_grating(1);  % Plus 360=0(deg)
Z_Grating(nStimuli_each+1)=se_grating(1);
Y_Plaid(nStimuli_each+1)=m_fr_plaid(1);
Z_Plaid(nStimuli_each+1)=se_plaid(1);


% new figure for plot
Describe_All=['( ',BlockName_Snip,' )','_SC_A','_(',int2str(s),')'];
Describe_Sort=['( ',BlockName_Snip,' )','_SC_',int2str(z),'_(',int2str(s),')'];

if(z==-1)
    hF=figure('Name',Describe_All,'NumberTitle','off');
else
    hF=figure('Name',Describe_Sort,'NumberTitle','off');
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hLine=plot(X,SPON,'-m');      % plot background firing rate

if(z==-1)
    title(Describe_All,'Interpreter','none','FontWeight','bold','FontSize',10);
else
    title(Describe_Sort,'Interpreter','none','FontWeight','bold','FontSize',10);
end

xlabel('Direction(deg)');
ylabel('Firing Rate(spikes/s)');
hold all;                    % for adding Grating Part and Plaid Part

hTuning_grating=errorbar(X,Y_Grating,Z_Grating,'-ob');   % plot Grating Part
set(hTuning_grating,'LineWidth',1.5,'MarkerSize',1.5,'MarkerEdgeColor','k','MarkerFaceColor','k');
hold all;

hTuning_plaid=errorbar(X,Y_Plaid,Z_Plaid,'-or');   % plot Plaid Part
set(hTuning_plaid,'LineWidth',1.5,'MarkerSize',1.5,'MarkerEdgeColor','k','MarkerFaceColor','k');

hCurrentAxes=gca;
legend(hCurrentAxes,'Background','Grating','Plaid',0);
legend('boxoff');
set(hCurrentAxes,'XTick',X(1:2:end));

annotation(hF,'textbox','LineStyle','none',...
           'String',{[' DI_g = ',num2str(DIg)],[' DI_p = ',num2str(DIp)]},...
           'FitHeightToText','off','Position',[0.122 0.8528 0.1423 0.06802]);

       
% Save the figure !
if (z==-1)
    saveas(hF,Describe_All,'fig');  
    saveas(hF,Describe_All,'png');
else
    saveas(hF,Describe_Sort,'fig');     
    saveas(hF,Describe_Sort,'png');
end
