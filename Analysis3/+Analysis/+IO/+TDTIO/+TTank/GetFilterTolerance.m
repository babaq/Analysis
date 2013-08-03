function [ tolerance ] = GetFilterTolerance( TTX )
%GETFILTERTOLERANCE Returns the tolerance of the filter. The tolerance is the margin of error allowed
%       in evaluating the conditions of the filter.The default value is 1e-7.
%output:
%  tolerance  Will return ¨C1 in the absence of a tolerance
%   Detailed explanation goes here

tolerance = TTX.GetFilterTolerance();
end

