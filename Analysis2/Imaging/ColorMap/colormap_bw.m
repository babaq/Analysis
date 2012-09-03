function map = colormap_bw(n)
% colormap_bw.m
% 2009-01-07 by Zhang Li
% Get Blue_White ColorMap of N Steps

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
    map(i,1) = 0.6; % hue
    map(i,2) = i/N; % saturation
    map(i,3) = 1; % brightness
end

map = hsv2rgb(map);
