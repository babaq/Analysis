function [ evinfo ] = BNEvInfo( notes, evname )
%BNEVINFO Parse Event Parameters from TTank Block Notes
%   Detailed explanation goes here

ed = strfind(notes,'[');
enote=strfind(notes,['VALUE=',evname]);
enote = enote(1);
tnstart = ed(ed<enote);
tnstart = tnstart(end);
tnend = ed(ed>enote);
tnend = tnend(1)-1;
tn = notes(tnstart:tnend);
evinfo.note = tn;

nidx = strfind(tn,'NAME=');
nidx = nidx + 5;
tidx = strfind(tn,'TYPE=');
tidx = tidx + 5;
vidx = strfind(tn,'VALUE=');
vidx = vidx + 6;
endidx = strfind(tn,';');
endidx = endidx - 1;
nend = endidx(1:3:end);
tend = endidx(2:3:end);
vend = endidx(3:3:end);

for i = 1:length(nend)
    value = tn(vidx(i):vend(i));
    switch tn(tidx(i):tend(i))
        case 'L'        
            value = str2double(value);        
    end
    evinfo.(tn(nidx(i):nend(i))) = value;
end

end

