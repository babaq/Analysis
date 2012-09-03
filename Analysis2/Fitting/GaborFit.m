function [curve_fit,goodness,fit_info]=GaborFit(X,Y,upper_amp,upper_t,f)
% GaborFit.m %
% 2007-08-25  Zhang Li
% GaborFit Function for Correlation fitting using "generalized Gabor function" 
% according to "Peter Konig,Journal of Neuroscience Methods 54 (1994) 31-37"

% smooth data first using "Moving Average" method
span=5;
y = smooth(X,Y,span,'moving');
x=X';             % fit function require column vectors

% fit the data with "generalized Gabor function"
fit_opt = fitoptions('method','NonlinearLeastSquares','Lower',[0.1 3 2 10 10 (f-30) 1 30],'Upper',[2 upper_amp upper_amp upper_t upper_t (f+30) upper_amp 100]);
start=[0.1 2 2 10 10 (f-30) 1 40];
set(fit_opt,'StartPoint',start,'MaxFunEvals',2500,'MaxIter',2500);

f_type=fittype('a*exp(-((abs(x-f))/c1)^L)*cos(2*pi*(1/v)*(x-f))+b*exp(-(x/c2)^2)+o',...
     'coefficients',{'L', 'a', 'b', 'c1', 'c2', 'f', 'o', 'v'});
 
[curve_fit,goodness,fit_info]=fit(x,y,f_type,fit_opt);

%%%%%%%%%%%%%---------generalized Gabor function---------%%%%%%%%%%%%%%

% Correlation functions could be quantified by fitting to a
% "generalized Gabor function" with 8 parameters.

% CFit(x)=a*exp(-((abs(x-f))/c1)^L)*cos(2*pi*(1/v)*(x-f))+b*exp(-(x/c2)^2)+o

% The parameters are: amplitude (a), decay constant(c1),
% frequency (v), phase shift (f), offset (o), exponent(L),
% central modulation factor (b) and the width of a central peak (c2). 

% In the above formula the different parameters can be described by their effect on the function.
% The ratio of the amplitude to the offset [a/o] gives an estimate of the strength of the correlation.
% The decay constant is inverse proportional to the bandwidth of the oscillation.
% Frequency and phase shift determine the position and characteristics of the sinusoid in the envelope.
% Choosing an exponent different from 2 leads to a deviation of the envelope from a gaussian,
% with smaller values accentuating the central peak, while larger values lead to a box-like shape.
% The central peak is permitted to depart from the envelope by the sencond term in the sum.
% It describes an additional gaussian of height b and width c2. When b is zero and the exponent L is 2,
% the above equation describes a standard Gabor function. When either of these 2 conditions is not fullfilled,
% we call it a generalized Gabor function.

% This function accounts for the characteristic features of the experimentally determined correlograms and allows for a good fit.
