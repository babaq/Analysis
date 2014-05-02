function [  ] = ExportBlock( vlblock,exportpath,isprepare,iscoredata )
%EXPORTBLOCK Summary of this function goes here
%   Detailed explanation goes here

if isa(vlblock,'Analysis.Core.Block')
    isblock = true;
    vlbfile = vlblock.source;
    block = vlblock;
else
    isblock = false;
    vlbfile = vlblock;
end
[pathstr, name, ext] = fileparts(vlbfile);
if nargin < 2
    exportpath = pathstr;
    isprepare = true;
    iscoredata = false;
elseif nargin < 3
    isprepare = true;
    iscoredata = false;
elseif nargin < 4
    iscoredata = false;
end

if ~isblock
    if isprepare
        block = Analysis.IO.VLabIO.Prepare(vlbfile);
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
end

