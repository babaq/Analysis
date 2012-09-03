function r = columnresponse(ci,image,props)
% columnresponse.m
% 2010-05-23 Zhang Li
% Columns response of optic imaging data

if nargin<3
    props = 'all';
end

r = regionprops(ci,image,props);

end % eof