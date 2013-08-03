function filterbstsc(BST,unit,stitype,freqrange)
% filterbst.m %
% 2012-04-09 by Zhang Li
% Filter subset of batched size tuning result

exid = BST{end,1}.exid;
extent = BST{end,1}.extent;
delay = BST{end,1}.delay;
stiend = BST{end,1}.stiend;
issps = BST{end,1}.issps;
pret = BST{end,1}.pret;
post = BST{end,1}.post;
rootpath = BST{end,1}.rootpath;
batchpath = BST{end,1}.batchpath;

sn = size(BST,1)-1;
vs = ValidSessions(sn,rootpath,exid,'st'); % exclude user defined invalid sessions

if strcmp(unit,'mu')
    un = 2;
else
    un = 3;
end
lfpn = 4;

if strcmp(stitype,'d')
    stitype = 'drifting';
else
    stitype = 'static';
end

% get valid non-empty sessions
vu = BST(vs,un);
vui = cellfun(@(x)~isempty(x),vu);
vs = vs(vui);
% filter result from within valid sessions
vsn=1;
for i=vs
    furesult=[];
    ffresult=[];
    bffresult=[];
    sessioninfo = BST{i,1};
    unitresult = BST{i,un};
    lfpresult = BST{i,lfpn};
    
    disp(['Filtering Size Tuning Batch Result --> Session ',num2str(i)]);
    
    chn = size(unitresult,1);
    sortn = size(unitresult,2);
    
    for ch = 1:chn
        
        % filter unit result
        for sort = 1:sortn
            cur = unitresult{ch,sort};
            if ~isempty(cur)
                fbn=1;
                for bn = 1:length(cur.block)
                    if ~isempty(cur.block{bn}) && strcmp(cur.block{bn}.blocktype,stitype)
                        furesult{ch,sort}.block{fbn} = cur.block{bn};
                        if isfield(cur.block{bn},'scps')
                            for fn = 1:length(cur.block{bn}.sctc)
                                if cur.block{bn}.sctc{fn}.freqrange==freqrange
                                    furesult{ch,sort}.block{fbn}.sctc = cur.block{bn}.sctc{fn};
                                end
                            end
                        end
                        fbn = fbn + 1;
                    end
                end
            end
            
        end
        
        
    end
    
    
    % have valid filtered result
    if ~isempty(furesult)
        chn = size(furesult,1);
        sortn = size(furesult,2);
        
        % choose only one best block data for each session according to curve fit goodness
        for ch = 1:chn
            
            for sort = 1:sortn
                cur = furesult{ch,sort};
                if ~isempty(cur)
                    vfbn = length(cur.block); % valid filter block number
                    fg = zeros(1,vfbn);
                    % get each filter block fit goodness of unit
                    for bn = 1:vfbn
                        cbid = cur.block{bn}.blockid;
                        
                        fg(bn) = cur.block{bn}.goodness.adjrsquare;
                    end
                    bbi = find(fg==max(fg)); % best fit block index
                    bbid = cur.block{bbi}.blockid; % best block id
                    disp(['Channal ',num2str(ch),' - Sort ',num2str(sort),' --> Choose Best Block ID: ',num2str(bbid),', Drop ',num2str(vfbn-1),' Other Blocks']);
                    furesult{ch,sort}.block = cur.block{bbi};
                    
                    
                    
                    
                end
            end
            
        end
    end
    
    
    % save valid filter result
    if ~isempty(furesult) 
        FBST{vsn,1} = sessioninfo;
        FBST{vsn,2} = furesult;

        vsn = vsn + 1;
    end
    
end

FBST{vsn,1} = BST{end,1};
FBST{vsn,1}.unit = unit;
FBST{vsn,1}.stitype = stitype;
FBST{vsn,1}.freqrange = freqrange;

save(fullfile(batchpath,...
    ['FBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',num2str(issps),'_',num2str(round(pret*10)),'_',num2str(round(post*10)),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'.mat']),...
    'FBST');
