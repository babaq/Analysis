function [lci lcp]=diroricm(srm,roi,columnsize,lcliptimes,hcliptimes,method,isori,ainterp,issinglecondition,image)
% diroricm.m
% 2010-10-26 Zhang Li
% Direction and Orientation column map

csize = 3;
h = fspecial('average',csize);

if ischar(srm)
    t = findstr('_',srm);
    pfn = srm(1:t(end));
    sf = dir([pfn,'*.bmp']);
    sn = size(sf,1);
    theta_n = 2*pi/sn;
    for i=1:sn
        map = imread([pfn,num2str(i-1),'.bmp']);
        map = imfilter(map,h);
        s(:,:,i)=map;
    end
    srm = s;
    clear s;
    
    if issinglecondition
        d = size(srm);
        srm = squeeze(mat2cell(srm,d(1),d(2),ones(1,d(3))))';
        srm = singlecondition(srm);
        t=zeros(d);
        for i=1:d(3)
            t(:,:,i)=srm{i};
        end
        srm = t;
        clear t;
    end
    
end

for i=1:sn
    LC(:,:,i) = columnmap(srm(:,:,i),roi,columnsize,lcliptimes,hcliptimes,method);
end

if isori
    for i=1:sn/2
        t(:,:,i)=LC(:,:,i) | LC(:,:,i+sn/2);
    end
    LC = t;
    sn = sn/2;
else
end

cm = colormap_dom(sn);
hfigure=figure;
imagesc(image);
colormap(gray);
hold on;

for i=1:sn
    [c h]=imcontour(LC(:,:,i),1);
    set(h,'color',cm(i,:),'LineWidth',2)
    [lci{i} lcp{i}]=columns(LC);
    lcn = lci{i}.NumObjects;
    for j=1:lcn
        text(lcp{i}(j).Centroid(1),lcp{i}(j).Centroid(2),num2str(j),...
            'Color','w','HorizontalAlignment','Center','FontWeight','Bold' );
    end
    
    hold on;
    
end

mapanno(hfigure);
