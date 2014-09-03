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
addParameter(p,'nivs','');
addParameter(p,'isorganize',true);
addParameter(p,'isfigononly',true);
addParameter(p,'badstatus',{'Early'});
addParameter(p,'iscoredata',true);


parse(p,vlblock,exportpath,varargin{:});
vlblock = p.Results.vlblock;
exportpath = p.Results.exportpath;
isprepare = p.Results.isprepare;
nivs = p.Results.nivs;
isorganize = p.Results.isorganize;
isfigononly = p.Results.isfigononly;
badstatus = p.Results.badstatus;
iscoredata = p.Results.iscoredata;


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
        block = Analysis.IO.VLabIO.Prepare(vlbfile,'nivs',nivs);
        if isorganize
            Analysis.IO.VLabIO.Organize(block,badstatus,isfigononly);
        end
    else
        block = Analysis.IO.VLabIO.ReadVLBlock(vlbfile);
    end
end

file = fullfile(exportpath,name);
disp(['Writing Block File: ',file,' ...']);
save([file,'.mat'],'block',Analysis.Core.Global.MatVersion);
if iscoredata
    dataset = block.CoreData();
    save([file,'_CoreData.mat'],'dataset',Analysis.Core.Global.MatVersion);
end
disp('Done.');
result = true;
end

