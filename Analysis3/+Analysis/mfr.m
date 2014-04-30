function [ mfrdata, spikedata ] = mfr( data,param,range,delay )
%MFR Summary of this function goes here
%   Detailed explanation goes here

subparam = param.SubjectParam;
minconddur = subparam.MinCondDur;

if nargin < 3
    range = [0 minconddur];
    delay = 0;
elseif nargin < 4
    delay = 0;
end
delayn = length(delay);

mfrdata = [];
spikedata = [];
for i = 1:delayn
    r = range+delay(i);
    [sd, md] = Analysis.cutbin(data,param,r,r(2)-r(1));
    mfrdata = cat(4,mfrdata,md);
    spikedata = cat(4,spikedata,sd);
end

end

