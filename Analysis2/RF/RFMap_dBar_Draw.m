function RFMap_dBar_Draw(mapdata,RFData,ch,sort,condition,delay,isfit)
% RFMap_dBar_Draw.m
% 2008-09-15 by Zhang Li
% Draw RF Map

%% Draw RF Map
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
end
condition_max = RFData.Mark.key{3,2};

if isfit
    fit='_fit';
else
    fit='';
end

fig_name = [RFData.Mark.extype,' __ ',RFData.Snip.spevent,...
        ' __( C-',ch,'__U-',sort,'__S-',condition,' )__',delay,'delay',fit];
scnsize = get(0,'ScreenSize');
output{1} = RFData.OutputDir;
output{2} = fig_name;
output{3} = RFData.Dinf.tank;
output{4} = RFData.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MWin = figure('Units','pixels',...
    'Position',[250 30 scnsize(4) scnsize(4)*0.86], ...
    'Tag','M_Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@MWin_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colormap(gray);
h = fspecial('average'); % image filter
cs='rgbkycm'; % color sequence


row = RFData.Mark.ckey{end-1,2};
step = RFData.Mark.ckey{end,2};
center_x = RFData.Mark.ckey{6,2};
center_y = RFData.Mark.ckey{7,2};
pos_h = (-(row-1)/2:(row-1)/2)*step;
pos_w = pos_h;
if isfit
    pos_h = pos_h + center_y;
    pos_w = pos_w + center_x;
end
screen_h = RFData.Mark.ckey{end-3,2};
screen_w = RFData.Mark.ckey{end-2,2};
    

if size(mapdata,3)==1  % RF_sdBar
    
    if ch_n==0 % ALL Channal
        for i=1:ch_max
            map=0;
            sort_max = RFData.Snip.sortnumber(i);
            for j=1:sort_max
                map = map+mapdata{i,j};
            end
            map = imrotate(map,str2double(condition),'bicubic','crop');
            map = imfilter(map,h,'replicate');
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
        
        if strcmp(sort,'NO SORT !')
            errordlg('NO SORT DATA TO SHOW !','Data Error ');
            return;            
        elseif strcmp(sort,'MUA') % MUA
            map=mapdata{ch_n,end};
        else % SUA
            if strcmp(sort,'SU')
                sort_n = 1;
            else
                sort_n = str2double(sort(end));
            end
            map = mapdata{ch_n,sort_n};
        end
        
        map = squeeze(mean(map));
        map = imrotate(map,str2double(condition),'bicubic','crop');
        %map = imfilter(map,h,'replicate');
        map = flipud(map);
        
        contourf(pos_w,pos_h,map,'LineStyle','none');
        colorbar();
    end
    
    xlabel('Position(deg)');
    ylabel('Position(deg)');
    if isfit
        set(gca,'box','off','TickDir','out','DataAspectRatio',[1 1 1],'XTick',(-screen_w/2:2:screen_w/2),'YTick',(-screen_h/2:2:screen_h/2),'XLim',[-screen_w/2 screen_w/2],'YLim',[-screen_h/2 screen_h/2]);
    else
        set(gca,'box','off','TickDir','out','DataAspectRatio',[1 1 1],'XTick',pos_w,'YTick',pos_h);
    end
    title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);
       
    
else % RF_mdBar
    
    
    scanarea =mean(mean(RFData.Mark.markoff - RFData.Mark.markon)) * RFData.Mark.para(3);
    scanrow=RFData.Mark.para(1);
    scaninterval=RFData.Mark.para(2);
    nbins = round(scanarea/scaninterval);
    if mod(nbins,2)==0
        nbins = nbins+1;
    end
    binwidth = scanarea/nbins;
    scaninit_h = ((scanrow-1)/2)*scaninterval;
    scaninit_w = ((nbins-1)/2)*binwidth;
    pos_h = (-scaninit_h:scaninterval:scaninit_h);
    pos_w = (-scaninit_w:binwidth:scaninit_w);
    screen_w = RFData.Mark.para(5);
    screen_h = RFData.Mark.para(4);
    
    
    if ch_n==0 % ALL Channal
        for i=1:ch_max
            map=0;
            sort_max = RFData.Snip.sortnumber(i);
            for j=1:sort_max
                temp=0;
                for k=1:condition_max
                    temp = temp+imrotate(mapdata{i,j,k},(k-1)*360/condition_max,'bicubic','crop');                    
                end
                map = map+temp/condition_max;
            end
            map = imfilter(map,h,'replicate');
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
        
        xlabel('Position(deg)');
        ylabel('Position(deg)');
        set(gca,'DataAspectRatio',[1 1 1],'YTick',pos_h);
        title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);
    else % single channal
        sort_max = RFData.Snip.sortnumber(ch_n);
        if iscut % cut to screen
            edge_h = (scanrow-1)/2;
            edge_w = (nbins-1)/2;
            cutedge_h = floor((edge_h*screen_h/2)/scaninit_h);
            cutedge_w = floor((edge_w*screen_w/2)/scaninit_w);
            cut1_h = edge_h-cutedge_h+1;
            cut2_h = cut1_h+2*cutedge_h;
            cut1_w = edge_w-cutedge_w+1;
            cut2_w = cut1_w+2*cutedge_w;
            pos_w = pos_w(cut1_w:cut2_w);
            pos_h = pos_h(cut1_h:cut2_h);
        end
        
        if strcmp(sort,'NO SORT !')
            errordlg('NO SORT DATA TO SHOW !','Data Error ');
            return;            
        elseif strcmp(sort,'MUA') % MUA
            if condition_n==0 % All Stimuli Condition
                row = floor(condition_max/4+0.5);
                for j=1:condition_max
                    c_title = (j-1)*360/condition_max;
                    subplot(row,4,j);
                    map=0;
                    for k=1:sort_max
                        map = map+imrotate(mapdata{ch_n,k,j},c_title,'bicubic','crop');   
                    end
                    map = imfilter(map,h,'replicate');
                    
                    if iscut % cut to screen
                        map = map(cut1_h:cut2_h,cut1_w:cut2_w);
                    end
                    
                    contourf(pos_w,pos_h,map);
                    set(gca,'DataAspectRatio',[1 1 1],'YTick',pos_h);
                    axis off;
                    title(int2str(c_title),'Interpreter','none','FontWeight','bold','FontSize',10);
                end  
            else % Single Stimuli Condition
                map=0;
                for i=1:sort_max
                    map = map+mapdata{ch_n,i,condition_n};
                end
                map = imrotate(map,str2double(condition),'bicubic','crop');
                map = imfilter(map,h,'replicate');
                
                if iscut % cut to screen
                    map = map(cut1_h:cut2_h,cut1_w:cut2_w);
                end
                
                contourf(pos_w,pos_h,map);
                colorbar();   
                
                xlabel('Position(deg)');
                ylabel('Position(deg)');
                set(gca,'DataAspectRatio',[1 1 1],'YTick',pos_h);
                title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);
            end
        else % SUA
            if strcmp(sort,'SU')
                sort_n = 1;
            else
                sort_n = str2double(sort(end));
            end
            
            if condition_n==0 % All Stimuli Condition
                row = floor(condition_max/4+0.5);
                for j=1:condition_max
                    c_title = (j-1)*360/condition_max;
                    subplot(row,4,j);
                    map = imrotate(mapdata{ch_n,sort_n,j},c_title,'bicubic','crop');   
                    map = imfilter(map,h,'replicate');
                    
                    if iscut % cut to screen
                        map = map(cut1_h:cut2_h,cut1_w:cut2_w);
                    end
                    
                    contourf(pos_w,pos_h,map);
                    set(gca,'DataAspectRatio',[1 1 1],'YTick',pos_h);
                    axis off;
                    title(int2str(c_title),'Interpreter','none','FontWeight','bold','FontSize',10);
                end   
            else % Single Stimuli Condition
                map = imrotate(mapdata{ch_n,sort_n,condition_n},str2double(condition),'bicubic','crop');
                map = imfilter(map,h,'replicate');
                
                if iscut % cut to screen
                    map = map(cut1_h:cut2_h,cut1_w:cut2_w);
                end
                
                contourf(pos_w,pos_h,map);
                colorbar();   
                
                xlabel('Position(deg)');
                ylabel('Position(deg)');
                set(gca,'DataAspectRatio',[1 1 1],'YTick',pos_h);
                title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',10);
            end
        end 
    end
end



function MWin_CloseRequestFcn(hObject, eventdata, handles)

selection = questdlg('Do you want to save this figure ?',...
                     'Close This Figure ...',...
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
    saveas(hObject,figname,'fig');
    saveas(hObject,figname,'png');
    
    cd(outputdir);
end

delete(hObject);

