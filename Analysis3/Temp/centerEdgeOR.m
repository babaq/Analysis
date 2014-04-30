function [ tv ] = centerEdgeOR( v,trans,or )
%CENTEREDGEOR Summary of this function goes here
%   Detailed explanation goes here

vd = size(v,2);
v = Analysis.Base.to4dvector(v);
tm = Analysis.Base.translation(trans);
rm = Analysis.Base.rotationxyz([0 0 1],Analysis.Base.ang2rad(or));
tv = rm*tm*v';
tv = tv(1:vd,:)';

end

