function [ array ] = num2bitnnumarray( n,num,m,endianness )
%NUM2BITNNUMARRAY Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
    endianness = 'big';
end
if m*n<=32
    maxbits = 32;
else
    maxbits = 64;
end

bits = bitget(num,maxbits:-1:1);
bits = bits(end-m*n+1:end);
bits = reshape(bits,n,m)';

array = zeros(1,m);
for i = 1:m
    switch endianness
        case 'little'
            idx = m-(i-1);
        case 'big'
            idx = i;
        otherwise
            error('need correct endianness: little/big');
    end
    bstring = regexprep(num2str(bits(idx,:)),'\s*','');
    array(i) = bin2dec(bstring);
end

end

