function [ es ] = ParseES( evs,format )
%PARSEES Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Core.StiLib.*

switch format
    case 'StiLib'
        es = SLParseES(evs);
    otherwise
        es = evs;
end
end

