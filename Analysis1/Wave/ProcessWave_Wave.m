% ProcessWave_Wave.m %

disp('  Processing Wave_Wave ...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wave_time=round(wave_time*1000);    % Convert Wave Time from "sec" to "ms"
% Sampling Frequency defines the number of datapoints in one second and for robust reason,
% we make the memory for datapoints larger by add 2*datapoint extra datapoints memory space
% waveform data unit is set to uV in TDT system 3
max_datapoint=round((stimulus_last_max/1000)*samplefreq+2*datapoint);

wave_nStimuli=zeros(nTrial,nStimuli,max_datapoint);

for j=1:nTrial
    for i=1:((m-1)/3)   
        if (((j-1)*nStimuli+1)<= i && i<=(j*nStimuli)) % confined to one Trial after another
            Index=find(start_time(i)<wave_time & wave_time<end_time(i)); 
            l=length(Index);
            code=floor(stimulus_code(i)/5)+1;
            for k=1:l
                wave_nStimuli(j,code,(1+(k-1)*datapoint):(datapoint*k))=wave_data(:,Index(k));
            end
        end
    end
end

clear wave_data;
clear wave_time;
wave=sum(wave_nStimuli,1);

clear wave_nStimuli;
