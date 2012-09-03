function map = colormap_rw(n)
% colormap_rw.m
% 2009-01-07 by Zhang Li
% Get Red_White ColorMap of N Steps

if nargin<1
    N = 64;
    map = zeros(N,3);
else
    if n<2
        N=2;
    else
        N=n;
    end
    map = zeros(N,3);
end

for i=1:N
    map(i,1) = 0;
    map(i,2) = i/N;
    map(i,3) = 1;
end

map = hsv2rgb(map);
