function [si s_max s_min] = SI(mr,sti,stiend)
% SI.m
% 2009-12-03 by Zhang Li
% Size Tuning Supression Index

% cut to stiend stimulus response
if nargin >2
    if stiend>0
        mr = mr(sti<=stiend);
        sti = sti(sti<=stiend);
    end
end

% SI is defined on stimuli other than background 1
bmr = mr(1);
mr = mr(2:end);
sti = sti(2:end);
r_max = max(mr);
if ~isfinite(r_max)
    si = NaN;
    s_max = NaN;
    s_min = NaN;
else
    maxind = find(mr==r_max);
    s_max = mean(sti(maxind));
    r_sur = mr(maxind(end):end);
    sti_sur = sti(maxind(end):end);
    r_sur_min = min(r_sur);
    s_min = mean(sti_sur(r_sur==r_sur_min));
    si = (r_max-r_sur_min)/(r_max-bmr);
end
