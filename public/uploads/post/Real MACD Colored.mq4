//+------------------------------------------------------------------+
//|                                                  Custom MACD.mq4 |
//+------------------------------------------------------------------+

#property copyright " "
#property link      " "

#property indicator_separate_window
#property indicator_levelcolor Gray
#property indicator_buffers 4
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Yellow
#property indicator_color4 Blue
#property indicator_level1 0

//#property indicator_level2 30.0
//#property indicator_level3 15.0
//#property indicator_style4 2
//#property indicator_level4 -15.0
//#property indicator_level5 -30.0
//#property indicator_level6 -45.0

extern int FastEMA = 5;
extern int SlowEMA = 15;//23
extern int SignalSMA = 1;//0
extern double MinDiff = 0.0;
//extern int FontSize = 8;
//extern color FontColor = Silver;
double gda_104[];
double g_ibuf_108[];
double g_ibuf_112[];
double g_ibuf_116[];
double g_ibuf_120[];

int init() {
   SetIndexStyle(0, DRAW_HISTOGRAM,1,4);
   SetIndexStyle(1, DRAW_HISTOGRAM,1,4);
   SetIndexStyle(2, DRAW_HISTOGRAM);
   SetIndexStyle(3, DRAW_LINE);
   //SetLevelValue(0, 45);
   //SetLevelValue(1, 30);
   //SetLevelValue(2, 15);
   //SetLevelValue(3, -15);
   //SetLevelValue(4, -30);
   //SetLevelValue(5, -45);
   SetIndexDrawBegin(1, SignalSMA);
   IndicatorDigits(1);
   SetIndexBuffer(0, g_ibuf_108);
   SetIndexBuffer(1, g_ibuf_112);
   SetIndexBuffer(2, g_ibuf_116);
   SetIndexBuffer(3, g_ibuf_120);
   IndicatorShortName(WindowExpertName() + " (" + FastEMA + "," + SlowEMA + "," + SignalSMA + ")");
   SetIndexLabel(0, "MACD UP");
   SetIndexLabel(1, "MACD DN");
   SetIndexLabel(2, "MACD EQ");
   SetIndexLabel(3, "Signal");
   return (0);
}

int deinit() {
   string l_name_0 = WindowExpertName() + "," + Symbol() + "," + Period();
   ObjectDelete(l_name_0);
   return (0);
}

int start() {
   double lda_20[];
   int li_32;
   int l_ind_counted_4 = IndicatorCounted();
   int li_0 = MathMin(Bars - SlowEMA, Bars - l_ind_counted_4 + 1);
   ArrayResize(gda_104, li_0);
   ArraySetAsSeries(gda_104, TRUE);
   for (int li_8 = 0; li_8 < li_0; li_8++) gda_104[li_8] = (iMA(NULL, 0, FastEMA, 0, MODE_EMA, PRICE_CLOSE, li_8) - iMA(NULL, 0, SlowEMA, 0, MODE_EMA, PRICE_CLOSE, li_8)) / Point / 10.0;
   for (li_8 = li_0 - 2; li_8 >= 0; li_8--) {
      if (MathAbs(gda_104[li_8] - (gda_104[li_8 + 1])) < MinDiff) {
         g_ibuf_116[li_8] = gda_104[li_8];
         g_ibuf_108[li_8] = 0;
         g_ibuf_112[li_8] = 0;
      } else {
         if (gda_104[li_8] > gda_104[li_8 + 1]) {
            g_ibuf_108[li_8] = gda_104[li_8];
            g_ibuf_112[li_8] = 0;
            g_ibuf_116[li_8] = 0;
         } else {
            g_ibuf_112[li_8] = gda_104[li_8];
            g_ibuf_108[li_8] = 0;
            g_ibuf_116[li_8] = 0;
         }
      }
   }
   for (li_8 = 0; li_8 < li_0; li_8++) g_ibuf_120[li_8] = iMAOnArray(gda_104, Bars, SignalSMA, 0, MODE_EMA, li_8);
   double ld_12 = (iMA(NULL, 0, FastEMA, 0, MODE_EMA, PRICE_CLOSE, 1) - iMA(NULL, 0, SlowEMA, 0, MODE_EMA, PRICE_CLOSE, 1)) / Point / 10.0;
   ArrayResize(lda_20, Bars);
   ArraySetAsSeries(lda_20, TRUE);
   ArrayCopy(lda_20, Close, 0, 0, ArraySize(lda_20));
   double ld_24 = (iMAOnArray(lda_20, 0, FastEMA, 0, MODE_EMA, 0) - iMAOnArray(lda_20, 0, SlowEMA, 0, MODE_EMA, 0)) / Point / 10.0;
   if (ld_24 < ld_12) {
      while (ld_24 < ld_12) {
         li_32++;
         lda_20[0] += Point / 0.1;
         ld_24 = (iMAOnArray(lda_20, 0, FastEMA, 0, MODE_EMA, 0) - iMAOnArray(lda_20, 0, SlowEMA, 0, MODE_EMA, 0)) / Point / 10.0;
      }
   } else {
      while (ld_24 > ld_12) {
         li_32--;
         lda_20[0] = lda_20[0] - Point / 0.1;
         ld_24 = (iMAOnArray(lda_20, 0, FastEMA, 0, MODE_EMA, 0) - iMAOnArray(lda_20, 0, SlowEMA, 0, MODE_EMA, 0)) / Point / 10.0;
      }
   }
   //string l_name_36 = WindowExpertName() + "," + Symbol() + "," + Period();
   //if (ObjectFind(l_name_36) < 0) ObjectCreate(l_name_36, OBJ_TEXT, WindowFind(WindowExpertName() + " (" + FastEMA + "," + SlowEMA + "," + SignalSMA + ")"), Time[0] + 60 * Period(), gda_104[0] / 2.0);
   //else ObjectMove(l_name_36, 0, Time[0] + 60 * Period(), gda_104[0] / 2.0);
   //if (li_32 != 0) ObjectSetText(l_name_36, DoubleToStr(li_32, 0), FontSize, "Courier", FontColor);
   //else ObjectSetText(l_name_36, " ", FontSize, "Courier", FontColor);
   return (0);
}