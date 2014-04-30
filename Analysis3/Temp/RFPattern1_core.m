function [ dots,dotrfidx ] = RFPattern1_core( rf,origin, or, repn,fixstart )
%RFPATTERN1_CORE Summary of this function goes here
%   Detailed explanation goes here

if nargin < 5
    fixstart = zeros(size(rf));
end

origin = Analysis.Base.arraypending(origin,repn,1);
dots = zeros(repn+1,size(rf,2));
dots(1,:) = fixstart;

for i=1:repn
    fc = centerEdgeOR(dots(i+1,:),origin(i,:),or);
    dots(i+1,:) = dots(i,:) + rf + fc;
end
dotrfidx = (1:repn+1)'+1;
dotrfidx(end) = 0;
end

