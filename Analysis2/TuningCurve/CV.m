function [cv ang] = CV(mr,sti)
% CV.m
% 2011-12-03 by Zhang Li
% Orientation Tuning Circular Variance


stin=[];
for i=1:size(mr,1)
    stin = [stin ;sti];
end

vs = sum(mr.*exp(1i*2*stin),2);
cv = abs(vs)./(sum(mr,2));
ang = angle(vs);
