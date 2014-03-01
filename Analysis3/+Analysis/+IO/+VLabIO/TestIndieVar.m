function [ ivspace,iv,ivv,ivvdim ] = TestIndieVar( ct )
%TESTINDIEVAR Summary of this function goes here
%   Detailed explanation goes here

cn = height(ct);
iv = categorical(ct.Properties.VariableNames);

wmid = 'MATLAB:UNIQUE:RowsFlagIgnored';
warning('off',wmid);
ivv = varfun(@(x)categorical(unique(x,'rows')),ct,'outputformat','cell');
ivvdim = cellfun(@(x)size(x,1),ivv);
ivvn = prod(ivvdim);
if cn<ivvn
    ivspace = 'Sub';
elseif cn==ivvn
    ivspace = 'Equal';
else
    ivspace = 'Dup';
end

end

