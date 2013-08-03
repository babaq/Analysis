function [ fr ] = ifr( st,range,bw )
%IFR Summary of this function goes here
%   Detailed explanation goes here

fr = Analysis.Base.binst(st,range,bw)/bw;
end

