function [ x ] = trystr2num( x )
%TRYSTR2NUM Summary of this function goes here
%   Detailed explanation goes here

if isa(x,'struct')
    names = fieldnames(x);
    for i=1:length(names)
        x.(names{i}) = Analysis.Base.trystr2num(x.(names{i}));
    end
else
    [t,s] = str2num(x);
    if s
        x = t;
    end
end

end

