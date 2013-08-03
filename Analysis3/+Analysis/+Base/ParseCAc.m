function [ pca ] = ParseCAc( c,flag )
%PARSECAC Parse CellAssemble from Channel
%   flag controls how sorted spiketrains are parsed
%     'each'                  each sort as a single unit
%     'all'                    pool all sort as multi unit
%     'each_all'              'each' and 'all' added to the end
%     'each_butlast'         each except last sort
%     'each_butlast_all'    'each_butlast' and 'all' added to the end
import Analysis.Core.* Analysis.Base.*

if nargin ==1
    flag = 'each_all';
end
if isnetype(c,'Channel')
    if ~isempty(c.spiketrains)
        sts = c.spiketrains;
        n = length(sts);
        ac = [];
        for i=1:n
            cs(i) = ParseC(sts(i));
            if n>1
            ac = CombineC(ac,cs(i));
            end
        end
        pca = CellAssemble();
        switch flag
            case 'each'
                pca.cells = cs;
            case 'all'
                pca.cells(1) = ac;
            case 'each_all'
                pca.cells = cs;
                if n>1
                pca.cells(end+1) = ac;
                end
            case 'each_butlast'
                cs(end) = [];
                pca.cells = cs;
            case 'each_butlast_all'
                cs(end) = ac;
                pca.cells = cs;
            otherwise
                error('Flag not supported.');
        end
    else
        pca = [];
    end
end

end

