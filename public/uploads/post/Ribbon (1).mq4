//+------------------------------------------------------------------+
//|                                                                  |
//|                                              Ribbon.mq4 |
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright "Ribbon"
#property link      "esterkin2313@inbox.lv"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 LimeGreen
#property indicator_color2 DarkOrange
#property indicator_color3 DimGray
#property indicator_color4 DimGray

extern string TimeFrame = "current time frame";
extern double Smooth1Period = 12.0;
extern int Smooth1Price = 0;
extern double Smooth1Phase = 0.0;
extern double Smooth2Period = 26.0;
extern int Smooth2Price = 0;
extern double Smooth2Phase = 0.0;
extern bool Interpolate = TRUE;
extern bool alertsOn = TRUE;
extern bool alertsOnCurrent = TRUE;
extern bool alertsMessage = TRUE;
extern bool alertsSound = FALSE;
extern bool alertsEmail = FALSE;
double g_ibuf_148[];
double g_ibuf_152[];
double g_ibuf_156[];
double g_ibuf_160[];
double g_ibuf_164[];
string gs_168;
int g_timeframe_176;
bool g_bool_180;
bool g_bool_184;
string gs_nothing_188 = "nothing";
datetime g_time_196;
double gda_200[][20];
string gsa_204[] = {"M1", "M5", "M15", "M30", "H1", "H4", "D1", "W1", "MN"};
int gia_208[] = {1, 5, 15, 30, 60, 240, 1440, 10080, 43200};

int init() {
   int li_0;
   IndicatorBuffers(5);
   SetIndexBuffer(0, g_ibuf_156);
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexBuffer(1, g_ibuf_160);
   SetIndexStyle(1, DRAW_HISTOGRAM);
   SetIndexBuffer(2, g_ibuf_148);
   SetIndexBuffer(3, g_ibuf_152);
   SetIndexBuffer(4, g_ibuf_164);
   if (Smooth1Period > Smooth2Period) {
      li_0 = Smooth1Period;
      Smooth1Period = Smooth2Period;
      Smooth2Period = li_0;
   }
   gs_168 = WindowExpertName();
   g_bool_184 = TimeFrame == "returnBars";
   if (g_bool_184) return (0);
   g_bool_180 = TimeFrame == "calculateValue";
   if (g_bool_180) return (0);
   g_timeframe_176 = stringToTimeFrame(TimeFrame);
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   int l_shift_12;
   int l_datetime_16;
   double ld_24;
   int li_0 = IndicatorCounted();
   if (li_0 < 0) return (-1);
   if (li_0 > 0) li_0--;
   int li_4 = MathMin(Bars - li_0, Bars - 1);
   if (g_bool_184) {
      g_ibuf_148[0] = li_4 + 1;
      return (0);
   }
   if (g_bool_180 || g_timeframe_176 == Period()) {
      for (int li_8 = li_4; li_8 >= 0; li_8--) {
         g_ibuf_148[li_8] = iSmooth(iMA(NULL, 0, 1, 0, MODE_SMA, Smooth1Price, li_8), Smooth1Period, Smooth1Phase, li_8, 0);
         g_ibuf_152[li_8] = iSmooth(iMA(NULL, 0, 1, 0, MODE_SMA, Smooth2Price, li_8), Smooth2Period, Smooth2Phase, li_8, 10);
         g_ibuf_156[li_8] = g_ibuf_148[li_8];
         g_ibuf_160[li_8] = g_ibuf_152[li_8];
         g_ibuf_164[li_8] = g_ibuf_164[li_8 + 1];
         if (g_ibuf_148[li_8] > g_ibuf_152[li_8]) g_ibuf_164[li_8] = 1;
         if (g_ibuf_148[li_8] < g_ibuf_152[li_8]) g_ibuf_164[li_8] = -1;
      }
      if (!g_bool_180) manageAlerts();
      return (0);
   }
   li_4 = MathMax(li_4, MathMin(Bars - 1, iCustom(NULL, g_timeframe_176, gs_168, "returnBars", 0, 0) * g_timeframe_176 / Period()));
   for (li_8 = li_4; li_8 >= 0; li_8--) {
      l_shift_12 = iBarShift(NULL, g_timeframe_176, Time[li_8]);
      g_ibuf_148[li_8] = iCustom(NULL, g_timeframe_176, gs_168, "calculateValue", Smooth1Period, Smooth1Price, Smooth1Phase, Smooth2Period, Smooth2Price, Smooth2Phase, 0, l_shift_12);
      g_ibuf_152[li_8] = iCustom(NULL, g_timeframe_176, gs_168, "calculateValue", Smooth1Period, Smooth1Price, Smooth1Phase, Smooth2Period, Smooth2Price, Smooth2Phase, 1, l_shift_12);
      g_ibuf_156[li_8] = g_ibuf_148[li_8];
      g_ibuf_160[li_8] = g_ibuf_152[li_8];
      g_ibuf_164[li_8] = g_ibuf_164[li_8 + 1];
      if (g_ibuf_148[li_8] > g_ibuf_152[li_8]) g_ibuf_164[li_8] = 1;
      if (g_ibuf_148[li_8] < g_ibuf_152[li_8]) g_ibuf_164[li_8] = -1;
      if (g_timeframe_176 <= Period() || l_shift_12 == iBarShift(NULL, g_timeframe_176, Time[li_8 - 1])) continue;
      if (Interpolate) {
         l_datetime_16 = iTime(NULL, g_timeframe_176, l_shift_12);
         for (int li_20 = 1; li_8 + li_20 < Bars && Time[li_8 + li_20] >= l_datetime_16; li_20++) {
         }
         ld_24 = 1.0 / li_20;
         for (int li_32 = 1; li_32 < li_20; li_32++) {
            g_ibuf_148[li_8 + li_32] = li_32 * ld_24 * (g_ibuf_148[li_8 + li_20]) + (1.0 - li_32 * ld_24) * g_ibuf_148[li_8];
            g_ibuf_152[li_8 + li_32] = li_32 * ld_24 * (g_ibuf_152[li_8 + li_20]) + (1.0 - li_32 * ld_24) * g_ibuf_152[li_8];
            g_ibuf_156[li_8 + li_32] = g_ibuf_148[li_8 + li_32];
            g_ibuf_160[li_8 + li_32] = g_ibuf_152[li_8 + li_32];
         }
      }
   }
   manageAlerts();
   return (0);
}

void manageAlerts() {
   int li_0;
   if (alertsOn) {
      if (alertsOnCurrent) li_0 = 0;
      else li_0 = 1;
      li_0 = iBarShift(NULL, 0, iTime(NULL, g_timeframe_176, li_0));
      if (g_ibuf_164[li_0] != g_ibuf_164[li_0 + 1]) {
         if (g_ibuf_164[li_0] == 1.0) doAlert(li_0, "up");
         if (g_ibuf_164[li_0] == -1.0) doAlert(li_0, "down");
      }
   }
}

void doAlert(int ai_0, string as_4) {
   string l_str_concat_12;
   if (gs_nothing_188 != as_4 || g_time_196 != Time[ai_0]) {
      gs_nothing_188 = as_4;
      g_time_196 = Time[ai_0];
      l_str_concat_12 = StringConcatenate(Symbol(), " ", timeFrameToString(g_timeframe_176), " at ", TimeToStr(TimeLocal(), TIME_SECONDS), " RaitisJMA smooth " + DoubleToStr(Smooth1Period, 1) +
         " crossed RaitisJMA smooth " + DoubleToStr(Smooth2Period, 1) + " ", as_4);
      if (alertsMessage) Alert(l_str_concat_12);
      if (alertsEmail) SendMail(StringConcatenate(Symbol(), "RaitisJMARibbon "), l_str_concat_12);
      if (alertsSound) PlaySound("alert2.wav");
   }
}

double iSmooth(double ad_0, double ad_8, double ad_16, int ai_24, int ai_28) {
   double ld_84;
   if (ArrayRange(gda_200, 0) != Bars) ArrayResize(gda_200, Bars);
   if (ad_8 <= 1.0) return (ad_0);
   int li_32 = Bars - ai_24 - 1;
   if (li_32 == 0) {
      for (int l_count_36 = 0; l_count_36 < 7; l_count_36++) gda_200[0][l_count_36 + ai_28] = ad_0;
      while (l_count_36 < 10) {
         gda_200[0][l_count_36 + ai_28] = 0;
         l_count_36++;
      }
      return (ad_0);
   }
   double ld_40 = MathMax(MathLog(MathSqrt((ad_8 - 1.0) / 2.0)) / MathLog(2.0) + 2.0, 0);
   double ld_48 = MathMax(ld_40 - 2.0, 0.5);
   double ld_56 = ad_0 - (gda_200[li_32 - 1][ai_28 + 5]);
   double ld_64 = ad_0 - (gda_200[li_32 - 1][ai_28 + 6]);
   double ld_72 = 1.0 / (10.0 * MathMin(MathMax(ad_8 - 10.0, 0), 100) / 100.0 + 10.0);
   int li_80 = MathMin(li_32, 10);
   gda_200[li_32][ai_28 + 7] = 0;
   if (MathAbs(ld_56) > MathAbs(ld_64)) gda_200[li_32][ai_28 + 7] = MathAbs(ld_56);
   if (MathAbs(ld_56) < MathAbs(ld_64)) gda_200[li_32][ai_28 + 7] = MathAbs(ld_64);
   gda_200[li_32][ai_28 + 8] = gda_200[li_32 - 1][ai_28 + 8] + (gda_200[li_32][ai_28 + 7] - (gda_200[li_32 - li_80][ai_28 + 7])) * ld_72;
   gda_200[li_32][ai_28 + 9] = gda_200[li_32 - 1][ai_28 + 9] + 2.0 / (MathMax(4.0 * ad_8, 30) + 1.0) * (gda_200[li_32][ai_28 + 8] - (gda_200[li_32 - 1][ai_28 + 9]));
   if (gda_200[li_32][ai_28 + 9] > 0.0) ld_84 = (gda_200[li_32][ai_28 + 7]) / (gda_200[li_32][ai_28 + 9]);
   else ld_84 = 0;
   if (ld_84 > MathPow(ld_40, 1.0 / ld_48)) ld_84 = MathPow(ld_40, 1.0 / ld_48);
   if (ld_84 < 1.0) ld_84 = 1.0;
   double ld_92 = MathPow(ld_84, ld_48);
   double ld_100 = MathSqrt((ad_8 - 1.0) / 2.0) * ld_40;
   double ld_108 = MathPow(ld_100 / (ld_100 + 1.0), MathSqrt(ld_92));
   if (ld_56 > 0.0) gda_200[li_32][ai_28 + 5] = ad_0;
   else gda_200[li_32][ai_28 + 5] = ad_0 - ld_108 * ld_56;
   if (ld_64 < 0.0) gda_200[li_32][ai_28 + 6] = ad_0;
   else gda_200[li_32][ai_28 + 6] = ad_0 - ld_108 * ld_64;
   double ld_116 = MathMax(MathMin(ad_16, 100), -100) / 100.0 + 1.5;
   double ld_124 = (ad_8 - 1.0) / 2.0 / ((ad_8 - 1.0) / 2.0 + 2.0);
   double ld_132 = MathPow(ld_124, ld_92);
   gda_200[li_32][ai_28 + 0] = ad_0 + ld_132 * (gda_200[li_32 - 1][ai_28 + 0] - ad_0);
   gda_200[li_32][ai_28 + 1] = (ad_0 - (gda_200[li_32][ai_28 + 0])) * (1 - ld_124) + ld_124 * (gda_200[li_32 - 1][ai_28 + 1]);
   gda_200[li_32][ai_28 + 2] = gda_200[li_32][ai_28 + 0] + ld_116 * (gda_200[li_32][ai_28 + 1]);
   gda_200[li_32][ai_28 + 3] = (gda_200[li_32][ai_28 + 2] - (gda_200[li_32 - 1][ai_28 + 4])) * MathPow(1 - ld_132, 2) + MathPow(ld_132, 2) * (gda_200[li_32 - 1][ai_28 +
      3]);
   gda_200[li_32][ai_28 + 4] = gda_200[li_32 - 1][ai_28 + 4] + (gda_200[li_32][ai_28 + 3]);
   return (gda_200[li_32][ai_28 + 4]);
}

int stringToTimeFrame(string as_0) {
   as_0 = StringUpperCase(as_0);
   for (int li_8 = ArraySize(gia_208) - 1; li_8 >= 0; li_8--)
      if (as_0 == gsa_204[li_8] || as_0 == "" + gia_208[li_8]) return (MathMax(gia_208[li_8], Period()));
   return (Period());
}

string timeFrameToString(int ai_0) {
   for (int li_4 = ArraySize(gia_208) - 1; li_4 >= 0; li_4--)
      if (ai_0 == gia_208[li_4]) return (gsa_204[li_4]);
   return ("");
}

string StringUpperCase(string as_0) {
   int li_20;
   string ls_ret_8 = as_0;
   for (int li_16 = StringLen(as_0) - 1; li_16 >= 0; li_16--) {
      li_20 = StringGetChar(ls_ret_8, li_16);
      if ((li_20 > '`' && li_20 < '{') || (li_20 > 'ß' && li_20 < 256)) ls_ret_8 = StringSetChar(ls_ret_8, li_16, li_20 - 32);
      else
         if (li_20 > -33 && li_20 < 0) ls_ret_8 = StringSetChar(ls_ret_8, li_16, li_20 + 224);
   }
   return (ls_ret_8);
}