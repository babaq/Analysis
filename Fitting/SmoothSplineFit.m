function [curvefit,goodness,fitinfo]=SmoothSplineFit(x,y)
% SmoothSplineFit.m %
% 2011-10-29 Zhang Li
% Generate Smooth Spline Fit Function for Stimulus Tuning Curve

if size(x,2)>size(x,1)
    x = x';
end
if size(y,2)>size(y,1)
    y = y';
end

ftype = fittype('smoothingspline');

[curvefit,goodness,fitinfo]=fit(x,y,ftype);


