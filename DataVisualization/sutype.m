function [ei ii]=sutype(si,type,varargin)
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


resolution = 10;
switch type
    case 's'
        xtype = varargin{1};
        ytype = varargin{2};
        ztype = varargin{3};
        x = si.(xtype);
        y = si.(ytype);
        z = si.(ztype);
        [xu xdec] = datatype(xtype);
        [yu ydec] = datatype(ytype);
        [zu zdec] = datatype(ztype);
        [maxx minx rangex bwx binx] = dataprepare(x,xdec,resolution);
        [maxy miny rangey bwy biny] = dataprepare(y,ydec,resolution);
        [maxz minz rangez bwz binz] = dataprepare(z,zdec,resolution);
        fname = [type,'-',xtype,'_',ytype,'_',ztype];
        n = length(x);
    case 'd'
        xtype = varargin{1};
        resolution = varargin{2};
        x = si.(xtype);
        [xu xdec] = datatype(xtype);
        [maxx minx rangex bwx binx] = dataprepare(x,xdec,resolution);
        [d dx dm dmax] = dist(x,binx);
        yu = 'Number of Cells';
        fname = [type,'-',xtype];
        n = length(x);
    case 'w'
        xtype = varargin{1};
        ytype = varargin{2};
        border = varargin{3};
        wtype = varargin{4};
        x = si.(xtype);
        y = si.(ytype);
        xu = 'Samples';
        n = size(x,1);
        samplen = size(x,2);
        fname = [type,'-',xtype,'_',num2str(border*1000),'usBorderOf_',ytype,'_',wtype];
end
%% Get Data Range and Bin
    function [maxx minx rangex bwx binx] = dataprepare(x,dec,resolution)
        maxx = round(max(x)*dec)/dec;
        minx = round(min(x)*dec)/dec;
        rangex = maxx-minx;
        bwx = rangex/resolution;
        binx = minx-bwx:bwx:maxx+bwx;
    end
%% Get Data Type Label
    function [u dec] = datatype(dtype)
        switch dtype
            case 'sd'
                u = 'Spike Duration (ms)';
                dec = 100;
            case 'hsw'
                u = 'Half Spike Width (ms)';
                dec = 1000;
            case 'hasw'
                u = 'Half AfterSpike Width (ms)';
                dec = 100;
                case 'ar'
                u = 'Amplitude Ratio';
                dec = 100;
        end
    end
%% Get Data Distribution
    function [d dx dm dmax] = dist(x,bin)
        d = histc(x,bin);
        d = d(1:end-1);
        dx = bin(1:end-1)+(bin(2)-bin(1))/2;
        dm = median(x);
        dmax = max(d);
    end
%% Draw
textsize = 14;
fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_',ssttype,'_',fname];
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
mcolorg = [0.25 0.85 0.35];
mcolorr = [0.85 0.15 0.05];

switch type
    case 's'
        plot3(x,y,z,'o','Linewidth',1,'MarkerSize',7,'MarkerEdgeColor',mcolorb,'MarkerFaceColor',mcolorg);
        set(gca,'box','on','LineWidth',2,'FontSize',textsize,'DataAspectRatio',[1 1 1],...
            'YLim',[biny(1) biny(end)],'XLim',[binx(1) binx(end)],'ZLim',[binz(1) binz(end)]);
        zlabel(zu,'FontSize',textsize);
    case 'd'
        hB = bar(dx,d,1);
        set(hB,'edgecolor','k','facecolor',mcolorb,'LineWidth',1);
        hold on;
        plot([dm dm],[0 dmax],'r','Linewidth',2);
        temp = round(dx*xdec)/xdec;
        set(gca,'box','off','LineWidth',2,'FontSize',textsize,'tickdir','out',...
            'XTick',temp(1:2:end),'XLim',[temp(1) temp(end)],'YTick',[0 dmax],'YLim',[0 dmax]);
    case 'w'
        ii = find(y<border);
        ei = find(y>=border);
        switch wtype
            case {'n','nl','nh'}
                [wmax wmaxi] = max(x,[],2);
                [wmin wmini] = min(x,[],2);
                wrange = wmax-wmin;
                mwmaxi = mean(wmaxi);
                mwmini = mean(wmini);
                for i = 1:n
                    x(i,:) = ((x(i,:)-wmin(i))/wrange(i))*2-1;
                    if strcmp(wtype(end),'l')
                        sampleshift = mwmini - wmini(i);
                    elseif strcmp(wtype(end),'h')
                        sampleshift = mwmaxi - wmaxi(i);
                    else
                        sampleshift = 0;
                    end
                    wx(i,:) = (1:samplen) + sampleshift;
                end
                yu = 'Normalized Voltage';
            otherwise
                for i = 1:n
                    wx(i,:) = 1:samplen;
                end
                yu = '\muV';
        end
        
        for i = ei
            plot(wx(i,:),x(i,:),'-','LineWidth',2,'color',mcolorr);
            hold on;
        end
        for i = ii
            plot(wx(i,:),x(i,:),'-','LineWidth',2,'color',mcolorb);
            hold on;
        end
        plot([0 samplen+1],[0 0],'-k','LineWidth',2);
        ylim = 1.2*max(max(abs(x)));
        set(gca,'LineWidth',2,'FontSize',textsize,'XTick',[1 samplen],'XLim',[0 samplen+1],...
            'YTick',[-ylim 0 ylim],'YLim',[-ylim ylim]);
end

ylabel(yu,'FontSize',textsize);
xlabel(xu,'FontSize',textsize);
annotation('textbox',[0.24 0.8 0.1 0.1],'FontSize',textsize,'string',{['n=',num2str(n)]},'LineStyle','none');
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);

end %eof