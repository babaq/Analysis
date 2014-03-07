function [ psthdata, spikedata ] = psth( data,param,range,bw )
%PSTH Summary of this function goes here
%   Detailed explanation goes here

import Analysis.Base.*

spike = data.spike;
subparam = param.SubjectParam;
maxpreicidur = str2double(subparam.MaxPreICIDur);
maxsuficidur = str2double(subparam.MaxSufICIDur);
maxconddur = str2double(subparam.MaxCondDur);

if nargin < 3
    range = [-maxpreicidur maxconddur + maxsuficidur];
    bw = 5; % ms
elseif nargin < 4
    bw = 5; % ms
end

trialn = size(spike,1);
condn = size(spike,2);
celln = size(spike,3);

for i = 1:trialn
    for j = 1:condn
        for k = 1:celln
            sp = rvector(spike{i,j,k});
            psthdata{i,j,k} = binst(sp,range,bw)/(bw/1000);
            spikedata{i,j,k} = cutst(sp,range(1),range(2));
        end
    end
end

end

