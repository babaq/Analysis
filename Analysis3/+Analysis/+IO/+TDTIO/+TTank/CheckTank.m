function [ hr ] = CheckTank( TTX, tankname )
%CHECKTANK Summary of this function goes here
%   Detailed explanation goes here

hr = TTX.CheckTank(tankname);
if hr==67
    hr = 'closed';
end
if hr==79
    hr = 'open';
end
if hr==82
    hr = 'record';
end

