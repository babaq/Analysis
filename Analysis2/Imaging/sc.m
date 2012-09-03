% sc.m
% 2010-06-25 Zhang Li
% single condition map using cocktail blank

method = 'div';

[tn sn] = size(IDataSet.image);
for i = 1:tn
    disp(['Processing Single Condition Map ',num2str(i),'/',num2str(tn),' Trials ...']);
    cb = 0;
    for s = 1:sn
        cb = cb + IDataSet.image{i,s};
    end
    for s = 1:sn
        if strcmp(method,'sub')
            IDataSet.image{i,s} = IDataSet.image{i,s} - cb;
        else
            IDataSet.image{i,s} = IDataSet.image{i,s} ./ cb;
        end
    end
end

clear cb i method s sn tn;