% BFiringPhase.m %
% 2010/08/13 by Zhang Li
% Batch Firing Phase Blocks

if isempty(varargin)
    extent = 0;
    delay = 0;
    stin = 0;
    freqrange = [25 90];
else
    extent=varargin{1};
    delay = varargin{2};
    stin = varargin{3};
    freqrange = varargin{4};
end

for i=1:sn
    currentsubject = SUB{i,1};
    currenttank = SUB{i,2};
    currentsession = SUB{i,3};
    
    muaresult = SUB{i,5};
    auaresult = muaresult;
    chn = size(muaresult,1);
    sortnmua = size(muaresult,2);
    suaresult = SUB{i,6};
    sortnsua = size(suaresult,2);
    lfpresult = cell(chn,1);
    
    blocknames = SUB{i,7}(:,2);
    t = cellfun(@(x)strcmp(x,'RF_Size'),blocknames);
    blocks = cell2mat(SUB{i,7}(:,1));
    blocks = blocks(t);
    bn = length(blocks);
    
    for j=1:bn
        blockid = blocks(j);
        disp(['Batching --> ',currentsubject,'-',currentsession,'-',num2str(blockid),' ...']);
        
        load(fullfile(rootpath,currentsubject,[currenttank,' __ ',currentsession,'-',num2str(blockid),'_N_F(',num2str(freqrange(1)),'-',num2str(freqrange(2)),').mat']));
        t= cellfun(@(x)(strcmp(x,'TemporalFreq')),DataSet.Mark.ckey(:,1));
        if DataSet.Mark.ckey{t,2}==0
            blocktype = 'static';
        else
            blocktype = 'drifting';
        end
        
        ppDataSet = PreProcess(DataSet,extent,delay,0);
        % Processing Firing Phase Distribution
        fpddata = FPD(ppDataSet,1);
        
        for ch = 1:chn
            for sort = 1:1
                if ~isstruct(auaresult{ch,sort})
                    auaresult{ch,sort}.sortid = 0;
                end
                auaresult{ch,sort}.block{j}.blockid = blockid;
                auaresult{ch,sort}.block{j}.type = blocktype;
                
                sortn = auaresult{ch,sort}.sortid;
                for s = 1:size(fpddata,3)
                    auaresult{ch,sort}.block{j}.fpd{s} = fpddata{ch,end,s};
                end
                if stin>0
                    auaresult{ch,sort}.block{j}.fpd = auaresult{ch,sort}.block{j}.fpd(1:stin);
                end
            end
            
            for sort = 1:sortnmua
                if ~isstruct(muaresult{ch,sort})
                    muaresult{ch,sort}.sortid = muaresult{ch,sort};
                end
                muaresult{ch,sort}.block{j}.blockid = blockid;
                muaresult{ch,sort}.block{j}.type = blocktype;
                
                sortn = muaresult{ch,sort}.sortid;
                for s = 1:size(fpddata,3)
                    muaresult{ch,sort}.block{j}.fpd{s} = fpddata{ch,sortn,s};
                end
                if stin>0
                    muaresult{ch,sort}.block{j}.fpd = muaresult{ch,sort}.block{j}.fpd(1:stin);
                end
            end
            
            for sort = 1:sortnsua
                suaresult{ch,sort}.block{j}.blockid = blockid;
                suaresult{ch,sort}.block{j}.type = blocktype;
                
                sortn = suaresult{ch,sort}.sortid;
                for s = 1:size(fpddata,3)
                    suaresult{ch,sort}.block{j}.fpd{s} = fpddata{ch,sortn,s};
                end
                if stin>0
                    suaresult{ch,sort}.block{j}.fpd = suaresult{ch,sort}.block{j}.fpd(1:stin);
                end
            end
        end
    end
    BSTFP{i,1}=auaresult;
    BSTFP{i,2}=muaresult;
    BSTFP{i,3}=suaresult;
end

BSTFP{sn+1,1} = [extent delay stin];
BSTFP{sn+1,2} = freqrange;
save(fullfile(rootpath,batchpath,['BSTFP_',num2str(extent),'_',num2str(delay),'_',num2str(stin),'_',num2str(freqrange),'.mat']),'BSTFP');
