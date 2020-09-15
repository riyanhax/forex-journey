//+------------------------------------------------------------------+
//|                                        Advance_Decline_Ratio.mq4 |
//|                                                      Magnumfreak |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Magnumfreak"
#property link      ""

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 White
#property indicator_color2 White
#property indicator_level1 1
#property indicator_levelcolor White
//---- input parameters
extern int       LookBack=25;

//---- buffers
double ADRLine[];
double ADRSmoothed[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ADRLine);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ADRSmoothed);
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
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   double goingup,goingdown;
   int limit = Bars-counted_bars;
//----
   for(int i = limit;i>=0;i--){
       goingup=0;
       goingdown=0;
       for(int y = LookBack;y>0;y--){
         if(Close[i+y] > Open[i+y])goingup++;
         if(Close[i+y] < Open[i+y])goingdown++;
         }
      if(goingdown>0) ADRLine[i] = goingup/goingdown;
     
       }
//----
   return(0);
  }
//+------------------------------------------------------------------+