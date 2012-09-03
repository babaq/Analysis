function ptm(ps,freqrange,type)
% ptm.m
% 2011-04-30 by Zhang Li
% Draw Batch Average Power Spectrum Tuning Map

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
    case 'rc'
        y = ps.psrc(freqindex,:);
        yu = 'Relative \DeltaP';
        dec = 10;
    case 'ac'
        y = ps.psac(freqindex,:);
        yu = 'Absolute \DeltaP';
        switch ssttype
            case 'scps'
                dec = 1000;
            otherwise
                dec = 10;
        end
    case 'cs'
        y = ps.cs(freqindex,:);
        yu = 'Coherence';
        dec = 100;
    case 'csac'
        y = ps.csac(freqindex,:);
        yu = 'Absolute \DeltaC';
        dec = 100;
    case 'csrc'
        y = ps.csrc(freqindex,:);
        yu = 'Relative \DeltaC';
        dec = 100;
    case 'ps'
        y = ps.ps(freqindex,:);
        y = pha2con(y);
        yu = 'Phase';
        dec = 100;
    case 'psac'
        y = ps.psac(freqindex,:);
        yu = 'Absolute \DeltaP';
        dec = 100;
    case 'psrc'
        y = ps.psrc(freqindex,:);
        yu = 'Relative \DeltaP';
        dec = 100;
    case 'rt'
        y = ps.p(freqindex,:);
        yu = 'Rayleigh P Value';
        dec = 100;
    otherwise
        y = ps.ps(freqindex,:);
        %y = 10*log10(y); % Convert to dB
        yu = 'Normalized Power';%'dB';
        dec = 10;
end
stin = length(ps.sti);

titlesize = 14;
textsize = 22;
linewidth = 1;
axiswidth = 0.5;
errorbarwidth = 0.5;
fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',num2str(round(pret*10)),'_',num2str(round(post*10)),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_PTM_',type,'_',ssttype];
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
color_n = 256;
cm = jet(color_n);

mmin = min(min(y));
mmax = max(max(y));
mrange = mmax-mmin;
y = mat2gray(y,[mmin mmax]);
[y, m] = gray2ind(y,color_n);

image([0 (stin-1)/2],[freqrange(1) freqrange(2)],y);
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

set(gca,'LineWidth',axiswidth,'FontSize',textsize,'box','off','YDir','normal','tickdir','out');
ylabel('Frequency (Hz)','FontSize',textsize);
xlabel('Stimulus Diameter (degrees)','FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',titlesize);
