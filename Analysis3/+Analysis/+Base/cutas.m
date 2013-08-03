function [ cas,win ] = cutas( as,starttime,endtime,fs,asstarttime )
%CUTAS Summary of this function goes here
%   Detailed explanation goes here

startidx = ceil((starttime-asstarttime)*fs);
endidx = ceil((endtime-asstarttime)*fs);
cas = as(startidx:endidx);
win = [starttime endtime];
end

