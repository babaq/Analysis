function map = colormap_rwb(n)
% colormap_rwb.m
% 2009-01-07 by Zhang Li
% Get Red_White_Blue ColorMap of N Steps

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
    if i < (N+1)/2  % Blue part
        map(i,1) = 0.6; % hue
        map(i,2) = 1-2*i/N; % saturation
        map(i,3) = 1; % brightness
    else % Red part
        map(i,1) = 0;
        map(i,2) = abs(1-2*i/N);
        map(i,3) = 1;
    end    
end

map = hsv2rgb(map);
