function [ cm,cse,ftn ] = cellfmean( c )
%CELLFMEAN Summary of this function goes here
%   Detailed explanation goes here

    function m = t(x)
        [m{1}, m{2}, m{3}] = Analysis.Base.fmean1(x,2);
    end
m = cellfun(@t,c,'Uniformoutput',false);
    function x = t1(x)
        if isempty(x)
            x = NaN;
        end
    end
cm = cellfun(@(x)t1(x{1}),m);
cse = cellfun(@(x)t1(x{2}),m);
    function x = t2(x)
        if isempty(x)
            x = 0;
        else
            x = nnz(x);
        end
    end
ftn = cellfun(@(x)t2(x{3}),m);

end

