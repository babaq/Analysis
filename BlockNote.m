function Param = BlockNote(note,eventname)
% BlockNote.m
% 2011-03-17 Zhang Li
% Parse Parameters from TTank Block Note

% get event channal number, waveform sample number and samplingfreq
enote=findstr(note,['VALUE=',eventname]);
vnote=findstr(note,'VALUE=');
endnote=findstr(note,';');

a=find(vnote==enote(end));
b=find(endnote==(vnote(a+3)-1));
ch_n = str2double(note(vnote(a+3)+6:endnote(b+1)-1));
Param.chn = ch_n;

b = find(endnote==(vnote(a+8)-1));
Param.swn = str2double(note(vnote(a+8)+6:endnote(b+1)-1));

b=find(endnote==(vnote(a+10)-1));
Param.fs = str2double(note(vnote(a+10)+6:endnote(b+1)-1));