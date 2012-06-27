% ProcessSpike_Event.m %

disp('  Processing Spike_Event ...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spike=round(spike*1000);   % Convert Spike Time from "sec" to "ms"
% Because the Absolute Refresh Period(>=1ms), the Max FiringRate of a neuron should be less than 1000 Spikes/sec
% But according to experience ,the max mean firingrate of a Recording is about 200 Spikes/sec(0.2 Spikes/ms)
max_spike_count=round(0.2*stimulus_last_max);

spike_time=zeros(nTrial,nStimuli,max_spike_count);

for j=1:nTrial
    for i=1:((m-1)/3)   
        if (((j-1)*nStimuli+1)<= i && i<=(j*nStimuli)) % confined to one Trial after another
            Index=find(start_time(i)<spike & spike<end_time(i));    
            l=length(Index);
            code=floor((stimulus_code(i))/5)+1;  
            for k=1:l
                spike_time(j,code,k)=spike(Index(k))-start_time(i);
            end 
        end
    end
end

% save each sort spike of each data 
S{rt,z+1}=spike_time;
