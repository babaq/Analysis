function [ v ] = rvector( v )
%RVECTOR Summary of this function goes here
%   Detailed explanation goes here

if iscolumn(v)
    v = v';
end

end

