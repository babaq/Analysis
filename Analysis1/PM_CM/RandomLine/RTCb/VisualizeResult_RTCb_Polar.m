% VisualizeResult_RTCb_Polar.m %

% Plot the Processed Result

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta=zeros(1,(nStimuli_each+1));        % for real Stimuli degrees
rho_90=zeros(1,(nStimuli_each+1));       % for mean firing rate of 90
rho_45=zeros(1,(nStimuli_each+1));       % for mean firing rate of 45
SPON=zeros(1,(nStimuli_each+1));         % for background firing rate


for i=1:nStimuli_each    % Translate Code to real Stimuli degrees
    theta(i)=(2*pi/(nStimuli_each))*(i-1); 
    rho_90(i)=m_fr_90(i);
    rho_45(i)=m_fr_45(i);
    SPON(i)=spon;
end

theta(nStimuli_each+1)=2*pi;    % Make the line close
rho_90(nStimuli_each+1)=m_fr_90(1);
rho_45(nStimuli_each+1)=m_fr_45(1);
SPON(nStimuli_each+1)=spon;


% new figure for plot
Describe_Sort=['( ',BlockName_Snip,' )','_SC_',int2str(z),'_polar','_(',int2str(s),')_(',...
               num2str((Bn-1)*Bin*1000),'--',num2str(Bn*Bin*1000),'ms)'];
hF=figure('Name',Describe_Sort,'NumberTitle','off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hTuning_90=polar(theta,rho_90,'-ob');   % plot 90 Part            
set(hTuning_90,'LineWidth',1.5,'MarkerSize',1.5,'MarkerEdgeColor','k','MarkerFaceColor','k');
hold on;

hTuning_45=polar(theta,rho_45,'-or');   % plot 45 Part
set(hTuning_45,'LineWidth',1.5,'MarkerSize',1.5,'MarkerEdgeColor','k','MarkerFaceColor','k');
hold on;

hCircle=polar(theta,SPON,'-m');      % plot background firing rate


hCurrentAxes=gca;
title(Describe_Sort,'Interpreter','none','FontWeight','bold','FontSize',10);
xlabel('Direction(deg)');
ylabel('Firing Rate(spikes/s)');

legend(hCurrentAxes,'90(deg)','45(deg)','Background','Location','Best');
legend('boxoff');

set(hCurrentAxes,'XTick',X(1:2:end),'YDir','reverse');

annotation(hF,'textbox','LineStyle','none',...
           'String',{[' R_c = ',num2str(round(Rc*1000)/1000)],[' R_p = ',num2str(round(Rp*1000)/1000)],[' T = ',num2str(round(t*1000)/1000)]},...
           'FitHeightToText','off','Position',[0.1232 0.7643 0.1625 0.1369]);


% Save the figure !
saveas(hF,Describe_Sort,'fig');  
saveas(hF,Describe_Sort,'png');

