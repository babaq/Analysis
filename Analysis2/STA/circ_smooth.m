function sa = circ_smooth(a,span)
% circ_smooth.m
% 2011-03-27 by Zhang Li
% Smooth Circular Data using Moving Average

if size(a,2)>size(a,1)
    a=a';
end
if nargin < 2
    span = 5;
end
l = length(a);
sa = a;
if mod(span,2)==0
    span = span + 1;
end
edgen = (span-1)/2;


for i = 2:edgen
    t = a(1:i+i-1);
    sa(i) = circ_mean(t);
end
for i = edgen+1:l-edgen
    t = a(i-edgen:i+edgen);
    sa(i) = circ_mean(t);
end
for i = l-edgen+1:l-1
    t = a(i-(l-i):l);
    sa(i) = circ_mean(t);
end