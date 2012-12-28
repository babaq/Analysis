function [ hr ] = ConnectServer( TX, servername, clientname )
%CONNECTSERVER Summary of this function goes here
%   Detailed explanation goes here
if nargin <2
    servername = 'Local';
    clientname = 'Matlab';
end
hr = TX.ConnectServer(servername,clientname);
if hr==0
    hr = false;
else
    hr = true;
end

