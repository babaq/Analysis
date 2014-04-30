function [ drx ] = dimreduc( x, dim, exdimidx )
%DIMREDUC Summary of this function goes here
%   Detailed explanation goes here

if nargin == 1
    dim = 1;
    exdimidx = [];
end
if nargin == 2
    exdimidx = [];
end

xsize = size(x);
dn = xsize(dim);
xidx = regexprep(num2str(xsize),{'\s*','\d*'},{',',':'});

if ~isempty(exdimidx)
    for i = 1:size(exdimidx,1)
        xidx = regexprep(xidx,'[:0-9]*',num2str(exdimidx(i,2)),exdimidx(i,1));
    end
end

sub = Analysis.Base.ind2subr(dn,1:prod(dn));
if length(dn)==1
    drx = cell(dn,1);
else
    drx = cell(dn);
end
for k = 1:size(sub,1)
    ksub = sub(k,:);
    idx = xidx;
    for di=1:size(sub,2)
        idx = regexprep(idx,'[:0-9]*',num2str(ksub(di)),dim(di));
    end
    eval(['dx = x(',idx,');']);
    drx{k} = dx(:);
end

end

