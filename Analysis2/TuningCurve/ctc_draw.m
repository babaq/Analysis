function [M,SD,SE] = ctc_draw(tdata,DataSet,param,cond_n,ch_n,sort,ispolar)
% ctc_draw.m
% 2009-06-30 by Zhang Li
% Draw Conditional TuningCurve
%
% tdata --- Stimulus Response from STC/WTC(DataSet)
% DataSet --- Whole DataSet
% param --- 's' for Shift
% cond_n --- Which Condition(int)
% ch_n --- Which Channal(int)
% sort --- Which Sort(string)
% ispolar --- if Draw in polar(bool)


if nargin<4
    disp('No Valid Arguments !');
    warndlg('No Valid Arguments !','Warnning');
    return;
end
type = tdata{end,1}.tmtype;
if nargin>4
    ch = num2str(ch_n);
else
    prompt = {['Which Channal { 0_ALL - ',num2str(DataSet.Snip.chn),' } :'],['Which Sort { ',num2str(DataSet.Snip.sortn),' } :'],'Is Polar { 0 - 1 } :'};
    dlg_title = 'Draw';
    num_lines = 1;
    def = {'1',type,'0'};
    input = inputdlg(prompt,dlg_title,num_lines,def);
    ch = input{1};
    sort = input{2};
    ispolar = str2double(input{3});
    ch_n = str2double(ch);
end

if DataSet.Mark.stimuli==1
    disp('Only One Stimulus !');
    warndlg('Only One Stimulus !','No Tuning');
    return;
end

if ispolar==1
    isp = '_p';
else
    isp = '';
end

tdata = ctc(tdata,DataSet);
c1 = DataSet.Mark.condtable{1};
c2 = DataSet.Mark.condtable{2};
textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
loc = 'northeastoutside';
switch type
    case 'mfr'
        fig_name = [DataSet.Mark.extype,' __ ',DataSet.Snip.spevent,...
        ' __( C-',ch,'__U-',sort,' )_Cond',num2str(cond_n),isp];
    yu = 'Firing Rate (spike/sec)';
    dec = 1;
    case 'rms'
            t = '_RMS';
            yu = 'uV';
            dec = 10;
        fig_name = [DataSet.Mark.extype,' __ ',DataSet.Wave.wvevent,...
        ' __( C-',ch,' )_Cond',num2str(cond_n),t,isp];
    otherwise
        t = ['_',num2str(tdata{end,1}.freqrange(1)),'-',num2str(tdata{end,1}.freqrange(2)),'Hz'];
            yu = 'Power (uV2)';
            dec = 10;
        fig_name = [DataSet.Mark.extype,' __ ',DataSet.Wave.wvevent,...
        ' __( C-',ch,' )_Cond',num2str(cond_n),t,isp];
end


scnsize = get(0,'ScreenSize');
output{1} = DataSet.OutputDir;
output{2} = fig_name;
output{3} = DataSet.Dinf.tank;
output{4} = DataSet.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86],...
    'Tag','T_Win',...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cs=['rgbkycm','rgbkycm']; % color sequence
%cs = lines(9);
cm = jet(9);


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
    
    if strcmp(sort,'NO SORT !')
        errordlg('NO SORT DATA TO SHOW !','Data Error');
        return;
    end
    if strcmp(sort,'MU') || strcmp(sort,'rms') || strcmp(sort,'pspower') || strcmp(sort,'psdpower') % MU/Wave
        fr = tdata{ch_n,end};
    else % SU
        if strcmp(sort,'SU')
            sort_n = 1;
        else
            sort_n = str2double(sort(3:end));
        end
        fr = tdata{ch_n,sort_n};
    end

    M = squeeze(mean(fr));
    SD = squeeze(std(fr));
    SE = SD/sqrt(DataSet.Mark.trial);
    
%     M = mean(M,cond_n);
%     SE = ste(M,0,cond_n);
    
    for i=1:size(M,cond_n)
        cr = cm(i,:);
        csr = cs(i);
        if cond_n==1
            m = M(i,:);
            sd = SD(i,:);
            se = SE(i,:);
            
            spon = m(1);
            m = circshift(m,[0 -1]);
            m(end) = m(1);
            se = circshift(se,[0 -1]);
            se(end) = se(1);
            sti=c2;
            sti = circshift(sti,[0 -1]);
            theta = sti*(pi/180);
            
            switch DataSet.Mark.extype
                case 'CenterSurround'
                    if i==1
                        legendlabel{i} = 'NoCenter';
                    else
                        legendlabel{i}=['Center',num2str(c1(i))];
                    end
                otherwise
                    legendlabel{i}=num2str(c1(i));
            end
            
            if ispolar
            else
                %hSpon = plot([min(sti) max(sti)],[spon spon],['-',cs(i)]);
                            hSpon = plot([min(sti) max(sti)],[spon spon],':');
                            set(hSpon,'Color',cr,'LineWidth',errorbarwidth);
                hold on;
                %hTuning=errorbar(sti,m,se,['-',cs(i)]);
                            heb=errorbar(sti,m,se,'o');
                            set(heb,'Color',cr,'LineWidth',errorbarwidth,'MarkerSize',7,...
                                'MarkerEdgeColor',cr,'MarkerFaceColor',cr);
                hold on;
                hTuning = plot(sti,m,'-');
                set(hTuning,'Color',cr,'LineWidth',linewidth);
                hold on;
                h(i)=hTuning;
            end
            
            clabel = 'Orientation Relative To Center';
        else
            m = M(:,i)';
            sd = SD(:,i)';
            se = SE(:,i)';
            
            spon = m(1);
            m = circshift(m,[0 -1]);
            m(end) = m(1);
            se = circshift(se,[0 -1]);
            se(end) = se(1);
            sti=c1;
            sti = circshift(sti,[0 -1]);
            theta = sti*(pi/180);
            
            switch DataSet.Mark.extype
                case 'CenterSurround'
                    if i==1
                        legendlabel{i} = 'NoSurround';
                    else
                        legendlabel{i}=['Surround',num2str(c2(i))];
                    end
                otherwise
                    legendlabel{i}=num2str(c2(i));
            end
            
            if ispolar
            else
                hSpon = plot([min(sti) max(sti)],[spon spon],[':',csr],'LineWidth',errorbarwidth);
                           % hSpon = plot([min(sti) max(sti)],[spon spon],':','Color',csr,'LineWidth',1);
                hold on;
                heb=errorbar(sti,m,se,['o',csr]);
                %heb=errorbar(sti,m,se,'o','Color',csr);
                set(heb,'LineWidth',errorbarwidth,'MarkerSize',7,'MarkerEdgeColor',csr,'MarkerFaceColor',csr);
                hold on;
                hTuning = plot(sti,m,['-',csr],'LineWidth',linewidth);
                %hTuning = plot(sti,m,'-','Color',csr,'LineWidth',2);
                hold on;
                h(i)=hTuning;
                
            end
            clabel = 'Center Orientation';
        end
    end
end


legend(h,legendlabel);
%legend('location',loc);
legend('boxoff');

set(gca,'LineWidth',axiswidth,'FontSize',textsize,'box','off','YDir','normal',...
    'tickdir','in','XTick',sti(1:end),'XLim',[min(sti)-max(sti)/40 max(sti)*(41/40)]);
ylabel(yu,'FontSize',textsize);
xlabel([clabel,' (degrees)'],'FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);

