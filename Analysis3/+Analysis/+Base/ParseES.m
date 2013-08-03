function [ epi ] = ParseES( evs,format )
%PARSEES Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Base.StiLib.*

if nargin == 1
    format = 'StiLib';
end
switch format
    case 'StiLib'
        epi = SLParseES(evs);
    otherwise
        epi = [];
end
end

