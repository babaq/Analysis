#include "mex.h"
#include "matrix.h"

mxArray * ReadCArray( FILE * fp, int type );
unsigned long ReadCount( FILE * fp );
void ReadCParam( mxArray * pParam, int index, FILE * fp );
mxArray * ReadCString( FILE * fp );
unsigned long ReadCStringLength( FILE * fp );
mxArray * ReadCStringArray( FILE * fp );
bool ReadCTrial( mxArray * pTrial, int index, FILE * fp );
mxArray * ReadCTypedPtrArray( FILE * fp );

char ** ClassName;
int sizeClassName;

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
	unsigned short wDataFormat;
	mxArray ** nTestType     = &plhs[0];
	mxArray ** szComment     = &plhs[1];
	mxArray ** nSpikeChannel = &plhs[2];
	mxArray ** aTestType     = &plhs[3];
	mxArray ** aExpParam     = &plhs[4];
	mxArray ** aBehavParam   = &plhs[5];
	mxArray ** aGraphParam   = &plhs[6];
	mxArray ** aTestSeries   = &plhs[7];
	mxArray ** aTrial        = &plhs[8];
	mxArray ** aFOREP        = &plhs[9];
	mxArray ** aResponseTime = &plhs[10];
	mxArray ** aTrialStatus  = &plhs[11];
	mxArray ** aDepth2Match  = &plhs[12];
	mxArray ** aCursorDepth  = &plhs[13];
	mxArray ** ucMajorChannel= &plhs[14];
	mxArray ** nCellNum      = &plhs[15];
	mxArray ** ucElectrodeNum= &plhs[16];
	mxArray ** nElectrodeDepth=&plhs[17];
    mxArray ** fSpikeShape           = &plhs[18];
    mxArray ** nSpikeShapeTimes      = &plhs[19];
    mxArray ** dSpikeShapeTimestamp  = &plhs[20];
    mxArray ** nSpikeShapeSampleRate = &plhs[21];

	int dims[2];
	FILE * fp;
	char * szFileName;
	size_t buflen = mxGetM(prhs[0]) * mxGetN(prhs[0]) + 1;
    unsigned long dwCount;
    int i, j;
    mxArray * array;

	szFileName = mxCalloc( buflen, sizeof(char) );
	mxGetString(prhs[0], szFileName, buflen);

	if( !(fp = fopen( szFileName, "rb" )) )
	{
		printf( "Can't open file!\n" );
		return;
	}
	setvbuf( fp, NULL, _IOFBF, 32000 );

	dims[0] = 1;
	dims[1] = 1;
	*nTestType = mxCreateNumericArray( 2, dims, mxINT32_CLASS, mxREAL );
	*nSpikeChannel = mxCreateNumericArray( 2, dims, mxINT32_CLASS, mxREAL );
	*ucMajorChannel = mxCreateNumericArray( 2, dims, mxUINT8_CLASS, mxREAL );
    *nSpikeShapeSampleRate = mxCreateNumericArray( 2, dims, mxINT32_CLASS, mxREAL );
	dims[1] = 8;
	*nCellNum = mxCreateNumericArray( 2, dims, mxINT16_CLASS, mxREAL );
	*ucElectrodeNum = mxCreateNumericArray( 2, dims, mxUINT8_CLASS, mxREAL );
	*nElectrodeDepth = mxCreateNumericArray( 2, dims, mxINT16_CLASS, mxREAL );

	fread( &wDataFormat, 2, 1, fp );
	if(wDataFormat > 10) {
	    printf("The format of underlining VLab file is newer than expected! !\n");
	    /*this piece of code actually reads data up to wDataFormat = 2*/
	    /*return;*/
	}
	fread( mxGetData(*nTestType), 4, 1, fp );
	if( wDataFormat == 0 || wDataFormat >= 2 )
		*szComment = ReadCString( fp );
	else
		*szComment = mxCreateString( mxCalloc( 1, sizeof(char) ) );
	fread( mxGetData(*nSpikeChannel), 4, 1, fp );
	if( wDataFormat > 0 )
	{
		fread( mxGetData(*ucMajorChannel), 1, 1, fp );
		fread( mxGetData(*nCellNum), 2, 8, fp );
		fread( mxGetData(*ucElectrodeNum), 1, 8, fp );
		fread( mxGetData(*nElectrodeDepth), 2, 8, fp );
	}

	*aTestType = ReadCStringArray( fp );

	ClassName = (char**)mxCalloc( 1, sizeof(char*) );
	sizeClassName = 0;

	*aExpParam = ReadCTypedPtrArray( fp );
	*aBehavParam = ReadCTypedPtrArray( fp );
	*aGraphParam = ReadCTypedPtrArray( fp );
	*aTestSeries = ReadCStringArray( fp );
	*aTrial = ReadCTypedPtrArray( fp );
	*aFOREP = ReadCArray( fp, mxINT32_CLASS );
	*aResponseTime = ReadCArray( fp, mxINT32_CLASS );
	*aTrialStatus = ReadCArray( fp, mxINT32_CLASS );
	*aDepth2Match = ReadCArray( fp, mxINT32_CLASS );
	*aCursorDepth = ReadCArray( fp, mxINT32_CLASS );

    /* spike shape */
    if (wDataFormat >= 10) {
        *fSpikeShape = mxCreateCellMatrix(8, 1);
        *nSpikeShapeTimes = mxCreateCellMatrix(8, 1);
        for (i = 0; i < 8; i ++) {
            dwCount = ReadCount( fp );
            array = mxCreateCellMatrix(dwCount, 1);
            for (j = 0; j < (int)dwCount; j ++)
                mxSetCell( array, j, ReadCArray(fp, mxSINGLE_CLASS));
            mxSetCell(*fSpikeShape, i, array);
            mxSetCell(*nSpikeShapeTimes, i, ReadCArray(fp, mxINT32_CLASS));
        }
        *dSpikeShapeTimestamp = ReadCArray(fp, mxUINT32_CLASS);
        dims[1] = 1;
        *nSpikeShapeSampleRate = mxCreateNumericArray( 2, dims, mxINT32_CLASS, mxREAL );
        fread(mxGetData(*nSpikeShapeSampleRate), 4, 1, fp );
    }
	else
	{
        *fSpikeShape = mxCreateCellMatrix(8, 1);
        *nSpikeShapeTimes = mxCreateCellMatrix(8, 1);
        dims[1] = 1;
        *dSpikeShapeTimestamp = mxCreateNumericArray(2, dims, mxUINT32_CLASS, mxREAL);
        *nSpikeShapeSampleRate = mxCreateNumericArray(2, dims, mxINT32_CLASS, mxREAL);
	}
	fclose( fp );

	mxFree( ClassName );
	ClassName = NULL;
}

/* READ a CArray object from input file "fp". */
mxArray * ReadCArray( FILE * fp, int type )
{
	int dims[2];
	unsigned long dCount = ReadCount( fp );
	mxArray * array;
	int unit_size;

	dims[0] = dCount;
	dims[1] = 1;

	switch( type )
	{
	case mxCHAR_CLASS:
	case mxINT8_CLASS:
	case mxUINT8_CLASS:
		unit_size = 1;
		break;
	case mxINT16_CLASS:
	case mxUINT16_CLASS:
		unit_size = 2;
		break;
	case mxUINT32_CLASS:
	case mxINT32_CLASS:
	case mxSINGLE_CLASS:
		unit_size = 4;
		break;
	case mxDOUBLE_CLASS:
	case mxINT64_CLASS:
	case mxUINT64_CLASS:
		unit_size = 8;
		break;
	}

	array = mxCreateNumericArray( 2, dims, type, mxREAL );

	if (dCount > 0)
		fread( mxGetData(array), unit_size, dCount, fp );

	return array;
}

/* Read the count of CArray from an open file */
unsigned long ReadCount( FILE * fp )
{
	unsigned long dCount = 0;
	fread( &dCount, 2, 1, fp );
	if( dCount == 65535 )
	   fread( &dCount, 4, 1, fp );
	return dCount;
}

/* READ a CParam object from input file 'fp'. */
void ReadCParam( mxArray * pParam, int index, FILE * fp )
{
	mxSetField( pParam, index, "m_szName", ReadCString( fp ) );
	mxSetField( pParam, index, "m_szData", ReadCString( fp ) );
}

/* READ a CString object from input file 'fid'.
   This function read a CString object from input
   file 'fid'. 'fid' was returned by 'fopen'
*/
mxArray * ReadCString( FILE * fp )
{
	unsigned long dLen = ReadCStringLength( fp );
	char * buf = mxCalloc( dLen+1, sizeof(char) );

	fread( buf, dLen, 1, fp );
	buf[dLen] = '\0';
	return mxCreateString( buf );
}

unsigned long ReadCStringLength( FILE * fp )
{
	unsigned long len = 0;

	fread( &len, 1, 1, fp );
	if( len == 255 )
	{
		fread( &len, 2, 1, fp );
		if( len == 65535 )
			fread( &len, 4, 1, fp );
	}
	return len;
}

/* READ a CStringArray object from input file 'fid'.
   This function read a CStringArray object from input
   file 'fid'. 'fid' was returned by 'fopen'
*/
mxArray * ReadCStringArray( FILE * fp )
{
	unsigned int dCount = ReadCount( fp );
	int i;
	mxArray * aString;

	aString = mxCreateCellMatrix( dCount, 1 );
	for( i = 0; i < (int)dCount; i ++ )
	   mxSetCell( aString, i, ReadCString( fp ) );
	return aString;
}

/* READ a CParam object from input file 'fp'. */
bool ReadCTrial( mxArray * pTrial, int index, FILE * fp )
{
	unsigned short wDataFormat;
	mxArray * array;
	int dims[2];
    int i;

	dims[0] = 1;
	dims[1] = 1;
	
	fread( &wDataFormat, 2, 1, fp );
	if(wDataFormat > 10) {
	    printf("Unknow Trial format!\n");
	    return false;
	}
	array = mxCreateNumericArray( 2, dims, mxUINT16_CLASS, mxREAL );
	fread( mxGetData(array), 2, 1, fp );
	mxSetField( pTrial, index, "m_wFigDelay", array );

	array = mxCreateNumericArray( 2, dims, mxUINT32_CLASS, mxREAL );
	fread( mxGetData(array), 4, 1, fp );
	mxSetField( pTrial, index, "m_dTime", array );

	array = mxCreateNumericArray( 2, dims, mxSINGLE_CLASS, mxREAL );
	fread( mxGetData(array), 4, 1, fp );
	mxSetField( pTrial, index, "m_fA_X", array );

	array = mxCreateNumericArray( 2, dims, mxINT32_CLASS, mxREAL );
	fread( mxGetData(array), 4, 1, fp );
	mxSetField( pTrial, index, "m_nB_X", array );

	array = mxCreateNumericArray( 2, dims, mxSINGLE_CLASS, mxREAL );
	fread( mxGetData(array), 4, 1, fp );
	mxSetField( pTrial, index, "m_fA_Y", array );

	array = mxCreateNumericArray( 2, dims, mxINT32_CLASS, mxREAL );
	fread( mxGetData(array), 4, 1, fp );
	mxSetField( pTrial, index, "m_nB_Y", array );

	array = mxCreateNumericArray( 2, dims, mxINT32_CLASS, mxREAL );
	fread( mxGetData(array), 4, 1, fp );
	mxSetField( pTrial, index, "m_nItem", array );

	array = mxCreateNumericArray( 2, dims, mxINT32_CLASS, mxREAL );
	fread( mxGetData(array), 4, 1, fp );
	mxSetField( pTrial, index, "m_nSet", array );

	array = mxCreateNumericArray( 2, dims, mxINT32_CLASS, mxREAL );
	fread( mxGetData(array), 4, 1, fp );
	mxSetField( pTrial, index, "m_nStatus", array );

	array = mxCreateNumericArray( 2, dims, mxINT32_CLASS, mxREAL );
	fread( mxGetData(array), 4, 1, fp );
	mxSetField( pTrial, index, "m_nResponseTime", array );

	array = mxCreateNumericArray( 2, dims, mxINT32_CLASS, mxREAL );
	fread( mxGetData(array), 4, 1, fp );
	mxSetField( pTrial, index, "m_nV1", array );

	array = mxCreateNumericArray( 2, dims, mxINT32_CLASS, mxREAL );
	fread( mxGetData(array), 4, 1, fp );
	mxSetField( pTrial, index, "m_nV2", array );

	if( wDataFormat >= 1 )
	{
		array = mxCreateNumericArray( 2, dims, mxUINT8_CLASS, mxREAL );
		fread( mxGetData(array), 1, 1, fp );
		mxSetField( pTrial, index, "m_ucActiveChannel", array );
		
		mxSetField( pTrial, index, "m_szComment", ReadCString( fp ) );
	}
	if( wDataFormat >= 3 )
	{
		array = mxCreateNumericArray( 2, dims, mxINT32_CLASS, mxREAL );
		fread( mxGetData(array), 4, 1, fp );
		mxSetField( pTrial, index, "m_nV3", array );
	}
	if( wDataFormat >= 5 )
	{
    	array = mxCreateNumericArray( 2, dims, mxSINGLE_CLASS, mxREAL );
    	fread( mxGetData(array), 4, 1, fp );
    	mxSetField( pTrial, index, "m_fR_X", array );
	
    	array = mxCreateNumericArray( 2, dims, mxSINGLE_CLASS, mxREAL );
    	fread( mxGetData(array), 4, 1, fp );
    	mxSetField( pTrial, index, "m_fR_Y", array );
    }
    if( wDataFormat >= 6 )
    {
        array = mxCreateNumericArray( 2, dims, mxUINT32_CLASS, mxREAL );
        fread( mxGetData(array), 4, 1, fp );
        mxSetField( pTrial, index, "m_dTimeStamp", array );
    }
    if( wDataFormat >= 7 )
    {
        array = mxCreateNumericArray( 2, dims, mxINT32_CLASS, mxREAL );
        fread( mxGetData(array), 4, 1, fp );
        mxSetField( pTrial, index, "m_nLFPSampleRate", array );
        
        array = mxCreateNumericArray( 2, dims, mxINT16_CLASS, mxREAL );
        fread( mxGetData(array), 2, 1, fp );
        mxSetField( pTrial, index, "m_nLFPChannels", array );
   
        dims[1] = 8;
        array = mxCreateNumericArray( 2, dims, mxINT16_CLASS, mxREAL );
        fread( mxGetData(array), 2, 8, fp );
        mxSetField( pTrial, index, "m_nLFPGain", array );
    }   

	mxSetField( pTrial, index, "m_wSpikeEvent", ReadCArray( fp, mxUINT16_CLASS ) );
	mxSetField( pTrial, index, "m_dSpikeTime", ReadCArray( fp, mxUINT32_CLASS ) );
    
    if (wDataFormat >= 10)
    {
        mxSetField( pTrial, index, "m_wEyePointX", ReadCArray( fp, mxSINGLE_CLASS ) );
        mxSetField( pTrial, index, "m_wEyePointY", ReadCArray( fp, mxSINGLE_CLASS ) );
        mxSetField( pTrial, index, "m_wEyePointTime", ReadCArray( fp, mxUINT32_CLASS ) );
    }
    else
    {
        const int * dm;
        int i;
        unsigned int * data;
        
        array = ReadCArray( fp, mxUINT16_CLASS );
        mxSetField( pTrial, index, "m_wEyePointX", array );
        mxSetField( pTrial, index, "m_wEyePointY", ReadCArray( fp, mxUINT16_CLASS ) );

        dm = mxGetDimensions(array);
            
        dims[1] = dm[1];
        array = mxCreateNumericArray(2, dims, mxUINT32_CLASS, mxREAL );
            
        data = mxGetData(array);
        for (i = 0; i < dims[1]; i ++)
            data[i] = (unsigned int)(i * 16.6667f);
            
        mxSetField( pTrial, index, "m_wEyePointTime", array);
    }
    
	mxSetField( pTrial, index, "m_dKeyTime", ReadCArray( fp, mxUINT32_CLASS ) );
	mxSetField( pTrial, index, "m_nKeyAction", ReadCArray( fp, wDataFormat>=4?mxINT16_CLASS:mxUINT8_CLASS ) );
	mxSetField( pTrial, index, "m_dFPTime", ReadCArray( fp, mxUINT32_CLASS ) );
	mxSetField( pTrial, index, "m_bFPAction", ReadCArray( fp, mxUINT8_CLASS ) );
	
    if (wDataFormat >= 7)
    {
    	array = mxCreateCellMatrix( 8, 1 );
        for (i = 0; i < 8; i ++)
            mxSetCell( array, i, ReadCArray( fp, mxINT16_CLASS ) );
        mxSetField( pTrial, index, "m_nLFPSample", array );
    }
    
    if (wDataFormat == 8)
    {
        /* read and discard */
    	array = ReadCArray( fp, mxUINT16_CLASS );
        mxDestroyArray(array);
    }

	return true;
}

/* READ a CTypedPtrArray object from input file 'fp'. */
mxArray * ReadCTypedPtrArray( FILE * fp )
{
	unsigned short wBigObjectTag = 0x7fff;
	unsigned short wClassTag = 0x8000;
	unsigned long dwBigClassTag = 0x80000000;
	unsigned short wNewClassTag = 0xffff;
	unsigned long dCount = ReadCount( fp );
	int i, n;
	unsigned short wTag, wSchema, wLen, wClassIndex;
	unsigned long obTag;
	char szName[80];
	mxArray * array;
	char ** className;
	char * paramFields[] =
	{
		"m_szName",
		"m_szData"
	};
	char * trialFields[] =
	{
	    "m_dTimeStamp",
		"m_wFigDelay",
		"m_dTime",
		"m_fA_X",
		"m_nB_X",
		"m_fR_X",
		"m_fA_Y",
		"m_nB_Y",
		"m_fR_Y",
		"m_nItem",
		"m_nSet",
		"m_nStatus",
		"m_nResponseTime",
		"m_nV1",
		"m_nV2",
		"m_nV3",
		"m_ucActiveChannel",
		"m_szComment",
		"m_wSpikeEvent",
		"m_dSpikeTime",
		"m_wEyePointX",
		"m_wEyePointY",
		"m_wEyePointTime",
		"m_dKeyTime",
		"m_nKeyAction",  
		"m_dFPTime",
		"m_bFPAction",
        "m_nLFPSampleRate",
        "m_nLFPChannels",
        "m_nLFPGain",
        "m_nLFPSample"
	};

	className = (char**)mxCalloc( sizeClassName + dCount + 1, sizeof(char*) );
	memcpy( className, ClassName, sizeClassName * sizeof(char*) );
	mxFree( ClassName );
	ClassName = className;

	for( i = 0; i < (int)dCount; i ++ )
	{
		fread( &wTag, 2, 1, fp );
		if( wTag == wBigObjectTag )
			fread( &obTag, 4, 1, fp );
		else
			obTag = ((wTag & wClassTag) << 16) | (wTag & ~wClassTag);
		if( wTag == wNewClassTag )
		{
			fread( &wSchema, 2, 1, fp );
			fread( &wLen, 2, 1, fp );
			fread( szName, wLen, 1, fp );
			szName[wLen] = '\0';
			sizeClassName ++;
			ClassName[sizeClassName] = mxCalloc( strlen( szName ) + 1, sizeof(char) );
			strcpy( ClassName[sizeClassName], szName );
			sizeClassName ++;
		}
		else
		{
			wClassIndex = (unsigned short)(obTag & ~dwBigClassTag);
			strcpy( szName, ClassName[wClassIndex] );
			sizeClassName ++;
		}
		if( strcmp( szName, "CParam" ) == 0 )
		{
			if( i == 0 )
			{
				n = sizeof(paramFields)/sizeof(char*);
				array = mxCreateStructMatrix( dCount, 1, n, paramFields );
			}
			ReadCParam( array, i, fp );
		}
		else if( strcmp( szName, "CTrial" ) == 0 )
		{
			if( i == 0 )
			{
				n = sizeof(trialFields)/sizeof(char*);
				array = mxCreateStructMatrix( dCount, 1, n, trialFields );
			}
			if(!ReadCTrial( array, i, fp ))
			    break;
		}
		else
			printf( "Unknown data format.\n" );
	}
	return array;
}

// vim: ts=4 sw=4 noet
