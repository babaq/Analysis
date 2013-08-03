function [ capt,win ] = caponduration( aptimes,on,onshift,duration )
%CAPONDURATION Summary of this function goes here
%   Detailed explanation goes here

[capt,win] = Analysis.Base.cutaptimes(aptimes,on+onshift,on+onshift+duration);
end

