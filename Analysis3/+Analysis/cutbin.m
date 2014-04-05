function [ spikedata, psthdata ] = cutbin( data,param,range,bw,isbin )
%CUTBIN Summary of this function goes here
%   Detailed explanation goes here

import Analysis.Base.*

vi = data.valididx;
subparam = param.SubjectParam;
figontime = data.figontime;
figvalid = param.AnalysisParam.FigValid;
maxpreicidur = str2double(subparam.MaxPreICIDur);
maxsuficidur = str2double(subparam.MaxSufICIDur);
maxconddur = str2double(subparam.MaxCondDur);

if nargin < 3
    range = [-maxpreicidur maxconddur + maxsuficidur];
    bw = 5; % ms
    isbin = true;
elseif nargin < 4
    bw = 5; % ms
    isbin = true;
elseif nargin < 5
    isbin = true;
end

psthdata = cell(size(vi));
spikedata = cell(size(vi));
trialn = size(vi,1);
condn = size(vi,2);
celln = size(vi,3);

for i = 1:trialn
    for j = 1:condn
        for k = 1:celln
            if vi(i,j,k)
                if figvalid
                    r = range + figontime{i,j}(1);
                end
                sp = cutst(data.cellspike{k},r(1),r(2));
                if isbin
                    psthdata{i,j,k} = binst(rvector(sp),r,bw)/(bw/1000);
                end
                if figvalid
                    sp = sp - figontime{i,j}(1);
                end
                spikedata{i,j,k} = sp;
            end
        end
    end
end

end

