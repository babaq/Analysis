function [  ] = ExportBlock( vlblock,exportpath,isprepare )
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
elseif nargin < 3
    isprepare = true;
end

if ~isblock
    if isprepare
        block = Analysis.IO.VLabIO.Prepare(vlbfile);
    else
        block = Analysis.IO.VLabIO.ReadVLBlock(vlbfile);
    end
end

disp('Writing Block File ...');
save(fullfile(exportpath,[name,'.mat']),'block');
end

