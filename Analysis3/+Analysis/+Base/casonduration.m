function [ cas,win ] = casonduration( as,on,onshift,duration,fs,asstarttime )
%CASONDURATION Summary of this function goes here
%   Detailed explanation goes here

[cas,win] = Analysis.Base.cutas(as,on+onshift,on+onshift+duration,fs,asstarttime);
end

