function [ hr ] = ParseEv( TTX,recindex, timestamp, channel, sortcode, npts, pdata )
%PARSEEV retrieve some or all information for event records cached
%        in local memory by a call to ReadEvents or ReadEventsV. 
%input:
%    recindex   index of record to retrieve, 0 based, return 0 when
%               recindex is beyond the end
%    timestamp   pointer to double array,0 to avoid return
%    channel   pointer to integer, 0 to avoid return
%    sortcode  pointer to integer,0 to avoid return
%    npts    pointer to integer to store the npts in any attached waveform
%             data, 0 to avoid return
%    pdata   pointer to a memory buffer to store the raw waveform

hr = TTX.ParseEv(recindex, timestamp, channel, sortcode, npts, pdata);
if hr==0
    hr = false;
else
    hr = true;
end

