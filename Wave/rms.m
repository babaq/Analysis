function y = rms(x,dim)
%   y = rms(x,dim)
%   Computes the Root Mean Square.
%
%   For vectors, RMS(X) is the rms of the elements in X. For
%   matrices, RMS(X) is a row vector containing the rms of
%   each column. For N-D arrays, RMS(X) is the rms of the
%   elements along the first non-singleton dimension of X.
%
%   RMS(X,DIM) takes the rms along the dimension DIM of X.
%
%   2008-10-13  Zhang Li


x = x.^2;
if nargin==1
    z = mean(x);
else
    z = mean(x,dim);
end
y = z.^0.5;

end %EOF