function [ error ] = GetError( TX )
%GETERROR retrieves any pending error string or null if there is no error pending
%   Detailed explanation goes here

error = TX.GetError();
end

