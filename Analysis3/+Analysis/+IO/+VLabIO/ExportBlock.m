function [  ] = ExportBlock( vlbfile,exportpath )
%EXPORTBLOCK Summary of this function goes here
%   Detailed explanation goes here

[pathstr, name, ext] = fileparts(vlbfile);
if nargin ==1
    exportpath = pathstr;
end
block = Analysis.IO.VLabIO.ReadVLBlock(vlbfile);

save(fullfile(exportpath,[name,'.mat']),'block');
end

