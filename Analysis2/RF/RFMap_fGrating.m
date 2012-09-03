function mapdata = RFMap_fGrating(DataSet)
% RFMap_fGrating.m
% 2011-05-12 by Zhang Li
% Calculate Reverse-Correlation RF Map


rows = DataSet.Mark.key{3,2};
delay_steps = size(DataSet.Snip.snip{1,1}.ppfr,3);

for i=1:DataSet.Snip.chn
    for j=1:DataSet.Snip.ppsortn(i)
        mapdata{i,j}=zeros(DataSet.Mark.trial,rows,rows,delay_steps);
    end
end

for i=1:DataSet.Snip.chn
    for j=1:DataSet.Snip.ppsortn(i)
        for t=1:DataSet.Mark.trial
            for d=1:delay_steps
                for s=1:DataSet.Mark.stimuli
                    cti = DataSet.Mark.stitable{s};
                    
                    mapdata{i,j}(t,cti(1),cti(2),d) = DataSet.Snip.snip{i,j}.ppfr(t,s,d);
                end
            end
        end
    end
end

mapdata{DataSet.Snip.chn+1,1}.step = DataSet.Dinf.step*1000; % ms
mapdata{DataSet.Snip.chn+1,1}.course = DataSet.Dinf.course*1000; % ms