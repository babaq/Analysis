function [lci hci]=bloodcolumn(imagefile,lc,hc)
% bloodcolumn.m
% 2010-05-29 Zhang Li
% Columns on Blood Map

image = imread(imagefile,'bmp');
[lci hci] = dirsf(lc,hc,image);

end % eof