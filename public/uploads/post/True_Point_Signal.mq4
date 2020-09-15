//+------------------------------------------------------------------+
//|                                                                  |
//|                                                Copyright © 2010|
//|                                          Jsdinc@yahoo.com |
//+------------------------------------------------------------------+

//----
#define major   1
#define minor   1
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Lime
#property indicator_color2 Red
#property indicator_width1  1
#property indicator_width2  1
//----
double CrossUp[];
double CrossDown[];
//----
int Bars.left=5;
int Bars.right=5;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   SetIndexBuffer(1, CrossUp);
   SetIndexBuffer(0, CrossDown);
   //
   SetIndexEmptyValue(0, 0);
   SetIndexEmptyValue(1, 0);
   //
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 233);
   //
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 234);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void start()
  {
   int counted=IndicatorCounted();
   if (counted < 0) return(-1);
   if (counted > 0) counted--;
   int limit=Bars-counted;
//-----
   double dy=0;
     for(int i=1; i<=20; i++) 
     {
      dy+=0.3*(High[i]-Low[i])/20;
     }
   for(i=1+Bars.right; i<=limit+Bars.left; i++)
     {
      CrossUp[i]=0;
      CrossDown[i]=0;
//----
      if (IsCrossUp(i)) CrossUp[i]=High[i] + dy;
      if (IsCrossDown(i)) CrossDown[i]=Low[i] - dy;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsCrossUp(int bar)
  {
   for(int i=1; i<=Bars.left; i++)
     {
      if (bar+i>=Bars) return(false);

      if (High[bar] < High[bar+i]) return(false);
     }
   for(i=1; i<=Bars.right; i++)
     {
      if (bar-i < 0) return(false);
      if (High[bar] < High[bar-i]) return(false);
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsCrossDown(int bar)
  {
   for(int i=1; i<=Bars.left; i++)
     {
      if (bar+i>=Bars) return(false);
      if (Low[bar] > Low[bar+i]) return(false);
     }
   for(i=1; i<=Bars.right; i++)
     {
      if (bar-i < 0) return(false);
      if (Low[bar] > Low[bar-i]) return(false);
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+