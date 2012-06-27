% ProcessSpike_B_RandomLine.m %

% Implement the Spike_RandomLine Computation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spike_count=zeros(1,(m-1)/3); % For Counting the number of spikes for each stimulus
firing_rate=zeros(nTrial,nStimuli); % spikes/sec
still_time=0.25;     % Custom stimulus still time(sec) before and after moving
s=length(find(spike));              % Refresh spike number for this spike sorting code


for j=1:nTrial
    for i=1:((m-1)/3)   
        if (((j-1)*nStimuli+1)<= i && i<=(j*nStimuli)) % confined to one Trial after another
        spike_count(i)=length(find(start_time(i)+still_time<spike & spike<end_time(i)-still_time));
        firing_rate(j,(floor((stimulus_code(i)*1000)/5)+1))=spike_count(i)/(stimulus_last(i)-still_time*2);   
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
PD90=(360/(nStimuli_each))*(index_90-1);   % perfered direction of 90
index_45=find(m_fr_45==Max_m_fr_45);
PD45=(360/(nStimuli_each))*(index_45-1);   % perfered direction of 45

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% organize data for plot tuning curve
X=zeros(1,(nStimuli_each+1));        % x axes for real Stimuli degrees plus Control
Y_90=zeros(1,(nStimuli_each+1));     % y1 axes for mean firing rate of 90
Z_90=zeros(1,(nStimuli_each+1));     % error bar for SD or SE of 90
Y_45=zeros(1,(nStimuli_each+1));     % y2 axes for mean firing rate of 45
Z_45=zeros(1,(nStimuli_each+1));     % error bar for SD or SE of 45
SPON_t=zeros(1,(nStimuli_each+1));     % line for background firing rate


for i=1:(nStimuli_each+1)    % Translate Code to real Stimuli degrees
    X(i)=(360/(nStimuli_each))*(i-1);  
    SPON_t(i)=spon;
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% organize data for plot tuning polar
theta=zeros(1,(nStimuli_each+1));        % for real Stimuli degrees
rho_90=zeros(1,(nStimuli_each+1));       % for mean firing rate of 90
rho_45=zeros(1,(nStimuli_each+1));       % for mean firing rate of 45
SPON_p=zeros(1,(nStimuli_each+1));         % for background firing rate


for i=1:nStimuli_each    % Translate Code to real Stimuli degrees
    theta(i)=(2*pi/(nStimuli_each))*(i-1); 
    rho_90(i)=m_fr_90(i);
    rho_45(i)=m_fr_45(i);
    SPON_p(i)=spon;
end

theta(nStimuli_each+1)=2*pi;    % Make the line close
rho_90(nStimuli_each+1)=m_fr_90(1);
rho_45(nStimuli_each+1)=m_fr_45(1);
SPON_p(nStimuli_each+1)=spon;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data to export to xls file
info={para_struct.BatchList_DataDir para_struct.BatchList_MarkerName ...
      para_struct.BatchList_SnipName para_struct.BatchList_StiType ['SortCode_',int2str(z)]};
  
title_stata={'Rc' 'Rp' 'T' 'Spon' 'SpikeNum' };
stata=[Rc Rp t spon s];

title_stata_90={'DI_90' 'PD_90' 'Max_m_fr_90' 'Min_m_fr_90'};
stata_90=[DI90 PD90 Max_m_fr_90 Min_m_fr_90];

title_stata_45={'DI_45' 'PD_45' 'Max_m_fr_45' 'Min_m_fr_45'};
stata_45=[DI45 PD45 Max_m_fr_45 Min_m_fr_45];

title_data_90t={'deg_90' 'M_fr_90' 'se_90' 'Spon'};
data_90t=[X' Y_90' Z_90' SPON_t'];

title_data_45t={'deg_45' 'M_fr_45' 'se_45' 'Spon'};
data_45t=[X' Y_45' Z_45' SPON_t'];

title_data_90p={'theta' 'rho_90' 'Spon'};
data_90p=[theta' rho_90' SPON_p'];

title_data_45p={'theta' 'rho_45' 'Spon'};
data_45p=[theta' rho_45' SPON_p'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save results data in *.xls file
warning off MATLAB:xlswrite:AddSheet
cd (deblank('E:\Experiment\Exported Data\Batch_Results'));
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],info,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)]);

xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_stata,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A3');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],stata,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A4');

xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_stata_90,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A6');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],stata_90,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A7');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_stata_45,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'F6');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],stata_45,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'F7');

xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_data_90t,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A9');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],data_90t,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A10');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_data_45t,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'F9');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],data_45t,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'F10');

xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_data_90p,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],['A',int2str(10+nStimuli_each+2)]);
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],data_90p,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],['A',int2str(10+nStimuli_each+3)]);
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_data_45p,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],['F',int2str(10+nStimuli_each+2)]);
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],data_45p,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],['F',int2str(10+nStimuli_each+3)]);

 
