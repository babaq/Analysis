function [ blockname ] = QueryBlockName( TX,blocknumber )
%QUERYBLOCKNAME returns the block name for a given block index. This function
%               can be used to build a list of blocks within a tank. The first call must be made
%               with BlockNumber of 0, then the index can be increased until null is returned.
%input:
%    blocknumber   0 based    

blockname = TX.QueryBlockName(blocknumber);
end

