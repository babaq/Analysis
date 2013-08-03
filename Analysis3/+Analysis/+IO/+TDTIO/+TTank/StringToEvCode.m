function [ eventcode ] = StringToEvCode( TTX,evcode )
%STRINGTOEVCODE converts a four character string to its corresponding event code
%               in long format. This call is used to obtain epoch codes required for SetFilter
%   Detailed explanation goes here

eventcode = TTX.StringToEvCode(evcode);
end

