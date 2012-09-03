function SaveFigure(hfig,varargin)
% SaveFigure.m
% 2011-03-19 Zhang Li
% Save Figure According to Figure UserData

if isempty(varargin)
    issave = questdlg('Do you want to save this figure ?',...
        'Save This Figure ...',...
        'Yes','No','No');
else
    issave = varargin{1};
end

if strcmp(issave,'Yes')
    output = get(hfig,'UserData');
    outputdir = output{1};
    figname = output{2};
    tank = output{3};
    block = output{4};
    
    cd(outputdir);
    if (exist(tank,'dir'))
        cd(tank);
    else
        mkdir(tank);
        cd(tank);
    end
    if (exist(block,'dir'))
        cd(block);
    else
        mkdir(block);
        cd(block);
    end
    
    if length(output)==5 % save movie
        rfmovie = output{5};
        save(figname,'rfmovie');
        movie2avi(rfmovie,figname,'compression','none','fps',10);
    else
        saveas(hfig,figname,'fig');
        saveas(hfig,figname,'png');
    end
    
    cd(outputdir);
end
