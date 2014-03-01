function [ x ] = trystr2double( x )
%TRYSTR2DOUBLE Summary of this function goes here
%   Detailed explanation goes here

t = str2double(x);
if nnz(isnan(t))==0
    x = t;
end
end

