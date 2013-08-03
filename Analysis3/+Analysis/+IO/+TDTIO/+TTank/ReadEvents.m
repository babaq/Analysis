function [ nevent ] = ReadEvents( TTX, maxret,tankcode,channel,sortcode,t1,t2,options)
%READEVENTS Summary of this function goes here
%input:
%   maxret    maximum number of events to be returned
%   tankcode  name of event in integer format
%   channel   0 for all channels
%   sortcode  0 to disregard sort codes
%   t1        events >= t1, t1=0 to read from start
%   t2        events < t2,  t2=0 to read until end
%   options   GET_ALL    0x0000   read all event
%             GET_NEW    0x0001   continue to read from last position
%             GET_SAME   0x0002   limit to the same access bounds as previous read
%             GET_JUSTTIMES  0x0100  return only event time stamps as floats
%             GET_DOUBLES 0x0200  same as above but as doubles
%             GET_NODATA  0x0400  casue any attached waveform data NOT returned
%             GET_FILTERED 0x1000 filter returned records based on the specified filters
%             GET_ORDERED 0x2000  not yet implemented
%             All values are bit masks so options can be used together. For
%             example, GET_JUSTTIMES + GET_DOUBLES
%output:
%   nevent   number of events cached to TTankX local buffer
nevent = TTX.ReadEvents(maxret,tankcode,channel,sortcode,t1,t2,options);
end

