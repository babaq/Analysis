function map = colormap_fi(n)
% colormap_fi.m
% 2009-08-05 Revised from Joseph Kirk(jdkirk630@gmail.com)
% Get LightCyan-Cyan-Blue-Black-Red-Yellow-LightYellow Colormap

% Default Colormap Size
if ~nargin
    n = 64;
end

% LightCyan-Cyan-Blue-Black-Red-Yellow-LightYellow
cl = [0.75 1 1; 0 1 1; 0 0 1;...
    0 0 0; 1 0 0; 1 1 0; 1 1 0.75];

y = -3:3;
if mod(n,2)
    delta = min(1,6/(n-1));
    half = (n-1)/2;
    yi = delta*(-half:half)';
else
    delta = min(1,6/n);
    half = n/2;
    yi = delta*nonzeros(-half:half);
end
map = interp2(1:3,y,cl,1:3,yi);

