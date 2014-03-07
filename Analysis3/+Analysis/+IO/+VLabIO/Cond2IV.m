function [ ivspace, iv, ivv, iv2c ] = Cond2IV( ct,tt,nivs )
%COND2IV Mapping condition index to independent variable values
%   Detailed explanation goes here

import Analysis.IO.VLabIO.* Analysis.Base.*

if nargin <2
    tt = '';
    nivs = '';
elseif nargin <3
    nivs = '';
end

[ ivspace,iv,ivv,ivvdim ] = TestIndieVar(ct);
ct = ct(:,ivvdim>1);
if strcmp(ivspace,'Sub')
    ivvdim = ivvdim(ivvdim>1);
    ct = GetIndieVar(ct,ivvdim,tt,nivs);
end
[ ivspace,iv,ivv,ivvdim ] = TestIndieVar(ct);

ivn = length(iv);
if ivn==1
    iv2c = cell(ivvdim,1);
else
    iv2c = cell(ivvdim);
end

for i = 1:height(ct)
    idx = zeros(1,ivn);
    for j=1:ivn
        idx(j) = find(roweq(categorical(ct{i,j}),categorical(ivv{j})));
    end
    idx = regexprep(num2str(idx),'\s*',',');
    eval(['iv2c{',idx,'} = [iv2c{',idx,'}; ',num2str(i),'];']);
end

end

