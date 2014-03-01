function [ lr ] = roweq( rvector,matrix )
%ROWEQ Summary of this function goes here
%   Detailed explanation goes here

if ~isrow(rvector)
    error('rvector');
end
cn = length(rvector);
if size(matrix,2) ~= cn
    error('matrix column do not match rvector');
end
rn = size(matrix,1);
lr = false(rn,1);
for r = 1:rn
    lr(r) = all(rvector==matrix(r,:));
end

end

