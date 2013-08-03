function [ cas,win ] = casoffduration( as,off,offshift,duration,fs,asstarttime )
%CASOFFDURATION Summary of this function goes here
%   Detailed explanation goes here

[cas,win] = Analysis.Base.cutaptimes(as,off+offshift-duration,off+offshift,fs,asstarttime);
end

