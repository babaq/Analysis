function [ blockowner ] = CurBlockOwner( TX )
%CURBLOCKOWNER returns the owner of the currently selected block. If no owner
%               was specified, a null string is returned
%   Detailed explanation goes here

blockowner = TX.CurBlockOwner();
end

