function STC_Draw(tdata,DataSet,ch,sort,delay,ispolar,isfit,varargin)
% STC_Draw.m
% 2008-09-10 by Zhang Li
% Draw TuningCurve
%
% STC_Draw(tdata,DataSet,ch,sort,delay,ispolar)
%
% tdata --- Stimulus Response from STC(DataSet)
% DataSet --- Whole DataSet
% ch --- Which Channal(string)
% sort --- Which Sort(string)
% delay --- Data Segment Delay(string)(ms)
% ispolar --- if Draw in polar(bool)
% isfit --- if Draw curve fit(bool)

if nargin <5
    delay = '0';
    ispolar = 0;
    isfit = 0;
elseif nargin < 6
    ispolar = 0;
    isfit = 0;
elseif nargin < 7
    isfit = 0;
end
%% Draw Tuning Curve
if strcmpi(ch,'ALL')
    ch_n = 0;
else
    ch_n = str2double(ch);
end

if strcmpi(sort,'NOSORT')
    errordlg('NO SORT DATA TO SHOW !','Data Error');
    return;
elseif strcmpi(sort,'MU')
    sort_n = DataSet.Snip.ppsortn(ch_n);
else
    sort_n = str2double(sort(3:end));
end

if ispolar
    switch DataSet.Mark.extype
        case {'fGrating','fGrating_Surround'}
            if isempty(varargin)
                prompt = {'Which Type { os: ori-sf, op: ori-sphase, sp: sf-sphase }'};
                dlg_title = 'Show Type';
                num_lines = 1;
                def = {'os'};
                input = inputdlg(prompt,dlg_title,num_lines,def);
                fgtype = input{1};
            else
                fgtype = varargin{1};
            end
            isp = ['_',fgtype];
        otherwise
            isp = '_p';
    end
else
    isp = '';
end
if isfit
    isf = '_f';
else
    isf = '';
end
ch_max = DataSet.Snip.chn;

titlesize = 14;
textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fig_name = [DataSet.Mark.extype,'__',DataSet.Snip.spevent,...
    '__( C-',ch,'__S-',sort,' )__',delay,'msDelay',isp,isf];
scnsize = get(0,'ScreenSize');
output{1} = DataSet.OutputDir;
output{2} = fig_name;
output{3} = DataSet.Dinf.tank;
output{4} = DataSet.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86],...
    'Tag','Win',...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cs='rgbkycm'; % color sequence


if ch_n==0 % Show All Channal
    for i=1:ch_max
        fr = tdata{i,end};
        
        fr = fr/max(max(fr));                     % Normalize
        mfr = mean(fr);                          % Mean firing rate for Stimuli of Trials
        sd = std(fr);                             % Standard Deviation for Stimuli
        se = sd/sqrt(DataSet.Mark.trial);          % Standard Error for Stimuli
        spon = mfr(1);                           % Background spontaneous firing rate
        mfr = circshift(mfr,[0 -1]);
        mfr(end) = mfr(1);
        se = circshift(se,[0 -1]);
        se(end) = se(1);
        
        if ispolar
            polar(0,1); % make all curves visible
            hold on;
            polar(theta,spon*ones(1,length(theta)),['-',cs(i)]);      % plot spontaneous firing rate
            hold on;
            hTuning=polar(theta,mfr,['-o',cs(i)]);        % plot polar tuning curve
            set(hTuning,'LineWidth',1,'MarkerSize',1);
            hold on;
        else
            plot([0 360],[spon spon],['-',cs(i)]);      % plot spontaneous firing rate
            hold on;
            hTuning=errorbar(sti,mfr,se,['-o',cs(i)]);   % plot Tuning curve
            set(hTuning,'LineWidth',1,'MarkerSize',1);
            hold on;
        end
    end
    
    ylabel('Firing Rate (spike/sec)');
    
    if isinfo && ~ispolar
        set(gca,'Box','off','XTick',[],'XLim',[-10 370],'YLim',[0 1]);
        axes('YAxisLocation','right','Color','none');
        for i=1:ch_max
            fr = tdata{i,end};
            Is = ITC(fr);                        % Information of Stimuli
            Is = Is/max(Is);                     % Normalize
            Ispon = Is(1);                       % Information of Background
            Is = circshift(Is,[0 -1]);
            Is(end) = Is(1);
            
            line('XData',[0 360],'YData',[Ispon Ispon],'Color',cs(i),'LineStyle',':');
            hITuning=line('XData',sti,'YData',Is,'Color',cs(i),'LineStyle',':','Marker','o');
            set(hITuning,'LineWidth',1,'MarkerSize',1);
        end
        set(gca,'XTick',[],'XLim',[-10 370],'YLim',[0 1]);
        ylabel('Information (bit)');
    end
    
else % Show single channal
    
    rate = tdata{ch_n,sort_n};
    
    
    mr = mean(rate);                     % Mean firing rate for Stimuli
    sd = std(rate);                        % Standard Deviation for Stimuli
    se = sd/sqrt(DataSet.Mark.trial);     % Standard Error for Stimuli
    
    switch DataSet.Mark.extype
        case {'mdBar','mdGrating'}
            spon = mr(1);                      % Background spontaneous firing rate
            mr = circshift(mr,[0 -1]);
            mr(end) = mr(1);
            se = circshift(se,[0 -1]);
            se(end) = se(1);
            
            sti=DataSet.Mark.condtable{1};
            sti = circshift(sti,[0 -1]);
            theta = sti*(pi/180);
        case 'RF_Size'
            spon = mr(1);
            
            theta = (0:DataSet.Mark.stimuli-1)*(2*pi/DataSet.Mark.stimuli);
            sti = DataSet.Mark.condtable{1};
            if isfit
                [curvefit,goodness,fitinfo] = SizeTuningFit(sti,mr,'dog');
            end
        otherwise
            spon = 0;
            nsti = length(mr);
            sti=(0:nsti-1);
            theta = sti*(2*pi/nsti);
    end
    
    labely = 'Response (spikes/sec)';
    labelx = 'Stimulus';
    dec = 1;
    if ispolar
        
        switch DataSet.Mark.extype
            case {'mdBar','mdGrating'}
                angle = 0:2*pi/360:2*pi;
                hTC=polar(theta,mr,'-ok');
                set(hTC,'LineWidth',2,'MarkerSize',7,'MarkerEdgeColor','k','MarkerFaceColor','k');
                hold on;
                hS=polar(angle,spon*ones(1,length(angle)),'-k'); % plot spontaneous firing rate
                set(hS,'LineWidth',1);
                
                labelx = 'Stimulus Direction (degrees)';
            case {'fGrating','fGrating_Surround'}
                ori = DataSet.Mark.condtable{1};
                sf = DataSet.Mark.condtable{2};
                sphase = DataSet.Mark.condtable{3};
                for s = 1:length(mr)
                    cti = DataSet.Mark.stitable{s};
                    fg(cti(1),cti(2),cti(3)) = mr(s);
                end
                switch fgtype
                    case 'os'
                        y = squeeze(mean(fg,3))';
                        y = cat(2,y,y(:,1));
                        ori = cat(2,ori,180);
                        xn = length(ori);
                        yn = length(sf);
                        xtl = cellfun(@(x)num2str(x),num2cell(ori),'UniformOutput',0);
                        ytl = cellfun(@(x)num2str(x),num2cell(sf),'UniformOutput',0);
                        labelx = 'Orientation (degrees)';
                        labely = 'Spatial Frequency (cycles/\circ)';
                    case 'op'
                        y = squeeze(mean(fg,2))';
                        y = cat(2,y,y(:,1));
                        y = cat(1,y,y(1,:));
                        ori = cat(2,ori,180);
                        sphase = cat(2,sphase,1);
                        xn = length(ori);
                        yn = length(sphase);
                        xtl = cellfun(@(x)num2str(x),num2cell(ori),'UniformOutput',0);
                        ytl = cellfun(@(x)num2str(x),num2cell(sphase),'UniformOutput',0);
                        labelx = 'Orientation (degrees)';
                        labely = 'Spatial Phase (2\pi)';
                    case 'sp'
                        y = squeeze(mean(fg,1))';
                        y = cat(1,y,y(1,:));
                        sphase = cat(2,sphase,1);
                        xn = length(sf);
                        yn = length(sphase);
                        xtl = cellfun(@(x)num2str(x),num2cell(sf),'UniformOutput',0);
                        ytl = cellfun(@(x)num2str(x),num2cell(sphase),'UniformOutput',0);
                        labelx = 'Spatial Frequency (cycles/\circ)';
                        labely = 'Spatial Phase (2\pi)';
                end
                y = interp2(y,6,'cubic');
                
                color_n = 256;
                cm = jet(color_n);
                
                mmin = min(min(y));
                mmax = max(max(y));
                mrange = mmax-mmin;
                y = mat2gray(y,[mmin mmax]);
                [y, m] = gray2ind(y,color_n);
                
                image([1 xn],[1 yn],y);
                colormap(cm);
                
                tickn = (0:0.25:1);
                tick = tickn*(color_n-1)+1;
                tickny = round((mmin + tickn * mrange)*dec)/dec;
                for t=1:length(tickn)
                    ticklabel{t} = num2str(tickny(t));
                end
                colorbar('LineWidth',2,'FontSize',textsize,'YTick',tick,'YTickLabel',ticklabel);
                
                annotation(hWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
                    'String',{'Response (spikes/sec)'},'FitHeightToText','off','Position',[0.8645 0.895 0.25 0.07])
                
                set(gca,'LineWidth',2,'FontSize',textsize,'box','off','YDir','normal','tickdir','out',...
                    'XTick',1:xn,'XTickLabel',xtl,'YTick',1:yn,'YTickLabel',ytl);
        end
        
    else
        plot([min(sti) max(sti)],[spon spon],':k','LineWidth',errorbarwidth); % plot spontaneous firing rate
        hold on;
        hTP = errorbar(sti,mr,se,'ok');
        set(hTP,'LineWidth',errorbarwidth,'MarkerSize',7,'MarkerEdgeColor','k','MarkerFaceColor','k');
        hold on;
        if isfit
            csti = sti(1):(sti(2)-sti(1))/100:sti(end);
            cmr = curvefit(csti);
            dtest=[' Adj-R^2 = ',num2str(round(goodness.adjrsquare*1000)/1000)];
        else
            csti = sti;
            cmr = mr;
            dtest = '';
        end
        hTC = plot(csti,cmr,'-k');
        set(hTC,'LineWidth',linewidth);
        xtickstep = 2;
        switch DataSet.Mark.extype
            case {'mdBar','mdGrating'}
                labelx = 'Stimulus Direction (degrees)';
            case {'fGrating','fGrating_Surround'}
                if strcmp(DataSet.Mark.extype,'fGrating')
                    cti = DataSet.Mark.stitable{mr==max(mr)};
                else
                    cti = DataSet.Mark.stitable{mr==min(mr)};
                end
                annotation(hWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
                    'String',{[' Ori = ',num2str(DataSet.Mark.condtable{1}(cti(1))),' \circ'],...
                    [' SF = ',num2str(DataSet.Mark.condtable{2}(cti(2))),' cycles/\circ'],...
                    [' SPhase = ',num2str(2*DataSet.Mark.condtable{3}(cti(3))),' \pi']},...
                    'FitHeightToText','off','Position',[0.75 0.85 0.25 0.07])
                xtickstep = length(DataSet.Mark.condtable{3})*length(DataSet.Mark.condtable{2});
            case 'RF_Size'
                [si s_max s_min] = SI(cmr,csti);
                annotation(hWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
                    'String',{[' SI = ',num2str(round(si*100)/100)],...
                    [' S_m_a_x = ',num2str(round(s_max*10)/10),' \circ'],...
                    [' S_m_i_n = ',num2str(round(s_min*10)/10),' \circ'],dtest},...
                    'FitHeightToText','off','Position',[0.75 0.85 0.25 0.07])
                labelx = 'Stimulus Diameter (degrees)';
        end
        
        set(gca,'Box','off','FontSize',textsize,'LineWidth',axiswidth,'XTick',sti(1:xtickstep:end),'XLim',[min(sti)-max(sti)/40 max(sti)*(41/40)]);
    end
    
end

xlabel(labelx,'FontSize',textsize);
ylabel(labely,'FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',titlesize);