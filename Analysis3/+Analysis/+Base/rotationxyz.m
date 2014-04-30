function [ rm ] = rotationxyz( xyz,theta )
%ROTATIONXYZ Counter-clockwise rotation about x, y, z Axis
%   Detailed explanation goes here

axis = find(xyz);
if length(axis) > 1
    error('Only One Axis Allowed.');
end

cosv = cos(theta);
sinv = sin(theta);

switch axis
    case 1
        rm = [ 1   0     0    0;
            0  cosv -sinv  0;
            0  sinv cosv   0;
            0   0    0     1 ];
    case 2
        rm = [ cosv  0  sinv  0;
            0     1    0    0;
            -sinv  0  cosv   0;
            0     0    0    1 ];
    case 3
        rm = [ cosv -sinv 0  0;
            sinv cosv 0   0;
            0     0   1   0;
            0     0   0   1 ];
    otherwise
        error('Only X, Y, Z Axis Allowed.');
end

end

