function [  ] = ExportTank( TTX,blocksource,blocknames,events,options,exportpath )
%EXPORTTANK Summary of this function goes here
%   Detailed explanation goes here

OpenTank(TTX,blocksource.tank,'R');
if isempty(blocknames)
    b=1;
    while true
        cbn = QueryBlockName(TTX,b);
        if isempty(cbn)
            break;
        else
            blocknames{b} = cbn;
            b = b+1;
        end
    end
end
blockn = length(blocknames);

for b = 1:blockn
    disp([blocksource.tank,'__',blocknames{b}]);
    ExportBlock(TTX,blocksource,blocknames{b},events,options,exportpath);
end

CloseTank(TTX);
end

