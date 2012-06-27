% ProcessSpike_PTCc.m %

% Implement the Spike_Plaid Timecourse Computation according to the "Plaid Stimulus Protocal"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spike_count=zeros(1,(m-1)/3); % For Counting the number of spikes for each stimulus
firing_rate=zeros(nTrial,nStimuli); % spikes/sec
still_time=0.25;     % Custom stimulus still time(sec) before and after moving
s=length(find(spike));              % Refresh spike number for this spike sorting code


for j=1:nTrial
    for i=1:((m-1)/3)   
        if (((j-1)*nStimuli+1)<= i && i<=(j*nStimuli)) % confined to one Trial after another
        spike_count(i)=length(find(start_time(i)+still_time<spike & spike<start_time(i)+still_time+(Bin*Bn)));
        firing_rate(j,(floor((stimulus_code(i)*1000)/5)+1))=spike_count(i)/(Bin*Bn);   
        end
    end
end

clear spike_count;

m_fr=mean(firing_rate); % Mean Firing Rate(m_fr) for nStimuli
sd=std(firing_rate);    % Standard Deviation for nStimuli
se=sd/sqrt(nTrial);     % Standard Error for nStimuli
spon=m_fr(1);           % Background spontaneous spike firing rate

clear firing_rate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(mod((nStimuli-1),2)~=0)   % check Grating and Plaid part Completion
    disp('                           Error !');
    disp('            DO NOT Consist 2 Types of Stimuli !');
    disp('Total Stimuli');
    disp(nStimuli);
    break;
end

nStimuli_each=(nStimuli-1)/2;   % number of Stimuli for each type

m_fr_grating=zeros(1,nStimuli_each);
sd_grating=zeros(1,nStimuli_each);
se_grating=zeros(1,nStimuli_each);

m_fr_plaid=zeros(1,nStimuli_each);
sd_plaid=zeros(1,nStimuli_each);
se_plaid=zeros(1,nStimuli_each);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part "m_fr" , "sd" and "se" data for each type
% Cauculate DI=1-(Rnpd-Rs/Rpd-Rs)
% Rpd is the Max respones, Rnpd is the Opposite Direction of Rpd, Rs is spon
% Only DI > 0.5 indicate there has significant Direction Selectivity
for i=1:nStimuli_each    
    m_fr_grating(i)=m_fr(i+1);
    sd_grating(i)=sd(i+1);
    se_grating(i)=se(i+1);
    
    
    m_fr_plaid(i)=m_fr(i+1+nStimuli_each);
    sd_plaid(i)=sd(i+1+nStimuli_each);
    se_plaid(i)=se(i+1+nStimuli_each);
    
end

clear m_fr;
clear sd;
clear se;


Max_m_fr_grating=max(m_fr_grating);  
Min_m_fr_grating=min(m_fr_grating);
Max_m_fr_plaid=max(m_fr_plaid);  
Min_m_fr_plaid=min(m_fr_plaid);

index_grating=find(m_fr_grating==Max_m_fr_grating);
index_plaid=find(m_fr_plaid==Max_m_fr_plaid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if all m_fr(i)==0,usually occurs in spike_0
if (length(index_grating)>1)
    index_grating=1;
end

if (length(index_plaid)>1)
    index_plaid=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (index_grating>(nStimuli_each/2))
    index_grating=index_grating-(nStimuli_each/2);
else
    index_grating=index_grating+(nStimuli_each/2);
end

if (index_plaid>(nStimuli_each/2))
    index_plaid=index_plaid-(nStimuli_each/2);
else
    index_plaid=index_plaid+(nStimuli_each/2);
end

% Direction Index For Grating
DIg=1-round(((m_fr_grating(index_grating)-spon)/(Max_m_fr_grating-spon))*100)/100;
% Direction Index For Plaid
DIp=1-round(((m_fr_plaid(index_plaid)-spon)/(Max_m_fr_plaid-spon))*100)/100;
 

clear index_grating;
clear index_plaid;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(mod(nStimuli_each,8) ~= 0)   % Stimuli Number of Each Type should be (+int) times of 8
    disp('                           Error !');
    disp('                   Can Not Shift 45 degrees !');
    disp('Stimuli Number of Each Type');
    disp(nStimuli_each);
    break;
end

shift_value=nStimuli_each/8;    % Estimation of PM and CM selectivity
PM_m_fr_plaid=m_fr_grating;
CM_m_fr_plaid=circshift(m_fr_grating',-shift_value)'+circshift(m_fr_grating',shift_value)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp=corrcoef(m_fr_plaid,PM_m_fr_plaid); % Correlation coef of Data and Estimation
rp=temp(1,2);
temp=corrcoef(m_fr_plaid,CM_m_fr_plaid);
rc=temp(2,1);
temp=corrcoef(CM_m_fr_plaid,PM_m_fr_plaid);
rpc=temp(1,2);

clear temp;
clear PM_m_fr_plaid;
clear CM_m_fr_plaid;

Rp=(rp-rc*rpc)/sqrt((1-rc*rc)*(1-rpc*rpc));
Rc=(rc-rp*rpc)/sqrt((1-rp*rp)*(1-rpc*rpc));


zp=0.5*log((1+Rp)/(1-Rp));
zc=0.5*log((1+Rc)/(1-Rc));
t=(zp-zc)/sqrt(2/(nStimuli_each-shift_value));   % T-Test

clear zp;
clear zc;
clear shift_value;

%disp('          Grating---Plaid');
%disp('      Rp        Rc        t');
%disp([Rp,Rc,t]);


%%%%%%%%%%%%%%-----Plaid Stimulus Protocal-----%%%%%%%%%%%%%%%%

% Plaid is two moving gratings combined with an angle 0<¦Á<180(deg),
% and as many reseachers do, we set ¦Á=90. Too small or too big ¦Á will
% bias heavily to either Pattern Motion(PM) or Component Motion(CM).

% A Trail of Plaid Stimulus contains two parts: Grating Part and Plaid Part.
% (nStimuli-1)/2 Grating stimulus test Optimal Direction Selectivity.
% (nStimuli-1)/2 Plaid stimulus test for PM or CM selectivity.
% The Sf,Tf,contrast of two gratings of Plaid Part is the same as the Grating Part.
% The mean luminance of the two part is the same.

% In each trail, stimuli are encoded from Control(1) to Grating Part(clockwise)
% ,and to Plaid Part(clockwise) and presented randomly in each part.
 
 