function [curve_fit,goodness,fit_info]=FourierFit(X,Y)
% FourierFit.m %
% 2008-10-30  Zhang Li
% FourierFit Function for Phase of Firing Distribution 

% smooth data first using "Moving Average" method
span=5;
y = smooth(X,Y,span,'moving');
x=X';             % fit function require column vectors


start=[0 0 0 0.15];
f_type=fittype('fourier1');
 
[curve_fit,goodness,fit_info]=fit(x,y,f_type,'StartPoint',start);
