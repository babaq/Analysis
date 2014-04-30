function [ oct ] = orthocond( iv,ivv )
%ORTHOCOND Summary of this function goes here
%   Detailed explanation goes here

ivn = length(iv);
if ivn ~= length(ivv)
    error('Independent Variable and Value Do Not Match.');
end

ct = ivv{1};
for i=2:ivn
    ctn = size(ct,1);
    pv = ivv{i};
    pct = [];
    for j=1:length(pv)
        pct = [pct; [ct Analysis.Base.arraypending(pv(j),ctn,1)]];
    end
    ct = pct;
end

oct = cell2table(num2cell(ct),'VariableNames',iv);
end

