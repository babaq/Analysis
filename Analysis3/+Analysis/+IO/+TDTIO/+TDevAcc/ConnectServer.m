function [ hr ] = ConnectServer( TDAX ,servername)
%CONNECTSERVER Initiates a connection with an OpenWorkbench server
%   Detailed explanation goes here
if nargin < 2
    servername = 'Local';
end
hr = TDAX.ConnectServer(servername);
if hr==0
    hr = false;
else
    hr = true;
end

