function sfcc(sfcs,freqrange)
% sfcc.m
% 2010-10-11 by Zhang Li
% Draw Batched Averaged Spike Field Coherence

freqindex = (sfcs.freq>=freqrange(1)) & (sfcs.freq<=freqrange(2));
X = sfcs.freq(freqindex);
X = round(X*10)/10;

y = squeeze(mean(sfcs.sfc));
y_sd = squeeze(std(sfcs.sfc));
y_se = y_sd/sqrt(size(sfcs.sfc,1));
y = y(freqindex,:);
y_sd = y_sd(freqindex,:);
y_se = y_se(freqindex,:);

stin = size(y,2);
cm = colormap_rwb(stin);
%cm = flipdim(gray(stin),1);
for s=1:1:stin
    %Y = y(:,s);
    Y = smooth(y(:,s));
    errorbar(X,Y,y_se(:,s),'.','color',cm(s,:));
    hold on;
    plot(X,Y,'color',cm(s,:),'linewidth',1.5);
    hold on;
    my(s) = max(Y);
end
ymax = max(my);
set(gca,'box','off','XTick',X(1):5:X(end),'XLim',[X(1) X(end)],'YLim',[0 1.1*ymax]);
set(gca,'color',[0.8,0.8,0.8]);
title('SFC Tuning Curve','Interpreter','none','FontWeight','bold','FontSize',10);
ylabel('SFC');
xlabel('Frequency [Hz]');
% legend('Location','EastOutside');
% legend show;
% legend boxoff;
