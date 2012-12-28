function [ nevent ] = ReadEventV(  TX, maxret,tankcode,channel,sortcode,t1,t2,options )
%READEVENTV same as ReadEvents except the EventCode and Options parameters
%are specified as strings.
%input:
%   maxret    maximum number of events to be returned
%   tankcode  name of event in 4 character string format.
%               Note: there is no error checking for valid TankCodes;
%              incorrectly typed (TankCode is case sensitive) or
%               nonexistent codes will return NaN or -1.
%   channel   0 for all channels
%   sortcode  0 to disregard sort codes
%   t1        events >= t1, t1=0 to read from start
%   t2        events < t2,  t2=0 to read until end
%   options   The Options parameter is similar to the Options parameter
%             for ReadEvents except that options here are specified
%             using a list of comma separated strings.
%             "ALL  GET_ALL
%             "NEW" GET_NEW
%             "SAME" GET_SAME
%             "JUSTTIMES" GET_JUSTTIMES 
%             "DOUBLES" GET_DOUBLES 
%             "NODATA" GET_NODATA 
%             "FILTERED" GET_FILTERED
%             "ORDERED" GET_ORDERED
%             Options can be combined in a comma separated list like:
%             "JUSTTIMES,DOUBLES".
%output:
%   nevent   number of events cached to TTankX local buffer

nevent = TX.ReadEvents(maxret,tankcode,channel,sortcode,t1,t2,options);
end

