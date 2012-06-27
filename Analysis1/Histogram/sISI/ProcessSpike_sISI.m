% ProcessSpike_sISI.m %

disp('  Processing Spike_sISI ...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spike=round(spike*10000);   % Convert Spike Time from "sec" to "0.1ms"
% Because the Absolute Refresh Period(>=1ms), the Max FiringRate of a neuron should be less than 1000 Spikes/sec
% But according to experience ,the max mean firingrate of a Recording is about 200 Spikes/sec(0.02 Spikes/0.1ms)
max_spike_count=round(0.02*stimulus_last_max);

spike_time=zeros(nTrial,nStimuli,max_spike_count);
clear max_spike_count;

for j=1:nTrial
    for i=1:((m-1)/3)   
        if (((j-1)*nStimuli+1)<= i && i<=(j*nStimuli)) % confined to one Trial after another
            Index=find(start_time(i)<spike & spike<end_time(i));    
            l=length(Index);
            code=floor(stimulus_code(i)/50)+1;  
            for k=1:l
                spike_time(j,code,k)=spike(Index(k));
            end 
        end
    end
end

clear spike;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate Successive ISI for nStimuli according to 
% "GEORGE L. GERSTEIN and NELSON Y.-S. KIANG,BIOPHYSICAL JOURNAL VOLUME 1 1960"

% For single trial Dirac function value,Total time course is stimulus_last_max
Dirac=zeros(nTrial,(stimulus_last_max+1),nStimuli);  

ISI_count_each=zeros(nTrial,nStimuli);  % sum of ISIs of nStimuli in each Trial

hsWaitBar=waitbar(0,'Processing Spikes sISI ...');

for j=1:nTrial       
    for i=1:nStimuli
        s=length(find(spike_time(j,i,:)));
        ISI_count_each(j,i)=s-1;
        for k=2:s
            for l=0:stimulus_last_max
                Dirac(j,(l+1),i)=Dirac(j,(l+1),i)+((spike_time(j,i,k)-spike_time(j,i,(k-1))-l)==0);  % Same as the area of Dirac Delta Function
            end
        end
    end
    waitbar(j/nTrial,hsWaitBar);
end

clear spike_time;

cumsum_Dirac=cumsum(sum(Dirac,1),2);  % Cumulative sum of sum of Dirac on nTrial
ISI_count=sum(ISI_count_each,1);      % sum of sISIs in nTrial
clear Dirac;
clear ISI_count_each;

binwidth=10;  % Bin width set to 1ms(10*0.1ms) by default
bin_number=floor(stimulus_last_max/binwidth);
% for Trial-summed Dirac value added together in the given binwidth for each Stimuli
bin_Dirac=zeros(bin_number,nStimuli);

% Define bin time Ti={T|ti<T<ti+1},binwidth=(ti+1)-(ti)
for j=1:nStimuli
    for i=1:bin_number
        if (i==1)
            bin_Dirac(i,j)=cumsum_Dirac(1,binwidth*i,j);   
        else
            bin_Dirac(i,j)=cumsum_Dirac(1,binwidth*i,j)-cumsum_Dirac(1,binwidth*(i-1),j);
        end
    end
end

clear cumsum_Dirac;
close(hsWaitBar);
