
#property copyright " code adapted to bars by GIO"
#property link      ""

#property indicator_separate_window
#property indicator_minimum 0.0
#property indicator_maximum 5.0
#property indicator_buffers 8
#property indicator_color1 Blue
#property indicator_color2 Blue
#property indicator_color3 Blue
#property indicator_color4 Blue
#property indicator_color5 Red
#property indicator_color6 Red
#property indicator_color7 Red
#property indicator_color8 Red

double g_ibuf_76[];
double g_ibuf_80[];
double g_ibuf_84[];
double g_ibuf_88[];
double g_ibuf_92[];
double g_ibuf_96[];
double g_ibuf_100[];
double g_ibuf_104[];
int gi_108 = 5000;
double gd_112 = 0.016;
double gd_120 = 0.2;
int gi_128 = 4;
int gi_132 = 240;
int gi_136 = 60;
int gi_140 = 30;
int gi_144 = 15;

int init() {
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 108);
   SetIndexBuffer(0, g_ibuf_76);
   SetIndexEmptyValue(0, 0.0);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 108);
   SetIndexBuffer(1, g_ibuf_80);
   SetIndexEmptyValue(1, 0.0);
   SetIndexStyle(2, DRAW_ARROW);
   SetIndexArrow(2, 108);
   SetIndexBuffer(2, g_ibuf_84);
   SetIndexEmptyValue(2, 0.0);
   SetIndexStyle(3, DRAW_ARROW);
   SetIndexArrow(3, 108);
   SetIndexBuffer(3, g_ibuf_88);
   SetIndexEmptyValue(3, 0.0);
   SetIndexStyle(4, DRAW_ARROW);
   SetIndexArrow(4, 108);
   SetIndexBuffer(4, g_ibuf_92);
   SetIndexEmptyValue(4, 0.0);
   SetIndexStyle(5, DRAW_ARROW);
   SetIndexArrow(5, 108);
   SetIndexBuffer(5, g_ibuf_96);
   SetIndexEmptyValue(5, 0.0);
   SetIndexStyle(6, DRAW_ARROW);
   SetIndexArrow(6, 108);
   SetIndexBuffer(6, g_ibuf_100);
   SetIndexEmptyValue(6, 0.0);
   SetIndexStyle(7, DRAW_ARROW);
   SetIndexArrow(7, 108);
   SetIndexBuffer(7, g_ibuf_104);
   SetIndexEmptyValue(7, 0.0);
   IndicatorShortName("Escalda");
   RefreshRates();
   return (0);
}

int deinit() {
   ObjectDelete("Para_Label");
   ObjectDelete("Para_Label1");
   ObjectDelete("Para_Label2");
   ObjectDelete("Para_Label3");
   ObjectDelete("Para_Label4");
   return (0);
}

int start() {
   int l_shift_20;
   if (Year() >= 2100 && Month() >= 8 && Day() >= 1) return (0);
   int l_ind_counted_0 = IndicatorCounted();
   int lia_8[] = {0, 0, 0, 0};
   lia_8[0] = gi_132;
   lia_8[1] = gi_136;
   lia_8[2] = gi_140;
   lia_8[3] = gi_144;
   int li_4 = MathMin(l_ind_counted_0, gi_108);
   if (li_4 == 0) li_4 = gi_108;
   for (int l_index_12 = 0; l_index_12 < li_4; l_index_12++) {
      g_ibuf_76[l_index_12] = 0;
      g_ibuf_80[l_index_12] = 0;
      g_ibuf_84[l_index_12] = 0;
      g_ibuf_88[l_index_12] = 0;
      g_ibuf_92[l_index_12] = 0;
      g_ibuf_96[l_index_12] = 0;
      g_ibuf_100[l_index_12] = 0;
      g_ibuf_104[l_index_12] = 0;
      for (int l_index_16 = 0; l_index_16 < 4; l_index_16++) {
         l_shift_20 = iBarShift(NULL, lia_8[l_index_16], Time[l_index_12]);
         SetIndicator(GetCustomBars(lia_8[l_index_16], l_shift_20), l_index_16, l_index_12);
      }
   }
   return (0);
}

int GetCustomBars(int a_timeframe_0, int ai_4) {
   double l_icustom_8 = iCustom(NULL, a_timeframe_0, "PARA", gd_112, gd_120, gi_128, 0, ai_4);
   double l_icustom_16 = iCustom(NULL, a_timeframe_0, "PARA", gd_112, gd_120, gi_128, 1, ai_4);
   return (l_icustom_8 < l_icustom_16);
}

void SetIndicator(bool ai_0, int ai_4, int ai_8) {
   color l_color_20;
   color l_color_24;
   color l_color_28;
   color l_color_32;
   int li_44;
   if (ai_0) {
      switch (ai_4) {
      case 3:
         g_ibuf_76[ai_8] = ai_4 + 1;
         return;
      case 2:
         g_ibuf_80[ai_8] = ai_4 + 1;
         return;
      case 1:
         g_ibuf_84[ai_8] = ai_4 + 1;
         return;
      case 0:
         g_ibuf_88[ai_8] = ai_4 + 1;
         return;
      }
   }
   switch (ai_4) {
   case 3:
      g_ibuf_92[ai_8] = ai_4 + 1;
      break;
   case 2:
      g_ibuf_96[ai_8] = ai_4 + 1;
      break;
   case 1:
      g_ibuf_100[ai_8] = ai_4 + 1;
      break;
   case 0:
      g_ibuf_104[ai_8] = ai_4 + 1;
   }
   string ls_unused_36 = "";
   if (g_ibuf_88[0] > g_ibuf_104[0]) l_color_20 = Blue;
   if (g_ibuf_104[0] > g_ibuf_88[0]) l_color_20 = Red;
   if (g_ibuf_76[0] > g_ibuf_92[0]) l_color_24 = Blue;
   if (g_ibuf_92[0] > g_ibuf_76[0]) l_color_24 = Red;
   if (g_ibuf_80[0] > g_ibuf_96[0]) l_color_28 = Blue;
   if (g_ibuf_96[0] > g_ibuf_80[0]) l_color_28 = Red;
   if (g_ibuf_84[0] > g_ibuf_100[0]) l_color_32 = Blue;
   if (g_ibuf_100[0] > g_ibuf_84[0]) l_color_32 = Red;
   if (li_44 == 1) ls_unused_36 = "";
   if (li_44 == 0) ls_unused_36 = "";
   ObjectDelete("Para_Label");
   if (ObjectFind("Para_Label") != 0) {
      ObjectCreate("Para_Label", OBJ_TEXT, WindowFind("Escalda"), Time[0], 4.5);
      ObjectSetText("Para_Label", "                    M1", 7, "Tahoma Narrow", l_color_24);
   } else ObjectMove("Para_Label", 0, Time[0], 4.5);
   ObjectDelete("Para_Label1");
   if (ObjectFind("Para_Label1") != 0) {
      ObjectCreate("Para_Label1", OBJ_TEXT, WindowFind("Escalda"), Time[0], 3.5);
      ObjectSetText("Para_Label1", "                    M2", 7, "Tahoma Narrow", l_color_28);
   } else ObjectMove("Para_Label1", 0, Time[0], 3.5);
   ObjectDelete("Para_Label2");
   if (ObjectFind("Para_Label2") != 0) {
      ObjectCreate("Para_Label2", OBJ_TEXT, WindowFind("Escalda"), Time[0], 2.5);
      ObjectSetText("Para_Label2", "                    M3", 7, "Tahoma Narrow", l_color_32);
   } else ObjectMove("Para_Label2", 0, Time[0], 2.5);
   ObjectDelete("Para_Label3");
   if (ObjectFind("Para_Label3") != 0) {
      ObjectCreate("Para_Label3", OBJ_TEXT, WindowFind("Escalda"), Time[0], 1.5);
      ObjectSetText("Para_Label3", "                    M4", 7, "Tahoma Narrow", l_color_20);
      return;
   }
   ObjectMove("Para_Label3", 0, Time[0], 1.5);
}