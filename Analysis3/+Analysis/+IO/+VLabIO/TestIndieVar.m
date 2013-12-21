function [ ivspace,iv,ivv,ivvdim ] = TestIndieVar( ct )
%TESTINDIEVAR Summary of this function goes here
%   Detailed explanation goes here

cn = height(ct);
iv = categorical(ct.Properties.VariableNames);

ivv = varfun(@(x)categorical(unique(x)),ct,'outputformat','cell');
ivvdim = cellfun(@(x)length(x),ivv);
ivvn = prod(ivvdim);
if cn<ivvn
    ivspace = 'Sub';
elseif cn==ivvn
    ivspace = 'Equal';
else
    ivspace = 'Dup';
end

end

