% ProcessSpike_B_Plaid.m %

% Implement the Spike_Plaid Computation 
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
PDg=(360/(nStimuli_each))*(index_grating-1);   % perfered direction of grating
index_plaid=find(m_fr_plaid==Max_m_fr_plaid);
PDp=(360/(nStimuli_each))*(index_plaid-1);   % perfered direction of plaid

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% organize data for plot tuning curve
X=zeros(1,(nStimuli_each+1));     % x axes for real Stimuli degrees plus 360=0(deg)
Y_Grating=zeros(1,(nStimuli_each+1));     % y1 axes for mean firing rate of grating
Z_Grating=zeros(1,(nStimuli_each+1));     % error bar for SD or SE of grating
Y_Plaid=zeros(1,(nStimuli_each+1));     % y2 axes for mean firing rate of plaid
Z_Plaid=zeros(1,(nStimuli_each+1));     % error bar for SD or SE of plaid
SPON_t=zeros(1,(nStimuli_each+1));    % line for background firing rate


for i=1:(nStimuli_each+1)    % Translate Code to real Stimuli degrees
    X(i)=(360/(nStimuli_each))*(i-1);  
    SPON_t(i)=spon;
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% organize data for plot tuning polar
theta=zeros(1,(nStimuli_each+1));           % for real Stimuli degrees
rho_grating=zeros(1,(nStimuli_each+1));     % for mean firing rate of grating
rho_plaid=zeros(1,(nStimuli_each+1));       % for mean firing rate of plaid
SPON_p=zeros(1,(nStimuli_each+1));            % for background firing rate


for i=1:nStimuli_each    % Translate Code to real Stimuli degrees
    theta(i)=(2*pi/(nStimuli_each))*(i-1); 
    rho_grating(i)=m_fr_grating(i);
    rho_plaid(i)=m_fr_plaid(i);
    SPON_p(i)=spon;
end


theta(nStimuli_each+1)=2*pi;    % Make the line close
rho_grating(nStimuli_each+1)=m_fr_grating(1);
rho_plaid(nStimuli_each+1)=m_fr_plaid(1);
SPON_p(nStimuli_each+1)=spon;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data to export to xls file
info={para_struct.BatchList_DataDir para_struct.BatchList_MarkerName ...
      para_struct.BatchList_SnipName para_struct.BatchList_StiType ['SortCode_',int2str(z)]};
  
title_stata={'Rc' 'Rp' 'T' 'Spon' 'SpikeNum' };
stata=[Rc Rp t spon s];

title_stata_g={'DI_g' 'PD_g' 'Max_m_fr_g' 'Min_m_fr_g'};
stata_g=[DIg PDg Max_m_fr_grating Min_m_fr_grating];

title_stata_p={'DI_p' 'PD_p' 'Max_m_fr_p' 'Min_m_fr_p'};
stata_p=[DIp PDp Max_m_fr_plaid Min_m_fr_plaid];

title_data_gt={'deg_g' 'M_fr_g' 'se_g' 'Spon'};
data_gt=[X' Y_Grating' Z_Grating' SPON_t'];

title_data_pt={'deg_p' 'M_fr_p' 'se_p' 'Spon'};
data_pt=[X' Y_Plaid' Z_Plaid' SPON_t'];

title_data_gp={'theta' 'rho_g' 'Spon'};
data_gp=[theta' rho_grating' SPON_p'];

title_data_pp={'theta' 'rho_p' 'Spon'};
data_pp=[theta' rho_plaid' SPON_p'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save results data in *.xls file
warning off MATLAB:xlswrite:AddSheet
cd (deblank('E:\Experiment\Exported Data\Batch_Results'));
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],info,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)]);

xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_stata,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A3');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],stata,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A4');

xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_stata_g,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A6');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],stata_g,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A7');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_stata_p,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'F6');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],stata_p,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'F7');

xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_data_gt,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A9');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],data_gt,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A10');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_data_pt,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'F9');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],data_pt,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'F10');

xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_data_gp,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],['A',int2str(10+nStimuli_each+2)]);
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],data_gp,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],['A',int2str(10+nStimuli_each+3)]);
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_data_pp,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],['F',int2str(10+nStimuli_each+2)]);
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],data_pp,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],['F',int2str(10+nStimuli_each+3)]);

 
 