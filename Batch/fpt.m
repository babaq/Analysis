function varargout = fpt(ps,freq,type,varargin)
% fpt.m
% 2011-05-10 by Zhang Li
% Draw Batch Average Phase Tuning on a Frequency


extent = ps.info.extent;
delay = ps.info.delay;
stiend = ps.info.stiend;
batchpath = ps.info.batchpath;
unit = ps.info.unit;
stitype = ps.info.stitype;
ssttype = ps.info.ssttype;

temp = abs(ps.frequencies-freq);
freqindex = temp==min(temp);
fi = find(freqindex==1);
sti = ps.sti;
stin = length(sti);
labelx = 'Phase (degrees)';
titlesize = 14;
textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fres = 22; % 1 Hz sample length
fl = size(ps.phase,2);
mc = max(ps.cs,[],1);


switch type
    case 't'
        %% Draw Frequency Phase Tuning
        fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
            '_',unit,'_',stitype,'_',num2str(freq),'Hz_FP',type,'_',ssttype];
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
        fr = 11; % 0.5*2 Hz Bandwidth
        y = squeeze(circ_mean(ps.ps(fi-fr:fi+fr,:),[],1));
        
        ysd = ps.psd(freqindex,:);
        y = pha2con(y);
        yu = 'Phase';
        labelx = 'Stimulus Diameter (degrees)';
        p = ps.p(freqindex,:);
        varargout{1} = p;
        
        plot([sti(1)-1 sti(end)+1],[pi pi],':k','Linewidth',1);
        hold on;
        hE=errorbar(sti,y,ysd,'or','LineWidth',1);
        set(hE,'LineWidth',1,'MarkerSize',7,'MarkerEdgeColor','r','MarkerFaceColor','r');
        hold on;
        plot(sti,y,'-r','Linewidth',2);
%         hold on;
%         plot(sti,p,'-r','Linewidth',2);
        set(gca,'LineWidth',2,'FontSize',textsize,'box','off','XTick',sti(1:2:end),'XLim',[min(sti)-max(sti)/40 max(sti)*(41/40)]);
        title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
        ylabel(yu,'FontSize',textsize);
        xlabel(labelx,'FontSize',textsize);
        
        
        case 'd'
        %% Draw Frequency Phase Distribution
        %Y = squeeze(ps.phase(:,freqindex,:));
        fr = 11; % 0.5*2 Hz Bandwidth
        Y = squeeze(circ_mean(ps.phase(:,fi-fr:fi+fr,:),[],2));
        
        fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
            '_',unit,'_',stitype,'_',num2str(freq),'Hz_FP',type,'_',ssttype];
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
        
        binw = 18*(2*pi/360);
        bin = 0:binw:2*pi;
        binx = bin+binw/2;
        binx(end) = binx(1);
        
        smoothn = 7;
        yu = 'Number of Cells';
        
        polar(0,15);
        hold on;
        
        step = 2; j = 1;
        for s=1:step:stin
            y = Y(:,s);
            %my = pha2con(circ_mean(y,[],1));
            my = pha2con(circ_median(y,1));
            y = histc(pha2con(y),bin);
            y(end) = y(1);
            y = smooth(y,smoothn,'sgolay');
            
            if s==1 % background
                cc = bgc;
            else
                cc = cm(s-1,:);
            end
            
            hp=polar(binx,y');
            set(hp,'color',cc,'linewidth',2);
            hold on;
            
            m = 11*exp(i*my);
            plot([0 real(m)],[0, imag(m)],'color',cc,'linewidth',2);
            hold on;
            
            ls{j} = ['\color[rgb]','{',num2str(cc),'}',num2str(sti(s)),' \circ'];
            j = j + 1;
        end
        
        % multi-sample test
        cond = 1:2:stin;
        alpha = Y(:,cond);
        ngroup = size(alpha,2);
        alpha = reshape(alpha,[],1);
        idx=[];
        for s=1:ngroup
        idx = cat(1,idx,ones(size(Y,1),1)*s);
        end

        %[p, table] = circ_wwtest(alpha,idx);
        [p, med cmt] = circ_cmtest(alpha,idx);
        disp(['p=',num2str(p)]);
        
        % two sample test p matrix
        pval = zeros(stin,stin);
        for f=1:stin
            for s = f:stin
                pval(f,s) = circ_cmtest(Y(:,f),Y(:,s));
                %pval(f,s) = signtest(Y(:,f),Y(:,s),'method','exact','alpha',0.05);
            end
        end
        varargout{1} = pval;
        
        legend(ls);
        legend('location','northeastoutside');
        legend hide;
        legend boxoff;
        
        set(gca,'LineWidth',2,'FontSize',textsize,'box','off');
        title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
        ylabel(yu,'FontSize',textsize);
        xlabel(labelx,'FontSize',textsize);
        annotation('textbox',[0.24 0.8 0.1 0.1],'FontSize',textsize,'string',{['p=',num2str(p)]},'LineStyle','none');
        
        case 'dd'
            mc = max(ps.cs,[],1);
            fr = 0;
        for s=1:stin
            fi = find(ps.cs(:,s)==mc(s));
            fi = fi-fr:fi+fr;
            x = ps.frequencies(fi);
            disp(num2str(x));
            cps = ps.phase(:,fi,s);
            for j=1:size(cps,1)
                cp = cps(j,:);
                cl(j,1) = circ_mean(cp,[],2);
            end
            findex(s) = fi;
            Y(:,s) = cl;
        end
        
       
        fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
            '_',unit,'_',stitype,'_',num2str(freq),'Hz_FP',type,'_',ssttype];
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
        
        binw = 18*(2*pi/360);
        bin = 0:binw:2*pi;
        binx = bin+binw/2;
        binx(end) = binx(1);

        smoothn = 7;
        yu = 'Number of Cells';
        
        polar(0,20);
        hold on;
        
        step = 2; j = 1;
        for s=1:step:stin
            y = Y(:,s);
            my = pha2con(circ_mean(y,[],1));
            y = histc(pha2con(y),bin);
            y(end) = y(1);
            y = smooth(y,smoothn,'sgolay');
            
            if s==1 % background
                cc = bgc;
            else
                cc = cm(s-1,:);
            end
            
            hp=polar(binx,y');
            set(hp,'color',cc,'linewidth',2);
            hold on;
            
            m = 18*exp(i*my);
            plot([0 real(m)],[0, imag(m)],'color',cc,'linewidth',2);
            hold on;
            
            ls{j} = ['\color[rgb]','{',num2str(cc),'}',num2str(sti(s)),' \circ'];
            j = j + 1;
        end
        alpha = Y(:,1:1:end);
        ngroup = size(alpha,2);
        alpha = reshape(alpha,[],1);
        idx=[];
        for s=1:ngroup
        idx = cat(1,idx,ones(size(Y,1),1)*s);
        end
%         alpha = reshape(Y,[],1);
%         idx=Y;
%         for s=1:stin
%         idx(:,s)=s;
%         end

        %[p, table] = circ_wwtest(alpha,idx);
        [p, table] = circ_cmtest(alpha,idx);
        disp(['p=',num2str(p)]);
        
        legend(ls);
        legend('location','northeastoutside');
        legend hide;
        legend boxoff;
        
        set(gca,'LineWidth',2,'FontSize',textsize,'box','off');
        title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
        ylabel(yu,'FontSize',textsize);
        xlabel(labelx,'FontSize',textsize);
        
    case 'l'
        dfr = ps.frequencies>=30 & ps.frequencies<=75;
        dfi = find(dfr==1);
        fr = 110; % 5*2 Hz Bandwidth
        temp = 1:stin;
        for s=temp
            fi = find(ps.cs(:,s)==mc(s));
            %ff = dfi(1):dfi(end);
            for j=1:size(ps.phase,1)
%                 ccs = ps.coherence(j,:,s);
%                 fi = find(ccs==max(ccs));
                
mf(j,s) = ps.frequencies(fi);
                ff = fi-fr:fi+fr;
                ff = ff(ff>=1 & ff<=fl);
                cp = ps.phase(j,ff,s);
                cp = pha2con(cp);
                x = ps.frequencies(ff);
                cl(j,1) = regress(cp',x');
            end
            cl = (cl/(2*pi))*1000; % ms
            l(:,s) = cl;
            y(s) = mean(cl);
            yse(s) = ste(cl);
        end
        
        % multi-sample test
        [p, table] = kruskalwallis(l);
        varargout{1} = mf;
        
        fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
            '_',unit,'_',stitype,'_',num2str(freq),'Hz_FP',type,'_',ssttype];
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
        yu = 'Lag (ms)';
        labelx = 'Stimulus Diameter (degrees)';
        
        hE=errorbar(sti,y,yse,'or','LineWidth',1);
        set(hE,'LineWidth',1,'MarkerSize',7,'MarkerEdgeColor','r','MarkerFaceColor','r');
        hold on;
        plot(sti,y,'-r','Linewidth',2);

        set(gca,'LineWidth',2,'FontSize',textsize,'box','off','XTick',sti(1:2:end),'XLim',[min(sti)-max(sti)/40 max(sti)*(41/40)]);
        title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
        ylabel(yu,'FontSize',textsize);
        xlabel(labelx,'FontSize',textsize);
        annotation('textbox',[0.24 0.8 0.1 0.1],'FontSize',textsize,'string',{['p=',num2str(p)]},'LineStyle','none');
        
    case {'s','ss'}
        %% Draw Frequency Phase Shift Correlation
        if strcmp(type,'s')
            stirangex = varargin{1};
            stirangey = varargin{2};
            stindx = sti>=stirangex(1) & sti<=stirangex(2);
            stindy = sti>=stirangey(1) & sti<=stirangey(2);
            
            x = squeeze(ps.phase(:,freqindex,stindx));
            y = squeeze(ps.phase(:,freqindex,stindy));
            x = reshape(x,[],1);
            y = reshape(y,[],1);
%             x = pha2con(circ_mean(x,[],2));
%             y = pha2con(circ_mean(y,[],2));
x = pha2con(x);
y = pha2con(y);
        else
            si = varargin{1};
            lowsi = varargin{2};
            sissessionindex = si.sessionindex(si.sis>=lowsi);
            csis = arrayfun(@(x)find(x==sissessionindex),ps.sessionindex,'UniformOutput',0);
            csis = cell2mat(csis);
            csissessionindex = sissessionindex(csis);
            csi = arrayfun(@(x)find(x==si.sessionindex),csissessionindex,'UniformOutput',0);
            csi = cell2mat(csi);
            cps = arrayfun(@(x)find(x==ps.sessionindex),sissessionindex,'UniformOutput',0);
            cps = cell2mat(cps);
            if length(csi)==length(unique(csi))
                smax = si.maxs(csi);
                smin = si.mins(csi);
                phase = ps.phase(cps,:,:);
            else % duplicate, need to check channal and sortid
            end
            
            stiwidthx=3;
            stiwidthy = 2;
            for ti = 1:size(phase,1)
                stindx = sti>=smin(ti)-stiwidthx & sti<=smin(ti)+stiwidthx;
                stindy = sti>=smax(ti)-stiwidthy & sti<=smax(ti)+stiwidthy;
                tempx = squeeze(phase(ti,freqindex,stindx));
                tempy = squeeze(phase(ti,freqindex,stindy));
                x(ti) = pha2con(circ_mean(tempx,[],1));
                y(ti) = pha2con(circ_mean(tempy,[],1));
            end
            stirangex = stiwidthx;
            stirangey = stiwidthy;
            ssttype = [ssttype,'_si_',num2str(lowsi)];
        end
        
        n = length(x);
        lim = 2*pi;
        mcolor = [0.15 0.25 0.45];
        %p = signrank(x,y,'method','exact','alpha',0.05);
        %p = signtest(x,y,'method','exact','alpha',0.05);
        [p, table] = circ_cmtest(x, y);
        
        textsize = 14;
        fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
            '_',unit,'_',stitype,'_',num2str(freq),'Hz_',num2str(stirangex),'_',num2str(stirangey),'_',ssttype];
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
        plot((0:2*lim),(0:2*lim),'-k','Linewidth',2);
        hold on;
        plot(x,y,'o','Linewidth',1,'MarkerSize',7,'MarkerEdgeColor',mcolor,'MarkerFaceColor',mcolor);
        set(gca,'LineWidth',2,'FontSize',textsize,'YLim',[0 lim],'XLim',[0 lim],...
            'XTick',(0:lim/2:lim),'YTick',(0:lim/2:lim),'XTickLabel',{'0','pi','2pi'},'YTickLabel',{'0','pi','2pi'},'DataAspectRatio',[1 1 1]);
        
        annotation('textbox',[0.24 0.8 0.1 0.1],'FontSize',textsize,'string',{['n=',num2str(n)],['p=',num2str(p)]},'LineStyle','none');
        ylabel(['Mean Phase of (',num2str(stirangey),') \circ'],'FontSize',textsize);
        xlabel(['Mean Phase of (',num2str(stirangex),') \circ'],'FontSize',textsize);
        title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
        
end