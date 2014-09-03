function [ filenames ] = getdatapath( path,name,iscoredata )
%GETDATAPATH Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    iscoredata = false;
end

d = dir(fullfile(path,name));
filenames = {d(:).name};

if ~iscoredata
    filenames = filenames(cellfun(@(x)isempty(x),strfind(filenames,'_CoreData')));
end

filenames = cellfun(@(x)fullfile(path,x),filenames,'uniformoutput',false);

end

