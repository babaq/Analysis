function [ hr ] = SelectBlock( TX,blockname,isepocindexing )
%SELECTBLOCK Summary of this function goes here
%input:
%  isepocindexing   if use '~' to automatically create epoc indexing for
%                   current block

if nargin < 3
    isepocindexing = true;
end
if isepocindexing
    blockname = ['~',blockname];
end
hr = TX.SelectBlock(blockname);
if hr==0
    hr = false;
else
    hr = true;
end

