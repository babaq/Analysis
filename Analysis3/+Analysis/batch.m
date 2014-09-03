function [ batchresult ] = batch( blocklist,methodlist,vararginlist )
%BATCH Summary of this function goes here
%   Detailed explanation goes here


import Analysis.* Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

blockn = length(blocklist);
methodn = length(methodlist);
argn = length(vararginlist);
if argn ~= methodn
    error('Number of batch method (%d) does not match number of corresponding argument (%d).',methodn,argn);
end

if methodn < blockn
    methodlist = arraypending(methodlist,blockn);
    vararginlist = arraypending(vararginlist,blockn);
end

for i=1:blockn
    block = blocklist{i};
    if isa(block,'Analysis.Core.Block')
        name = block.param.DataFile;
    elseif isa(block,'char')
        [pathstr, name, ext] = fileparts(block);
        if strcmp(ext,'.mat')
            load(block,'block');
        end
    end
    varargin = vararginlist{i};
    disp('==================================================');
    disp([methodlist{i},' -> ',name,' ...']);
    eval(['batchresult{i} = ',methodlist{i},'(block',varargin2literal(varargin),');']);
end

end

