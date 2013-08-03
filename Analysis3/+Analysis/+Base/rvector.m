function [ v,isrv ] = rvector( v )
%RVECTOR Summary of this function goes here
%   Detailed explanation goes here

isrv = isrow(v);
if ~isrv
    v = v';
end

end

