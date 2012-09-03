function IDataSet = blockbatch(blkfile,zfn,tfn,type,method,isframemethod,framemethod)
% blockbatch.m
% 2010-03-09 Zhang Li
% Batch a optic imaging experiment

% check block files
t = findstr('\',blkfile);
bdir = blkfile(1:t(end));

blockname = blkfile(t(end)+1:end);
t = findstr('_',blockname);
ex = blockname(1:t(end)-1);
extail = blockname(t(end)+1:end);
pb = findstr('B',extail);
pe = findstr('E',extail);
exn = str2double(extail(pe(1)+1:pb(1)-1));

bf = dir([bdir,ex,'_E',num2str(exn),'B*.BLK']);
bn = size(bf,1);

if nargin < 3
    tfn = 0;
    type = 'avg';
    method = 'sub';
    isframemethod = 1;
    framemethod = 'sum';
elseif nargin < 4
    type = 'avg';
    method = 'sub';
    isframemethod = 1;
    framemethod = 'sum';
elseif nargin < 5
    method = 'sub';
    isframemethod = 1;
    framemethod = 'sum';
elseif nargin < 6
    isframemethod = 1;
    framemethod = 'sum';
elseif nargin < 7
    framemethod = 'sum';
end

disp(['Processing Block 1/',num2str(bn),' ...']);
if isframemethod==1
    IDataSet = BLK([bdir,bf(1).name],zfn,tfn,type,method,framemethod);
else
    IDataSet = BLK0F([bdir,bf(1).name],zfn,tfn,type,method);
end

IDataSet.blockpath = bdir;
IDataSet.ex = ex;
IDataSet.exn = exn;

% batching each block
for bi = 2:bn
    disp(['Processing Block ',num2str(bi),'/',num2str(bn),' ...']);
    if isframemethod==1
        data = BLK([bdir,bf(bi).name],zfn,tfn,type,method,framemethod);
    else
        data = BLK0F([bdir,bf(bi).name],zfn,tfn,type,method);
    end
    IDataSet.image = [IDataSet.image;data.image];
end

end % eof