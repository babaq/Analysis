function [ ivt ] = physiobo( block,varargin )
%PHYSIOBO Summary of this function goes here
%   Detailed explanation goes here

p = inputParser;
addRequired(p,'block');
addParameter(p,'nivs','');
addParameter(p,'range','d');
addParameter(p,'delay',50);
addParameter(p,'cell',1);

parse(p,block,varargin{:});
block = p.Results.block;
nivs = p.Results.nivs;
range = p.Results.range;
delay = p.Results.delay;
cell = p.Results.cell;

import Analysis.* Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

[block.param.IVSpace,block.param.IndieVar,block.param.IVValue,block.param.IV2C]...
    = Cond2IV(block.param.Condition,block.param.TestType,nivs);
if isempty(block.param.AnalysisParam.BadStatus)
    disp('Exclude ''Early'' Test Trials ...');
    Organize(block,{'Early'});
end

%% Processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = block.data;
param = block.param;
vi = data.valididx;
subparam = param.SubjectParam;
minconddur = subparam.MinCondDur;
iv2c = param.IV2C;
if ischar(range)
    range = [0 minconddur];
end

processdata = mfr(data,param,range,delay);
pdata = processdata(:,:,cell);
pdata = cell2matnn(pdata);
ivt = iv2ct(pdata,iv2c);
siz = size(ivt);
ivtsub = ind2subr(siz,1:prod(siz));

    function [y,group] = prepareanovan(ivt,ivtsub)
        y=[];
        group = [];
        for i=1:size(ivtsub,1)
            civt = ivt{i};
            y = [y;civt];
            tn = length(civt);
            group = [group;Analysis.Base.arraypending(ivtsub(i,:),tn)];
        end
        group = mat2cell(group,size(group,1),ones(1,size(ivtsub,2)));
    end

[y,group] = prepareanovan(ivt,ivtsub);
anovan(y,group,'varnames',param.IndieVar,'model','full');

end

