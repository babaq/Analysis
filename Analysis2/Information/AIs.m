function ais = AIs(r,s)
%   ais = AIs(r,s)
%   Computes the average information of all stimulus conditions.
%
%   Input:
%     r       neural signal[Trial,nStimuli]
%     s       stimulus signal[Trial,nStimuli]
%
%   Output:
%     ais     average information
%
%   2008-11-29 Zhang Li


Is = ITC(r);
ps = nsdist(s);
nsti = numel(ps);

ais=0;
for i=1:nsti
    ais = ais + ps(i)*Is(i);
end