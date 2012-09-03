function [LC HC image] = columnmap(imagefile,roi,columnsize,lcliptimes,hcliptimes,method)
% columnmap.m
% 2010-05-22 Zhang Li
% Column map of optic imaging data

if nargin<3
end

if ischar(imagefile)
    image = imread(imagefile,'bmp');
else
    image = imagefile;
end
LC = false(size(image));
HC = false(size(image));
ROI = image(roi(1):roi(2),roi(3):roi(4));

h = fspecial('average',columnsize);
ROI=imfilter(ROI,h,'replicate');
method = lower(method);
switch (method)
    case 'std'
        imean = mean2(ROI);
        istd = std2(ROI);
        lc = im2bw(ROI,(imean-lcliptimes*istd)/255);
        hc = im2bw(ROI,(imean+hcliptimes*istd)/255);
        LC(roi(1):roi(2),roi(3):roi(4))=~lc;
        lcr = columnsize*(1-lcliptimes*istd/imean)/2;
        LC = bwareaopen(LC,floor(pi*lcr^2));
        HC(roi(1):roi(2),roi(3):roi(4))=hc;
        hcr = columnsize*(1-hcliptimes*istd/imean)/2;
        HC = bwareaopen(HC,floor(pi*hcr^2));
    case 'der'
        dROI = double(ROI);
        x = diff(dROI,1,1);
        x = imfilter(x,h,'replicate');
        y = diff(dROI,1,2);
        y = imfilter(y,h,'replicate');
        xx = diff(x,1,1);
        xx = imfilter(xx,h,'replicate');
        yy = diff(y,1,2);
        yy = imfilter(yy,h,'replicate');
        xx = xx(:,2:end-1);
        yy = yy(2:end-1,:);
        
        xxmax = max(max(xx));
        xxmin = min(min(xx));
        xx = mat2gray(xx,[xxmin xxmax]);
        xxzeroratio = (0-xxmin)/(xxmax-xxmin);
        yymax = max(max(yy));
        yymin = min(min(yy));
        yy = mat2gray(yy,[yymin yymax]);
        yyzeroratio = (0-yymin)/(yymax-yymin);
        
        hxb = im2bw(xx,xxzeroratio+lcliptimes);
        lxb = ~im2bw(xx,xxzeroratio-hcliptimes);
        hyb = im2bw(yy,yyzeroratio+lcliptimes);
        lyb = ~im2bw(yy,yyzeroratio-hcliptimes);
        
        LC(roi(1)+1:roi(2)-1,roi(3)+1:roi(4)-1)=hxb&hyb;
        lcr = columnsize*(1-lcliptimes)/2;
        LC = bwareaopen(LC,floor(pi*lcr^2));
        HC(roi(1)+1:roi(2)-1,roi(3)+1:roi(4)-1)=lxb&lyb;
        hcr = columnsize*(1-hcliptimes)/2;
        HC = bwareaopen(HC,floor(pi*hcr^2));
end

end % eof