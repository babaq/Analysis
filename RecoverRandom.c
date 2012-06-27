/* RecoverRandom.c */
/* 2008-01-15 Zhang Li */

#include "mex.h"


/*
 * Recover Experiment Random Sequence
 */




/* Use MarkerHeader Information to Recover Experiment Random Sequence */
void RecoverRandom(double *sticode,double *seed,double *trial,double *nsti)
{
    int i,j,k,m;
    srand((unsigned int)*seed);
    
    for (j=0;j<(*nsti)*(*trial);j++)
    {
        sticode[j]=-1;
    }
    

    for (i=0;i<*trial;i++)
    {
         for (k=0;k<*nsti;k++)
         {
             do
             {
                 m=rand()%((unsigned int)*nsti);
             }
             while(sticode[i*((unsigned int)*nsti)+m]>=0);
             sticode[i*((unsigned int)*nsti)+m]=k;
         }
    }
}





/*  the gateway routine.  */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
  double *x1,*x2,*x3,*y;
  mwSize mrows,ncols;
  
  /* Check for proper number of arguments. */
  if(nrhs!=3) {
    mexErrMsgTxt("Three input required.");
  } else if(nlhs>1) {
    mexErrMsgTxt("Too many output arguments");
  }
  
  /* The input must be a noncomplex scalar double.*/
  mrows = mxGetM(prhs[0]);
  ncols = mxGetN(prhs[0]);
  if( !mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]) ||
      !(mrows==1 && ncols==1) ) {
    mexErrMsgTxt("Input must be a noncomplex scalar double.");
  }
  
  mrows = mxGetM(prhs[1]);
  ncols = mxGetN(prhs[1]);
  if( !mxIsDouble(prhs[1]) || mxIsComplex(prhs[1]) ||
      !(mrows==1 && ncols==1) ) {
    mexErrMsgTxt("Input must be a noncomplex scalar double.");
  }
  
  mrows = mxGetM(prhs[2]);
  ncols = mxGetN(prhs[2]);
  if( !mxIsDouble(prhs[2]) || mxIsComplex(prhs[2]) ||
      !(mrows==1 && ncols==1) ) {
    mexErrMsgTxt("Input must be a noncomplex scalar double.");
  }
  
    
  /* Assign pointers to each input and output. */
  x1 = mxGetPr(prhs[0]);
  x2 = mxGetPr(prhs[1]);
  x3 = mxGetPr(prhs[2]);
  
  mrows = *x2;
  ncols = *x3;
  /* Create matrix for the return argument. */
  plhs[0] = mxCreateDoubleMatrix(ncols,mrows, mxREAL);
  
  y = mxGetPr(plhs[0]);
  
  /* Call the RecoverRandom subroutine. */
  RecoverRandom(y,x1,x2,x3);
}

