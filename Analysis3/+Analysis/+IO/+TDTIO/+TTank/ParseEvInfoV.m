function [ data ] = ParseEvInfoV( TTX,recindex, nrecs, nitem )
%PARSEEVINFOV used to retrieve information, read using ReadEvents or ReadEventsV, from TTankX's
%             local cache. Any or all event information (but not waveform data) can be
%             retrieved with this call.
%input:
%   recindex  starting index, 0 based
%   nrecs     number of records to be retrieved.
%             The number specified is the number of rows returned. Use
%             0 to have data returned in a single dimensional array or as
%              a scalar. If RecIndex + nRecs exceeds the end of the
%              cached records, the extra rows will be returned with zeros.
%    nitem    item code,Use 0 to have all items returned as columns in the order
%              shown below or select one of the following:
%       1 size of waveform data in bytes
%       2 event type
%       3 event code
%       4 channel number
%        5 sorting number
%       6 time stamp
%       7 scalar value (valid when no waveform data is attached)
%        8 data format code
%       9 waveform sample rate in Hz (requires attached wavefrom data)
%       10 not used(returns 0)
%       11 X dimension filter ID
%       12 Y dimension filter ID
%       13 Z dimension filter ID
%       14 fill Item
%output:
%   data  The variant form of the data is a matrix with the columns
%        being the data item or items and rows being the indexed
%        records. The exact format of the returned data is
%        dependent on which arguments are passed as 0s.
%       The possible return scenarios are:
%       { nRecs > 0 and nItem > 0 } returns a row matrix
%       containing the requested value for nRecs records
%       { nRecs > 0 and nItem = 0 } returns a row/column matrix
%        with nRecs rows by 10 columns containing all the
%       information values
%       { nRecs = 0 and nItem > 0 } returns a single scalar with
%       the specified value for the specified record index
%       { nRecs = 0 and nItem = 0 } returns a row matrix
%       containing the 10 data items for the specified record index

data = TTX.ParseEvInfoV(recindex, nrecs, nitem );
end

