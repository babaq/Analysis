function [columnindex columnproperty] = columns(columnmap)
% columns.m
% 2010-05-23 Zhang Li
% Columns of columnmap

columnindex = bwconncomp(columnmap);
columnproperty = regionprops(columnindex);

end % eof