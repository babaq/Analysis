function sfci(sfcs,freqrange)
% sfci.m
% 2010-10-11 by Zhang Li
% Draw Batched Averaged Spike Field Coherence

freqindex = (sfcs.freq>=freqrange(1)) & (sfcs.freq<=freqrange(2));
y = squeeze(mean(sfcs.sfc));
y = y(freqindex,:);
stin = size(y,2);
color_n = 256;
cm = jet(color_n);

mmin = min(min(y));
mmax = max(max(y));
y = mat2gray(y,[mmin mmax]);
mrange = mmax-mmin;
[y, m] = gray2ind(y,color_n);

figure;
image([0 (stin-1)/2],[freqrange(1) freqrange(2)],y);

tick = (0:0.1:1)*(color_n-1) + 1;
ticklabel = round((mmin + (0:0.1:1) * mrange)*1000)/1000;
for t=1:length(ticklabel)
    label{t} = num2str(ticklabel(t));
end

colormap(cm);
colorbar('YTick',tick,'YTickLabel',label);
set(gca,'box','off','YDir','normal');
title('SFC Tuning','Interpreter','none','FontWeight','bold','FontSize',10);
ylabel('Frequency [Hz]');
xlabel('Stimuli');
