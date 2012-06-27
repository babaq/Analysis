function cm = bipolar(m, n, interp)
% bipolar: symmetric/diverging/bipolar colormap, with neutral central color,
% warm colors for positive values, and cold colours for negative ones.
%
% Usage: cm = bipolar(m, neutral, interp)
%  neutral is the gray value for the middle of the colormap, default 1/3.
%  m is the number of rows in the colormap, defaulting to copy the current
%    colormap, or the colormap that MATLAB defaults for new figures.
%  interp is the method used to interpolate the colors, see interp1.
%
% The colormap goes from cyan-blue-neutral-red-yellow if neutral is < 0.5
% and if not, then from blue-cyan-neutral-yellow-red.
% 
% Examples:
%  surf(peaks)
%  cmx = max(abs(get(gca, 'CLim')));
%  set(gca, 'CLim', [-cmx cmx]);
%  colormap(bipolar)
%
%  imagesc(linspace(-1, 1,201)) % symmetric data, if not set symmetric CLim
%  colormap(bipolar(201, 0.1)) % dark gray as neutral
%  axis off; colorbar
%  pause(2)
%  colormap(bipolar(201, 0.9)) % light gray as neutral
%
% See also: colormap, jet, autumn, cool, gray, interp1

% Copyright 2009 Ged Ridgway at gmail com
% Based on Manja Lehmann's hand-crafted colormap for cortical visualisation

if ~exist('interp', 'var')
    interp = [];
end

if ~exist('m', 'var') || isempty(m)
    m = size(get(gcf, 'colormap'), 1);
end

if nargin < 2
    n = 1/3;
end

if n < 0
    % undocumented rainbow-variant colormap, not recommended, as explained 
    % by Borland & Taylor (2007) in IEEE Computer Graphics & Applications,
    % http://doi.ieeecomputersociety.org/10.1109/10.1109/MCG.2007.46
    if isempty(interp)
        interp = 'cubic'; % linear produces bands at pure green and yellow
    end
    n = abs(n);
    cm = [
        0 0 1
        0 1 0
        n n n
        1 1 0
        1 0 0
        ];
elseif n < 0.5
    if isempty(interp)
        interp = 'linear'; % seems to work well with dark neutral colors
    end
    cm = [
        0 1 1
        0 0 1
        n n n
        1 0 0
        1 1 0
        ];
else
    if isempty(interp)
        interp = 'cubic'; % seems to work better with bright neutral colors
    end

    cm = [
        0 0 1
        0 1 1
        n n n
        1 1 0
        1 0 0
        ];
end

if m ~= size(cm, 1)
    xi = linspace(1, size(cm, 1), m);
    cm = interp1(cm, xi, interp);
end
