% BFiltering.m %
% 2010/08/09 by Zhang Li
% Batch Filtering Blocks

if isempty(varargin)
    blocktype = 'RF_Size';
else
    blocktype=varargin{1};
end

for i=1:sn
    currentsubject = SUB{i,1};
    currenttank = SUB{i,2};
    currentsession = SUB{i,3};
    
    muaresult = SUB{i,5};
    chn = size(muaresult,1);
    sortnmua = size(muaresult,2);
    suaresult = SUB{i,6};
    sortnsua = size(suaresult,2);
    lfpresult = cell(chn,1);
    
    blocknames = SUB{i,7}(:,2);
    t = cellfun(@(x)strcmp(x,blocktype),blocknames);
    blocks = cell2mat(SUB{i,7}(:,1));
    blocks = blocks(t);
    bn = length(blocks);
    
    for j=1:bn
        blockid = blocks(j);
        disp(['Batching --> ',currentsubject,'-',currentsession,'-',num2str(blockid),' ...']);
        
        load(fullfile(rootpath,currentsubject,[currenttank,' __ ',currentsession,'-',num2str(blockid),'_N.mat']));
        
        Filtering(DataSet,{'Kaiser' '40' '44' 'Yes'});
        
    end
end
