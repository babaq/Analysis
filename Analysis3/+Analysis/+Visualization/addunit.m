function [ var, unit ] = addunit( var )
%ADDUNIT Summary of this function goes here
%   Detailed explanation goes here

switch var
    case 'Orientation'
        unit = 'Deg';
    case {'Width','Length','Position'}
        unit = 'Arcmin';
    otherwise
        unit = '';
end
if ~isempty(unit)
    unit = [' (',unit,')'];
end
var = [var,unit];

end

