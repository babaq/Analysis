function [ nTestType,szComment,nSpikeChannel,aTestType,aExpParam,aBehavParam,...
    aGraphParam,aTestSeries,aTrial,aFOREP,aResponseTime,aTrialStatus,aDepth2Match,...
    aCursorDepth,ucMajorChannel,nCellNum,ucElectrodeNum,nElectrodeDepth,fSpikeShape,...
    nSpikeShapeTimes,dSpikeShapeTimestamp,nSpikeShapeSampleRate] = ReadVLB( szFileName )
%READVLB Read VLab Binary Data File
%   only support file format version 10 - 11

[fid, message] = fopen(szFileName,'rb');
if fid == -1
    disp(message);
    return;
end

supportversion = [10 11];
supportchannel = 8;
wDataFormat   = fread( fid, 1, 'uint16' );
if wDataFormat < supportversion(1)
    disp('The format of the VLab file is older than supported, error may accur !');
end
if wDataFormat > supportversion(2)
    disp('The format of the VLab file is newer than supported, error may accur !');
end
CLASSNAME = {};

nTestType     = fread( fid, 1, 'int32' );
szComment     = ReadCString( fid );
nSpikeChannel = fread( fid, 1, 'int32' );
ucMajorChannel = fread(fid,1, 'uint8');
nCellNum = fread(fid,supportchannel, 'int16');
ucElectrodeNum = fread(fid,supportchannel, 'uint8');
nElectrodeDepth = fread(fid,supportchannel, 'int16');

aTestType     = ReadCStringArray( fid );
aExpParam     = ReadCTypedPtrArray( fid );
aBehavParam   = ReadCTypedPtrArray( fid );
aGraphParam   = ReadCTypedPtrArray( fid );
aTestSeries   = ReadCStringArray( fid );
aTrial        = ReadCTypedPtrArray( fid );
aFOREP        = ReadCArray( fid, 'int32' );
aResponseTime = ReadCArray( fid, 'int32' );
aTrialStatus  = ReadCArray( fid, 'int32' );
aDepth2Match  = ReadCArray( fid, 'int32' );
aCursorDepth  = ReadCArray( fid, 'int32' );

for i=1:supportchannel
    dwCount = ReadCount(fid);
    spikeshape = cell(dwCount,1);
    for j=1:dwCount
        spikeshape{j} = ReadCArray(fid,'float32');
    end
    fSpikeShape{i,1}=spikeshape;
    nSpikeShapeTimes{i,1} = ReadCArray(fid,'int32');
end
dSpikeShapeTimestamp = ReadCArray(fid,'uint32');
nSpikeShapeSampleRate = fread(fid,1,'int32');

if ~feof(fid)
    disp('Warnning, did not reach the end of file, there are data left.');
end
if fclose(fid) == -1
    disp('File Close Operation Fail.');
end
%%%%%%%%%%%%%%%%%%%%%% Nested Functions %%%%%%%%%%%%%%%%%%%%%%%

    function carray = ReadCArray( fid, type )
        % READ a CArray object from input file 'fid'.
        
        dCount = ReadCount( fid );
        carray = fread( fid, dCount, type );
    end

    function dCount = ReadCount( fid )
        % Read the count of CArray from an open file
        
        dCount = fread( fid, 1, 'uint16' );
        if dCount == 65535
            dCount = fread( fid, 1, 'uint32' );
        end
    end

    function string = ReadCString( fid )
        % READ a CString object from input file 'fid'.
        % This function read a CString object from input
        % file 'fid'. 'fid' was returned by 'fopen'
        
        dLen = ReadCStringLength( fid );
        string = fread( fid, dLen );
        string = char( string' );
    end

    function len = ReadCStringLength( fid )
        len = fread( fid, 1, 'uint8' );
        if len == 255
            len = fread( fid, 1, 'uint16' );
            if len == 65535
                len = fread( fid, 1, 'uint32' );
            end
        end
    end

    function aString = ReadCStringArray( fid )
        % READ a CStringArray object from input file 'fid'.
        % This function read a CStringArray object from input
        % file 'fid'. 'fid' was returned by 'fopen'
        
        dCount = ReadCount( fid );
        aString = cell( dCount, 1 );
        for csai = 1:dCount
            aString{csai} = ReadCString( fid );
        end
    end

    function array = ReadCTypedPtrArray( fid )
        % READ a CTypedPtrArray object from input file 'fid'.
        
        wBigObjectTag = 2^15 - 1; %0x7fff
        wClassTag = 2^15; %0x8000
        dwBigClassTag = 2^31; %0x80000000
        wNewClassTag = 2^16-1; %0xffff
        dCount = ReadCount( fid );
        
        for ctpai = 1:dCount
            wTag = fread( fid, 1, 'uint16' );
            if wTag == wBigObjectTag
                obTag = fread( fid, 1, 'uint32' );
            else
                obTag = bitor( bitshift( bitand( wTag, wClassTag ), 16 ), bitand( wTag, bitcmp(wClassTag, 'uint16') ) );
            end
            if wTag == wNewClassTag
                wSchema = fread( fid, 1, 'uint16' );
                wLen = fread( fid, 1, 'uint16' );
                szName = fread( fid, wLen );
                szName = char( szName' );
                CLASSNAME{length(CLASSNAME)+1} = '';
            else
                wClassIndex = bitand(obTag, bitcmp(dwBigClassTag, 'uint32'))+1;
                szName = CLASSNAME{wClassIndex};
            end
            switch szName
                case 'CParam'
                    array(ctpai,1) = ReadCParam( fid );
                case 'CTrial'
                    array(ctpai,1) = ReadCTrial( fid );
                otherwise
                    disp( 'Unknown CTypedPtrArray data format.' );
            end
            CLASSNAME{length(CLASSNAME)+1} = szName;
        end
    end

    function trial = ReadCTrial( fid )
        % READ a CTrial object from input file 'fid'.
        
        wDataFormat                      = fread( fid, 1, 'uint16' );
        trial.m_wFigDelay                = fread( fid, 1, 'uint16' );
        trial.m_dTime                    = fread( fid, 1, 'uint32' );
        trial.m_fA_X                     = fread( fid, 1, 'float32' );
        trial.m_nB_X                     = fread( fid, 1, 'int32' );
        trial.m_fA_Y                     = fread( fid, 1, 'float32' );
        trial.m_nB_Y                     = fread( fid, 1, 'int32' );
        
        trial.m_nItem                    = fread( fid, 1, 'int32' );
        trial.m_nSet                     = fread( fid, 1, 'int32' );
        trial.m_nStatus                  = fread( fid, 1, 'int32' );
        trial.m_nResponseTime            = fread( fid, 1, 'int32' );
        trial.m_nV1                      = fread( fid, 1, 'int32' );
        trial.m_nV2                      = fread( fid, 1, 'int32' );
        
        trial.m_ucActiveChannel          = fread( fid, 1, '*uint8' );
        trial.m_szComment                = ReadCString( fid );
        
        trial.m_nV3                      = fread( fid, 1, 'int32' );
        trial.m_fR_X                     = fread( fid, 1, 'float32' );
        trial.m_fR_Y                     = fread( fid, 1, 'float32' );
        trial.m_dTimeStamp               = fread( fid, 1, 'uint32' );
        
        trial.m_nLFPSampleRate           = fread( fid, 1, 'int32' );
        trial.m_nLFPChannels             = fread( fid, 1, 'int16' );
        trial.m_nLFPGain                 = fread( fid, supportchannel, 'int16' );
        
        trial.m_wSpikeEvent              = ReadCArray( fid, '*uint16' );
        trial.m_dSpikeTime               = ReadCArray( fid, 'uint32' );
        
        trial.m_wEyePointX               = ReadCArray( fid, 'float32' );
        trial.m_wEyePointY               = ReadCArray( fid, 'float32' );
        trial.m_wEyePointTime            = ReadCArray( fid, 'uint32' );
        
        trial.m_dKeyTime                 = ReadCArray( fid, 'uint32' );
        trial.m_nKeyAction               = ReadCArray( fid, 'int16' );
        trial.m_dFPTime                  = ReadCArray( fid, 'uint32' );
        trial.m_bFPAction                = ReadCArray( fid, 'uint8' );
        
        for cti=1:supportchannel
            lfpsample{cti,1} = ReadCArray(fid,'int16');
        end
        trial.m_nLFPSample = lfpsample;
    end

    function param = ReadCParam( fid )
        % READ a CParam object from input file 'fid'.
        
        param.m_szName = ReadCString( fid );
        param.m_szData = ReadCString( fid );
    end
end