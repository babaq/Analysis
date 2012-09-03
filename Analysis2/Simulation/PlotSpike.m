function PlotSpike(ss)
% PlotSpike.m
% 2010-04-24 Zhang Li
% Plot Soul simulation system record spike data

figure,plot(ss.spike.n,ss.spike.data,'.b');