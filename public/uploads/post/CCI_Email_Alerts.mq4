//+------------------------------------------------------------------+
//|                                                          CCI mq4 |
//+------------------------------------------------------------------+
#property copyright "www,forex-tsd.com"
#property link      "www,forex-tsd.com"

#property indicator_separate_window
#property indicator_buffers    1
#property indicator_color1     LimeGreen
#property indicator_levelcolor Gray

//
//
//
//
//

extern int    CCIPeriod       = 14;
extern int    CCIPrice        = PRICE_TYPICAL;
extern double levelOs         = -100;
extern double levelOb         =  100;

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

double cci[];
double prices[];
double trend[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

int init()
{
   IndicatorBuffers(3);
      SetIndexBuffer(0,cci);
      SetIndexBuffer(1,prices);
      SetIndexBuffer(2,trend);
         SetLevelValue(0,levelOb);
         SetLevelValue(1,levelOs);

         
   IndicatorShortName(" CCI ("+CCIPeriod+")");
   return(0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//

int start()
{
   int counted_bars=IndicatorCounted();
   int i,k,limit;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
         limit = MathMin(Bars-counted_bars,Bars-1);

   //
   //
   //
   //
   //

   for (i=limit; i>=0; i--)
   {
      prices[i]  = iMA(NULL,0,1,0,MODE_SMA,CCIPrice,i);
      double avg = 0; for(k=0; k<CCIPeriod; k++) avg +=         prices[i+k];      avg /= CCIPeriod;
      double dev = 0; for(k=0; k<CCIPeriod; k++) dev += MathAbs(prices[i+k]-avg); dev /= CCIPeriod;
          if (dev!=0)
                cci[i] = (prices[i]-avg)/(0.015*dev);
          else  cci[i] = 0;
         
          //
          //
          //
          //
          //
         
          trend[i] = trend[i+1];
             if (cci[i]>levelOb) trend[i] = -1;
             if (cci[i]<levelOs) trend[i] =  1;
               
         }
          
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
               doAlert("oversold");
         else  doAlert("overbought");       
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

          message =  StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," cci cross ",doWhat);
             if (alertsMessage) Alert(message);
             if (alertsEmail)   SendMail(StringConcatenate(Symbol()," cci cross "),message);
             if (alertsSound)   PlaySound(soundfile);
      }
}
   
   
   