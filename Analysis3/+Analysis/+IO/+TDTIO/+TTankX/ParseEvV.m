function [ data ] = ParseEvV( TX,recindex, nrecs )
%PARSEEVV used to retrieve waveform data, read using ReadEvents or ReadEventsV, from
%         TTankX's local cache.
%input:
%    nrecs   number of records to be retrieved. 0 or 1 to get a single row
%            of data for a single record
%output:
%    data  The variant form of the data is a matrix with the columns
%           being the waveform data and the rows being the indexed
%           records. If nRecs = 0 the waveform data is returned in a
%           row array.

data = TX.ParseEvV(recindex,nrecs);
end

