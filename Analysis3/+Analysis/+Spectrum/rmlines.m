function [ as ] = rmlines( as,fs,freqs )
%RMLINES Summary of this function goes here
%   Detailed explanation goes here

params.tapers = [1 1];
params.Fs = fs;
params.fpass = [0 fs/2];
params.pad = 5;
n = length(as);

for i = 1:length(freqs)
    as = rmlinesc(as,params,0.05/n,'n',freqs(i));
end

end

