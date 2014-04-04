function [ rfigidx ] = rewardfig( dotfigtype,rfigtype,rn )
%REWARDFIG Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    rn = 1;
end

rftidx = find(dotfigtype==rfigtype);
if isempty(rftidx)
    error('No Reward Figure Type in Figure Array.');
end
rs = Analysis.Base.randseq(1,length(rftidx),'shuffle');
rfigidx = zeros(size(dotfigtype));
rfigidx(rftidx(rs(1:rn)))=1;

end

