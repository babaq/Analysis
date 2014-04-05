function [ dots,dotrfidx ] = RFPattern1_2( rf,israndom )
%RFPATTERN1_2 Summary of this function goes here
%   Detailed explanation goes here

if nargin<1
    rf = rand(1,2)-0.5;
    israndom = false;
elseif nargin <2
    israndom = false;
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
cdots = [rf;cdots;mrf];

ldots(:,1) = cdots(:,1) - rf(2) + jitter(israndom,r);
ldots(:,2) = cdots(:,2) + rf(1) + jitter(israndom,r);
rdots(:,1) = cdots(:,1) + rf(2) + jitter(israndom,r);
rdots(:,2) = cdots(:,2) - rf(1) + jitter(israndom,r);

cdots = [cdots;mrf*2];
cdots(:,1) = cdots(:,1) + rf(1)/2;
cdots(:,2) = cdots(:,2) + rf(2)/2;
dots = [cdots;ldots;rdots];
dotrfidx = (1:size(dots,1))'-1;
dotrfidx(5) = 0;
dotrfidx(8) = 0;

end