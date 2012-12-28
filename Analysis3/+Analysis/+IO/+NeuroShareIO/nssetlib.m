function [ nsLibraryInfo ] = nssetlib( filename )
%NSSETLIB Summary of this function goes here
%   Detailed explanation goes here

[ns_RESULT] = ns_SetLibrary(filename);

if ns_RESULT ~= 0
    error('Library Error!');
end
[ns_RESULT, nsLibraryInfo] = ns_GetLibraryInfo();
if ns_RESULT ~= 0
    error('Library Error!');
end

end

