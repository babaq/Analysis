function [ hf ] = newfig( name,tag )
%NEWFIG Summary of this function goes here
%   Detailed explanation goes here

import Analysis.Visualization.FigDeleteFcn
if nargin < 2
    tag = '';
end

scrsz = get(0,'ScreenSize');
hf = figure('Units','pixels',...
    'Position',[scrsz(3)*0.1 scrsz(4)*0.1 scrsz(3)*0.85 scrsz(4)*0.8],...
    'Tag',tag,...
    'Name',name,...
    'NumberTitle','off',...
    'DeleteFcn',@FigDeleteFcn);

end

