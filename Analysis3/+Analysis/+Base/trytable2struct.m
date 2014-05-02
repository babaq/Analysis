function [ t ] = trytable2struct( t,ists )
%TRYTABLE2STRUCT Summary of this function goes here
%   Detailed explanation goes here

if nargin ==1
    ists = true;
end

if isa(t,'table')
    t = table2struct(t,'ToScalar',ists);
    t = Analysis.Base.trytable2struct(t,ists);
elseif isa(t,'struct')
    names = fieldnames(t);
    for i=1:length(names)
        t.(names{i}) = Analysis.Base.trytable2struct(t.(names{i}),ists);
    end
elseif isa(t,'categorical')
    t = cellstr(t);
end

end

