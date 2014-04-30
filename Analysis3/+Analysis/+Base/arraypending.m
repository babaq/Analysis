function [ x ] = arraypending( x,pn,dim )
%ARRAYPENDING Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    dim = 1;
end

xn = size(x,dim);
pvidx = regexprep(num2str(size(x)),{'\s*','\d*'},{',',':'});

if xn < pn
    pvidx = regexprep(pvidx,'[:0-9]*',num2str(xn),dim);
    eval(['pv = x(',pvidx,');']);
    for i=1:pn-xn
        x = cat(dim,x,pv);
    end
elseif xn > pn
    pvidx = regexprep(pvidx,'[:0-9]*',['1:',num2str(pn)],dim);
    eval(['x = x(',pvidx,');']);
end

end

