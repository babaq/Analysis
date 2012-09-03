% BSFC.m %
% 2011-04-24 by Zhang Li
% Batch Spike Field Coherence

if isempty(varargin)
    extent = 0;
    delay = 0;
    stin = 0;
    freqrange = [25 90];
    seg_n = 100;
    ch_w = 0;
    method = 'mtm';
else
    extent=varargin{1};
    delay = varargin{2};
    stin = varargin{3};
    freqrange = varargin{4};
    seg_n = varargin{5};
    ch_w = varargin{6};
    method = varargin{7};
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
        
        DataSet = PreProcess(DataSet,extent,delay,1);
        % Processing Spike Field Coherence
        sfcdata = CalcSFC(DataSet,seg_n,ch_w,method);
        
        for ch = 1:chn
            for sort = 1:1
                if ~isstruct(auaresult{ch,sort})
                    auaresult{ch,sort}.sortid = 0;
                end
                auaresult{ch,sort}.block{j}.blockid = blockid;
                auaresult{ch,sort}.block{j}.type = blocktype;
                
                sortn = auaresult{ch,sort}.sortid;
                for s = 1:size(sfcdata,3)
                    auaresult{ch,sort}.block{j}.sfc{s} = sfcdata{ch,end,s}.sfc;
                end
                if stin>0
                    auaresult{ch,sort}.block{j}.sfc = auaresult{ch,sort}.block{j}.sfc(1:stin);
                end
            end
            
            for sort = 1:sortnmua
                if ~isstruct(muaresult{ch,sort})
                    muaresult{ch,sort}.sortid = muaresult{ch,sort};
                end
                muaresult{ch,sort}.block{j}.blockid = blockid;
                muaresult{ch,sort}.block{j}.type = blocktype;
                
                sortn = muaresult{ch,sort}.sortid;
                for s = 1:size(sfcdata,3)
                    muaresult{ch,sort}.block{j}.sfc{s} = sfcdata{ch,sortn,s}.sfc;
                end
                if stin>0
                    muaresult{ch,sort}.block{j}.sfc = muaresult{ch,sort}.block{j}.sfc(1:stin);
                end
            end
            
            for sort = 1:sortnsua
                suaresult{ch,sort}.block{j}.blockid = blockid;
                suaresult{ch,sort}.block{j}.type = blocktype;
                
                sortn = suaresult{ch,sort}.sortid;
                for s = 1:size(sfcdata,3)
                    suaresult{ch,sort}.block{j}.sfc{s} = sfcdata{ch,sortn,s}.sfc;
                end
                if stin>0
                    suaresult{ch,sort}.block{j}.sfc = suaresult{ch,sort}.block{j}.sfc(1:stin);
                end
            end
        end
    end
    BSTSFC{i,1}=auaresult;
    BSTSFC{i,2}=muaresult;
    BSTSFC{i,3}=suaresult;
end

BSTSFC{sn+1,1} = [extent delay stin];
BSTSFC{sn+1,2} = freqrange;
BSTSFC{sn+1,3} = sfcdata{end,1,1};
save(fullfile(rootpath,batchpath,['BSTSFC_',num2str(extent),'_',num2str(delay),'_',num2str(stin),'_',num2str(freqrange),'.mat']),'BSTSFC');
