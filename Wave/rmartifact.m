function [w info] = rmartifact(w,xsd,tsd)
% rmartifact.m
% 2012-04-12 by Zhang Li
% Remove Wave Artifact

if nargin < 2
    xsd = 4;
end

if size(w,1)>1
    w = w';
end

wn = length(w);
mw = mean(w);
if isempty(tsd)
    sdw = std(w);
else
    sdw = tsd;
end
ai = find((w>mw+xsd*sdw) | (w<mw-xsd*sdw));

if isempty(ai)
    info.isartifact = 0;
else
    info.isartifact = 1;
    asi = artiseg(ai);
    
    for i=1:size(asi,1)
        tws = asi(i,1)-1:asi(i,2)+1;
        if tws(1)<1
            tws(1)=[];
            stws = mw;
        else
            stws = w(tws(1));
        end
        if tws(end)>wn
            tws(end)=[];
            etws = mw;
        else
            etws = w(tws(end));
        end
        
        w(tws) = interp1([1 length(tws)],[stws etws],1:length(tws),'linear');
        spn(i) = asi(i,2)-asi(i,1)+1;
    end
    
    info.asn = spn;
end
info.tsd = sdw;



    function ic = artiseg(ai)
        d = diff(ai);
        d(d>1)=0;
        d = [0 d 0];
        
        d = num2str(d);
        d(d==' ')=[];
        st = strfind(d,'01');
        ed = strfind(d,'10');
        sg = strfind(d,'00');
        ic1 = [];
        ic2 = [];
        
        for i=1:length(st)
            ic1(i,:) = [ai(st(i)) ai(ed(i))];
        end
        for i=1:length(sg)
            ic2(i,:) = [ai(sg(i)) ai(sg(i))];
        end
        ic = [ic1; ic2];
    end

end % eof
