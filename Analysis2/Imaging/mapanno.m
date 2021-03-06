function mapanno(hfigure)
% mapanno.m
% 2010-05-30 Zhang Li
% Add annotation on Map

annotation(hfigure,'doublearrow',[0.775 0.875],[0.825 0.825],'LineWidth',1,...
    'Head1Style','vback1',...
    'Head1Length',8,...
    'Head1Width',6,...
    'Head2Style','vback1',...
    'Head2Length',8,...
    'Head2Width',6);
annotation(hfigure,'doublearrow',[0.825 0.825],[0.775 0.875],'LineWidth',1,...
    'Head1Style','vback1',...
    'Head1Length',8,...
    'Head1Width',6,...
    'Head2Style','vback1',...
    'Head2Length',8,...
    'Head2Width',6);

annotation(hfigure,'textbox',[0.735 0.8 0.05 0.05],'String','P',...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',10,...
    'FitBoxToText','off',...
    'LineStyle','none');
annotation(hfigure,'textbox',[0.86 0.8 0.05 0.05],'String','A',...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',10,...
    'FitBoxToText','off',...
    'LineStyle','none');
annotation(hfigure,'textbox',[0.8 0.725 0.05 0.05],'String','M',...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',10,...
    'FitBoxToText','off',...
    'LineStyle','none');
annotation(hfigure,'textbox',[0.8 0.88 0.05 0.05],'String','L',...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',10,...
    'FitBoxToText','off',...
    'LineStyle','none');

end % eof