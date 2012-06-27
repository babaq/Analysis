function info = spikewaveinfo(meanspikewave,sortid,fs,minisi)
% spikewaveinfo.m
% 2010-07-09 by Zhang Li
% Check Single-Unit and Get parameters of mean spike waveform

info.meanspikewave = meanspikewave;
info.sortid = sortid;
% single-unit have valid minimum refactory period: 1ms and thus minimum ISI: 2ms
if minisi > 0.002; % sec
    info.unittype = 'su';
else
    info.unittype = 'mu';
end

mswn = length(meanspikewave);
ft = fittype('smoothingspline');
mswf = fit((1:mswn)',double(meanspikewave),ft);
resolution = 0.01;
sw = mswf(1:resolution:mswn);
fs = fs/resolution;

smin = min(sw);
smind = find(sw==smin);
smax = max(sw(smind:end));
smaxd = find(sw==smax);
ar = abs(smax/smin);
sd = ((smaxd-smind)/fs)*1000; % ms
hsi = find(sw<=(smin/2));
hswleft = hsi(1);
hswright = hsi(end);
hsw= ((hswright-hswleft)/fs)*1000; % ms
hasi = find(sw>=(smax/2));
haswleft = hasi(1);
haswright = hasi(end);
hasw= ((haswright-haswleft)/fs)*1000; % ms

info.spikewaveinfo.smoothspikewave = sw;
info.spikewaveinfo.spikeduration = sd;
info.spikewaveinfo.halfspikewidth = hsw;
info.spikewaveinfo.halfafterspikewidth = hasw;
info.spikewaveinfo.amplituderatio = ar;
