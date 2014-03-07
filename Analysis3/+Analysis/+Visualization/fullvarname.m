function [ var ] = fullvarname( var )
%FULLVARNAME Summary of this function goes here
%   Detailed explanation goes here

switch var
    case {'OR','OR2'}
        var = 'Orientation';
    case 'WID'
        var = 'Width';
    case 'LEN'
        var = 'Length';
    case 'COL'
        var = 'Color';
    case {'POSX','POSY'}
        var = 'Position';
end

end

