function [ dots,dotrfidx ] = RFPattern1_1( rf,israndom,repn )
%RFPATTERN1_1 Summary of this function goes here
%   Detailed explanation goes here

if nargin<1
    rf = rand(1,2)-0.5;
    israndom = false;
    repn=2;
elseif nargin <2
    israndom = false;
    repn=1;
elseif nargin < 3
    repn = 1;
end

    function rjv = jitter(isj,limit)
        if isj
            rjv = (rand(1,1)*2-1)*limit;
        else
            rjv = 0;
        end
    end

r = sqrt(rf(1)^2+rf(2)^2)/2;
mrf = -rf;
cdots=[0 0];
for i=1:repn
    cdots = [rf*i;cdots;mrf*i];
end
for i=1:repn
    ldots{i,1}(:,1) = cdots(:,1) - rf(2)*i + jitter(israndom,r);
    ldots{i,1}(:,2) = cdots(:,2) + rf(1)*i + jitter(israndom,r);
    rdots{i,1}(:,1) = cdots(:,1) + rf(2)*i + jitter(israndom,r);
    rdots{i,1}(:,2) = cdots(:,2) - rf(1)*i + jitter(israndom,r);
end

dots = [cdots;cell2mat(ldots);cell2mat(rdots)];
dotrfidx = (1:size(dots,1))'-1;
for i=1:2*repn+1:length(dotrfidx)
    dotrfidx(i) = 0;
end

end