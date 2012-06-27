% ProcessMarker_RandomLine.m %

% Process Markers according to the "Marker Encode Protocal" %
disp('  Processing Marker ...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=length(marker);     % Get the number of marker Triggers time(sec)
if(mod((m-1),3)~=0)     % Check marker completion
    disp('                     Error !');
    disp('            Marker Structure Incomplete !');
    disp('Total Markers');
    disp(m);
    break;
end

encode_time=zeros(1,(m-1)/3);  % First Trigger of a Stimulus
start_time=zeros(1,(m-1)/3);   % Second Trigger of a Stimulus
end_time=zeros(1,(m-1)/3);     % Third Trigger of a Stimulus


for i=1:((m-1)/3)        % Load each type of time
    encode_time(i)=marker(1+3*(i-1));
    start_time(i)=marker(2+3*(i-1));
    end_time(i)=marker(3+3*(i-1));
end

stimulus_code=start_time-encode_time;
stimulus_last=end_time-start_time;

clear encode_time;

encode_max=max(stimulus_code);
nStimuli=floor((encode_max*1000)/5)+1; % 0-5 ms for Blank Control ,ClockWise Stimuli
nTrial=((m-1)/3)/nStimuli;


if(floor(nTrial)~=nTrial)     % Check stimulus completion
    disp('                       Error !');
    disp('            Stimulus Structure Incomplete !');
    disp('Total Trials');
    disp(nTrial);
    break;
end

clear marker;

 %%%%%%%%%%%%%-----Marker Encode Protocal-----%%%%%%%%%%%%%%%%
 
 %M 1(encode_time)   M 2(start_time)    M 3(end_time)     % for a stimulus
 %M 4                M 5                M 6         % for another stimulus
 %...                ...                M n-1        
 %M n         % end of marker
 
 