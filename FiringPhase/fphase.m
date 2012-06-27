function fp = fphase(DataSet)
% fphase.m
% 2008-10-17 by Zhang Li
% Organize Phase of Firing

if ( isfield(DataSet.Wave,'phase') && isfield(DataSet,'Snip') )
    
    fp = zeros([size(DataSet.Snip.snip) 2])+10;
    
    for i=1:DataSet.Snip.chn
        for j=1:DataSet.Snip.sortn(i)
            for s=1:DataSet.Mark.stimuli
                for t=1:DataSet.Mark.trial
                    wpdata = squeeze(DataSet.Wave.phase(i,t,s,:));
                    spdata = squeeze(DataSet.Snip.snip(i,j,t,s,:));
                    spdata = spdata(spdata~=0);
                    sp=spdata-DataSet.Mark.on(t,s);
                    sp = round(sp * DataSet.Wave.fs)+1;
                    
                    fp(i,j,t,s,1:length(sp),1) = wpdata(sp);
                    fp(i,j,t,s,1:length(sp),2) = spdata;
                end
            end
        end
    end
    
else
    disp('No Valid Data !');
    errordlg('No WavePhase or Snip !','No Valid Data !');
end

end % end of function





