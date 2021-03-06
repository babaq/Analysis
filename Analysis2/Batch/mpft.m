function mpft(ps,freqrange,type)
% mpft.m
% 2011-04-10 by Zhang Li
% Draw Batch Average Maximum Power and Frequency Tuning

if nargin < 3
    type = 'p';
end
extent = ps.info.extent;
delay = ps.info.delay;
stiend = ps.info.stiend;
batchpath = ps.info.batchpath;
unit = ps.info.unit;
stitype = ps.info.stitype;
ssttype = ps.info.ssttype;

freqindex = (ps.frequencies>=freqrange(1)) & (ps.frequencies<=freqrange(2));
X = ps.frequencies(freqindex);
sti = ps.sti;
stistart = 1;
switch type
    case {'ac','acm'}
        p = ps.powerac(:,freqindex,stistart:end);
        if strcmp(type,'acm')
            p = mean(p,1);
            ismean = 1;
        else
            ismean = 0;
        end
        stix = sti(stistart:end);
        pu = 'Absolute \DeltaPower';
    case {'rc','rcm'}
        p = ps.powerrc(:,freqindex,stistart:end);
        if strcmp(type,'rcm')
            p = mean(p,1);
            ismean = 1;
        else
            ismean = 0;
        end
        stix = sti(stistart:end);
        pu = 'Relative \DeltaPower';
    otherwise
        p = ps.power(:,freqindex,:);
        stix = sti;
        ismean = 0;
        pu = 'Absolute Power';
end
labelx = 'Stimulus Diameter (degrees)';
textsize = 14;

[mp mpfi] = max(p,[],2);
mp = squeeze(mp);
mpfi = squeeze(mpfi);
mpf = mp;
for i=1:size(mp,1)
    for j = 1:size(mp,2)
        mpf(i,j) = X(mpfi(i,j));
    end
end

if ismean
    mpm = mp;
    mpfm = mpf;
    linemarksize = 7;
else
    mpm = squeeze(mean(mp,1));
    mpsd = squeeze(std(mp,0,1));
    mpse = mpsd/sqrt(size(mp,1));
    mpfm = squeeze(mean(mpf,1));
    mpfsd = squeeze(std(mpf,0,1));
    mpfse = mpfsd/sqrt(size(mpf,1));
    linemarksize = 1;
end


%% Draw Maximum Power Tuning
fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_MPT_',type,'_',ssttype];
scnsize = get(0,'ScreenSize');
output{1} = batchpath;
output{2} = fig_name;
output{3} = unit;
output{4} = stitype;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hPWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~ismean
    hE=errorbar(stix,mpm,mpse,'or','LineWidth',1);
    set(hE,'LineWidth',1,'MarkerSize',7,'MarkerEdgeColor','r','MarkerFaceColor','r');
    hold on;
end
plot(stix,mpm,'-or','Linewidth',2,'MarkerSize',linemarksize,'MarkerEdgeColor','r','MarkerFaceColor','r');
set(gca,'LineWidth',2,'FontSize',textsize,'box','off','XTick',sti(1:2:end),'XLim',[min(sti)-max(sti)/40 max(sti)*(41/40)]);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
ylabel(pu,'FontSize',textsize);
xlabel(labelx,'FontSize',textsize);


%% Draw Maximum Power Frequency Tuning
fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_MPFT_',type,'_',ssttype];
scnsize = get(0,'ScreenSize');
output{1} = batchpath;
output{2} = fig_name;
output{3} = unit;
output{4} = stitype;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hPFWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~ismean
    hE=errorbar(stix,mpfm,mpfse,'ob','LineWidth',1);
    set(hE,'LineWidth',1,'MarkerSize',7,'MarkerEdgeColor','b','MarkerFaceColor','b');
    hold on;
end
plot(stix,mpfm,'-ob','Linewidth',2,'MarkerSize',linemarksize,'MarkerEdgeColor','b','MarkerFaceColor','b');
set(gca,'LineWidth',2,'FontSize',textsize,'box','off','XTick',sti(1:2:end),'XLim',[min(sti)-max(sti)/40 max(sti)*(41/40)]);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
ylabel('Frequency (Hz)','FontSize',textsize);
xlabel(labelx,'FontSize',textsize);


function Win_CloseRequestFcn(hObject, eventdata, handles)

SaveFigure(hObject);

delete(hObject);