function [ hr ] = CreateEpocIndexing( TX )
%CREATEEPOCINDEXING A memory based epoch index must be created for the selected block before a
%       client applications can take advantage of high speed data indexing and filtering
%       capabilities. After selecting a block for access, using SelectBlock, call
%       CreateEpocIndexing to instruct TTankServer to build the epoch index. This call
%       must be made each time a new block is selected.
%       A tilde (~) in front of the block name of the SelectBlock method will
%       automatically generate an epoch index for that block.

hr = TX.CreateEpocIndexing();
if hr==0
    hr = false;
else
    hr = true;
end

