function StatBSTSFC(BSTSFC,unit,stitype)
% StatBSTSFC.m %
% 2010/10/11 by Zhang Li
% Statistics of Batched Size Tuning Spike Field Coherence

sn = size(BSTSFC,1)-1;
vs = ValidSessions(sn);
extent = BSTSFC{end,1}(1);
delay = BSTSFC{end,1}(2);
stin = BSTSFC{end,1}(3);
freqrange = BSTSFC{end,2};
freq = BSTSFC{end,3};
rootpath = 'E:\Zl\Data & Result';
batchpath='BatchResult';

if strcmp(unit,'aua')
    un = 1;
elseif strcmp(unit,'mua')
    un = 2;
else
    un = 3;
end

if strcmp(stitype,'d')
    stitype = 'drifting';
else
    stitype = 'static';
end

SBSTSFC = cell(sn,3);

for i=vs
    spdata = BSTSFC{i,un};
    sortn = length(spdata);
    
    if un<=2 % ana and mua
        sp = spdata{1};
        for bn = 1:length(sp.block)
            bdata = sp.block{bn};
            if strcmp(bdata.type,stitype)
                SBSTSFC{i,un}{bn}.sfc = bdata.sfc;
            end
        end
    else % sua
        if sortn>0
            for sort=1:sortn
                sp = spdata{sort};
                for bn = 1:length(sp.block)
                    bdata = sp.block{bn};
                    if strcmp(bdata.type,stitype)
                        SBSTSFC{i,un}{sort,bn}.sfc = bdata.sfc;
                    end
                end
            end
        end
    end
    
end


j=1;
for i=1:sn
    if ~isempty(SBSTSFC{i,un})
        if un<3 % aua or mua
            temp = cellfun(@(x)~isempty(x),SBSTSFC{i,un},'UniformOutput',0);
            sp = SBSTSFC{i,un}(cell2mat(temp));
            
            if length(sp)>1
                sfc = zeros(1,length(sp));
                for bn = 1:length(sp)
                    sfc(bn) = max(sp{bn}.sfc{6});
                end
                sb = find(sfc==max(sfc));
                sp = sp{sb(1)};
            else
                sp = sp{1};
            end
            
            SFC{j,1}=sp;
            j=j+1;
        else % sua
            sortn = size(SBSTSFC{i,un},1);
            for sort = 1:sortn
                sp = SBSTSFC{i,un}(sort,:);
                temp = cellfun(@(x)~isempty(x),sp,'UniformOutput',0);
                bind = cell2mat(temp);
                sp = sp(bind);
                
                if length(sp)>1
                    sfc = zeros(1,length(sp));
                    for bn = 1:length(sp)
                        sfc(bn) = max(sp{bn}.sfc{6});
                    end
                    sb = find(sfc==max(sfc));
                    sp = sp{sb(1)};
                else
                    sp = sp{1};
                end
                
                SFC{j,1}=sp;
                j=j+1;
            end
        end
    end
end

SFC{end+1,1}=freqrange;
SFC{end+1,1}=freq;

save(fullfile(rootpath,batchpath,...
    ['SBSTSFC_',num2str(extent),'_',num2str(delay),'_',num2str(stin),'_',unit,'_',stitype,'_',num2str(freqrange),'.mat']),...
    'SBSTSFC','SFC');
