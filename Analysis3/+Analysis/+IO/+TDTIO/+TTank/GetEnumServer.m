function [ servername ] = GetEnumServer( TTX,idx )
%GETENUMSERVER returns servers that are enumerated (registered) on your
%               computer. 0 is returned when no more servers are found
%input:
%    idx   index of enumerated server, 0 based
%   Detailed explanation goes here

servername = TTX.GetEnumServer(idx);
end

