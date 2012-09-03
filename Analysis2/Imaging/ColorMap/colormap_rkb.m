function map = colormap_rkb(n)
% colormap_rkb.m
% 2010-05-16 by Zhang Li
% Get Red_Black_Blue ColorMap of N Steps

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
        map(i,2) = 1; % saturation
        map(i,3) = 1-2*i/N; % brightness
    else % Red part
        map(i,1) = 0;
        map(i,2) = 1;
        map(i,3) = abs(1-2*i/N);
    end    
end

map = hsv2rgb(map);
