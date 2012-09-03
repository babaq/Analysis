function [curvefit,goodness,fitinfo]=SizeTuningFit(x,y,model,varargin)
% SizeTuningFit.m %
% 2011-03-29 Zhang Li
% Generate Fit Function for Size Tuning Curve using DoG, RoG or DoGI Model

if size(x,2)>size(x,1)
    x = x';
end
if size(y,2)>size(y,1)
    y = y';
end
meany = mean(y);
stdy = std(y);
maxy = max(y);
miny = min(y);
[si s_max s_min] = SI(y,x);

maxind = find(y==maxy);
if maxind==1
    outliers = excludedata(x,y,'indices',maxind);
    k0 = miny;
else
    outliers = [];
    k0 = y(1);
end

start = [k0 maxy (maxy-y(1))*si s_max s_min];
low = [0 meany 0 0.5 0.5];
up = [maxy maxy+3*stdy maxy+3*stdy 2*x(end) 2*x(end)];
if ~isempty(varargin)
    vn = length(varargin);
    if vn<2
        start = varargin{1};
    elseif vn <3
        start = varargin{1};
        low = varargin{2};
    else
        start = varargin{1};
        low = varargin{2};
        up = varargin{3};
    end
end
fitopt = fitoptions('Method','NonlinearLeastSquares','Robust','Bisquare',...
    'Algorithm','Trust-Region','Lower',low,'Upper',up,'Startpoint',start,...
    'DiffMaxChange',60,'MaxFunEvals',32000,'MaxIter',30000,'TolFun',10e-8,...
    'TolX',10e-8,'Exclude',outliers);

switch lower(model)
    case 'dogi' % --- DoGI Model
        ftype = fittype('ke*(erf(x/re))^2-ki*(erf(x/ri))^2+k0',...
            'dependent',{'y'},'independent',{'x'},...
            'coefficients',{'k0', 'ke', 'ki', 're', 'ri'});
    case 'rog' % --- RoG Model
        ftype = fittype('ke*(erf(x/re))^2/(1+ki*(erf(x/ri))^2)+k0',...
            'dependent',{'y'},'independent',{'x'},...
            'coefficients',{'k0', 'ke', 'ki', 're', 'ri'});
    case 'dog' % --- DoG Model
        ftype = fittype('ke*(1-exp(-(2*x/re)^2))-ki*(1-exp(-(2*x/ri)^2))+k0',...
            'dependent',{'y'},'independent',{'x'},...
            'coefficients',{'k0', 'ke', 'ki', 're', 'ri'});
end


[curvefit,goodness,fitinfo]=fit(x,y,ftype,fitopt);


