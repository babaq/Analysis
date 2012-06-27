% ProcessSpike_GTCb.m %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


