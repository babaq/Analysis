function RFMap_fBar_Draw(mapdata,RFData,ch,sort,condition,delay,tstep_n,isfit,iscontour)
% RFMap_fBar_Draw.m
% 2009-01-03 by Zhang Li
% Draw Reverse-Correlation RF Map

if strcmpi(ch,'ALL')
    ch_n = 0;
else
    ch_n = str2double(ch);
end
ch_max = RFData.Snip.chn;

if strcmpi(condition,'ALL')
    condition_n = 0;
else
    condition_n = str2double(condition);
    ind = findstr(condition,'.');
    if ~isempty(ind)
        condition(ind) = '_';
    end
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

fig_name = [RFData.Mark.extype,' __ ',RFData.Snip.spevent,...
        ' __( C-',ch,'__U-',sort,' )__( S-',condition,' )__',delay,'delay',ct,fit];
scnsize = get(0,'ScreenSize');
output{1} = RFData.OutputDir;
output{2} = [fig_name,'_white'];
output{3} = RFData.Dinf.tank;
output{4} = RFData.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MWin_w = figure('Units','pixels',...
    'Position',[230 scnsize(4)*0.525 scnsize(4)*0.51 scnsize(4)*0.44], ...
    'Tag','M_Win_w', ...
    'Name',output{2},...
    'CloseRequestFcn',@MWin_CloseRequestFcn,...
    'NumberTitle','off',...
    'Toolbar','none',...
    'Menubar','none',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output{2} = [fig_name,'_black'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MWin_b = figure('Units','pixels',...
    'Position',[230 + scnsize(4)*0.52 scnsize(4)*0.525 scnsize(4)*0.51 scnsize(4)*0.44], ...
    'Tag','M_Win_b', ...
    'Name',output{2},...
    'CloseRequestFcn',@MWin_CloseRequestFcn,...
    'NumberTitle','off',...
    'Toolbar','none',...
    'Menubar','none',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output{2} = [fig_name,'_sub'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MWin_s = figure('Units','pixels',...
    'Position',[230 31 scnsize(4)*0.51 scnsize(4)*0.44], ...
    'Tag','M_Win_s', ...
    'Name',output{2},...
    'CloseRequestFcn',@MWin_CloseRequestFcn,...
    'NumberTitle','off',...
    'Toolbar','none',...
    'Menubar','none',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output{2} = [fig_name,'_add'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MWin_a = figure('Units','pixels',...
    'Position',[230 + scnsize(4)*0.52 31 scnsize(4)*0.51 scnsize(4)*0.44], ...
    'Tag','M_Win_a', ...
    'Name',output{2},...
    'CloseRequestFcn',@MWin_CloseRequestFcn,...
    'NumberTitle','off',...
    'Toolbar','none',...
    'Menubar','none',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fh{1} = MWin_w;
fh{2} = MWin_b;
fh{3} = MWin_s;
fh{4} = MWin_a;

color_n = 256;
cm{1} = colormap_rw(color_n);
cm{2} = colormap_bw(color_n);
cm{3} = colormap_rwb(color_n);
%cm{3} = colormap_fi(color_n);
tick = (0:0.1:1)*(color_n-1) + 1;

h = fspecial('average'); % image filter
cs='rb'; % color sequence
ls{1}='-';
ls{2}='--';


height = RFData.Mark.ckey{1,2};
width = RFData.Mark.ckey{2,2};
ori = RFData.Mark.ckey{3,2};
center_x = RFData.Mark.ckey{6,2};
center_y = RFData.Mark.ckey{7,2};

screen_h = floor(RFData.Mark.ckey{end-5,2});
screen_w = floor(RFData.Mark.ckey{end-4,2});
rows = RFData.Mark.ckey{end-3,2};
columns = RFData.Mark.ckey{end-2,2};
rstep = RFData.Mark.ckey{end-1,2};
cstep = RFData.Mark.ckey{end,2};

pos_h = (-(rows-1)/2:(rows-1)/2)*rstep;
pos_w = (-(columns-1)/2:(columns-1)/2)*cstep;
l_w = (columns-1)*cstep;
l_h = (rows-1)*rstep;
l_ratio = l_w/l_h;
if isfit
    pos_h = pos_h + center_y;
    pos_w = pos_w + center_x;
    l_ratio = screen_w/screen_h;
end


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
    
    if strcmp(sort,'NO SORT !')
        errordlg('NO SORT DATA TO SHOW !','Data Error ');
        return;
    elseif strcmp(sort,'MUA') % MUA
        map = mapdata{ch_n,end};
    else % SUA
        if strcmp(sort,'SU')
            sort_n = 1;
        else
            sort_n = str2double(sort(end));
        end
        map = mapdata{ch_n,sort_n};
    end

    mb = squeeze(map(:,:,:,1,:));
    mw = squeeze(map(:,:,:,2,:));
    mm = mw - mb;
        
    temp = squeeze(mean(mm));
    mmax = max(max(max(temp)));
    mmin = min(min(min(temp)));
    
    temp = squeeze(mean(map));
    mmax_bw = max(max(max(max(temp))));
    mmin_bw = min(min(min(min(temp))));
    
    if delay_n < 0 % All Delay Steps
        map_b = squeeze(map(:,:,:,1,:));
        map_w = squeeze(map(:,:,:,2,:));
        map = map_w - map_b;
        
        rfmap{1} = squeeze(mean(map_w));
        rfmap{2} = squeeze(mean(map_b));
        rfmap{3} = squeeze(mean(map));
       
        for j=1:size(map,4)
            for i=1:4
                if iscontour
                    if i~=4
                        map = imrotate(squeeze(rfmap{i}(:,:,j)),ori,'bicubic','crop');
                        %map = interp2(map,2,'cubic');
                        map = flipud(map);
                        
                        figure(fh{i});
                        %contourf(map,'LineStyle','none');
                        contourf(pos_w,pos_h,map,'LineStyle','none');
                        colormap(cm{i});
                        colorbar;
                    else
                        figure(fh{i});
                        for a=1:2
                            map = imrotate(squeeze(rfmap{a}(:,:,j)),ori,'bicubic','crop');
                            %map = interp2(map,2,'cubic');
                            map = flipud(map);
                            map = mat2gray(map);
                            contour(pos_w,pos_h,map,(0.7:0.1:0.9),[ls{a},cs(a)],'Linewidth',2);
                            hold on;
                        end
                        hold off;
                    end
                    
                else
                    if i~=4
                        map = imrotate(squeeze(rfmap{i}(:,:,j)),ori,'bicubic','crop');
                        map = interp2(map,2,'cubic');
                        map = flipud(map);
                        if i==3
                            map = mat2gray(map,[mmin mmax]);
                            mrange = mmax - mmin;
                            ticklabel = round(mmin + (0:0.1:1) * mrange);
                        else
                            map = mat2gray(map,[mmin_bw mmax_bw]);
                            mrange = mmax_bw - mmin_bw;
                            ticklabel = round(mmin_bw + (0:0.1:1) * mrange);
                        end
                        [map, m] = gray2ind(map,color_n);
                        
                        figure(fh{i});
                        iptsetpref('ImshowAxesVisible','on');
                        imshow(map,cm{i},'Parent',gca,'XData',[pos_w(1) pos_w(end)],'YData',[pos_h(1) pos_h(end)],'InitialMagnification','fit');
                        %image([pos_w(1) pos_w(end)],[pos_h(1) pos_h(end)],map);
                        set(gca,'YDir','normal');
                        
                        for t=1:length(ticklabel)
                            label{t} = num2str(ticklabel(t));
                        end
                        colorbar('YTick',tick,'YTickLabel',label);
                    else
                        figure(fh{i});
                        for a=1:2
                            map = imrotate(squeeze(rfmap{a}(:,:,j)),ori,'bicubic','crop');
                            map = interp2(map,2,'cubic');
                            map = flipud(map);
                            map = mat2gray(map);
                            pos_w_i = interp(pos_w,4);
                            pos_w_i = pos_w_i(1:end-3);
                            pos_h_i = interp(pos_h,4);
                            pos_h_i = pos_h_i(1:end-3);
                            contour(pos_w_i,pos_h_i,map,(0.7:0.1:0.9),[ls{a},cs(a)],'Linewidth',2);
                            hold on;
                        end
                        hold off;
                    end
                    
                end

                fig = get(gcf,'Name');
                t1 = findstr(fig,'__');
                t2 = findstr(fig,'delay');
                fig = [fig(1:t1(end)+1),num2str((j-1)*tstep_n),fig(t2:end)];
                title(fig,'Interpreter','none','FontWeight','bold','FontSize',10);
                
                if isfit
                    set(gca,'box','off','TickDir','out','DataAspectRatio',[1 1 1],'XTick',(-screen_w/2:2:screen_w/2),'YTick',(-screen_h/2:2:screen_h/2),...
                        'XLim',[-screen_w/2 screen_w/2],'YLim',[-screen_h/2 screen_h/2]);
                else
                    set(gca,'box','off','TickDir','out','DataAspectRatio',[1 1 1]);
                end
                
                mmovie{i}(j) = getframe(gcf);
                                
            end
            
        end

        for i=1:4
            output = get(fh{i},'UserData');
            output{5} = mmovie{i};
            set(fh{i},'UserData',output);
        end

    else % single delay slice
        map_b = squeeze(map(:,:,:,1,floor(delay_n/tstep_n)+1));
        map_w = squeeze(map(:,:,:,2,floor(delay_n/tstep_n)+1));
        map = map_w - map_b;

        map_b = squeeze(mean(map_b));
        map_w = squeeze(mean(map_w));
        map = squeeze(mean(map));

        map_w = imrotate(map_w,ori,'bicubic','crop');
        rfmap{1} = map_w;
        map_b = imrotate(map_b,ori,'bicubic','crop');
        rfmap{2} = map_b;
        map = imrotate(map,ori,'bicubic','crop');
        rfmap{3} = map;
        
        for i=1:4            
            if iscontour
                if i~=4
                    map = rfmap{i};
                    %map = interp2(map,2,'cubic');
                    map = flipud(map);
                    figure(fh{i});
                    %contourf(map,'LineStyle','none');
                    contourf(pos_w,pos_h,map,'LineStyle','none');
                    colormap(cm{i});
                    colorbar;
                else
                    figure(fh{i});
                    for a=1:2
                        map = rfmap{a};
                        %map = interp2(map,2,'cubic');
                        map = flipud(map);
                        map = mat2gray(map);
                        contour(pos_w,pos_h,map,(0.7:0.1:0.9),[ls{a},cs(a)],'Linewidth',2);
                        hold on;
                    end
                    hold off;
                end
                
            else
                if i~=4
                    map = interp2(rfmap{i},2,'cubic');
                    map = flipud(map);
                    if i==3
                        map = mat2gray(map,[mmin mmax]);
                        mrange = mmax - mmin;
                        ticklabel = round(mmin + (0:0.1:1) * mrange);
                    else
                        map = mat2gray(map,[mmin_bw mmax_bw]);
                        mrange = mmax_bw - mmin_bw;
                        ticklabel = round(mmin_bw + (0:0.1:1) * mrange);
                    end
                    [map, m] = gray2ind(map,color_n);
                    
                    figure(fh{i});
                    iptsetpref('ImshowAxesVisible','on');
                    imshow(map,cm{i},'Parent',gca,'XData',[pos_w(1) pos_w(end)],'YData',[pos_h(1) pos_h(end)],'InitialMagnification','fit');
                    %image([pos_w(1) pos_w(end)],[pos_h(1) pos_h(end)],map);
                    set(gca,'YDir','normal');
                    
                    for t=1:length(ticklabel)
                        label{t} = num2str(ticklabel(t));
                    end
                    colorbar('YTick',tick,'YTickLabel',label);
                else
                    figure(fh{i});
                    for a=1:2
                        map = rfmap{a};
                        map = interp2(map,2,'cubic');
                        map = flipud(map);
                        map = mat2gray(map);
                        pos_w_i = interp(pos_w,4);
                        pos_w_i = pos_w_i(1:end-3);
                        pos_h_i = interp(pos_h,4);
                        pos_h_i = pos_h_i(1:end-3);
                        contour(pos_w_i,pos_h_i,map,(0.7:0.1:0.9),[ls{a},cs(a)],'Linewidth',2);
                        hold on;
                    end
                    hold off;
                end
                
            end   
            
            title(get(gcf,'Name'),'Interpreter','none','FontWeight','bold','FontSize',10);
            
            if isfit
                set(gca,'box','off','TickDir','out','DataAspectRatio',[1 1 1],'XTick',(-screen_w/2:2:screen_w/2),'YTick',(-screen_h/2:2:screen_h/2),...
                    'XLim',[-screen_w/2 screen_w/2],'YLim',[-screen_h/2 screen_h/2]);
            else
                set(gca,'box','off','TickDir','out','DataAspectRatio',[1 1 1]);
            end
                       
        end
          
    end

end



function MWin_CloseRequestFcn(hObject, eventdata, handles)

selection = questdlg('Do you want to save figure ?',...
                     'Close Figure ...',...
                     'Yes','No','No');
if strcmp(selection,'Yes')
    output = get(hObject,'UserData');
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
    
    if length(output)==5 % save movie
        rfmovie = output{5};
        save(figname,'rfmovie');
        movie2avi(rfmovie,figname,'compression','none','fps',10);
    else
        saveas(hObject,figname,'fig');
        saveas(hObject,figname,'png');
    end
    
    cd(outputdir);
end

delete(hObject);

