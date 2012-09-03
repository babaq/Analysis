function RFMap_fBar_Draw(mapdata,RFData,ch,sort,condition,delay,isfit,iscontour)
% RFMap_fBar_Draw.m
% 2011-05-03 by Zhang Li
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
condition_max = RFData.Mark.key{3,2};

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

textsize=14;
fig_name = [RFData.Mark.extype,'__',RFData.Snip.spevent,...
    '__( C-',ch,'__U-',sort,' )__( S-',condition,' )__',delay,'msDelay',fit,ct];
scnsize = get(0,'ScreenSize');
output{1} = RFData.OutputDir;
output{2} = [fig_name,'_white'];
output{3} = RFData.Dinf.tank;
output{4} = RFData.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin_w = figure('Units','pixels',...
    'Position',[230 scnsize(4)*0.525 scnsize(4)*0.51 scnsize(4)*0.44], ...
    'Tag','Win_w', ...
    'Name',output{2},...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'Toolbar','none',...
    'Menubar','none',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output{2} = [fig_name,'_black'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin_b = figure('Units','pixels',...
    'Position',[230 + scnsize(4)*0.52 scnsize(4)*0.525 scnsize(4)*0.51 scnsize(4)*0.44], ...
    'Tag','Win_b', ...
    'Name',output{2},...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'Toolbar','none',...
    'Menubar','none',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output{2} = [fig_name,'_sub'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin_s = figure('Units','pixels',...
    'Position',[230 31 scnsize(4)*0.51 scnsize(4)*0.44], ...
    'Tag','Win_s', ...
    'Name',output{2},...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'Toolbar','none',...
    'Menubar','none',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output{2} = [fig_name,'_add'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin_a = figure('Units','pixels',...
    'Position',[230 + scnsize(4)*0.52 31 scnsize(4)*0.51 scnsize(4)*0.44], ...
    'Tag','Win_a', ...
    'Name',output{2},...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'Toolbar','none',...
    'Menubar','none',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fh{1} = hWin_w;
fh{2} = hWin_b;
fh{3} = hWin_s;
fh{4} = hWin_a;

color_n = 256;
cm{1} = colormap_rw(color_n);
cm{2} = colormap_bw(color_n);
cm{3} = colormap_rwb(color_n);
imf = fspecial('average',6); % image filter
cs='rb'; % color sequence
axiscolor = [1 1 1];
interptime = 6;
tickn = (0:0.25:1);
tick = tickn*(color_n-1)+1;
ls{1}='-';
ls{2}='--';


height = RFData.Mark.ckey{1,2};
width = RFData.Mark.ckey{2,2};
ori = RFData.Mark.ckey{3,2};
row = RFData.Mark.ckey{end-3,2};
column = RFData.Mark.ckey{end-2,2};
rstep = RFData.Mark.ckey{end-1,2};
cstep = RFData.Mark.ckey{end,2};
center_x = RFData.Mark.ckey{6,2};
center_y = RFData.Mark.ckey{7,2};
screen_h = floor(RFData.Mark.ckey{end-5,2});
screen_w = floor(RFData.Mark.ckey{end-4,2});

pos_h = (-(row-1)/2:(row-1)/2)*rstep;
pos_w = (-(column-1)/2:(column-1)/2)*cstep;
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
pos_wi = pos_w(1):cstep/(2^interptime):pos_w(end);
pos_hi = pos_h(1):rstep/(2^interptime):pos_h(end);


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
    mapb = squeeze(map(:,:,1,:));
    mapw = squeeze(map(:,:,2,:));
    
    mmaxb = max(max(max(mapb)));
    mminb = min(min(min(mapb)));
    mrangeb = mmaxb - mminb;
    mmaxw = max(max(max(mapw)));
    mminw = min(min(min(mapw)));
    mrangew = mmaxw - mminw;
    
    ticknyb = round((mminb + tickn * mrangeb)*dec)/dec;
    for t=1:length(tickn)
        ticklabelb{t} = num2str(ticknyb(t));
    end
    ticknyw = round((mminw + tickn * mrangew)*dec)/dec;
    for t=1:length(tickn)
        ticklabelw{t} = num2str(ticknyw(t));
    end
    
    mapdraw{1,1} = mapw;
    mapdraw{1,2} = [mminw mmaxw];
    mapdraw{1,3} = ticklabelw;
    mapdraw{2,1} = mapb;
    mapdraw{2,2} = [mminb mmaxb];
    mapdraw{2,3} = ticklabelb;
    
    
    if delay_n < 0 % All Delay Steps
        for d=1:size(mapb,3)
            
            for i=1:4
                if i<3
                    rfmap{i} = imrotate(squeeze(mapdraw{i,1}(:,:,d)),ori,'bicubic','crop');
                    rfmap{i} = interp2(rfmap{i},interptime,'cubic');
                    %rfmap{i} = imfilter(rfmap{i},imf,'replicate');
                    rfmap{i} = flipud(rfmap{i});
                    
                    y = mat2gray(rfmap{i},mapdraw{i,2});
                    [y, m] = gray2ind(y,color_n);
                    
                    figure(fh{i});
                    if iscontour
                        contourf(pos_wi,pos_hi,y,floor(color_n/15),'LineStyle','none');
                        caxis([1 color_n]);
                    else
                        image([pos_w(1) pos_w(end)],[pos_h(1) pos_h(end)],y);
                    end
                    colormap(cm{i});
                    colorbar('LineWidth',2,'FontSize',textsize,'YTick',tick,'YTickLabel',mapdraw{i,3});
                end
                
                if i==3
                    y = mat2gray(rfmap{1},mapdraw{1,2}) - mat2gray(rfmap{2},mapdraw{2,2});
                    y = (y+1)/2;
                    [y, m] = gray2ind(y,color_n);
                    
                    ticknybw = round((-1 + tickn * 2)*10)/10;
                    for t=1:length(tickn)
                        ticklabelbw{t} = num2str(ticknybw(t));
                    end
                    
                    figure(fh{i});
                    if iscontour
                        contourf(pos_wi,pos_hi,y,floor(color_n/15),'LineStyle','none');
                        caxis([1 color_n]);
                    else
                        image([pos_w(1) pos_w(end)],[pos_h(1) pos_h(end)],y);
                    end
                    colormap(cm{i});
                    colorbar('LineWidth',2,'FontSize',textsize,'YTick',tick,'YTickLabel',ticklabelbw);
                end
                
                if i==4
                    figure(fh{i});
                    for bw=1:2
                        y = mat2gray(rfmap{bw},mapdraw{bw,2});
                        
                        contour(pos_wi,pos_hi,y,(0.7:0.05:0.9),[ls{bw},cs(bw)],'Linewidth',2);
                        hold on;
                    end
                    hold off;
                end
                
                fig_name = get(gcf,'Name');
                t1 = findstr(fig_name,'__');
                t2 = findstr(fig_name,'msDelay');
                fig_name = [fig_name(1:t1(end)+1),num2str((d-1)*tstep_n),fig_name(t2:end)];
                
                set(gca,'LineWidth',2,'FontSize',textsize,'Color',axiscolor,'box','off','TickDir','out','YDir','normal',...
                    'DataAspectRatio',[1 1 1],'XTick',tickx,'YTick',ticky,'XLim',limx,'YLim',limy);
                title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
                
                mmovie{i}(d) = getframe(gcf);
            end
            
        end
        
        for i=1:4
            output = get(fh{i},'UserData');
            output{5} = mmovie{i};
            set(fh{i},'UserData',output);
        end
        
    else % single delay slice
        
        dind = floor(delay_n/tstep_n)+1;
        
        for i=1:4
            if i<3
                rfmap{i} = imrotate(squeeze(mapdraw{i,1}(:,:,dind)),ori,'bicubic','crop');
                rfmap{i} = interp2(rfmap{i},interptime,'cubic');
                %rfmap{i} = imfilter(rfmap{i},imf,'replicate');
                rfmap{i} = flipud(rfmap{i});
                
                y = mat2gray(rfmap{i},mapdraw{i,2});
                [y, m] = gray2ind(y,color_n);
                
                figure(fh{i});
                if iscontour
                    contourf(pos_wi,pos_hi,y,floor(color_n/15),'LineStyle','none');
                    caxis([1 color_n]);
                else
                    image([pos_w(1) pos_w(end)],[pos_h(1) pos_h(end)],y);
                end
                colormap(cm{i});
                colorbar('LineWidth',2,'FontSize',textsize,'YTick',tick,'YTickLabel',mapdraw{i,3});
                
                annotation(fh{i},'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
                    'String',{yu},'FitHeightToText','off','Position',[0.8645 0.895 0.25 0.07])
            end
            
            if i==3
                y = mat2gray(rfmap{1},mapdraw{1,2}) - mat2gray(rfmap{2},mapdraw{2,2});
                y = (y+1)/2;
                [y, m] = gray2ind(y,color_n);
                
                ticknybw = round((-1 + tickn * 2)*10)/10;
                for t=1:length(tickn)
                    ticklabelbw{t} = num2str(ticknybw(t));
                end
                
                figure(fh{i});
                if iscontour
                    contourf(pos_wi,pos_hi,y,floor(color_n/15),'LineStyle','none');
                    caxis([1 color_n]);
                else
                    image([pos_w(1) pos_w(end)],[pos_h(1) pos_h(end)],y);
                end
                colormap(cm{i});
                colorbar('LineWidth',2,'FontSize',textsize,'YTick',tick,'YTickLabel',ticklabelbw);
                
                annotation(fh{i},'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
                    'String',{yu},'FitHeightToText','off','Position',[0.8645 0.895 0.25 0.07])
            end
            
            if i==4
                figure(fh{i});
                for bw=1:2
                    y = mat2gray(rfmap{bw},mapdraw{bw,2});
                    
                    contour(pos_wi,pos_hi,y,(0.7:0.05:0.9),[ls{bw},cs(bw)],'Linewidth',2);
                    hold on;
                end
                hold off;
            end
            
            fig_name = get(gcf,'Name');
            xlabel('Position (degrees)','FontSize',textsize);
            ylabel('Position (degrees)','FontSize',textsize);
            set(gca,'LineWidth',2,'FontSize',textsize,'Color',axiscolor,'box','off','TickDir','out','YDir','normal',...
                'DataAspectRatio',[1 1 1],'XTick',tickx,'YTick',ticky,'XLim',limx,'YLim',limy);
            title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
        end
        
    end
end



function Win_CloseRequestFcn(hObject, eventdata, handles)

SaveFigure(hObject);

delete(hObject);