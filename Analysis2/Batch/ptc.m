function ptc(ps,freqrange,type)
% ptc.m
% 2011-04-30 by Zhang Li
% Draw Batch Average Power Spectrum Tuning Curve

if nargin < 3
    type = 'p';
end
extent = ps.info.extent;
delay = ps.info.delay;
stiend = ps.info.stiend;
pret = ps.info.pret;
post = ps.info.post;
batchpath = ps.info.batchpath;
unit = ps.info.unit;
stitype = ps.info.stitype;
ssttype = ps.info.ssttype;

freqindex = (ps.frequencies>=freqrange(1)) & (ps.frequencies<=freqrange(2));
X = ps.frequencies(freqindex);
switch type
    case {'rc','erc'}
        Y = ps.psrc(freqindex,:);
        Yse = ps.serc(freqindex,:);
        yu = 'Relative \DeltaPower';
        loc = 'northeastoutside';
        smoothn = 107; % 5 Hz Bandwidth
    case {'ac','eac'}
        Y = ps.psac(freqindex,:);
        Yse = ps.seac(freqindex,:);
        yu = 'Absolute \DeltaPower';
        loc = 'northeastoutside';
    case {'csp'}
        pidx = {3:7,9:13,15:21};%1-3, 4-6, 7-10
        pcs = cell(1,length(pidx));
        for pn = 1:length(pidx)
            %             for pi = 1:length(pidx{pn})
            %             pcs{pn} = cat(1,pcs{pn},ps.coherence(:,freqindex,pidx{pn}(pi)));
            %             end
            pcs{pn} = mean(ps.coherence(:,freqindex,pidx{pn}),3);
            Y(:,pn) = squeeze(mean(pcs{pn}));
            Yse(:,pn) = squeeze(ste(pcs{pn}));
        end
        yu = 'Coherence';
        loc = 'northeastoutside';
        switch ssttype
            case 'stasfc'
                smoothn = 6;
            otherwise
                smoothn = 215; % 10 Hz Bandwidth
                %smoothn = 322; % 15 Hz Bandwidth
                %smoothn = 430; % 20 Hz Bandwidth
        end
    case {'cspac'}
        pidx = {3:7,9:13,15:21};%1-3, 4-6, 7-10
        n = size(ps.coherence,1);
        pcs = [];
        for t =1: n
            for pn = 1:length(pidx)
                temp(:,pn) = squeeze(mean(ps.coherence(t,freqindex,pidx{pn}),3));
            end
            temp = cn(temp,'a');
            pcs = cat(3,pcs,temp);
        end
        Y = squeeze(mean(pcs,3));
        Yse = squeeze(ste(pcs,0,3));
        yu = 'Absolute \DeltaCoherence';
        loc = 'northeastoutside';
        switch ssttype
            case 'stasfc'
                smoothn = 6;
            otherwise
                smoothn = 215; % 10 Hz Bandwidth
                %smoothn = 322; % 15 Hz Bandwidth
                %smoothn = 430; % 20 Hz Bandwidth
        end
    case {'cs','ecs','csm'}
        Y = ps.cs(freqindex,:);
        Yse = ps.se(freqindex,:);
        yu = 'Coherence';
        loc = 'northeastoutside';
        switch ssttype
            case 'stasfc'
                smoothn = 6;
            otherwise
                smoothn = 215; % 10 Hz Bandwidth
                %smoothn = 322; % 15 Hz Bandwidth
                %smoothn = 430; % 20 Hz Bandwidth
        end
    case {'csac','ecsac'}
        Y = ps.csac(freqindex,:);
        Yse = ps.seac(freqindex,:);
        yu = 'Absolute \DeltaCoherence';
        loc = 'northeastoutside';
        switch ssttype
            case 'stasfc'
                smoothn = 6;
            otherwise
                smoothn = 215; % 10 Hz Bandwidth
        end
    case {'csrc','ecsrc'}
        Y = ps.csrc(freqindex,:);
        Yse = ps.serc(freqindex,:);
        yu = 'Relative \DeltaCoherence';
        loc = 'northeastoutside';
        switch ssttype
            case 'stasfc'
                smoothn = 6;
            otherwise
                smoothn = 215; % 10 Hz Bandwidth
        end
    case 'ps'
        Y = ps.ps(freqindex,:);
        Yse = ps.psd(freqindex,:);
        yu = 'Phase';
        loc = 'northeastoutside';
        switch ssttype
            case 'stasfc'
                smoothn = 6;
            otherwise
                smoothn = 215;
        end
    case {'psac','epsac'}
        Y = ps.psac(freqindex,:);
        Yse = ps.pseac(freqindex,:);
        yu = 'Absolute \DeltaPhase';
        loc = 'northeastoutside';
        switch ssttype
            case 'stasfc'
                smoothn = 6;
            otherwise
                smoothn = 215;
        end
    case 'rt'
        Y = ps.p(freqindex,:);
        yu = 'Rayleigh P Value';
        loc = 'northeastoutside';
    otherwise
        Y = ps.ps(freqindex,:);
        Yse = ps.se(freqindex,:);
        %         Y = 10*log10(Y); % Convert to dB
        %         Yse = 10*log10(Yse); % Convert to dB
        yu = 'Normalized Power';
        %         yu = 'Power (dB)';
        loc = 'northeastoutside';
        smoothn = 107; % 5 Hz Bandwidth
end
sti = ps.sti;
stin = length(sti);

titlesize = 14;
textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',num2str(round(pret*10)),'_',num2str(round(post*10)),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_PTC_',type,'_',ssttype];
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
bc = [1 0.1 0.1];
ec = [0.1 0.1 1];
bgc = [0.3 0.3 0.3];
cm = makeColorMap(bc,0.9*[1 1 1],ec,stin-1);

switch type
    case 'csm'
        stindex = sti>=0.5 & sti<= stiend;
        mY = Y(:,stindex);
        y = mean(mY,2);
        yse = ste(mY,0,2);
        freq = X(y==max(y));
        y = smooth(y,smoothn,'sgolay');
        errorbar(X,y,yse,'.','color',bgc+0.2,'linewidth',1);
        hold on;
        plot(X,y,'color',bc,'linewidth',2);
        annotation(hWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
            'String',{['Max Coherence Frequency: ',num2str(freq),' Hz']},'FitHeightToText','off','Position',[0.50 0.81 0.45 0.07])
    case {'csp','cspac'}
        j = 1;
        for s=1:size(Y,2)
            y = Y(:,s);
            yse = Yse(:,s);
            switch type
                case {'csp'}
                    y = smooth(y,smoothn,'sgolay');
                    %yse = smooth(yse,smoothn,'sgolay');
                case {'ps','psac','epsac'}
                    y = circ_smooth(y,smoothn);
                    %y = pha2con(y);
            end
            cc = mean(cm(pidx{s}-1,:));
            %                         errorbar(X,y,yse,'.','color',cc,'linewidth',1);
            %                         hold on;
            estep = 9; %9;%18;
            ep = 1:estep:length(X);
            plot([X(ep); X(ep)],[y(ep)'-yse(ep)'; y(ep)'+yse(ep)'],'color',cc,'linewidth',errorbarwidth);
            hold on;
            %             plot(X,y+yse,':','color',cc,'linewidth',1);
            %             hold on;
            %             plot(X,y-yse,':','color',cc,'linewidth',1);
            %             hold on;
            plot(X,y,'color',cc,'linewidth',linewidth);
            hold on;
            ls{j} = ['\color[rgb]','{',num2str(cc),'}',num2str((pidx{s}(1)-1)/2),'-',num2str((pidx{s}(end)-1)/2),' \circ'];
            j = j + 1;
        end
        
        switch type
            case 'ps'
                set(gca,'YLim',[0 2*pi],'YTick',[0 0.5*pi,pi,1.5*pi 2*pi],'YTickLabel',{'0','pi/2','pi','3pi/2','2pi'});
        end
        
        legend(ls);
        legend('location',loc);
        legend show;
        legend boxoff;
    otherwise
        %         switch type
        %             case 'ps'
        %                 plot([X(1)-1 X(end)+1],[pi pi],':k','Linewidth',1);
        %                 hold on;
        %         end
        
        step = 2; j = 1;
        for s=1:step:stin
            y = Y(:,s);
            yse = Yse(:,s);
            switch type
                case {'p','ep','rc','erc','cs','csac','csrc','ecsac','ecsrc'}
                    y = smooth(y,smoothn,'sgolay');
                    %yse = smooth(yse,smoothn,'sgolay');
                case {'ps','psac','epsac'}
                    y = circ_smooth(y,smoothn);
                    %y = pha2con(y);
            end
            if s==1 % background
                cc = bgc;
            else
                cc = cm(s-1,:);
            end
            %                         errorbar(X,y,yse,'.','color',cc,'linewidth',1);
            %                         hold on;
            estep = 9; %9;%18;
                                                ep = 1:estep:length(X);
                                                plot([X(ep); X(ep)],[y(ep)'-yse(ep)'; y(ep)'+yse(ep)'],'color',cc,'linewidth',errorbarwidth);
                                                hold on;
            %             plot(X,y+yse,':','color',cc,'linewidth',1);
            %             hold on;
            %             plot(X,y-yse,':','color',cc,'linewidth',1);
            %             hold on;
            plot(X,y,'color',cc,'linewidth',linewidth);
            hold on;
            ls{j} = ['\color[rgb]','{',num2str(cc),'}',num2str(sti(s)),' \circ'];
            j = j + 1;
        end
        
        switch type
            case 'ps'
                %set(gca,'YLim',[0 2*pi],'YTick',[0 0.5*pi,pi,1.5*pi 2*pi],'YTickLabel',{'0','pi/2','pi','3pi/2','2pi'});
        end
        
        legend(ls);
        legend('location',loc);
        legend show;
        legend boxoff;
end

set(gca,'LineWidth',axiswidth,'FontSize',textsize,'box','off',...
    'XTick',freqrange(1):(freqrange(2)-freqrange(1))/10:freqrange(2),'XLim',[freqrange(1) freqrange(2)]);
ylabel(yu,'FontSize',textsize);
xlabel('Frequency (Hz)','FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',titlesize);

