function [ info, spi] = spikewaveinfo( s,tfs,iswave )
%SPIKEWAVEINFO Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Core.* Analysis.Base.*
minfs = Global.MinFs;

if nargin==1
    tfs = minfs;
    iswave = false;
end
if nargin==2
    iswave = false;
end
if tfs < minfs
    tfs = minfs;
end

if isnetype(s,'Spike')
    if s.fs < tfs
        n = length(s.value);
        dt = 1/tfs;
        sw = interp1(1:n,s.value,1:s.fs/tfs:n,'pchip');
    else
        dt = 1/s.fs;
        sw = s.value;
    end
    if rms(sw) > Global.MinAPRMS
        [info,spi]= spikewaveinfoin(sw,dt);
    else
        [info,spi] = spikewaveinfoex(sw,dt);
    end
    if iswave
        info.dt = dt;
        info.spikewave = sw;
    end
end

end

