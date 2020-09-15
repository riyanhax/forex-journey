
//+------------------------------------------------------------------+
//|                                          SimplexEURGBP.mq4       |
//|                               Copyright © 2009, Simplexnet       |
//|                                      http://simplex-ea.com       |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Simplexnet"
#property link      "http://simplex-ea.com"

string Expert_Name = "simplex";
bool CloseAll_NOW = FALSE;
double TargetEquity = 50000000.0;
extern string t1="Начало работы советника";
extern int OpenHour = 20;
extern string t2="Окончание работы советника";
extern int CloseHour = 4;
extern string t3="Использовать ограничение по времени";
extern bool Time_Opened_Protection = TRUE;
extern string t4="Использовать ММ";
extern bool LotsOptimized = TRUE;
int Risk = 200;
extern string t5="Мин. лот";
extern double Lots = 0.1;
extern string t6="Макс. лот";
extern double MaxLots = 100.0;
extern string t7="Тейк Профит";
extern int TP = 5;
extern string t8="Стоп Лосс";
extern int SLA = 22;
int SLB = 32;
int Range_OP = 5;
extern string t9="Проскальзывание";
extern int Slippage = 3;
extern string t10="Максимальный спред";
extern double MaxSpread = 3.0;
int OPFromFractal = 7;
bool Hidden_TP = TRUE;
bool Hidden_SL = TRUE;
extern string t11="Максимальное кол-во ордеров";
extern int MaxTrades = 4;
int MaxTradePerBar = 1;
int MaxTradePerPosition = 3;
int IMA_PERIOD = 11;
int MA_AngleZero_PERIOD = 34;
int LimitTime_1 = 60;
int LimitTime_2 = 140;
int LimitTime_3 = 170;
int LimitTime_4 = 200;
int LimitTime_5 = 240;
int pips_1 = 3;
int pips_2 = 2;
int pips_3 = 0;
int pips_4 = 1;
int pips_5 = 4;
int g_count_272 = 0;
double g_ord_open_price_276 = 0.0;
double g_ord_open_price_284 = 0.0;
int gi_292 = 55;
int g_magic_296 = 777;
int g_bars_300 = -1;
bool gi_unused_304 = TRUE;
bool gi_unused_308 = TRUE;
double g_ifractals_312;
double g_ifractals_320;
double gd_unused_328;
double gd_unused_336;
double g_ifractals_384;
double g_ifractals_392;
double gd_unused_400;
double gd_unused_408;
int gi_416 = 0;
int gi_unused_420 = 0;
int gi_unused_424 = 0;
double gd_428 = 0.0;
double gd_unused_436 = 0.0;
double gd_unused_444 = 0.0;
int gi_unused_452;
int gi_468;
int gi_472;
double gd_492;

int init() {
   gd_492 = SetPoint();
   return (0);
}

int start() {
   double ld_0 = NormalizeDouble(MarketInfo(Symbol(), MODE_LOTSTEP), 2);
   if (ld_0 == 0.01) gi_472 = 2;
   else {
      if (ld_0 == 0.1) gi_472 = 1;
      else gi_472 = 0;
   }
   gi_468 = gi_472;
   if (CloseAll_NOW == TRUE) {
      CloseAll();
      return (0);
   }
   if (TargetEquity > 0.0 && AccountEquity() >= TargetEquity) {
      ForceCloseAll();
      return (0);
   }
   int l_count_8 = 0;
   int l_count_12 = 0;
   int l_count_16 = 0;
   int l_ticket_20 = -1;
   int l_pos_24 = 0;
   for (l_pos_24 = 0; l_pos_24 < OrdersTotal(); l_pos_24++) {
      OrderSelect(l_pos_24, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_296 && OrderCloseTime() == 0) {
         l_count_16++;
         if (OrderType() == OP_BUY) {
            l_count_8++;
            g_ord_open_price_276 = OrderOpenPrice();
         }
         if (OrderType() == OP_SELL) {
            l_count_12++;
            g_ord_open_price_284 = OrderOpenPrice();
         }
      }
   }
   for (int li_28 = 1; li_28 < Bars; li_28++) {
      if (iFractals(NULL, PERIOD_M15, MODE_UPPER, li_28) != 0.0) {
         g_ifractals_312 = iFractals(NULL, PERIOD_M15, MODE_UPPER, li_28);
         gd_unused_336 = Time[li_28];
         break;
      }
   }
   for (int li_32 = 1; li_32 < Bars; li_32++) {
      if (iFractals(NULL, PERIOD_M15, MODE_LOWER, li_32) != 0.0) {
         g_ifractals_320 = iFractals(NULL, PERIOD_M15, MODE_LOWER, li_32);
         gd_unused_328 = Time[li_32];
         break;
      }
   }
   for (int li_36 = 1; li_36 < Bars; li_36++) {
      if (iFractals(NULL, PERIOD_H1, MODE_UPPER, li_36) != 0.0) {
         g_ifractals_384 = iFractals(NULL, PERIOD_H1, MODE_UPPER, li_36);
         gd_unused_408 = Time[li_36];
         break;
      }
   }
   for (int li_40 = 1; li_40 < Bars; li_40++) {
      if (iFractals(NULL, PERIOD_H1, MODE_LOWER, li_40) != 0.0) {
         g_ifractals_392 = iFractals(NULL, PERIOD_H1, MODE_LOWER, li_40);
         gd_unused_400 = Time[li_32];
         break;
      }
   }
   gi_416 = MathRound((g_ifractals_312 - g_ifractals_320) / gd_492);
   gi_unused_420 = MathRound((g_ifractals_384 - g_ifractals_392) / gd_492);
   gd_428 = 0;
   gd_428 = g_ifractals_312 - (g_ifractals_312 - g_ifractals_320) / 2.0;
   gi_unused_452 = MathRound(iATR(Symbol(), PERIOD_M15, 4, 0) / gd_492);
   bool li_44 = FALSE;
   if (Close[0] <= g_ifractals_384 && Close[0] >= g_ifractals_392) li_44 = TRUE;
   if (IsTradeTime()) {
      Comment("\n    " + Expert_Name, 
         "\n\n    РАБОТАЕТ ", 
         "\n    Broker Time            = ", Hour() + " : " + Minute(), 
         "\n    Начало торговли    = ", OpenHour, 
         "\n    Конец торговли   = ", CloseHour, 
         "\n    Fractal Envelope     = " + gi_416 + " pips", 
         "\n    MidFractal              = " + DoubleToStr(gd_428, Digits), 
         "\n    L O T S                 =  " + DoubleToStr(GetLots(), 2), 
         "\n    B A L A N C E        =  " + DoubleToStr(AccountBalance(), 2), 
         "\n    E Q U I T Y           =  " + DoubleToStr(AccountEquity(), 2), 
         "\n*=====================*");
   } else {
      Comment("\n    " + Expert_Name, 
         "\n\n    НЕ РАБОТАЕТ ", 
         "\n    Broker Time            = ", Hour() + " : " + Minute(), 
         "\n    Начало торговли    = ", OpenHour, 
         "\n    Конец торговли   = ", CloseHour, 
         "\n    Fractal Envelope     = " + gi_416 + " pips", 
         "\n    MidFractal              = " + DoubleToStr(gd_428, Digits), 
         "\n    L O T S                 =  " + DoubleToStr(GetLots(), 2), 
         "\n    B A L A N C E        =  " + DoubleToStr(AccountBalance(), 2), 
         "\n    E Q U I T Y           =  " + DoubleToStr(AccountEquity(), 2), 
         "\n*=====================*"); 
           }
   if (Time_Opened_Protection == TRUE) {
      for (int l_pos_48 = 0; l_pos_48 < OrdersTotal(); l_pos_48++) {
         OrderSelect(l_pos_48, SELECT_BY_POS, MODE_TRADES);
         if (OrderType() == OP_BUY && OrderMagicNumber() == g_magic_296) {
            if (TimeCurrent() - OrderOpenTime() > 60 * LimitTime_1 && TimeCurrent() - OrderOpenTime() < 60 * LimitTime_2 && Bid >= OrderOpenPrice() + pips_1 * gd_492) {
               RefreshRates();
               OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, Orange);
               Print("Prot. Level 1 - Close Price :" + DoubleToStr(OrderClosePrice(), Digits) + " Lots : " + DoubleToStr(OrderLots(), gi_468) + " Order Number : " + DoubleToStr(OrderTicket(), 0) +
                  " Profit : $ " + DoubleToStr(OrderProfit(), 2));
            }
            if (TimeCurrent() - OrderOpenTime() > 60 * LimitTime_2 && TimeCurrent() - OrderOpenTime() < 60 * LimitTime_3 && Bid >= OrderOpenPrice() + pips_2 * gd_492) {
               RefreshRates();
               OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, Orange);
               Print("Prot. Level 2 - Close Price :" + DoubleToStr(OrderClosePrice(), Digits) + " Lots : " + DoubleToStr(OrderLots(), gi_468) + " Order Number : " + DoubleToStr(OrderTicket(), 0) +
                  " Profit : $ " + DoubleToStr(OrderProfit(), 2));
            }
            if (TimeCurrent() - OrderOpenTime() > 60 * LimitTime_3 && TimeCurrent() - OrderOpenTime() < 60 * LimitTime_4 && Bid >= OrderOpenPrice() + pips_3 * gd_492) {
               RefreshRates();
               OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, Orange);
               Print("Prot. Level 3 - Close Price :" + DoubleToStr(OrderClosePrice(), Digits) + " Lots : " + DoubleToStr(OrderLots(), gi_468) + " Order Number : " + DoubleToStr(OrderTicket(), 0) +
                  " Profit : $ " + DoubleToStr(OrderProfit(), 2));
            }
            if (TimeCurrent() - OrderOpenTime() > 60 * LimitTime_4 && TimeCurrent() - OrderOpenTime() < 60 * LimitTime_5 && Bid >= OrderOpenPrice() - pips_4 * gd_492) {
               RefreshRates();
               OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, Orange);
               Print("Prot. Level 4 - Close Price :" + DoubleToStr(OrderClosePrice(), Digits) + " Lots : " + DoubleToStr(OrderLots(), gi_468) + " Order Number : " + DoubleToStr(OrderTicket(), 0) +
                  " Profit : $ " + DoubleToStr(OrderProfit(), 2));
            }
            if (TimeCurrent() - OrderOpenTime() > 60 * LimitTime_5 && Bid >= OrderOpenPrice() - pips_5 * gd_492) {
               RefreshRates();
               OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, Orange);
               Print("Prot. Level 5 - Close Price :" + DoubleToStr(OrderClosePrice(), Digits) + " Lots : " + DoubleToStr(OrderLots(), gi_468) + " Order Number : " + DoubleToStr(OrderTicket(), 0) +
                  " Profit : $ " + DoubleToStr(OrderProfit(), 2));
            }
            if (DayOfWeek() == 5 && Hour() >= 16) {
               RefreshRates();
               OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, Orange);
               Print("Prot. Level 5 - Close Price :" + DoubleToStr(OrderClosePrice(), Digits) + " Lots : " + DoubleToStr(OrderLots(), gi_468) + " Order Number : " + DoubleToStr(OrderTicket(), 0) +
                  " Profit : $ " + DoubleToStr(OrderProfit(), 2));
            }
         }
         if (OrderType() == OP_SELL && OrderMagicNumber() == g_magic_296) {
            if (TimeCurrent() - OrderOpenTime() > 60 * LimitTime_1 && TimeCurrent() - OrderOpenTime() < 60 * LimitTime_2 && Ask <= OrderOpenPrice() - pips_1 * gd_492) {
               RefreshRates();
               OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, Orange);
               Print("Prot. Level 1 - Close Price :" + DoubleToStr(OrderClosePrice(), Digits) + " Lots : " + DoubleToStr(OrderLots(), gi_468) + " Order Number : " + DoubleToStr(OrderTicket(), 0) +
                  " Profit : $ " + DoubleToStr(OrderProfit(), 2));
            }
            if (TimeCurrent() - OrderOpenTime() > 60 * LimitTime_2 && TimeCurrent() - OrderOpenTime() < 60 * LimitTime_3 && Ask <= OrderOpenPrice() - pips_2 * gd_492) {
               RefreshRates();
               OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, Orange);
               Print("Prot. Level 2 - Close Price :" + DoubleToStr(OrderClosePrice(), Digits) + " Lots : " + DoubleToStr(OrderLots(), gi_468) + " Order Number : " + DoubleToStr(OrderTicket(), 0) +
                  " Profit : $ " + DoubleToStr(OrderProfit(), 2));
            }
            if (TimeCurrent() - OrderOpenTime() > 60 * LimitTime_3 && TimeCurrent() - OrderOpenTime() < 60 * LimitTime_4 && Ask <= OrderOpenPrice() - pips_3 * gd_492) {
               RefreshRates();
               OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, Orange);
               Print("Prot. Level 3 - Close Price :" + DoubleToStr(OrderClosePrice(), Digits) + " Lots : " + DoubleToStr(OrderLots(), gi_468) + " Order Number : " + DoubleToStr(OrderTicket(), 0) +
                  " Profit : $ " + DoubleToStr(OrderProfit(), 2));
            }
            if (TimeCurrent() - OrderOpenTime() > 60 * LimitTime_4 && TimeCurrent() - OrderOpenTime() < 60 * LimitTime_5 && Ask <= OrderOpenPrice() + pips_4 * gd_492) {
               RefreshRates();
               OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, Orange);
               Print("Prot. Level 4 - Close Price :" + DoubleToStr(OrderClosePrice(), Digits) + " Lots : " + DoubleToStr(OrderLots(), gi_468) + " Order Number : " + DoubleToStr(OrderTicket(), 0) +
                  " Profit : $ " + DoubleToStr(OrderProfit(), 2));
            }
            if (TimeCurrent() - OrderOpenTime() > 60 * LimitTime_5 && Ask <= OrderOpenPrice() + pips_5 * gd_492) {
               RefreshRates();
               OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, Orange);
               Print("Prot. Level 5 - Close Price :" + DoubleToStr(OrderClosePrice(), Digits) + " Lots : " + DoubleToStr(OrderLots(), gi_468) + " Order Number : " + DoubleToStr(OrderTicket(), 0) +
                  " Profit : $ " + DoubleToStr(OrderProfit(), 2));
            }
            if (DayOfWeek() == 5 && Hour() >= 16) {
               RefreshRates();
               OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, Orange);
               Print("Prot. Level 5 - Close Price :" + DoubleToStr(OrderClosePrice(), Digits) + " Lots : " + DoubleToStr(OrderLots(), gi_468) + " Order Number : " + DoubleToStr(OrderTicket(), 0) +
                  " Profit : $ " + DoubleToStr(OrderProfit(), 2));
            }
         }
      }
   }
   CloseAll();
   double l_icustom_52 = iCustom(Symbol(), PERIOD_M1, "MA_AngleZeroSigma", MA_AngleZero_PERIOD, 1, 0, 0.2, 6, 0, 9, 1, "", "", 4, 0);
   if (IsTradeTime() && IsTradeTimeA()) {
      if (l_count_16 <= MaxTrades) {
         if (g_bars_300 != Bars) {
            g_count_272 = 0;
            g_bars_300 = Bars;
         }
         RefreshRates();
         if (Ask - Bid < MaxSpread * gd_492 && li_44 && g_count_272 <= MaxTradePerBar) {
            if (l_count_8 < 1 && l_icustom_52 <= -0.12 && Bid <= gd_428 - OPFromFractal * gd_492 && GetSignal(0) == 1) {
               if (AccountFreeMarginCheck(Symbol(), OP_BUY, GetLots()) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) Print("Деньги кончились, ищем депозит Free Margin = ", AccountFreeMargin());
               else {
                  if (Hidden_TP == TRUE && Hidden_SL == FALSE) l_ticket_20 = OrderSend(Symbol(), OP_BUY, GetLots(), Ask, Slippage, Ask - SLB * gd_492, 0, Expert_Name, g_magic_296, 0, Blue);
                  else {
                     if (Hidden_TP == TRUE && Hidden_SL == TRUE) l_ticket_20 = OrderSend(Symbol(), OP_BUY, GetLots(), Ask, Slippage, 0, 0, Expert_Name, g_magic_296, 0, Blue);
                     else l_ticket_20 = OrderSend(Symbol(), OP_BUY, GetLots(), Ask, Slippage, Ask - SLB * gd_492, Ask + TP * gd_492, Expert_Name, g_magic_296, 0, Blue);
                  }
                  if (l_ticket_20 > 0) g_count_272++;
               }
               gi_unused_308 = TRUE;
            }
            if (l_count_8 > 0 && l_count_8 < MaxTradePerPosition && l_icustom_52 <= -0.12 && g_ord_open_price_276 - Bid >= Range_OP * gd_492 && Bid <= gd_428 - OPFromFractal * gd_492 &&
               GetSignal(0) == 1) {
               if (AccountFreeMarginCheck(Symbol(), OP_BUY, GetLots()) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) Print("Деньги кончились, ищем депозит Free Margin = ", AccountFreeMargin());
               else {
                  if (Hidden_TP == TRUE && Hidden_SL == FALSE) l_ticket_20 = OrderSend(Symbol(), OP_BUY, GetLots(), Ask, Slippage, Ask - SLB * gd_492, 0, Expert_Name, g_magic_296, 0, Blue);
                  else {
                     if (Hidden_TP == TRUE && Hidden_SL == TRUE) l_ticket_20 = OrderSend(Symbol(), OP_BUY, GetLots(), Ask, Slippage, 0, 0, Expert_Name, g_magic_296, 0, Blue);
                     else l_ticket_20 = OrderSend(Symbol(), OP_BUY, GetLots(), Ask, Slippage, Ask - SLB * gd_492, Ask + TP * gd_492, Expert_Name, g_magic_296, 0, Blue);
                  }
                  if (l_ticket_20 > 0) g_count_272++;
               }
               gi_unused_308 = TRUE;
               gi_unused_304 = FALSE;
            }
            if (l_count_12 < 1 && l_icustom_52 >= 0.12 && Ask >= gd_428 + OPFromFractal * gd_492 && GetSignal(1) == 1) {
               if (AccountFreeMarginCheck(Symbol(), OP_BUY, GetLots()) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) Print("Деньги кончились, ищем депозит Free Margin = ", AccountFreeMargin());
               else {
                  if (Hidden_TP == TRUE && Hidden_SL == FALSE) l_ticket_20 = OrderSend(Symbol(), OP_SELL, GetLots(), Bid, Slippage, Bid + SLB * gd_492, 0, Expert_Name, g_magic_296, 0, Red);
                  else {
                     if (Hidden_TP == TRUE && Hidden_SL == TRUE) l_ticket_20 = OrderSend(Symbol(), OP_SELL, GetLots(), Bid, Slippage, 0, 0, Expert_Name, g_magic_296, 0, Red);
                     else l_ticket_20 = OrderSend(Symbol(), OP_SELL, GetLots(), Bid, Slippage, Bid + SLB * gd_492, Bid - TP * gd_492, Expert_Name, g_magic_296, 0, Red);
                  }
                  if (l_ticket_20 > 0) g_count_272++;
               }
               gi_unused_304 = TRUE;
            }
            if (l_count_12 > 0 && l_count_12 < MaxTradePerPosition && l_icustom_52 >= 0.12 && Ask - g_ord_open_price_284 >= Range_OP * gd_492 && Ask >= gd_428 + OPFromFractal * gd_492 &&
               GetSignal(1) == 1) {
               if (AccountFreeMarginCheck(Symbol(), OP_BUY, GetLots()) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) Print("Деньги кончились, ищем депозит Free Margin = ", AccountFreeMargin());
               else {
                  if (Hidden_TP == TRUE && Hidden_SL == FALSE) l_ticket_20 = OrderSend(Symbol(), OP_SELL, GetLots(), Bid, Slippage, Bid + SLB * gd_492, 0, Expert_Name, g_magic_296, 0, Red);
                  else {
                     if (Hidden_TP == TRUE && Hidden_SL == TRUE) l_ticket_20 = OrderSend(Symbol(), OP_SELL, GetLots(), Bid, Slippage, 0, 0, Expert_Name, g_magic_296, 0, Red);
                     else l_ticket_20 = OrderSend(Symbol(), OP_SELL, GetLots(), Bid, Slippage, Bid + SLB * gd_492, Bid - TP * gd_492, Expert_Name, g_magic_296, 0, Red);
                  }
                  if (l_ticket_20 > 0) g_count_272++;
               }
               gi_unused_304 = TRUE;
               gi_unused_308 = FALSE;
            }
         }
      }
      if (l_icustom_52 < 0.1 && l_icustom_52 > -0.1) {
         gi_unused_308 = TRUE;
         gi_unused_304 = TRUE;
      }
   }
   return (0);
}

int GetSignal(int ai_0) {
   bool li_ret_4 = FALSE;
   int li_8 = 0;
   int li_12 = 3;
   if (Digits == 5 || Digits == 3) li_8 = 10 * li_12;
   else li_8 = li_12;
   if (ai_0 == 0) {
      if (Ask <= NormalizeDouble(iMA(Symbol(), PERIOD_M5, IMA_PERIOD, 0, MODE_SMA, PRICE_OPEN, 0), Digits) - gd_492 * li_8) li_ret_4 = TRUE;
   } else {
      if (ai_0 == 1)
         if (Bid >= NormalizeDouble(iMA(Symbol(), PERIOD_M5, IMA_PERIOD, 0, MODE_SMA, PRICE_OPEN, 0), Digits) + gd_492 * li_8) li_ret_4 = TRUE;
   }
   return (li_ret_4);
}

void CloseAll() {
   for (int l_pos_0 = OrdersTotal() - 1; l_pos_0 >= 0; l_pos_0--) {
      OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_296 && OrderCloseTime() == 0) {
         if (SecurProfit() == 1) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, Blue);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, Red);
         } else {
            if (IsTradeTime()) {
               if (OrderType() == OP_BUY && (OrderOpenPrice() - Bid) / gd_492 > SLA) OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, Blue);
               if (OrderType() == OP_SELL && (Ask - OrderOpenPrice()) / gd_492 > SLA) OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, Red);
            } else {
               if (Hidden_SL == TRUE)
                  if (OrderType() == OP_BUY && (OrderOpenPrice() - Bid) / gd_492 > SLB) OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, Blue);
               if (OrderType() == OP_SELL && (Ask - OrderOpenPrice()) / gd_492 > SLB) OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, Red);
            }
         }
      }
   }
}

void ForceCloseAll() {
   for (int l_pos_0 = OrdersTotal() - 1; l_pos_0 >= 0; l_pos_0--) {
      OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_296 && OrderCloseTime() == 0) {
         if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, Blue);
         if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, Red);
      }
   }
}

bool IsTradeTime() {
   if (OpenHour < CloseHour && TimeHour(TimeCurrent()) < OpenHour || TimeHour(TimeCurrent()) >= CloseHour) return (FALSE);
   if (OpenHour > CloseHour && (TimeHour(TimeCurrent()) < OpenHour && TimeHour(TimeCurrent()) >= CloseHour)) return (FALSE);
   if (OpenHour == 0) CloseHour = 24;
   if (Hour() == CloseHour - 1 && Minute() >= gi_292) return (FALSE);
   return (TRUE);
}

int IsTradeTimeA() {
   if (DayOfWeek() == 5 && Hour() >= CloseHour) return (0);
   return (1);
}

double GetLots() {
   double ld_ret_0;
   double ld_48;
   int li_64;
   double l_lotsize_56 = MarketInfo(Symbol(), MODE_LOTSIZE);
   double ld_8 = NormalizeDouble(MarketInfo(Symbol(), MODE_LOTSTEP), 2);
   double ld_16 = NormalizeDouble(MarketInfo(Symbol(), MODE_MARGINREQUIRED), 4);
   if (ld_8 == 0.01) li_64 = 2;
   else {
      if (ld_8 == 0.1) li_64 = 1;
      else li_64 = 0;
   }
   gi_468 = li_64;
   if (LotsOptimized == TRUE) ld_ret_0 = NormalizeDouble(AccountFreeMargin() * Risk / l_lotsize_56 / MaxTrades, gi_468);
   else ld_ret_0 = Lots;
   double ld_32 = NormalizeDouble(MarketInfo(Symbol(), MODE_MINLOT), 2);
   double ld_40 = NormalizeDouble(MarketInfo(Symbol(), MODE_MAXLOT), 2);
   if (gi_468 == 2) ld_32 = 0.01;
   if (gi_468 == 1) ld_32 = 0.1;
   if (gi_468 == 0) ld_32 = 1;
   if (ld_ret_0 < ld_32) ld_ret_0 = ld_32;
   if (ld_40 > MaxLots) ld_48 = MaxLots;
   else ld_48 = ld_40;
   if (ld_ret_0 > ld_48) ld_ret_0 = ld_48;
   return (ld_ret_0);
}

double TickValue() {
   double ld_0 = NormalizeDouble(MarketInfo(Symbol(), MODE_TICKVALUE), Digits);
   return (ld_0);
}

int SecurProfit() {
   bool li_ret_0 = FALSE;
   if (OrderProfit() > TickValue() * GetLots() * TP) li_ret_0 = TRUE;
   return (li_ret_0);
}

double SetPoint() {
   double ld_ret_0;
   if (Digits == 5 || Digits == 3) ld_ret_0 = 0.00001;
   else ld_ret_0 = 0.0001;
   return (ld_ret_0);
}