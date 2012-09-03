function w = rmline(w,fs,f0,nharmonic)
% rmline.m
% 2011-03-12 by Zhang Li
% Remove Line Noise

if nargin < 4
    nharmonic = 1;
end

params.tapers = [1 1];
params.Fs = fs;
params.fpass = [0 fs/2];
params.pad = 5;

for i = 1:nharmonic
    f = f0 * i;
    w = rmlinesc(w,params,0.05,'n',f);
end
