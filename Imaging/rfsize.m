function stc=rfsize(imagefile,ci,in,step)
% rfsize.m
% 2010-05-23 Zhang Li
% Direction and Spatial Frequency column receptive field size tuning curve

if nargin<3
    in = 8;
    step = 2;
end

images = cell(in,1);
t = findstr('_',imagefile);
for i=1:in
    images{i} = [imagefile(1:t(end)),int2str(i-1)];
end

cn = ci.NumObjects;
stc = zeros(cn,in);
for i=0:in-1
    m = imread(images{i+1},'bmp');
    crs = columnresponse(ci,m,'MeanIntensity');
    for j=1:cn
        stc(j,i+1)=crs(j).MeanIntensity;
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
    y = stc(i,:);
    x = (0:(in-1))*step;
    plot(x,abs(y-255));
    title(['Column\_',num2str(i)]);
    set(gca,'XLim',[-1 x(end)+1]);
    %axis off;
end

end % EOF
