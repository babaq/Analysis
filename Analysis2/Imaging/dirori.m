function [anglemap ampmap] = dirori(srm,roi,isori,ainterp,issinglecondition)
% dirori.m
% 2010-06-22 Zhang Li
% Direction and Orientation Column Map

if nargin <2
    roi = [];
    isori = 1;
    ainterp =1;
    issinglecondition = 1;
elseif nargin <3
    isori = 1;
    ainterp = 1;
    issinglecondition = 1;
elseif nargin <4
    ainterp = 1;
    issinglecondition = 1;
elseif nargin <5
    issinglecondition = 1;
end

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
        if ~isempty(roi)
            map = map(roi(1):roi(2),roi(3):roi(4));
        end
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

sm=[];
for i=1:sn
    theta = (i-1)*theta_n;
    t = mat2gray(squeeze(srm(:,:,i)));
    t = abs(t-1);
    t = complex(t*cos(theta),t*sin(theta));
    sm=cat(3,sm,t);
end
vsum = squeeze(sum(sm,3));
anglemap = pha2con(angle(vsum));
ampmap = abs(vsum);

if isori
    amax = pi;
    anglemap(anglemap>pi)=anglemap(anglemap>pi)-pi;
    an = sn/2*ainterp;
    theta_n_ahalf = pi/an/2;
    anglemap(anglemap>(pi-theta_n_ahalf)) = anglemap(anglemap>(pi-theta_n_ahalf))-pi;
    anglemap = mat2gray(anglemap,[0 amax]-theta_n_ahalf);
else
    amax = 2*pi;
    an = sn * ainterp;
    theta_n_ahalf = 2*pi/an/2;
    anglemap(anglemap>(2*pi-theta_n_ahalf)) = anglemap(anglemap>(2*pi-theta_n_ahalf))-2*pi;
    anglemap = mat2gray(anglemap,[0 amax]-theta_n_ahalf);
end


%% angle map
csize = 1;
h = fspecial('average',csize);

figure;
tanglemap = imfilter(anglemap,h);
imagesc(tanglemap);
colormap(colormap_dom(an));
tick = (0:1/an:1);
tick = tick(1:end-1);
for t=1:length(tick)
    cblabel{t} = num2str(circ_rad2ang(tick(t)*amax));
end
colorbar('YTick',tick+1/an/2,'YTickLabel',cblabel);


%% amplitude angle map
tanglemap = ind2rgb(floor(anglemap*an)+1,colormap_dom(an));
ampmean = mean2(ampmap);
ampstd = std2(ampmap);
stdn = 2;
nampmap = mat2gray(ampmap,[ampmean-stdn*ampstd ampmean+stdn*ampstd]);
for i=1:3
    aamap(:,:,i) = nampmap.*tanglemap(:,:,i);
end
figure;
taamap = imfilter(aamap,h);
imagesc(taamap);
colormap(colormap_dom(an));
colorbar('YTick',tick+1/an/2,'YTickLabel',cblabel);


%% angle gradient map
[fx fy] = gradient(anglemap);
g = complex(fx,fy);
gamp = abs(g);
figure;
tgamp = imfilter(gamp,h);
imagesc(tgamp);
colormap(jet);
%% Iso-line map

%% column contour map
csize = 30;
h = fspecial('average',csize);
ac = imfilter(anglemap,h);
figure;
contour(ac,an);
colormap(colormap_dom(an));
set(gca,'YDir','reverse');
colorbar('YTick',tick+1/an/2,'YTickLabel',cblabel);


end % eof