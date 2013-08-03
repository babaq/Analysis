function [ sti2cti ] = sti2con( varargin )
%STI2CON Recover Stimuli index to Condition Table index
%   Detailed explanation goes here

cond = cellfun(@(x)x(~isempty(x)),varargin);
sn = prod(cond);
cti = cond;
sti2cti = cell(1,sn);
for si=0:sn-1
    cti(1) = si;
    for ci=1:length(cond)-1
        subprod = prod(cond(ci+1:end));
        subs = cti(ci);
        cti(ci) = floor(subs/subprod);
        cti(ci+1) = mod(subs,subprod);
    end
    sti2cti{1,si+1} = cti+1;
end

end

