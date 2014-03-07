function [ ivt ] = iv2ct( tc,iv2c )
%IV2CT Summary of this function goes here
%   Detailed explanation goes here

ivt = cellfun(@(x)reshape(tc(:,x),[],1),iv2c,'Uniformoutput',false);
end

