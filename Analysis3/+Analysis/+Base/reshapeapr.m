function [ rap ] = reshapeapr( aptimes,on,delaystep,delaymax,duration  )
%RESHAPEAPR Summary of this function goes here
%   Detailed explanation goes here

trialn = size(on,1);
stin = size(on,2);
dstepn = ceil(delaymax/delaystep);
for t = 1:trialn
    for s = 1:stin
        for d = 1:dstepn
            [rap.apt{t,s,d},rap.win(t,s,d,:)] = caponduration(aptimes,on(t,s),delaystep*(d-1),duration);
        end
    end
end

end

