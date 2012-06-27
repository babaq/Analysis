function CWave = TTWave(TTX,ActEvent,Options)
% TTWave.m
% 2011-03-17 Zhang Li
% Read Wave Event from TTank ActiveX Control

% get current event channal number, waveform sample number and samplingfreq from block note
note = TTX.CurBlockNotes;
CWave = BlockNote(note,ActEvent);
ch_n = CWave.chn;

%____________________Reading Waveforms Data_____________________%

%     hWaitBar=waitbar(0,'Reading All Channal Wave ...');
for i=1:ch_n
    
    TTX.ResetFilters;
    TTX.SetFilterWithDescEx(['CHAN=',num2str(i)]);
    
    seg_n=TTX.ReadEventsV(10000000,ActEvent, i, 0, 0.0, 0.0,'Filtered');
    temp = TTX.ParseEvV(0, seg_n);
    CWave.wave{i}.wave = reshape(temp,1,[]);

    %              waitbar(i/ch_n,hWaitBar);
    
end

CWave.wvevent = ActEvent;
CWave.ontime = TTX.ParseEvInfoV(0, 1, 6);
CWave = rmfield(CWave,'swn');
