function ExportFig(hfig,format)
% ExportFig.m %
% 2011-08-02 Zhang Li
% Export Figure to File


% File Format
eps = '-depsc2';
ill = '-dill';
jpg = '-djpeg';
pdf = '-dpdf';
png = '-dpng';
svg = '-dsvg';
tif = '-dtiff';

dpi = '-r2400';

output = get(hfig,'UserData');
outputdir = output{1};
figname = output{2};
tank = output{3};
block = output{4};

cd(outputdir);
if (exist(tank,'dir'))
    cd(tank);
else
    mkdir(tank);
    cd(tank);
end
if (exist(block,'dir'))
    cd(block);
else
    mkdir(block);
    cd(block);
end


if nargin<2
    print(hfig,eps,'-tiff',dpi,figname);
else
    print(hfig,format,dpi,figname);
end


cd(outputdir);