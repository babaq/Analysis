function [ cas,win ] = casonoff( as,onoff,onoffshift,fs,asstarttime )
%CASONOFF Summary of this function goes here
%   Detailed explanation goes here

[cas,win ]= Analysis.Base.cutas(as,onoff(1)+onoffshift(1),onoff(2)+onoffshift(2),fs,asstarttime);
end

