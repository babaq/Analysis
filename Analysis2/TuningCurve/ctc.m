function tdata = ctc(tdata,DataSet)
% ctc.m
% 2009-05-09 by Zhang Li
% Conditional Tuning Data

cn =length(DataSet.Mark.condtable);
for i = 1:cn
    cl(i) = length(DataSet.Mark.condtable{i});
end
ctdata = zeros([DataSet.Mark.trial cl]);


for c=1:DataSet.Snip.chn
    temp = cellfun(@(x)~isempty(x),tdata(c,:));
    sortn = length(find(temp));
    for j=1:sortn
        for t=1:DataSet.Mark.trial
            for s=1:DataSet.Mark.stimuli
                ci = DataSet.Mark.stitable{s};
                sub=num2str(t);
                for i=1:cn
                    sub = [sub,',',num2str(ci(i))];
                end
                
                evalc(['ctdata(',sub,') = tdata{c,j}(t,s)']);
                
            end
        end
        tdata{c,j} = ctdata;
    end
end


