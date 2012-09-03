function sfclock(sfcs,freqrange,validsti)
% sfclock.m
% 2010-10-11 by Zhang Li
% Draw Batched Averaged Spike Field Coherence

freqindex = (sfcs.freq>=freqrange(1)) & (sfcs.freq<=freqrange(2));
X = sfcs.freq(freqindex);
X = round(X*10)/10;
stin = size(sfcs.sfc,3);
sti = 1:stin;
stindex = (sti>=validsti(1)) & (sti<=validsti(2));

lock = sfcs.sfc(:,:,stindex);
lock = squeeze(mean(lock,3));
y = squeeze(mean(lock));
y_sd = squeeze(std(lock));
y_se = y_sd/sqrt(size(lock,1));
y = y(freqindex);
y_sd = y_sd(freqindex);
y_se = y_se(freqindex);

Y = y;
Y = smooth(y);
figure;
errorbar(X,Y,y_se);

ymax = max(Y);
xmax = X(Y==ymax);

set(gca,'box','off','XTick',X(1):5:X(end),'XLim',[X(1)-5 X(end)+5]);
title('SFC Locking Tuning Curve','Interpreter','none','FontWeight','bold','FontSize',10);
ylabel('SFC');
xlabel('Frequency [Hz]');

annotation(gcf,'textbox','LineStyle','none','Interpreter','tex',...
        'String',{[' MaxSFC Frequency = ',num2str(round(xmax)),' Hz']},...
        'FitHeightToText','off','Position',[0.5 0.85 0.5 0.07]);
