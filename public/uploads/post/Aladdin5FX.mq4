
#property copyright "Copyright © 2011, Finans Plus Company "
#property link      "http://www.finans-plus.ru"

extern string EA_Name = "Aladdin 5 FX";
extern string Creator = "Copyright © 2011, Finans Plus Company";
extern string Options1 = "-------Trading-------";
int gi_104 = 3;
extern bool CloseOnlyProfit = TRUE;
extern int TakeProfit = 34;
extern int StopLoss = 22;
extern double MaxSpread = 2.0;
extern double Slippage = 2.0;
extern string Options2 = "-------MoneyManagement-------";
extern double AutoMM = 10.0;
extern double AutoMM_Max = 20.0;
extern double FixedLot = 0.01;
extern double StartLot = 0.0;
extern double MaximalLot = 1000.0;
extern bool RecoveryMode = TRUE;
extern string Options3 = "---If RecoveryMode = TRUE, setup---";
extern int MaxAnalizCount = 50;
extern double Risk = 25.0;
extern double RiskFreeMargin = 0.5;
extern double RiskMargin = 0.0;
extern double MultiLotPercent = 2.0;
extern string Options4 = "-------Parametres Orders-------";
extern bool UseStopLevels = TRUE;
extern double StopOrder = 0.0;
extern double TimeStopOrder = 20.0;
extern int IFStop = 20;
extern double KStop = 1.0;
extern bool ModifStop = TRUE;
bool gi_276 = TRUE;
extern double OrderDol = 2.0;
extern double KDol = 2.0;
extern bool ModifDol = FALSE;
extern bool ModifTake = FALSE;
extern double LimitOrder = 0.0;
extern double TimeL = 11.0;
extern double KLimit = 1.5;
extern bool DeleteLimit = TRUE;
extern bool DeleteLimitU = TRUE;
extern int ReversOrder = 0;
extern double KRevers = 2.0;
extern double TimeRewers = 11.0;
extern string Options5 = "-------Trailing-------";
extern double TrailingStop = 0.0;
extern double TrailingStep = 0.0;
extern double Utral = 10.0;
extern string Options6 = "-------Professional options-------";
extern bool Long = TRUE;
extern bool Short = TRUE;
extern int NormalizeLot = 2;
int g_timeframe_408 = PERIOD_M5;
double gd_412 = 10.0;
bool gi_420 = FALSE;
extern bool WriteLog = TRUE;
extern bool WriteDebugLog = TRUE;
extern bool PrintLogOnChart = TRUE;
string gs_unused_436 = "Время торговой паузы";
bool gi_444 = FALSE;
double gd_448 = 14.0;
double gd_456 = 1.0;
double gd_464 = 5.0;
double gd_472 = 1.0;
double gd_480 = 0.0;
double gd_488 = 6.0;
extern int MagicNumber = 567833;
extern int MagicNumber1 = 567834;
extern int MagicNumber2 = 567835;
extern int MagicNumber3 = 567836;
extern int MagicNumber4 = 567837;
int g_color_516 = Gold;
int g_color_520 = Lime;
extern string Options7 = "-------Optimization-------";
extern string _NotLoss = "---";
extern int SecProfit = 2;
extern int SecProfitTr = 8;
extern int MaxLossPoints = -65;
double g_pips_552 = 0.0;
extern string _Indicator_Long = "---";
extern int iMA_PeriodLONG = 55;
extern int iCCI_PeriodLONG = 18;
extern int iATR_PeriodLONG = 14;
extern int iWPR_PeriodLONG = 11;
extern int iMA_LONG_Open_a = 18;
extern int iMA_LONG_Open_b = 39;
extern int iWPR_LONG_Open_a = 1;
extern int iWPR_LONG_Open_b = 5;
extern string _Indicator_Short = "---";
extern int iMA_PeriodShort = 55;
extern int iCCI_PeriodShort = 18;
extern int iATR_PeriodShort = 14;
extern int iWPR_PeriodShort = 11;
extern int iMA_Short_Open_a = 15;
extern int iMA_Short_Open_b = 39;
extern int iWPR_Short_Open_a = 1;
extern int iWPR_Short_Open_b = 5;
extern string _AddOpenFilters = "---";
extern int FilterATR = 6;
extern double iCCI_OpenFilter = 150.0;
extern string _CloseOrderFilters = "---";
extern int Price_Filter_Close = 14;
extern int iWPR_Filter_Close = 90;
extern string End = "*** Good Luck ***";
double gd_684;
int gi_692;
int gi_unused_696 = 0;
int gi_700;
double gd_704;
string gs_712;
double gd_720 = 3.0;
int g_slippage_728;
int g_slippage_732;
int gi_736 = 1;
double gd_740;
bool gi_748;
string g_comment_752 = "Aladdin5FX";
int gi_760 = 0;
double g_minlot_764 = 0.01;
double gd_772 = 0.01;
double g_lotstep_780 = 0.01;
int gi_788 = 100000;
double g_marginrequired_792 = 1000.0;
double gd_800 = 1.0;
double gd_808;
int gi_816;
int gi_820;
int gi_824;
int gi_828;
int gi_832;
int gi_836;
int g_color_840 = Green;
int g_color_844 = Red;
int g_color_848 = DodgerBlue;
int g_color_852 = DeepPink;
bool gi_856 = TRUE;
string gs_860 = "alert.wav";
string gs_unused_868 = "alert.wav";
int gi_876 = 1;
bool gi_880 = FALSE;

void init() {
   if (IsTesting() && (!IsVisualMode())) PrintLogOnChart = FALSE;
   if (!PrintLogOnChart) Comment("");
   gs_712 = Symbol();
   if (Digits < 4) {
      gd_684 = 0.01;
      gi_692 = 2;
      gd_704 = 0.009;
   } else {
      gd_684 = 0.0001;
      gi_692 = 4;
      gd_704 = 0.00009;
   }
   if (Digits == 4) gi_700 = 1;
   if (Digits == 5) gi_700 = 10;
   if (Digits == 3) gi_700 = gd_412;
   if (Digits == 2) gi_700 = gd_412 / 10.0;
   g_slippage_728 = Slippage * MathPow(10, Digits - gi_692);
   g_slippage_732 = gd_720 * MathPow(10, Digits - gi_692);
   gd_740 = NormalizeDouble(MaxSpread * gd_684, gi_692 + 1);
   g_minlot_764 = MarketInfo(Symbol(), MODE_MINLOT);
   gd_772 = MarketInfo(Symbol(), MODE_MAXLOT);
   if (gd_772 > MaximalLot) gd_772 = MaximalLot;
   gi_788 = MarketInfo(Symbol(), MODE_LOTSIZE);
   g_lotstep_780 = MarketInfo(Symbol(), MODE_LOTSTEP);
   g_marginrequired_792 = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
   double ld_0 = 0;
   if (StringSubstr(AccountCurrency(), 0, 3) == "JPY") {
      ld_0 = MarketInfo("USDJPY" + StringSubstr(Symbol(), 6), MODE_BID);
      if (ld_0 > 0.1) gd_800 = ld_0;
      else gd_800 = 84;
   }
   if (StringSubstr(AccountCurrency(), 0, 3) == "GBP") {
      ld_0 = MarketInfo("GBPUSD" + StringSubstr(Symbol(), 6), MODE_BID);
      if (ld_0 > 0.1) gd_800 = 1 / ld_0;
      else gd_800 = 0.6211180124;
   }
   if (StringSubstr(AccountCurrency(), 0, 3) == "EUR") {
      ld_0 = MarketInfo("EURUSD" + StringSubstr(Symbol(), 6), MODE_BID);
      if (ld_0 > 0.1) gd_800 = 1 / ld_0;
      else gd_800 = 0.7042253521;
   }
   gi_816 = iWPR_LONG_Open_a;
   gi_820 = iWPR_LONG_Open_b;
   gi_824 = 100 - iWPR_Short_Open_a;
   gi_828 = 100 - iWPR_Short_Open_b;
   gi_832 = iWPR_Filter_Close;
   gi_836 = 100 - iWPR_Filter_Close;
}

int deinit() {
   if (ObjectFind("BKGR") >= 0) ObjectDelete("BKGR");
   if (ObjectFind("BKGR2") >= 0) ObjectDelete("BKGR2");
   if (ObjectFind("BKGR3") >= 0) ObjectDelete("BKGR3");
   if (ObjectFind("BKGR4") >= 0) ObjectDelete("BKGR4");
   if (ObjectFind("LV") >= 0) ObjectDelete("LV");
   return (0);
}

int start() {
   bool li_0 = FALSE;
   if (!IsTesting()) {
      Comment("\n", "    Aladdin 5 FX ", 
         "\n", 
         "\n", "     License: ОК", 
         "\n", "     Account Number:  ", AccountNumber(), 
         "\n", 
         "\n", "    =======================================", 
         "\n", "     Broker Time       :                ", TimeToStr(TimeCurrent()), 
         "\n", "     Spread = ", DoubleToStr((Ask - Bid) / gd_684, 1), " pips", 
         "\n", "     MaxSpread = ", DoubleToStr(MaxSpread, 1), " pips", 
         "\n", 
         "\n", "     Balance              : ", AccountBalance(), 
         "\n", "     Equity               : ", AccountEquity(), 
         "\n", "     Orders Total         : ", OrdersTotal(), 
         "\n", "     Total Profit/Loss    : ", AccountProfit(), 
         "\n", 
         "\n", "======================================", 
         "\n", "   Copyright © 2011, Finans Plus Company", 
         "\n", "   http://finans-plus.ru", 
         "\n", "   finansplus@bk.ru", 
      "\n");
   }
   if (Hour() >= gd_480 && Hour() < gd_488 && gd_480 > 0.0) li_0 = TRUE;
   if (DayOfWeek() >= gd_464 && Hour() >= gd_448 && gi_444 == TRUE) li_0 = TRUE;
   if (DayOfWeek() <= gd_472 && Hour() <= gd_456 && gi_444 == TRUE) li_0 = TRUE;
   if (li_0 == TRUE) {
      ObjectCreate("P", OBJ_LABEL, 0, 0, 0, 0, 0);
      ObjectSet("P", OBJPROP_CORNER, 2);
      ObjectSet("P", OBJPROP_YDISTANCE, 75);
      ObjectSet("P", OBJPROP_XDISTANCE, 10);
      ObjectSetText("P", "ПЕРЕРЫВ! ", 20, "Tahoma", Red);
   }
   if (li_0 == FALSE) ObjectDelete("P");
   f0_3();
   f0_2();
   if (OrderDol > 0.0) f0_12(li_0);
   if (LimitOrder > 0.0) f0_13(li_0);
   if (StopOrder > 0.0) f0_14(li_0);
   if (ModifDol == TRUE) f0_15();
   if (Ask - Bid > MaxSpread * Point * gi_700) {
      ObjectCreate("Spread", OBJ_LABEL, 0, 0, 0, 0, 0);
      ObjectSet("Spread", OBJPROP_CORNER, 2);
      ObjectSet("Spread", OBJPROP_YDISTANCE, 45);
      ObjectSet("Spread", OBJPROP_XDISTANCE, 10);
      ObjectSetText("Spread", "Spread ! " + DoubleToStr((Ask - Bid) / Point, 0), 20, "Tahoma", Red);
   }
   if (Ask - Bid < MaxSpread * Point * gi_700) ObjectDelete("Spread");
   if (gi_104 > 0 && iVolume(Symbol(), PERIOD_M1, 0) > gi_104) return (0);
   if (AutoMM > 0.0 && (!RecoveryMode)) gd_808 = MathMax(g_minlot_764, MathMin(gd_772, MathCeil(MathMin(AutoMM_Max, AutoMM) / gd_800 / 100.0 * AccountFreeMargin() / g_lotstep_780 / (gi_788 / 100)) * g_lotstep_780));
   if (AutoMM > 0.0 && RecoveryMode) gd_808 = f0_8();
   if (AutoMM == 0.0) gd_808 = FixedLot;
   if (DayOfWeek() == 1 && iVolume(NULL, PERIOD_D1, 0) < 5.0) return (0);
   if (StringLen(gs_712) < 6) return (0);
   if ((!IsTesting()) && IsStopped()) return (0);
   if ((!IsTesting()) && !IsTradeAllowed()) return (0);
   if ((!IsTesting()) && IsTradeContextBusy()) return (0);
   HideTestIndicators(FALSE);
   if (li_0 == FALSE) f0_0();
   return (0);
}

void f0_0() {
   if (f0_9() == 1) {
      if ((!gi_748) && WriteDebugLog) {
         Print("Торговый сигнал пропущен из-за большого спреда.");
         Print("Текущий спред = ", DoubleToStr((Ask - Bid) / gd_684, 1), ",  MaxSpread = ", DoubleToStr(MaxSpread, 1));
         Print("Эксперт будет пробовать позже, когда спред станет допустимым.");
      }
      gi_748 = TRUE;
      return;
   }
   gi_748 = FALSE;
   if (f0_4() && f0_11() && Long) f0_1(OP_BUY);
   if (f0_5() && f0_11() && Short) f0_1(OP_SELL);
}

int f0_1(int a_cmd_0) {
   int li_40;
   double order_open_price_44;
   color color_52;
   int ticket_56;
   int error_60;
   string ls_64;
   double order_open_price_72;
   double ld_80;
   double ld_88;
   bool li_4 = FALSE;
   bool li_8 = FALSE;
   bool li_12 = FALSE;
   bool li_16 = FALSE;
   int li_unused_20 = 0;
   int li_unused_24 = 0;
   for (int pos_28 = OrdersTotal() - 1; pos_28 >= 0; pos_28--) {
      if (OrderSelect(pos_28, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()) {
         if (OrderType() == OP_BUYLIMIT && OrderMagicNumber() == MagicNumber) li_4 = TRUE;
         if (OrderType() == OP_SELLLIMIT && OrderMagicNumber() == MagicNumber) li_8 = TRUE;
         if (OrderType() == OP_SELLSTOP && OrderMagicNumber() == MagicNumber) li_16 = TRUE;
         if (OrderType() == OP_BUYSTOP && OrderMagicNumber() == MagicNumber) li_12 = TRUE;
      }
   }
   bool li_32 = FALSE;
   bool li_36 = FALSE;
   double ld_96 = NormalizeDouble(TakeProfit * gd_684, gi_692);
   double ld_104 = NormalizeDouble(StopLoss * gd_684, gi_692);
   if (gi_760 > 0) {
      MathSrand(TimeLocal());
      li_40 = MathRand() % gi_760;
      if (WriteLog) Print("DelayRandomiser: задержка ", li_40, " секунд.");
      Sleep(1000 * li_40);
   }
   double ld_112 = gd_808;
   if (StartLot > 0.0) ld_112 = StartLot;
   if (AccountFreeMarginCheck(gs_712, a_cmd_0, ld_112) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) {
      if (!(WriteDebugLog)) return (-1);
      Print("Для открытия ордера недостаточно свободной маржи.");
      Comment("Для открытия ордера недостаточно свободной маржи.");
      return (-1);
   }
   RefreshRates();
   if (a_cmd_0 == OP_BUY) {
      li_32 = TRUE;
      order_open_price_72 = NormalizeDouble(Ask, Digits);
      color_52 = g_color_840;
      if (UseStopLevels) {
         ld_80 = NormalizeDouble(order_open_price_72 + ld_96, Digits);
         ld_88 = NormalizeDouble(order_open_price_72 - ld_104, Digits);
      } else {
         ld_80 = 0;
         ld_88 = 0;
      }
   } else {
      li_36 = TRUE;
      order_open_price_72 = NormalizeDouble(Bid, Digits);
      color_52 = g_color_844;
      if (UseStopLevels) {
         ld_80 = NormalizeDouble(order_open_price_72 - ld_96, Digits);
         ld_88 = NormalizeDouble(order_open_price_72 + ld_104, Digits);
      } else {
         ld_80 = 0;
         ld_88 = 0;
      }
   }
   int li_120 = gi_736;
   while (li_120 > 0 && f0_11()) {
      if (gi_276 == TRUE && li_32 == TRUE) OrderSend(gs_712, OP_BUY, ld_112, NormalizeDouble(Ask, Digits), g_slippage_728, 0, 0, g_comment_752, MagicNumber, 0, color_52);
      if (gi_276 == TRUE && li_36 == TRUE) OrderSend(gs_712, OP_SELL, ld_112, NormalizeDouble(Bid, Digits), g_slippage_728, 0, 0, g_comment_752, MagicNumber, 0, color_52);
      if (LimitOrder > 0.0 && li_32 == TRUE && li_4 == FALSE) OrderSend(gs_712, OP_BUYLIMIT, ld_112, NormalizeDouble(Bid - LimitOrder * Point * gi_700, Digits), g_slippage_728, 0, 0, g_comment_752, MagicNumber, 0, color_52);
      if (LimitOrder > 0.0 && li_36 == TRUE && li_8 == FALSE) OrderSend(gs_712, OP_SELLLIMIT, ld_112, NormalizeDouble(Ask + LimitOrder * Point * gi_700, Digits), g_slippage_728, 0, 0, g_comment_752, MagicNumber, 0, color_52);
      if (ReversOrder > 0 && li_32 == TRUE && li_16 == FALSE) {
         OrderSend(gs_712, OP_SELLSTOP, KRevers * ld_112, NormalizeDouble(Bid - ReversOrder * Point * gi_700, Digits), g_slippage_728, 0, 0, "R", MagicNumber, TimeCurrent() +
            60.0 * TimeRewers, color_52);
      }
      if (ReversOrder > 0 && li_36 == TRUE && li_12 == FALSE) {
         OrderSend(gs_712, OP_BUYSTOP, KRevers * ld_112, NormalizeDouble(Ask + ReversOrder * Point * gi_700, Digits), g_slippage_728, 0, 0, "R", MagicNumber, TimeCurrent() +
            60.0 * TimeRewers, color_52);
      }
      Sleep(MathRand() / 1000);
      if (ticket_56 < 0) {
         error_60 = GetLastError();
         if (WriteDebugLog) {
            if (a_cmd_0 == OP_BUY) ls_64 = "OP_BUY";
            else ls_64 = "OP_SELL";
            Print("Открытие: OrderSend(", ls_64, ") ошибка = ", f0_16(error_60));
         }
         if (error_60 != 136/* OFF_QUOTES */) break;
         if (!(gi_880)) break;
         Sleep(6000);
         RefreshRates();
         if (a_cmd_0 == OP_BUY) order_open_price_44 = NormalizeDouble(Ask, Digits);
         else order_open_price_44 = NormalizeDouble(Bid, Digits);
         if (NormalizeDouble(MathAbs((order_open_price_44 - order_open_price_72) / gd_684), 0) > gi_876) break;
         order_open_price_72 = order_open_price_44;
         li_120--;
         if (li_120 > 0)
            if (WriteLog) Print("... Возможно открыть ордер.");
      } else {
         if (OrderSelect(ticket_56, SELECT_BY_TICKET)) order_open_price_72 = OrderOpenPrice();
         if (!(gi_856)) break;
         PlaySound(gs_860);
         break;
      }
   }
   return (ticket_56);
}

void f0_2() {
   bool bool_0;
   int error_8;
   int li_12;
   string ls_16;
   int li_4 = OrdersTotal() - 1;
   for (int pos_24 = li_4; pos_24 >= 0; pos_24--) {
      if (OrderSelect(pos_24, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderType() == OP_BUY) {
            if (OrderMagicNumber() == MagicNumber || OrderMagicNumber() == MagicNumber1 && OrderSymbol() == gs_712 && OrderStopLoss() == 0.0 && OrderTakeProfit() == 0.0) {
               bool_0 = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() - StopLoss * Point * gi_700, Digits), NormalizeDouble(OrderOpenPrice() + TakeProfit * Point * gi_700,
                  Digits), 0, Blue);
            }
         }
         if (OrderType() == OP_SELL) {
            if (OrderMagicNumber() == MagicNumber || OrderMagicNumber() == MagicNumber1 && OrderSymbol() == gs_712 && OrderStopLoss() == 0.0 && OrderTakeProfit() == 0.0) {
               bool_0 = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() + StopLoss * Point * gi_700, Digits), NormalizeDouble(OrderOpenPrice() - TakeProfit * Point * gi_700,
                  Digits), 0, Blue);
            }
         }
         if (OrderType() == OP_BUY)
            if (OrderMagicNumber() == MagicNumber || OrderMagicNumber() == MagicNumber1 && OrderSymbol() == gs_712 && OrderStopLoss() == 0.0 && OrderTakeProfit() != 0.0) bool_0 = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() - StopLoss * Point * gi_700, Digits), OrderTakeProfit(), 0, Blue);
         if (OrderType() == OP_SELL)
            if (OrderMagicNumber() == MagicNumber || OrderMagicNumber() == MagicNumber1 && OrderSymbol() == gs_712 && OrderStopLoss() == 0.0 && OrderTakeProfit() != 0.0) bool_0 = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() + StopLoss * Point * gi_700, Digits), OrderTakeProfit(), 0, Blue);
         if (OrderType() == OP_BUY)
            if (OrderMagicNumber() == MagicNumber || OrderMagicNumber() == MagicNumber1 && OrderSymbol() == gs_712 && OrderStopLoss() != 0.0 && OrderTakeProfit() == 0.0) bool_0 = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), NormalizeDouble(OrderOpenPrice() + TakeProfit * Point * gi_700, Digits), 0, Blue);
         if (OrderType() == OP_SELL)
            if (OrderMagicNumber() == MagicNumber || OrderMagicNumber() == MagicNumber1 && OrderSymbol() == gs_712 && OrderStopLoss() != 0.0 && OrderTakeProfit() == 0.0) bool_0 = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), NormalizeDouble(OrderOpenPrice() - TakeProfit * Point * gi_700, Digits), 0, Blue);
         if (OrderType() == OP_BUY) {
            if (OrderMagicNumber() == MagicNumber || OrderMagicNumber() == MagicNumber1 && OrderSymbol() == gs_712) {
               if (Bid - OrderOpenPrice() > SecProfitTr * gd_684 && MathAbs(OrderOpenPrice() + SecProfit * gd_684 - OrderStopLoss()) >= Point && NormalizeDouble(OrderOpenPrice() +
                  SecProfit * gd_684, Digits) - Point >= OrderStopLoss()) {
                  bool_0 = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() + SecProfit * gd_684, Digits), OrderTakeProfit(), 0, Blue);
                  if (!bool_0) {
                     error_8 = GetLastError();
                     if (WriteDebugLog) Print("Произошла ошибка во время модификации ордера (", ls_16, ",", li_12, "). Причина: ", f0_16(error_8));
                  }
               }
            }
         }
         if (OrderType() == OP_SELL) {
            if (OrderMagicNumber() == MagicNumber || OrderMagicNumber() == MagicNumber1 && OrderSymbol() == gs_712) {
               if (OrderOpenPrice() - Ask > SecProfitTr * gd_684 && MathAbs(OrderOpenPrice() - SecProfit * gd_684 - OrderStopLoss()) >= Point && NormalizeDouble(OrderOpenPrice() - SecProfit * gd_684,
                  Digits) + Point <= OrderStopLoss()) {
                  bool_0 = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() - SecProfit * gd_684, Digits), OrderTakeProfit(), 0, Red);
                  if (!bool_0) {
                     error_8 = GetLastError();
                     if (WriteDebugLog) Print("Произошла ошибка во время модификации ордера (", ls_16, ",", li_12, "). Причина: ", f0_16(error_8));
                  }
               }
            }
         }
         if (TrailingStop > 1.0 && OrderMagicNumber() == MagicNumber || OrderMagicNumber() == MagicNumber1) {
            if (OrderType() == OP_SELL && OrderOpenPrice() - Ask > Utral * Point * gi_700) {
               if (TrailingStop > 0.0 && TrailingStop > 1.0) {
                  if (OrderOpenPrice() - Ask > TrailingStop * Point * gi_700)
                     if (OrderStopLoss() - Point * TrailingStep * gi_700 > Ask + Point * TrailingStop * gi_700 && Ask + Point * TrailingStop * gi_700 <= OrderStopLoss() - Point) OrderModify(OrderTicket(), OrderOpenPrice(), Ask + Point * TrailingStop * gi_700, OrderTakeProfit(), 0, CLR_NONE);
               }
            } else {
               if (OrderType() == OP_BUY && Bid - OrderOpenPrice() > Utral * Point * gi_700) {
                  if (TrailingStop > 0.0 && TrailingStop > 1.0) {
                     if (Bid - OrderOpenPrice() > TrailingStop * Point * gi_700)
                        if (OrderStopLoss() + Point * TrailingStep * gi_700 < Bid - Point * TrailingStop * gi_700 && Bid - Point * TrailingStop * gi_700 >= OrderStopLoss() + Point) OrderModify(OrderTicket(), OrderOpenPrice(), Bid - Point * TrailingStop * gi_700, OrderTakeProfit(), 0, CLR_NONE);
                  }
               }
            }
         }
         if (TrailingStop < 1.0 && OrderMagicNumber() == MagicNumber || OrderMagicNumber() == MagicNumber1) {
            if (OrderType() == OP_SELL && TrailingStop < 1.0) {
               if (TrailingStop <= 0.0) continue;
               if (OrderOpenPrice() - Ask <= Utral * Point * gi_700) continue;
               if (!(OrderStopLoss() - Point * TrailingStep * gi_700 > Ask + (OrderOpenPrice() - Ask) * TrailingStop && Ask + (OrderOpenPrice() - Ask) * TrailingStop <= OrderStopLoss() - Point)) continue;
               OrderModify(OrderTicket(), OrderOpenPrice(), Ask + (OrderOpenPrice() - Ask) * TrailingStop, OrderTakeProfit(), 0, CLR_NONE);
               continue;
            }
            if (OrderType() == OP_BUY) {
               if (TrailingStop > 0.0 && TrailingStop < 1.0) {
                  if (Bid - OrderOpenPrice() > Utral * Point * gi_700) {
                     if (OrderStopLoss() + Point * TrailingStep * gi_700 < Bid - (Bid - OrderOpenPrice()) * TrailingStop && Bid - (Bid - OrderOpenPrice()) * TrailingStop >= OrderStopLoss() +
                        Point) OrderModify(OrderTicket(), OrderOpenPrice(), Bid - (Bid - OrderOpenPrice()) * TrailingStop, OrderTakeProfit(), 0, CLR_NONE);
                  }
               }
            }
         }
      }
   }
}

void f0_3() {
   int error_28;
   int ticket_32;
   string cmd_36;
   int li_unused_0 = 0;
   int li_unused_4 = 0;
   int li_12 = OrdersTotal() - 1;
   int count_16 = 0;
   int count_20 = 0;
   int li_24 = 3;
   for (int pos_48 = li_12; pos_48 >= 0; pos_48--) {
      if (OrderSelect(pos_48, SELECT_BY_POS, MODE_TRADES)) {
         ticket_32 = OrderTicket();
         cmd_36 = OrderType();
         if (OrderMagicNumber() == MagicNumber || OrderMagicNumber() == MagicNumber1) {
            if (OrderType() == OP_BUY && OrderSymbol() == gs_712) {
               count_16++;
               if (CloseOnlyProfit == FALSE) {
                  if (Bid >= OrderOpenPrice() + TakeProfit * gd_684 || Bid <= OrderOpenPrice() - StopLoss * gd_684 || f0_6(OrderOpenPrice(), f0_10())) {
                     for (int li_44 = 1; li_44 <= MathMax(1, li_24); li_44++) {
                        RefreshRates();
                        if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), g_slippage_732, g_color_848)) {
                           count_16--;
                           break;
                        }
                        error_28 = GetLastError();
                        if (WriteDebugLog) Print("Произошла ошибка во время закрытия ордера (", cmd_36, ",", ticket_32, "). Причина: ", f0_16(error_28));
                     }
                  }
               }
               if (CloseOnlyProfit == TRUE) {
                  if (Bid >= OrderOpenPrice() + gi_700 * Point && Bid >= OrderOpenPrice() + TakeProfit * gd_684 || Bid <= OrderOpenPrice() - StopLoss * gd_684 || f0_6(OrderOpenPrice(),
                     f0_10())) {
                     for (li_44 = 1; li_44 <= MathMax(1, li_24); li_44++) {
                        RefreshRates();
                        if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), g_slippage_732, g_color_848)) {
                           count_16--;
                           break;
                        }
                        error_28 = GetLastError();
                        if (WriteDebugLog) Print("Произошла ошибка во время закрытия ордера (", cmd_36, ",", ticket_32, "). Причина: ", f0_16(error_28));
                     }
                  }
               }
            }
            if (OrderType() == OP_SELL && OrderSymbol() == gs_712) {
               count_20++;
               if (CloseOnlyProfit == FALSE) {
                  if (Ask <= OrderOpenPrice() - TakeProfit * gd_684 || Ask >= OrderOpenPrice() + StopLoss * gd_684 || f0_7(OrderOpenPrice(), f0_10())) {
                     for (li_44 = 1; li_44 <= MathMax(1, li_24); li_44++) {
                        RefreshRates();
                        if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), g_slippage_732, g_color_852)) {
                           count_20--;
                           break;
                        }
                        error_28 = GetLastError();
                        if (WriteDebugLog) Print("Произошла ошибка во время закрытия ордера (", cmd_36, ",", ticket_32, "). Причина: ", f0_16(error_28));
                     }
                  }
               }
               if (CloseOnlyProfit == TRUE) {
                  if (Ask <= OrderOpenPrice() - gi_700 * Point && Ask <= OrderOpenPrice() - TakeProfit * gd_684 || Ask >= OrderOpenPrice() + StopLoss * gd_684 || f0_7(OrderOpenPrice(),
                     f0_10())) {
                     for (li_44 = 1; li_44 <= MathMax(1, li_24); li_44++) {
                        RefreshRates();
                        if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), g_slippage_732, g_color_852)) {
                           count_20--;
                           break;
                        }
                        error_28 = GetLastError();
                        if (WriteDebugLog) Print("Произошла ошибка во время закрытия ордера (", cmd_36, ",", ticket_32, "). Причина: ", f0_16(error_28));
                     }
                  }
               }
            }
         }
      }
   }
}

int f0_4() {
   int li_unused_0 = 0;
   bool li_ret_4 = FALSE;
   bool li_8 = FALSE;
   bool li_12 = FALSE;
   bool li_16 = FALSE;
   double iclose_20 = iClose(NULL, PERIOD_M15, 1);
   double ima_28 = iMA(NULL, PERIOD_M15, iMA_PeriodLONG, 0, MODE_SMMA, PRICE_HIGH, 1);
   double istochastic_36 = iStochastic(NULL, PERIOD_M15, iWPR_PeriodLONG, 1, 1, MODE_SMA, 0, MODE_MAIN, 1);
   double iatr_44 = iATR(NULL, PERIOD_M15, iATR_PeriodLONG, 1);
   double icci_52 = iCCI(NULL, PERIOD_M15, iCCI_PeriodLONG, PRICE_TYPICAL, 1);
   double ld_60 = NormalizeDouble(iMA_LONG_Open_a * gd_684, gi_692);
   double ld_68 = NormalizeDouble(iMA_LONG_Open_b * gd_684, gi_692);
   double bid_76 = Bid;
   if (iatr_44 <= FilterATR * gd_684) return (0);
   if (iclose_20 - ima_28 > ld_60 && iclose_20 - bid_76 >= (-gd_704) && gi_816 > istochastic_36) li_8 = TRUE;
   else li_8 = FALSE;
   if (iclose_20 - ima_28 > ld_68 && iclose_20 - bid_76 >= (-gd_704) && (-iCCI_OpenFilter) > icci_52) li_12 = TRUE;
   else li_12 = FALSE;
   if (iclose_20 - ima_28 > ld_68 && iclose_20 - bid_76 >= (-gd_704) && gi_820 > istochastic_36) li_16 = TRUE;
   else li_16 = FALSE;
   if (li_8 == TRUE || li_12 == TRUE || li_16 == TRUE) li_ret_4 = TRUE;
   else li_ret_4 = FALSE;
   return (li_ret_4);
}

int f0_5() {
   int li_unused_0 = 0;
   bool li_ret_4 = FALSE;
   bool li_8 = FALSE;
   bool li_12 = FALSE;
   bool li_16 = FALSE;
   double iclose_20 = iClose(NULL, PERIOD_M15, 1);
   double ima_28 = iMA(NULL, PERIOD_M15, iMA_PeriodShort, 0, MODE_SMMA, PRICE_LOW, 1);
   double istochastic_36 = iStochastic(NULL, PERIOD_M15, iWPR_PeriodShort, 1, 1, MODE_SMA, 0, MODE_MAIN, 1);
   double iatr_44 = iATR(NULL, PERIOD_M15, iATR_PeriodShort, 1);
   double icci_52 = iCCI(NULL, PERIOD_M15, iCCI_PeriodShort, PRICE_TYPICAL, 1);
   double ld_60 = NormalizeDouble(iMA_Short_Open_a * gd_684, gi_692);
   double ld_68 = NormalizeDouble(iMA_Short_Open_b * gd_684, gi_692);
   double bid_76 = Bid;
   if (iatr_44 <= FilterATR * gd_684) return (0);
   if (ima_28 - iclose_20 > ld_60 && iclose_20 - bid_76 <= gd_704 && istochastic_36 > gi_824) li_8 = TRUE;
   else li_8 = FALSE;
   if (ima_28 - iclose_20 > ld_68 && iclose_20 - bid_76 <= gd_704 && icci_52 > iCCI_OpenFilter) li_12 = TRUE;
   else li_12 = FALSE;
   if (ima_28 - iclose_20 > ld_68 && iclose_20 - bid_76 <= gd_704 && istochastic_36 > gi_828) li_16 = TRUE;
   else li_16 = FALSE;
   if (li_8 == TRUE || li_12 == TRUE || li_16 == TRUE) li_ret_4 = TRUE;
   else li_ret_4 = FALSE;
   return (li_ret_4);
}

int f0_6(double ad_0, int ai_8) {
   bool li_ret_12 = FALSE;
   bool li_16 = FALSE;
   bool li_20 = FALSE;
   double istochastic_24 = iStochastic(NULL, PERIOD_M15, iWPR_PeriodLONG, 1, 1, MODE_SMA, 0, MODE_SIGNAL, 1);
   double iclose_32 = iClose(NULL, PERIOD_M15, 1);
   double iopen_40 = iOpen(NULL, PERIOD_M1, 1);
   double iclose_48 = iClose(NULL, PERIOD_M1, 1);
   double ld_56 = NormalizeDouble((-MaxLossPoints) * gd_684, gi_692);
   double ld_64 = NormalizeDouble(Price_Filter_Close * gd_684, gi_692);
   double bid_72 = Bid;
   if (ad_0 - bid_72 <= ld_56 && iclose_32 - bid_72 <= gd_704 && istochastic_24 > gi_832 && ai_8 == 1) li_16 = TRUE;
   else li_16 = FALSE;
   if (iopen_40 > iclose_48 && bid_72 - ad_0 >= ld_64 && ai_8 == 1) li_20 = TRUE;
   else li_20 = FALSE;
   if (li_16 == TRUE || li_20 == TRUE) li_ret_12 = TRUE;
   else li_ret_12 = FALSE;
   return (li_ret_12);
}

int f0_7(double ad_0, int ai_8) {
   bool li_ret_12 = FALSE;
   bool li_16 = FALSE;
   bool li_20 = FALSE;
   double istochastic_24 = iStochastic(NULL, PERIOD_M15, iWPR_PeriodShort, 1, 1, MODE_SMA, 0, MODE_SIGNAL, 1);
   double iclose_32 = iClose(NULL, PERIOD_M15, 1);
   double iopen_40 = iOpen(NULL, PERIOD_M1, 1);
   double iclose_48 = iClose(NULL, PERIOD_M1, 1);
   double ld_56 = NormalizeDouble((-MaxLossPoints) * gd_684, gi_692);
   double ld_64 = NormalizeDouble(Price_Filter_Close * gd_684, gi_692);
   double bid_72 = Bid;
   double ask_80 = Ask;
   if (ask_80 - ad_0 <= ld_56 && iclose_32 - bid_72 >= (-gd_704) && istochastic_24 < gi_836 && ai_8 == 1) li_16 = TRUE;
   else li_16 = FALSE;
   if (iopen_40 < iclose_48 && ad_0 - ask_80 >= ld_64 && ai_8 == 1) li_20 = TRUE;
   else li_20 = FALSE;
   if (li_16 == TRUE || li_20 == TRUE) li_ret_12 = TRUE;
   else li_ret_12 = FALSE;
   return (li_ret_12);
}

double f0_8() {
   double ld_0;
   int count_8;
   double ld_12;
   int li_20;
   double ld_24;
   int li_32;
   double ld_36;
   int li_44;
   double ld_48 = 1;
   if (MultiLotPercent > 0.0 && AutoMM > 0.0) {
      ld_0 = 0;
      count_8 = 0;
      ld_12 = 0;
      li_20 = 0;
      ld_24 = 0;
      li_32 = 0;
      for (int pos_56 = OrdersHistoryTotal() - 1; pos_56 >= 0; pos_56--) {
         if (OrderSelect(pos_56, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
               count_8++;
               ld_0 += OrderProfit();
               if (ld_0 > ld_24) {
                  ld_24 = ld_0;
                  li_32 = count_8;
               }
               if (ld_0 < ld_12) {
                  ld_12 = ld_0;
                  li_20 = count_8;
               }
               if (count_8 >= MaxAnalizCount) break;
            }
         }
      }
      if (li_32 <= li_20) ld_48 = MathPow(MultiLotPercent, li_20);
      else {
         ld_0 = ld_24;
         count_8 = li_32;
         ld_36 = ld_24;
         li_44 = li_32;
         for (pos_56 = OrdersHistoryTotal() - li_32 - 1; pos_56 >= 0; pos_56--) {
            if (OrderSelect(pos_56, SELECT_BY_POS, MODE_HISTORY)) {
               if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
                  if (count_8 >= MaxAnalizCount) break;
                  count_8++;
                  ld_0 += OrderProfit();
                  if (ld_0 < ld_36) {
                     ld_36 = ld_0;
                     li_44 = count_8;
                  }
               }
            }
         }
         if (li_44 == li_32 || ld_36 == ld_24) ld_48 = MathPow(MultiLotPercent, li_20);
         else {
            if (MathAbs(ld_12 - ld_24) / MathAbs(ld_36 - ld_24) >= (Risk + 100.0) / 100.0) ld_48 = MathPow(MultiLotPercent, li_20);
            else ld_48 = MathPow(MultiLotPercent, li_44);
         }
      }
   }
   for (double ld_ret_60 = MathMax(g_minlot_764, MathMin(gd_772, MathCeil(MathMin(AutoMM_Max, ld_48 * AutoMM) / 100.0 * AccountFreeMargin() / g_lotstep_780 / (gi_788 / 100)) * g_lotstep_780)); ld_ret_60 >= 2.0 * g_minlot_764 &&
      1.05 * (ld_ret_60 * g_marginrequired_792) >= AccountFreeMargin(); ld_ret_60 -= g_minlot_764) {
   }
   return (ld_ret_60);
}

int f0_9() {
   RefreshRates();
   if (NormalizeDouble(Ask - Bid, Digits) > gd_740) return (1);
   return (0);
}

int f0_10() {
   int li_0 = OrdersTotal() - 1;
   for (int pos_4 = li_0; pos_4 >= 0; pos_4--) {
      if (OrderSelect(pos_4, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber || OrderMagicNumber() == MagicNumber1) {
            if (OrderSymbol() == gs_712)
               if (OrderType() <= OP_SELL) return (1);
         }
      }
   }
   return (0);
}

int f0_11() {
   int count_0 = 0;
   int li_4 = OrdersTotal() - 1;
   for (int pos_8 = li_4; pos_8 >= 0; pos_8--) {
      if (OrderSelect(pos_8, SELECT_BY_POS, MODE_TRADES))
         if (OrderComment() != "R" && (OrderType() == OP_BUY || OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber || OrderMagicNumber() == MagicNumber1 && OrderSymbol() == gs_712)) count_0++;
   }
   if (count_0 >= gi_736) return (0);
   return (1);
}

void f0_12(int ai_0) {
   double order_open_price_68;
   double order_open_price_76;
   double order_open_price_84;
   double order_open_price_92;
   double ld_unused_108;
   double ld_116;
   double lots_140;
   double ld_148;
   int li_unused_4 = 0;
   int li_unused_8 = 0;
   bool li_12 = FALSE;
   bool li_16 = FALSE;
   int li_unused_20 = 0;
   int li_unused_24 = 0;
   int li_unused_28 = 0;
   int li_unused_32 = 0;
   int li_unused_36 = 0;
   int li_unused_40 = 0;
   bool li_44 = FALSE;
   bool li_48 = FALSE;
   bool li_52 = FALSE;
   bool li_56 = FALSE;
   bool li_60 = FALSE;
   bool li_64 = FALSE;
   for (int pos_156 = OrdersTotal() - 1; pos_156 >= 0; pos_156--) {
      if (!OrderSelect(pos_156, SELECT_BY_POS, MODE_TRADES) || OrderSymbol() != Symbol()) continue;
      if (OrderType() == OP_BUY || OrderType() == OP_SELL && OrderOpenTime() >= iTime(Symbol(), g_timeframe_408, 0)) li_44 = TRUE;
      if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1 || OrderMagicNumber() == MagicNumber && Ask > OrderOpenPrice() - OrderDol * Point * gi_700) li_56 = TRUE;
      if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1 || OrderMagicNumber() == MagicNumber && Bid < OrderOpenPrice() + OrderDol * Point * gi_700) li_60 = TRUE;
      if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1) {
         li_48 = TRUE;
         order_open_price_68 = OrderOpenPrice();
      }
      if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1) {
         li_52 = TRUE;
         order_open_price_76 = OrderOpenPrice();
      }
      if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber) {
         li_unused_36 = 1;
         order_open_price_84 = OrderOpenPrice();
      }
      if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber) {
         li_unused_40 = 1;
         order_open_price_92 = OrderOpenPrice();
      }
      if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber && OrderStopLoss() > OrderOpenPrice()) li_unused_28 = 1;
      if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber && OrderStopLoss() < OrderOpenPrice()) li_unused_32 = 1;
      if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber && Ask < OrderOpenPrice() - OrderDol * Point * gi_700) {
         li_12 = TRUE;
         ld_116 = OrderLots();
      }
      if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber && Bid > OrderOpenPrice() + OrderDol * Point * gi_700) {
         li_16 = TRUE;
         ld_116 = OrderLots();
      }
      if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber && Ask < OrderOpenPrice() - IFStop * Point * gi_700) {
         li_unused_20 = 1;
         ld_148 = OrderLots();
      }
      if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber && Bid > OrderOpenPrice() + IFStop * Point * gi_700) {
         li_unused_24 = 1;
         ld_148 = OrderLots();
      }
      if (gi_420 == FALSE) {
         if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1) li_unused_36 = 1;
         if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1) li_unused_40 = 1;
         if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1 && OrderStopLoss() > OrderOpenPrice()) li_unused_28 = 1;
         if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1 && OrderStopLoss() < OrderOpenPrice()) li_unused_32 = 1;
         if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1 && Ask < OrderOpenPrice() - OrderDol * Point * gi_700) {
            li_12 = TRUE;
            ld_116 = OrderLots();
         }
         if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1 && Bid > OrderOpenPrice() + OrderDol * Point * gi_700) {
            li_16 = TRUE;
            ld_116 = OrderLots();
         }
         if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1 && Ask < OrderOpenPrice() - IFStop * Point * gi_700) {
            li_unused_20 = 1;
            ld_148 = OrderLots();
         }
         if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1 && Bid > OrderOpenPrice() + IFStop * Point * gi_700) {
            li_unused_24 = 1;
            ld_148 = OrderLots();
         }
      }
      if (ModifDol == TRUE && li_48 == TRUE && OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber && OrderTakeProfit() > OrderOpenPrice() + 1.0 * Point + g_pips_552 * Point * gi_700 &&
         order_open_price_68 < OrderOpenPrice() && OrderProfit() < 0.0) OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), OrderOpenPrice() + g_pips_552 * Point * gi_700, 0, CLR_NONE);
      if (ModifDol == TRUE && li_52 == TRUE && OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber && OrderTakeProfit() < OrderOpenPrice() - 1.0 * Point - g_pips_552 * Point * gi_700 &&
         order_open_price_76 > OrderOpenPrice() && OrderProfit() < 0.0) OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), OrderOpenPrice() - g_pips_552 * Point * gi_700, 0, CLR_NONE);
   }
   if (StartLot > 0.0) {
      ld_unused_108 = gd_808;
      ld_116 = gd_808;
      ld_148 = gd_808;
   }
   for (int pos_160 = OrdersTotal() - 1; pos_160 >= 0; pos_160--) {
      if (OrderSelect(pos_160, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber1 || OrderMagicNumber() == MagicNumber)
         if (RiskMargin > 0.0 && RiskMargin * AccountFreeMargin() < AccountMargin()) li_64 = TRUE;
   }
   double ld_176 = AccountFreeMargin() * RiskFreeMargin;
   double lotstep_184 = MarketInfo(Symbol(), MODE_LOTSTEP);
   int li_172 = ld_176 / MarketInfo(Symbol(), MODE_MARGINREQUIRED) / lotstep_184;
   double ld_164 = li_172 * lotstep_184;
   if (ld_164 > gd_772) ld_164 = gd_772;
   if (li_44 == FALSE && li_64 == FALSE) {
      if (ai_0 == 0 && li_12 == TRUE && f0_4() == 1 && li_56 == FALSE) {
         lots_140 = NormalizeDouble(KDol * ld_116, NormalizeLot);
         if (lots_140 > gd_772) lots_140 = gd_772;
         if (lots_140 > ld_164) lots_140 = ld_164;
         OrderSend(Symbol(), OP_BUY, lots_140, Ask, 2, 0, 0, 0, MagicNumber1, 0, Blue);
      }
      if (ai_0 == 0 && li_16 == TRUE && f0_5() == 1 && li_60 == FALSE) {
         lots_140 = NormalizeDouble(KDol * ld_116, NormalizeLot);
         if (lots_140 > gd_772) lots_140 = gd_772;
         if (lots_140 > ld_164) lots_140 = ld_164;
         OrderSend(Symbol(), OP_SELL, lots_140, Bid, 2, 0, 0, 0, MagicNumber1, 0, Fuchsia);
      }
   }
}

void f0_13(int ai_0) {
   double order_open_price_76;
   double order_open_price_84;
   double order_open_price_92;
   double order_open_price_100;
   double order_lots_116;
   double lots_140;
   bool li_4 = FALSE;
   bool li_8 = FALSE;
   int li_unused_12 = 0;
   int li_unused_16 = 0;
   int li_unused_20 = 0;
   int li_unused_24 = 0;
   bool li_28 = FALSE;
   bool li_32 = FALSE;
   bool li_36 = FALSE;
   bool li_40 = FALSE;
   int li_unused_44 = 0;
   int li_unused_48 = 0;
   int li_unused_52 = 0;
   int li_unused_56 = 0;
   int li_unused_60 = 0;
   bool li_64 = FALSE;
   bool li_68 = FALSE;
   bool li_72 = FALSE;
   for (int pos_164 = OrdersTotal() - 1; pos_164 >= 0; pos_164--) {
      if (!OrderSelect(pos_164, SELECT_BY_POS, MODE_TRADES) || OrderSymbol() != Symbol()) continue;
      if (DeleteLimitU == TRUE && OrderType() == OP_BUYLIMIT && OrderMagicNumber() == MagicNumber1 && f0_4() != 1) OrderDelete(OrderTicket());
      if (DeleteLimitU == TRUE && OrderType() == OP_SELLLIMIT && OrderMagicNumber() == MagicNumber1 && f0_5() != 1) OrderDelete(OrderTicket());
      if (OrderType() == OP_BUYLIMIT && OrderMagicNumber() == MagicNumber1) li_64 = TRUE;
      if (OrderType() == OP_SELLLIMIT && OrderMagicNumber() == MagicNumber1) li_68 = TRUE;
      if (OrderType() == OP_BUY || OrderType() == OP_SELL && OrderOpenTime() >= iTime(Symbol(), g_timeframe_408, 0)) li_unused_44 = 1;
      if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1 || OrderMagicNumber() == MagicNumber && Ask > OrderOpenPrice() - OrderDol * Point * gi_700) li_unused_56 = 1;
      if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1 || OrderMagicNumber() == MagicNumber && Bid < OrderOpenPrice() + OrderDol * Point * gi_700) li_unused_60 = 1;
      if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1) {
         li_unused_48 = 1;
         order_open_price_76 = OrderOpenPrice();
      }
      if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1) {
         li_unused_52 = 1;
         order_open_price_84 = OrderOpenPrice();
      }
      if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber) {
         li_36 = TRUE;
         order_open_price_92 = OrderOpenPrice();
      }
      if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber) {
         li_40 = TRUE;
         order_open_price_100 = OrderOpenPrice();
      }
      if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber && OrderStopLoss() > OrderOpenPrice()) li_28 = TRUE;
      if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber && OrderStopLoss() < OrderOpenPrice()) li_32 = TRUE;
      if (DeleteLimit == TRUE && OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber && OrderStopLoss() < OrderOpenPrice()) {
         li_4 = TRUE;
         order_lots_116 = OrderLots();
      }
      if (DeleteLimit == TRUE && OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber && OrderStopLoss() > OrderOpenPrice()) {
         li_8 = TRUE;
         order_lots_116 = OrderLots();
      }
      if (DeleteLimit == FALSE && OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber) {
         li_4 = TRUE;
         order_lots_116 = OrderLots();
      }
      if (DeleteLimit == FALSE && OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber) {
         li_8 = TRUE;
         order_lots_116 = OrderLots();
      }
      if (gi_420 == FALSE) {
         if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1) li_36 = TRUE;
         if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1) li_40 = TRUE;
         if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1 && OrderStopLoss() > OrderOpenPrice()) li_28 = TRUE;
         if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1 && OrderStopLoss() < OrderOpenPrice()) li_32 = TRUE;
         if (DeleteLimit == TRUE && OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1 && OrderStopLoss() < OrderOpenPrice()) {
            li_4 = TRUE;
            order_lots_116 = OrderLots();
         }
         if (DeleteLimit == TRUE && OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1 && OrderStopLoss() > OrderOpenPrice()) {
            li_8 = TRUE;
            order_lots_116 = OrderLots();
         }
         if (DeleteLimit == FALSE && OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1) {
            li_4 = TRUE;
            order_lots_116 = OrderLots();
         }
         if (DeleteLimit == FALSE && OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1) {
            li_8 = TRUE;
            order_lots_116 = OrderLots();
         }
      }
      if (DeleteLimit == TRUE && OrderType() == OP_BUYLIMIT && li_28 == TRUE || li_36 == FALSE) OrderDelete(OrderTicket());
      if (DeleteLimit == TRUE && OrderType() == OP_SELLLIMIT && li_32 == TRUE || li_40 == FALSE) OrderDelete(OrderTicket());
   }
   for (int pos_168 = OrdersTotal() - 1; pos_168 >= 0; pos_168--) {
      if (OrderSelect(pos_168, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber1 || OrderMagicNumber() == MagicNumber)
         if (RiskMargin > 0.0 && RiskMargin * AccountFreeMargin() < AccountMargin()) li_72 = TRUE;
   }
   double ld_184 = AccountFreeMargin() * RiskFreeMargin;
   double lotstep_192 = MarketInfo(Symbol(), MODE_LOTSTEP);
   int li_180 = ld_184 / MarketInfo(Symbol(), MODE_MARGINREQUIRED) / lotstep_192;
   double ld_172 = li_180 * lotstep_192;
   if (ld_172 > gd_772) ld_172 = gd_772;
   if (ai_0 == 0 && li_4 == TRUE && li_64 == FALSE && f0_4() == 1 && li_72 == FALSE) {
      lots_140 = NormalizeDouble(KLimit * order_lots_116, NormalizeLot);
      if (lots_140 > gd_772) lots_140 = gd_772;
      if (lots_140 > ld_172) lots_140 = ld_172;
      OrderSend(Symbol(), OP_BUYLIMIT, lots_140, Bid - LimitOrder * Point * gi_700, 2, 0, 0, 0, MagicNumber1, TimeCurrent() + 60.0 * TimeL, Lime);
   }
   if (ai_0 == 0 && li_8 == TRUE && li_68 == FALSE && f0_5() == 1 && li_72 == FALSE) {
      lots_140 = NormalizeDouble(KLimit * order_lots_116, NormalizeLot);
      if (lots_140 > gd_772) lots_140 = gd_772;
      if (lots_140 > ld_172) lots_140 = ld_172;
      OrderSend(Symbol(), OP_SELLLIMIT, lots_140, Ask + LimitOrder * Point * gi_700, 2, 0, 0, 0, MagicNumber1, TimeCurrent() + 60.0 * TimeL, Orange);
   }
}

void f0_14(int ai_0) {
   double ld_unused_116;
   double ld_unused_124;
   double lots_132;
   double ld_156;
   int li_unused_4 = 0;
   int li_unused_8 = 0;
   int li_unused_12 = 0;
   int li_unused_16 = 0;
   bool li_20 = FALSE;
   bool li_24 = FALSE;
   int li_unused_28 = 0;
   int li_unused_32 = 0;
   int li_unused_36 = 0;
   int li_unused_40 = 0;
   int li_unused_44 = 0;
   int li_unused_48 = 0;
   int li_unused_52 = 0;
   int li_unused_56 = 0;
   int li_unused_60 = 0;
   bool li_64 = FALSE;
   bool li_68 = FALSE;
   bool li_72 = FALSE;
   for (int pos_164 = OrdersTotal() - 1; pos_164 >= 0; pos_164--) {
      if (!OrderSelect(pos_164, SELECT_BY_POS, MODE_TRADES) || OrderSymbol() != Symbol()) continue;
      if (OrderType() == OP_BUYSTOP) li_64 = TRUE;
      if (OrderType() == OP_SELLSTOP) li_68 = TRUE;
      if (OrderType() == OP_BUY || OrderType() == OP_SELL && OrderOpenTime() >= iTime(Symbol(), g_timeframe_408, 0)) li_unused_44 = 1;
      if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber && Ask < OrderOpenPrice() - IFStop * Point * gi_700) {
         li_20 = TRUE;
         ld_156 = OrderLots();
      }
      if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber && Bid > OrderOpenPrice() + IFStop * Point * gi_700) {
         li_24 = TRUE;
         ld_156 = OrderLots();
      }
      if (gi_420 == FALSE) {
         if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1 && Ask < OrderOpenPrice() - IFStop * Point * gi_700) {
            li_20 = TRUE;
            ld_156 = OrderLots();
         }
         if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1 && Bid > OrderOpenPrice() + IFStop * Point * gi_700) {
            li_24 = TRUE;
            ld_156 = OrderLots();
         }
      }
      if (ModifStop == TRUE && OrderType() == OP_BUYSTOP && OrderOpenPrice() - Ask > StopOrder * Point * gi_700) OrderModify(OrderTicket(), Ask + StopOrder * Point * gi_700, 0, 0, OrderExpiration(), CLR_NONE);
      if (ModifStop == TRUE && OrderType() == OP_SELLSTOP && Bid - OrderOpenPrice() > StopOrder * Point * gi_700) OrderModify(OrderTicket(), Bid - StopOrder * Point * gi_700, 0, 0, OrderExpiration(), CLR_NONE);
   }
   if (StartLot > 0.0) {
      ld_unused_116 = gd_808;
      ld_unused_124 = gd_808;
      ld_156 = gd_808;
   }
   for (int pos_168 = OrdersTotal() - 1; pos_168 >= 0; pos_168--) {
      if (OrderSelect(pos_168, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber1 || OrderMagicNumber() == MagicNumber)
         if (RiskMargin > 0.0 && RiskMargin * AccountFreeMargin() < AccountMargin()) li_72 = TRUE;
   }
   double ld_184 = AccountFreeMargin() * RiskFreeMargin;
   double lotstep_192 = MarketInfo(Symbol(), MODE_LOTSTEP);
   int li_180 = ld_184 / MarketInfo(Symbol(), MODE_MARGINREQUIRED) / lotstep_192;
   double ld_172 = li_180 * lotstep_192;
   if (ld_172 > gd_772) ld_172 = gd_772;
   if (ai_0 == 0 && li_20 == TRUE && li_64 == FALSE && f0_4() == 1 && li_72 == FALSE) {
      lots_132 = NormalizeDouble(KStop * ld_156, NormalizeLot);
      if (lots_132 > gd_772) lots_132 = gd_772;
      if (lots_132 > ld_172) lots_132 = ld_172;
      OrderSend(Symbol(), OP_BUYSTOP, lots_132, Ask + StopOrder * Point * gi_700, 2, 0, 0, 0, MagicNumber1, TimeCurrent() + 60.0 * TimeStopOrder, Aqua);
   }
   if (ai_0 == 0 && li_24 == TRUE && li_68 == FALSE && f0_5() == 1 && li_72 == FALSE) {
      lots_132 = NormalizeDouble(KStop * ld_156, NormalizeLot);
      if (lots_132 > gd_772) lots_132 = gd_772;
      if (lots_132 > ld_172) lots_132 = ld_172;
      OrderSend(Symbol(), OP_SELLSTOP, lots_132, Bid - StopOrder * Point * gi_700, 2, 0, 0, 0, MagicNumber1, TimeCurrent() + 60.0 * TimeStopOrder, Yellow);
   }
}

void f0_15() {
   double ld_12;
   double price_20;
   double ld_28;
   double price_36;
   bool li_0 = FALSE;
   bool li_4 = FALSE;
   for (int pos_8 = OrdersTotal() - 1; pos_8 >= 0; pos_8--) {
      if (OrderSelect(pos_8, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()) {
         if (OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) li_0 = TRUE;
            if (OrderType() == OP_SELL) li_4 = TRUE;
            if (OrderType() == OP_BUY) {
               if (ObjectFind("NP") == -1) {
                  ObjectCreate("NP", OBJ_HLINE, 0, 0, OrderOpenPrice());
                  ObjectSet("NP", OBJPROP_COLOR, g_color_520);
               }
            }
            if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber) {
               if (ObjectFind("NP1") == -1) {
                  ObjectCreate("NP1", OBJ_HLINE, 0, 0, OrderOpenPrice());
                  ObjectSet("NP1", OBJPROP_COLOR, g_color_516);
               }
            }
         }
         ld_12 = ObjectGet("NP", OBJPROP_PRICE1);
         price_20 = NormalizeDouble(ld_12, Digits);
         ld_28 = ObjectGet("NP1", OBJPROP_PRICE1);
         price_36 = NormalizeDouble(ld_28, Digits);
         if (ModifTake == FALSE && ModifDol == TRUE && ObjectFind("NP") != -1 && li_0 == TRUE && OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1 && OrderTakeProfit() < price_20 - Point) OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), price_20, 0, CLR_NONE);
         if (ModifTake == FALSE && ModifDol == TRUE && ObjectFind("NP1") != -1 && li_4 == TRUE && OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1 && OrderTakeProfit() > price_36 +
            Point) OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), price_36, 0, CLR_NONE);
         if (ModifTake == TRUE && ObjectFind("NP") != -1 && li_0 == TRUE && OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber1 && OrderOpenPrice() < price_20 - (Ask - Bid)) OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), price_20, 0, CLR_NONE);
         if (ModifTake == TRUE && ObjectFind("NP1") != -1 && li_4 == TRUE && OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber1 && OrderOpenPrice() > price_36 + (Ask - Bid)) OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), price_36, 0, CLR_NONE);
      }
   }
   if (li_0 == FALSE) ObjectDelete("NP");
   if (li_4 == FALSE) ObjectDelete("NP1");
}

string f0_16(int ai_0) {
   string ls_ret_4;
   switch (ai_0) {
   case 0:
   case 1:
      ls_ret_4 = "Нет ошибки, но результат неизвестен";
      break;
   case 2:
      ls_ret_4 = "Общая ошибка";
      break;
   case 3:
      ls_ret_4 = "Неправильные параметры";
      break;
   case 4:
      ls_ret_4 = "Торговый сервер занят";
      break;
   case 5:
      ls_ret_4 = "Старая версия клиентского терминала";
      break;
   case 6:
      ls_ret_4 = "Нет связи с торговым сервером";
      break;
   case 7:
      ls_ret_4 = "Недостаточно прав";
      break;
   case 8:
      ls_ret_4 = "Слишком частые запросы";
      break;
   case 9:
      ls_ret_4 = "Недопустимая операция нарушающая функционирование сервера";
      break;
   case 64:
      ls_ret_4 = "Счет заблокирован";
      break;
   case 65:
      ls_ret_4 = "Неправильный номер счета";
      break;
   case 128:
      ls_ret_4 = "Истек срок ожидания совершения сделки";
      break;
   case 129:
      ls_ret_4 = "Неправильная цена";
      break;
   case 130:
      ls_ret_4 = "Неправильные стопы";
      break;
   case 131:
      ls_ret_4 = "Неправильный объем";
      break;
   case 132:
      ls_ret_4 = "Рынок закрыт";
      break;
   case 133:
      ls_ret_4 = "Торговля запрещена";
      break;
   case 134:
      ls_ret_4 = "Недостаточно денег для совершения операции";
      break;
   case 135:
      ls_ret_4 = "Цена изменилась";
      break;
   case 136:
      ls_ret_4 = "Нет цен";
      break;
   case 137:
      ls_ret_4 = "Брокер занят";
      break;
   case 138:
      ls_ret_4 = "Новые цены - Реквот";
      break;
   case 139:
      ls_ret_4 = "Ордер заблокирован и уже обрабатывается";
      break;
   case 140:
      ls_ret_4 = "Разрешена только покупка";
      break;
   case 141:
      ls_ret_4 = "Слишком много запросов";
      break;
   case 145:
      ls_ret_4 = "Модификация запрещена, так как ордер слишком близок к рынку";
      break;
   case 146:
      ls_ret_4 = "Подсистема торговли занята";
      break;
   case 147:
      ls_ret_4 = "Использование даты истечения ордера запрещено брокером";
      break;
   case 148:
      ls_ret_4 = "Количество открытых и отложенных ордеров достигло предела ";
      break;
   case 4000:
      ls_ret_4 = "Нет ошибки";
      break;
   case 4001:
      ls_ret_4 = "Неправильный указатель функции";
      break;
   case 4002:
      ls_ret_4 = "Индекс массива - вне диапазона";
      break;
   case 4003:
      ls_ret_4 = "Нет памяти для стека функций";
      break;
   case 4004:
      ls_ret_4 = "Переполнение стека после рекурсивного вызова";
      break;
   case 4005:
      ls_ret_4 = "На стеке нет памяти для передачи параметров";
      break;
   case 4006:
      ls_ret_4 = "Нет памяти для строкового параметра";
      break;
   case 4007:
      ls_ret_4 = "Нет памяти для временной строки";
      break;
   case 4008:
      ls_ret_4 = "Неинициализированная строка";
      break;
   case 4009:
      ls_ret_4 = "Неинициализированная строка в массиве";
      break;
   case 4010:
      ls_ret_4 = "Нет памяти для строкового массива";
      break;
   case 4011:
      ls_ret_4 = "Слишком длинная строка";
      break;
   case 4012:
      ls_ret_4 = "Остаток от деления на ноль";
      break;
   case 4013:
      ls_ret_4 = "Деление на ноль";
      break;
   case 4014:
      ls_ret_4 = "Неизвестная команда";
      break;
   case 4015:
      ls_ret_4 = "Неправильный переход";
      break;
   case 4016:
      ls_ret_4 = "Неинициализированный массив";
      break;
   case 4017:
      ls_ret_4 = "Вызовы DLL не разрешены";
      break;
   case 4018:
      ls_ret_4 = "Невозможно загрузить библиотеку";
      break;
   case 4019:
      ls_ret_4 = "Невозможно вызвать функцию";
      break;
   case 4020:
      ls_ret_4 = "Вызовы внешних библиотечных функций не разрешены";
      break;
   case 4021:
      ls_ret_4 = "Недостаточно памяти для строки, возвращаемой из функции";
      break;
   case 4022:
      ls_ret_4 = "Система занята";
      break;
   case 4050:
      ls_ret_4 = "Неправильное количество параметров функции";
      break;
   case 4051:
      ls_ret_4 = "Недопустимое значение параметра функции";
      break;
   case 4052:
      ls_ret_4 = "Внутренняя ошибка строковой функции";
      break;
   case 4053:
      ls_ret_4 = "Ошибка массива";
      break;
   case 4054:
      ls_ret_4 = "Неправильное использование массива-таймсерии";
      break;
   case 4055:
      ls_ret_4 = "Ошибка пользовательского индикатора";
      break;
   case 4056:
      ls_ret_4 = "Массивы несовместимы";
      break;
   case 4057:
      ls_ret_4 = "Ошибка обработки глобальныех переменных";
      break;
   case 4058:
      ls_ret_4 = "Глобальная переменная не обнаружена";
      break;
   case 4059:
      ls_ret_4 = "Функция не разрешена в тестовом режиме";
      break;
   case 4060:
      ls_ret_4 = "Функция не подтверждена";
      break;
   case 4061:
      ls_ret_4 = "Ошибка отправки почты";
      break;
   case 4062:
      ls_ret_4 = "Ожидается параметр типа string";
      break;
   case 4063:
      ls_ret_4 = "Ожидается параметр типа integer";
      break;
   case 4064:
      ls_ret_4 = "Ожидается параметр типа double";
      break;
   case 4065:
      ls_ret_4 = "В качестве параметра ожидается массив";
      break;
   case 4066:
      ls_ret_4 = "Запрошенные исторические данные в состоянии обновления";
      break;
   case 4067:
      ls_ret_4 = "Ошибка при выполнении торговой операции";
      break;
   case 4099:
      ls_ret_4 = "Конец файла";
      break;
   case 4100:
      ls_ret_4 = "Ошибка при работе с файлом";
      break;
   case 4101:
      ls_ret_4 = "Неправильное имя файла";
      break;
   case 4102:
      ls_ret_4 = "Слишком много открытых файлов";
      break;
   case 4103:
      ls_ret_4 = "Невозможно открыть файл";
      break;
   case 4104:
      ls_ret_4 = "Несовместимый режим доступа к файлу";
      break;
   case 4105:
      ls_ret_4 = "Ни один ордер не выбран";
      break;
   case 4106:
      ls_ret_4 = "Неизвестный символ";
      break;
   case 4107:
      ls_ret_4 = "Неправильный параметр цены для торговой функции";
      break;
   case 4108:
      ls_ret_4 = "Неверный номер тикета";
      break;
   case 4109:
      ls_ret_4 = "Торговля не разрешена";
      break;
   case 4110:
      ls_ret_4 = "Длинные позиции не разрешены";
      break;
   case 4111:
      ls_ret_4 = "Короткие позиции не разрешены";
      break;
   case 4200:
      ls_ret_4 = "Объект уже существует";
      break;
   case 4201:
      ls_ret_4 = "Запрошено неизвестное свойство объекта";
      break;
   case 4202:
      ls_ret_4 = "Объект не существует";
      break;
   case 4203:
      ls_ret_4 = "Неизвестный тип объекта";
      break;
   case 4204:
      ls_ret_4 = "Нет имени объекта";
      break;
   case 4205:
      ls_ret_4 = "Ошибка координат объекта";
      break;
   case 4206:
      ls_ret_4 = "Не найдено указанное подокно";
      break;
   case 4207:
      ls_ret_4 = "Ошибка при работе с объектом";
      break;
   default:
      ls_ret_4 = "Неизвестная ошибка";
   }
   return (ls_ret_4);
}