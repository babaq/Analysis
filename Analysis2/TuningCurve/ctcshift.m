function [tdata c1step c2step] = ctcshift(tdata,ooi)
% ctcshift.m
% 2012-05-09 by Zhang Li
% Conditional Tuning Data shift to center

c1 = size(tdata,1);
c2 = size(tdata,2);
cc1 = (c1-1)/2+1;
cc2 = (c2-1)/2+1;

c1step = cc1-ooi;
c2step = 0;

tdata = circshift(tdata,[c1step c2step]);
temp = circshift(tdata(1:cc1-1,:),[1 0]);
tdata(1:cc1-1,:) = temp;


