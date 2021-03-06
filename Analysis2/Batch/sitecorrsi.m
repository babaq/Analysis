function sitecorrsi(si,type,varargin)
% sitecorrsi.m %
% 2011-06-09 by Zhang Li
% Draw Size Tuning Statistics

extent = si.info.extent;
delay = si.info.delay;
stiend = si.info.stiend;
batchpath = si.info.batchpath;
unit = si.info.unit;
stitype = si.info.stitype;
freqrange = si.info.freqrange;
ssttype = si.info.ssttype;


z = si.site;
zu = 'Recording Site Depth (\mum)';
zlim = 3000;%max(z)+100;
dec = 1000;
switch type
    case 'sf'
        stat = varargin{1};
        xtype = [stat,'s'];
        ytype = [stat,'f'];
        x = si.(xtype);
        y = si.(ytype);
        [xu lim] = datatype(xtype);
        n1 = length(x);
        n2 = n1;
        z1 = z;
        z2 = z;
    case 'su'
        stat = varargin{1};
        ei = varargin{2};
        ii = varargin{3};
        xtype = [stat,'s'];
        x = si.(xtype);
        [xu lim] = datatype(xtype);
        n1 = length(ei);
        n2 = length(ii);
        y = x(ii);
        x = x(ei);
        z1 = z(ei);
        z2 = z(ii);
    case 'sc'
        x = si.(type);
        stat = '';
        [xu lim] = datatype(type);
        n1 = length(x);
        n2 = n1;
        z1 = z;
        z2 = z;
        y = x;
end


    function [u lim] = datatype(dtype)
        switch dtype
            case {'sis','sif','sisc'}
                lim = si.bin(end)*2;
                u = 'SI';
            case 'sc'
                lim = 1.4;
                u = 'F1/F0';
            case {'fgs','fgf','fgsc'}
                lim = si.bin(end);
                u = 'Fit Adj-R^2';
            case {'maxs','mins','maxf','minf','maxsc','minsc','res','ris','ref','rif','resc','risc'}
                lim = si.bin(end)*stiend;
                u = 'Stimulus Diameter (degrees)';
        end
    end


[rx rxp] = corr(x',z1','type','spearman','rows','pairwise','tail','ne');
[ry ryp] = corr(y',z2','type','spearman','rows','pairwise','tail','ne');

textsize = 14;
fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_',ssttype,'_',type,'_',stat];
scnsize = get(0,'ScreenSize');
output{1} = batchpath;
output{2} = fig_name;
output{3} = unit;
output{4} = stitype;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mcolorb = [0.15 0.25 0.55];
mcb = ['{',num2str(mcolorb),'}'];
mcolorg = [0.25 0.85 0.35];
mcolorr = [0.85 0.15 0.05];
mcr = ['{',num2str(mcolorr),'}'];

plot(x,z1,'o','Linewidth',1,'MarkerSize',7,'MarkerEdgeColor','none','MarkerFaceColor',mcolorr);
hold on;
plot(y,z2,'o','Linewidth',1,'MarkerSize',7,'MarkerEdgeColor','none','MarkerFaceColor',mcolorb);
set(gca,'LineWidth',2,'FontSize',textsize,'YLim',[0 zlim],'XLim',[0 lim],'box','off','YDir','reverse');

annotation('textbox',[0.14 0.8 0.1 0.1],'FontSize',textsize,'LineStyle','none',...
    'string',{['n=\color[rgb]',mcr,num2str(n1),'\color{black}, \color[rgb]',mcb,num2str(n2)],...
    ['\color{black}r_s=\color[rgb]',mcr,num2str(round(rx*dec)/dec),'\color{black}, \color[rgb]',mcb,num2str(round(ry*dec)/dec)],...
    ['\color{black}p=\color[rgb]',mcr,num2str(round(rxp*dec)/dec),'\color{black}, \color[rgb]',mcb,num2str(round(ryp*dec)/dec)]});
ylabel(zu,'FontSize',textsize);
xlabel(xu,'FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);

end %eof