function [ blockname ] = GetHotBlock( TX )
%GETHOTBLOCK Returns the block that is being recorded into the opened tank. If no block is open
%           for recording a null string is returned
%   Detailed explanation goes here

blockname = TX.GetHotBlock();
end

