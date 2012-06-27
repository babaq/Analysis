function tdata = FPDTC(DataSet)
% FPDTC.m
% 2009-01-11 by Zhang Li
% Firing Phase "cmean of phase of all trials" TuningCurve Function for Different Stimuli Modulation

fp = fphase(DataSet);

tdata = cell(DataSet.Snip.chnumber,max(DataSet.Snip.sortnumber)+1);

for i=1:DataSet.Snip.chnumber
    for j=1:DataSet.Snip.sortnumber(i)
        tdata{i,j}=zeros(DataSet.Mark.trial,DataSet.Mark.nstimuli);
    end
end

for i=1:DataSet.Snip.chnumber
    for j=1:DataSet.Snip.sortnumber(i)
        for k=1:DataSet.Mark.trial
            for m=1:DataSet.Mark.nstimuli
                
                p = squeeze(fp(i,j,k,m,:));
                p = p(p<10);
                
                if isempty(p)
                    tdata{i,j}(k,m) = 0;
                else
                    tdata{i,j}(k,m)=cmean(p);
                end
                
            end
        end
    end
end


for i=1:DataSet.Snip.chnumber
    for k=1:DataSet.Mark.trial
        for m=1:DataSet.Mark.nstimuli
            
            muap = [];
            for j=1:DataSet.Snip.sortnumber(i)
                p = squeeze(fp(i,j,k,m,:));
                p = p(p<10);
                muap = cat(1,muap,p);
            end

            if isempty(muap)
                tdata{i,end}(k,m) = 0;
            else
                tdata{i,end}(k,m)=cmean(muap);
            end
            
        end
    end
end
