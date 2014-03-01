function [ rfigidx ] = rewardfig( df,figtype,rn )
%REWARDFIG Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    rn = 1;
end

fidx = find(df==figtype);
rs = Analysis.Base.randseq(1,length(fidx),'shuffle');
rfigidx = zeros(size(df));
rfigidx(fidx(rs(1:rn)))=1;

end

