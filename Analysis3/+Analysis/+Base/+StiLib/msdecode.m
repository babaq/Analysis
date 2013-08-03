function [ dn ] = msdecode( tins, msbase )
%MSDECODE Decode time in second based on ms interval
%   Detailed explanation goes here

if nargin == 1
    msbase = 5;
end
dn = floor(tins*1000/msbase);

end

