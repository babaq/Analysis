function [ lv ] = loadvar( invokefun,filename,varname )
%LOADVAR Load a varable from a mat file located in the same folder of
%       invoking function or file

if nargin==2
    [path, varname, ext] = fileparts(filename);
end
path = fileparts(which(invokefun));
filepath = fullfile(path,filename);
if exist(filepath,'file') > 1
    lv = load(filepath,varname);
    lv = lv.(varname);
else
    lv = [];
end

end

