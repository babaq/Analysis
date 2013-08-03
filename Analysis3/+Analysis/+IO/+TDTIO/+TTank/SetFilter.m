function [ nepoc ] = SetFilter( TTX,tankcode,testcode,v1,v2 )
%SETFILTER SetFilter is used to filter out events associated with specified epoch blocks. Once
%       a TestCode has been specified, Values V1 and V2 can be used to set boundaries
%       for filtering out epoch events
%   SetFilter can be used to filter events associated with specified epoch blocks and
%   can be made multiple times. Multiple calls to SetFilter are cumulative and are
%   logically ORed if applied to the same epoch or logically ANDed if applied
%   across different epochs. To reset all filters make a call to ResetFilters.
%input:
% tankcode  epoch event code as 4 bytes long, determined using
%           StringToEvCode or GetEventCodes
% testcode  a single value that sets the criteria value for the filter
%           letters shown correspond to their ASCII value
%           associated numbers for use with MATLAB are:
%           'E' 69  equal to
%           'N' 78  not equal to
%           'G' 71  greater than or equal
%           'L' 76  less than or equal
%           'A' 65  above, greater than
%           'B' 66  below, less than
%           'I' 73  include, between these values
%           'O' 79  outside of those values
% v1  primary value used in an equation
% v2  secondary value used an equation
%       The V2 value is used with "I" and "O" to define the range of the filter.
%output:
% nepoc  number of epoch blocks removed by filtering

nepoc = TTX.SetFilter(tankcode,testcode,v1,v2);
end

