//+------------------------------------------------------------------+
//|                                                 FadedBckgrnd.mq4 |
//|                                                      Tino Wening |
//|                                                  info@prinova.de |
//+------------------------------------------------------------------+
#property copyright "Tino Wening"
#property link      "info@prinova.de"

#property indicator_chart_window
#import "stdlib.ex4"
int RGB(int red_value,int green_value,int blue_value);
double top, bottom;
datetime left;
int right_bound;
datetime right;
extern string topcol  ="000,000,000";
extern string bottomcol ="000,000,255";
int r,g,b;
extern int steps =20;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   //Print(colour);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   for(int x=1;x<=steps;x++)
   {
      ObjectDelete("Padding_rect"+x);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   top =  WindowPriceMax();
   bottom = WindowPriceMin(); 
   left = Time[WindowFirstVisibleBar()];
   right_bound=WindowFirstVisibleBar()-WindowBarsPerChart();
   if(right_bound<0) right_bound=0;
   right=Time[right_bound]+Period()*60;
   for(int x=1;x<=steps;x++)
   {
      if(ObjectFind("Padding_rect"+x) ==-1) ObjectCreate("Padding_rect"+x,OBJ_RECTANGLE,0,left,top-((top-bottom)/steps)*(x-1),right,top-((top-bottom)/steps)*(x));
      ObjectSet("Padding_rect"+x, OBJPROP_TIME1, left);
      ObjectSet("Padding_rect"+x, OBJPROP_TIME2, right);
      ObjectSet("Padding_rect"+x, OBJPROP_PRICE1, top-((top-bottom)/steps)*(x-1));
      ObjectSet("Padding_rect"+x, OBJPROP_PRICE2, top-((top-bottom)/steps)*(x));
      ObjectSet("Padding_rect"+x,OBJPROP_BACK,true);
      
      ObjectSet("Padding_rect"+x,OBJPROP_COLOR, ss2rgb(topcol, bottomcol,steps, x));//  RGB((128/steps*x),(128/steps*x),(255/steps*x)));
   }
      WindowRedraw();

//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int ss2rgb(string colour1, string colour2, int step, int index)
{
   
   int r1 = StrToInteger(StringSubstr(colour1, 0,3));
   int g1 = StrToInteger(StringSubstr(colour1, 4,3));
   int b1 = StrToInteger(StringSubstr(colour1, 8,3));
   
   int r2 = StrToInteger(StringSubstr(colour2, 0,3));
   int g2 = StrToInteger(StringSubstr(colour2, 4,3));
   int b2 = StrToInteger(StringSubstr(colour2, 8,3));
   
   if(r1>r2)
   {
      r = r1+((r2-r1)/step*index);
   }
   if(r1<r2)
   {
      r = r1-((r1-r2)/step*index);
   }
   
   if(g1>g2)
   {
      g = g1+((g2-g1)/step*index);
   }
   if(g1<g2)
   {
      g = g1-((g1-g2)/step*index);
   }
   
   if(b1>b2)
   {
      b = b1+((b2-b1)/step*index);
   }
   if(b1<b2)
   {
      b = b1-((b1-b2)/step*index);
   }
   
   g<<=8;
   b<<=16;
   return(r+g+b);
   
      
}