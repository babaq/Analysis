function [ vp ] = visprofile( vps )
%VISPROFILE Summary of this function goes here
%   Detailed explanation goes here

% Default Profile
vp.linewidth = 1;
vp.errorbarwidth = 0.5;
vp.textsize = 22;
vp.axiswidth = 0.5;
vp.titlesize = 14;
vp.markersize = 7;
vp.colorseq = 'rgbycm';
vp.barcolor = [0.15 0.25 0.45];
switch vps
    otherwise
        vps = 'Default';
end
vp.profilename = vps;

end

