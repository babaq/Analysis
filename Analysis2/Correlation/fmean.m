function [m se t] = fmean(x,type)
% fmean.m
% 2010-7-12 by Zhang Li
% Finite Matrix First Dim Mean without NaN and +/-Inf (3D X)

if nargin <2
    type = 'l';
end

msize = size(x);
m = zeros(msize(2:3));
se = m;
t = zeros(msize(2),1);
for i=1:msize(2)
    sx = squeeze(x(:,i,:));
    ivsxi = ~isfinite(sx);
    sx( ivsxi==1)=[];
    
    if ~isempty(sx)
        ivsxit = ivsxi(:,1);
        ivsxit(ivsxit==1)=[];
        vt = length(ivsxit);
        sx = reshape(sx,[vt msize(3)]);
        if strcmpi(type,'l') % linear
            m(i,:) = mean(sx,1);
            se(i,:) = ste(sx,0,1);
        else
            mu = circ_mean(sx,[],1);
            m(i,:) = mu;
            [s s0] = circ_std(sx,[],[],1);
            se(i,:) = s0;
        end
        t(i) = vt;
    else
        m(i,:) = NaN;
        se(i,:) = NaN;
    end
end