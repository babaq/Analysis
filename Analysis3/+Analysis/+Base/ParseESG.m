function [ epi ] = ParseESG( esg, format )
%PARSEESG Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Base.*

if nargin==1
    format = 'StiLib';
end
epi = [];
for i = 1:length(esg)
    tpi = ParseES(esg(i),format);
    if ~isempty(tpi) && isempty(tpi.error)
        epi = catstruct(tpi,epi);
    end
end

end

