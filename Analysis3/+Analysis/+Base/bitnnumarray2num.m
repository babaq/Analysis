function [ num,numarray ] = bitnnumarray2num( n,array,endianness )
%BITNNUMARRAY2NUM Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    endianness = 'big';
end
bitnrange =[0 2^n-1];
if max(array)>bitnrange(2) || min(array) < bitnrange(1)
    error(['array exceed the range of bit ',num2str(n),' encoding: ',num2str(bitnrange(1)),' - ',num2str(bitnrange(2))]);
end

numarray = array;
m = length(array);
if n*m>64
    error('Encoding bits exceed maximum bits of a number(64).');
end
for i=1:m
    switch endianness
        case 'little'
            t = i-1;
            idx = m-t;
        case 'big'
            t = m-i;
            idx = i;
        otherwise
            error('need correct endianness: little/big.');
    end
    numarray(idx) = 2^(t*n)*array(i);
end

num = sum(numarray);

disp([endianness,'-endian encoding done in ',num2str(m*n),' bits.']);
end
