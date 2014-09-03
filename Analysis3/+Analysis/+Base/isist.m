function [ isi ] = isist( st )
%ISIST Summary of this function goes here
%   Detailed explanation goes here

st = sort(st);
isi = diff(st);
end

