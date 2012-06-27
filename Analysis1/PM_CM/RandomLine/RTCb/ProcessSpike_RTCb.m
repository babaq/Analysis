% ProcessSpike_RTCb.m %

% Implement the Spike_RandomLine Timecourse Computation according to the "RandomLine Stimulus Protocal"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spike_count=zeros(1,(m-1)/3); % For Counting the number of spikes for each stimulus
firing_rate=zeros(nTrial,nStimuli); % spikes/sec
s=length(find(spike));              % Refresh spike number for this spike sorting code


for j=1:nTrial
    for i=1:((m-1)/3)   
        if (((j-1)*nStimuli+1)<= i && i<=(j*nStimuli)) % confined to one Trial after another
        spike_count(i)=length(find(start_time(i)+(Bin*(Bn-1))<spike & spike<start_time(i)+(Bin*Bn)));
        firing_rate(j,(floor((stimulus_code(i)*1000)/5)+1))=spike_count(i)/Bin;   
        end
    end
end

clear spike_count;

m_fr=mean(firing_rate); % Mean Firing Rate(m_fr) for nStimuli
sd=std(firing_rate);    % Standard Deviation for nStimuli
se=sd/sqrt(nTrial);     % Standard Error for nStimuli
spon=m_fr(1);           % Background spontaneous spike firing rate

clear firing_rate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(mod((nStimuli-1),2)~=0)   % check 90(deg) and 45(deg) part Completion
    disp('                           Error !');
    disp('            DO NOT Consist 2 Types of Stimuli !');
    disp('Total Stimuli');
    disp(nStimuli);
    break;
end

nStimuli_each=(nStimuli-1)/2;   % number of Stimuli for each type

m_fr_90=zeros(1,nStimuli_each);
sd_90=zeros(1,nStimuli_each);
se_90=zeros(1,nStimuli_each);

m_fr_45=zeros(1,nStimuli_each);
sd_45=zeros(1,nStimuli_each);
se_45=zeros(1,nStimuli_each);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part "m_fr" , "sd" and "se" data for each type
% Cauculate DI=1-(Rnpd-Rs/Rpd-Rs)
% Rpd is the Max respones, Rnpd is the Opposite Direction of Rpd, Rs is spon
% Only DI > 0.5 indicate there has significant Direction Selectivity
for i=1:nStimuli_each  
    m_fr_90(i)=m_fr(i+1);
    sd_90(i)=sd(i+1);
    se_90(i)=sd(i+1);
   
    
    m_fr_45(i)=m_fr(i+1+nStimuli_each);
    sd_45(i)=sd(i+1+nStimuli_each);
    se_45(i)=sd(i+1+nStimuli_each);
    
end

clear m_fr;
clear sd;
clear se;


Max_m_fr_90=max(m_fr_90);  
Min_m_fr_90=min(m_fr_90);
Max_m_fr_45=max(m_fr_45);  
Min_m_fr_45=min(m_fr_45);

index_90=find(m_fr_90==Max_m_fr_90);
index_45=find(m_fr_45==Max_m_fr_45);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if all m_fr(i)==0,usually occurs in spike_0
if (length(index_90)>1)
    index_90=1;
end

if (length(index_45)>1)
    index_45=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (index_90>(nStimuli_each/2))
    index_90=index_90-(nStimuli_each/2);
else
    index_90=index_90+(nStimuli_each/2);
end

if (index_45>(nStimuli_each/2))
    index_45=index_45-(nStimuli_each/2);
else
    index_45=index_45+(nStimuli_each/2);
end

% Direction Index For 90
DI90=1-round(((m_fr_90(index_90)-spon)/(Max_m_fr_90-spon))*100)/100;
% Direction Index For 45
DI45=1-round(((m_fr_45(index_45)-spon)/(Max_m_fr_45-spon))*100)/100;
 

clear index_grating;
clear index_plaid;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(mod(nStimuli_each,8) ~= 0) % Stimuli Number of Each Type should be (+int) times of 8
    disp('                           Error !');
    disp('                   Can Not Shift 45 degrees !');
    disp('Stimuli Number of Each Type');
    disp(nStimuli_each);
    break;
end

shift_value=nStimuli_each/8;    % Estimation of PM and CM selectivity
PM_m_fr_45=m_fr_90;
CM_m_fr_45=circshift(m_fr_90',-shift_value)';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp=corrcoef(m_fr_45,PM_m_fr_45); % Correlation coef of Data and Estimation
rp=temp(1,2);
temp=corrcoef(m_fr_45,CM_m_fr_45);
rc=temp(2,1);
temp=corrcoef(CM_m_fr_45,PM_m_fr_45);
rpc=temp(1,2);

clear temp;
clear PM_m_fr_45;
clear CM_m_fr_45;

Rp=(rp-rc*rpc)/sqrt((1-rc*rc)*(1-rpc*rpc));
Rc=(rc-rp*rpc)/sqrt((1-rp*rp)*(1-rpc*rpc));


zp=0.5*log((1+Rp)/(1-Rp));
zc=0.5*log((1+Rc)/(1-Rc));
t=(zp-zc)/sqrt(2/(nStimuli_each-shift_value));   % T-Test

clear zp;
clear zc;
clear shift_value;

%disp('        90(deg)---45(deg)');
%disp('      Rp        Rc        t');
%disp([Rp,Rc,t]);


%%%%%%%%%%%%%%%-----RandomLine Stimulus Protocal-----%%%%%%%%%%%%%%%%

% RandomLine is consist of identical short lines that distributed in the
% screan randomly. The angle(clockwise) between the short line Orientation and 
% the short line Moving Direction could be 0<¦Á<180(deg). As many
% reseachers do, we set ¦Á1=90 and ¦Á2=45. 

% A Trail of RandomLine stimulus contains two parts: 90(deg) Part and 45(deg) Part.
% (nStimuli-1)/2 90(deg) Part stimulus test Optimal Direction Selectivity.
% (nStimuli-1)/2 45(deg) Part stimulus test for PM or CM selectivity.

% In each trail, stimuli are encoded from Control(1) to 90 Part(clockwise)
% ,and to 45 Part(clockwise) and presented randomly in each part.
 
 