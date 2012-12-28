function [ hr ] = CheckTank( TX, tankname )
%CHECKTANK Summary of this function goes here
%   Detailed explanation goes here

hr = TX.CheckTank(tankname);
if hr==67
    hr = 'closed';
end
if hr==79
    hr = 'open';
end
if hr==82
    hr = 'record';
end

