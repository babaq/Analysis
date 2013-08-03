function [ v, iscv] = cvector( v )
%CVECTOR Summary of this function goes here
%   Detailed explanation goes here

iscv = iscolumn(v);
if ~iscv
    v = v';
end

end

