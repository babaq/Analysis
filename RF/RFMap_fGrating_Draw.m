function RFMap_fGrating_Draw(mapdata,RFData,ch,sort,condition,delay,isfit,iscontour)
% RFMap_fGrating_Draw.m
% 2011-05-12 by Zhang Li
% Draw Reverse-Correlation RF Map


tstep_n = mapdata{end,1}.step; % ms
if strcmpi(ch,'ALL')
    ch_n = 0;
else
    ch_n = str2double(ch);
end
ch_max = RFData.Snip.chn;

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

if strcmpi(condition,'ALL')
    condition_n = 0;
else
    condition_n = str2double(condition);
end
if strcmpi(delay,'ALL')
    delay_n = -1;
else
    delay_n = str2double(delay);
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
dec = 1;
yu = 'Response (spikes/sec)';

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

textsize = 14;
fig_name = [RFData.Mark.extype,'__',RFData.Snip.spevent,...
    '__( C-',ch,'__U-',sort,' )__( S-',condition,' )__',delay,'msDelay',fit,ct];
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
imf = fspecial('average',6); % image filter
cs='rgbkycm'; % color sequence
axiscolor = [0 0 0];
interptime = 6;
tickn = (0:0.25:1);
tick = tickn*(color_n-1)+1;


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
pos_wi = pos_w(1):step/(2^interptime):pos_w(end);
pos_hi = pos_h(1):step/(2^interptime):pos_h(end);


if ch_n==0 % ALL Channal
    for i=1:ch_max
        map = mapdata{i,end};
        
        if delay_n < 0 % All Time Delays
            
        else % single delay slice
            
            map_b = squeeze(map(:,:,:,1,delay_n/tstep_n+1));
            map_w = squeeze(map(:,:,:,2,delay_n/tstep_n+1));
            map = map_w - map_b;
            
            map_b = squeeze(mean(map_b));
            map_w = squeeze(mean(map_w));
            map = squeeze(mean(map));
            
            map_b = imrotate(map_b,ori,'bicubic','crop');
            map_b = imfilter(map_b,h,'replicate');
            rfmap{1,3} = map_b;
            map_w = imrotate(map_w,ori,'bicubic','crop');
            map_w = imfilter(map_w,h,'replicate');
            rfmap{1,2} = map_w;
            map = imrotate(map,ori,'bicubic','crop');
            map = imfilter(map,h,'replicate');
            rfmap{1,1} = map;
            
            if isfit % fit to screen
                mapmax = max(max(rfmap{1}));
                mapedge = mapmax*(0.7:0.1:1);
                contour((0:columns-1)*width+center_x,(0:rows-1)*height+center_y,rfmap{1},mapedge,cs(i),'LineWidth',2);
                hold on;
            else
                
            end
            
        end
        
    end
    
    plot(0,0,'+r','LineWidth',3,'MarkerSize',8);
    
    title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);
    ylabel('Position(deg)');
    xlabel('Position(deg)');
    
    set(gca,'DataAspectRatio',[1 1 1],'XLim',[-screen_w/2 screen_w/2],'YLim',[-screen_h/2 screen_h/2],...
        'XTick',-screen_w/2:2:screen_w/2,'YTick',-screen_h/2:2:screen_h/2);
    
else % single channal
    
    map = squeeze(mean(mapdata{ch_n,sort_n},1));
    if issurround
        for d=1:size(map,3)
            map(:,:,d) = map(:,:,d) - map(center_index,center_index,d);
        end
    end
    
    mmin = min(min(min(map)));
    mmax = max(max(max(map)));
    mrange = mmax - mmin;
    tickny = round((mmin + tickn * mrange)*dec)/dec;
    for t=1:length(tickn)
        ticklabel{t} = num2str(tickny(t));
    end
    
    if delay_n < 0 % All Delay Steps
        
        for d=1:size(map,3)
            rfmap = squeeze(map(:,:,d));
            rfmap = interp2(rfmap,interptime,'cubic');
            %rfmap = imfilter(rfmap,imf,'replicate');
            y = flipud(rfmap);
            y = mat2gray(y,[mmin mmax]);
            [y, m] = gray2ind(y,color_n);
            
            if iscontour
                contourf(pos_wi,pos_hi,y,floor(color_n/15),'LineStyle','none');
                caxis([1 color_n]);
            else
                image([pos_w(1) pos_w(end)],[pos_h(1) pos_h(end)],y);
            end
            
            colormap(cm);
            colorbar('LineWidth',2,'FontSize',textsize,'YTick',tick,'YTickLabel',ticklabel);
            annotation(hWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
                'String',{yu},'FitHeightToText','off','Position',[0.8645 0.895 0.25 0.07])
            
            if issurround
                hold on;
                plot(cx,cy1,':k',cx,cy2,':k','LineWidth',1);
                hold off;
            end
            
            t1 = findstr(fig_name,'__');
            t2 = findstr(fig_name,'msDelay');
            fig_name = [fig_name(1:t1(end)+1),num2str((d-1)*tstep_n),fig_name(t2:end)];
            
            xlabel('Position (degrees)','FontSize',textsize);
            ylabel('Position (degrees)','FontSize',textsize);
            set(gca,'LineWidth',2,'FontSize',textsize,'Color',axiscolor,'box','off','TickDir','out','YDir','normal',...
                'DataAspectRatio',[1 1 1],'XTick',tickx,'YTick',ticky,'XLim',limx,'YLim',limy);
            title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
            
            mmovie(d) = getframe(gcf);
        end
        
        output{5} = mmovie;
        set(gcf,'UserData',output);
        
    else % single delay slice
        
        rfmap = squeeze(map(:,:,floor(delay_n/tstep_n)+1));
        rfmap = interp2(rfmap,interptime,'cubic');
        %rfmap = imfilter(rfmap,imf,'replicate');
        y = flipud(rfmap);
        y = mat2gray(y,[mmin mmax]);
        [y, m] = gray2ind(y,color_n);
        
        if iscontour
            contourf(pos_wi,pos_hi,y,floor(color_n/15),'LineStyle','none');
            caxis([1 color_n]);
        else
            image([pos_w(1) pos_w(end)],[pos_h(1) pos_h(end)],y);
        end
        
        colormap(cm);
        colorbar('LineWidth',2,'FontSize',textsize,'YTick',tick,'YTickLabel',ticklabel);
        annotation(hWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
            'String',{yu},'FitHeightToText','off','Position',[0.8645 0.895 0.25 0.07])
        
        if issurround
            hold on;
            plot(cx,cy1,':k',cx,cy2,':k','LineWidth',1);
            hold off;
        end
        
        xlabel('Position (degrees)','FontSize',textsize);
        ylabel('Position (degrees)','FontSize',textsize);
        set(gca,'LineWidth',2,'FontSize',textsize,'Color',axiscolor,'box','off','TickDir','out','YDir','normal',...
            'DataAspectRatio',[1 1 1],'XTick',tickx,'YTick',ticky,'XLim',limx,'YLim',limy);
        title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
        
    end
end



function Win_CloseRequestFcn(hObject, eventdata, handles)

SaveFigure(hObject);

delete(hObject);