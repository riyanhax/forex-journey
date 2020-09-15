
#property copyright "Copyright © 2011, Expert Advisor"
#property link      "http://robotforexkhai.webs.com/"

extern string _EA = "________EA MA________";
extern int Magic = 20110402;
extern double Lots = 0.01;
extern int TakeProfit1 = 4;
extern int TakeProfit2 = 4;
extern int StopLoss = 0;
int gi_108 = 0;
int g_acc_number_112 = 5063268;
string gs_116 = "2012.2.30 00:00";
extern string _MOVING_AVERAGES1 = "_______MA INDICATOR 1______";
extern int MA_Period1 = 10;
extern int MA_Method1 = 0;
extern string MA_MethoD1 = "0=simple 1=exponential 2=smoothed 3=linear weighted";
extern int aplied_price1 = 0;
extern string aplied_pricE1 = "0=CLOSE 1=OPEN 2=HIGH 3=LOW 4=MEDIAN 5=TYPICAL 6=WEIGHTED";
extern string _MOVING_AVERAGES2 = "_______MA INDICATOR 2______";
extern int MA_Period2 = 110;
extern int MA_Method2 = 0;
extern string MA_MethoD2 = "0=simple 1=exponential 2=smoothed 3=linear weighted";
extern int aplied_price2 = 0;
extern string aplied_pricE2 = "0=CLOSE 1=OPEN 2=HIGH 3=LOW 4=MEDIAN 5=TYPICAL 6=WEIGHTED";
extern string _TIMEFILTER = "_______ TIME FILTER BROKER TIME _______";
extern bool Use_TimeFilter = TRUE;
extern int StartHour = 0;
extern int EndHour = 24;
int gi_216;
int gi_220;
int gi_224;
string gs_unused_228;
double g_lots_236;
double g_lots_244;
double g_minlot_252;
int gi_260;
int gi_264;
int g_slippage_268 = 10;
int gi_272;
int gi_276;
double g_order_lots_280;
double g_order_open_price_288;
double g_order_lots_296;
double g_order_open_price_304;
double g_order_open_price_312;
double g_order_lots_320;
int g_cmd_328;
int g_count_332;
int g_count_336;
int g_pos_340;
int g_count_344;
int g_count_348;
int g_datetime_352;
int g_datetime_356;
double g_ima_360;
double g_ima_368;
int gi_376 = 17;
int gi_380 = 70;
int gi_384;
int gi_388;

int init() {
   if (!IsExpertEnabled()) Alert("EA NOT Active, Please CLICK EXPERT ADVISOR");
   if (!IsTradeAllowed()) Alert("EA NOT ACTIVE, PLEASE RIGHT AT ALLOW LIVE TRADING");
   gi_384 = Magic - 1832;
   gi_388 = Magic - 364;
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   g_minlot_252 = MarketInfo(Symbol(), MODE_MINLOT);
   if (g_minlot_252 / 0.01 == 1.0) gi_260 = 2;
   else gi_260 = 1;
   if (10.0 * MarketInfo(Symbol(), MODE_LOTSTEP) < 1.0) gi_260 = 2;
   else gi_260 = 1;
   if (Digits == 5 || Digits == 3 || Symbol() == "GOLD" || Symbol() == "GOLD." || Symbol() == "GOLDm") {
      gi_264 = 10;
      g_slippage_268 = 100;
   } else gi_264 = 1;
   g_lots_236 = NormalizeDouble(MarketInfo(Symbol(), MODE_MINLOT), gi_260);
   g_lots_244 = NormalizeDouble(MarketInfo(Symbol(), MODE_MAXLOT), gi_260);
   if (Lots < g_lots_236) Lots = g_lots_236;
   if (Lots > g_lots_244) Lots = g_lots_244;
   Lots = NormalizeDouble(Lots, gi_260);
   gi_276 = NormalizeDouble(MarketInfo(Symbol(), MODE_STOPLEVEL), 2);
   gi_272 = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD), 2);
   if (gi_108 * gi_264 < gi_276 + gi_272 && gi_108 != 0) gi_108 = (gi_276 + gi_272) / gi_264;
   getOpenOrders(gi_384, TakeProfit1, StopLoss, gi_108);
   getOpenOrders(gi_388, TakeProfit2, StopLoss, gi_108);
   g_ima_360 = iMA(NULL, 0, MA_Period1, 0, MA_Method1, aplied_price1, 0);
   g_ima_368 = iMA(NULL, 0, MA_Period2, 0, MA_Method2, aplied_price2, 0);
   openord(gi_384);
   if (TimeFilter() && g_datetime_352 != iTime(Symbol(), 0, 0) && kadaluarsa() && LoginNumber()) {
      if (buy_MA1())
         if (OPEN(Symbol(), OP_BUY, Blue, Lots, g_slippage_268, Ask, 0, StopLoss, TakeProfit1, "", gi_384)) g_datetime_352 = iTime(Symbol(), 0, 0);
      if (sell_MA1())
         if (OPEN(Symbol(), OP_SELL, Red, Lots, g_slippage_268, Bid, 0, StopLoss, TakeProfit1, "", gi_384)) g_datetime_352 = iTime(Symbol(), 0, 0);
   }
   openord(gi_388);
   if (TimeFilter() && g_datetime_356 != iTime(Symbol(), 0, 0) && kadaluarsa() && LoginNumber()) {
      if (buy_MA2())
         if (OPEN(Symbol(), OP_BUY, Blue, Lots, g_slippage_268, Ask, 0, StopLoss, TakeProfit2, "", gi_388)) g_datetime_356 = iTime(Symbol(), 0, 0);
      if (sell_MA2())
         if (OPEN(Symbol(), OP_SELL, Red, Lots, g_slippage_268, Bid, 0, StopLoss, TakeProfit2, "", gi_388)) g_datetime_356 = iTime(Symbol(), 0, 0);
   }
   komentar(1, "MAGIC", DoubleToStr(Magic, 0));
   komentar(2, "NAMA", AccountName());
   komentar(3, "No. ACC", AccountNumber());
   komentar(4, "BROKER", AccountCompany());
   komentar(5, "LEVERAGE", "1:" + DoubleToStr(AccountLeverage(), 0));
   komentar(6, "BALANCE", DoubleToStr(AccountBalance(), 2));
   komentar(7, "EQUITY", DoubleToStr(AccountEquity(), 2));
   return (0);
}

int sell_MA1() {
   if (iClose(Symbol(), PERIOD_M1, 1) < g_ima_360 + gi_376 * gi_264 * Point && iClose(Symbol(), PERIOD_M1, 0) >= g_ima_360 + gi_376 * gi_264 * Point) return (1);
   return (0);
}

int buy_MA1() {
   if (iClose(Symbol(), PERIOD_M1, 1) > g_ima_360 - gi_376 * gi_264 * Point && iClose(Symbol(), PERIOD_M1, 0) <= g_ima_360 - gi_376 * gi_264 * Point) return (1);
   return (0);
}

int sell_MA2() {
   if (iClose(Symbol(), PERIOD_M5, 1) < g_ima_368 + gi_380 * gi_264 * Point && iClose(Symbol(), PERIOD_M5, 0) >= g_ima_368 + gi_380 * gi_264 * Point) return (1);
   return (0);
}

int buy_MA2() {
   if (iClose(Symbol(), PERIOD_M5, 1) > g_ima_368 - gi_380 * gi_264 * Point && iClose(Symbol(), PERIOD_M5, 0) <= g_ima_368 - gi_380 * gi_264 * Point) return (1);
   return (0);
}

void komentar(int ai_0, string as_4, string as_12) {
   int li_20;
   int li_24;
   if ((!IsTradeAllowed()) || !IsExpertEnabled()) {
      ObjectDelete("baris0");
      return;
   }
   switch (ai_0) {
   case 1:
      li_20 = 40;
      li_24 = 60;
      break;
   case 2:
      li_20 = 40;
      li_24 = 75;
      break;
   case 3:
      li_20 = 40;
      li_24 = 90;
      break;
   case 4:
      li_20 = 40;
      li_24 = 105;
      break;
   case 5:
      li_20 = 40;
      li_24 = 120;
      break;
   case 6:
      li_20 = 40;
      li_24 = 135;
      break;
   case 7:
      li_20 = 40;
      li_24 = 150;
      break;
   case 8:
      li_20 = 40;
      li_24 = 165;
      break;
   case 9:
      li_20 = 40;
      li_24 = 180;
      break;
   case 10:
      li_20 = 40;
      li_24 = 195;
      break;
   case 11:
      li_20 = 40;
      li_24 = 210;
      break;
   case 12:
      li_20 = 40;
      li_24 = 225;
      break;
   case 13:
      li_20 = 40;
      li_24 = 240;
      break;
   case 14:
      li_20 = 40;
      li_24 = 255;
      break;
   case 15:
      li_20 = 40;
      li_24 = 270;
      break;
   case 16:
      li_20 = 40;
      li_24 = 285;
      break;
   case 17:
      li_20 = 40;
      li_24 = 300;
   }
   Monitor("baris0", WindowExpertName() + " IS RUNNING", 10, 40, 20, Yellow, 0);
   Monitor("baris00", "HAK MILIK TERPERLIHARA SARJAN KERORO", 8, 40, 10, Yellow, 2);
   Monitor("baris" + ai_0, as_4, 8, li_20, li_24, Yellow, 0);
   Monitor("baris_" + ai_0, ":", 8, li_20 + 150, li_24, Yellow, 0);
   Monitor("baris-" + ai_0, as_12, 8, li_20 + 160, li_24, Yellow, 0);
}

void Monitor(string a_name_0, string a_text_8, int a_fontsize_16, int a_x_20, int a_y_24, color a_color_28, int a_corner_32) {
   if (ObjectFind(a_name_0) < 0) ObjectCreate(a_name_0, OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet(a_name_0, OBJPROP_CORNER, a_corner_32);
   ObjectSet(a_name_0, OBJPROP_XDISTANCE, a_x_20);
   ObjectSet(a_name_0, OBJPROP_YDISTANCE, a_y_24);
   ObjectSetText(a_name_0, a_text_8, a_fontsize_16, "Tahoma", a_color_28);
}

int OPEN(string a_symbol_0, int a_cmd_8, color a_color_12, double a_lots_16, double a_slippage_24, double a_price_32, int ai_40, double ad_44, double ad_52, string a_comment_60, int a_magic_68) {
   double price_72;
   double price_80;
   int ticket_88 = 0;
   while (ticket_88 <= 0) {
      RefreshRates();
      gi_276 = NormalizeDouble(MarketInfo(Symbol(), MODE_STOPLEVEL), 0);
      gi_272 = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD), 0);
      if (a_cmd_8 == OP_BUY || a_cmd_8 == OP_BUYLIMIT || a_cmd_8 == OP_BUYSTOP) {
         if (ad_52 * gi_264 >= gi_276 && (!ai_40)) price_72 = a_price_32 + ad_52 * gi_264 * Point;
         else price_72 = 0;
         if (ad_44 * gi_264 >= gi_276 + gi_272 && (!ai_40)) price_80 = a_price_32 - ad_44 * gi_264 * Point;
         else price_80 = 0;
      }
      if (a_cmd_8 == OP_SELL || a_cmd_8 == OP_SELLLIMIT || a_cmd_8 == OP_SELLSTOP) {
         if (ad_52 * gi_264 >= gi_276 && (!ai_40)) price_72 = a_price_32 - ad_52 * gi_264 * Point;
         else price_72 = 0;
         if (ad_44 * gi_264 >= gi_276 + gi_272 && (!ai_40)) price_80 = a_price_32 + ad_44 * gi_264 * Point;
         else price_80 = 0;
      }
      ticket_88 = OrderSend(a_symbol_0, a_cmd_8, a_lots_16, a_price_32, a_slippage_24, price_80, price_72, a_comment_60, a_magic_68, 0, a_color_12);
      if (ticket_88 > 0) return (1);
      Sleep(1000);
      continue;
      return (1);
   }
   return (0);
}

int TimeFilter() {
   gi_216 = EndHour + gi_224;
   gi_220 = StartHour + gi_224;
   if (StartHour + gi_224 < 0) gi_220 = StartHour + gi_224 + 24;
   if (EndHour + gi_224 < 0) gi_216 = EndHour + gi_224 + 24;
   if (StartHour + gi_224 > 24) gi_220 = StartHour + gi_224 - 24;
   if (EndHour + gi_224 > 24) gi_216 = EndHour + gi_224 - 24;
   if (Use_TimeFilter == FALSE) {
      gs_unused_228 = "";
      return (1);
   }
   if (gi_220 < gi_216) {
      if (Hour() >= gi_220 && Hour() < gi_216) {
         gs_unused_228 = "";
         return (1);
      }
      gs_unused_228 = "WARNING: Trading diluar Time Filter, No Open Position\n";
      return (0);
   }
   if (gi_220 > gi_216) {
      if (Hour() >= gi_220 || Hour() < gi_216) {
         gs_unused_228 = "";
         return (1);
      }
      gs_unused_228 = "WARNING: Trading diluar Time Filter, No Open Position\n";
      return (0);
   }
   return (0);
}

double getPipValue(double ad_0, int ai_8) {
   double ld_ret_12;
   RefreshRates();
   if (ai_8 == 1) ld_ret_12 = NormalizeDouble(ad_0, Digits) - NormalizeDouble(Ask, Digits);
   else ld_ret_12 = NormalizeDouble(Bid, Digits) - NormalizeDouble(ad_0, Digits);
   ld_ret_12 /= Point;
   return (ld_ret_12);
}

void getOpenOrders(int a_magic_0, double ad_4, double ad_12, double ad_20) {
   double ld_28;
   int order_total_36 = OrdersTotal();
   for (int pos_40 = 0; pos_40 < order_total_36; pos_40++) {
      OrderSelect(pos_40, SELECT_BY_POS, MODE_TRADES);
      if (OrderType() == OP_BUY || OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == a_magic_0) {
         ld_28 = getPipValue(OrderOpenPrice(), OrderType());
         if (ad_4 != 0.0) takeProfit(ad_4, ld_28, OrderTicket());
         if (ad_12 != 0.0) killTrade(ad_12, ld_28, OrderTicket());
         if (ad_20 != 0.0) TrailingPositions(ad_20, 1, OrderTicket());
      }
   }
}

void takeProfit(double ad_0, int ai_8, int a_ticket_12) {
   int li_unused_16;
   if (OrderSelect(a_ticket_12, SELECT_BY_TICKET) == TRUE) {
      li_unused_16 = MarketInfo(Symbol(), MODE_SPREAD);
      if (ai_8 >= ad_0 * gi_264) {
         if (OrderType() == OP_SELL) OrderClose(a_ticket_12, OrderLots(), Ask, g_slippage_268, Red);
         if (OrderType() == OP_BUY) OrderClose(a_ticket_12, OrderLots(), Bid, g_slippage_268, Blue);
      }
   }
}

void killTrade(double ad_0, int ai_8, int a_ticket_12) {
   if (OrderSelect(a_ticket_12, SELECT_BY_TICKET) == TRUE) {
      if (ai_8 <= (-ad_0) * gi_264) {
         if (OrderType() == OP_SELL) OrderClose(a_ticket_12, OrderLots(), Ask, g_slippage_268, Red);
         if (OrderType() == OP_BUY) OrderClose(a_ticket_12, OrderLots(), Bid, g_slippage_268, Blue);
      }
   }
}

void TrailingPositions(double ad_0, double ad_8, int a_ticket_16) {
   if (OrderType() == OP_BUY) {
      if (NormalizeDouble(Bid, Digits) - NormalizeDouble(OrderOpenPrice(), Digits) >= NormalizeDouble(ad_0 * gi_264 * Point, Digits)) {
         if (NormalizeDouble(OrderStopLoss(), Digits) < NormalizeDouble(Bid - (ad_0 + ad_8 - 1.0) * gi_264 * Point, Digits) || NormalizeDouble(OrderStopLoss(), Digits) == 0.0) {
            OrderModify(a_ticket_16, OrderOpenPrice(), NormalizeDouble(Bid - ad_0 * gi_264 * Point, Digits), OrderTakeProfit(), 0, CLR_NONE);
            return;
         }
      }
   }
   if (OrderType() == OP_SELL) {
      if (NormalizeDouble(OrderOpenPrice(), Digits) - NormalizeDouble(Ask, Digits) >= NormalizeDouble(ad_0 * gi_264 * Point, Digits)) {
         if (NormalizeDouble(OrderStopLoss(), Digits) > NormalizeDouble(Ask + (ad_0 + ad_8 - 1.0) * gi_264 * Point, Digits) || NormalizeDouble(OrderStopLoss(), Digits) == 0.0) {
            OrderModify(a_ticket_16, OrderOpenPrice(), NormalizeDouble(Ask + ad_0 * gi_264 * Point, Digits), OrderTakeProfit(), 0, CLR_NONE);
            return;
         }
      }
   }
}

void openord(int a_magic_0) {
   g_count_336 = 0;
   g_count_344 = 0;
   g_count_348 = 0;
   g_count_332 = 0;
   for (g_pos_340 = 0; g_pos_340 < OrdersTotal(); g_pos_340++) {
      OrderSelect(g_pos_340, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == a_magic_0 && OrderType() == OP_BUY || OrderType() == OP_SELL) {
         g_count_336++;
         g_order_open_price_312 = OrderOpenPrice();
         g_order_lots_320 = OrderLots();
         g_cmd_328 = OrderType();
      }
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP || OrderType() == OP_SELLLIMIT) g_count_332++;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() == OP_BUY) {
         g_count_344++;
         g_order_open_price_304 = OrderOpenPrice();
         g_order_lots_296 = OrderLots();
      }
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() == OP_SELL) {
         g_count_348++;
         g_order_open_price_288 = OrderOpenPrice();
         g_order_lots_280 = OrderLots();
      }
   }
}

int kadaluarsa() {
   int str2time_0 = StrToTime(gs_116);
   if (TimeCurrent() > str2time_0) {
      Alert("Expert Advisor has expired");
      return (0);
   }
   return (1);
}

int LoginNumber() {
   if (AccountNumber() == g_acc_number_112 || g_acc_number_112 == 0 || IsDemo() || IsTesting()) return (1);
   Alert("Login Number no valid ");
   return (0);
}