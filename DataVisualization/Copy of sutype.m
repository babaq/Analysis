function sutype(si,xtype,ytype,type,varargin)
% sutype.m
% 2011-06-08 by Zhang Li
% Distinguish single-unit excitatory/inhibitory type according to spike wave shape

extent = si.info.extent;
delay = si.info.delay;
stiend = si.info.stiend;
batchpath = si.info.batchpath;
unit = si.info.unit;
stitype = si.info.stitype;
freqrange = si.info.freqrange;
ssttype = si.info.ssttype;

if nargin < 2
    xtype = 'sd';
    ytype = 'hsw';
end
resolution = 10;
sdline = 0;
isline = 0;
switch type
    case 's'
        if ~isempty(varargin)
            isline = 1;
            sdline = varargin{1};
        end
    case 'h'
        if ~isempty(varargin)
            resolution = varargin{1};
        end
    case 'sw'
        if ~isempty(varargin)
            sdline = varargin{1};
            isnorm = varargin{2};
        end
end
switch xtype
    case 'sd'
        xu = 'Spike Duration (ms)';
        dec = 100;
    case 'hsw'
        xu = 'Half Spike Width (ms)';
        dec = 1000;
    case 'hasw'
        xu = 'Half After Spike Width (ms)';
        dec = 1000;
end
x = si.(xtype);
maxx = round(max(x)*dec)/dec;
minx = round(min(x)*dec)/dec;
rangex = maxx-minx;
bwx = rangex/resolution;
binx = minx-bwx:bwx:maxx+bwx;

if ~strcmp(ytype,'dist')
    y = si.(ytype);
    if ~strcmp(ytype,'sw')
        maxy = round(max(y)*dec)/dec;
        miny = round(min(y)*dec)/dec;
        rangey = maxy-miny;
        bwy = rangey/resolution;
        biny = miny-bwy:bwy:maxy+bwy;
    end
end
switch ytype
    case 'sd'
        yu = 'Spike Duration (ms)';
    case 'hsw'
        yu = 'Half Spike Width (ms)';
    case 'hasw'
        yu = 'Half After Spike Width (ms)';
    case 'dist'
        yu = 'Number of Cells';
    case {'sw','ssw'}
        xu = 'Samples';
        yu = '\muV';
        samplen = size(y,2);
end


textsize = 14;
fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_',xtype,'_',ytype,'_',ssttype,...
    '_',type];
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
n = length(x);
mcolor = [0.15 0.25 0.45];

binxx = binx(1:end-1)+bwx/2;
d = histc(x,binx);
xdist = d(1:end-1);
xmd = median(x);
ylimx = max(xdist);

switch type
    case 's'
        plot(x,y,'o','Linewidth',1,'MarkerSize',7,'MarkerEdgeColor',mcolor,'MarkerFaceColor',mcolor);
        if isline
            hold on;
            plot([sdline sdline],[0 2],'-r','Linewidth',2);
        end
        set(gca,'box','off','LineWidth',2,'FontSize',textsize,'YLim',[biny(1) biny(end)],'XLim',[binx(1) binx(end)]);
    case 'h'
        hB = bar(binxx,xdist,1);
        set(hB,'edgecolor','k','facecolor',mcolor,'LineWidth',1);
        hold on;
        plot([xmd xmd],[0 ylimx],'r','Linewidth',2);
        temp = round(binxx*dec)/dec;
        set(gca,'LineWidth',2,'FontSize',textsize,'tickdir','out','XTick',temp(1:2:end),'YTick',[0 ylimx],'YLim',[0 ylimx],'box','off');
    case 'sw'
        ii = find(x<=sdline);
        ei = find(x>sdline);
        if strcmp(isnorm,'n')
            wmax = max(abs(y),[],2);
            for i = 1:size(y,1)
                y(i,:) = y(i,:)./wmax(i);
                xx(i,:) = (1:samplen);
            end
        elseif strcmp(isnorm,'yn')
            wmax = max(y,[],2);
            wmin = min(y,[],2);
            wrange = wmax-wmin;
            for i = 1:size(y,1)
                y(i,:) = ((y(i,:)-wmin(i))/wrange(i))*2-1;
                xx(i,:) = (1:samplen);
            end
        else
            [wmax wmaxi] = max(y,[],2);
            mwmaxi = mean(wmaxi);
            [wmin wmini] = min(y,[],2);
            mwmini = mean(wmini);
            wrange = wmax-wmin;
            for i = 1:size(y,1)
                y(i,:) = ((y(i,:)-wmin(i))/wrange(i))*2-1;
                xx(i,:) = (1:samplen)+(mwmini-wmini(i));
            end
        end
        for i = ei
            plot(xx(i,:),y(i,:),'-r','LineWidth',2);
            hold on;
        end
        for i = ii
            plot(xx(i,:),y(i,:),'-b','LineWidth',2);
            hold on;
        end
        plot([0 samplen+1],[0 0],'-k','LineWidth',2);
        ylim = 1.1*max(max(abs(y)));
        set(gca,'LineWidth',2,'FontSize',textsize,'XTick',[1 samplen],'YTick',[-ylim 0 ylim],'YLim',[-ylim ylim],'XLim',[0 samplen+1]);
end

ylabel(yu,'FontSize',textsize);
xlabel(xu,'FontSize',textsize);
annotation('textbox',[0.24 0.8 0.1 0.1],'FontSize',textsize,'string',{['n=',num2str(n)]},'LineStyle','none');
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
