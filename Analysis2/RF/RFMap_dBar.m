function mapdata = RFMap_dBar(DataSet,width)
% RFMap_dBar.m
% 2008-09-15 by Zhang Li
% Calculate Drifting Bar RF Map
%
% DataSet - Whole DataSet
% width - bin width(Deg) in each scan line

rows = DataSet.Mark.ckey{end-1,2};
step = DataSet.Mark.ckey{end,2};
area = (rows-1) * step;
binn = round(area/width);

if DataSet.Mark.key{3,2}==0  % RF_sdBar
    mapdata = cell(DataSet.Snip.chn,max(DataSet.Snip.sortn)+1);
    
    for i=1:DataSet.Snip.chn
        for j=1:DataSet.Snip.sortn(i)
            mapdata{i,j}=zeros(DataSet.Mark.trial,rows,binn);
        end
        mapdata{i,end}=zeros(DataSet.Mark.trial,rows,binn);
    end

    for i=1:DataSet.Snip.chn
        for j=1:DataSet.Snip.sortn(i)
            
            for t=1:DataSet.Mark.trial
                for s=1:DataSet.Mark.stimuli
                    
                    stidur = DataSet.Mark.off(t,s)-DataSet.Mark.on(t,s);
                    bintime = stidur/binn;
                    
                    bin = (DataSet.Mark.on(t,s):bintime:DataSet.Mark.off(t,s));
                    temp = DataSet.Snip.snip(i,j,t,s,:);
                    temp = squeeze(temp);
                    n=histc(temp,bin)/bintime; % firing rate
                    
                    if isempty(n)
                        n=zeros(1,binn);
                    else
                        n=n(1:binn);
                        if ( size(n,1) > size(n,2) )
                            n=n';
                        end
                    end
                    
                    mapdata{i,j}(t,s,:) = n;
                    
                end
            end
            
            mapdata{i,end}=mapdata{i,end}+mapdata{i,j};
            
        end
    end

    
else  % RF_mdBar
    mapdata = cell(DataSet.Snip.chn,max(DataSet.Snip.sortn)+1,DataSet.Mark.key{3,2});
    
    for i=1:DataSet.Snip.chn
        for j=1:DataSet.Snip.sortnumber(i)
            for c=1:size(DataSet.Mark.stitable,1);
                mapdata{i,j,c}=zeros(DataSet.Mark.trial,rows,binn);
            end
        end
    end
    
    for i=1:DataSet.Snip.chn
        for j=1:DataSet.Snip.sortn(i)
            
            for t=1:DataSet.Mark.trial
                for s=1:DataSet.Mark.stimuli
                    
                    stidur = DataSet.Mark.off(t,s)-DataSet.Mark.on(t,s);
                    bintime = stidur/binn;
                    bin = (DataSet.Mark.on(t,s):bintime:DataSet.Mark.off(t,s));
                    temp = DataSet.Snip.snip(i,j,t,s,:);
                    temp = squeeze(temp);
                    n=histc(temp,bin)/bintime; % firing rate
   
                    if isempty(n)
                        n=zeros(1,binn);
                    else
                        n=n(1:binn);
                        n=n';
                    end
                    
                    [cond,row] = ind2sub(size(DataSet.Mark.stitable),find(DataSet.Mark.stitable==s));                    
                    mapdata{i,j,cond}(t,row,:) = n;
                    
                end
            end

            mapdata{i,end,:}=mapdata{i,end,:}+mapdata{i,j,:};
        end
    end
    
end


end % end of function





