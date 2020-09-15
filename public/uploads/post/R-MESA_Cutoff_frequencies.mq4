//+------------------------------------------------------------------+
//|                                                                  |
//|  R-MESA-Cutoff_frequencies v.1.0                                 |
//|  Copyright © 2009 Riccardo "Rich" Cap                            |
//|  email: richcap.rc@gmail.com                                     |
//|                                                                  |
//|                                                                  |
//|  This indicator draws original (or smoothed)                     |
//|  Fatl and Satl cutoff Frequencies                                |
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

#import "R-MESA.ex4"
bool ME_Cutoff_frequencies(
   double&  inputseries[],          // real data input vector to be analyzed
   int      length,                 // length of input vector
   int      degree,                 // degree (order) of autoregression
   double   f_max,                  // the frequency under which to search peaks (f_max < Fn)
   double   f_min,                  // the frequency above which to search peaks (f_max < Fn)
   double   f_satl_max,             // the maximum satl frequency (e.g. 1/50)
   double   f_fatl_min,             // the minimum fatl frequency (e.g. 1/40)  
   double&  satl_fatl[]);           // vector to store cutoff P1 and D1 for satl and fatl
#import

#define pi 3.14159265358979323846

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 LimeGreen   // SATL cutoff period P1
#property indicator_color2 Blue        // SATL cutoff period D1 (transition)
#property indicator_color3 Red         // FATL cutoff period P1
#property indicator_color4 Orange      // FATL cutoff period D1 (transition)


//---- buffers
double Buffer1[];
double Buffer2[];
double Buffer3[];
double Buffer4[];

//---
extern int degree=150;
extern int length=200;
extern double max_period=400;
extern double min_period=5;
extern double satl_min_period=50.0;
extern int backwardsBars=20;
extern bool smoothed=true;
//extern int waveA=0;              // uncomment to verify with a sinusoidal signal
//extern double waveL=100.0;       // uncomment to verify with a sinusoidal signal

double inputseries[];
double satl_fatl[4];
double old_orig_values[4];
//double smoothed_values[];
bool filled=false;
bool firstBar=true;
static datetime prevtime=0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   //if (!checkAR())
     // return(0);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,DRAW_LINE);
   

   SetIndexDrawBegin(0,0);
   SetIndexDrawBegin(1,0);
   SetIndexDrawBegin(2,0);
   SetIndexDrawBegin(3,0);
   SetIndexBuffer(0,Buffer1);
   SetIndexBuffer(1,Buffer2);
   SetIndexBuffer(2,Buffer3);
   SetIndexBuffer(3,Buffer4);
   

   ArrayResize(inputseries,length);
   //ArrayResize(vector1,4*degree);

   //----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   //----
   
   //----
   return(0);
  }
  
  
int fill_backwards()
{
   for (int i=backwardsBars-1; i>0; i--)
   { 
     satl_fatl(i);
   }
   //Print ("Filling");
   filled=true;
   return(0);
}
  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {

   if( Bars<length) return(0);
   if (!filled)  fill_backwards();
   if(!newPeriodOpening())
     {
      return(0);  // Not the beginning of a new period
     } 
   //Print(TimeToStr(TimeCurrent(),TIME_SECONDS));
   satl_fatl(1);  // Values are calculated at the very beginning of a bar, for the previous (index=1)
   return(0);
}
    
void satl_fatl(int shift)
 {
  
   // double waveAmplitude=waveA*Point;                              // uncomment to verify with a sinusoidal signal
   for(int i=length-1; i>=0; i--) 
   { 

      inputseries[i]=0.0;
      inputseries[i]+=iClose(Symbol(),0,shift+i); 
      // inputseries[i]+=waveAmplitude*MathCos(2*pi/waveL*(i+1));    // uncomment to verify with a sinusoidal signal
   }
      
   if (!ME_Cutoff_frequencies(inputseries,length,degree,1.0/min_period,1.0/max_period,1.0/satl_min_period,1.0/(satl_min_period*0.8),satl_fatl))
      return(0);
   
   // Filter cutoff frequency change with an histeresis: change frequency band after 2 bars
   if ( (MathAbs(old_orig_values[0]-satl_fatl[0]) > 10.0)&& smoothed && !firstBar )
   { 
      Buffer1[shift]=Buffer1[shift+1];  // old SATL P1
      Buffer2[shift]=Buffer2[shift+1];  // old SATL D1  
   }
   else
   { 
      Buffer1[shift]=satl_fatl[0];  // new SATL P1
      Buffer2[shift]=satl_fatl[1];  // new SATL D1
   }
   if ( (MathAbs(old_orig_values[2]-satl_fatl[2]) > 2.0) && smoothed && !firstBar )
   { 
      Buffer3[shift]=Buffer3[shift+1];  // new FATL P1
      Buffer4[shift]=Buffer4[shift+1];  // new FATL D1
   }
   else
   { 
      Buffer3[shift]=satl_fatl[2];  // new FATL P1
      Buffer4[shift]=satl_fatl[3];  // new FATL D1  
   }
   
   //Print("Value Shift:",shift," -- Satl - cutoff P1:",satl_fatl[0]," - cutoff D1:",satl_fatl[1]," --- Fatl - cutoff P1:",satl_fatl[2]," - cutoff D1:",satl_fatl[3]); 
   
   // save old values for smoothing
   ArrayCopy(old_orig_values,satl_fatl,0,0,WHOLE_ARRAY);   
   if (firstBar) firstBar=false;
   return(0);
}
  
bool newPeriodOpening()
{
   if(prevtime == Time[0]) return(false);
   prevtime = Time[0];
   return(true);
}