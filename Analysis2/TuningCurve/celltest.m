function h = celltest(x,type,alpha)
% celltest.m
% 2011-07-03 by Zhang Li
% Valid Neuron Response Modulation Test


if nargin <3
    alpha = 0.05;
end

mx = mean(x,1);
maxind = find(mx==max(mx));
minind = find(mx==min(mx));
if strcmpi(type,'w') % Wilcoxon signed rank test
    [p h]= signrank(x(:,maxind(1)),x(:,minind(1)),'alpha',alpha);
else
    [h p] = ttest(x(:,maxind(1)),x(:,minind(1)),alpha);
end
