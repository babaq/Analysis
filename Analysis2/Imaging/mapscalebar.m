function si = mapscalebar(image)
% mapscalebar.m
% 2010-05-31 Zhang Li
% Add scalebar on Map

si = image;
imagesize = size(image,1);
switch imagesize
    case 768
        mm = 210;
end

si(end-50:end-45,50:50+mm)=0;