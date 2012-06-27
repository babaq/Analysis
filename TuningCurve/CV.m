function cv = CV(mr,sti)
% CV.m
% 2011-12-03 by Zhang Li
% Orientation Tuning Circular Variance


cv = 1 - abs((sum(mr.*exp(1i*2*sti)))/(sum(mr)));
