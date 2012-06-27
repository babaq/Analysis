function wp = phase(DataSet)
% phase.m
% 2008-10-13 by Zhang Li
% Organized Wavephase

if isfield(DataSet.Wave,'wavephase')
    stilast_m = min(min(DataSet.Mark.markoff - DataSet.Mark.markon));
    wl = floor(stilast_m*DataSet.Wave.samplefreq);
    wp = cell(DataSet.Wave.chnumber,DataSet.Mark.nstimuli);

    for i=1:DataSet.Wave.chnumber
        for s=1:DataSet.Mark.nstimuli
            wp{i,s}=zeros(DataSet.Mark.trial,wl);
        end
    end
    
    for i=1:DataSet.Wave.chnumber   
        for s=1:DataSet.Mark.nstimuli
            for t=1:DataSet.Mark.trial
                wp{i,s}(t,:) = squeeze( DataSet.Wave.wavephase(i,t,s,1:wl) )';
            end
        end
    end

else
    disp('No Valid Data !');
    errordlg('Filter Wave First !','No WavePhase !');
end
