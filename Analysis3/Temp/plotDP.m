function [  ] = plotDP( dots )
%PLOTDP Summary of this function goes here
%   Detailed explanation goes here

figure;
scatter(dots(:,1),dots(:,2),'fill');
% 
% dc = d/2;
% x = -abs(d(1))*0.5:0.01:abs(d(1))*1.5;
% y = sqrt(r^2-(x-dc(1)).^2)+dc(2);
% yy = -sqrt(r^2-(x-dc(1)).^2)+dc(2);
% 
% mx = x-d(1);
% my = y-d(2);
% myy = yy-d(2);
% 
% plot(x,y,x,yy,mx,my,mx,myy);
axislimit = [-2 2];
set(gca,'xlim',axislimit,'ylim',axislimit,'dataaspectratio',[1 1 1]);

end

