function [ capt,win ] = capoffduration( aptimes,off,offshift,duration )
%CAPOFFDURATION Summary of this function goes here
%   Detailed explanation goes here

[capt,win] = Analysis.Base.cutaptimes(aptimes,off+offshift-duration,off+offshift);
end

