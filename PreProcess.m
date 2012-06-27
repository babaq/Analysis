function Data = PreProcess(DataSet,Extent,Delay,Type,varargin)
%                       PreProcess.m
%                     2011-03-17 Zhang Li
%   Organize All Neural Data Accordding to Experiment Design
%
%           Data = PreProcess(DataSet,Extent,Delay,Type)
%           Data = PreProcess(DataSet,Extent,Delay,Type,Step,Course)
%
%   Data Segment are extended/shrinked on +/-(Extent)(ms)
%   Delay is the Segment time shift on +/-(Delay)(ms) after/before stimulus onset
%   Process Type is either 1(Snip) or 2(Wave) or 0(Both)
%   Step(varargin 1) is the time step(ms) used in dynamics of firing of Reverse-Correlation Diagram
%   Course(varargin 2) is the time course(ms) of stepping of Reverse-Correlation Diagram
%       ----------------------------------------------
%       ------------Data Structure to Method----------
%       ----------------------------------------------
%       Data.Dinf --- Data Source Information
%                   Dinf.server --- Data Source Server(String)
%                   Dinf.tank --- Data Tank Name(String)
%                   Dinf.block --- Data Block Name(String)
%                   Dinf.extent --- Data Segment Extend Time(double)(sec)
%                   Dinf.delay --- Data Segment Delay Time(double)(sec)
%                   Dinf.msegt --- Mean Data Segment Duration Time(double)(sec)
%
%       ----------------------------------------------
%       Data.Mark --- Marker Data
%                   Mark.mark --- All Marker TimeStamp[1,:]
%                   Mark.markn --- Total Marker Number(unsigned int)
%                   Mark.key --- MarkHead Common Keywords{:,2}
%
%                           For Example:
%
%                               'Experiment'    'dBar'
%                               'ExParameter'   'Direction'
%                               'Condition'     16
%                               'RandomSeed'    26
%                               'Trial'         30
%                               .               .
%                               .               .
%                               .               .
%
%                   Mark.extype --- Experiment Type(string)
%                   Mark.trial --- Experiment Trials(unsigned int)
%                   Mark.ckey --- MarkHead Custom Keywords{:,2}
%
%                           For Example:
%
%                               'Height'        1
%                               'Width'         4
%                               'Orientation'   90
%                               'Direction'     0
%                               'Speed'         20
%                               'CenterX'       0
%                               'CenterY'       3
%                               .               .
%                               .               .
%                               .               .
%
%                   Mark.stimuli --- Real Stimulus Number(unsigned int)
%                   Mark.condtable --- Array of All Condition Levels{1,Condn}[1,CondLeveln]
%                   Mark.stitable --- Conversion Array of Stimuli to CondTable Index{1,Stimuli}[Cond1_LevelIndex,Cond2_LevelIndex,...]
%                   Mark.exseq --- Experiment Random Sequence[Trial,Stimuli]
%                   Mark.tick --- Real Stimulus Marker TimeStamp[1,:]
%                   Mark.hresult --- Marker Completion Check(String)
%                   Mark.ticktype --- Stimulus Marker Encoding Type(String)
%                   Mark.on --- Real Stimulus Onset[Trial,Stimuli]
%                   Mark.off --- Real Stimulus Offset[Trial,Stimuli]
%
%       ----------------------------------------------
%       Data.Snip --- Spike Data
%                   Snip.spevent --- Spike Event Name(String)
%                   Snip.chn --- Channal Number(unsigned int)
%                   Snip.swn --- Snip Wave Segment Sample Number(unsigned int)
%                   Snip.fs --- Snip Wave Segment Sampling Frequency(double)
%                   Snip.sortn --- Sort Number of Each Channal[Channal,1]
%                   Snip.ppsortn --- Sort Number of Each Channal[Channal,1] (PreProcessed, Multi-SU Pooled To MU In End)
%                   Snip.snipn --- Spike Number of Each Channal and Sort{Channal,Sortcode}
%                   Snip.ppsnipn --- Spike Number of Each Channal and Sort{Channal,Sortcode} (PreProcessed, Multi-SU Pooled To MU In End)
%                   ----------------------------------------------
%                   Snip.snip --- Snip In Channals and Sorts
%                               snip{Channal,Sortcode}.spike --- All Raw Spike TimeStamp [1,TimeStamp] (Original)
%                               snip{Channal,Sortcode}.ppspike --- All Spike TimeStamp{Trial,Stimuli}[1,TimeStamp] (PreProcessed, Multi-SU Pooled To MU In End)
%
%                               For Example:
%
%                               Data.Snip.snip{Channal_1,Sort_1}.spike(Trial_1,Stimuli_1,:) is organized as such:
%
%                               1-2-3-     ...     -10-11-12-13-14-15-   ...   -(n-2)-(n-1)-n
%                               |           |            |            |            |        |
%                            -Extent  Stimulus Onset   Delay    Stimulus Offset  Delay    Extent
%
%                              snip{Channal,Sortcode}.spikewave --- All Raw Spike Segments{[1,TimeStamp] [Segment,TimeStamp]} (Original)
%                              snip{Channal,Sortcode}.ppfr --- ReverseCorrelation Dynamic Firing Rate[Trial,Stimuli,DelayStep] (PreProcessed, SU Pooled To MU In End)
%
%       -----------------------------------------------
%       Data.Wave --- Wave Data
%                   Wave.wvevent --- Wave Event Name(String)
%                   Wave.chn --- Channal Number(unsigned int)
%                   Wave.fs --- Wave Sampling Frequency(double)
%                   Wave.ontime --- Begin Time of Wave(double)
%                   ----------------------------------------------
%                   Wave.wave --- Wave In Channals
%                               wave{Channal}.wave --- All Raw Wave Data [1,DataPoint] (Original)
%                               wave{Channal}.ppwave --- All Wave Data {Trial,Stimuli}[DataPoint,1] (PreProcessed, LineNoise Removed)
%                               wave{Channal}.phase --- All Raw Wave Phase [1,PhasePoint] (Original)
%                                                       All Wave Phase [Trial,Stimuli,PhasePoint] (PreProcessed)
%
%                               Wave Extent and Delay Organization is the same as Data.Snip.snip.spike
%
%       ------------------------------------------------
%       Data.Method --- Analysis Method(String)
%
%       ------------------------------------------------
%       Data.OutputDir --- Result Output Path(String)
%

Data.Dinf = DataSet.Dinf;
extent=Extent/1000; % convert to second
delay=Delay/1000; % convert to second
Data.Dinf.extent = extent;
Data.Dinf.delay = delay;

Data.Mark = DataSet.Mark;
Data.Method = DataSet.Method;
Data.OutputDir = DataSet.OutputDir;

mstidur = mean(mean(Data.Mark.off-Data.Mark.on));
Data.Dinf.msegt = mstidur+2*extent;
%% PreProcess Snip Data
if isfield(DataSet,'Snip')
    
    Data.Snip = DataSet.Snip;
    
    if Type~=2
        
        % In default Two/One Marker Mode, Organize Stimulus-Response Spikes
        ppsortn = Data.Snip.sortn;
        ppsnipn = Data.Snip.snipn;
        for i=1:Data.Snip.chn
            for j=1:Data.Snip.sortn(i)
                for t=1:Data.Mark.trial
                    for s=1:Data.Mark.stimuli
                        
                        spikeindex = Data.Mark.on(t,s)-extent+delay<=Data.Snip.snip{i,j}.spike & ...
                            Data.Snip.snip{i,j}.spike<Data.Mark.off(t,s)+extent+delay;
                        Data.Snip.snip{i,j}.ppspike{t,s} = Data.Snip.snip{i,j}.spike(spikeindex);
                        
                    end
                end
            end
            
            if Data.Snip.sortn(i)>1 % Have multi SU, need pooling SU to MU
                ppsortn(i) = ppsortn(i) + 1;
                ppsnipn{ppsortn(i)} = 0;
                
                temp = cell(Data.Mark.trial,Data.Mark.stimuli);
                for j=1:Data.Snip.sortn(i)
                    for t=1:Data.Mark.trial
                        for s=1:Data.Mark.stimuli
                            
                            temp{t,s} = [temp{t,s} Data.Snip.snip{i,j}.ppspike{t,s}];
                            
                        end
                    end
                    ppsnipn{ppsortn(i)} = ppsnipn{ppsortn(i)} + ppsnipn{j};
                end
                
                Data.Snip.snip{i,ppsortn(i)}.ppspike = temp;
            end
            
        end
        Data.Snip.ppsortn = ppsortn;
        Data.Snip.ppsnipn = ppsnipn;
        
        
        
        % In One Marker Mode, Get Reverse Correlation Dynamic Firing Rate
        if strcmp(Data.Mark.ticktype,'one') && length(varargin)==2
            step = varargin{1}/1000; % convert to second
            course = varargin{2}/1000; % convert to second
            Data.Dinf.step = step;
            Data.Dinf.course = course;
            
            stepn = floor(course/step);
            for i=1:Data.Snip.chn
                for j=1:Data.Snip.sortn(i)
                    
                    sp = Data.Snip.snip{i,j}.spike;
                    for d=1:stepn
                        
                        tickn = length(Data.Mark.tick);
                        tickbin = cat(2,Data.Mark.tick,Data.Mark.tick(end) + mstidur);
                        spcount = histc(sp,tickbin + step*(d-1));
                        temp = spcount(1:tickn)/mstidur;
                        
                        for k=0:tickn-1
                            t = floor(k/Data.Mark.stimuli)+1;
                            s = k-(Data.Mark.stimuli*(t-1))+1;
                            s = Data.Mark.exseq(t,s)+1;
                            Data.Snip.snip{i,j}.ppfr(t,s,d) = temp(k+1);
                        end
                    end
                end
                
                if Data.Snip.sortn(i)>1 % Have multi SU, need pooling SU to MU
                    temp = 0;
                    for j=1:Data.Snip.sortn(i)
                        temp = temp + Data.Snip.snip{i,j}.ppfr;
                    end
                    Data.Snip.snip{i,Data.Snip.ppsortn(i)}.ppfr = temp;
                end
                
            end
        end
        
    end
    
end

%% PreProcess Wave Data
if isfield(DataSet,'Wave')
    
    Data.Wave = DataSet.Wave;
    
    f0 = 50; % Line Noise Frequency
    nharmonic = 1;
    xsd = 4; % X times SD to remove wave artifact
    isrmartifact = 1;
    isrmline = 1;
    thrasn = 3;
    
    if (isfield(Data,'Snip')) && (isfield(Data.Snip,'ppsortn')) && (length(varargin)==2)
        pret = varargin{1}/1000; % convert to second
        post = varargin{2}/1000; % convert to second
        Data.Dinf.pret = pret;
        Data.Dinf.post = post;
        pret=round(pret*Data.Wave.fs);
        post=round(post*Data.Wave.fs);
        isrmspike = 1;
    else
        isrmspike = 0;
    end
    
    if Type~=1
        
        % In default Two Marker Mode, organize Stimulus-Response Wave DataPoints
        
        for i=1:Data.Wave.chn
            for s=1:Data.Mark.stimuli
                for t=1:Data.Mark.trial
                    
                    
                    a=Data.Mark.on(t,s)-extent+delay-Data.Wave.ontime;
                    b=Data.Mark.off(t,s)+extent+delay-Data.Wave.ontime;
                    a=round(a*Data.Wave.fs);
                    b=round(b*Data.Wave.fs);
                    temp = Data.Wave.wave{i}.wave(a:b);
                    
                    if isrmartifact
                        [temp info] = rmartifact(temp,xsd,[]);
                        if info.isartifact
                            asn = length(info.asn);
                            disp(['In Channal ',num2str(i),', Trial ',num2str(t),', Stimuli ',num2str(s),...
                                ', Mean¡À',num2str(xsd),'SD Wave Artifacts have been linearly interpolated.']);
                            for ai=1:asn
                                disp(['Artifact',num2str(ai),'---',num2str(info.asn(ai)*1000/Data.Wave.fs),' ms']);
                            end
                            if asn>thrasn
                                disp(['More than ',num2str(thrasn),' Artifacts, Need to delete this trial.']);
                            end
                            disp('-------------------------------------------------------------------------');
                        end
                    end
                    if isrmline
                        temp = rmline(temp',DataSet.Wave.fs,f0,nharmonic);
                    end
                    if isrmspike
                        st = Data.Snip.snip{i,Data.Snip.ppsortn(i)}.ppspike{t,s};
                        if ~isempty(st)
                            st = st - (DataSet.Mark.on(t,s)-extent+delay);
                            st = round(st*Data.Wave.fs);
                            Data.Wave.wave{i}.ppwave{t,s} = rmspike(temp,st,pret,post);
                        else
                            Data.Wave.wave{i}.ppwave{t,s} = temp;
                        end
                    else
                        Data.Wave.wave{i}.ppwave{t,s} = temp;
                    end
                end
            end
        end
        
    end
    
end

end %eof