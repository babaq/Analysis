function mapdata = RFMap_Grating(DataSet,datatype,varargin)
% RFMap_Grating.m
% 2012-04-22 by Zhang Li
% Calculate Grating RF Map
%
% datatype is a string indicating which data is used( 'Snip' or 'rms', 'max', 'min', 'power' of Wave )


rows = DataSet.Mark.key{3,2};
msegt = DataSet.Dinf.msegt;

if strcmp(datatype,'Snip') % Snip Data
    
    chn = DataSet.Snip.chn;
    for i=1:chn
        for j=1:DataSet.Snip.ppsortn(i)
            mapdata{i,j}=zeros(DataSet.Mark.trial,rows,rows);
        end
    end
    
    for i=1:chn
        for j=1:DataSet.Snip.ppsortn(i)
            for t=1:DataSet.Mark.trial
                for s=1:DataSet.Mark.stimuli
                    
                    spike = DataSet.Snip.snip{i,j}.ppspike{t,s};
                    spike_count=length(spike(spike~=0));
                    
                    cti = DataSet.Mark.stitable{s};
                    mapdata{i,j}(t,cti(1),cti(2)) = spike_count/msegt;
                    
                end
            end
        end
    end
    
else % Wave Data
    
    chn = DataSet.Wave.chn;
    for i=1:chn
        mapdata{i,1}=zeros(DataSet.Mark.trial,rows,rows);
    end
    
    switch datatype
        case 'power'
            if isempty(varargin)
                psd = powerspectrum(DataSet,'ps');
                ptrange = [30 100];
            else
                params = varargin{1};
                ptrange = varargin{2};
                psd = powerspectrum(DataSet,'ps',params);
            end
            wtc = WTC(DataSet,'power',psd,ptrange);
    end
    
    for i=1:chn
        for t=1:DataSet.Mark.trial
            for s=1:DataSet.Mark.stimuli
                
                w = DataSet.Wave.wave{i}.ppwave{t,s};
                switch datatype
                    case 'rms'
                        w = rms(w);
                    case 'max'
                        w = max(w);
                    case 'min'
                        w = min(w);
                    case 'power'
                        w = wtc{i,1}(t,s);
                end
                
                cti = DataSet.Mark.stitable{s};
                mapdata{i,1}(t,cti(1),cti(2)) = w;
            end
        end
    end
end

mapdata{chn+1,1}.datatype = datatype;