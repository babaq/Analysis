function psthdata = CalcPSTH(DataSet,bin_n)
% CalcPSTH.m
% 2011-04-11 by Zhang Li
% Calculate Peri-Stimulus Time Histogram

extent = DataSet.Dinf.extent;
delay = DataSet.Dinf.delay;
stidurmin = min(min( (DataSet.Mark.off+extent+delay) - (DataSet.Mark.on-extent+delay) )); % sec
bw = bin_n/1000; % sec
bn = floor(stidurmin/bw);

if isfield(DataSet,'Snip')
    
    for i=1:DataSet.Snip.chn
        for j=1:DataSet.Snip.ppsortn(i)
            psthdata{i,j}=zeros(DataSet.Mark.trial,DataSet.Mark.stimuli,bn);
            for s=1:DataSet.Mark.stimuli
                for t=1:DataSet.Mark.trial
                    st = DataSet.Snip.snip{i,j}.ppspike{t,s};
                    onofftime = [DataSet.Mark.on(t,s)-extent+delay DataSet.Mark.off(t,s)+extent+delay];
                    
                    bst = binst(st,onofftime,bw);
                    
                    if isempty(bst)
                        bst=zeros(1,bn);
                    else
                        bst=bst(1:bn);
                        if ( size(bst,1) > size(bst,2) )
                            bst=bst';
                        end
                    end
                    
                    psthdata{i,j}(t,s,:) = bst/bw;
                end
            end
        end
    end
    
else
    disp('No Valid Data !');
    warndlg('No Valid Data !','Warnning');
end