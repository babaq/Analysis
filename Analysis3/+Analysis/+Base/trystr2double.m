function [ x ] = trystr2double( x )
%TRYSTR2DOUBLE Summary of this function goes here
%   Detailed explanation goes here

if isa(x,'struct')
    names = fieldnames(x);
    for i=1:length(names)
        x.(names{i}) = Analysis.Base.trystr2double(x.(names{i}));
    end
else
    t = str2double(x);
    if nnz(isnan(t))==0
        x = t;
    end
end

end

