function [m se t] = fmean2(x)
% fmean2.m
% 2010-7-13 by Zhang Li
% Finite Matrix First Dim Mean and Standard Error without NaN and +/-Inf (2D X)

msize = size(x);
m = zeros(1,msize(2));
se = m;
t = m;
for i=1:msize(2)
    sx = squeeze(x(:,i));
    ivsxi = ~isfinite(sx);
    sx( ivsxi==1)=[];
    
    if ~isempty(sx)
        vt = length(sx);
        m(i) = mean(sx,1);
        se(i) = ste(sx);
        t(i) = vt;
    else
        m(i) = NaN;
        se(i) = NaN;
    end
end