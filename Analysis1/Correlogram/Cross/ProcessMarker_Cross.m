% ProcessMarker_Cross.m %
% Process Marker according to the "Marker Encode Protocal"

disp('  Processing Marker ...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
marker=round(marker*10000);      % Convert Marker Time from "sec" to "0.1ms" 
m=length(marker);                % Get the total number of marker

if(mod((m-1),3)~=0)              % Check marker completion
    disp('                     Error !');
    disp('            Marker Structure Incomplete !');
    disp('Total Markers');
    disp(m);
    break;
end

encode_time=zeros(1,(m-1)/3);      % First Trigger of a Stimulus
start_time=zeros(1,(m-1)/3);       % Second Trigger of a Stimulus
end_time=zeros(1,(m-1)/3);         % Third Trigger of a Stimulus

for i=1:((m-1)/3)                  % Load each type of time
    encode_time(i)=marker(1+3*(i-1));
    start_time(i)=marker(2+3*(i-1));
    end_time(i)=marker(3+3*(i-1));
end

stimulus_code=start_time-encode_time;
stimulus_last=end_time-start_time;
stimulus_last_max=round(max(stimulus_last));  % Integer max time of stimulus last(0.1ms)

clear encode_time;
clear stimulus_last;

encode_max=max(stimulus_code);
nStimuli=floor(encode_max/50)+1;   % 0-5 ms for Blank Control ,ClockWise Stimuli
nTrial=((m-1)/3)/nStimuli;

clear encode_max;

if(floor(nTrial)~=nTrial)          % Check stimulus completion
    disp('                       Error !');
    disp('            Stimulus Structure Incomplete !');
    disp('Total Trials');
    disp(nTrial);
    break;
end

clear marker;

 %%%%%%%%%%%%%-----Marker Encode Protocal-----%%%%%%%%%%%%%%%%
 
 % M 1(encode_time)   M 2(start_time)    M 3(end_time)     % for a stimulus
 % M 4                M 5                M 6         % for another stimulus
 % ...                ...                M m-1        
 % M m       % end of marker
