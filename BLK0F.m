function IDataSet = BLK0F(blkfile,zfn,tfn,type,method)
% BLK0F.m
% 2010-03-09 Zhang Li
% Convert Optic Imaging,Inc. Block File and analysis zero frame

%% read file
[hfile,hr] = fopen(blkfile,'r');
if hfile == -1
    disp(hr);
    return;
end

%% parse header
% Data Integrity
IDataSet.head.filesize = fread(hfile,1,'long');
IDataSet.head.checksumheader = fread(hfile,1,'long'); % Beginning with head.lenheader
IDataSet.head.checksumdata = fread(hfile,1,'long');

% Common to all data files
IDataSet.head.lenheader = fread(hfile,1,'long');
IDataSet.head.versionid = fread(hfile,1,'long');
% RAWBLOCK_FILE(11), DCBLOCK_FILE(12), SUM_FILE(13), IMAGE_FILE(14)
IDataSet.head.filetype = fread(hfile,1,'long');
% FROM_VDAQ(11), FROM_ORA(12)
IDataSet.head.filesubtype = fread(hfile,1,'long');
% DAT_UCHAR(11), DAT_USHORT(12), DAT_LONG(13), DAT_FLOAT(14)
IDataSet.head.datatype = fread(hfile,1,'long');
IDataSet.head.sizeof = fread(hfile,1,'long'); % e.g. sizeof(long), sizeof(float)
IDataSet.head.framewidth = fread(hfile,1,'long');
IDataSet.head.frameheight = fread(hfile,1,'long');
IDataSet.head.nframesperstim = fread(hfile,1,'long'); % data frames
IDataSet.head.nstimuli = fread(hfile,1,'long');
IDataSet.head.initialxbinfactor = fread(hfile,1,'long'); % from data acquisition
IDataSet.head.initialybinfactor = fread(hfile,1,'long'); % from data acquisition
IDataSet.head.xbinfactor = fread(hfile,1,'long'); % this file
IDataSet.head.ybinfactor = fread(hfile,1,'long'); % this file
IDataSet.head.username = fread(hfile,32,'*char');
IDataSet.head.recordingdata = fread(hfile,16,'*char');
IDataSet.head.x1roi = fread(hfile,1,'long');
IDataSet.head.y1roi = fread(hfile,1,'long');
IDataSet.head.x2roi = fread(hfile,1,'long');
IDataSet.head.y2roi = fread(hfile,1,'long');

% Locate data and ref frames
IDataSet.head.stimoffs = fread(hfile,1,'long');
IDataSet.head.stimsize = fread(hfile,1,'long');
IDataSet.head.frameoffs = fread(hfile,1,'long');
IDataSet.head.framesize = fread(hfile,1,'long');
IDataSet.head.refoffs = fread(hfile,1,'long'); % Imager 3001 has no ref
IDataSet.head.refsize = fread(hfile,1,'long'); % these fields will be 0
IDataSet.head.refwidth = fread(hfile,1,'long');
IDataSet.head.refheight = fread(hfile,1,'long');

% Common to data files that have undergone some form of 
% "compression" or "summing"; i.e. The data in the current 
% file may be the result of having summed blocks 'a'-'f', frames 1-7
IDataSet.head.whichblocks = fread(hfile,16,'ushort'); % 256 bits => max of 256 blocks per experiment
IDataSet.head.whichframes = fread(hfile,16,'ushort'); % 256 bits => max of 256 frames per condition

% Data analysis
IDataSet.head.loclip = fread(hfile,1,'float');
IDataSet.head.hiclip = fread(hfile,1,'float');
IDataSet.head.lopass = fread(hfile,1,'long');
IDataSet.head.hipass = fread(hfile,1,'long');
IDataSet.head.operationsperformed = fread(hfile,64,'*char');

% Ora specific not needed by Vdaq
IDataSet.head.magnification = fread(hfile,1,'float');
IDataSet.head.gain = fread(hfile,1,'ushort');
IDataSet.head.wavelength = fread(hfile,1,'ushort');
IDataSet.head.exposuretime = fread(hfile,1,'long');
IDataSet.head.nrepetitions = fread(hfile,1,'long'); % number of repetitions
IDataSet.head.acquisitiondelay = fread(hfile,1,'long'); % delay of DAQ relative to Stim-Go
IDataSet.head.interstiminterval = fread(hfile,1,'long'); % time interval between Stim-Go's
IDataSet.head.creationdata = fread(hfile,16,'*char');
IDataSet.head.datafilename = fread(hfile,64,'*char');
IDataSet.head.orareserved = fread(hfile,256,'*char');

% Vdaq-specific
IDataSet.head.includesrefframe = fread(hfile,1,'long'); % 0 or 1
IDataSet.head.listofstimuli = fread(hfile,256,'*char');
IDataSet.head.nframesperdataframe = fread(hfile,1,'long');
IDataSet.head.ntrials = fread(hfile,1,'long');
IDataSet.head.scalefactor = fread(hfile,1,'long'); % NFramesAvgd * Bin * Trials
IDataSet.head.meanampgain = fread(hfile,1,'float');
IDataSet.head.meanampdc = fread(hfile,1,'float');
IDataSet.head.begbaselineframeno = fread(hfile,1,'int8'); % SUM-FR/DC File (i.e. compressed)
IDataSet.head.endbaselineframeno = fread(hfile,1,'int8'); % SUM-FR/DC File (i.e. compressed)
IDataSet.head.begactivityframeno = fread(hfile,1,'int8'); % SUM-FR/DC File (i.e. compressed)
IDataSet.head.endactivityframeno = fread(hfile,1,'int8'); % SUM-FR/DC File (i.e. compressed)
IDataSet.head.digitizerbits = fread(hfile,1,'int8'); % cam_GetGrabberBits
IDataSet.head.activesystemid = fread(hfile,1,'int8'); % core_ActiveSystemID()
IDataSet.head.dummy2 = fread(hfile,1,'int8');
IDataSet.head.dummy3 = fread(hfile,1,'int8');
IDataSet.head.x1superpix = fread(hfile,1,'long');
IDataSet.head.y1superpix = fread(hfile,1,'long');
IDataSet.head.x2superpix = fread(hfile,1,'long');
IDataSet.head.y2superpix = fread(hfile,1,'long');
IDataSet.head.frameduration = fread(hfile,1,'float');
IDataSet.head.validframes = fread(hfile,1,'long');
IDataSet.head.vdaqreserved = fread(hfile,224,'*char');

% Note = SYSTEMTIME is 8 WORDS (16 bytes)
IDataSet.head.timeblockstart = fread(hfile,8,'int16');
IDataSet.head.timeblockend = fread(hfile,8,'int16');

% User-defined
IDataSet.head.user = fread(hfile,224,'*char');

% Comment
IDataSet.head.comment = fread(hfile,256,'*char');

%% get data and analysis zero frame
switch IDataSet.head.datatype
    case 13 % DAT_LONG
        datatype = '*long';
    otherwise
        datatype = '*int32';
end

if nargin < 3
    tfn = 0;
    type = 'avg';
    method = 'sub';
elseif nargin < 4
    type = 'avg';
    method = 'sub';
elseif nargin < 5
    method = 'sub';
end

if (zfn>=IDataSet.head.nframesperstim)
    disp('Error, zero frames exceed data frames.');
    return;
end
if (tfn>=(IDataSet.head.nframesperstim-zfn))
    disp('Error, tail frames exceed real data frames.');
    return;
end

hwaitbar = waitbar(0,'Reading and Processing Image Data . . .');
IDataSet.image = cell(IDataSet.head.ntrials,IDataSet.head.nstimuli);
for i = 1:IDataSet.head.ntrials
    for s = 1:IDataSet.head.nstimuli
        IDataSet.image{i,s} = zeros(IDataSet.head.nframesperstim,IDataSet.head.frameheight,IDataSet.head.framewidth);
        for d = 1:IDataSet.head.nframesperstim
            ti = fread(hfile,IDataSet.head.framewidth*IDataSet.head.frameheight,datatype);
            ti = reshape(ti,IDataSet.head.framewidth,IDataSet.head.frameheight)';
            IDataSet.image{i,s}(d,:,:) = ti;
            waitbar((i*s*d)/(IDataSet.head.ntrials*IDataSet.head.nstimuli*IDataSet.head.nframesperstim),hwaitbar);
        end
        
        rf = IDataSet.image{i,s}(zfn+1:end-tfn,:,:);
        rfn = size(rf,1);
        if strcmp(type,'avg')
            zf = mean(IDataSet.image{i,s}(1:zfn,:,:));
            for ri = 1:rfn
                if strcmp(method,'sub')
                    rf(ri,:,:) = rf(ri,:,:)-zf;
                else
                    rf(ri,:,:) = rf(ri,:,:)./zf;
                end
            end
        else
            zf = IDataSet.image{i,s}(1:zfn,:,:);
            if(mod(rfn,zfn)==0)
                for c = 0:rfn/zfn-1
                    for zi = 1:zfn
                        if strcmp(method,'sub')
                            rf(c*zfn+zi,:,:)=rf(c*zfn+zi,:,:)-zf(zi,:,:);
                        else
                            rf(c*zfn+zi,:,:)=rf(c*zfn+zi,:,:)./zf(zi,:,:);
                        end
                    end
                end
            else
                disp('Error, no matching of real dataframes to zeroframes circle.');
                return;
            end
        end
        IDataSet.image{i,s} = rf;
    end
end
close(hwaitbar);
if (ftell(hfile)~=IDataSet.head.filesize)
    disp('Block Is Not Converted Correctly.');
end
fclose(hfile);