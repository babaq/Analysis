function [  ] = exportfig( hfig,filename,format,dpi )
%EXPORTFIG Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    format = 'eps';
    dpi = 2400;
end

switch format
    case 'eps'
        format = '-depsc2';
    case 'ill'
        format = '-dill';
    case 'jpg'
        format = '-djpeg';
    case 'pdf'
        format = '-dpdf';
    case 'png'
        format = '-dpng';
    case 'svg'
        format = '-dsvg';
    case 'tif'
        format = '-dtiff';
end

dpi = ['-r',num2str(dpi)];

print(hfig,format,dpi,filename);

end

