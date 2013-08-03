function [ epi ] = SLParseES16( es )
%SLPARSEES16 Parse StiLib 16 number system eventseries encoding
%   Detailed explanation goes here
import Analysis.Base.StiLib.* Analysis.Base.mergestruct
en = length(es);
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
    'SpatialFrequency',...
    'SpatialPhase',...
    'TemporalFrequency',...
    'TemporalPhase',...
    'Color',...
    'Disparity',...
    'Size',...
    'Location'
    };
%% Get Header Keywords
% Header Common Keywords
j=1;
for i=1:8:en
    c = msdecode(es(i+5)-es(i+4));
    if(c==16)
        j=i+8;
        break;
    else
        a = msdecode(es(i+1)-es(i));
        b = msdecode(es(i+3)-es(i+2));
        d = msdecode(es(i+7)-es(i+6));
        key(j)=a*4096+b*256+c*16+d;
    end
    j=j+1;
end
% Header Custom Keywords
k=1;
for i=j:8:en
    d = msdecode(es(i+7)-es(i+6));
    if(d==16)
        k=i+8;
        break;
    else
        a = msdecode(es(i+1)-es(i));
        b = msdecode(es(i+3)-es(i+2));
        c = msdecode(es(i+5)-es(i+4));
        ckey(k)=a*4096+b*256+c*16+d;
    end
    k=k+1;
end
%% Parse Header Keyworks
% Parse Common Keywords function
    function epi = parsecommon(epi,key)
        % Get Experiment Variable
        epi.exvar = EXPARA{key(2)};
        % Get ExVar Condition Number
        epi.condn = key(3);
        % Get RandomSeed
        epi.rseed = key(4);
        % Get Trial
        epi.trial = key(5);
    end
nparamBar = 7;
% Parse Common Bar Keywords function
    function epi = parsecommonBar(epi,ckey,nparam)
        for i=0:floor(length(ckey)/nparam)-1
            cb = ['bar',num2str(i)];
            epi.(cb).height = ckey(1+i*nparam)/100;
            epi.(cb).width = ckey(2+i*nparam)/100;
            epi.(cb).orientation = ckey(3+i*nparam)/100;
            epi.(cb).direction = ckey(4+i*nparam)/100;
            epi.(cb).speed = ckey(5+i*nparam)/100;
            epi.(cb).centerx = ckey(6+i*nparam)/100-60;
            epi.(cb).centery = ckey(7+i*nparam)/100-60;
        end
    end
nparamGrating = 10;
% Parse Common Grating Keywords function
    function epi = parsecommonGrating(epi,ckey,nparam)
        for i=0:floor(length(ckey)/nparam)-1
            cg = ['grating',num2str(i)];
            epi.(cg).temporalfrequency = ckey(1+i*nparam)/100;
            epi.(cg).spatialfrequency = ckey(2+i*nparam)/100;
            epi.(cg).spatialphase = ckey(3+i*nparam)/100;
            epi.(cg).orientation = ckey(4+i*nparam)/100;
            epi.(cg).direction = ckey(5+i*nparam)/100;
            epi.(cg).luminance = ckey(6+i*nparam)/100;
            epi.(cg).contrast = ckey(7+i*nparam)/100;
            epi.(cg).centerx = ckey(8+i*nparam)/100-60;
            epi.(cg).centery = ckey(9+i*nparam)/100-60;
            epi.(cg).diameter = ckey(10+i*nparam)/100;
        end
    end
% Get Experiment Type
epi.ex = EXTYPE{key(1)};
switch epi.ex
    case {'dBar','Two_dBar'}
        epi = parsecommon(epi,key);
        epi = parsecommonBar(epi,ckey,nparamBar);
        if length(ckey) > nparamBar % Two_dBar
            if (epi.condn==0) % Two_sdBar
                epi.ex = 'Two_sdBar';
            else % Two_mdBar
                epi.ex = 'Two_mdBar';
            end
            epi.barangle = ckey(end)/100;
        else % dBar
            if (epi.condn==0) % sdBar
                epi.ex='sdBar';
            else % mdBar
                epi.ex='mdBar';
            end
        end
    case {'dGrating','Two_dGrating','Plaid'}
        epi = parsecommon(epi,key);
        epi = parsecommonGrating(epi,ckey,nparamGrating);
        if length(ckey) > nparamGrating % Two_dGrating/Plaid
            if (epi.condn==0) % Two_sdGrating/sPlaid
                if strcmp(epi.ex,'Plaid')
                    epi.ex='sPlaid';
                else
                    epi.ex='Two_sdGrating';
                end
            else % Two_mdGrating/mPlaid
                if strcmp(epi.ex,'Plaid')
                    epi.ex='mPlaid';
                else
                    epi.ex='Two_mdGrating';
                end
            end
            epi.gratingangle = ckey(end)/100;
        else % dGrating
            if (epi.condn==0) % sdGrating
                epi.ex='sdGrating';
            else % mdGrating
                epi.ex='mdGrating';
            end
        end
    case 'fBar'
        epi = parsecommon(epi,key);
        if (epi.condn==0) % sfBar
            epi.ex='sfBar';
        else % mfBar
            epi.ex='mfBar';
        end
    case 'fGrating'
        %%%%%%%%%%%%%%%%
        % Get Experiment Variable and Condition Number
        exvar{1} = EXPARA{key(2)};
        condn(1) = key(3);
        exvar{2} = EXPARA{key(4)};
        condn(2) = key(5);
        exvar{3} = EXPARA{key(6)};
        condn(3) = key(7);
        epi.exvar = exvar;
        epi.condn = condn;
        % Get RandomSeed
        epi.rseed = key(8);
        % Get Trial
        epi.trial = key(9);
        %%%%%%%%%%%%%%%%%
        epi = parsecommonGrating(epi,ckey,nparamGrating);
        if length(ckey) > nparamGrating
            epi.ex = 'fGrating_Surround';
            epi.centerdiameter = ckey(end)/100;
        end
    case 'RF_dBar'
        epi = parsecommon(epi,key);
        epi = parsecommonBar(epi,ckey,nparamBar);
        epi.screenheight = ckey(end-3)/100;
        epi.screenwidth = ckey(end-2)/100;
        epi.rows = ckey(end-1);
        epi.step = ckey(end)/100;
        if (epi.condn==0) % RF_sdBar
            epi.ex='RF_sdBar';
        else % RF_mdBar
            epi.ex='RF_mdBar';
        end
    case 'RF_fBar'
        epi = parsecommon(epi,key);
        if length(ckey) > nparamBar + 6
            epi = parsecommonBar(epi,ckey(1:nparamBar),nparamBar);
            if (epi.condn==0) % RF_sfBar_Surround
                epi.ex='RF_sfBar_Surround';
            else % RF_mfBar_Surround
                epi.ex='RF_mfBar_Surround';
            end
            epi.centerdiameter = ckey(end-6)/100;
        else
            epi = parsecommonBar(epi,ckey,nparamBar);
            if (epi.condn==0) % RF_sfBar
                epi.ex='RF_sfBar';
            else % RF_mfBar
                epi.ex='RF_mfBar';
            end
        end
        epi.screenheight = ckey(end-5)/100;
        epi.screenwidth = ckey(end-4)/100;
        epi.rows = ckey(end-3);
        epi.columns = ckey(end-2);
        epi.rowstep = ckey(end-1)/100;
        epi.columnstep = ckey(end)/100;
    case 'RF'
        epi.exvar = EXPARA{key(2)};
        if strcmp(epi.exvar,'Size')
            epi.ex = 'RF_Size';
            epi.condn = key(3);
            epi.condstart = key(4);
            epi.condstop = key(5);
            epi.rseed = key(6);
            epi.trial = key(7);
            epi = parsecommonGrating(epi,ckey,nparamGrating);
        else
            if length(ckey) > nparamGrating + 3
                epi.ex = 'RF_Surround';
                epi.centerdiameter = ckey(end-3)/100;
            else
                epi.ex = 'RF_Center';
            end
            epi.condn = key(3);
            epi.rseed = key(4);
            epi.trial = key(5);
            epi = parsecommonGrating(epi,ckey,nparamGrating);
            epi.screenheight = ckey(end-2)/100;
            epi.screenwidth = ckey(end-1)/100;
            epi.step = ckey(end)/100;
        end
    case 'Context'
        %%%%%%%%%%%%%%%%
        % Get Experiment Variable and Condition Number
        exvar{1} = EXPARA{key(2)};
        condn(1) = key(3);
        exvar{2} = EXPARA{key(4)};
        condn(2) = key(5);
        epi.exvar = exvar;
        epi.condn = condn;
        % Get RandomSeed
        epi.rseed = key(6);
        % Get Trial
        epi.trial = key(7);
        %%%%%%%%%%%%%%%%%
        epi = parsecommonGrating(epi,ckey,nparamGrating);
        epi.ex = 'CenterSurround';
    otherwise
end
%% Recover Random Sequence, Condition Table and Stimuli to Condition Table Conversion
switch epi.ex
    case {'sdBar','mdBar','Two_sdBar','Two_mdBar','sdGrating','mdGrating','Two_sdGrating','Two_mdGrating','sPlaid','mPlaid'}
        epi.stin = epi.condn + 1; % Additional Blank Control
        epi.sti2cti = sti2con(epi.stin);
        epi.condtable{1} = [360 (0:epi.condn-1) * (360/epi.condn)];
    case {'fGrating','fGrating_Surround'}
        epi.stin = prod(epi.condn);
        epi.sti2cti = sti2con(epi.condn(1),epi.condn(2),epi.condn(3));
        epi.condtable{1} = (0:epi.condn(1)-1) * (180/epi.condn(1));
        epi.condtable{2} = 0.1*2.^(0:epi.condn(2)-1);
        epi.condtable{3} = (0:epi.condn(3)-1) * (1/epi.condn(3));
    case {'RF_sfBar','RF_sfBar_Surround'}
        epi.stin = epi.rows * epi.columns * 2; % Black and White
        epi.sti2cti = sti2con(epi.rows,epi.columns,2);
        epi.condtable{1} = (1:epi.rows);
        epi.condtable{2} = (1:epi.columns);
        epi.condtable{3} = [0 1];
    case {'RF_mfBar','RF_mfBar_Surround'}
        epi.stin = epi.condn * epi.rows * epi.columns * 2;
        epi.sti2cti = sti2con(epi.condn,epi.rows,epi.columns,2);
        epi.condtable{1} = (0:epi.condn-1) * (180/epi.condn);
        epi.condtable{2} = (1:epi.rows);
        epi.condtable{3} = (1:epi.columns);
        epi.condtable{4} = [0 1];
    case 'RF_sdBar'
        epi.stin = epi.rows;
        epi.sti2cti = sti2con(epi.rows);
        epi.condtable{1} = (1:epi.rows);
    case 'RF_mdBar'
        epi.stin = epi.condn * epi.rows;
        epi.sti2cti = sti2con(epi.condn,epi.rows);
        epi.condtable{1} = (0:epi.condn-1) * (360/epi.condn);
        epi.condtable{2} = (1:epi.rows);
    case 'RF_Size'
        epi.stin = epi.condn;
        epi.sti2cti = sti2con(epi.condn);
        ct = (epi.condstart:(epi.condstop-epi.condstart)/(epi.condn-1):epi.condstop);
        if ct(end)>10 % replace additional larger stimuli [10.5 11 11.5 12 ...] to [11 13 17 25 ...]
            rls = [11 13 17 25 30 40];
            j=1;
            for i=find(ct>10)
                ct(i) = rls(j);
                j = j + 1;
            end
        end
        epi.condtable{1} = ct;
    case {'RF_Center','RF_Surround'}
        epi.stin = epi.condn * epi.condn;
        epi.sti2cti = sti2con(epi.condn,epi.condn);
        epi.condtable{1} = (1:epi.condn);
        epi.condtable{2} = (1:epi.condn);
    case 'CenterSurround'
        epi.stin = (epi.condn(1)+1) * (epi.condn(2)+1);
        epi.sti2cti = sti2con(epi.condn(1)+1,epi.condn(2)+1);
        epi.condtable{1} = [180 (0:epi.condn(1)-1) * (180/epi.condn(1))];
        epi.condtable{2} = [180 (0:epi.condn(2)-1) * (180/epi.condn(2))];
    otherwise
end
epi.rseq = RecoverRandomMSVCRT(epi.rseed,epi.trial,epi.stin);
%% on/off Tick and Validation
epi.tick = es(k:end);
tpi = stimark(epi.tick,epi.rseq);
epi = mergestruct(epi,tpi);
end