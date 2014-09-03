function [ dots,dotrfidx ] = RFPattern1_3( rf,or,origin,dotfigtype,spacefactor )
%RFPATTERN1_3 Summary of this function goes here
%   Detailed explanation goes here


if nargin < 5
   spacefactor = 1.1; 
end

corigin = [];
for i=1:3
    corigin = cat(1,corigin,origin(dotfigtype(i+1),:));
end
lorigin = [];
for i=1:2
    lorigin = cat(1,lorigin,origin(dotfigtype(i+5),:));
end
rorigin = [];
for i=1:2
    rorigin = cat(1,rorigin,origin(dotfigtype(i+8),:));
end
[ cdots,cdotrfidx ] = RFPattern1_core( rf,corigin, or, 3 );
[ ldots,ldotrfidx ] = RFPattern1_core( rf,lorigin, or, 2 );
[ rdots,rdotrfidx ] = RFPattern1_core( rf,rorigin, or, 2 );
ldotrfidx = ldotrfidx + 4;
ldotrfidx(end) = 0;
rdotrfidx = rdotrfidx + 7;
rdotrfidx(end) = 0;


newrfs = [cdots(2:end,:)-cdots(1:end-1,:);...
    ldots(2:end,:)-ldots(1:end-1,:);...
    rdots(2:end,:)-rdots(1:end-1,:)];
[c,i] = max(sqrt(diag(newrfs*newrfs')));
nrf = spacefactor * newrfs(i,:);


ldots(:,1) = ldots(:,1) - nrf(2);
ldots(:,2) = ldots(:,2) + nrf(1);
rdots(:,1) = rdots(:,1) + nrf(2);
rdots(:,2) = rdots(:,2) - nrf(1);

cdots(:,1) = cdots(:,1) - nrf(1)/2;
cdots(:,2) = cdots(:,2) - nrf(2)/2;

dots = [cdots;ldots;rdots];
dotrfidx = [cdotrfidx;ldotrfidx;rdotrfidx];
end

