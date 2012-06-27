function m = fm(m)
% fm.m
% 2010-3-12 by Zhang Li
% Finite Matrix with NaN and +/-Inf set to []

msize = size(m);
nfi = ~isfinite(m);
nfi = find(nfi==1);
[rowsub columnsub] = ind2sub(msize,nfi);

m(rowsub,:) = [];
urown = length(unique(rowsub));
msize(1) = msize(1) - urown;
m = reshape(m,msize);

