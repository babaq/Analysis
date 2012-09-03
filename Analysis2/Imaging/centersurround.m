function centersurround(IDataSet,method)
% centersurround.m
% 2010-03-09 Zhang Li
% Direction and Spatial Frequency column centersurround map

if nargin <2
    method = 'sub';
end
center = 3;
surround = IDataSet.head.nstimuli/center;

for i = 1:IDataSet.head.ntrials
    for s = 1:IDataSet.head.nstimuli
        if strcmp(method,'sub')
            df = IDataSet.image{i,s};
        else
            df = IDataSet.image{i,s};
        end
        figure;
        imagesc(df);
        colormap(gray);
        title(gca,num2str(s));
    end
end

end % EOF
