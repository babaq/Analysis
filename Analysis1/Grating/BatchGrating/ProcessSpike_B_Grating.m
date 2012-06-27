% ProcessSpike_B_Grating.m %

% Implement the Spike Computation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spike_count=zeros(1,(m-1)/3); % For Counting the number of spikes for each stimulus
firing_rate=zeros(nTrial,nStimuli); % spikes/sec
still_time=0.25;     % Custom stimulus still time(sec) before and after moving
s=length(find(spike));              % Refresh spike number for this spike sorting code


for j=1:nTrial
    for i=1:((m-1)/3)   
        if (((j-1)*nStimuli+1)<= i && i<=(j*nStimuli)) % confined to one Trial after another
        spike_count(i)=length(find(start_time(i)+still_time<spike & spike<end_time(i)-still_time));
        firing_rate(j,(floor((stimulus_code(i)*1000)/5)+1))=spike_count(i)/(stimulus_last(i)-2*still_time);   
        end
    end
end

clear spike_count;


mean_firing_rate=mean(firing_rate); % Mean firing rate for nStimuli
sd=std(firing_rate);                % Standard Deviation for nStimuli
se=sd/sqrt(nTrial);                 % Standard Error for nStimuli
spon=mean_firing_rate(1);           % Background spontaneous spike firing rate

clear firing_rate;



RealSti_fr=zeros(1,(nStimuli-1));             % For Real Stimuli firing rate
% Cauculate DI=1-(Rnpd-Rs/Rpd-Rs)
% Rpd is the Max respones, Rnpd is the Opposite Direction of Rpd, Rs is spon
% Only DI > 0.5 indicate there has significant Direction Selectivity
for i=1:(nStimuli-1)
    RealSti_fr(i)=mean_firing_rate(i+1);
end

Max_m_fr=max(RealSti_fr);  
Min_m_fr=min(RealSti_fr);

index=find(RealSti_fr==Max_m_fr);
PD=(360/(nStimuli-1))*(index-1);   % perfered direction

% Check if all RealSti_fr(i)==0,usually for spike_0
if (length(index)>1)
    index=1;
end

if (index>(nStimuli-1)/2)
    index=index-(nStimuli-1)/2;
else
    index=index+(nStimuli-1)/2;
end

DI=1-round(((RealSti_fr(index)-spon)/(Max_m_fr-spon))*100)/100;

clear mean_firing_rate;
clear index;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% organize data for plot
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data to export to xls file
info={para_struct.BatchList_DataDir para_struct.BatchList_MarkerName ...
      para_struct.BatchList_SnipName para_struct.BatchList_StiType ['SortCode_',int2str(z)]};
  
title_stata={'DI' 'PD' 'Max_m_fr' 'Min_m_fr' 'Spon' 'SpikeNum' };
stata=[DI PD Max_m_fr Min_m_fr spon s];

title_data={'deg' 'M_fr' 'se' 'Spon'};
data=[X' Y' Z' SPON'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save results data in *.xls file
warning off MATLAB:xlswrite:AddSheet
cd (deblank('E:\Experiment\Exported Data\Batch_Results'));
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],info,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)]);
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_stata,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A3');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],stata,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A4');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],title_data,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A6');
xlswrite(['Batch_',para_struct.BatchList_name,'.xls'],data,['Sheet',int2str(para_struct.DataIndex),'_S',int2str(z)],'A7');




