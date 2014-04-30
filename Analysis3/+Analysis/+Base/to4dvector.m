function [ pv ] = to4dvector( v )
%TO4DVECTOR Summary of this function goes here
%   Detailed explanation goes here

vd = size(v,2);
vn = size(v,1);
if vd == 1
    pn = 3;
elseif vd == 2
    pn = 2;
elseif vd == 3
    pn = 1;
end

pending = zeros(vn,pn);
pending(:,end) = 1;
pv = [v pending];
end

