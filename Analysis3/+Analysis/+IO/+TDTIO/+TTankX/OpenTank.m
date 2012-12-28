function [ hr ] = OpenTank( TX,tankname,accessmode )
%OPENTANK Summary of this function goes here
%   AccessMode    'R'   'W'   'C'     'M'
%                read  write control monitor  
 
hr = TX.OpenTank(tankname,accessmode);
if hr==0
    hr = false;
else
    hr = true;
end

