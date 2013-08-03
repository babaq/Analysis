function [ data ] = rfecc( sessionindex )
%RFECC Summary of this function goes here
%   Detailed explanation goes here

sn = size(sessionindex,1);
vsn = 1;
for i =1:sn
    ec = sessionindex{i,3}.eccentricity;
    if ~isempty(ec)
        data.rfec(vsn,:) = ec;
        data.sindex(vsn) = i;
        vsn = vsn +1;
    end
end

end

