function Is = ITC(x)
%   Is = ITC(x)
%   Computes the information tuning curve of neural signal.
%   2008-11-28 Zhang Li

nsti = size(x,2);
Is = zeros(1,nsti);
[pr,event_r] = nsdist(x);

for i=1:nsti
    [prs,event_rs] = nsdist(x,i);
    
    is = 0;
    for j=1:numel(event_rs)
        is = is + prs(j)*log2(prs(j)/pr(event_rs(j)==event_r));
    end
    Is(1,i) = is;
end