#property copyright " © TLP 2013"
#property link      "www.google.com"

#property indicator_chart_window

#import "kernel32.dll"
   int GetTimeZoneInformation(int& a0[]);
#import

string Gs_unused_76 = "Ku Klux";
string Gs_unused_84 = "© TLP 2013";
string Gs_unused_92 = "www.google.com";
extern string Level = "=== Level settings ===";
extern int Level_Width = 3;
extern int Text_Font_Size = 9;
extern int Level_Text_Shift = 0;
extern bool Extend_Lines = TRUE;
extern string Daily = "=== Daily settings ===";
extern bool Show_Daily_Open = TRUE;
extern int Number_of_Days = 1;
extern string d1 = "1 = Broker Daily Open";
extern string d2 = "2 = Australia/NZ Open - 5PM Eastern";
extern string d3 = "3 = Tokyo Open - 7PM Eastern";
extern string d4 = "4 = Midnight NY Open - 12AM Eastern";
extern string d5 = "5 = European Open - 2AM Eastern";
extern string d6 = "6 = London Open - 3AM Eastern";
extern string d7 = "7 = New York Open - 8AM Eastern";
extern int Daily_Open_Setting = 1;
extern bool Show_Trend = TRUE;
extern string Clock = "=== Clock settings ===";
extern bool Show_Clock = FALSE;
extern int Clock_Vertical_Position = 50;
extern string sCorner = "=== Corner Display ===";
extern string c0 = " 0 = Upper Left";
extern string c1 = " 1 = Upper right";
extern string c2 = " 2 = Lower Left";
extern string c3 = " 3 = Lower right";
extern int Corner = 0;
extern string Color = "=== Color settings ===";
extern color Level_Text_Color = DimGray;
extern color Daily_Open_Color = White;
extern color Daily_Separator_Color = DimGray;
extern color Clock_Color = Yellow;
extern color Buy_Color = Green;
extern color BT1_Color = LimeGreen;
extern color BT2_Color = CornflowerBlue;
extern color BuySL_Color = Olive;
extern color Sell_Color = Crimson;
extern color ST1_Color = OrangeRed;
extern color ST2_Color = Goldenrod;
extern color SellSL_Color = SaddleBrown;
extern color Up_Trend_Color = CornflowerBlue;
extern color Down_Trend_Color = Red;
extern color Flat_Trend_Color = DimGray;
int Gi_332 = -7;
int Gi_336 = -11;
int Gi_340 = -1;
int Gi_344 = 0;
int Gi_348 = 5;
int Gi_352 = 21;
double Gda_356[22];
double Gda_360[22];
double Gda_364[22];
double Gda_368[22];
double Gda_372[22];
double Gda_376[22];
double Gda_380[22];
double Gda_384[22];
double Gda_388[22];
double Gda_392[22];
double Gda_396[22];
double Gda_400[48];
double Gda_404[48];
double Gda_408[48];
int Gia_412[48];
int Gia_416[48];
int Gi_420 = 22;
int G_datetime_424;
int Gi_428;
int Gi_432;
int Gi_436;
string Gsa_440[] = {"Местное", "Время Брокера", "Нью-йорк", "GMT"};
int Gi_444 = -5;
int Gi_448;
int Gi_452;
int Gi_456;
int G_hour_460;
double Gd_464;
int G_datetime_472;
bool Gi_476 = TRUE;
bool Gi_unused_480 = TRUE;
bool Gi_484 = TRUE;
string G_fontname_488 = "Arial Narrow";
int G_fontsize_496 = 9;
int Gi_500 = 20;
int Gi_504;
bool Gi_508 = FALSE;
string Gs_512 = "Ku Klux_";
string Gs_520 = "CLOCK_";
string Gs_528 = "WARN_";
double Gd_536;
int Gi_544;
int Gi_548;
int Gi_552;
int Gi_556;
int Gi_560;
int G_corner_564;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   f0_27();
   f0_0();
   f0_2();
   f0_19();
   Gi_504 = ArrayRange(Gsa_440, 0);
   Gd_536 = f0_21();
   if (Gd_536 == 0.01) Gi_544 = 2;
   else Gi_544 = 4;
   Gi_436 = Number_of_Days;
   if (Number_of_Days > 22) Gi_436 = 22;
   Gi_unused_480 = TRUE;
   IndicatorShortName("Ku Klux");
   G_corner_564 = Corner;
   if (G_corner_564 > 3) G_corner_564 = 0;
   if (G_corner_564 <= 1) {
      Gi_552 = 15;
      Gi_560 = Gi_552 + Text_Font_Size + 6;
      Gi_556 = Gi_560 + Text_Font_Size + 6;
   } else {
      Gi_556 = 15;
      Gi_560 = Gi_556 + Text_Font_Size + 6;
      Gi_552 = Gi_560 + Text_Font_Size + 6;
   }
   return (0);
}

// 52D46093050F38C27267BCE42543EF60
int deinit() {
   f0_5();
   f0_1();
   f0_2();
   f0_19();
   return (0);
}

// FD4055E1AC0A7D690C66D37B2C70E529
int f0_38(int A_timeframe_0) {
   int Li_4 = 1440 / A_timeframe_0;
   if (Li_4 == 1) return (0);
   int Li_8 = 48 * Li_4 + 5 * Li_4;
   if (iBars(Symbol(), A_timeframe_0) > Li_8) return (1);
   return (0);
}

// 689C35E4872BA754D7230B8ADAA28E48
int f0_17() {
   if (f0_38(Period())) return (1);
   int Li_0 = f0_33(Period());
   if (Li_0 > 240) return (0);
   if (f0_38(Li_0)) return (1);
   Li_0 = f0_33(Li_0);
   if (Li_0 > 240) return (0);
   if (f0_38(Li_0)) return (1);
   Li_0 = f0_33(Li_0);
   if (Li_0 > 240) return (0);
   if (f0_38(Li_0)) return (1);
   Li_0 = f0_33(Li_0);
   if (Li_0 > 240) return (0);
   if (f0_38(Li_0)) return (1);
   Li_0 = f0_33(Li_0);
   if (Li_0 > 240) return (0);
   if (f0_38(Li_0)) return (1);
   return (0);
}

// 6ABA3523C7A75AAEA41CC0DEC7953CC5
int f0_18(int Ai_0) {
   int Li_ret_4 = Ai_0;
   for (int count_8 = 0; count_8 < 7; count_8++) {
      if (f0_38(Li_ret_4)) break;
      Li_ret_4 = f0_33(Li_ret_4);
   }
   return (Li_ret_4);
}

// F4F2EE5CE6F3F7678B6B3F2A5D4685D7
int f0_33(int Ai_0) {
   switch (Ai_0) {
   case 1:
      return (5);
   case 5:
      return (15);
   case 15:
      return (30);
   case 30:
      return (60);
   case 60:
      return (240);
   case 240:
      return (1440);
   }
   return (0);
}

// 945D754CB0DC06D04243FCBA25FC0802
int f0_23() {
   int Li_ret_0;
   int Li_4 = Gi_448 - 2;
   switch (Daily_Open_Setting) {
   case 1:
      Li_ret_0 = 0;
      break;
   case 2:
      Li_ret_0 = 0;
      break;
   case 3:
      Li_ret_0 = 2;
      break;
   case 4:
      Li_ret_0 = 7;
      break;
   case 5:
      Li_ret_0 = 9;
      break;
   case 6:
      Li_ret_0 = 10;
      break;
   case 7:
      Li_ret_0 = 15;
   }
   if (Gi_448 != 100) Li_ret_0 += Li_4;
   if (Li_ret_0 >= 24) Li_ret_0 -= 24;
   if (Li_ret_0 < 0) Li_ret_0 += 24;
   return (Li_ret_0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   if (Period() > PERIOD_H4) return (-1);
   if (!IsDllsAllowed()) {
      f0_15(255);
      Gi_508 = TRUE;
      return (0);
   }
   Gi_448 = f0_25();
   if (Gi_448 == 100) Daily_Open_Setting = TRUE;
   Gd_464 = f0_6();
   Gi_452 = Gd_464;
   Gi_456 = f0_23();
   if (!f0_17()) {
      f0_8(255);
      Gi_508 = TRUE;
      return (0);
   }
   if (f0_24(Gd_464, Gi_448)) {
      f0_34();
      Gi_508 = TRUE;
      return (0);
   }
   if (Gi_508) {
      f0_19();
      Gi_508 = FALSE;
   }
   f0_34();
   return (0);
}

// F590ACE4AD4063CE989827AACE7F7FA6
void f0_34() {
   if (Show_Clock) f0_31(Gi_500, Clock_Vertical_Position);
   WindowRedraw();
   if (f0_32()) f0_12(48);
   for (int count_0 = 0; count_0 < Gi_436; count_0++) f0_30(count_0);
   f0_28();
}

// 2230DA82D7FAFF3EA8CD4CFC92DE64E8
double f0_6() {
   int Lia_0[43];
   switch (GetTimeZoneInformation(Lia_0)) {
   case 0:
      return (0);
   case 1:
      return (Lia_0[0] / (-60.0));
   case 2:
      return ((Lia_0[0] + Lia_0[42]) / (-60.0));
   }
   return (0);
}

// 2FC9212C93C86A99B2C376C96453D3A4
double f0_9() {
   int Li_0 = (TimeCurrent() - TimeLocal()) / 60;
   int Li_4 = MathRound(Li_0 / 30.0);
   Li_0 = 30 * Li_4;
   return (f0_6() + Li_0 / 60.0);
}

// A0F6E6535C856D4495BA899376567E48
int f0_26(double Ad_unused_0, double Ad_unused_8) {
   int Li_ret_16 = TimeLocal() - 3600.0 * f0_6();
   int Li_ret_20 = TimeCurrent() - 3600.0 * f0_9();
   if (Li_ret_16 > Li_ret_20 + 300) return (Li_ret_16);
   return (Li_ret_20);
}

// 9ED55815FB278759298B6BAF50BEC3C8
int f0_24(double Ad_unused_0, double Ad_unused_8) {
   int day_of_week_16 = DayOfWeek();
   if (day_of_week_16 == 0) return (1);
   if (day_of_week_16 == 6) return (1);
   int Li_20 = TimeLocal() - 3600.0 * f0_6();
   int Li_24 = TimeCurrent() - 3600.0 * f0_9();
   if (Li_20 > Li_24 + 300) return (1);
   return (0);
}

// E57BE7F0D51233E12F19376575CE10FF
int f0_32() {
   if (Gi_456 < 23) {
      if (TimeHour(iTime(NULL, 0, 0)) == Gi_456) G_hour_460 = -1;
   } else {
      if (TimeDayOfWeek(G_hour_460) == Gi_348 - 1)
         if (TimeHour(iTime(NULL, 0, 0)) == Gi_352 - 1) G_hour_460 = -1;
   }
   if (Gi_484 || TimeHour(iTime(NULL, 0, 0)) > G_hour_460) {
      Gi_484 = FALSE;
      G_hour_460 = TimeHour(iTime(NULL, 0, 0));
      return (1);
   }
   return (0);
}

// F96D30471D3E10470383B6981C5E7039
void f0_37(int Ai_0) {
   int index_4 = 0;
   for (int Li_8 = 0; Li_8 < Ai_0 * 2; Li_8++) {
      if (TimeDayOfWeek(iTime(NULL, PERIOD_D1, Li_8)) != 0) {
         Gda_404[index_4] = iHigh(NULL, PERIOD_D1, Li_8);
         Gda_408[index_4] = iLow(NULL, PERIOD_D1, Li_8);
         Gda_400[index_4] = iOpen(NULL, PERIOD_D1, Li_8);
         Gia_412[index_4] = iTime(NULL, PERIOD_D1, Li_8);
         Gia_416[index_4] = Time[0];
         if (index_4 > 0) {
            if (TimeDayOfWeek(iTime(NULL, PERIOD_D1, Li_8 - 1)) != 0) Gia_416[index_4] = iTime(NULL, PERIOD_D1, Li_8 - 1);
            else Gia_416[index_4] = iTime(NULL, PERIOD_D1, Li_8 - 2);
         }
         index_4++;
         if (index_4 == Ai_0) break;
      }
   }
}

// C326432F8CFFDF18B9C33D8D42CEBC52
void f0_29(int Ai_0, int A_timeframe_4) {
   int Li_8;
   bool Li_12;
   bool Li_16;
   int count_20 = 0;
   int index_24 = 0;
   int Li_28 = 0;
   while (count_20 < Ai_0 * 2) {
      if (TimeDayOfWeek(iTime(NULL, A_timeframe_4, Li_28)) == 0) count_20++;
      else {
         Gda_404[index_24] = -99999;
         Gda_408[index_24] = 99999;
         if (count_20 > 0) Gia_416[index_24] = Gia_412[index_24 - 1];
         Li_12 = FALSE;
         while (!Li_12) {
            if (TimeHour(iTime(NULL, A_timeframe_4, Li_28)) >= Gi_456) {
               Li_16 = FALSE;
               while (!Li_16) {
                  if (TimeHour(iTime(NULL, A_timeframe_4, Li_28)) < Gi_456) Li_16 = TRUE;
                  else {
                     if (TimeDayOfWeek(iTime(NULL, A_timeframe_4, Li_28)) == 0) Li_28++;
                     else {
                        Gda_404[index_24] = MathMax(iHigh(NULL, A_timeframe_4, Li_28), Gda_404[index_24]);
                        Gda_408[index_24] = MathMin(iLow(NULL, A_timeframe_4, Li_28), Gda_408[index_24]);
                        Li_28++;
                     }
                  }
               }
               Li_12 = TRUE;
            } else {
               Li_16 = FALSE;
               while (!Li_16) {
                  if (TimeHour(iTime(NULL, A_timeframe_4, Li_28)) == 0) Li_16 = TRUE;
                  else {
                     if (TimeDayOfWeek(iTime(NULL, A_timeframe_4, Li_28)) == 0) Li_28++;
                     else {
                        Gda_404[index_24] = MathMax(iHigh(NULL, A_timeframe_4, Li_28), Gda_404[index_24]);
                        Gda_408[index_24] = MathMin(iLow(NULL, A_timeframe_4, Li_28), Gda_408[index_24]);
                        Li_28++;
                     }
                  }
               }
               Li_16 = FALSE;
               while (!Li_16) {
                  if (TimeHour(iTime(NULL, A_timeframe_4, Li_28)) > 0) Li_16 = TRUE;
                  else {
                     if (TimeDayOfWeek(iTime(NULL, A_timeframe_4, Li_28)) == 0) Li_28++;
                     else {
                        Gda_404[index_24] = MathMax(iHigh(NULL, A_timeframe_4, Li_28), Gda_404[index_24]);
                        Gda_408[index_24] = MathMin(iLow(NULL, A_timeframe_4, Li_28), Gda_408[index_24]);
                        Li_28++;
                     }
                  }
               }
               Li_16 = FALSE;
               while (!Li_16) {
                  if (TimeHour(iTime(NULL, A_timeframe_4, Li_28)) < Gi_456) Li_16 = TRUE;
                  else {
                     if (TimeDayOfWeek(iTime(NULL, A_timeframe_4, Li_28)) == 0) Li_28++;
                     else {
                        Gda_404[index_24] = MathMax(iHigh(NULL, A_timeframe_4, Li_28), Gda_404[index_24]);
                        Gda_408[index_24] = MathMin(iLow(NULL, A_timeframe_4, Li_28), Gda_408[index_24]);
                        Li_28++;
                     }
                  }
               }
               Li_12 = TRUE;
            }
         }
         Li_8 = Li_28;
         Li_12 = FALSE;
         while (!Li_12) {
            if (TimeDayOfWeek(iTime(NULL, A_timeframe_4, Li_8 - 1)) == 0) Li_8--;
            else {
               if (Gda_400[index_24] == 0.0) Gda_400[index_24] = iOpen(NULL, A_timeframe_4, Li_8 - 1);
               Gia_412[index_24] = iTime(NULL, A_timeframe_4, Li_8 - 1);
               Li_12 = TRUE;
            }
         }
         index_24++;
         if (index_24 == Ai_0) break;
         count_20++;
      }
   }
}

// 528FD8B404F8774AC78741021D00D737
void f0_12(int Ai_0) {
   int Li_4;
   if (Gi_456 == 0 || Daily_Open_Setting == 1) f0_37(Ai_0);
   else {
      Li_4 = f0_18(Period());
      f0_29(Ai_0, Li_4);
   }
   for (int index_8 = 0; index_8 < 48; index_8++) {
      Gda_404[index_8] = NormalizeDouble(Gda_404[index_8], Gi_544);
      Gda_408[index_8] = NormalizeDouble(Gda_408[index_8], Gi_544);
      Gda_400[index_8] = NormalizeDouble(Gda_400[index_8], Gi_544);
   }
   for (index_8 = 0; index_8 < 22; index_8++) {
      Gda_392[index_8] = f0_13(index_8 + 1);
      Gda_396[index_8] = f0_20(index_8);
   }
}

// AA5EA51BFAC7B64E723BF276E0075513
void f0_28() {
   int Li_0;
   int Li_4;
   f0_5();
   G_datetime_424 = f0_22(Gi_332 - Level_Text_Shift);
   Gi_428 = f0_22(Gi_340 - Level_Text_Shift);
   Gi_432 = f0_22(Gi_336 - Level_Text_Shift);
   for (int index_8 = 0; index_8 < Gi_436; index_8++) {
      Li_0 = Gi_428;
      Li_4 = Gi_432;
      if (index_8 > 0) {
         Li_0 = Gia_412[index_8];
         Li_4 = Gia_416[index_8];
      }
      f0_11(index_8, Li_0, Li_4, Gia_412[index_8], Gia_416[index_8]);
      f0_10(index_8, Gia_412[index_8]);
   }
}

// D1DDCE31F1A86B3140880F6B1877CBF8
void f0_30(int Ai_0) {
   double Ld_4 = Gda_392[Ai_0];
   double Ld_12 = Gda_404[Ai_0 + 1];
   double Ld_20 = Gda_408[Ai_0 + 1];
   double Ld_28 = Ld_12 - Ld_20;
   double Ld_36 = NormalizeDouble(Ld_28 / Gd_536, 0);
   if (Ld_4 >= Ld_36) {
      Gda_356[Ai_0] = Gda_400[Ai_0];
      Gda_360[Ai_0] = f0_3(Gda_356[Ai_0], Ld_28, 1);
      Gda_364[Ai_0] = f0_3(Gda_356[Ai_0], Ld_28, 2);
      Gda_368[Ai_0] = f0_3(Gda_356[Ai_0], Ld_28, 3);
      Gda_372[Ai_0] = Gda_360[Ai_0] - 1.272 * (Gda_360[Ai_0] - Gda_356[Ai_0]);
      Gda_376[Ai_0] = f0_3(Gda_356[Ai_0], Ld_28, 4);
      Gda_380[Ai_0] = f0_3(Gda_356[Ai_0], Ld_28, 5);
      Gda_384[Ai_0] = f0_3(Gda_356[Ai_0], Ld_28, 6);
      Gda_388[Ai_0] = Gda_376[Ai_0] + 1.272 * (Gda_356[Ai_0] - Gda_376[Ai_0]);
   } else {
      if (Ld_4 < Ld_36) {
         Gda_356[Ai_0] = Gda_400[Ai_0];
         Gda_360[Ai_0] = f0_3(Gda_356[Ai_0], Ld_28, 7);
         Gda_364[Ai_0] = f0_3(Gda_356[Ai_0], Ld_28, 8);
         Gda_368[Ai_0] = f0_3(Gda_356[Ai_0], Ld_28, 9);
         Gda_372[Ai_0] = Gda_360[Ai_0] - 1.272 * (Gda_360[Ai_0] - Gda_356[Ai_0]);
         Gda_376[Ai_0] = f0_3(Gda_356[Ai_0], Ld_28, 10);
         Gda_380[Ai_0] = f0_3(Gda_356[Ai_0], Ld_28, 11);
         Gda_384[Ai_0] = f0_3(Gda_356[Ai_0], Ld_28, 12);
         Gda_388[Ai_0] = Gda_376[Ai_0] + 1.272 * (Gda_356[Ai_0] - Gda_376[Ai_0]);
      }
   }
   Gda_360[Ai_0] = NormalizeDouble(Gda_360[Ai_0], Gi_544);
   Gda_364[Ai_0] = NormalizeDouble(Gda_364[Ai_0], Gi_544);
   Gda_368[Ai_0] = NormalizeDouble(Gda_368[Ai_0], Gi_544);
   Gda_372[Ai_0] = NormalizeDouble(Gda_372[Ai_0], Gi_544);
   Gda_376[Ai_0] = NormalizeDouble(Gda_376[Ai_0], Gi_544);
   Gda_380[Ai_0] = NormalizeDouble(Gda_380[Ai_0], Gi_544);
   Gda_384[Ai_0] = NormalizeDouble(Gda_384[Ai_0], Gi_544);
   Gda_388[Ai_0] = NormalizeDouble(Gda_388[Ai_0], Gi_544);
}

// 50257C26C4E5E915F022247BABD914FE
void f0_11(int Ai_0, int Ai_4, int Ai_8, int Ai_12, int Ai_16) {
   bool Li_20;
   bool Li_24;
   Gi_548 = Gda_396[Ai_0];
   if (Show_Trend) {
      if (Gi_548 == 1) f0_36("L3", Gi_560, Period() + "-min: Up Trend", Text_Font_Size, Up_Trend_Color);
      if (Gi_548 == 2) f0_36("L3", Gi_560, Period() + "-min: Down Trend", Text_Font_Size, Down_Trend_Color);
      if (Gi_548 == 3) f0_36("L3", Gi_560, Period() + "-min: Flat Trend", Text_Font_Size, Flat_Trend_Color);
   }
   if (Ai_0 == 0) {
      f0_36("L1", Gi_552, "Ku Klux | TLP", Text_Font_Size, Gray);
      if (Gi_448 == 100) f0_36("L2", Gi_556, "Unknown Broker", Text_Font_Size, Red);
      f0_4("BT2", Gda_368[Ai_0], "BT2 " + DoubleToStr(Gda_368[Ai_0], Gi_544) + "", Text_Font_Size, Level_Text_Color);
      f0_4("BT1", Gda_364[Ai_0], "BT1 " + DoubleToStr(Gda_364[Ai_0], Gi_544) + "", Text_Font_Size, Level_Text_Color);
      f0_4("BEntry", Gda_360[Ai_0], "Buy " + DoubleToStr(Gda_360[Ai_0], Gi_544) + "", Text_Font_Size, Level_Text_Color);
      f0_4("BuySL", Gda_372[Ai_0], "BSL " + DoubleToStr(Gda_372[Ai_0], Gi_544) + "", Text_Font_Size, Level_Text_Color);
      f0_4("SEntry", Gda_376[Ai_0], "Sell " + DoubleToStr(Gda_376[Ai_0], Gi_544) + "", Text_Font_Size, Level_Text_Color);
      f0_4("ST1", Gda_380[Ai_0], "ST1 " + DoubleToStr(Gda_380[Ai_0], Gi_544) + "", Text_Font_Size, Level_Text_Color);
      f0_4("ST2", Gda_384[Ai_0], "ST2 " + DoubleToStr(Gda_384[Ai_0], Gi_544) + "", Text_Font_Size, Level_Text_Color);
      f0_4("SellSL", Gda_388[Ai_0], "SSL " + DoubleToStr(Gda_388[Ai_0], Gi_544) + "", Text_Font_Size, Level_Text_Color);
   }
   if (Show_Daily_Open) {
      if (Ai_0 == 0) f0_14("MDOp" + Ai_0, Ai_4, Gda_356[Ai_0], Ai_8, Gda_356[Ai_0], 1, STYLE_SOLID, Daily_Open_Color);
      else f0_14("MDOp" + Ai_0, Ai_12, Gda_356[Ai_0], Ai_16, Gda_356[Ai_0], 1, STYLE_DASH, Daily_Open_Color);
   }
   if (Ai_0 == 0) {
      Li_20 = Level_Width;
      Li_24 = Gi_344;
   } else {
      Li_20 = TRUE;
      Li_24 = TRUE;
   }
   f0_14("MBEntry" + Ai_0, Ai_4, NormalizeDouble(Gda_360[Ai_0], Gi_544), Ai_8, NormalizeDouble(Gda_360[Ai_0], Gi_544), Li_20, Li_24, Buy_Color);
   f0_14("MBT1" + Ai_0, Ai_4, NormalizeDouble(Gda_364[Ai_0], Gi_544), Ai_8, NormalizeDouble(Gda_364[Ai_0], Gi_544), Li_20, Li_24, BT1_Color);
   f0_14("MBT2" + Ai_0, Ai_4, NormalizeDouble(Gda_368[Ai_0], Gi_544), Ai_8, NormalizeDouble(Gda_368[Ai_0], Gi_544), Li_20, Li_24, BT2_Color);
   f0_14("MBSL" + Ai_0, Ai_4, NormalizeDouble(Gda_372[Ai_0], Gi_544), Ai_8, NormalizeDouble(Gda_372[Ai_0], Gi_544), Li_20, STYLE_SOLID, BuySL_Color);
   f0_14("MSEntry" + Ai_0, Ai_4, NormalizeDouble(Gda_376[Ai_0], Gi_544), Ai_8, NormalizeDouble(Gda_376[Ai_0], Gi_544), Li_20, Li_24, Sell_Color);
   f0_14("MST1" + Ai_0, Ai_4, NormalizeDouble(Gda_380[Ai_0], Gi_544), Ai_8, NormalizeDouble(Gda_380[Ai_0], Gi_544), Li_20, Li_24, ST1_Color);
   f0_14("MST2" + Ai_0, Ai_4, NormalizeDouble(Gda_384[Ai_0], Gi_544), Ai_8, NormalizeDouble(Gda_384[Ai_0], Gi_544), Li_20, Li_24, ST2_Color);
   f0_14("MSL" + Ai_0, Ai_4, NormalizeDouble(Gda_388[Ai_0], Gi_544), Ai_8, NormalizeDouble(Gda_388[Ai_0], Gi_544), Li_20, STYLE_SOLID, SellSL_Color);
   if (Ai_0 == 0) {
      if (Extend_Lines) {
         f0_14("MBEntryLine", Ai_12, NormalizeDouble(Gda_360[Ai_0], Gi_544), Ai_4, NormalizeDouble(Gda_360[Ai_0], Gi_544), 1, STYLE_DASH, Buy_Color);
         f0_14("MBT1Line", Ai_12, NormalizeDouble(Gda_364[Ai_0], Gi_544), Ai_4, NormalizeDouble(Gda_364[Ai_0], Gi_544), 1, STYLE_DASH, BT1_Color);
         f0_14("MBT2Line", Ai_12, NormalizeDouble(Gda_368[Ai_0], Gi_544), Ai_4, NormalizeDouble(Gda_368[Ai_0], Gi_544), 1, STYLE_DASH, BT2_Color);
         f0_14("MBSLLine", Ai_12, NormalizeDouble(Gda_372[Ai_0], Gi_544), Ai_4, NormalizeDouble(Gda_372[Ai_0], Gi_544), 1, STYLE_SOLID, BuySL_Color);
         f0_14("MSEntryLine", Ai_12, NormalizeDouble(Gda_376[Ai_0], Gi_544), Ai_4, NormalizeDouble(Gda_376[Ai_0], Gi_544), 1, STYLE_DASH, Sell_Color);
         f0_14("MST1Line", Ai_12, NormalizeDouble(Gda_380[Ai_0], Gi_544), Ai_4, NormalizeDouble(Gda_380[Ai_0], Gi_544), 1, STYLE_DASH, ST1_Color);
         f0_14("MST2Line", Ai_12, NormalizeDouble(Gda_384[Ai_0], Gi_544), Ai_4, NormalizeDouble(Gda_384[Ai_0], Gi_544), 1, STYLE_DASH, ST2_Color);
         f0_14("MSLLine", Ai_12, NormalizeDouble(Gda_388[Ai_0], Gi_544), Ai_4, NormalizeDouble(Gda_388[Ai_0], Gi_544), 1, STYLE_SOLID, SellSL_Color);
         if (Show_Daily_Open) f0_14("MDOpLine", Ai_12, Gda_356[Ai_0], Ai_4, Gda_356[Ai_0], 1, STYLE_DASH, Daily_Open_Color);
      }
   }
}

// 88CBC5FF77567D51686974367A3E9700
double f0_21() {
   double Ld_ret_0;
   if (StringFind(Symbol(), "JPY") >= 0) Ld_ret_0 = 0.01;
   else Ld_ret_0 = 0.0001;
   return (Ld_ret_0);
}

// 90124A87B1714F1FF8E93A2800BD4144
int f0_22(int Ai_0) {
   if (Ai_0 < 0) return (Time[0] + 60 * Period() * MathAbs(Ai_0));
   return (Time[Ai_0]);
}

// 5710F6E623305B2C1458238C9757193B
double f0_13(int Ai_0) {
   double Ld_4;
   double Ld_12;
   double Ld_20 = 0;
   Ld_20 = 0.0;
   for (int Li_28 = Ai_0; Li_28 < Gi_420 + Ai_0; Li_28++) {
      Ld_12 = Gda_404[Li_28] - Gda_408[Li_28];
      Ld_20 += Ld_12;
   }
   Ld_4 = NormalizeDouble(Ld_20 / Gi_420 / Gd_536, 0);
   return (Ld_4);
}

// 81A4CBF7E575109EFB1104EFB9B5DF39
double f0_20(int Ai_unused_0) {
   int Li_ret_4;
   double ima_8 = iMA(NULL, 0, 3, 0, MODE_EMA, PRICE_CLOSE, 0);
   double ima_16 = iMA(NULL, 0, 10, 0, MODE_EMA, PRICE_CLOSE, 0);
   double ima_24 = iMA(NULL, 0, 26, 0, MODE_EMA, PRICE_CLOSE, 0);
   double ima_32 = iMA(NULL, 0, 47, 0, MODE_EMA, PRICE_CLOSE, 0);
   double Ld_40 = (ima_8 + ima_16) / 2.0;
   double Ld_48 = (ima_24 + ima_32) / 2.0;
   if (MathAbs(Ld_40 - Ld_48) < Ask - Bid) Li_ret_4 = 3;
   else {
      if (Ld_40 < Ld_48) Li_ret_4 = 2;
      else Li_ret_4 = 1;
   }
   return (Li_ret_4);
}

// D362D41CFF235C066CFB390D52F4EB13
void f0_31(int Ai_0, int Ai_4) {
   int Li_8;
   int str_len_12;
   int Li_16;
   int datetime_20;
   string Ls_24;
   string Ls_32;
   int Li_40 = Ai_0;
   int Li_44 = Ai_4;
   G_datetime_472 = f0_26(Gd_464, Gi_448);
   if (Gi_476) Li_16 = 1;
   for (int index_48 = 0; index_48 < Gi_504; index_48++) {
      switch (index_48) {
      case 0:
         datetime_20 = TimeLocal();
         Ls_24 = Gsa_440[index_48] + "  " + TimeToStr(datetime_20, TIME_MINUTES) + " : " + Gi_452;
         break;
      case 1:
         datetime_20 = G_datetime_472 + 3600 * (Gi_448 + Li_16);
         Ls_24 = Gsa_440[index_48] + "  " + TimeToStr(datetime_20, TIME_MINUTES) + " : " + Gi_448;
         break;
      case 2:
         datetime_20 = G_datetime_472 + 3600 * (Gi_444 + Li_16);
         Ls_24 = Gsa_440[index_48] + "  " + TimeToStr(datetime_20, TIME_MINUTES) + " : " + Gi_444;
         break;
      case 3:
         datetime_20 = G_datetime_472;
         Ls_24 = Gsa_440[index_48] + "  " + TimeToStr(datetime_20, TIME_MINUTES);
      }
      f0_16("_" + DoubleToStr(index_48, 0), Ls_24, Black, Li_40, Li_44);
      str_len_12 = StringLen(Ls_24);
      Ls_32 = "_";
      for (int count_56 = 0; count_56 < str_len_12; count_56++) Ls_32 = Ls_32 + "_";
      if (Gsa_440[index_48] == "GMT") Ls_32 = Ls_32 + "_";
      Li_8 = Li_44;
      for (count_56 = 0; count_56 < G_fontsize_496 + 4; count_56++) {
         f0_35("_" + DoubleToStr(index_48, 0) + "_" + DoubleToStr(count_56, 0), Li_40 - 5, Li_8, Ls_32, Clock_Color);
         Li_8--;
      }
      Li_44 = Li_44 + G_fontsize_496 / 2 + 15;
   }
}

// F7B1F0AA13347699EFAE0D924298CB02
void f0_35(string As_0, int A_x_8, int A_y_12, string A_text_16, color A_color_24) {
   string name_28 = Gs_520 + Symbol() + As_0;
   if (ObjectFind(name_28) == -1) {
      ObjectCreate(name_28, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name_28, OBJPROP_BACK, TRUE);
   }
   ObjectSet(name_28, OBJPROP_XDISTANCE, A_x_8);
   ObjectSet(name_28, OBJPROP_YDISTANCE, A_y_12);
   ObjectSetText(name_28, A_text_16, G_fontsize_496, G_fontname_488, A_color_24);
}

// 667DC3F4F5B9C0B70229F573988AC7C0
void f0_16(string As_0, string A_text_8, color A_color_16, int A_x_20, int A_y_24) {
   string name_28 = Gs_520 + Symbol() + As_0;
   if (ObjectFind(name_28) == -1) ObjectCreate(name_28, OBJ_LABEL, 0, 0, 0);
   ObjectSet(name_28, OBJPROP_XDISTANCE, A_x_20);
   ObjectSet(name_28, OBJPROP_YDISTANCE, A_y_24);
   ObjectSetText(name_28, A_text_8, G_fontsize_496, G_fontname_488, A_color_16);
}

// 0B26898E7D2CBB01295E320263028F2C
void f0_2() {
   string name_0;
   int Li_8 = ObjectsTotal();
   for (int objs_total_12 = Li_8; objs_total_12 >= 0; objs_total_12--) {
      name_0 = ObjectName(objs_total_12);
      if (StringFind(name_0, Gs_520) > -1) ObjectDelete(name_0);
   }
}

// 78BAA8FAE18F93570467778F2E829047
void f0_19() {
   string name_0;
   int Li_8 = ObjectsTotal();
   if (Li_8 > 0) {
      for (int objs_total_12 = Li_8; objs_total_12 >= 0; objs_total_12--) {
         name_0 = ObjectName(objs_total_12);
         if (StringFind(name_0, Gs_528, 0) >= 0) ObjectDelete(name_0);
      }
   }
}

// 2569208C5E61CB15E209FFE323DB48B7
void f0_7(string A_name_0, int A_x_8, int A_y_12, int A_corner_16, int A_fontsize_20, color A_color_24, string A_text_28) {
   if (ObjectFind(A_name_0) != 0) {
      ObjectCreate(A_name_0, OBJ_LABEL, 0, 0, 0);
      ObjectSet(A_name_0, OBJPROP_CORNER, A_corner_16);
      ObjectSet(A_name_0, OBJPROP_XDISTANCE, A_x_8);
      ObjectSet(A_name_0, OBJPROP_YDISTANCE, A_y_12);
   }
   ObjectSetText(A_name_0, A_text_28, A_fontsize_20, "Verdana", A_color_24);
}

// 632A6309D71E99A017FD9D3CE1A19C24
void f0_15(int Ai_0) {
   f0_7(Gs_528 + Symbol() + "_warn1", 50, 50, 0, Text_Font_Size, Ai_0, "DLL is not allowed. Go to top menu bar.");
   f0_7(Gs_528 + Symbol() + "_warn2", 50, Text_Font_Size * 2 + 50 + 4, 0, Text_Font_Size, Ai_0, "Select Tools. Select Options.");
   f0_7(Gs_528 + Symbol() + "_warn3", 50, Text_Font_Size * 4 + 50 + 8, 0, Text_Font_Size, Ai_0, "Under Expert Advisor tab, check Allow DLL imports.");
   f0_7(Gs_528 + Symbol() + "_warn4", 50, Text_Font_Size * 4 + 50 + 28, 0, Text_Font_Size, Ai_0, "Close and re-open MT4 platform.");
}

// 28EFB830D150E70A8BB0F12BAC76EF35
void f0_8(int Ai_0) {
   f0_7(Gs_528 + Symbol() + "_warn5", 50, 50, 0, Text_Font_Size, Ai_0, "Not enough bars in chart or higher timeframe. Turn off AutoScroll.");
   f0_7(Gs_528 + Symbol() + "_warn6", 50, Text_Font_Size * 2 + 50 + 4, 0, Text_Font_Size, Ai_0, "Press Page Up Key repeatedly until this message disappears.");
   f0_7(Gs_528 + Symbol() + "_warn7", 50, Text_Font_Size * 4 + 50 + 8, 0, Text_Font_Size, Ai_0, "Then press the End Key and the DOTS levels should appear.");
   f0_7(Gs_528 + Symbol() + "_warn8", 50, Text_Font_Size * 4 + 50 + 28, 0, Text_Font_Size, Ai_0, "If not, close and re-open chart. Re-apply DOTS to chart.");
}

// A9B24A824F70CC1232D1C2BA27039E8D
void f0_27() {
   string name_0;
   int Li_8 = ObjectsTotal();
   if (Li_8 > 0) {
      for (int objs_total_12 = Li_8; objs_total_12 >= 0; objs_total_12--) {
         name_0 = ObjectName(objs_total_12);
         if (StringFind(name_0, Gs_520, 0) >= 0)
            if (StringFind(name_0, Symbol(), 0) < 0) ObjectDelete(name_0);
      }
   }
}

// 3180D254E1C24E987439E4F62708F6A2
void f0_10(int Ai_0, int A_datetime_4) {
   string name_8 = Gs_512 + Symbol() + "_Day" + Ai_0;
   ObjectDelete(name_8);
   ObjectCreate(name_8, OBJ_VLINE, 0, A_datetime_4, Bid);
   ObjectSet(name_8, OBJPROP_COLOR, Daily_Separator_Color);
   ObjectSet(name_8, OBJPROP_WIDTH, 1);
   ObjectSet(name_8, OBJPROP_STYLE, STYLE_SOLID);
}

// 58B0897F29A3AD862616D6CBF39536ED
void f0_14(string As_0, int A_datetime_8, double A_price_12, int A_datetime_20, double A_price_24, double A_width_32, double A_style_40, color A_color_48) {
   string name_52 = Gs_512 + Symbol() + "_" + As_0;
   ObjectCreate(name_52, OBJ_TREND, 0, A_datetime_8, A_price_12, A_datetime_20, A_price_24);
   ObjectSet(name_52, OBJPROP_COLOR, A_color_48);
   ObjectSet(name_52, OBJPROP_RAY, FALSE);
   ObjectSet(name_52, OBJPROP_WIDTH, A_width_32);
   ObjectSet(name_52, OBJPROP_STYLE, A_style_40);
}

// 19821383AADC0BD1EE56BF2194EC478F
void f0_5() {
   string Ls_0 = Gs_512 + Symbol() + "_";
   for (int count_8 = 0; count_8 < 5; count_8++) {
      ObjectDelete(Ls_0 + "MDOp" + count_8);
      ObjectDelete(Ls_0 + "MBEntry" + count_8);
      ObjectDelete(Ls_0 + "MBT1" + count_8);
      ObjectDelete(Ls_0 + "MBT2" + count_8);
      ObjectDelete(Ls_0 + "MBSL" + count_8);
      ObjectDelete(Ls_0 + "MSEntry" + count_8);
      ObjectDelete(Ls_0 + "MST1" + count_8);
      ObjectDelete(Ls_0 + "MST2" + count_8);
      ObjectDelete(Ls_0 + "MSL" + count_8);
   }
   ObjectDelete(Ls_0 + "MDOpLine");
   ObjectDelete(Ls_0 + "MBEntryLine");
   ObjectDelete(Ls_0 + "MBT1Line");
   ObjectDelete(Ls_0 + "MBT2Line");
   ObjectDelete(Ls_0 + "MBSLLine");
   ObjectDelete(Ls_0 + "MSEntryLine");
   ObjectDelete(Ls_0 + "MST1Line");
   ObjectDelete(Ls_0 + "MST2Line");
   ObjectDelete(Ls_0 + "MSLLine");
}

// 184916985BFD167AE4E08C739AF60F52
void f0_4(string As_0, double A_price_8, string A_text_16, int A_fontsize_24, color A_color_28) {
   string Ls_32 = Gs_512 + Symbol() + "_";
   ObjectDelete(Ls_32 + As_0);
   if (ObjectFind(Ls_32 + As_0) != 0) {
      ObjectCreate(Ls_32 + As_0, OBJ_TEXT, 0, G_datetime_424, A_price_8);
      ObjectSetText(Ls_32 + As_0, A_text_16, A_fontsize_24, "Tahoma", A_color_28);
      return;
   }
   ObjectMove(Ls_32 + As_0, 0, G_datetime_424, A_price_8);
}

// F8058EB0D24E6949E44CCCFC53A38CBD
void f0_36(string As_0, int A_y_8, string A_text_12, int A_fontsize_20, color A_color_24) {
   string Ls_28 = Gs_512 + Symbol() + "_";
   ObjectDelete(Ls_28 + As_0);
   if (ObjectFind(Ls_28 + As_0) != 0) {
      ObjectCreate(Ls_28 + As_0, OBJ_LABEL, 0, 0, 0);
      ObjectSet(Ls_28 + As_0, OBJPROP_CORNER, G_corner_564);
      ObjectSet(Ls_28 + As_0, OBJPROP_YDISTANCE, A_y_8);
      ObjectSet(Ls_28 + As_0, OBJPROP_XDISTANCE, 10);
   }
   ObjectSetText(Ls_28 + As_0, A_text_12, A_fontsize_20, "Tahoma", A_color_24);
   WindowRedraw();
}

// 07726B7CD4E14568E00388C5E27E3F10
void f0_0() {
   string name_0;
   int Li_8 = ObjectsTotal();
   if (Li_8 > 0) {
      for (int objs_total_12 = Li_8; objs_total_12 >= 0; objs_total_12--) {
         name_0 = ObjectName(objs_total_12);
         if (StringFind(name_0, Gs_512, 0) >= 0)
            if (StringFind(name_0, Symbol(), 0) < 0) ObjectDelete(name_0);
      }
   }
}

// 09CBB5F5CE12C31A043D5C81BF20AA4A
void f0_1() {
   string name_0;
   int Li_8 = ObjectsTotal();
   for (int objs_total_12 = Li_8; objs_total_12 >= 0; objs_total_12--) {
      name_0 = ObjectName(objs_total_12);
      if (StringFind(name_0, Gs_512) > -1) ObjectDelete(name_0);
   }
}

// 9FDC179C742334D485A77A8B241EC55C
int f0_25() {
   string Ls_0 = AccountServer();
   if (StringFind(Ls_0, "Forexoma") >= 0) return (0);
   string Ls_8 = TerminalCompany();
   if (StringFind(Ls_8, "AAA") >= 0) return (2);
   if (StringFind(Ls_8, "ACM") >= 0) return (1);
   if (StringFind(Ls_8, "ActivTrade") >= 0) return (0);
   if (StringFind(Ls_8, "Admiral Markets") >= 0) return (2);
   if (StringFind(Ls_8, "AForex") >= 0) return (2);
   if (StringFind(Ls_8, "AFX") >= 0) return (2);
   if (StringFind(Ls_8, "AGEA") >= 0) return (2);
   if (StringFind(Ls_8, "Aksys") >= 0) return (-1);
   if (StringFind(Ls_8, "Alfa-Forex") >= 0) return (2);
   if (StringFind(Ls_8, "Alpari") >= 0) return (2);
   if (StringFind(Ls_8, "AFB") >= 0) return (2);
   if (StringFind(Ls_8, "Arab Financial") >= 0) return (2);
   if (StringFind(Ls_8, "Armada") >= 0) return (2);
   if (StringFind(Ls_8, "Arrowfield") >= 0) return (2);
   if (StringFind(Ls_8, "ATC") >= 0) return (2);
   if (StringFind(Ls_8, "Avail Trading") >= 0) return (2);
   if (StringFind(Ls_8, "Ava Financial") >= 0) return (-1);
   if (StringFind(Ls_8, "AxiCorp") >= 0) return (2);
   if (StringFind(Ls_8, "Capital Markets Access") >= 0) return (0);
   if (StringFind(Ls_8, "Citi FX") >= 0) return (-1);
   if (StringFind(Ls_8, "CMAP") >= 0) return (0);
   if (StringFind(Ls_8, "Collective") >= 0) return (0);
   if (StringFind(Ls_8, "Connoisseur") >= 0) return (0);
   if (StringFind(Ls_8, "Direct FX") >= 0) return (2);
   if (StringFind(Ls_8, "Divisa") >= 0) return (-1);
   if (StringFind(Ls_8, "Dunboyne") >= 0) return (0);
   if (StringFind(Ls_8, "Easy Forex") >= 0) return (0);
   if (StringFind(Ls_8, "Ethos") >= 0) return (2);
   if (StringFind(Ls_8, "Exness") >= 0) return (2);
   if (StringFind(Ls_8, "Fair Trading") >= 0) return (0);
   if (StringFind(Ls_8, "FBS") >= 0) return (2);
   if (StringFind(Ls_8, "FGH") >= 0) return (2);
   if (StringFind(Ls_8, "Fibo Group") >= 0) return (2);
   if (StringFind(Ls_8, "Fienex") >= 0) return (0);
   if (StringFind(Ls_8, "Finam") >= 0) return (2);
   if (StringFind(Ls_8, "FINAM") >= 0) return (2);
   if (StringFind(Ls_8, "FinFx") >= 0) return (-1);
   if (StringFind(Ls_8, "First Prudential") >= 0) return (2);
   if (StringFind(Ls_8, "FOREX.com") >= 0) return (-1);
   if (StringFind(Ls_8, "Forex.com") >= 0) return (-1);
   if (StringFind(Ls_8, "Forex Capital Markets") >= 0) return (-1);
   if (StringFind(Ls_8, "Forex Financial Services") >= 0) return (-1);
   if (StringFind(Ls_8, "Forex FS") >= 0) return (-1);
   if (StringFind(Ls_8, "FOREX Ltd") >= 0) return (-1);
   if (StringFind(Ls_8, "Forex Metal") >= 0) return (0);
   if (StringFind(Ls_8, "Forex-Metal") >= 0) return (0);
   if (StringFind(Ls_8, "Forexoma") >= 0) return (0);
   if (StringFind(Ls_8, "Forex Place") >= 0) return (2);
   if (StringFind(Ls_8, "ForexTime") >= 0) return (0);
   if (StringFind(Ls_8, "Forex Time") >= 0) return (0);
   if (StringFind(Ls_8, "ForexYard") >= 0) return (-1);
   if (StringFind(Ls_8, "Forexyard") >= 0) return (-1);
   if (StringFind(Ls_8, "FXCBS") >= 0) return (0);
   if (StringFind(Ls_8, "FX Central") >= 0) return (0);
   if (StringFind(Ls_8, "FXCC") >= 0) return (0);
   if (StringFind(Ls_8, "FX Choice") >= 0) return (2);
   if (StringFind(Ls_8, "FX Clearing") >= 0) return (0);
   if (StringFind(Ls_8, "FXDD") >= 0) return (2);
   if (StringFind(Ls_8, "FXDD Malta") >= 0) return (2);
   if (StringFind(Ls_8, "FXOpen") >= 0) return (2);
   if (StringFind(Ls_8, "FXPRIMUS") >= 0) return (2);
   if (StringFind(Ls_8, "FXPRO") >= 0) return (2);
   if (StringFind(Ls_8, "FXSALT") >= 0) return (-1);
   if (StringFind(Ls_8, "FX Solutions") >= 0) return (-5);
   if (StringFind(Ls_8, "FX Systems") >= 0) return (-1);
   if (StringFind(Ls_8, "FXTM") >= 0) return (-1);
   if (StringFind(Ls_8, "FXVV") >= 0) return (2);
   if (StringFind(Ls_8, "Gallant") >= 0) return (2);
   if (StringFind(Ls_8, "GCM") >= 0) return (2);
   if (StringFind(Ls_8, "GAIN Capital") >= 0) return (-1);
   if (StringFind(Ls_8, "GCI Financial") >= 0) return (-5);
   if (StringFind(Ls_8, "GFT") >= 0) return (-1);
   if (StringFind(Ls_8, "GKFX") >= 0) return (1);
   if (StringFind(Ls_8, "Global Brokers") >= 0) return (2);
   if (StringFind(Ls_8, "Global Prime") >= 0) return (-1);
   if (StringFind(Ls_8, "Go Markets") >= 0) return (2);
   if (StringFind(Ls_8, "GTL") >= 0) return (2);
   if (StringFind(Ls_8, "Hantec") >= 0) return (0);
   if (StringFind(Ls_8, "HF Markets") >= 0) return (2);
   if (StringFind(Ls_8, "HotForex") >= 0) return (2);
   if (StringFind(Ls_8, "IamFX") >= 0) return (-1);
   if (StringFind(Ls_8, "IBFX") >= 0) return (-1);
   if (StringFind(Ls_8, "InterbankFX") >= 0) return (-1);
   if (StringFind(Ls_8, "Interbank FX") >= 0) return (-1);
   if (StringFind(Ls_8, "IC Markets") >= 0) return (0);
   if (StringFind(Ls_8, "IFCM") >= 0) return (0);
   if (StringFind(Ls_8, "IKO") >= 0) return (0);
   if (StringFind(Ls_8, "International Capital") >= 0) return (0);
   if (StringFind(Ls_8, "Institutional Liquidity") >= 0) return (2);
   if (StringFind(Ls_8, "InstaForex") >= 0) return (2);
   if (StringFind(Ls_8, "InvestTech") >= 0) return (0);
   if (StringFind(Ls_8, "IronFX") >= 0) return (2);
   if (StringFind(Ls_8, "I Securities") >= 0) return (0);
   if (StringFind(Ls_8, "iTrade") >= 0) return (-5);
   if (StringFind(Ls_8, "KT Financial") >= 0) return (-3);
   if (StringFind(Ls_8, "LiteForex") >= 0) return (2);
   if (StringFind(Ls_8, "LMAX") >= 0) return (0);
   if (StringFind(Ls_8, "LQD") >= 0) return (4);
   if (StringFind(Ls_8, "Maxprocapital") >= 0) return (2);
   if (StringFind(Ls_8, "MAX PROCAPITAL") >= 0) return (2);
   if (StringFind(Ls_8, "M.H. Value") >= 0) return (2);
   if (StringFind(Ls_8, "MPCL") >= 0) return (2);
   if (StringFind(Ls_8, "MB Trading") >= 0) return (-5);
   if (StringFind(Ls_8, "MetaQuotes") >= 0) return (-5);
   if (StringFind(Ls_8, "MIC") >= 0) return (2);
   if (StringFind(Ls_8, "MIG Bank") >= 0) return (1);
   if (StringFind(Ls_8, "Nord") >= 0) return (2);
   if (StringFind(Ls_8, "OANDA") >= 0) return (-5);
   if (StringFind(Ls_8, "Online Capital") >= 0) return (2);
   if (StringFind(Ls_8, "OCM") >= 0) return (2);
   if (StringFind(Ls_8, "Octa") >= 0) return (0);
   if (StringFind(Ls_8, "One Vector") >= 0) return (2);
   if (StringFind(Ls_8, "PaxForex") >= 0) return (0);
   if (StringFind(Ls_8, "Paxinvest") >= 0) return (0);
   if (StringFind(Ls_8, "Pellucid") >= 0) return (2);
   if (StringFind(Ls_8, "Pepperstone") >= 0) return (2);
   if (StringFind(Ls_8, "Premier Interchange") >= 0) return (2);
   if (StringFind(Ls_8, "PrimeXM") >= 0) return (0);
   if (StringFind(Ls_8, "Profiforex") >= 0) return (2);
   if (StringFind(Ls_8, "Quadra") >= 0) return (0);
   if (StringFind(Ls_8, "Questrade") >= 0) return (-1);
   if (StringFind(Ls_8, "RoboForex") >= 0) return (2);
   if (StringFind(Ls_8, "RPD FX") >= 0) return (2);
   if (StringFind(Ls_8, "RVD") >= 0) return (0);
   if (StringFind(Ls_8, "SafeCap") >= 0) return (0);
   if (StringFind(Ls_8, "Sisma") >= 0) return (0);
   if (StringFind(Ls_8, "Skopalino") >= 0) return (2);
   if (StringFind(Ls_8, "Smart Live") >= 0) return (1);
   if (StringFind(Ls_8, "SmartTrade") >= 0) return (2);
   if (StringFind(Ls_8, "Star Financial") >= 0) return (2);
   if (StringFind(Ls_8, "Straighthold") >= 0) return (2);
   if (StringFind(Ls_8, "Sunbird") >= 0) return (2);
   if (StringFind(Ls_8, "Swissquote") >= 0) return (1);
   if (StringFind(Ls_8, "Synergy Financial") >= 0) return (2);
   if (StringFind(Ls_8, "Tadawulfx") >= 0) return (0);
   if (StringFind(Ls_8, "TF Global Markets") >= 0) return (2);
   if (StringFind(Ls_8, "ThinkForex") >= 0) return (2);
   if (StringFind(Ls_8, "Think Forex") >= 0) return (2);
   if (StringFind(Ls_8, "Tradaxa") >= 0) return (0);
   if (StringFind(Ls_8, "TradeFort") >= 0) return (2);
   if (StringFind(Ls_8, "Trading Forex") >= 0) return (2);
   if (StringFind(Ls_8, "TradingForext") >= 0) return (2);
   if (StringFind(Ls_8, "Trading Point") >= 0) return (2);
   if (StringFind(Ls_8, "Triple A") >= 0) return (2);
   if (StringFind(Ls_8, "TradersWay") >= 0) return (2);
   if (StringFind(Ls_8, "TW Corp") >= 0) return (2);
   if (StringFind(Ls_8, "United World") >= 0) return (2);
   if (StringFind(Ls_8, "UPME") >= 0) return (0);
   if (StringFind(Ls_8, "VantageFX") >= 0) return (2);
   if (StringFind(Ls_8, "Varchev") >= 0) return (2);
   if (StringFind(Ls_8, "WealthTrade") >= 0) return (-1);
   if (StringFind(Ls_8, "Wealth") >= 0) return (-1);
   if (StringFind(Ls_8, "WHOTRADES") >= 0) return (2);
   if (StringFind(Ls_8, "Windsor") >= 0) return (2);
   if (StringFind(Ls_8, "World Pro") >= 0) return (0);
   if (StringFind(Ls_8, "WorldWide") >= 0) return (-1);
   if (StringFind(Ls_8, "WWM") >= 0) return (-1);
   if (StringFind(Ls_8, "YouTrade") >= 0) return (4);
   if (StringFind(Ls_8, "You Trade") >= 0) return (4);
   if (StringFind(Ls_8, "XForex") >= 0) return (2);
   return (100);
}

// 16492E70E4F8C469899EED01A932AFEF
double f0_3(double Ad_0, double Ad_8, int Ai_16) {
   double Ld_ret_20 = 0.0;
   switch (Ai_16) {
   case 1:
      Ld_ret_20 = Ad_8 / 4.0 + Ad_0;
      break;
   case 2:
      Ld_ret_20 = Ad_8 / 2.0 + Ad_0;
      break;
   case 3:
      Ld_ret_20 = 0.7 * Ad_8 + Ad_0;
      break;
   case 4:
      Ld_ret_20 = Ad_0 - Ad_8 / 4.0;
      break;
   case 5:
      Ld_ret_20 = Ad_0 - Ad_8 / 2.0;
      break;
   case 6:
      Ld_ret_20 = Ad_0 - 0.7 * Ad_8;
      break;
   case 7:
      Ld_ret_20 = 0.12 * Ad_8 + Ad_0;
      break;
   case 8:
      Ld_ret_20 = Ad_8 / 4.0 + Ad_0;
      break;
   case 9:
      Ld_ret_20 = 0.33 * Ad_8 + Ad_0;
      break;
   case 10:
      Ld_ret_20 = Ad_0 - 0.12 * Ad_8;
      break;
   case 11:
      Ld_ret_20 = Ad_0 - Ad_8 / 4.0;
      break;
   case 12:
      Ld_ret_20 = Ad_0 - 0.33 * Ad_8;
      break;
   case 0:
      return (Ld_ret_20);
   }
   return (Ld_ret_20);
}
