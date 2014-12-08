function [ result ] = ExportBlock( vlblock,exportpath,varargin )
%EXPORTBLOCK Summary of this function goes here
%   Detailed explanation goes here

import Analysis.* Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

if isa(vlblock,'cell')
    result = batch(vlblock,{'ExportBlock'},{[{exportpath} varargin]});
    return;
end


p = inputParser;
addRequired(p,'vlblock');
addRequired(p,'exportpath');
addParameter(p,'isprepare',true);
addParameter(p,'ismlb',true);

parse(p,vlblock,exportpath,varargin{:});
vlblock = p.Results.vlblock;
exportpath = p.Results.exportpath;
isprepare = p.Results.isprepare;
ismlb = p.Results.ismlb;


if isa(vlblock,'Analysis.Core.Block')
    isblock = true;
    vlbfile = vlblock.source;
    block = vlblock;
else
    isblock = false;
    vlbfile = vlblock;
end
[pathstr, name, ext] = fileparts(vlbfile);

if ~isblock
    if isprepare
        block = Analysis.IO.VLabIO.Prepare(vlbfile);
    else
        block = Analysis.IO.VLabIO.ReadVLBlock(vlbfile);
    end
end

file = fullfile(exportpath,name);
disp(['Writing Data File: ',file,' ...']);
block.savedataset([file,'.mat']);
if ismlb
    block.saveblock([file,'_MLB.mat']);
end
disp('Done.');
result = true;
end

