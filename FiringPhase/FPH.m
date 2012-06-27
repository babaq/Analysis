function fphdata = FPH(DataSet,bin_n)
% FPH.m
% 2008-10-17 by Zhang Li
% Calculate Phase of Firing Histogram

fp = fphase(DataSet);
fphdata = cell(DataSet.Snip.chnumber,max(DataSet.Snip.sortnumber),DataSet.Mark.nstimuli);
bn = floor(360/bin_n);
binwidth = 2*pi/bn;
bin = (0:binwidth:2*pi); % Phase Convention

for i=1:DataSet.Snip.chnumber
    for j=1:DataSet.Snip.sortnumber(i)
        for s=1:DataSet.Mark.nstimuli
            fphdata{i,j,s}=zeros(DataSet.Mark.trial,bn);
        end
    end
end
    
for i=1:DataSet.Snip.chnumber
    for j=1:DataSet.Snip.sortnumber(i)
        for s=1:DataSet.Mark.nstimuli
            for t=1:DataSet.Mark.trial
                data = squeeze(fp(i,j,t,s,:));
                data = data(data~=10);
                data=pha2con(data);

                n=histc(data,bin);

                if isempty(n)
                    n=zeros(1,bn);
                else
                    n=n(1:bn);
                    if ( size(n,1) > size(n,2) )
                        n=n';
                    end
                end

                fphdata{i,j,s}(t,:) = n;
            end
        end
    end
end
