function SCTC_Draw(tdata,DataSet,ispolar,isfit)
% SCTC_Draw.m
% 2011-03-28 by Zhang Li
% Draw Spike Trian Correlation Power Tuning Curve

if nargin < 3
    ispolar = 0;
    isfit = 0;
elseif nargin < 4
    isfit = 0;
end

ch_n1 = tdata{end}.params.ch;
sort1 = tdata{end}.params.sort;
ch_n2 = tdata{end}.params.ch;
sort2 = tdata{end}.params.sort;

% ch_n1 = tdata{end}.params.ch_n1;
% sort1 = tdata{end}.params.sort1;
% ch_n2 = tdata{end}.params.ch_n2;
% sort2 = tdata{end}.params.sort2;

freqrange = tdata{end}.freqrange;
type = [num2str(freqrange(1)),'-',...
    num2str(freqrange(2)),'Hz_pspower'];
labely = 'Power (Arbitrary Unit)';

if ispolar
    isp = '_p';
else
    isp = '';
end
if isfit
    isf = '_f';
else
    isf = '';
end

textsize = 14;
fig_name = [DataSet.Mark.extype,'__',DataSet.Snip.spevent,...
    '__( C-',num2str(ch_n1),'_U-',sort1,' ^ C-',num2str(ch_n2),'_U-',sort2,' )__',type,isp,isf];
scnsize = get(0,'ScreenSize');
output{1} = DataSet.OutputDir;
output{2} = fig_name;
output{3} = DataSet.Dinf.tank;
output{4} = DataSet.Dinf.block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cs='rgbkycm'; % color sequence

[mp se] = fmean2(tdata{1});

switch DataSet.Mark.extype
    case {'mdBar','mdGrating'}
        spon = mp(1);
        mp = circshift(mp,[0 -1]);
        mp(end) = mp(1);
        se = circshift(se,[0 -1]);
        se(end) = se(1);
        
        sti=DataSet.Mark.condtable{1};
        sti = circshift(sti,[0 -1]);
        theta = sti*(pi/180);
    case 'RF_Size'
        spon = mp(1);
        
        theta = (0:DataSet.Mark.stimuli-1)*(2*pi/DataSet.Mark.stimuli);
        sti = DataSet.Mark.condtable{1};
        if isfit
            [curvefit,goodness,fitinfo] = SizeTuningFit(sti,mp,'dog');
        end
    otherwise
        spon = 0;
        nsti = length(mp);
        sti=(0:nsti-1);
        theta = sti*(2*pi/nsti);
end


if ispolar
else
    plot([min(sti) max(sti)],[spon spon],':k','LineWidth',1);
    hold on;
    hTP=errorbar(sti,mp,se,'ok');
    set(hTP,'LineWidth',1,'MarkerSize',7,'MarkerEdgeColor','k','MarkerFaceColor','k');
    hold on;
    if isfit
        csti = sti(1):(sti(2)-sti(1))/100:sti(end);
        cmp = curvefit(csti);
        dtest=[' Adj-R^2 = ',num2str(round(goodness.adjrsquare*1000)/1000)];
    else
        csti = sti;
        cmp = mp;
        dtest = '';
    end
    hTC = plot(csti,cmp,'-k');
    set(hTC,'LineWidth',2);
    switch DataSet.Mark.extype
        case 'RF_Size'
            [si s_max s_min] = SI(cmp,csti);
            annotation(hWin,'textbox','LineStyle','none','Interpreter','tex','FontSize',textsize,...
                'String',{[' SI = ',num2str(round(si*100)/100)],...
                [' S_m_a_x = ',num2str(round(s_max*10)/10),' \circ'],...
                [' S_m_i_n = ',num2str(round(s_min*10)/10),' \circ'],dtest},...
                'FitHeightToText','off','Position',[0.75 0.85 0.25 0.07])
            labelx = 'Stimulus Diameter (degrees)';
        otherwise
    end
    
end
set(gca,'LineWidth',2,'FontSize',textsize,'Box','off','XTick',sti(1:2:end),'XLim',[min(sti)-max(sti)/40 max(sti)*(41/40)]);
xlabel(labelx,'FontSize',textsize);
ylabel(labely,'FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);

