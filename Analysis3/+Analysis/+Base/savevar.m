function [  ] = savevar( invokefun,var,varname )
%SAVEVAR Save a varable to a mat file located in the same folder of
%       invoking function or file

eval([varname '=var;']);
path = fileparts(which(invokefun));
filepath = fullfile(path,[varname,'.mat']);
save(filepath,varname);
end

