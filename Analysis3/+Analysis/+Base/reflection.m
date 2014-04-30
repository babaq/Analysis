function [ rm ] = reflection( xyz )
%REFLECTION Summary of this function goes here
%   Detailed explanation goes here

plane = find(xyz);
if length(plane) > 2
    error('Only One Plane Allowed.');
end

switch sum(plane)
    case 3 % xy plane
        rm = [ 1   0     0    0;
            0   1     0    0;
            0   0     -1   0;
            0   0     0    1 ];
    case 4 % xz plane
        rm = [ 1   0     0    0;
            0   -1     0    0;
            0   0     1   0;
            0   0     0    1 ];
    case 5 % yz plane
        rm = [ -1   0     0    0;
            0   1     0    0;
            0   0     1   0;
            0   0     0    1 ];
    otherwise
        error('Only XY, XZ, YZ Plane Allowed.');
end

end

