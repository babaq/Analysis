function [curvefit,goodness,fitinfo]=OriFit(x,y,model,varargin)
% OriFit.m %
% 2012-03-29 Zhang Li
% Generate Fit Function for Orientation Tuning Curve

if size(x,2)>size(x,1)
    x = x';
end
if size(y,2)>size(y,1)
    y = y';
end
if nargin <3
    model = 'gau';
end
meany = mean(y);
stdy = std(y);
maxy = max(y);
miny = min(y);

maxind = find(y==maxy);
outliers = [];
% if maxind==1
%     outliers = excludedata(x,y,'indices',maxind);
% else
%     outliers = [];
% end

start = [meany        0    10    0];
low =   [0          -180    5    0];
up =    [maxy+stdy   180   180  maxy];
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
    case 'gau' % --- Gaussian Model
        ftype = fittype('k*exp((-(x-u)^2)/(2*(c^2)))+b',...
            'dependent',{'y'},'independent',{'x'},...
            'coefficients',{'k', 'u', 'c', 'b'});
end


[curvefit,goodness,fitinfo]=fit(x,y,ftype,fitopt);


