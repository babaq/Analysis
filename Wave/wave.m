function w = wave(DataSet)
% wave.m
% 2011-04-12 by Zhang Li
% Organize Waveform

if isfield(DataSet,'Wave')
    extent = DataSet.Dinf.extent;
    delay = DataSet.Dinf.delay;
    stidurmin = min(min( (DataSet.Mark.off+extent+delay) - (DataSet.Mark.on-extent+delay) ));
    wl = floor(stidurmin*DataSet.Wave.fs);

    for i=1:DataSet.Wave.chn
        w{i}=zeros(DataSet.Mark.trial,DataSet.Mark.stimuli,wl);
        for s=1:DataSet.Mark.stimuli
            for t=1:DataSet.Mark.trial
                w{i}(t,s,:) = DataSet.Wave.wave{i}.ppwave{t,s}(1:wl);
            end
        end
    end
    
else
    disp('No Valid Data !');
    warndlg('No Valid Data !','Warnning');
end
