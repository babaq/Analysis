function H = entropy(x)
%   H = entropy(x)
%   Computes the entropy of signal.
%
%   Input:
%     x         signal[Trial,nStimuli]
%
%   2008-11-29 Zhang Li

px = nsdist(x);
nx = numel(px);
H=0;

for i=1:nx
    H = H - px(i)*log2(px(i));
end
    