function [ cs ] = catstructcellarray( sca )
%CATSTRUCTCELLARRAY Summary of this function goes here
%   Detailed explanation goes here

cs=[];
for i=1:numel(sca)
    cs = Analysis.Base.catstruct(cs,sca{i});
end

end

