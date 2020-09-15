//------------------------------------------------------------------
#property copyright "www.forex-tsd.com"
#property link      "www.forex-tsd.com"
//------------------------------------------------------------------

#property indicator_separate_window
#property indicator_buffers 5
#property indicator_color1  DarkSlateGray
#property indicator_color2  DarkSlateGray
#property indicator_style1  STYLE_DASH
#property indicator_style2  STYLE_DASH 
#property indicator_color3  Orange
#property indicator_color4  Magenta
#property indicator_color5  Blue

//
//
//
//
//

extern int    EnvelopePeriod = 15;
extern int    EnvelopeMaShift= 0;
extern int    EnvelopeMaMode  = MODE_EMA;
extern int    UpperPrice      = 0;
extern int    LowerPrice      = 0;
extern double Deviation       = 0.25;

extern int    FastMaPeriod    = 7;
extern int    FastMaShift     = 0;
extern int    FastMaMode      = MODE_EMA;
extern int    FastMaPrice     = PRICE_CLOSE;

extern int    MiddMaPeriod    = 25;
extern int    MiddMaShift     = 0;
extern int    MiddMaMode      = MODE_SMA;
extern int    MiddMaPrice     = PRICE_CLOSE;

extern int    SlowMaPeriod    = 35;
extern int    SlowMaShift     = 0;
extern int    SlowMaMode      = MODE_SMA;
extern int    SlowMaPrice     = PRICE_CLOSE;

extern string note            = "turn on Alert = true; turn off = false";
extern bool   alertsOn        = true;
extern bool   alertsOnCurrent = true;
extern bool   alertsMessage   = true;
extern bool   alertsSound     = true;
extern bool   alertsEmail     = false;
extern string soundfile       = "alert2.wav";

//
//
//
//
//

double UpEnv[];
double DnEnv[];
double fastMa[];
double middMa[];
double slowMa[];
double trend[];
string short_name;

//
//
//
//                    
//

int init()
{

   SetIndexBuffer(0,UpEnv);  SetIndexShift(0,EnvelopeMaShift);
   SetIndexBuffer(1,DnEnv);  SetIndexShift(1,EnvelopeMaShift);
   SetIndexBuffer(2,fastMa); SetIndexShift(2,FastMaShift);
   SetIndexBuffer(3,middMa); SetIndexShift(3,MiddMaShift);
   SetIndexBuffer(4,slowMa); SetIndexShift(4,SlowMaShift);
   SetIndexBuffer(5,trend);
   
   short_name="enveloping Ma("+EnvelopePeriod+","+FastMaPeriod+","+MiddMaPeriod+","+SlowMaPeriod+")";
   IndicatorShortName(short_name);
   
   
return(0);
}  
  
//+------------------------------------------------------------------
//|                             
//+------------------------------------------------------------------
//
//

int start()
{
   int counted_bars=IndicatorCounted();
   int i,limit;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
         limit = MathMin(Bars-counted_bars,Bars-1);
         
   //
   //
   //
   //
   //
   
   for (i = limit; i >= 0; i--)
   {
      UpEnv[i]  = (1+Deviation/100)*iMA(NULL,0,EnvelopePeriod,EnvelopeMaShift,EnvelopeMaMode,UpperPrice,i);
      DnEnv[i]  = (1-Deviation/100)*iMA(NULL,0,EnvelopePeriod,EnvelopeMaShift,EnvelopeMaMode,LowerPrice,i);
      fastMa[i] = iMA(NULL,0,FastMaPeriod,FastMaShift,FastMaMode,FastMaPrice,i);
      middMa[i] = iMA(NULL,0,MiddMaPeriod,MiddMaShift,MiddMaMode,MiddMaPrice,i);
      slowMa[i] = iMA(NULL,0,SlowMaPeriod,SlowMaShift,SlowMaMode,SlowMaPrice,i);
      
      trend[i] = trend[i+1];
         if (fastMa[i]>slowMa[i]) trend[i] = 1;
         if (fastMa[i]<slowMa[i]) trend[i] =-1;
         }

         //
         //
         //
         //
         //
         
         if (alertsOn)
         {
         if (alertsOnCurrent)
              int whichBar = 0;
         else     whichBar = 1;

         //
         //
         //
         //
         //
         
         if (trend[whichBar] != trend[whichBar+1])
         if (trend[whichBar] == 1)
               doAlert("uptrend");
         else  doAlert("downtrend");       
   }
   
   return(0);
}
//+------------------------------------------------------------------+


void doAlert(string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
      if (previousAlert != doWhat || previousTime != Time[0]) {
          previousAlert  = doWhat;
          previousTime   = Time[0];

          //
          //
          //
          //
          //

          message =  StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," ma cross ",doWhat);
             if (alertsMessage) Alert(message);
             if (alertsEmail)   SendMail(StringConcatenate(Symbol()," ma cross "),message);
             if (alertsSound)   PlaySound(soundfile);
      }
}
 
   

