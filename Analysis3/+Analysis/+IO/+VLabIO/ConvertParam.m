function [ params ] = ConvertParam( pstructarray )
%CONVERTPARAM Summary of this function goes here
%   Detailed explanation goes here

% some graph param that has m_szName = '.' which cann't be used
% as valid name of struct field.
dotcount = 1;
    function ps = paramstruct(s)
        name = s.m_szName;
        value = s.m_szData;
        if name=='.'
            name = ['DOT',num2str(dotcount)];
            dotcount = dotcount+1;
        end
        ps.(name) = value;
    end
params = arrayfun(@paramstruct,pstructarray,'uniformoutput',false);
params = Analysis.Base.catstructcellarray(params);
end

