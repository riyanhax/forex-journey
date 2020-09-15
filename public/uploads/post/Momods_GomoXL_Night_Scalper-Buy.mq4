// Original code GomoXL
// Code modified by Momods
// September 29, 2012
// Added 4-5 digits broker compatibility
// Added separate parameters for Day and Night trading
// Added Start/End hour for night trading


extern string gs_264 = "Momods_GomoXL_Night_Scalper-Buy";
int gi_76 = 1;
bool gi_80 = FALSE;
bool gi_84 = TRUE;
extern int Start_Hour=20;
extern int End_Hour=1;
extern double Night_LotExp = 2;
double g_slippage_96 = 1.0;
extern double Lots = 0.01;
double gd_112 = 2.0;
extern double Night_TP = 10.0;
double g_pips_128 = 500.0;
double gd_136 = 10.0;
double gd_144 = 10.0;
extern double Night_PipStep = 5.0;
extern int NightMaxTrades = 4;
extern double Day_LotExp = 1.6;
extern double Day_TP = 5.0;
extern double Day_PipStep = 40.0;
extern int DayMaxTrades = 10;
bool gi_164 = FALSE;
double gd_168 = 20.0;
bool gi_176 = FALSE;
bool gi_180 = FALSE;
double gd_184 = 48.0;
extern int g_magic_192 = 112233441;
double g_price_196;
double gd_204;
double gd_unused_212;
double g_price_220;
double g_ask_228;
double gd_236;
double gd_252;
bool gi_260;
int g_time_272 = 0;
int gi_276;
int gi_280 = 0;
double gd_284;
int g_pos_292 = 0;
int gi_296;
double gd_300 = 0.0;
bool gi_308 = FALSE;
bool gi_312 = FALSE;
bool gi_unused_316 = FALSE;
int gi_320;
extern double NewCycle = 1;
bool gi_324 = FALSE;
int g_datetime_328 = 0;
double gd_332;
double gd_340;
bool FirstTrade;
double LotExp;
int TakeProfit,PipStep;

int init() {
   gd_252 = MarketInfo(Symbol(), MODE_SPREAD) * PointValue();
   if (IsTesting() == TRUE) Display_Info();
   if (IsTesting() == FALSE) Display_Info();
   return (0);
}

int deinit() {
   return (0);
}

int start() {

   double l_ord_lots_48;
   int li_32 = 377313;
   FirstTrade = TRUE;
   if (DayOfWeek() == 5) FirstTrade = FALSE;  
   if (Start_Hour==24)Start_Hour=0;
   if (End_Hour==24)End_Hour=0;     
   if (Start_Hour < End_Hour && TimeHour(TimeCurrent()) < Start_Hour || TimeHour(TimeCurrent()) >= End_Hour) FirstTrade = FALSE;
   if (Start_Hour > End_Hour && (TimeHour(TimeCurrent()) < Start_Hour && TimeHour(TimeCurrent()) >= End_Hour)) FirstTrade = FALSE;   
   if (FirstTrade == FALSE)
   {
     LotExp=Day_LotExp;
     TakeProfit=Day_TP;
     PipStep=Day_PipStep;
   }  
     
   if (FirstTrade == TRUE)
   {
     LotExp=Night_LotExp;
     TakeProfit=Night_TP;
     PipStep=Night_PipStep;
   }
   
   if (CountTrades()>= NightMaxTrades)
   {
     LotExp=Day_LotExp;
     TakeProfit=Day_TP;
     PipStep=Day_PipStep;
   }   

   if (gi_176) TrailingAlls(gd_136, gd_144, g_price_220);
   if (gi_180) {
      if (TimeCurrent() >= gi_276) {
         CloseThisSymbolAll();
         Print("Closed All due to TimeOut");
      }
   }
   if (g_time_272 == Time[0]) return (0);
   g_time_272 = Time[0];
   double ld_40 = CalculateProfit();
   if (gi_164) {
      if (ld_40 < 0.0 && MathAbs(ld_40) > gd_168 / 100.0 * AccountEquityHigh()) {
         CloseThisSymbolAll();
         Print("Closed All due to Stop Out");
         gi_324 = FALSE;
      }
   }
   gi_296 = CountTrades();
   if (gi_296 == 0) gi_260 = FALSE;
   for (g_pos_292 = OrdersTotal() - 1; g_pos_292 >= 0; g_pos_292--) {
      OrderSelect(g_pos_292, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_192) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_192) {
         if (OrderType() == OP_BUY) {
            gi_312 = TRUE;
            l_ord_lots_48 = OrderLots();
            break;
         }
      }
   }
   if (gi_296 > 0 && gi_296 <= (NightMaxTrades+DayMaxTrades)) {
      RefreshRates();
      gd_236 = FindLastBuyPrice();
      if (gi_312 && gd_236 - Ask >= PipStep * PointValue()) gi_308 = TRUE;
   }
   if (gi_296 < NewCycle) {
      gi_312 = FALSE;
      gi_308 = TRUE;
      gd_204 = AccountEquity();
   }
   
   if (gi_308) {
      gd_236 = FindLastBuyPrice();
      if (gi_312) {
         if (gi_80) {
            fOrderCloseMarket(1, 0);
            gd_284 = NormalizeDouble(LotExp * l_ord_lots_48, gd_112);
         } else gd_284 = fGetLots(OP_BUY);
         if (gi_84) {
            gi_280 = gi_296;
            if (gd_284 > 0.0) {
               gi_320 = OpenPendingOrder(0, gd_284, Ask, g_slippage_96, Bid, 0, 0, gs_264 + "-" + gi_280, g_magic_192, 0, Lime);
               if (gi_320 < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               gd_236 = FindLastBuyPrice();
               gi_308 = FALSE;
               gi_324 = TRUE;
            }
         }
      }
   }
    
   if (gi_308 && gi_296 < 1 && FirstTrade) {
      g_ask_228 = Ask;
      if (!gi_312) {
         gi_280 = gi_296;
         gd_284 = fGetLots(OP_BUY);
         if (gd_284 > 0.0) {
            gi_320 = OpenPendingOrder(0, gd_284, g_ask_228, g_slippage_96, g_ask_228, 0, 0, gs_264 + "-" + gi_280, g_magic_192, 0, Lime);
            if (gi_320 < 0) {
               Print(gd_284, "Error: ", GetLastError());
               return (0);
            }
            gi_324 = TRUE;
         }
      }
      if (gi_320 > 0) gi_276 = TimeCurrent() + 60.0 * (60.0 * gd_184);
      gi_308 = FALSE;
   }
   gi_296 = CountTrades();
   g_price_220 = 0;
   double ld_56 = 0;
   for (g_pos_292 = OrdersTotal() - 1; g_pos_292 >= 0; g_pos_292--) {
      OrderSelect(g_pos_292, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_192) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_192) {
         if (OrderType() == OP_BUY) {
            g_price_220 += OrderOpenPrice() * OrderLots();
            ld_56 += OrderLots();
         }
      }
   }
   if (gi_296 > 0) g_price_220 = NormalizeDouble(g_price_220 / ld_56, Digits);
   if (gi_324) {
      for (g_pos_292 = OrdersTotal() - 1; g_pos_292 >= 0; g_pos_292--) {
         OrderSelect(g_pos_292, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_192) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_192) {
            if (OrderType() == OP_BUY) {
               g_price_196 = g_price_220 + TakeProfit * PointValue();
               gd_unused_212 = g_price_196;
               gd_300 = g_price_220 - g_pips_128 * PointValue();
               gi_260 = TRUE;
            }
         }
      }
   }
   if (gi_324) {
      if (gi_260 == TRUE) {
         for (g_pos_292 = OrdersTotal() - 1; g_pos_292 >= 0; g_pos_292--) {
            OrderSelect(g_pos_292, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_192) continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_192) OrderModify(OrderTicket(), g_price_220, OrderStopLoss(), g_price_196, 0, Yellow);
            gi_324 = FALSE;
         }
      }
   }
   return (0);
}

double ND(double ad_0) {
   return (NormalizeDouble(ad_0, Digits));
}

int fOrderCloseMarket(bool ai_0 = TRUE, bool ai_unused_4 = TRUE) {
   int li_ret_8 = 0;
   for (int l_pos_12 = OrdersTotal() - 1; l_pos_12 >= 0; l_pos_12--) {
      if (OrderSelect(l_pos_12, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_192) {
            if (OrderType() == OP_BUY && ai_0) {
               RefreshRates();
               if (!IsTradeContextBusy()) {
                  if (!OrderClose(OrderTicket(), OrderLots(), ND(Bid), 5, CLR_NONE)) {
                     Print("Error close BUY " + OrderTicket());
                     li_ret_8 = -1;
                  }
               } else {
                  if (g_datetime_328 != iTime(NULL, 0, 0)) {
                     g_datetime_328 = iTime(NULL, 0, 0);
                     Print("Need close BUY " + OrderTicket() + ". Trade Context Busy");
                  }
                  return (-2);
               }
            }
         }
      }
   }
   return (li_ret_8);
}

double fGetLots(int a_cmd_0) {
   double l_lots_4;
   int l_datetime_16;
   switch (gi_76) {
   case 0:
      l_lots_4 = Lots;
      break;
   case 1:
      l_lots_4 = NormalizeDouble(Lots * MathPow(LotExp, gi_280), gd_112);
      break;
   case 2:
      l_datetime_16 = 0;
      l_lots_4 = Lots;
      for (int l_pos_20 = OrdersHistoryTotal() - 1; l_pos_20 >= 0; l_pos_20--) {
         if (OrderSelect(l_pos_20, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_192) {
               if (l_datetime_16 < OrderCloseTime()) {
                  l_datetime_16 = OrderCloseTime();
                  if (OrderProfit() < 0.0) l_lots_4 = NormalizeDouble(OrderLots() * LotExp, gd_112);
                  else l_lots_4 = Lots;
               }
            }
         } else return (-3);
      }
   }
   if (AccountFreeMarginCheck(Symbol(), a_cmd_0, l_lots_4) <= 0.0) return (-1);
   if (GetLastError() == 134/* NOT_ENOUGH_MONEY */) return (-2);
   return (l_lots_4);
}

int CountTrades() {
   int l_count_0 = 0;
   for (int l_pos_4 = OrdersTotal() - 1; l_pos_4 >= 0; l_pos_4--) {
      OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_192) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_192)
         if (OrderType() == OP_BUY) l_count_0++;
   }
   return (l_count_0);
}

void CloseThisSymbolAll() {
   for (int l_pos_0 = OrdersTotal() - 1; l_pos_0 >= 0; l_pos_0--) {
      OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_192)
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, g_slippage_96, Blue);
         Sleep(1000);
      }
   }
}

int OpenPendingOrder(int ai_0, double a_lots_4, double a_price_12, int a_slippage_20, double ad_24, int ai_32, int ai_36, string a_comment_40, int a_magic_48, int a_datetime_52, color a_color_56) {
   int l_ticket_60 = 0;
   int l_error_64 = 0;
   int l_count_68 = 0;
   int li_72 = 100;
   switch (ai_0) {
   case 2:
      for (l_count_68 = 0; l_count_68 < li_72; l_count_68++) {
         l_ticket_60 = OrderSend(Symbol(), OP_BUYLIMIT, a_lots_4, a_price_12, a_slippage_20, StopLong(ad_24, ai_32), TakeLong(a_price_12, ai_36), a_comment_40, a_magic_48, a_datetime_52, a_color_56);
         l_error_64 = GetLastError();
         if (l_error_64 == 0/* NO_ERROR */) break;
         if (!(l_error_64 == 4/* SERVER_BUSY */ || l_error_64 == 137/* BROKER_BUSY */ || l_error_64 == 146/* TRADE_CONTEXT_BUSY */ || l_error_64 == 136/* OFF_QUOTES */)) break;
         Sleep(1000);
      }
      break;
   case 4:
      for (l_count_68 = 0; l_count_68 < li_72; l_count_68++) {
         l_ticket_60 = OrderSend(Symbol(), OP_BUYSTOP, a_lots_4, a_price_12, a_slippage_20, StopLong(ad_24, ai_32), TakeLong(a_price_12, ai_36), a_comment_40, a_magic_48, a_datetime_52, a_color_56);
         l_error_64 = GetLastError();
         if (l_error_64 == 0/* NO_ERROR */) break;
         if (!(l_error_64 == 4/* SERVER_BUSY */ || l_error_64 == 137/* BROKER_BUSY */ || l_error_64 == 146/* TRADE_CONTEXT_BUSY */ || l_error_64 == 136/* OFF_QUOTES */)) break;
         Sleep(5000);
      }
      break;
   case 0:
      for (l_count_68 = 0; l_count_68 < li_72; l_count_68++) {
         RefreshRates();
         l_ticket_60 = OrderSend(Symbol(), OP_BUY, a_lots_4, Ask, a_slippage_20, StopLong(Bid, ai_32), TakeLong(Ask, ai_36), a_comment_40, a_magic_48, a_datetime_52, a_color_56);
         l_error_64 = GetLastError();
         if (l_error_64 == 0/* NO_ERROR */) break;
         if (!(l_error_64 == 4/* SERVER_BUSY */ || l_error_64 == 137/* BROKER_BUSY */ || l_error_64 == 146/* TRADE_CONTEXT_BUSY */ || l_error_64 == 136/* OFF_QUOTES */)) break;
         Sleep(5000);
      }
   }
   return (l_ticket_60);
}

double StopLong(double ad_0, int ai_8) {
   if (ai_8 == 0) return (0);
   return (ad_0 - ai_8 * PointValue());
}

double TakeLong(double ad_0, int ai_8) {
   if (ai_8 == 0) return (0);
   return (ad_0 + ai_8 * PointValue());
}

double CalculateProfit() {
   double ld_ret_0 = 0;
   for (g_pos_292 = OrdersTotal() - 1; g_pos_292 >= 0; g_pos_292--) {
      OrderSelect(g_pos_292, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_192) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_192)
         if (OrderType() == OP_BUY) ld_ret_0 += OrderProfit();
   }
   return (ld_ret_0);
}

void TrailingAlls(int ai_0, int ai_4, double a_price_8) {
   int li_16;
   double l_ord_stoploss_20;
   double l_price_28;
   if (ai_4 != 0) {
      for (int l_pos_36 = OrdersTotal() - 1; l_pos_36 >= 0; l_pos_36--) {
         if (OrderSelect(l_pos_36, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_192) continue;
            if (OrderSymbol() == Symbol() || OrderMagicNumber() == g_magic_192) {
               if (OrderType() == OP_BUY) {
                  li_16 = NormalizeDouble((Bid - a_price_8) / PointValue(), 0);
                  if (li_16 < ai_0) continue;
                  l_ord_stoploss_20 = OrderStopLoss();
                  l_price_28 = Bid - ai_4 * PointValue();
                  if (l_ord_stoploss_20 == 0.0 || (l_ord_stoploss_20 != 0.0 && l_price_28 > l_ord_stoploss_20)) OrderModify(OrderTicket(), a_price_8, l_price_28, OrderTakeProfit(), 0, Aqua);
               }
            }
            Sleep(1000);
         }
      }
   }
}

double AccountEquityHigh() {
   if (CountTrades() == 0) gd_332 = AccountEquity();
   if (gd_332 < gd_340) gd_332 = gd_340;
   else gd_332 = AccountEquity();
   gd_340 = AccountEquity();
   return (gd_332);
}

double FindLastBuyPrice() {
   double l_ord_open_price_8;
   int l_ticket_24;
   double ld_unused_0 = 0;
   int l_ticket_20 = 0;
   for (int l_pos_16 = OrdersTotal() - 1; l_pos_16 >= 0; l_pos_16--) {
      OrderSelect(l_pos_16, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_192) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_192 && OrderType() == OP_BUY) {
         l_ticket_24 = OrderTicket();
         if (l_ticket_24 > l_ticket_20) {
            l_ord_open_price_8 = OrderOpenPrice();
            ld_unused_0 = l_ord_open_price_8;
            l_ticket_20 = l_ticket_24;
         }
      }
   }
   return (l_ord_open_price_8);
}

void Display_Info() {
   Comment("This system for register member only\n", "Forex Account Server:", AccountServer(), 
      "\n", "___________________________________", 
      "\n", "AccountName:  ", AccountName(), 
      "\n", "Lots:  ", Lots, 
      "\n", "LotExp:  ", LotExp, 
      "\n", "Step: ", PipStep, 
      "\n", "TakeProfit: ", TakeProfit, 
      "\n", "Symbol: ", Symbol(), 
      "\n", "Price:  ", NormalizeDouble(Bid, 4), 
      "\n", "Date: ", Month(), "-", Day(), "-", Year(), " Server Time: ", Hour(), ":", Minute(), ":", Seconds(), 
      "\n", "___________________________________", 
   "\n");
}

double PointValue() {
   if (MarketInfo(Symbol(), MODE_DIGITS) == 5.0 || MarketInfo(Symbol(), MODE_DIGITS) == 3.0) return (10.0 * Point);
   return (Point);
}