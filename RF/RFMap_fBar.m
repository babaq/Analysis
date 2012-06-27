function mapdata = RFMap_fBar(DataSet)
% RFMap_fBar.m
% 2011-05-03 by Zhang Li
% Calculate Reverse-Correlation RF Map


map_row = DataSet.Mark.ckey{end-3,2};
map_column = DataSet.Mark.ckey{end-2,2};
delay_steps = size(DataSet.Snip.snip{1,1}.ppfr,3);

for i=1:DataSet.Snip.chn
    for j=1:DataSet.Snip.ppsortn(i)
        mapdata{i,j}=zeros(DataSet.Mark.trial,map_row,map_column,2,delay_steps);
    end
end

for i=1:DataSet.Snip.chn
    for j=1:DataSet.Snip.ppsortn(i)
        for t=1:DataSet.Mark.trial
            for d=1:delay_steps
                for s=1:DataSet.Mark.stimuli
                    
                    cti = DataSet.Mark.stitable{s};
                    
                    mapdata{i,j}(t,cti(1),cti(2),cti(3),d) = DataSet.Snip.snip{i,j}.ppfr(t,s,d);
                end
            end
        end
    end
end

mapdata{DataSet.Snip.chn+1,1}.step = DataSet.Dinf.step*1000; % ms
mapdata{DataSet.Snip.chn+1,1}.course = DataSet.Dinf.course*1000; % ms