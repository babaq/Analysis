function [ vp ] = visprofile( vps )
%VISPROFILE Summary of this function goes here
%   Detailed explanation goes here

if nargin < 1
    vps = '';
end

% Default Profile
vp.linewidth = 1;
vp.errorbarwidth = 0.5;
vp.textsize = 22;
vp.axiswidth = 0.5;
vp.titlesize = 14;
vp.markersize = 7;
vp.colorseq = 'rgbycm';
vp.barcolor = [0.15 0.25 0.45];
vp.maxtickn = 20;
vp.colorn = 256; % max = 65536
vp.axiscolor = [0 0 0];
vp.rd = 100; % rounding float digit to 2
vp.interptime = 4;
switch vps
    otherwise
        vps = 'Default';
end
vp.profilename = vps;

end

