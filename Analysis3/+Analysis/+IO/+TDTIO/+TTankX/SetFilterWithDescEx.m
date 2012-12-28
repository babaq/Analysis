function [ hr ] = SetFilterWithDescEx( TX, conditions )
%SETFILTERWITHDESCEX Sets multiple, logically related filters in a single string. If multiple calls are
%       made, then the last call will overwrite the previous filters. Different filter
%       characteristics can be logically chained together using ANDs and/or ORs to
%       achieve the desired filter
%input:
%  conditions string defining the filter, for example: ¡®Freq=4000 and Levl=2¡¯
%   Note: boolean operators ¡®and¡¯ and ¡®or¡¯ are allowed within
%   the filter string as well as standard filters, such as ¡®chan¡¯
%   and ¡®sort¡¯ are also allowed.
%   Also uses the following Global parameters: RespectOffsetEpoc

hr = TX.SetFilterWithDescEx(conditions);
if hr==0
    hr = false;
else
    hr = true;
end

