//+------------------------------------------------------------------+
//|                Stochastic (with alert)                           |
//|                Copyright © 2006  Scorpion@fxfisherman.com        |
//+------------------------------------------------------------------+
#property copyright "FxFisherman.com"
#property link      "http://www.fxfisherman.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Aqua
#property indicator_color2 Red
#property indicator_minimum 0
#property indicator_maximum 100

extern string    ________General_______;
extern int K = 5;
extern int D = 3;
extern int Slowing = 3;
extern int MA_Mode = 0;   // 0 = SMA, 1 = EMA, 
extern int Shift_Bars=0;
extern int Bars_Count= 0;

extern string    _________Alert________;
extern double Overbuy_Level = 80;
extern double Oversell_Level = 20;
extern bool   Enable_Alert_1 = true;
extern double Crossover_Gap = 0;
extern bool   Enable_Alert_2 = true;

//---- buffers
double v1[];
double v2[];
  
int init()
  {

   IndicatorBuffers(2);
  
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1);
   SetIndexDrawBegin(0,K+Slowing);
   SetIndexBuffer(0, v1);
   SetIndexLabel(0,"K");
   
   SetIndexStyle(1,DRAW_LINE,STYLE_DOT,1);
   SetIndexDrawBegin(1,K+D+Slowing);
   SetIndexBuffer(1, v2);
   SetIndexLabel(1,"D");
   
   watermark();
 
   return(0);
  }

int start()
 {
  int i;
  int shift; 
  int counted_bars = IndicatorCounted();
  if (counted_bars > 0) counted_bars--;
  if (Bars_Count > 0 && Bars_Count <= Bars)
  {
    i = Bars_Count - counted_bars;
  }else{
    i = Bars - counted_bars;
  }
  
  while(i>=0)
   {
    shift = i + Shift_Bars;
    v1[i] = iStochastic(Symbol(), Period(), K, D, Slowing, MA_Mode, 0, 0, shift);
    v2[i] = iStochastic(Symbol(), Period(), K, D, Slowing, MA_Mode, 0, 1, shift);
    Print(v1[i]);
    i--;
   }
  
  // Alert: Overbuy and Oversold
  static int OBOS;
  if (Enable_Alert_1 && v1[0] >= Overbuy_Level && OBOS != 1)
  {
    OBOS = 1;
    Alert("Stoch: Overbuy! Stoch K: ", v1[0]);
  }else if (Enable_Alert_1 && v1[0] <= Oversell_Level && OBOS != -1){
    OBOS = -1;
    Alert("Stoch: Oversell! Stoch K: ", v1[0]);
  }
  
  // Alert crossover
  static int Crossover;
  if (Enable_Alert_2 && v1[1] < v2[0] + Crossover_Gap && v1[0] >= v2[0] + Crossover_Gap && Crossover != 1) {
    Crossover = 1;
    Alert("Stoch: K crosses above D! Trend: Bull");
  }else if(Enable_Alert_2 && v1[1] > v2[0] - Crossover_Gap && v1[0] <= v2[0] - Crossover_Gap && Crossover != -1) {
    Crossover = -1;
    Alert("Stoch: K crosses below D! Trend: Bear");
  }
  return(0);
 }
 
//+------------------------------------------------------------------+

void watermark()
  {
   ObjectCreate("fxfisherman", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("fxfisherman", "fxfisherman.com", 11, "Lucida Handwriting", RoyalBlue);
   ObjectSet("fxfisherman", OBJPROP_CORNER, 2);
   ObjectSet("fxfisherman", OBJPROP_XDISTANCE, 5);
   ObjectSet("fxfisherman", OBJPROP_YDISTANCE, 10);
   return(0);
  }