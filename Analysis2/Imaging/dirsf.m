function [lci hci]=dirsf(LC, HC, image)
% dirsf.m
% 2010-05-23 Zhang Li
% Direction and Spatial Frequency map

image = mapscalebar(image);
hfigure=figure;
imagesc(image);
colormap(gray);
hold on;

[c h]=imcontour(LC,1,'r');
set(h,'LineWidth',2);
[c h]=imcontour(HC,1,'b');
set(h,'LineWidth',2);
[lci lcp]=columns(LC);
lcn = lci.NumObjects;
for i=1:lcn
    text(lcp(i).Centroid(1),lcp(i).Centroid(2),num2str(i),...
        'Color','w','HorizontalAlignment','Center','FontWeight','Bold' );
end
[hci hcp]=columns(HC);
hcn = hci.NumObjects;
for i=1:hcn
    text(hcp(i).Centroid(1),hcp(i).Centroid(2),num2str(i),...
        'Color','k','HorizontalAlignment','Center','FontWeight','Bold');
end

mapanno(hfigure);
