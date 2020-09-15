//+------------------------------------------------------------------+
//|                                                                  |
//|  R-MESA -  Maximum Entropy Spectrum Analysis Library             |
//|  v.1.1 - 2008-06-30                                              |
//|  Copyright © 2008 Riccardo "Rich" Cap                            |
//|  email: richcap.rc@gmail.com                                     |
//|                                                                  |
//|                                                                  |
//|                                                                  |
//|  Permission to use, copy, modify, and distribute this software   |
//|  for any purpose without fee is hereby granted, provided that    |
//|  this entire notice is included in all copies of any software    |
//|  which is or includes a copy or modification of this software    |
//|  and in all copies of the supporting documentation for such      |
//|  software.                                                       |
//|  THIS SOFTWARE IS BEING PROVIDED "AS IS", WITHOUT ANY EXPRESS    |
//|  OR IMPLIED WARRANTY.  IN PARTICULAR, NEITHER THE AUTHOR DOES    |
//|  NOT MAKE ANY REPRESENTATION OR WARRANTY OF ANY KIND CONCERNING  |
//|  THE MERCHANTABILITY OF THIS SOFTWARE OR ITS FITNESS FOR ANY     |
//|  PARTICULAR PURPOSE.                                             |
//|                                                                  |
//+------------------------------------------------------------------+
 
/*
 *    TODO List
 *
 *    - Assessment of best "order" for a given input vector (with 
 *      iterative procedure of Levinson - Durbin ??)
 *    
 *
 */

#property library

#define MAXIMUMDEGREE 500
#define MAXENTROPY 1
#define LEASTSQUARES 2
#define pi 3.14159265358979323846


/*
 * Maximum Entropy Spectrum Analisys
 * Cutoff Frequency finder
 *
 * This is the end-user's primary function, as it returns fast and slow cutoff frequencies for 
 * lowpass fatl & satl calculation
 * 
 * SATL (slow adaptive trend line) cutoff frequency is the most important peak between parameters
 * f_min and f_satl_max, where f_min is 1/max_period, i.e. the longest cycle period we are interested in
 * and f_satl_max is 1/satl_min_period, i.e. the cycle period above which we are searching a spectrum
 * peak.
 * FATL (fast adaptive trend line) cutoff frequency is the most important peak between f_fatl_min and
 * f_max, where f_max is 1/min period, i.e. the shortest cycle period we are investigating and 
 * f_fatl_min is 1/fatl_max_period, i.e. the cycle period under which we are searching for a "fast" peak
 *
 * In Kravchuk study ( V.K.Kravchuk. New Adaptive Method of Following the Tendency and Market Cycles.
 * Valyutny Spekulyant - 12, December 2000, p. 50-55.) typical values are: max period=160, 
 * satl_min_period=50, fatl_max_period=40, min_period=12(-20)
 *
 * The "importance" criterium for peaks is proprietary R.Cap
 *
 */
bool ME_Cutoff_frequencies(
   double&  inputseries[],          // real data input vector to be analyzed
   int      length,                 // length of input vector
   int      degree,                 // degree (order) of autoregression
   double   f_max,                  // the frequency under which to search peaks (f_max < Fn) e.g. 1.0/min_period
   double   f_min,                  // the frequency above which to search peaks (f_max < Fn) e.g. 1.0/max_period
   double   f_satl_max,             // the maximum satl frequency (e.g. 1/50)
   double   f_fatl_min,             // the minimum fatl frequency (e.g. 1/40)    
   double&  satl_fatl[])            // vector to store cutoff P1 and D1 for satl and fatl
{

   double mean[1], peaksVector[];
   double aa[];
   int n_peaks=0, shift;
   double sine, cosine, angle1, angle2, angle, importance[];
   double max_slow_importance=0.0, max_fast_importance=0.0;
   int slow_peak_index=-1, fast_peak_index=-1;
   
   ArrayResize(aa,degree);
   ArrayResize(peaksVector,4*degree);     // here we store peaks and valleys values and frequencies [4 x number of peaks]
   
   // Resolve Autoregression coefficient for the given degree. Maximum entropy method is the optimum choice
   // Least Squares is only for testing purposes
   if (!AutoRegression(inputseries, length, degree, aa, mean, MAXENTROPY))
     {
      Print("Autoregression Failed ");
      return(FALSE);  
     } 
    
   // Calculates peaks vector
   n_peaks=peaksVector(peaksVector, f_max, f_min, aa, degree);   

   // first check if first peak is minimum or maximum, then apply a shift in the algorithm
   if (peaksVector[0]<peaksVector[2])
      shift=0;
   else
      shift=2;
   
   // find important peaks by measuring each peak's height and sharpness and obtain an "importance" number
   // to measure sharpness we consider linear lines between peaks and valleys and measure angles
   // the smaller is the angle, the sharpest is the peak. Importance for each peak is given by height/angle  
   ArrayResize(importance,n_peaks);  
   for ( int i=0; i < n_peaks; i++)
   {  
         sine=1.0/peaksVector[4*i+shift+1]-1.0/peaksVector[4*i+shift+3];      // first angle sine
         cosine=peaksVector[4*i+shift+2]-peaksVector[4*i+shift];              // first angle cosine
         angle1=MathArctan(sine/cosine);                                      // first angle
         
         sine=1.0/peaksVector[4*i+shift+3]-1.0/peaksVector[4*i+shift+5];      // second angle sine
         cosine=peaksVector[4*i+shift+2]-peaksVector[4*i+shift+4];            // second angle cosine 
         angle2=MathArctan(sine/cosine);                                      // second angle
         
         angle=angle1+angle2;
         importance[i]=peaksVector[4*i+shift+2]/angle;
   }
   
   // chose peak in the low frequencies (periods over 1/f_satl_max)
   i=0;
   while (peaksVector[4*i+shift+3] < f_satl_max)
   {      
      if (  importance[i] > max_slow_importance*(1+0.3) )
      {  
         max_slow_importance = importance[i];
         slow_peak_index=i;
      }
      i++;
   }   
   
   // chose peak in the high frequencies (periods under 1/f_fatl_min)
   i=n_peaks-1;
   while (peaksVector[4*i+shift+3] > f_fatl_min)
   {  
      if (  importance[i] > max_fast_importance*(1+0.3) )
      {     
            max_fast_importance = importance[i];
            fast_peak_index=i;
      }
      i--;
   }
   
   if (slow_peak_index < 0)
   { 
      Print("Error: No cutoff values found for SATL");
      return (FALSE);
   }
   else
   { 
      double satl_P1=1.0/peaksVector[4*slow_peak_index+shift+3];
      double satl_D1=1.0/peaksVector[4*slow_peak_index+shift+5];
      //Print("Slow Period's length: ",satl_P1," - Value: ",peaksVector[4*slow_peak_index+shift+2], " - Importance: ", importance[slow_peak_index] );
      //Print("Satl - cutoff P1:",satl_P1," - cutoff D1:",satl_D1); 
   }
   
   if (fast_peak_index < 0)
   {
      Print("Error: No cutoff values found for FATL");
      return (FALSE);
   }
   else
   { 
      
      double fatl_P1=1.0/peaksVector[4*fast_peak_index+shift+3];
      double fatl_D1=1.0/peaksVector[4*fast_peak_index+shift+5];
      //Print("Fast Period's length: ",1.0/peaksVector[4*fast_peak_index+shift+3]," - Value: ",peaksVector[4*fast_peak_index+shift+2], " - Importance: ", importance[fast_peak_index] );
      //Print("Fatl - cutoff P1:",fatl_P1," - cutoff D1:",fatl_D1); 
   }
   
   satl_fatl[0]=satl_P1;
   satl_fatl[1]=satl_D1;
   satl_fatl[2]=fatl_P1;
   satl_fatl[3]=fatl_D1;
   return (TRUE);
          
}


  
/*
 * Maximum Entropy Spectrum Analisys
 * Cutoff Single Frequency finder
 *
 * This function returns only fast cutoff frequencies (peak and valley) for 
 * lowpass fatl/satl calculation.
 * As SATL/FATL are are different frequencies it can be useful to calculate them separately on different
 * paramater basys (degree, length, maximum and minimum).
 * 
 * Both SATL (slow adaptive trend line) and FATL (fast adaptive trend line) cutoff frequency are calculated 
 * finding the most important peak between parameters f_min and f_max, where f_min is 1/max_period, i.e. the 
 * longest cycle period we are interested in, and f_max, where f_max is 1/min period, i.e. the shortest cycle period 
 * we are investigating 
 *
 * In Kravchuk study ( V.K.Kravchuk. New Adaptive Method of Following the Tendency and Market Cycles.
 * Valyutny Spekulyant - 12, December 2000, p. 50-55.) typical values are: max period=160, 
 * min_period=12(-20)
 *
 * The "importance" criterium for peaks is proprietary RichCap
 *
 */
bool ME_Cutoff_frequency(
   double&  inputseries[],          // real data input vector to be analyzed
   int      length,                 // length of input vector
   int      degree,                 // degree (order) of autoregression
   double   f_max,                  // the frequency under which to search peaks (f_max < Fn) e.g. 1.0/min_period
   double   f_min,                  // the frequency above which to search peaks (f_max < Fn) e.g. 1.0/max_period
   double&  fatl_vector[])            // vector to store cutoff P1 and D1 for satl and fatl
{

   double mean[1], peaksVector[];
   double aa[];
   int n_peaks=0, shift;
   double sine, cosine, angle1, angle2, angle, importance[];
   double max_importance=0.0;
   int peak_index=-1;
   
   ArrayResize(aa,degree);
   ArrayResize(peaksVector,4*degree);     // here we store peaks and valleys values and frequencies [4 x number of peaks]
   
   // Resolve Autoregression coefficient for the given degree. Maximum entropy method is the optimum choice
   // Least Squares is only for testing purposes
   if (!AutoRegression(inputseries, length, degree, aa, mean, MAXENTROPY))
     {
      Print("Autoregression Failed ");
      return(FALSE);  
     } 
    
   // Calculates peaks vector
   n_peaks=peaksVector(peaksVector, f_max, f_min, aa, degree);   
   //Print("N Peaks", n_peaks);

   // first check if first peak is minimum or maximum, then apply a shift in the algorithm
   if (peaksVector[0]<peaksVector[2])
      shift=0;
   else
      shift=2;
   
   // find important peaks by measuring each peak's height and sharpness and obtain an "importance" number
   // to measure sharpness we consider linear lines between peaks and valleys and measure angles
   // the smaller is the angle, the sharpest is the peak. Importance for each peak is given by height/angle  
   ArrayResize(importance,n_peaks);  
   for ( int i=0; i < n_peaks; i++)
   {  
         sine=1.0/peaksVector[4*i+shift+1]-1.0/peaksVector[4*i+shift+3];      // first angle sine
         cosine=peaksVector[4*i+shift+2]-peaksVector[4*i+shift];              // first angle cosine
         angle1=MathArctan(sine/cosine);                                      // first angle
         
         sine=1.0/peaksVector[4*i+shift+3]-1.0/peaksVector[4*i+shift+5];      // second angle sine
         cosine=peaksVector[4*i+shift+2]-peaksVector[4*i+shift+4];            // second angle cosine 
         angle2=MathArctan(sine/cosine);                                      // second angle
         
         angle=angle1+angle2;
         importance[i]=peaksVector[4*i+shift+2]/angle;
         
         // chose peak        
         if (  importance[i] > max_importance*(1+0.3) )
         {  
            max_importance = importance[i];
            peak_index=i;
            //Print("importance[",i,"]:", importance[i]," - Cutoff length:",1.0/peaksVector[4*peak_index+shift+3] );
         }
   }
   
   
    
   
   if (peak_index < 0)
   { 
      Print("Error: No cutoff values found");
      return (FALSE);
   }
   else
   { 
      double fatl_P1=1.0/peaksVector[4*peak_index+shift+3];
      double fatl_D1=1.0/peaksVector[4*peak_index+shift+5];
      //Print("Period's length: ",fatl_P1," - Value: ",peaksVector[4*peak_index+shift+2], " - Importance: ", importance[peak_index] );
      //Print("fatl - cutoff P1:",fatl_P1," - cutoff D1:",fatl_D1); 
   }
   
   fatl_vector[0]=fatl_P1;
   fatl_vector[1]=fatl_D1;
   return (TRUE);
          
}
  
  
  
  
/*
 * Returns a vector filled with  "(beginChartingPeriod-endChartingPeriod)*resolution"  spectum values
 */
bool MESpectrum(
   double&  inputseries[],          // real data input vector to be analyzed
   int      length,                 // length of input vector
   int      degree,                 // degree (order) of autoregression
   int      beginChartingPeriod,    // maximum=lenth corresponding to the observed time lapse
   int      endChartingPeriod,      // minimum=2 corresponding to the Nyquist frequency
   int      resolution,             // spectum resolution >= 1. A value of 10 means that spectrum is evaluated at every 0.1 of periods amplitude
   double&  spectrumVector[])       // spectrum values at the given resolution is returned by means of this vector
{
   double mean[1];
   double aa[];
   
   ArrayResize(aa,degree);
   
   // Resolve Autoregression coefficient for the given degree. Maximum entropy method is the optimum choice
   // Least Squares is only for testing purposes
   if (!AutoRegression(inputseries, length, degree, aa, mean, MAXENTROPY))
     {
      Print("Autoregression Failed ");
      return(FALSE);  
     } 
    
   /*
      Create vector with the specrum values.
      
      The Nyquist frequency Fn is Fc/2 where Fs is sampling frequency (Fs=1 because of it's normalization)
      Fn is the maximum representable frequency.
      Frequency is calculated in (1) so that we can plot the spectrum as a funcion of period's length, starting
      from "beginChartingPeriod" (longer period) down to "endChartingPeriod" with the given resolution
    */
   double frequency;
   int begin=(2*length-beginChartingPeriod)*resolution;
   int end=(2*length-endChartingPeriod)*resolution;
   for( int i=begin; i<=end; i++)
   {  
      frequency=1.0/(2*length-i*1.0/resolution); // (1)
      spectrumVector[i-begin]=spectrumValue(frequency, aa, degree);
   }
   return(TRUE);
}


/*
 * Returns a vector with peaks and valleys values
 */
int MEPeaks(
   double&  inputseries[],          // real data input vector to be analyzed
   int      length,                 // length of input vector
   int      degree,                 // degree (order) of autoregression
   double   f_max,                  // the frequency under which to search peaks (f_max < Fn)
   double   f_min,                  // the frequency above which to search peaks (f_max < Fn)
   double&  peaksVector[])          // peaks and valleys are returned by means of this vector [4*(degree+1)]
{
   double mean[1];
   double aa[];
   
   ArrayResize(aa,degree);
   
   // Resolve Autoregression coefficient for the given degree. Maximum entropy method is the optimum choice
   // Least Squares is only for testing purposes
   if (!AutoRegression(inputseries, length, degree, aa, mean, MAXENTROPY))
     {
      Print("Autoregression Failed ");
      return(FALSE);  
     } 
    
   // Calculates and returns peaks vector
   return(peaksVector (peaksVector, f_max, f_min, aa, degree));
}



/*
 *  This function fills an array with  'amplitude' and 'frequency' (0 < f < Fn=0.5, Nyquist normalized freq) values 
 *  of the peaks (and following valleys) under f_max and above f_min frequency by finding local maxima 
 *  with a bisection equivalent algorithm.
 *  It returns the number of calculated peaks 
 */
int peaksVector (
   double& peaks[],     // this vector must be dimensioned to 4*degree
   double f_max,        // the frequency under which to search peaks (f_max < Fn)
   double f_min,        // the frequency above which to search peaks (f_max > 0 )
   double& aa[],        // autoregression coefficients
   int degree)          // order of autoregression
{  
      double frequency, Qn, delta_f, delta_f2;
      double s1, s2;
      double f1, f2, fm, d1, d2, dm;
      double tolerance=0.01;                 // zero (maximum) finding tolerance (we don't need a very high precision
      double fine_stepping = 1.0 / 10.0;     // 2nd level stepping for local minimum/maximum search
      int count=0, i;
      bool growing=true;
      
      // check for Nyquist
      if (f_max > 0.5) f_max=0.5;
      
      // First evaluate Qn to set proper resolution delta_f... (see (II-70) formula in Burg's PhD thesis)
      /*
      Qn=1.0;
      for (i=0; i<degree; i++)
      {
         Qn=Qn*(1.0+MathAbs(aa[i]))/(1.0-MathAbs(aa[i]));
      }*/
      Qn=50; // above formula gives too high Qn, to be verified
      delta_f=1.0/(degree*Qn);    
      
      // ...then starts to find peaks (and valleys)
      s1=spectrumValue(f_min+delta_f,aa,degree);
      peaks[0]= s1;              // include first point ...
      peaks[1]= f_min+delta_f;   // ... and frequency
      i=2;
      d1=spectrumValue(f_min+delta_f*(1.0+fine_stepping),aa,degree) - s1 ;
      if (d1 < 0) 
         growing=false;    // set initial slope direcion
      
      for (frequency=f_min+2*delta_f; frequency < f_max || (frequency >= f_max && !growing); frequency+=delta_f)   
      {    
         s2=spectrumValue (frequency,aa,degree);
         if (s2>s1 && growing)                     
         { 
            s1=s2;                                 // updates new maximum   
         } 
         else if (s2<=s1 && growing)               // found an interval in which there is a local maximum??  
         {
            // search for a local maximum in the interval [ frequency-delta_f,frequency + delta_f ] 
            f1=frequency-2.0*delta_f;
            f2=frequency;
            delta_f2=delta_f*fine_stepping; // delta_f2 (adaptive) is used to evaluate funcion's slope   
            d1=spectrumValue(f1+delta_f2,aa,degree) - spectrumValue(f1,aa,degree);
            d2=spectrumValue(f2+delta_f2,aa,degree) - spectrumValue(f2,aa,degree);
            while (true)
            {
               // try to find maximum value by evaluating central point's slope
               fm = (f1+f2)/2.0;
               dm=spectrumValue(fm+delta_f2,aa,degree) - spectrumValue(fm,aa,degree);
               if ( MathAbs(dm) < tolerance) 
                  break;
               if (dm < 0.0) f2=fm;
               else f1=fm;
               
               delta_f2=(f2-f1)*fine_stepping;        // adapt delta_f2
               d1=spectrumValue(f1+delta_f2,aa,degree) - spectrumValue(f1,aa,degree);
               d2=spectrumValue(f2+delta_f2,aa,degree) - spectrumValue(f2,aa,degree);   
            } 
            peaks[i]= spectrumValue (fm,aa,degree);  
            peaks[i+1]=fm;
            i+=2; 
            count++;          // increments number of peaks
            growing=false;    // after a peak there must be a valley, so the funcion starts to decrease
         }        
         else if (s2<s1 && !growing)   
         {
            s1=s2;                                    // updates new minimum  
         } 
         else if (s2>=s1 && !growing)                 // found an interval in which there is a local minimum??  
         {
            // search for a local maximum in the interval [ frequency-delta_f,frequency + delta_f ] 
            f1=frequency-2.0*delta_f;
            f2=frequency;
            delta_f2=delta_f*fine_stepping; // delta_f2 (adaptive) is used to evaluate funcion's slope   
            d1=spectrumValue(f1+delta_f2,aa,degree) - spectrumValue(f1,aa,degree);
            d2=spectrumValue(f2+delta_f2,aa,degree) - spectrumValue(f2,aa,degree);
            while (true)
            {
               // try to find maximum value by evaluating central point's slope
               fm = (f1+f2)/2.0;
               dm=spectrumValue(fm+delta_f2,aa,degree) - spectrumValue(fm,aa,degree);  
               if ( MathAbs(dm) < tolerance) 
                  break;
               if (dm > 0.0) f2=fm;
               else f1=fm;      
                  
               delta_f2=(f2-f1)*fine_stepping;        // adapt delta_f2   
               d1=spectrumValue(f1+delta_f2,aa,degree) - spectrumValue(f1,aa,degree);
               d2=spectrumValue(f2+delta_f2,aa,degree) - spectrumValue(f2,aa,degree);
            
            } 
            peaks[i]= spectrumValue (fm,aa,degree);  
            peaks[i+1]=fm;
            i+=2;
            growing=true;    
         }
      }

      return(count);
}


/*
 *  This function calculates a spectrum value at a given frequency from an autoregression vector
 */
double spectrumValue (double frequency, double& aa[], int degree)
{  
     
      double s1=0.0;
      double s1r=1.0;
      double s1i=0.0;
      double omega=2*pi*frequency;
      for (int j=0;j<degree;j++)
      {
         s1r+=(-aa[j])*MathCos(-(j+1)*omega);
         s1i+=(-aa[j])*MathSin(-(j+1)*omega);
      }
      s1=MathSqrt(MathPow(s1r,2)+MathPow(s1i,2));
      return(1.0/s1);
}


/* 
 *    Perform AR parameter estimation
 */
bool AutoRegression(
   double&  inputseries[],
   int      length,
   int      degree,
   double&  coefficients[],
   double&  c0[],
   int      method)
{
   double mean;
   int i, t;            
   double w[];                /* Input series - mean                           */
   double h[]; 
   double g[];                /* Used by mempar()                              */
   double per[]; 
   double pef[];              /* Used by mempar()                              */
   double ar[][MAXIMUMDEGREE];/* AR coefficients, all degrees                  */
   
   
   if(degree>=MAXIMUMDEGREE)
     {
      Print("Degree must be under ", MAXIMUMDEGREE);
      return(FALSE);  
     }  

   /* Allocate space for working variables */
   ArrayResize(w,length);
   ArrayResize(h,degree+1);
   ArrayResize(g,degree+2);
   ArrayResize(per,length+1);
   ArrayResize(pef,length+1);
   ArrayResize(ar,degree+1);
   

   /* Determine and subtract the mean from the input series */
   mean = 0.0;
   for (t=0;t<length;t++) 
      mean += inputseries[t];
   mean /= (1.0*length);
   for (t=0;t<length;t++)
      w[t] = inputseries[t] - mean;
   
   /* Perform the appropriate AR calculation */
   if (method == MAXENTROPY) {

      if (!ARMaxEntropy(w,length,degree,ar,per,pef,h,g)) {
      	Print("Max entropy failed - fatal!\n");
      	return(FALSE);
		}	
      for (i=1;i<=degree;i++)
         coefficients[i-1] = -ar[degree][i];

   } else if (method == LEASTSQUARES) {

      if (!ARLeastSquare(w,length,degree,coefficients)) {
      	Print("Least squares failed - fatal!\n");
      	return(FALSE);
		}

   } else {

      Print("Unknown method\n");
		return(FALSE);

   }
   c0[0]=mean;  
   return(TRUE);
}


/*   
 * Previously called mempar()
 * Originally in FORTRAN, hence the array offsets of 1, Yuk.
 * Original code from Kay, 1988, appendix 8D.
 * 
 * Perform Burg's Maximum Entropy AR parameter estimation
 * outputting successive models en passant. Sourced from Alex Sergejew
 *
 * Two small changes made by NH in November 1998:
 * tstarz.h no longer included, just say "typedef double REAL" instead
 * Declare ar by "REAL **ar" instead of "REAL ar[MAXA][MAXA]
 * 
 * Further "cleaning" by Paul Bourke.....for personal style only.
 */
bool ARMaxEntropy(
   double& inputseries[],
   int length,int degree,
   double& ar[][],
   double& per[],double& pef[],
   double& h[],double& g[])
{
   int j,n,nn,jj;
   double sn,sd;
   double t1,t2;

   for (j=1;j<=length;j++) {
      pef[j] = 0;
      per[j] = 0;
   }
      
   for (nn=2;nn<=degree+1;nn++) {
      n  = nn - 2;
      sn = 0.0;
      sd = 0.0;
      jj = length - n - 1;
      for (j=1;j<=jj;j++) {
         t1 = inputseries[j+n] + pef[j];
         t2 = inputseries[j-1] + per[j];
         sn -= 2.0 * t1 * t2;
         sd += (t1 * t1) + (t2 * t2);
      }
      g[nn] = sn / sd;
      t1 = g[nn];
      if (n != 0) {
         for (j=2;j<nn;j++) 
            h[j] = g[j] + (t1 * g[n - j + 3]);
         for (j=2;j<nn;j++)
            g[j] = h[j];
         jj--;
      }
      for (j=1;j<=jj;j++) {
         per[j] += (t1 * pef[j]) + (t1 * inputseries[j+nn-2]);
         pef[j]  = pef[j+1] + (t1 * per[j+1]) + (t1 * inputseries[j]);
      }

      for (j=2;j<=nn;j++)
         ar[nn-1][j-1] = g[j];
   }
   
   return(TRUE);
}

/*
 * Least squares method
 * Original from Rainer Hegger, Last modified: Aug 13th, 1998
 * Modified (for personal style and context) by Paul Bourke
 */
bool ARLeastSquare(
   double&  inputseries[],
   int      length,
   int      degree,
   double&  coefficients[])
{
   int i,j,k,hj,hi;
   double mat[][MAXIMUMDEGREE];
   
   ArrayResize(mat,degree);

   for (i=0;i<degree;i++) {
      coefficients[i] = 0.0;
      for (j=0;j<degree;j++)
         mat[i][j] = 0.0;
   }
   for (i=degree-1;i<length-1;i++) {
      hi = i + 1;
      for (j=0;j<degree;j++) {
         hj = i - j;
         coefficients[j] += (inputseries[hi] * inputseries[hj]);
         for (k=j;k<degree;k++)
            mat[j][k] += (inputseries[hj] * inputseries[i-k]);
      }
   }
   for (i=0;i<degree;i++) {
      coefficients[i] /= (length - degree);
      for (j=i;j<degree;j++) {
         mat[i][j] /= (length - degree);
         mat[j][i] = mat[i][j];
      }
   }

   /* Solve the linear equations */
   if (!SolveLE(mat,coefficients,degree)) {
		Print("Linear solver failed - fatal!\n");
		return(FALSE);
	}
     
   return(TRUE);
}


/*
 * Gaussian elimination solver
 * Author: Rainer Hegger Last modified: Aug 14th, 1998
 * Modified (for personal style and context) by Paul Bourke
 */
bool SolveLE(double& mat[][],double& vec[],int n)
{
   int i,j,k,maxi;
   double vswap,mswap[],hvec[],max,h,pivot,q;

   ArrayResize(mswap,n);
   ArrayResize(hvec,n);
  
   for (i=0;i<n-1;i++) {
      //max = fabs(mat[i][i]);
      max = MathAbs(mat[i][i]);
      maxi = i;
      for (j=i+1;j<n;j++) {
         //if ((h = fabs(mat[j][i])) > max) {
         h = MathAbs(mat[j][i]);
         if (h > max) {
            max = h;
            maxi = j;
         }
      }
      if (maxi != i) {
         /*
          * Two matrix rows are swapped
         mswap     = mat[i];
         mat[i]    = mat[maxi];
         mat[maxi] = mswap;
         */
         for (int ii=0;ii<n;ii++) {
            mswap[ii]=mat[i][ii];
            mat[i][ii]=mat[maxi][ii];
            mat[maxi][ii]=mswap[ii];
         }
         
         vswap     = vec[i];
         vec[i]    = vec[maxi];
         vec[maxi] = vswap;
      }
    
      //hvec = mat[i];
      pivot = mat[i][i];
      //if (fabs(pivot) == 0.0) {
      if (MathAbs(pivot) == 0.0) {
         Print("Singular matrix - fatal!\n");
         return(FALSE);
      }
      for (j=i+1;j<n;j++) {
         q = - mat[j][i] / pivot;
         mat[j][i] = 0.0;
         for (k=i+1;k<n;k++)
            mat[j][k] += q * mat[i][k];
         vec[j] += (q * vec[i]);
      }
   }
   vec[n-1] /= mat[n-1][n-1];
   for (i=n-2;i>=0;i--) {
      //hvec = mat[i];
      for (j=n-1;j>i;j--)
         vec[i] -= (mat[i][j] * vec[j]);
      vec[i] /= mat[i][i];
   }
   
   return(TRUE);
}


/*
 * Check algorythms with test suite
 * returns true if all is OK , otherwise it returns false
 */
bool checkAR()
{
   int i,j,k;
   int degree=5;
   int length=500;
   int method=1;
   int N=1000;


   double inputseries[];
   double aa[], bb[], cc[];
   double partial,noise,WGN, mean[1];
   
   ArrayResize(inputseries,length);
   ArrayResize(aa,degree);
   ArrayResize(bb,degree);
   ArrayResize(cc,degree);
   MathSrand(TimeLocal());

   cc[0]=1.4;
   cc[1]=-0.7;
   cc[2]=0.04;
   cc[3]=0.7;
   cc[4]=-0.5;

   
   inputseries[length-1]=1.0;
   for (i=length-2; i>=0; i--)
   {
      partial=0.0;
      for (j=0; j<degree; j++)
      {
         if (i+1+j > length-1)
            partial+=0.0;
         else
            partial+=inputseries[i+1+j]*cc[j];
      
      }
      
      // Generate WHITE GAUSSIAN NOISE from uniform noise
      WGN=0;
      for (k = 1; k <= N;k++)
      {
         WGN = WGN + (MathRand()*1.0)/32767;
      }
	   /* for uniform randoms in [0,1], mu = 0.5 and var = 1/12 */
      /* adjust X so mu = 0 and var = 1 */
      WGN = WGN - 1.0*N/2;                   /* set mean to 0 */
      WGN = WGN * MathSqrt(12.0 / N);      /* adjust variance to 1 */
      noise=WGN;
      
      //noise=(MathRand()-16535)*1.0/32767;
      
      inputseries[i]=partial+noise;    
   }
   if ( AutoRegression(inputseries, length, degree, aa, mean, 1) && AutoRegression(inputseries, length, degree, bb, mean, 2) )
   {
      Print("Init OK");
      /*
      Print("Init - Max Entropy coefficients");
      for (j=0; j<degree; j++)
         Print(DoubleToStr(aa[j],4));
         
      Print("Init - LSR coefficients");
      for (j=0; j<degree; j++)
         Print(DoubleToStr(bb[j],4));
      */
      return(TRUE);
   }
   else
   {
      Print("Init failed");
      return(FALSE);
   }
}