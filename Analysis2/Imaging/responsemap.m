function rm = responsemap(IDataSet,method,issinglecondition)
% responsemap.m
% 2010-03-09 Zhang Li
% response frame of each condition of an optic imaging experiment

if nargin < 2
    method = 'sum';
    issinglecondition = 0;
elseif nargin < 3
    issinglecondition = 0;
end


if isfield(IDataSet,'blockpath')
    sn = IDataSet.head.nstimuli;
    tn = size(IDataSet.image,1);
    rm = zeros([size(IDataSet.image{1,1}) sn]);
    for s = 1:sn
        disp(['Processing Stimulus ',num2str(s),' ...']);
        for i = 1:tn
            rm(:,:,s)=rm(:,:,s)+IDataSet.image{i,s};
        end
        
        if strcmp(method,'avg')
            rm(:,:,s)=rm(:,:,s)/tn;
        end
    end
    
    if issinglecondition
        d = size(rm);
        rm = squeeze(mat2cell(rm,d(1),d(2),ones(1,d(3))))';
        rm = singlecondition(rm);
        t=zeros(d);
        for i=1:d(3)
            t(:,:,i)=rm{i};
        end
        rm = t;
        clear t;
    end
    
    switch IDataSet.ex
        case 'DirSF'
            c=4;
        otherwise
            c=3;
    end
    if (mod(sn,c)==0)
        r = sn/c;
    else
        r = floor(sn/c)+1;
    end
    
    figure;
    for s=1:sn
        subplot(r,c,s);
        x = squeeze(rm(1:end-1,:,s));
        xmean = mean2(x);
        xstd = std2(x);
        imagesc(mat2gray(x,[xmean-3*xstd xmean+3*xstd]));
        colormap(gray);
        title(['Stimulus\_',num2str(s)]);
        set(gca,'DataAspectRatio',[1 1 1]);
        axis off;
    end
    
else
    disp('Incomplete Blocks Data !');
    return;
end

end % EOF
