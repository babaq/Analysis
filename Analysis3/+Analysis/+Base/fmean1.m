function [ m, se, t ] = fmean1( x,dim,dimidx )
%FMEAN1 Summary of this function goes here
%   Detailed explanation goes here

if nargin == 1
    dim = 1;
    dimidx = [];
end
if nargin == 2
    dimidx = [];
end

msize = size(x);
dn = msize(dim);
m = zeros(dn,1);
se = m;
t = false(msize);
midx = regexprep(num2str(msize),{'\s*','\d*'},{',',':'});

if ~isempty(dimidx)
    for i = 1:size(dimidx,1)
        midx = regexprep(midx,'[:0-9]*',num2str(dimidx(i,2)),dimidx(i,1));
    end
end

for i = 1:dn
    idx = regexprep(midx,'[:0-9]*',num2str(i),dim);
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

