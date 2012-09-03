function tmap=topology(imagefile,ci,in,division)
% topology.m
% 2010-05-23 Zhang Li
% Direction and Spatial Frequency column topology map

if nargin<3
    in = 9;
    division = 3;
end

images = cell(in,1);
t = findstr('_',imagefile);
for i=1:in
    images{i} = [imagefile(1:t(end)),int2str(i-1)];
end

cn = ci.NumObjects;
tmap = cell(cn,1);
for i=0:in-1
    m = imread(images{i+1},'bmp');
    crs = columnresponse(ci,m,'MeanIntensity');
    for j=1:cn
        tmap{j}(floor(i/division)+1,mod(i,division)+1)=crs(j).MeanIntensity;
    end
end

figure;
c = 4;
if (mod(cn,c)==0)
    r = cn/c;
else
    r = floor(cn/c)+1;
end
for i=1:cn
    subplot(r,c,i);
    contourf(mat2gray(interp2(tmap{i},2)));
    colormap(colormap_rwb);
    title(['Column\_',num2str(i)]);
    set(gca,'DataAspectRatio',[1 1 1]);
    axis off;
end

end % EOF
