function [ m, se, t ] = fmean1( x,dim )
%FMEAN1 Summary of this function goes here
%   Detailed explanation goes here

if nargin == 1
    dim = 1;
end

msize = size(x);
dn = msize(dim);
m = zeros(dn,1);
se = m;
t = false(msize);
midx = regexprep(num2str(msize),{'\s*','\d*'},{',',':'});

for i = 1:dn
    idx = regexprep(midx,'[:]',num2str(i),dim);
    eval(['dx = x(',idx,');']);
    fidx = isfinite(dx);
    fdx = dx(fidx);
    
    if ~isempty(fdx)
        m(i) = mean(fdx(:));
        se(i) = Analysis.Base.ste(fdx(:));
        eval(['t(',idx,') = fidx;']);
    else
        m(i) = NaN;
        se(i) = NaN;
    end
end

end

