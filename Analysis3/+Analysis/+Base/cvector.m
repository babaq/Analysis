function [ v ] = cvector( v )
%CVECTOR Summary of this function goes here
%   Detailed explanation goes here

if isrow(v)
    v = v';
end

end

