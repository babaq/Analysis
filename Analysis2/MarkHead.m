function MH = MarkHead(MH)
% MarkHead.m
% 2009-03-27 Zhang Li
% Decode and Validate MarkHead Information

% Pre-Defined Experiment Types
EXTYPE = {
    'dBar',...
    'RF_dBar',...
    'fBar',...
    'RF_fBar',...
    'dGrating',...
    'fGrating',...
    'Plaid',...
    'RandomLine',...
    'OpticFlow',...
    'Two_dBar',...
    'Two_dGrating',...
    'Two_fBar',...
    'Two_fGrating',...
    'Context',...
    'RF'
    };

% Pre-Defined Experiment Parameters
EXPARA = {
    'Orientation',...
    'Direction',...
    'Speed',...
    'Luminance',...
    'Contrast',...
    'SpatialFreq',...
    'SpatialPhase',...
    'TemporalFreq',...
    'TemporalPhase',...
    'Color',...
    'Disparity',...
    'Size',...
    'Location'
    };


%% Get MarkHead Keywords

% Get MarkHead Common Keywords
j=0;
for i=1:8:MH.markn
    j=j+1;
    c=floor((MH.mark(i+5)-MH.mark(i+4))*1000/5);
    if(c==16)
        j=i+8;
        break;
    else
        a=floor((MH.mark(i+1)-MH.mark(i))*1000/5);
        b=floor((MH.mark(i+3)-MH.mark(i+2))*1000/5);
        d=floor((MH.mark(i+7)-MH.mark(i+6))*1000/5);
        MH.key{j,2}=a*4096+b*256+c*16+d;
    end
end

% Get MarkHead Custom Keywords
k=0;
for i=j:8:MH.markn
    k=k+1;
    d=floor((MH.mark(i+7)-MH.mark(i+6))*1000/5);
    if(d==16)
        k=i+8;
        break;
    else
        a=floor((MH.mark(i+1)-MH.mark(i))*1000/5);
        b=floor((MH.mark(i+3)-MH.mark(i+2))*1000/5);
        c=floor((MH.mark(i+5)-MH.mark(i+4))*1000/5);
        MH.ckey{k,2}=a*4096+b*256+c*16+d;
    end
end


%% Parse MarkHead Keyworks

% Get Experiment Type
MH.key{1,1} = 'Experiment';
MH.key{1,2} = EXTYPE{MH.key{1,2}};

% Parse Common Keywords
    function key = parsecommon(key)
        % Get Condition Parameter
        key{2,1} = 'ExParameter';
        key{2,2} = EXPARA{key{2,2}};

        % Get Condition Number
        key{3,1} = 'Condition';

        % Get RandomSeed
        key{4,1} = 'RandomSeed';

        % Get Trial
        key{5,1} = 'Trial';
    end

nparaBar = 7;
% Parse Common Bar Keywords
    function ckey = parsecommonBar(ckey,npara)
        for i=0:floor(size(ckey,1)/npara)-1
            ckey{1+i*npara,1} = 'Height';
            ckey{2+i*npara,1} = 'Width';
            ckey{3+i*npara,1} = 'Orientation';
            ckey{4+i*npara,1} = 'Direction';
            ckey{5+i*npara,1} = 'Speed';
            ckey{6+i*npara,1} = 'CenterX';
            ckey{7+i*npara,1} = 'CenterY';
            
            ckey{1+i*npara,2} = ckey{1+i*npara,2}/100;
            ckey{2+i*npara,2} = ckey{2+i*npara,2}/100;
            ckey{3+i*npara,2} = ckey{3+i*npara,2}/100;
            ckey{4+i*npara,2} = ckey{4+i*npara,2}/100;
            ckey{5+i*npara,2} = ckey{5+i*npara,2}/100;
            ckey{6+i*npara,2} = ckey{6+i*npara,2}/100-60;
            ckey{7+i*npara,2} = ckey{7+i*npara,2}/100-60;
        end
    end

nparaGrating = 10;
% Parse Common Grating Keywords
    function ckey = parsecommonGrating(ckey,npara)
        for i=0:floor(size(ckey,1)/npara)-1
            ckey{1+i*npara,1} = 'TemporalFreq';
            ckey{2+i*npara,1} = 'SpatialFreq';
            ckey{3+i*npara,1} = 'SpatialPhase';
            ckey{4+i*npara,1} = 'Orientation';
            ckey{5+i*npara,1} = 'Direction';
            ckey{6+i*npara,1} = 'Luminance';
            ckey{7+i*npara,1} = 'Contrast';
            ckey{8+i*npara,1} = 'CenterX';
            ckey{9+i*npara,1} = 'CenterY';
            ckey{10+i*npara,1} = 'Diameter';
            
            ckey{1+i*npara,2} = ckey{1+i*npara,2}/100;
            ckey{2+i*npara,2} = ckey{2+i*npara,2}/100;
            ckey{3+i*npara,2} = ckey{3+i*npara,2}/100;
            ckey{4+i*npara,2} = ckey{4+i*npara,2}/100;
            ckey{5+i*npara,2} = ckey{5+i*npara,2}/100;
            ckey{6+i*npara,2} = ckey{6+i*npara,2}/100;
            ckey{7+i*npara,2} = ckey{7+i*npara,2}/100;
            ckey{8+i*npara,2} = ckey{8+i*npara,2}/100-60;
            ckey{9+i*npara,2} = ckey{9+i*npara,2}/100-60;
            ckey{10+i*npara,2} = ckey{10+i*npara,2}/100;
        end
    end


switch MH.key{1,2}
    case {'dBar','Two_dBar'}
        MH.key = parsecommon(MH.key);
        MH.ckey = parsecommonBar(MH.ckey,nparaBar);
        
        if size(MH.ckey,1) > nparaBar % Two_dBar
            if (MH.key{3,2}==0) % Two_sdBar
                MH.key{1,2}='Two_sdBar';
            else % Two_mdBar
                MH.key{1,2}='Two_mdBar';
            end
            MH.ckey{end,1} = 'BarAngle';
            MH.ckey{end,2} = MH.ckey{end,2}/100;
        else % dBar
            if (MH.key{3,2}==0) % sdBar
                MH.key{1,2}='sdBar';
            else % mdBar
                MH.key{1,2}='mdBar';
            end
        end
        
    case {'dGrating','Two_dGrating','Plaid'}
        MH.key = parsecommon(MH.key);
        MH.ckey = parsecommonGrating(MH.ckey,nparaGrating);
        
        if size(MH.ckey,1) > nparaGrating % Two_dGrating/Plaid
            if (MH.key{3,2}==0) % Two_sdGrating/sPlaid
                if strcmp(MH.key{1,2},'Plaid')
                    MH.key{1,2}='sPlaid';
                else
                    MH.key{1,2}='Two_sdGrating';
                end
            else % Two_mdGrating/mPlaid
                if strcmp(MH.key{1,2},'Plaid')
                    MH.key{1,2}='mPlaid';
                else
                    MH.key{1,2}='Two_mdGrating';
                end
            end
            MH.ckey{end,1} = 'GratingAngle';
            MH.ckey{end,2} = MH.ckey{end,2}/100;
        else % dGrating
            if (MH.key{3,2}==0) % sdGrating
                MH.key{1,2}='sdGrating';
            else % mdGrating
                MH.key{1,2}='mdGrating';
            end
        end
        
    case 'fBar'
        MH.key = parsecommon(MH.key);

        if (MH.key{3,2}==0) % sfBar
            MH.key{1,2}='sfBar';
        else % mfBar
            MH.key{1,2}='mfBar';
        end

    case 'fGrating'

        % Get Condition Parameter
        MH.key{2,1} = 'ExParameter1';
        MH.key{2,2} = EXPARA{MH.key{2,2}};
        % Get Condition Number
        MH.key{3,1} = 'Condition1';

        MH.key{4,1} = 'ExParameter2';
        MH.key{4,2} = EXPARA{MH.key{4,2}};
        MH.key{5,1} = 'Condition2';

        MH.key{6,1} = 'ExParameter3';
        MH.key{6,2} = EXPARA{MH.key{6,2}};
        MH.key{7,1} = 'Condition3';

        % Get RandomSeed
        MH.key{8,1} = 'RandomSeed';
        % Get Trial
        MH.key{9,1} = 'Trial';
        
        MH.ckey = parsecommonGrating(MH.ckey,nparaGrating);
        
        if size(MH.ckey,1) > nparaGrating
            MH.key{1,2} = 'fGrating_Surround';
            MH.ckey{end,1} = 'CenterDiameter';
            MH.ckey{end,2} = MH.ckey{end,2}/100;
        end
        
    case 'RF_dBar'
        MH.key = parsecommon(MH.key);
        MH.ckey = parsecommonBar(MH.ckey,nparaBar);
        MH.ckey{end-3,1} = 'ScreenH';
        MH.ckey{end-3,2} = MH.ckey{end-3,2}/100;
        MH.ckey{end-2,1} = 'ScreenW';
        MH.ckey{end-2,2} = MH.ckey{end-2,2}/100;
        MH.ckey{end-1,1} = 'Rows';
        MH.ckey{end,1} = 'Step';
        MH.ckey{end,2} = MH.ckey{end,2}/100;
        
        if (MH.key{3,2}==0) % RF_sdBar
            MH.key{1,2}='RF_sdBar';
        else % RF_mdBar
            MH.key{1,2}='RF_mdBar';
        end

    case 'RF_fBar'
        MH.key = parsecommon(MH.key);

        if size(MH.ckey,1) > nparaBar + 6
            MH.ckey(1:nparaBar,:) = parsecommonBar(MH.ckey(1:nparaBar,:),nparaBar);
            if (MH.key{3,2}==0) % RF_sfBar_Surround
                MH.key{1,2}='RF_sfBar_Surround';
            else % RF_mfBar_Surround
                MH.key{1,2}='RF_mfBar_Surround';
            end
            MH.ckey{end-6,1} = 'CenterDiameter';
            MH.ckey{end-6,2} = MH.ckey{end-6,2}/100;
        else
            MH.ckey = parsecommonBar(MH.ckey,nparaBar);
            if (MH.key{3,2}==0) % RF_sfBar
                MH.key{1,2}='RF_sfBar';
            else % RF_mfBar
                MH.key{1,2}='RF_mfBar';
            end
        end
            
        MH.ckey{end-5,1} = 'ScreenH';
        MH.ckey{end-5,2} = MH.ckey{end-5,2}/100;
        MH.ckey{end-4,1} = 'ScreenW';
        MH.ckey{end-4,2} = MH.ckey{end-4,2}/100;
        MH.ckey{end-3,1} = 'Rows';
        MH.ckey{end-2,1} = 'Columns';
        MH.ckey{end-1,1} = 'Rstep';
        MH.ckey{end-1,2} = MH.ckey{end-1,2}/100;
        MH.ckey{end,1} = 'Cstep';
        MH.ckey{end,2} = MH.ckey{end,2}/100;
        
    case 'RF'
        
        % Get Condition Parameter
        MH.key{2,1} = 'ExParameter';
        MH.key{2,2} = EXPARA{MH.key{2,2}};
        
        if strcmp(MH.key{2,2},'Size')
            MH.key{1,2} = 'RF_Size';
            % Get Condition Number
            MH.key{3,1} = 'Condition';
            
            MH.key{4,1} = 'ConditionStart';
            MH.key{5,1} = 'ConditionEnd';
            % Get RandomSeed
            MH.key{6,1} = 'RandomSeed';
            % Get Trial
            MH.key{7,1} = 'Trial';
            
            MH.ckey = parsecommonGrating(MH.ckey,nparaGrating);
        else
            if size(MH.ckey,1) > nparaGrating + 3
                MH.key{1,2} = 'RF_Surround';
                MH.ckey{end-3,1} = 'CenterDiameter';
                MH.ckey{end-3,2} = MH.ckey{end-3,2}/100;
            else
                MH.key{1,2} = 'RF_Center';
            end
            % Get Condition Number
            MH.key{3,1} = 'Condition';
            % Get RandomSeed
            MH.key{4,1} = 'RandomSeed';
            % Get Trial
            MH.key{5,1} = 'Trial';
            
            MH.ckey = parsecommonGrating(MH.ckey,nparaGrating);
            MH.ckey{end-2,1} = 'ScreenH';
            MH.ckey{end-2,2} = MH.ckey{end-2,2}/100;
            MH.ckey{end-1,1} = 'ScreenW';
            MH.ckey{end-1,2} = MH.ckey{end-1,2}/100;
            MH.ckey{end,1} = 'Step';
            MH.ckey{end,2} = MH.ckey{end,2}/100;
        end
        
    case 'Context'
        
        % Get Condition Parameter
        MH.key{2,1} = 'ExParameter1';
        MH.key{2,2} = EXPARA{MH.key{2,2}};
        % Get Condition Number
        MH.key{3,1} = 'Condition1';
        
        MH.key{4,1} = 'ExParameter2';
        MH.key{4,2} = EXPARA{MH.key{4,2}};
        MH.key{5,1} = 'Condition2';
        
        % Get RandomSeed
        MH.key{6,1} = 'RandomSeed';
        % Get Trial
        MH.key{7,1} = 'Trial';
        
        MH.ckey = parsecommonGrating(MH.ckey,nparaGrating);
        MH.key{1,2} = 'CenterSurround';
        
    otherwise

end

% Set Alias
MH.extype = MH.key{1,2};
MH.trial = MH.key{end,2};


%% Recover Experiment Random Sequence, Condition Table and Stimuli to Condition Conversion Table

% Recover Experiment Stimuli to Condition Conversion Table
    function stitable = sti2con(varargin)
        cond = cellfun(@(x)x(~isempty(x)),varargin);
        sn = prod(cond);
        cti = cond;
        stitable = cell(1,sn);
        for si=0:sn-1
            cti(1) = si;
            for ci=1:length(cond)-1
                subprod = prod(cond(ci+1:end));
                subs = cti(ci);
                cti(ci) = floor(subs/subprod);
                cti(ci+1) = mod(subs,subprod);
            end
            stitable{1,si+1} = cti+1;
        end
    end


switch MH.extype
    case {'sdBar','mdBar','Two_sdBar','Two_mdBar','sdGrating','mdGrating','Two_sdGrating','Two_mdGrating','sPlaid','mPlaid'}
        MH.stimuli = MH.key{3,2} + 1; % additional Blank Control
        MH.condtable{1} = [360 (0:MH.key{3,2}-1) * (360/MH.key{3,2})];
        MH.stitable = sti2con(MH.key{3,2}+1);
    case {'fGrating','fGrating_Surround'}
        MH.stimuli = MH.key{3,2} * MH.key{5,2} * MH.key{7,2};
        MH.condtable{1} = (0:MH.key{3,2}-1) * (180/MH.key{3,2});
        MH.condtable{2} = 0.1*2.^(0:MH.key{5,2}-1);
        MH.condtable{3} = (0:MH.key{7,2}-1) * (1/MH.key{7,2});
        MH.stitable = sti2con(MH.key{3,2},MH.key{5,2},MH.key{7,2});
    case {'RF_sfBar','RF_sfBar_Surround'}
        MH.stimuli = MH.ckey{end-3,2} * MH.ckey{end-2,2} * 2; % Black and White
        MH.condtable{1} = (1:MH.ckey{end-3,2});
        MH.condtable{2} = (1:MH.ckey{end-2,2});
        MH.condtable{3} = [0 1];
        MH.stitable = sti2con(MH.ckey{end-3,2},MH.ckey{end-2,2},2);
    case {'RF_mfBar','RF_mfBar_Surround'}
        MH.stimuli = MH.key{3,2} * MH.ckey{end-3,2} * MH.ckey{end-2,2} * 2;
        MH.condtable{1} = (0:MH.key{3,2}-1) * (180/MH.key{3,2});
        MH.condtable{2} = (1:MH.ckey{end-3,2});
        MH.condtable{3} = (1:MH.ckey{end-2,2});
        MH.condtable{4} = [0 1];
        MH.stitable = sti2con(MH.key{3,2},MH.ckey{end-3,2},MH.ckey{end-2,2},2);
    case 'RF_sdBar'
        MH.stimuli = MH.ckey{end-1,2};
        MH.condtable{1} = (1:MH.ckey{end-1,2});
        MH.stitable = sti2con(MH.ckey{end-1,2});
    case 'RF_mdBar'
        MH.stimuli = MH.key{3,2} * MH.ckey{end-1,2};
        MH.condtable{1} = (0:MH.key{3,2}-1) * (360/MH.key{3,2});
        MH.condtable{2} = (1:MH.ckey{end-1,2});
        MH.stitable = sti2con(MH.key{3,2},MH.ckey{end-1,2});
    case 'RF_Size'
        MH.stimuli = MH.key{3,2};
        ct = (MH.key{4,2}:(MH.key{5,2}-MH.key{4,2})/(MH.key{3,2}-1):MH.key{5,2});
        MH.stitable = sti2con(MH.key{3,2});
        if ct(end)>10 % replace additional larger stimuli [10.5 11 11.5 12 ...] to [11 13 17 25 ...]
            rls = [11 13 17 25 30 40];
            j=1;
            for i=find(ct>10)
                ct(i) = rls(j);
                j = j + 1;
            end
        end
        MH.condtable{1} = ct;
    case {'RF_Center','RF_Surround'}
        MH.stimuli = MH.key{3,2} * MH.key{3,2};
        MH.condtable{1} = (1:MH.key{3,2});
        MH.condtable{2} = (1:MH.key{3,2});
        MH.stitable = sti2con(MH.key{3,2},MH.key{3,2});
    case 'CenterSurround'
        MH.stimuli = (MH.key{3,2}+1) * (MH.key{5,2}+1);
        MH.condtable{1} = [180 (0:MH.key{3,2}-1) * (180/MH.key{3,2})];
        MH.condtable{2} = [180 (0:MH.key{5,2}-1) * (180/MH.key{5,2})];
        MH.stitable = sti2con(MH.key{3,2}+1,MH.key{5,2}+1);
    otherwise

end

MH.exseq = RecoverRandom(MH.key{end-1,2},MH.key{end,2},MH.stimuli);
MH.exseq = MH.exseq';


%% on/off Tick and Marker Validation
MH.tick = MH.mark(1,k:end);

% Check Marker Completion
if( length(MH.tick)/2 == numel(MH.exseq) )
    MH.hresult = 'S_OK';

    % -----Organize tick in two marker mode----- %
    MH.ticktype = 'two';
    on = MH.tick(1,1:2:end);
    off = MH.tick(1,2:2:end);
    sti = size(MH.exseq,2);
    trial = size(MH.exseq,1);
    MH.on = zeros(trial,sti);
    MH.off = zeros(trial,sti);

    for i=0:length(on)-1
        a = 1+floor(i/sti);
        b = i-(sti*(a-1))+1;
        b = MH.exseq(a,b)+1;
        MH.on(a,b) = on(i+1);
        MH.off(a,b) = off(i+1);
    end
elseif( length(MH.tick) == numel(MH.exseq) )
    MH.hresult = 'S_OK';

    % -----Organize tick in one marker mode----- %
    MH.ticktype = 'one';
    on = MH.tick;
    off = circshift(MH.tick,[0,-1]);
    off(end) = off(end-1) + (on(2)-on(1));
    sti = size(MH.exseq,2);
    trial = size(MH.exseq,1);
    MH.on = zeros(trial,sti);
    MH.off = zeros(trial,sti);

    for i=0:length(on)-1
        a = 1+floor(i/sti);
        b = i-(sti*(a-1))+1;
        b = MH.exseq(a,b)+1;
        MH.on(a,b) = on(i+1);
        MH.off(a,b) = off(i+1);
    end
else
    MH.hresult = 'E_FAIL';
end
end % EOF
