% ProcessSpike_Cross.m %

disp('  Processing Spike_Cross ...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spike1=round(spike1*10000);   % Convert Spike1 Time from "sec" to "0.1ms"
spike2=round(spike2*10000);   % Convert Spike2 Time from "sec" to "0.1ms"
% Because the Absolute Refresh Period(>=1ms), the Max FiringRate of a neuron should be less than 1000 Spikes/sec
% But according to experience ,the max mean firingrate of a Recording is about 200 Spikes/sec(0.02 Spikes/0.1ms)
max_spike_count=round(0.02*stimulus_last_max);
clear stimulus_last_max;

spike_time1=zeros(nTrial,nStimuli,max_spike_count);
spike_time2=zeros(nTrial,nStimuli,max_spike_count);
clear max_spike_count;

for j=1:nTrial
    for i=1:((m-1)/3)   
        if (((j-1)*nStimuli+1)<= i && i<=(j*nStimuli)) % confined to one Trial after another
            Index1=find(start_time(i)<spike1 & spike1<end_time(i));
            Index2=find(start_time(i)<spike2 & spike2<end_time(i));
            l1=length(Index1);
            l2=length(Index2);
            code=floor(stimulus_code(i)/50)+1;  
            for k=1:l1
                spike_time1(j,code,k)=spike1(Index1(k));
            end 
            
            for k=1:l2
                spike_time2(j,code,k)=spike2(Index2(k));
            end 
        end
    end
end

clear spike1;
clear spike2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate Cross Correlation Function according to
% "GEORGE L. GERSTEIN and NELSON Y.-S. KIANG,BIOPHYSICAL JOURNAL VOLUME 1 1960"

% Time course of each lag direction set to N(0.1ms)
N=2500;
% For single trial Dirac function value
Dirac=zeros(nTrial,(2*N+1),nStimuli);

hsWaitBar=waitbar(0,'Calculating Cross-Correlation Function ...');

for j=1:nTrial
    for i=1:nStimuli
        s1=length(find(spike_time1(j,i,:)));
        s2=length(find(spike_time2(j,i,:)));
        for p=1:s1
            for q=1:s2
                for l=-N:N
                    Dirac(j,(1+N-(-1)*l),i)=Dirac(j,(1+N-(-1)*l),i)+((spike_time1(j,i,p)-spike_time2(j,i,q)-l)==0);   % Same as the area of Dirac Delta Function
                end
            end
        end
    end
    waitbar(j/nTrial,hsWaitBar);
end

clear spike_time1;
clear spike_time2;

cumsum_Dirac=cumsum(sum(Dirac,1),2); % Cumulative sum of sum of Dirac on nTrial
clear Dirac;

binwidth=10;  % Bin width set to 1ms(10*0.1ms) by default
bin_number=floor((2*N+1)/binwidth);
% for Trial-summed Dirac value added together in the given binwidth for each Stimuli
bin_Dirac=zeros(bin_number,nStimuli); 

% bin_Dirac(1+N/binwidth,j) is the sum of Dirac from 0-1ms(1ms last) lags 
% and actually represent Correlation at 0ms lag bintime
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
