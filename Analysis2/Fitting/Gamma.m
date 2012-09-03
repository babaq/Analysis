function picG=Gamma(y)
% Gamma.m %
% 2008-01-14 Zhang Li
% Fit Absolute Luminance Curve and get Gamma Value

ffun=fittype('x^g','coefficients','g','independent','x');

if (size(y,1)==1)
    y=y';
end

x=(0:length(y)-1)';

options = fitoptions('Method','NonlinearLeastSquares');
options.StartPoint = 1;
options.Lower = 1;
cfun=fit(x,y,ffun,options);

hfig = figure('Position',[100,200,500 400],'Visible','on');

hfit = plot(cfun);
set(hfit,'LineWidth',1.5);
xlabel('Relative Luminance');
ylabel('Absolute Luminance');

hold on;

plot(x,y,'MarkerFaceColor',[0 0 0],...
    'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',8,...
    'Marker','.',...
    'LineWidth',1.5);

text(2,0.7*max(y),['Gamma = ',num2str(cfun.g)],'HorizontalAlignment','center','VerticalAlignment','top',...
    'FontWeight','demi',...
    'FontSize',11,...
    'Color',[1 0 0]);
haxe = gca;
hleg = legend(haxe,'Fitted Gamma Curve','Real Gamma Curve');
set(hleg,'Orientation','vertical','Location','NorthWest','Box','off');
set(haxe,'XLim',[0 length(y)-1]);

saveas(hfig,'Autogamma.bmp');
picG='Autogamma.bmp';
%close(hfig);

end
