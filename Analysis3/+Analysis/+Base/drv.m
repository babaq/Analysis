function [ idx ] = drv( p,n,isp2n )
%DRV Generate Discrete Random Variable Sequence
%   Detailed explanation goes here

if sum(p) ~= 1
    error('sum(p) ~= 1');
end
if nargin <2
    n=1;
    isp2n = false;
elseif nargin <3
    isp2n = false;
end

if isp2n
    pn = round(p*n);
    pn(end) = n-sum(pn(1:end-1));
    if sum(pn) ~= n
        error('sum(pn) ~= n');
    end
    
    pnc = zeros(size(p));
    idx = zeros(n,1);
    for i=1:n
        while true
            v = Analysis.Base.drv(p);
            if pnc(v) < pn(v)
                pnc(v) = pnc(v) + 1;
                idx(i) = v;
                break;
            end
        end
    end
    
else
    bin = [0 cumsum(p)];
    x=rand(1,n);
    [c,idx] = histc(x,bin);
    idx = idx';
end

end

