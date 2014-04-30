function [ tm ] = translation( trans )
%TRANSLATION Summary of this function goes here
%   Detailed explanation goes here

tm = [ 1 0 0 trans(1);
    0 1 0 trans(2);
    0 0 1 trans(3);
    0 0 0    1 ];

end

