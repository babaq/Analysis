function IDataSetImage = singlecondition(IDataSetImage,method)
% singlecondition.m
% 2010-06-25 Zhang Li
% single condition map using cocktail blank

if nargin <2
    method = 'div';
end

[tn sn] = size(IDataSetImage);
for i = 1:tn
    disp(['Processing Single Condition Map ',num2str(i),'/',num2str(tn),' Trials ...']);
    cb = 0;
    for s = 1:sn
        cb = cb + IDataSetImage{i,s};
    end
    cb = cb./sn;
    for s = 1:sn
        if strcmp(method,'sub')
            IDataSetImage{i,s} = IDataSetImage{i,s} - cb;
        else
            IDataSetImage{i,s} = IDataSetImage{i,s} ./ cb;
        end
    end
end

end % eof
