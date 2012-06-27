function RFMap_Grating_Draw(mapdata,RFData,delay,ch,sort,isfit,iscontour)
% RFMap_Grating_Draw.m
% 2012-04-22 by Zhang Li
% Draw RF Map


datatype = mapdata{end,1}.datatype;
if strcmpi(ch,'ALL')
    ch_n = 0;
else
    ch_n = str2double(ch);
end
ch_max = RFData.Snip.chn;

switch datatype
    case 'Snip'
        Ev = RFData.Snip.spevent;
        if strcmpi(sort,'NOSORT')
            errordlg('NO SORT DATA TO SHOW !','Data Error');
            return;
        elseif strcmpi(sort,'MU')
            if ch_n~=0
                sort_n = RFData.Snip.ppsortn(ch_n);
            end
        else
            sort_n = str2double(sort(3:end));
        end
        dec = 1;
        yu = 'Firing Rate (spikes/sec)';
    case {'rms','max','min'}
        Ev = RFData.Wave.wvevent;
        sort_n=1;
        dec = 10;
        yu = '\muV';
    case {'power'}
        Ev = RFData.Wave.wvevent;
        sort_n=1;
        dec = 10;
        yu = '\muV^2';
end

if isfit
    fit='_fit';
else
    fit='';
end
if iscontour
    ct='_contour';
else
    ct='';
end

if strcmp(RFData.Mark.extype,'RF_Surround')
    issurround = true;
    centerR = RFData.Mark.ckey{end-3,2}/2;
    cx=-centerR:0.02*centerR:centerR;
    cy1 = sqrt(centerR^2-cx.^2);
    cy2 = -cy1;
else
    issurround = false;
    cx=0;
    cy1=0;
    cy2=0;
end

textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fig_name = [RFData.Mark.extype,'__',Ev,...
    '__( C-',ch,'__U-',sort,' )__',delay,'msDelay_',datatype,fit,ct];
scnsize = get(0,'ScreenSize');
output{1} = RFData.OutputDir;
output{2} = fig_name;
output{3} = RFData.Dinf.tank;
output{4} = RFData.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin = figure('Units','pixels',...
    'Position',[250 30 scnsize(4) scnsize(4)*0.86], ...
    'Tag','Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
color_n = 256;
cm = jet(color_n);
cs=['rgbkycm','rgbkycm']; % color sequence
axiscolor = [0 0 0];
interptime = 4;
imf = fspecial('average',(3-1)^(interptime)+1); % image filter


row = RFData.Mark.key{3,2};
center_x = RFData.Mark.ckey{8,2};
center_y = RFData.Mark.ckey{9,2};
screen_h = floor(RFData.Mark.ckey{end-2,2});
screen_w = floor(RFData.Mark.ckey{end-1,2});
step = RFData.Mark.ckey{end,2};

center_index = (row-1)/2 +1;
pos_h = (-(row-1)/2:(row-1)/2)*step;
pos_w = pos_h;
if isfit
    pos_h = pos_h + center_y;
    pos_w = pos_w + center_x;
    
    limx = [-screen_w/2 screen_w/2];
    limy = [-screen_h/2 screen_h/2];
    tickx = limx(1):5:limx(2);
    ticky = limy(1):5:limy(2);
    cm = gray(color_n);
    
    cx = cx + center_x;
    cy1 = cy1 + center_y;
    cy2 = cy2 + center_y;
else
    limx = [pos_w(1) pos_w(end)];
    limy = [pos_h(1) pos_h(end)];
    tickx = pos_w;
    ticky = pos_h;
end


if ch_n==0 % ALL Channal
    for i=1:ch_max
        map=0;
        sort_max = RFData.Snip.sortnumber(i);
        for j=1:sort_max
            map = map+mapdata{i,j};
        end
        map = imrotate(map,str2double(condition),'bicubic','crop');
        map = imfilter(map,imf,'replicate');
        mapmax = max(max(map));
        mapedge = mapmax*(0.7:0.1:1);
        
        contour(pos_w,pos_h,map,mapedge,cs(i),'LineWidth',2);
        hold on;
    end
    width = [-screen_w screen_w]/2;
    height = [-screen_h screen_h]/2;
    plot(width,ones(1,2)*screen_h/2,'-.+r','LineWidth',1);
    hold on;
    plot(width,-ones(1,2)*screen_h/2,'-.+r','LineWidth',1);
    hold on;
    plot(-ones(1,2)*screen_w/2,height,'-.+r','LineWidth',1);
    hold on;
    plot(ones(1,2)*screen_w/2,height,'-.+r','LineWidth',1);
    hold on;
    plot(0,0,'+r','LineWidth',3,'MarkerSize',8);
    
else % single channal
    
    map = squeeze(mean(mapdata{ch_n,sort_n},1));
    cmap = map(center_index,center_index);
    %     if issurround
    %         map = map - cmap;
    %         map = map/cmap;
    %     end
    
    if iscontour
        map = interp2(map,interptime,'cubic');
        %map = imfilter(map,imf,'replicate');
        y = flipud(map);
        
        pos_w = pos_w(1):step/(2^interptime):pos_w(end);
        pos_h = pos_h(1):step/(2^interptime):pos_h(end);
        contourf(pos_w,pos_h,y,'LineStyle','none');
        colorbar();
    else
        map = interp2(map,interptime,'cubic');
        %map = imfilter(map,imf,'replicate');
        y = flipud(map);
        
        mmin = min(min(y));
        mmax = max(max(y));
        mrange = mmax-mmin;
        y = mat2gray(y,[mmin mmax]);
        [y, m] = gray2ind(y,color_n);
        
        image([pos_w(1) pos_w(end)],[pos_h(1) pos_h(end)],y);
        colormap(cm);
        
        tickn = (0:0.25:1);
        tick = tickn*(color_n-1)+1;
        tickny = round((mmin + tickn * mrange)*dec)/dec;
        for t=1:length(tickn)
            ticklabel{t} = num2str(tickny(t));
        end
        colorbar('LineWidth',axiswidth,'FontSize',textsize,'YTick',tick,'YTickLabel',ticklabel);
        
        annotation(hWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
            'String',{yu},'FitHeightToText','off','Position',[0.8645 0.895 0.25 0.07])
    end
    
    if issurround
        hold on;
        plot(cx,cy1,':k',cx,cy2,':k','LineWidth',linewidth);
        annotation(hWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
            'String',{[num2str(RFData.Mark.ckey{5,2}),'\circ']},'FitHeightToText','off','Position',[0.43 0.5 0.25 0.07])
        hold off;
    end
    
end

xlabel('Position (degrees)','FontSize',textsize);
ylabel('Position (degrees)','FontSize',textsize);
set(gca,'LineWidth',axiswidth,'FontSize',textsize,'Color',axiscolor,'box','off','TickDir','out','YDir','normal',...
    'DataAspectRatio',[1 1 1],'XTick',tickx,'YTick',ticky,'XLim',limx,'YLim',limy);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);

