function [ f0,f1 ] = f0f1( x )
%F0F1 Summary of this function goes here
%   Detailed explanation goes here

n = length(x);
y = abs(fft(x))/n;
f0 = y(1);
f1 = y(2)*2;
end

