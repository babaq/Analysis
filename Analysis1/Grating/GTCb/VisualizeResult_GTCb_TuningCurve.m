% VisualizeResult_GTCb_TuningCurve.m %

% Plot the Processed Result

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X=zeros(1,nStimuli);     % x axes for real Stimuli degrees
Y=zeros(1,nStimuli);     % y axes for mean firing rate
Z=zeros(1,nStimuli);     % error bar for Standard Deviation or Standard Error
SPON=zeros(1,nStimuli);  % line for background firing rate

for i=2:nStimuli    % Translate Code to real Stimuli degrees
    X(i)=(360/(nStimuli-1))*(i-1);  
    Y(i-1)=RealSti_fr(i-1);
    Z(i-1)=se(i);
    SPON(i)=spon;
end

X(1)=0;
Y(nStimuli)=RealSti_fr(1); % Plus 360=0(deg)
Z(nStimuli)=se(2);
SPON(1)=spon;


% new figure for plot
Describe_Sort=['( ',BlockName_Snip,' )','_SC_',int2str(z),'_(',int2str(s),')',...
               num2str((Bn-1)*Bin*1000),'--',num2str(Bn*Bin*1000),'ms)'];
hF=figure('Name',Describe_Sort,'NumberTitle','off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hLine=plot(X,SPON,'-b');      % plot background firing rate

title(Describe_Sort,'Interpreter','none','FontWeight','bold','FontSize',10);
xlabel('Direction(deg)');
ylabel('Firing Rate(spikes/s)');
hold all;                    % for adding Tuning curve

hTuning=errorbar(X,Y,Z,'-ok');   % plot Tuning curve
set(hTuning,'LineWidth',1.5,'MarkerSize',1.5,'MarkerEdgeColor','r','MarkerFaceColor','r');
hCurrentAxes=gca;
set(hCurrentAxes,'XTick',X(1:2:end));


annotation(hF,'textbox','LineStyle','none',...
           'String',{[' DI = ',num2str(DI)]},...
           'FitHeightToText','on','Position',[0.772 0.8361 0.1423 0.06802]);
       
       
% Save the figure !
saveas(hF,Describe_Sort,'fig');          
saveas(hF,Describe_Sort,'png');

