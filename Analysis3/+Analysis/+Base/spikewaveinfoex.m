function [ info, smind] = spikewaveinfoex( sw,dt )
%SPIKEWAVEINFOEX Extrocellular spike wave info

l = length(sw);
% spike peak should in first 1 ms
n = floor(0.001/dt);
smin = min(sw(1:n));
smind = find(sw==smin);
smind = smind(1);
% spike duration should less than 1 ms
smax = max(sw(smind:smind+n));
smaxd = find(sw==smax);
smaxd = smaxd(1);
ar = abs(smin/smax);
sd = (smaxd-smind)*dt*1000; % ms
% spike width should less than 1 ms
m = floor(n/2);
rsw = sw(max(smind-m,1):min(smind+m,l));
hsi = find(rsw<=(smin/2));
hswleft = hsi(1);
hswright = hsi(end);
hsw= (hswright-hswleft)*dt*1000; % ms
% after spike width should less than 0.5 - 1 ms
fsw = sw(max(smaxd-m,1):min(smaxd+n,l));
hasi = find(fsw>=(smax/2));
if isempty(hasi)
    hasw = NaN;
else
haswleft = hasi(1);
haswright = hasi(end);
hasw= (haswright-haswleft)*dt*1000; % ms
end

info.amplituderatio = ar;
info.spikeduration = sd;
info.halfspikewidth = hsw;
info.halfafterspikewidth = hasw;

end

