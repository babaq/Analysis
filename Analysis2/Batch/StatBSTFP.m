function StatBSTFP(BSTFP,unit,stitype)
% StatBSTFP.m %
% 2010/08/09 by Zhang Li
% Statistics of Batched Size Tuning Firing Phase

sn = size(BSTFP,1)-1;
vs = ValidSessions(sn);
extent = BSTFP{end,1}(1);
delay = BSTFP{end,1}(2);
stin = BSTFP{end,1}(3);
freqrange = BSTFP{end,2};
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

SBSTFP = cell(sn,3);
plim = 0.05;

for i=vs
    spdata = BSTFP{i,un};
    
    if un<=2 % ana and mua
        sp = spdata{1};
        for bn = 1:length(sp.block)
            bdata = sp.block{bn};
            if strcmp(bdata.type,stitype)
                if isempty(bdata.fpd{4})
                else
                max1 = bdata.fpd{4}{2};
                max2 = bdata.fpd{5}{2};
                max3 = bdata.fpd{6}{2};
                min1 = bdata.fpd{15}{2};
                min2 = bdata.fpd{16}{2};
                min3 = bdata.fpd{17}{2};
                min4 = bdata.fpd{18}{2};
                min5 = bdata.fpd{19}{2};
                
                
                maxp = [max1;max2;max3];
                minp = [min1;min2;min3;min4;min5];
                maxrp = circ_rtest(maxp);
                minrp = circ_rtest(minp);
                maxmp = circ_mean(maxp);
                minmp = circ_mean(minp);
                maxstd = circ_std(maxp);
                minstd = circ_std(minp);
                
                
                if (maxrp<plim) && (minrp<plim)
                    SBSTFP{i,un}{bn}.maxp = maxp;
                    SBSTFP{i,un}{bn}.minp = minp;
                    SBSTFP{i,un}{bn}.maxrp = maxrp;
                    SBSTFP{i,un}{bn}.minrp = minrp;
                    SBSTFP{i,un}{bn}.maxmp = maxmp;
                    SBSTFP{i,un}{bn}.minmp = minmp;
                    SBSTFP{i,un}{bn}.maxstd = maxstd;
                    SBSTFP{i,un}{bn}.minstd = minstd;
                end

                end
            end
        end
    else % sua
        for sort=1:length(spdata)
            sp{sort} = spdata{sort};
            for bn = 1:length(sp.block)
                bdata = sp.block{bn};
                if strcmp(bdata.type,stitype)
                    if isempty(bdata.fpd{4})
                    else
                        max1 = bdata.fpd{4}{2};
                        max2 = bdata.fpd{5}{2};
                        max3 = bdata.fpd{6}{2};
                        min1 = bdata.fpd{15}{2};
                        min2 = bdata.fpd{16}{2};
                        min3 = bdata.fpd{17}{2};
                        min4 = bdata.fpd{18}{2};
                        min5 = bdata.fpd{19}{2};
                        
                        
                        maxp = [max1;max2;max3];
                        minp = [min1;min2;min3;min4;min5];
                        maxrp = circ_rtest(maxp);
                        minrp = circ_rtest(minp);
                        maxmp = circ_mean(maxp);
                        minmp = circ_mean(minp);
                        maxstd = circ_std(maxp);
                        minstd = circ_std(minp);
                        
                        
                        if (maxrp<plim) && (minrp<plim)
                            SBSTFP{i,un}{bn}.maxp = maxp;
                            SBSTFP{i,un}{bn}.minp = minp;
                            SBSTFP{i,un}{bn}.maxrp = maxrp;
                            SBSTFP{i,un}{bn}.minrp = minrp;
                            SBSTFP{i,un}{bn}.maxmp = maxmp;
                            SBSTFP{i,un}{bn}.minmp = minmp;
                            SBSTFP{i,un}{bn}.maxstd = maxstd;
                            SBSTFP{i,un}{bn}.minstd = minstd;
                        end
                        
                    end
                end
            end
        end
    end
    
end


j=1;
for i=1:sn
    if ~isempty(SBSTFP{i,un})
        temp = cellfun(@(x)~isempty(x),SBSTFP{i,un},'UniformOutput',0);
        sp = SBSTFP{i,un}(cell2mat(temp));
        
        if length(sp)>1
            rp = zeros(1,length(sp));
            for bn = 1:length(sp)
                rp(bn) = sp{bn}.maxrp;
            end
            sb = find(rp==min(rp));
            sp = sp{sb(1)};
        else
            sp = sp{1};
        end
        
        FP{j,1}=sp;
        j=j+1;
    end
end

save(fullfile(rootpath,batchpath,...
    ['SBSTFP_',num2str(extent),'_',num2str(delay),'_',num2str(stin),'_',unit,'_',stitype,'_',num2str(freqrange),'.mat']),...
    'SBSTFP','FP');
