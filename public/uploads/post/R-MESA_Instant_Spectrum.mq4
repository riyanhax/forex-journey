//+------------------------------------------------------------------+
//|                                                                  |
//|  R-MESA-Instant_Spectrum v.1.2                                   |
//|  Copyright © 2009 Riccardo "Rich" Cap                            |
//|  email: richcap.rc@gmail.com                                     |
//|                                                                  |
//|                                                                  |
//|  This indicator draws a Maximum Entropy Spectrum Analysis at     |
//|  time 0 (now) for every new Close[0]  (redraws every tick)       |
//|  This indicator also draws (and writes to file) Frequency peaks  |
//|  and valleys                                                     |
//|  It also has an option to add a sinusoidal signal (length and    |
//|  amplitude) for testing purposes                                 |
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

#property copyright "Riccardo -Rich- Cap"

#import "R-MESA.ex4"
bool MESpectrum(
   double&  inputseries[],
   int      length,
   int      degree,
   int      max_period,
   int      min_period,
   int      resolution,
   double&  spectrumVector[]);
int MEPeaks(
   double&  inputseries[],          // real data input vector to be analyzed
   int      length,                 // length of input vector
   int      degree,                 // degree (order) of autoregression
   double   f_max,                  // the frequency under which to search peaks (f_max < Fn)
   double   f_min,                  // the frequency above which to search peaks (f_max < Fn)
   double&  peaksVector[]);         // peaks and valleys are returned by means of this vector
bool checkAR();
#import
#define pi 3.14159265358979323846

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
#property indicator_level1 0.0

//---- buffers
double Buffer1[];

//---
extern int degree=150;
extern int length=200;
extern double max_period=400.0;       // maximum=2*lenth (double the observed time lapse)
extern double min_period=2.0;         // minimum=2 corresponding to the Nyquist frequency
extern datetime initial_time=D'1970.01.01 00:00'; // if backwardBars=0, get it from initial_time
extern int backwardBars=0;       // The indicator is drawn backard "*" bars       ** Check if == 0 ** (MESA_Cutoff_frequencies problems??
extern int resolution=1;
extern int write_N_peaks=10;
extern int waveA=0;              // add this for testing purposes
extern double waveL=100.0;       // add this for testing purposes
// denoising
extern int FilterPeriod=3;    
extern int FilterMode=0;         // take raw timeseries (1) or Median filtered(1) or NonLagMA(2)
extern int ValueMode=3;          // Apply to 0=Open, 1=Low, 2=High, 3=Close (default), 4=(H+L)/2

double inputseries[];
double vector1[];
double vector2[];
int n_peaks=0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   if (!checkAR())
      return(0);
      
   // sets number of initial bars, meaning that analisys is taken "backwardBars" backward from actual bar
   if (backwardBars==0)
   {
      if (initial_time == D'1970.01.01 00:00')
         backwardBars=0;
      else
         backwardBars=iBarShift(NULL,0,initial_time, true)-1;        
   }   
   if (backwardBars==-1)
   {
      Print ("Initial time not valid");
      return (20);            
   }
   else  Print("shift of bar with open time ",TimeToStr(initial_time)," is ",backwardBars);
      
   //---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM,0,1);
   SetIndexBuffer(0,Buffer1);   

   ArrayResize(inputseries,length);
   ArrayResize(vector1,(max_period-min_period)*resolution);
   ArrayResize(vector2,6*(degree+1));
   //----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   //----
   int handle;
   handle=FileOpen("Mesa_Peaks_Output.csv", FILE_CSV|FILE_WRITE, ';');
   if(handle>0)
    {
      for(int i=0; i<2*(n_peaks+1); i++)
      {
         FileWrite(handle, "Peak/valley ",i," :", DoubleToStr(vector2[2*i],5)," @ ",vector2[2*i+1], " - Period's length: " , DoubleToStr(1.0/vector2[2*i+1],2) );
      }
     FileClose(handle);
     Print("File  saved ");
    }
   else
    {
      Print("File  not found, the last error is ", GetLastError());
      return(false);
    }
   //----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{

   if( Bars<length) return(0);
 
   SetIndexDrawBegin(0,Bars-(max_period-min_period)*resolution);
   
   // Fill vector for spectrum analysis. Eventually denoise with given filter and period, then add a sinusoid if requested
   for(int i=length-1; i>=0; i--) 
   { 

      inputseries[i]=0;
      switch (FilterMode)
      {
         case 0:               
                  switch (ValueMode)
                  {  
                     case MODE_CLOSE: 
                        inputseries[i]+=iClose(Symbol(),0,backwardBars+i+1);
                        break;
                     case MODE_HIGH: 
                        inputseries[i]+=iHigh(Symbol(),0,backwardBars+i+1);
                        break;
                     case MODE_LOW: 
                        inputseries[i]+=iLow(Symbol(),0,backwardBars+i+1);
                        break;
                     case MODE_OPEN: 
                        inputseries[i]+=iOpen(Symbol(),0,backwardBars+i+1);
                        break;
                     case 4: 
                        inputseries[i]+=( iHigh(Symbol(),0,backwardBars+i+1) + iLow(Symbol(),0,backwardBars+i+1) ) / 2;
                        break;
                     default:  
                        inputseries[i]+=iClose(Symbol(),0,backwardBars+i+1);
                        break;
                    }
                    break;
         
         case 1:
                  inputseries[i]+=iMA(NULL, 0, FilterPeriod,0,MODE_SMA,ValueMode,backwardBars+i+1);
                  break;
         case 2:
                  inputseries[i]+=iCustom(NULL, 0, "MedianFilter",FilterPeriod,0,ValueMode,0,backwardBars+i+1);
                  break;
         case 3:
                  inputseries[i]+=iCustom(NULL, 0, "NonLagMA_v6.1",ValueMode,FilterPeriod,0,0,1,0,0,0,backwardBars+i+1);
                  break;
         case 4:
                  inputseries[i]+=iCustom(NULL, 0, "Kalman Filter",FilterPeriod,ValueMode,0,backwardBars+i+1);
                  break;
         case 5:
                  inputseries[i]+=iCustom(NULL, 0, "JMA",FilterPeriod,0,0,backwardBars+i+1);
                  break;
         case 6:
                  inputseries[i]+=iCustom(NULL, 0, "R-DigitalFilter",2*FilterPeriod,FilterPeriod,40.0,0.8,0,ValueMode,0,backwardBars+i+1);
                  break;
         default:
                  break;
      }  
      double waveAmplitude=waveA*Point;                              // add this for testing purposes
      inputseries[i]+=waveAmplitude*MathCos(2*pi/waveL*(i+1));       // add this for testing purposes
   }
   
   // Calculate and plot spectrum
   if (!MESpectrum(inputseries,length,degree,max_period,min_period,resolution,vector1))
      return (-1);
   
   for( i=0; i<=(max_period-min_period)*resolution; i++)
   {     
      Buffer1[i]=MathMin(vector1[i],MathPow(2,46));
   }
 
   // Calculate and write peaks and valleys
   n_peaks=MEPeaks(inputseries,length,degree,1.0/min_period,1.0/max_period,vector2);
   Print("Number of peaks with period above ",min_period," : ", n_peaks); 
   if (!n_peaks)
      return (-1);
   write_text(write_N_peaks);
   
   
   //----
   return(0);
}
  
void write_text(int index)
{
   string text;
   color col=Orange;   
   
   int thisWindow=WindowFind( "R-MESA_Instant_Spectrum");
   ObjectsDeleteAll(thisWindow, OBJ_LABEL);   
   
   for(int i=0; i<2*(index+1); i++)
   {
      text=StringConcatenate( "Peak / valley  ",i,"  : ", DoubleToStr(vector2[2*i],2), "   -   Period's length: " , DoubleToStr(1.0/vector2[2*i+1],2) );
      if ( col==Orange ) col=Yellow;
      else col=Orange;
      
      if(!ObjectCreate( StringConcatenate("MESA_Peak",DoubleToStr(i,0)) ,OBJ_LABEL, thisWindow, 0,0))
      {
         Print("error: can't create text_object! code #",GetLastError());
      }
      else    
      {
         ObjectSet(StringConcatenate("MESA_peak",DoubleToStr(i,0)), OBJPROP_CORNER, 0);    // Reference corner
         ObjectSet(StringConcatenate("MESA_peak",DoubleToStr(i,0)), OBJPROP_XDISTANCE, 7);      // X coordinate
         ObjectSet(StringConcatenate("MESA_peak",DoubleToStr(i,0)), OBJPROP_YDISTANCE, 15+i*10);// Y coordinate

         ObjectSetText(StringConcatenate("MESA_peak",DoubleToStr(i,0)), text, 8, "Arial", col);
      }
      
   }

 }     
 
 
//-------------------------------------------------------------------+