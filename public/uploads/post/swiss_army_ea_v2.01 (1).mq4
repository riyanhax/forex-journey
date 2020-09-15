
#property copyright "Copyright © 2007, Ryan Klefas (Base 1.8)"
#property link      "Modified to be 5 difit compatible & added Spread adjust"

#define Delay 300

#include <stdlib.mqh>

extern string input_action = "==== Action Inputs ====";
extern double TakeProfit = 0.0;
extern double Stoploss = 0.0;
extern bool AdjustForSpread = true;
extern string manage = "==== Stop Management ====";
extern double BreakEvenAt = 3.0;
extern double TrailingStop = 3.0;
extern double BreakEvenSlide = 0.0;
extern bool OnlyTrailProfits = true;

extern string id = "==== Identity Settings ====";
extern bool Symbol_Specific = false;
extern bool MagicNum_Specific = false;
extern int MagicNumber = 9999;
extern bool SelectiveScan = false;
extern bool RequireAllConditions = false;
extern string cond = "==== Conditions: General ====";
extern bool Immediate_Activation = true;
extern bool Time_Activation = false;
extern int Time_Hour = 23;
extern int Time_Minute = 55;
extern int Minimum_FreeMargin = 0;
extern bool FreeMargin_LessThan = false;
extern string pro_cond = "==== Conditions: Profit-Based ====";
extern int MaxProfit_Dollar = 0;
extern double MaxProfit_Pip = 0.0;
extern int MaxProfit_Percent = 0;
extern string loss_cond = "==== Conditions: Loss-Based ====";
extern int MaxLoss_Dollar = 0;
extern double MaxLoss_Pip = 0.0;
extern int MaxLoss_Percent = 0;
extern string action = "==== Actions: General ====";
extern bool CloseOrders = false;
extern bool HedgeOrders = false;
extern string mod_action = "==== Actions: Modify Orders ====";
extern bool SetTakeProfit = true;
extern bool SetStoploss = true;
extern bool RemoveTakeProfit = false;
extern bool RemoveStoploss = false;
extern string otype = "==== Order Types: Standard ====";
extern bool Allow_All_Types = true;
extern bool Buy_Active = false;
extern bool Sell_Active = false;
extern bool Buy_Stop = false;
extern bool Sell_Stop = false;
extern bool Buy_Limit = false;
extern bool Sell_Limit = false;
extern string extra = "==== Extra Settings ====";
extern string ExpertName = "Swiss Army EA";
extern bool Disable_Comments = false;
extern int Slippage = 3;
extern string sep = "=============================";
extern string author = "Programming:  Ryan Klefas";
extern string contact = "Email:  rklefas@inbox.com";
extern string web = "Website:  www.forex-tsd.com";
int gi_348 = -1;
int gi_352 = 90;
int gi_356 = 91;
int gi_360 = 92;
int gi_364 = 93;
int g_count_380 = 0;
int g_count_384 = 0;
int g_count_388 = 0;
int g_count_392 = 0;
int g_count_396 = 0;
int g_count_400 = 0;
int gi_404 = 0;
int gi_408 = 0;
int gi_412 = 0;
int gi_416 = 0;
int gi_420 = 0;
int gi_424 = 0;
int gi_428 = 0;
int gi_432;
double gd_436 = 0.0;
double gd_444 = 0.0;
double gd_452 = 0.0;
double gd_460 = 0.0;
string gsa_468[1];
string gsa_472[1];
double gda_476[1];
double gd_480 = 0.0;
double gd_488 = 0.0;
int gi_496 = 3007;

int Factor = 1;
double Lot_Min = 0.1, Lot_Max = 10, Lot_Step = 0.1;
int Lot_Decimals = 1;





int init() {
   onScreenComment(91);

//  Adjust for 3 or 5 digit brokers.
   if (Digits ==3 || Digits == 5) {
      Factor = 10;
      MaxProfit_Pip *= 10;
      MaxLoss_Pip *= 10;
      TakeProfit *= 10;
      Stoploss *= 10;
      BreakEvenAt *= 10;
      BreakEvenSlide *= 10;
      TrailingStop *= 10;
   }

   _Get_Lot_Specifications(Lot_Min, Lot_Max, Lot_Step, Lot_Decimals);
   

   return (0);
}

int deinit() {
   onScreenComment(99);
   return (0);
}

int start() {
   commence();
   return (0);
}

void commence() {
   bool li_0 = false;
   bool li_4 = false;
   findMyOrders();
   statTracker();
   onScreenComment(98);
   if (gi_420 > 0) {
      if (BreakEvenAt > 0) breakEvenManager(BreakEvenAt, BreakEvenSlide);
      if (TrailingStop > 0) trailingStopManager(TrailingStop, OnlyTrailProfits);
   }
   if (Immediate_Activation) li_0 = TRUE;
   if (Time_Activation) {
      if (Hour() == Time_Hour && Minute() >= Time_Minute) li_0 = TRUE;
      else li_4 = TRUE;
   }
   if (MathAbs(MaxProfit_Dollar) > 0.0) {
      if (gd_436 > MathAbs(MaxProfit_Dollar)) li_0 = TRUE;
      else li_4 = TRUE;
   }
   if (MathAbs(MaxLoss_Dollar) > 0.0) {
      if (gd_436 < -1.0 * MathAbs(MaxLoss_Dollar)) li_0 = TRUE;
      else li_4 = TRUE;
   }
   if (MathAbs(MaxProfit_Pip) > 0.0) {
      if (gd_444 > MathAbs(MaxProfit_Pip)) li_0 = TRUE;
      else li_4 = TRUE;
   }
   if (MathAbs(MaxLoss_Pip) > 0.0) {
      if (gd_444 < -1.0 * MathAbs(MaxLoss_Pip)) li_0 = TRUE;
      else li_4 = TRUE;
   }
   if (MathAbs(MaxLoss_Percent) > 0.0) {
      if (balanceDeviation() < -1.0 * MathAbs(MaxLoss_Percent)) li_0 = TRUE;
      else li_4 = TRUE;
   }
   if (MathAbs(MaxProfit_Percent) > 0.0) {
      if (balanceDeviation() > MathAbs(MaxProfit_Percent)) li_0 = TRUE;
      else li_4 = TRUE;
   }
   if (MathAbs(Minimum_FreeMargin) > 0.0) {
      if (AccountFreeMargin() < Minimum_FreeMargin) li_0 = TRUE;
      else li_4 = TRUE;
   }
   if (FreeMargin_LessThan) {
      if (AccountFreeMargin() < AccountMargin()) li_0 = TRUE;
      else li_4 = TRUE;
   }
   if (RequireAllConditions) {
      if (li_0)
         if (li_4 == false) actionFunction();
   } else
      if (li_0) actionFunction();
   findMyOrders();
   statTracker();
   onScreenComment(98);
}

void onScreenComment(int ai_0) {
   string l_dbl2str_4;
   string l_dbl2str_12;
   string l_dbl2str_20;
   string l_dbl2str_28;
   string l_dbl2str_36;
   string l_dbl2str_44;
   string ls_52;
   string ls_60;
   string ls_68;
   string ls_76;
   string ls_84;
   string ls_92;
   string ls_100;
   string ls_108;
   string ls_116;
   string ls_124;
   string ls_132;
   if (Disable_Comments == false) {
      l_dbl2str_4 = DoubleToStr(balanceDeviation(), 2);
      l_dbl2str_12 = DoubleToStr(gd_436, 2);
      l_dbl2str_20 = DoubleToStr(gd_452, 2);
      l_dbl2str_28 = DoubleToStr(-gd_460, 2);
      l_dbl2str_36 = DoubleToStr(gd_480, 2);
      l_dbl2str_44 = DoubleToStr(gd_488, 2);
      ls_52 = "\n";
      ls_60 = "------------------------------------";
      ls_68 = ls_60 + ls_52;
      ls_76 = ExpertName + " run-time statistics: " + ls_52;
      if (!(TrailingStop > 0)) ls_100 = "Trailing Stop management disabled" + ls_52;
      else
         if (TrailingStop > 0) ls_100 = "Trailing Stop management enabled" + ls_52;
      if (!(BreakEvenAt > 0)) ls_92 = "Breakeven management disabled" + ls_52;
      else
         if (BreakEvenAt > 0) ls_92 = "Breakeven management enabled" + ls_52;
      if (MagicNum_Specific == false && Symbol_Specific == false) ls_84 = "Managing ALL orders in this terminal" + ls_52;
      else {
         if (MagicNum_Specific && Symbol_Specific) ls_84 = "Managing only " + Symbol() + " orders that have magic number " + MagicNumber + ls_52;
         else {
            if (MagicNum_Specific) ls_84 = "Managing all orders that have magic number " + MagicNumber + ls_52;
            else
               if (Symbol_Specific) ls_84 = "Managing all " + Symbol() + " orders " + ls_52;
         }
      }
      ls_108 = "Buy Active:  " + g_count_380 + ls_52 + "Sell Active:  " + g_count_384 + ls_52 + "Buy Stop:  " + g_count_388 + ls_52 + "Sell Stop:  " + g_count_392 + ls_52 +
         "Buy Limit:  " + g_count_396 + ls_52 + "Sell Limit:  " + g_count_400 + ls_52 + "Grand Total:  " + gi_428 + ls_52;
      ls_116 = "Date and Time:  " + TimeToStr(TimeCurrent()) + ls_52 + "Account Leverage:  " + AccountLeverage() + ":1" + ls_52;
      ls_124 = "Cash:  $" + l_dbl2str_12 + ls_52 + "Swap:  $" + l_dbl2str_20 + ls_52 + "Pips:  " + pipCount() + ls_52 + "Percent:  " + l_dbl2str_4 + "%" + ls_52;
      ls_132 = "Largest Recorded Gain:  " + l_dbl2str_44 + "%" + ls_52 + "Largest Recorded Drawdown:  " + l_dbl2str_36 + "%" + ls_52 + "Order Costs:  $" + l_dbl2str_28 +
         ls_52;
      switch (ai_0) {
      case 91:
         Comment(ls_52 + ExpertName + " is waiting for the next tick to begin.");
         return;
      case 98:
         Comment(ls_52 + ls_76 + ls_68 + ls_84 + ls_100 + ls_92 + ls_68 + ls_116 + ls_68 + ls_132 + ls_68 + ls_124 + ls_68 + ls_108);
         return;
      case 99:
         Comment(" ");
      }
   }
}

int simpleMagicGenerator() {
   return (MagicNumber);
}

bool orderBelongsToMe() {
   bool li_0 = false;
   bool li_4 = false;
   if (MagicNum_Specific) {
      if (OrderMagicNumber() == simpleMagicGenerator()) li_0 = TRUE;
   } else li_0 = TRUE;
   if (Symbol_Specific) {
      if (OrderSymbol() == Symbol()) li_4 = TRUE;
   } else li_4 = TRUE;
   if (li_4 && li_0) return (TRUE);
   return (false);
}

void findMyOrders() {
   g_count_380 = 0;
   g_count_384 = 0;
   g_count_388 = 0;
   g_count_392 = 0;
   g_count_396 = 0;
   g_count_400 = 0;
   gi_404 = 0;
   gi_408 = 0;
   gi_412 = 0;
   gi_416 = 0;
   gi_420 = 0;
   gi_424 = 0;
   gi_428 = 0;
   for (int l_pos_0 = OrdersTotal() - 1; l_pos_0 >= 0; l_pos_0--) {
      OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
      if (orderBelongsToMe()) {
         if (OrderType() == OP_BUY) g_count_380++;
         else {
            if (OrderType() == OP_SELL) g_count_384++;
            else {
               if (OrderType() == OP_BUYSTOP) g_count_388++;
               else {
                  if (OrderType() == OP_SELLSTOP) g_count_392++;
                  else {
                     if (OrderType() == OP_BUYLIMIT) g_count_396++;
                     else
                        if (OrderType() == OP_SELLLIMIT) g_count_400++;
                  }
               }
            }
         }
      }
   }
   gi_404 = g_count_388 + g_count_396;
   gi_408 = g_count_392 + g_count_400;
   gi_424 = gi_404 + gi_408;
   gi_420 = g_count_380 + g_count_384;
   gi_412 = g_count_388 + g_count_396 + g_count_380;
   gi_416 = g_count_392 + g_count_400 + g_count_384;
   gi_428 = gi_420 + gi_424;
}

void breakEvenManager(double ai_0, double ai_4) {
   double l_point_8;
   double l_bid_16;
   double l_ask_24;
   double SL_PX;
   for (int l_pos_32 = 0; l_pos_32 < OrdersTotal(); l_pos_32++) {
      OrderSelect(l_pos_32, SELECT_BY_POS, MODE_TRADES);
      if (ai_0 > 0 && orderBelongsToMe()) {
         l_bid_16 = MarketInfo(OrderSymbol(), MODE_BID);
         l_ask_24 = MarketInfo(OrderSymbol(), MODE_ASK);
         l_point_8 = MarketInfo(OrderSymbol(), MODE_POINT);
         if (OrderType() == OP_BUY) {
            if (l_bid_16 - OrderOpenPrice() >= l_point_8 * ai_0)
               if (OrderStopLoss() < OrderOpenPrice() + ai_4 * l_point_8) {
                  SL_PX = NormalizeDouble(OrderOpenPrice() + ai_4 * l_point_8 , Digits); 
                  Wait();
                  OrderModify(OrderTicket(), OrderOpenPrice(), SL_PX, OrderTakeProfit(), 0, Green);
               }
         } else {
            if (OrderType() == OP_SELL) {
               if (OrderOpenPrice() - l_ask_24 >= l_point_8 * ai_0)
                  if (OrderStopLoss() > OrderOpenPrice() - ai_4 * l_point_8 || OrderStopLoss() == 0.0) {
                     SL_PX = NormalizeDouble(OrderOpenPrice() - ai_4 * l_point_8, Digits);
                     Wait();
                     OrderModify(OrderTicket(), OrderOpenPrice(), SL_PX, OrderTakeProfit(), 0, Red);
                  }
            }
         }
      }
   }
}

void trailingStopManager(double ai_0, double ai_4) {
   double l_point_8;
   double l_bid_16;
   double l_ask_24;
   double SL_PX;
   for (int l_pos_32 = 0; l_pos_32 < OrdersTotal(); l_pos_32++) {
      OrderSelect(l_pos_32, SELECT_BY_POS, MODE_TRADES);
      if (ai_0 > 0 && orderBelongsToMe()) {
         l_bid_16 = MarketInfo(OrderSymbol(), MODE_BID);
         l_ask_24 = MarketInfo(OrderSymbol(), MODE_ASK);
         l_point_8 = MarketInfo(OrderSymbol(), MODE_POINT);
         if (OrderType() == OP_BUY) {
            if (l_bid_16 - OrderOpenPrice() > l_point_8 * ai_0 || ai_4 == 0)
               if (OrderStopLoss() < l_bid_16 - l_point_8 * ai_0) {
                  SL_PX = NormalizeDouble(l_bid_16 - l_point_8 * ai_0, Digits);
                  Wait();
                  OrderModify(OrderTicket(), OrderOpenPrice(), SL_PX, OrderTakeProfit(), 0, Green);
               }
         } else {
            if (OrderType() == OP_SELL) {
               if (OrderOpenPrice() - l_ask_24 > l_point_8 * ai_0 || ai_4 == 0)
                  if (OrderStopLoss() > l_ask_24 + l_point_8 * ai_0 || OrderStopLoss() == 0.0) {
                     SL_PX = NormalizeDouble(l_ask_24 + l_point_8 * ai_0, Digits);
                     Wait();
                     OrderModify(OrderTicket(), OrderOpenPrice(), SL_PX, OrderTakeProfit(), 0, Red);
                  }
            }
         }
      }
   }
}

void swissArmyOrderCloser() {
   for (int l_pos_0 = 0; l_pos_0 < OrdersTotal(); l_pos_0++) {
      OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
      if (orderBelongsToMe()) {
         if (orderTypeManagementAllowed(OrderType())) {
            doing("close " + OrderSymbol() + " orders.");
            positionCloser(l_pos_0);
         }
      }
   }
}

void actionFunction() {
   bool li_0 = TRUE;
   bool li_4 = TRUE;
   if (gi_428 > 0) {
      if (CloseOrders) {
         swissArmyOrderCloser();
         li_4 = false;
         li_0 = false;
      }
   }
   if (gi_420 > 0 && li_4) {
      if (HedgeOrders) {
         prepareToHedge();
         sendHedges();
      }
   }
   if (gi_420 > 0 && li_0) {
      if (SetStoploss && Stoploss > 0) modifyMyOrders(gi_364);
      else
         if (RemoveStoploss) modifyMyOrders(gi_356);
      if (SetTakeProfit && TakeProfit > 0) {
         modifyMyOrders(gi_360);
         return;
      }
      if (RemoveTakeProfit) modifyMyOrders(gi_352);
   }
}

double balanceDeviation() {
   double ld_0 = AccountBalance() + gd_436 + gd_452;
   double ld_8 = AccountBalance();
   double ld_ret_16 = 100.0 * (ld_0 / ld_8 - 1.0);
   return (ld_ret_16);
}

void doing(string as_0) {
   Print(ExpertName + " is attempting to " + as_0);
}

int pipCount() {
   int li_ret_0 = gd_444;
   return (li_ret_0);
}

void modifyMyOrders(int ai_0) {
   double TP_PX, SL_PX;
   
   color l_color_4 = Red;
   for (int l_pos_8 = OrdersTotal() - 1; l_pos_8 >= 0; l_pos_8--) {
      OrderSelect(l_pos_8, SELECT_BY_POS, MODE_TRADES);
      if (orderBelongsToMe() && orderTypeAllowed(OrderType())) {
         if (ai_0 == gi_352) {
            if (OrderTakeProfit() != 0.0) {
               doing("remove takeprofits.");
               Wait();
               OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), 0, 0, l_color_4);
            }
         } else {
            if (ai_0 == gi_360) {
               if (OrderTakeProfit() == 0.0) {
                  doing("set takeprofits.");
                  TP_PX = NormalizeDouble(takeGenerator(OrderSymbol(), OrderType(), OrderOpenPrice(), TakeProfit), Digits);
                  Wait();
                  OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), TP_PX, 0, l_color_4);
               }
            }
         }
         if (ai_0 == gi_356) {
            if (OrderStopLoss() != 0.0) {
               doing("remove stoplosses.");
               Wait();
               OrderModify(OrderTicket(), OrderOpenPrice(), 0, OrderTakeProfit(), 0, l_color_4);
            }
         } else {
            if (ai_0 == gi_364) {
               if (OrderStopLoss() == 0.0) {
                  doing("set stoplosses");
                  SL_PX = NormalizeDouble(stopGenerator(OrderSymbol(), OrderType(), OrderOpenPrice(), Stoploss), Digits);
                  Wait();
                  OrderModify(OrderTicket(), OrderOpenPrice(), SL_PX, OrderTakeProfit(), 0, l_color_4);
               }
            }
         }
      }
   }
}

void prepareToHedge() {
   ArrayResize(gsa_468, gi_420);
//   string ls_unused_0 = "\n";
   int l_index_8 = 0;
   int l_index_12 = 0;
   for (int l_pos_16 = OrdersTotal() - 1; l_pos_16 >= 0; l_pos_16--) {
      OrderSelect(l_pos_16, SELECT_BY_POS, MODE_TRADES);
      if (orderBelongsToMe() && orderTypeAllowed(OrderType())) {
         if (OrderType() == OP_BUY) {
            gsa_468[l_index_8] = OrderSymbol();
            l_index_8++;
         } else {
            if (OrderType() == OP_SELL) {
               gsa_468[l_index_8] = OrderSymbol();
               l_index_8++;
            }
         }
      }
   }
   gi_432 = createUniqueArray();
   ArrayResize(gda_476, gi_432);
   for (l_pos_16 = 0; l_pos_16 < gi_432; l_pos_16++) gda_476[l_pos_16] = 0;
   for (int l_count_20 = 0; l_count_20 < gi_432; l_count_20++) {
      for (l_pos_16 = OrdersTotal() - 1; l_pos_16 >= 0; l_pos_16--) {
         OrderSelect(l_pos_16, SELECT_BY_POS, MODE_TRADES);
         if (orderBelongsToMe()) {
            if (OrderSymbol() == gsa_472[l_index_12]) {
               if (OrderType() == OP_BUY) gda_476[l_index_12] += OrderLots();
               if (OrderType() == OP_SELL) gda_476[l_index_12] = gda_476[l_index_12] - OrderLots();
            }
         }
      }
      l_index_12++;
   }
}

int createUniqueArray() {
   bool li_0 = false;
   int li_ret_4 = 0;
   ArrayResize(gsa_472, gi_420);
   for (int l_index_8 = 0; l_index_8 < gi_420; l_index_8++) gsa_472[l_index_8] = "empty";
   for (int l_index_12 = 0; l_index_12 < gi_420; l_index_12++) {
      for (int l_index_16 = 0; l_index_16 < gi_420; l_index_16++)
         if (gsa_472[l_index_16] == gsa_468[l_index_12]) li_0 = TRUE;
      if (li_0 == false) {
         gsa_472[li_ret_4] = gsa_468[l_index_12];
         li_ret_4++;
      }
      li_0 = false;
   }
   ArrayResize(gsa_472, li_ret_4);
   return (li_ret_4);
}

void sendHedges() {
   double ld_4;
   double l_price_16;
   bool li_0 = false;
   bool li_12 = gi_348;
   for (int l_index_24 = 0; l_index_24 < gi_432; l_index_24++) {
      if (gda_476[l_index_24] < 0.0) {
         li_0 = TRUE;
         li_12 = false;
         ld_4 = MathAbs(gda_476[l_index_24]);
         l_price_16 = MarketInfo(gsa_472[l_index_24], MODE_ASK);
      } else {
         if (gda_476[l_index_24] > 0.0) {
            li_0 = TRUE;
            li_12 = TRUE;
            ld_4 = gda_476[l_index_24];
            l_price_16 = MarketInfo(gsa_472[l_index_24], MODE_BID);
         }
      }
      if (li_0) {
         doing("hedge active " + gsa_472[l_index_24] + " orders.");
         universalOrderTaker(gsa_472[l_index_24], li_12, ld_4, l_price_16, stopGenerator(gsa_472[l_index_24], li_12, l_price_16, Stoploss), takeGenerator(gsa_472[l_index_24], li_12, l_price_16, TakeProfit), commentString(), simpleMagicGenerator());
      }
      li_0 = false;
   }
}

string commentString() {
   string l_str_concat_0 = StringConcatenate(ExpertName, ": Hedge Order");
   return (l_str_concat_0);
}

void statTracker() {
   gd_436 = 0;
   gd_444 = 0;
   gd_452 = 0;
   gd_460 = 0;
   if (balanceDeviation() > gd_488) gd_488 = balanceDeviation();
   if (balanceDeviation() < gd_480) gd_480 = balanceDeviation();
   for (int l_pos_0 = OrdersTotal() - 1; l_pos_0 >= 0; l_pos_0--) {
      OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
      if (orderBelongsToMe() && orderTypeAllowed(OrderType()) || SelectiveScan == false) {
         if (OrderType() == OP_BUY) gd_444 += (MarketInfo(OrderSymbol(), MODE_BID) - OrderOpenPrice()) / MarketInfo(OrderSymbol(), MODE_POINT);
         else
            if (OrderType() == OP_SELL) gd_444 += (OrderOpenPrice() - MarketInfo(OrderSymbol(), MODE_ASK)) / MarketInfo(OrderSymbol(), MODE_POINT);
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) {
            gd_436 += OrderProfit();
            gd_452 += OrderSwap();
            gd_460 += OrderLots() * MarketInfo(OrderSymbol(), MODE_SPREAD) * MarketInfo(OrderSymbol(), MODE_TICKVALUE);
         }
      }
   }
}

void Wait() {
   while (IsTradeContextBusy() || !IsTradeAllowed()) Sleep(Delay);
}

int orderTypeAllowed(int ai_0) {
   switch (ai_0) {
   case 0:
      if (Buy_Active || Allow_All_Types) return (1);
      return (0);
   case 1:
      if (Sell_Active || Allow_All_Types) return (1);
      return (0);
   case 4:
      if (Buy_Stop || Allow_All_Types) return (1);
      return (0);
   case 5:
      if (Sell_Stop || Allow_All_Types) return (1);
      return (0);
   case 2:
      if (Buy_Limit || Allow_All_Types) return (1);
      return (0);
   case 3:
      if (Sell_Limit || Allow_All_Types) return (1);
      return (0);
   }
   return (0);
}

void universalOrderCloser(int a_pos_0, int ai_4, double a_ord_lots_8) {
   int l_slippage_16 = Slippage;
   double PX;
   
   a_ord_lots_8 = NormalizeDouble(a_ord_lots_8, Lot_Decimals);

   OrderSelect(a_pos_0, ai_4, MODE_TRADES);
   if (OrderTicket() > 0) {
      if (a_ord_lots_8 <= 0.0) a_ord_lots_8 = OrderLots();
      switch (OrderType()) {
      case OP_SELLLIMIT:
      case OP_SELLSTOP:
      case OP_BUYLIMIT:
      case OP_BUYSTOP:
         Wait();
         OrderDelete(OrderTicket());
         return;
      case OP_SELL:
         PX = NormalizeDouble(MarketInfo(OrderSymbol(), MODE_ASK), Digits);
         Wait();
         OrderClose(OrderTicket(), a_ord_lots_8, PX, l_slippage_16, CLR_NONE);
         return;
      case OP_BUY:
         PX = NormalizeDouble(MarketInfo(OrderSymbol(), MODE_BID), Digits);
         Wait();
         OrderClose(OrderTicket(), a_ord_lots_8, PX, l_slippage_16, CLR_NONE);
      }
   }
}

void positionCloser(int ai_0) {
   universalOrderCloser(ai_0, SELECT_BY_POS, 0);
}

bool orderTypeManagementAllowed(int ai_0) {
   switch (ai_0) {
   case 0:
      if (Buy_Active || Allow_All_Types) return (TRUE);
      return (false);
   case 1:
      if (Sell_Active || Allow_All_Types) return (TRUE);
      return (false);
   case 4:
      if (Buy_Stop || Allow_All_Types) return (TRUE);
      return (false);
   case 5:
      if (Sell_Stop || Allow_All_Types) return (TRUE);
      return (false);
   case 2:
      if (Buy_Limit || Allow_All_Types) return (TRUE);
      return (false);
   case 3:
      if (Sell_Limit || Allow_All_Types) return (TRUE);
      return (false);
   }
   return (false);
}

void universalOrderTaker(string Pair, int Buy_Sell, double Lots, double Px, double SL_Px, double TP_Px, string comment, int Magic) {
   string ls_60;
   int Slip = Slippage;
   Lots = NormalizeDouble(Lots, Lot_Decimals);
   Px = NormalizeDouble(Px, Digits);
   SL_Px = NormalizeDouble(SL_Px, Digits);
   TP_Px = NormalizeDouble(TP_Px, Digits);
   switch (Buy_Sell) {
   case OP_SELLSTOP:
      ls_60 = "SELLSTOP";
      break;
   case OP_SELLLIMIT:
      ls_60 = "SELLLIMIT";
      break;
   case OP_BUYSTOP:
      ls_60 = "BUYSTOP";
      break;
   case OP_BUYLIMIT:
      ls_60 = "BUYLIMIT";
      break;
   case OP_SELL:
      ls_60 = "SELL";
      break;
   case OP_BUY:
      ls_60 = "BUY";
   }
   Wait();
   int l_ticket_72 = OrderSend(Pair, Buy_Sell, Lots, Px, Slip, SL_Px, TP_Px, comment, Magic, 0, Violet);
   if (l_ticket_72 > 0) {
      if (OrderSelect(l_ticket_72, SELECT_BY_TICKET, MODE_TRADES)) Print(ExpertName + " " + ls_60 + " order at ", OrderOpenPrice());
   } else Print("Error opening " + ls_60 + " order:  ", ErrorDescription(GetLastError()));
}


//takeGenerator(OrderSymbol(), OrderType(), OrderOpenPrice(), TakeProfit), 0, l_color_4);
double takeGenerator(string Pair, int Buy_Sell, double Open_Px, double TP_Pips) {
   double l_point_24 = MarketInfo(Pair, MODE_POINT);
   double Spread = 0;
   RefreshRates();
   if (AdjustForSpread) Spread = (Ask - Bid);
   if (TP_Pips == 0) return (0);
   if (Buy_Sell == 0) return (NormalizeDouble(Open_Px + TP_Pips * l_point_24 + Spread, Digits));
   if (Buy_Sell == 1) return (NormalizeDouble(Open_Px - TP_Pips * l_point_24, Digits));
   return (0);
}

double stopGenerator(string Pair, int Buy_Sell, double Open_Px, double SL_Pips) {
   double l_point_24 = MarketInfo(Pair, MODE_POINT);
   double Spread = 0;
   RefreshRates();
   if (AdjustForSpread) Spread = (Ask - Bid);
   if (SL_Pips == 0) return (0);
   if (Buy_Sell == 0) return (NormalizeDouble(Open_Px - SL_Pips * l_point_24, Digits));
   if (Buy_Sell == 1) return (NormalizeDouble(Open_Px + SL_Pips * l_point_24 - Spread, Digits));
   return (0);
}


//+------------------------------------------------------------------+
//| _Get_Lot_Specifications.                                   |
//+------------------------------------------------------------------+
void _Get_Lot_Specifications(double& _Lot_Minimum, double& _Lot_Maximum, double& _Lot_Step, int& _Lot_Decimal) {

   if (!IsTesting() ) {  //  Market Info not available for testing.
      _Lot_Minimum = MarketInfo(Symbol(), MODE_MINLOT);
      _Lot_Maximum = MarketInfo(Symbol(), MODE_MAXLOT);
      _Lot_Step = MarketInfo(Symbol(), MODE_LOTSTEP);
   }
   else {   //  Testing...
      _Lot_Step = _Lot_Minimum;
   }
   if (_Lot_Minimum <= 0.1) _Lot_Decimal = 2;
   else if (_Lot_Minimum < 1) _Lot_Decimal = 1;
   else _Lot_Decimal = 0;
   
   return;
}


