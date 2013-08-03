function [ capt,win ] = caponoff( aptimes,onoff,onoffshift )
%CAPONOFF Summary of this function goes here
%   Detailed explanation goes here

[capt,win ]= Analysis.Base.cutaptimes(aptimes,onoff(1)+onoffshift(1),onoff(2)+onoffshift(2));
end

