function [ msw ] = meanspikewave( sw,pi )
%MEANSPIKEWAVE Align spike wave to peak and get overlapped mean wave

ai = floor(mean(pi));
sn = pi-ai;
cutrange = 1-floor(mean(sn(sn<0))):size(sw,1)-ceil(mean(sn(sn>0)));
for i = 1:size(sw,2)
    casw = circshift(sw(:,i),[-sn(i) 0]);
    acsw(:,i) = casw(cutrange);
end
msw = mean(acsw,2);

end

