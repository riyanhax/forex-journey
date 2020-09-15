#property copyright "X-module 1.0"
#property link      "http://www.x-module.ru"

//Õ‡ 1000 ‰ÓÎ. Ì‡‰‡ ÒÚ‡Ú ÎÓÚ 0.02
//Õ‡ 2000 ‰ÓÎ. Ì‡‰‡ ÒÚ‡Ú ÎÓÚ 0.04
//Õ‡ 4000 ‰ÓÎ. Ì‡‰‡ ÒÚ‡Ú ÎÓÚ 0.08 ≥ Ú.‰.
extern int Magic = 1111;
extern double Lots = 0.02;
extern double TakeProfit = 45.0;
extern double Booster = 1.86;
extern int PipStarter = 45;
double gd_112 = 0.0;
int gi_120 = 0;
extern int MaxTradesPerChart = 9;
extern int StartHour = 0;
extern int StopHour = 24;
int gi_136 = 55;
extern int StartingTradeDay = 0;
extern int EndingTradeDay = 5;
extern int slippage = 3;
double g_lots_156;
int g_period_164 = 7;
int gi_168 = 0;
int g_ma_method_172 = MODE_LWMA;
int g_applied_price_176 = PRICE_WEIGHTED;
double gd_180 = 0.25;
double gd_188 = 0.2;
extern bool SupportECN = FALSE;
int gi_200;
bool gi_unused_204 = FALSE;
string gs_dummy_208;
int gi_216;
int gi_220;
int gi_224 = 0;
int gi_228 = 1;
int gi_unused_232 = 3;
int gi_236 = 250;

int deinit() {
   return (0);
}

int init() {
   if (Digits == 3) {
      gd_112 = 10.0 * TakeProfit;
      gi_120 = 10.0 * PipStarter;
   } else {
      if (Digits == 5) {
         gd_112 = 10.0 * TakeProfit;
         gi_120 = 10.0 * PipStarter;
      } else {
         gd_112 = TakeProfit;
         gi_120 = PipStarter;
      }
   }
//   if (Symbol() == "AUDCADm" || Symbol() == "AUDCAD" || Symbol() == "AUDCAD.") Magic = 133701;
//   if (Symbol() == "AUDJPYm" || Symbol() == "AUDJPY" || Symbol() == "AUDJPY.") Magic = 133702;
//   if (Symbol() == "AUDNZDm" || Symbol() == "AUDNZD" || Symbol() == "AUDNZD.") Magic = 133703;
//   if (Symbol() == "AUDUSDm" || Symbol() == "AUDUSD" || Symbol() == "AUDUSD.") Magic = 133704;
//   if (Symbol() == "CHFJPYm" || Symbol() == "CHFJPY" || Symbol() == "CHFJPY.") Magic = 133705;
//   if (Symbol() == "EURAUDm" || Symbol() == "EURAUD" || Symbol() == "EURAUD.") Magic = 133706;
//   if (Symbol() == "EURCADm" || Symbol() == "EURCAD" || Symbol() == "EURCAD.") Magic = 133707;
//   if (Symbol() == "EURCHFm" || Symbol() == "EURCHF" || Symbol() == "EURCHF.") Magic = 133708;
//   if (Symbol() == "EURGBPm" || Symbol() == "EURGBP" || Symbol() == "EURGBP.") Magic = 133709;
//   if (Symbol() == "EURJPYm" || Symbol() == "EURJPY" || Symbol() == "EURJPY.") Magic = 133710;
//   if (Symbol() == "EURUSDm" || Symbol() == "EURUSD" || Symbol() == "EURUSD.") Magic = 133711;
//   if (Symbol() == "GBPCHFm" || Symbol() == "GBPCHF" || Symbol() == "GBPCHF.") Magic = 133712;
//   if (Symbol() == "GBPJPYm" || Symbol() == "GBPJPY" || Symbol() == "GBPJPY.") Magic = 133713;
//   if (Symbol() == "GBPUSDm" || Symbol() == "GBPUSD" || Symbol() == "GBPUSD.") Magic = 133714;
//   if (Symbol() == "NZDJPYm" || Symbol() == "NZDJPY" || Symbol() == "NZDJPY.") Magic = 133715;
//   if (Symbol() == "NZDUSDm" || Symbol() == "NZDUSD" || Symbol() == "NZDUSD.") Magic = 133716;
//   if (Symbol() == "USDCHFm" || Symbol() == "USDCHF" || Symbol() == "USDCHF.") Magic = 133717;
//   if (Symbol() == "USDJPYm" || Symbol() == "USDJPY" || Symbol() == "USDJPY.") Magic = 133718;
//   if (Symbol() == "USDCADm" || Symbol() == "USDCAD" || Symbol() == "USDCAD.") Magic = 133719;
//   if (Magic == 0) Magic = 133799;
   gi_200 = MathRound((-MathLog(MarketInfo(Symbol(), MODE_LOTSTEP))) / 2.302585093);

   return (0);
}

int IsTradeTime() {
   if (StartHour < StopHour && TimeHour(TimeCurrent()) < StartHour || TimeHour(TimeCurrent()) >= StopHour) return (0);
   if (StartHour > StopHour && (TimeHour(TimeCurrent()) < StopHour && TimeHour(TimeCurrent()) >= StopHour)) return (0);
   if (StopHour == 0) StopHour = 24;
   if (Hour() == StopHour - 1 && Minute() >= gi_136) return (0);
   return (1);
}

void OpenBuy() {
   int l_ticket_0;
   if (!GlobalVariableCheck("InTrade")) {
      GlobalVariableSet("InTrade", TimeCurrent());
      if (SupportECN && IsTradeTime() == 1 && DayOfWeek() >= StartingTradeDay && DayOfWeek() <= EndingTradeDay) l_ticket_0 = OrderSend(Symbol(), OP_BUY, g_lots_156, Ask, slippage, 0, 0, "x-moduleBuyô", Magic, 0, Green);
      else
         if (IsTradeTime() == 1 && DayOfWeek() >= StartingTradeDay && DayOfWeek() <= EndingTradeDay) l_ticket_0 = OrderSend(Symbol(), OP_BUY, g_lots_156, Ask, slippage, 0, Ask + gd_112 * Point, "x-moduleBuyô", Magic, 0, Green);
      GlobalVariableDel("InTrade");
   }
}

void OpenSell() {
   int l_ticket_0;
   if (!GlobalVariableCheck("InTrade")) {
      GlobalVariableSet("InTrade", TimeCurrent());
      if (SupportECN && IsTradeTime() == 1 && DayOfWeek() >= StartingTradeDay && DayOfWeek() <= EndingTradeDay) l_ticket_0 = OrderSend(Symbol(), OP_SELL, g_lots_156, Bid, slippage, 0, 0, "x-moduleSellô", Magic, 0, Pink);
      else
         if (IsTradeTime() == 1 && DayOfWeek() >= StartingTradeDay && DayOfWeek() <= EndingTradeDay) l_ticket_0 = OrderSend(Symbol(), OP_SELL, g_lots_156, Bid, slippage, 0, Bid - gd_112 * Point, "x-moduleSellô", Magic, 0, Pink);
      GlobalVariableDel("InTrade");
   }
}

void ManageBuy() {
   int l_datetime_0 = 0;
   double l_ord_open_price_4 = 0;
   double l_ord_lots_12 = 0;
   double l_ord_takeprofit_20 = 0;
   int l_cmd_28 = -1;
   int l_ticket_32 = 0;
   int l_pos_36 = 0;
   for (l_pos_36 = 0; l_pos_36 < OrdersTotal(); l_pos_36++) {
      OrderSelect(l_pos_36, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() != Magic || OrderType() != OP_BUY) continue;
      if (OrderOpenTime() > l_datetime_0 && IsTradeTime() == 1) {
         l_datetime_0 = OrderOpenTime();
         l_ord_open_price_4 = OrderOpenPrice();
         l_cmd_28 = OrderType();
         l_ticket_32 = OrderTicket();
         l_ord_takeprofit_20 = OrderTakeProfit();
      }
      if (OrderLots() > l_ord_lots_12) l_ord_lots_12 = OrderLots();
   }
   double l_isar_40 = iSAR(NULL, 0, gd_180, gd_188, 0);
   double l_ima_48 = iMA(NULL, 0, g_period_164, gi_168, g_ma_method_172, g_applied_price_176, 0);
   int li_56 = MathRound(MathLog(l_ord_lots_12 / Lots) / MathLog(Booster)) + 1.0;
   if (li_56 < 0) li_56 = 0;
   g_lots_156 = NormalizeDouble(Lots * MathPow(Booster, li_56), gi_200);
   if ((g_lots_156 == l_ord_lots_12) && (g_lots_156 == 0.01)) g_lots_156 = 0.02;
   if ((li_56 == 0 && l_isar_40 < l_ima_48 && DayOfWeek() < EndingTradeDay) || (li_56 == 0 && l_isar_40 < l_ima_48 && DayOfWeek() >= StartingTradeDay && DayOfWeek() <= EndingTradeDay)) OpenBuy();
   if (l_ord_open_price_4 - Ask > gi_120 * Point && li_56 < MaxTradesPerChart) {
      OpenBuy();
      return;
   }
   for (l_pos_36 = 0; l_pos_36 < OrdersTotal(); l_pos_36++) {
      OrderSelect(l_pos_36, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() != Magic || OrderType() != OP_BUY || OrderTakeProfit() == l_ord_takeprofit_20 || l_ord_takeprofit_20 == 0.0) continue;
      OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), l_ord_takeprofit_20, 0, Pink);
   }
}

void ManageSell() {
   int l_datetime_0 = 0;
   double l_ord_open_price_4 = 0;
   double l_ord_lots_12 = 0;
   double l_ord_takeprofit_20 = 0;
   int l_cmd_28 = -1;
   int l_ticket_32 = 0;
   int l_pos_36 = 0;
   for (l_pos_36 = 0; l_pos_36 < OrdersTotal(); l_pos_36++) {
      OrderSelect(l_pos_36, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() != Magic || OrderType() != OP_SELL) continue;
      if (OrderOpenTime() > l_datetime_0 && IsTradeTime() == 1) {
         l_datetime_0 = OrderOpenTime();
         l_ord_open_price_4 = OrderOpenPrice();
         l_cmd_28 = OrderType();
         l_ticket_32 = OrderTicket();
         l_ord_takeprofit_20 = OrderTakeProfit();
      }
      if (OrderLots() > l_ord_lots_12) l_ord_lots_12 = OrderLots();
   }
   double l_isar_40 = iSAR(NULL, 0, gd_180, gd_188, 0);
   double l_ima_48 = iMA(NULL, 0, g_period_164, gi_168, g_ma_method_172, g_applied_price_176, 0);
   int li_56 = MathRound(MathLog(l_ord_lots_12 / Lots) / MathLog(Booster)) + 1.0;
   if (li_56 < 0) li_56 = 0;
   g_lots_156 = NormalizeDouble(Lots * MathPow(Booster, li_56), gi_200);
   if ((g_lots_156 == l_ord_lots_12) && (g_lots_156 == 0.01)) g_lots_156 = 0.02;
   if ((li_56 == 0 && l_isar_40 > l_ima_48 && DayOfWeek() < EndingTradeDay) || (li_56 == 0 && l_isar_40 > l_ima_48 && DayOfWeek() >= StartingTradeDay && DayOfWeek() <= EndingTradeDay)) OpenSell();
   if (Bid - l_ord_open_price_4 > gi_120 * Point && l_ord_open_price_4 > 0.0 && li_56 < MaxTradesPerChart) {
      OpenSell();
      return;
   }
   for (l_pos_36 = 0; l_pos_36 < OrdersTotal(); l_pos_36++) {
      OrderSelect(l_pos_36, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() != Magic || OrderType() != OP_SELL || OrderTakeProfit() == l_ord_takeprofit_20 || l_ord_takeprofit_20 == 0.0) continue;
      OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), l_ord_takeprofit_20, 0, Pink);
   }
}

int start() {

   if (SupportECN) {
      for (int l_pos_0 = 0; l_pos_0 < OrdersTotal(); l_pos_0++) {
         if (OrderSelect(l_pos_0, SELECT_BY_POS)) {
            if (OrderMagicNumber() == Magic) {
               if (OrderTakeProfit() == 0.0) {
                  if (OrderType() == OP_BUY) OrderModify(OrderTicket(), 0, OrderStopLoss(), OrderOpenPrice() + gd_112 * Point, 0, White);
                  else
                     if (OrderType() == OP_SELL) OrderModify(OrderTicket(), 0, OrderStopLoss(), OrderOpenPrice() - gd_112 * Point, 0, White);
               }
            }
         }
      }
   }
   if (Check() != 0) {
      ManageBuy();
      ManageSell();
      ChartComment();
      return (0);
   }
   return (0);
}

void ChartComment() {
   string l_dbl2str_0 = DoubleToStr(balanceDeviation(2), 2);
   Comment(" \nx-module V1.0ô ", 
      "\nAccount Leverage  :  " + "1 : " + AccountLeverage(), 
      "\nAccount Type  :  " + AccountServer(), 
      "\nServer Time  :  " + TimeToStr(TimeCurrent(), TIME_SECONDS), 
      "\nAccount Equity  = ", AccountEquity(), 
      "\nFree Margin     = ", AccountFreeMargin(), 
   "\nDrawdown  :  ", l_dbl2str_0, "%\n");
}

int Check() {
   return (1);
}

double balanceDeviation(int ai_0) {
   double ld_ret_4;
   if (ai_0 == 2) {
      ld_ret_4 = (AccountEquity() / AccountBalance() - 1.0) / (-0.01);
      if (ld_ret_4 > 0.0) return (ld_ret_4);
      return (0);
   }
   if (ai_0 == 1) {
      ld_ret_4 = 100.0 * (AccountEquity() / AccountBalance() - 1.0);
      if (ld_ret_4 > 0.0) return (ld_ret_4);
      return (0);
   }
   return (0.0);
}