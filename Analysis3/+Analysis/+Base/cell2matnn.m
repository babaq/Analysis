function [ m ] = cell2matnn( c )
%CELL2MATNN Summary of this function goes here
%   Detailed explanation goes here

    function x = t(x)
        if isempty(x)
            x = NaN;
        end
    end

c = cellfun(@t,c,'Uniformoutput',false);
m = cell2mat(c);
end

