function [ m, se, t ] = fmean2( x,dim1,dim2 )
%FMEAN2 Summary of this function goes here
%   Detailed explanation goes here

if nargin == 1
    dim1 = 1;
    dim2 = 2;
end

msize = size(x);
dn1 = msize(dim1);
dn2 = msize(dim2);
m = zeros(dn1,dn2);
se = m;
t = false(msize);
midx = regexprep(num2str(msize),{'\s*','\d*'},{',',':'});

for i = 1:dn1
    idx1 = regexprep(midx,'[:]',num2str(i),dim1);
    for j = 1:dn2
        idx = regexprep(idx1,'[:0-9]*',num2str(j),dim2);
        eval(['dx = x(',idx,');']);
        fidx = isfinite(dx);
        fdx = dx(fidx);
        
        if ~isempty(fdx)
            m(i,j) = mean(fdx(:));
            se(i,j) = Analysis.Base.ste(fdx(:));
            eval(['t(',idx,') = fidx;']);
        else
            m(i,j) = NaN;
            se(i,j) = NaN;
        end
    end
end

end

