function [ sm ] = scale( xyzs )
%SCALE Summary of this function goes here
%   Detailed explanation goes here

sm = [ xyzs(1) 0     0     0;
    0     xyzs(2) 0     0;
    0        0  xyzs(3) 0;
    0        0    0     1 ];

end

