function fpddata = FPD(DataSet,bin_n)
% FPD.m
% 2008-10-17 by Zhang Li
% Calculate Phase of Firing Distribution and p-value of Rayleigh test

fp = fphase(DataSet);
fpddata = cell(DataSet.Snip.chn,max(DataSet.Snip.sortn)+1,DataSet.Mark.stimuli);
bn = floor(360/bin_n);
binwidth = 2*pi/bn;
bin = (0:binwidth:2*pi); % Phase Convention
    
for i=1:DataSet.Snip.chn
    for j=1:DataSet.Snip.sortn(i)
        for s=1:DataSet.Mark.stimuli
            fpdata=[];
            fplength=0;
            for t=1:DataSet.Mark.trial
                data = squeeze(fp(i,j,t,s,:,1));
                data = data(data~=10);
                data=pha2con(data);
                datalength = length(data);
                
                fpdata = cat(1,fpdata,data);
                fplength = fplength+datalength;
            end

            if isempty(fpdata)
                p = 0;
                mp = circ_mean(fpdata);
                pstd = circ_std(fpdata);
                n=histc(fpdata,bin);
            else
                p = circ_rtest(fpdata);
                mp = circ_mean(fpdata);
                pstd = circ_std(fpdata);
                n=histc(fpdata,bin);
            end

            if isempty(n)
                n=zeros(1,bn);
            else
                n=n(1:bn);
                if ( size(n,1) > size(n,2) )
                    n=n';
                end
            end

            n = n/fplength;
            
            fpddata{i,j,s} = {n fpdata p mp pstd};
           
        end
    end
end

for i=1:DataSet.Snip.chn
    for s=1:DataSet.Mark.stimuli
        fpdata=[];
        fplength=0;
        for t=1:DataSet.Mark.trial
            for j=1:DataSet.Snip.sortn(i)
                data = squeeze(fp(i,j,t,s,:,1));
                data = data(data~=10);
                data=pha2con(data);
                datalength = length(data);
                
                fpdata = cat(1,fpdata,data);
                fplength = fplength+datalength;
            end
        end
        
        if isempty(fpdata)
            p = 0;
            mp = circ_mean(fpdata);
            pstd = circ_std(fpdata);
            n=histc(fpdata,bin);
        else
            p = circ_rtest(fpdata);
            mp = circ_mean(fpdata);
            pstd = circ_std(fpdata);
            n=histc(fpdata,bin);
        end
        
        if isempty(n)
            n=zeros(1,bn);
        else
            n=n(1:bn);
            if ( size(n,1) > size(n,2) )
                n=n';
            end
        end
        
        n = n/fplength;
        fpddata{i,end,s} = {n fpdata p mp pstd};
    end
end



