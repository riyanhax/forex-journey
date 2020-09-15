//+-------------------------------------------------------------------+
//|                                             BS_EA1.1.mq4          |
//|                      Copyright © 2010, WildhorseEnterprises       |
//|                                        http://www.metaquotes.net  |
//|
#property copyright "Copyright © 2010, Wildhorse Enterprises"
#property link      "email to stovedude@q.com"

#define BUY 1
#define SELL -1
#define FLAT 0
#define UP 1
#define DN -1
#define GOOD 1
#define PRICE 2
#define TAKE 3
#define STOP 4
#define CLOSE 5
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
extern string  mm = "Money Management settings - Percent Risk";
extern bool    UseMM = true;
extern double  Risk = 1.0,
               NoMMLots = 0.01;
extern int     StopLoss = 30,
               TakeProfit = 30;
               //MaxTrades = 1,
               //NumSignalPairs = 1;
extern bool    UseClosedCandle = true;
extern string  bs = "Buy/Sell settings";
extern int     Arrowperiod = 53;
extern double  Arrowsticker = 1.2;
extern int     Upper = 2;
extern int     Downner = 3;
extern string  s1 = "SL Options";
extern bool    UseStdSL = false,
               UseSRStopLoss = true;
extern string  t1 = "TP Options";
extern bool    UseStdTP = true;
extern string  b1 = "BE Options";
extern bool    UseStdBE = true;
extern double  BreakEvenPips = 10;
extern int     LockInPips = 2;
extern string  t0 = "Trail Stop settings";
extern int     TrailStart = 20,
               TrailStop = 20;
extern bool    UseTrailingStop = false,
               UseSRTrailStop = true;
extern int     SLPipDiff = 1;
extern bool    AddSpread = true;
extern bool    UseCandleTrail = false;
extern int     TrailCandlesBack = 3;
extern string  ms = "Misc settings";
extern int     MaxSpread = 15,
               Slippage = 3;
extern bool    UseNewsFilter = false;
extern int     MinsBeforeNews = 60; 
extern int     MinsAfterNews  = 30;
extern int     NewsImpact = 3;
extern bool    UseHourTrade1 = false;
extern int     FromHourTrade1 = 6,
               ToHourTrade1 = 18;
extern bool    UseHourTrade2 = false;
extern int     FromHourTrade2 = 6,
               ToHourTrade2 = 18;
extern int     MagicID = 12341123109;
extern string  TradeComment = "BS_EA-1.1";
bool           BuyTradeExists, 
               SellTradeExists,
               BuySignal=false,
               SellSignal=false,
               StartCandleTrail=false;
int            StopRange,X,SignalCandle=0,minutesUntilNextEvent=0,BSCmd=0;
static datetime dtBarTime = 0, LastBuyTime=0,LastSellTime=0;
double         Pt,Res=0.0,Sup=0.0;
               
bool IsTradeTime1() {
   if ((FromHourTrade1 < ToHourTrade1) && ((Hour() < FromHourTrade1) || (Hour() >= ToHourTrade1))) return (false);
   if (FromHourTrade1 > ToHourTrade1 && Hour() < FromHourTrade1 && Hour() >= ToHourTrade1) return (false);
   return (true);
}
bool IsTradeTime2() {
   if ((FromHourTrade2 < ToHourTrade2) && ((Hour() < FromHourTrade2) || (Hour() >= ToHourTrade2))) return (false);
   if (FromHourTrade2 > ToHourTrade2 && Hour() < FromHourTrade2 && Hour() >= ToHourTrade2) return (false);
   return (true);
}
bool NewsTime() {
   bool News=false;
   static int PrevMinute = -1;
   if (UseNewsFilter && Minute() != PrevMinute && !IsTesting()) {
      PrevMinute = Minute();
      int minutesSincePrevEvent = iCustom(NULL, 0, "FFCal", true, true, false, true, true, 1, 0);
      minutesUntilNextEvent = iCustom(NULL, 0, "FFCal", true, true, false, true, true, 1, 1);
      if ((minutesUntilNextEvent <= MinsBeforeNews) || (minutesSincePrevEvent <= MinsAfterNews)) {
         int impactOfNextEvent = iCustom(NULL, 0, "FFCal", true, true, false, true, true, 2, 1);
         if (impactOfNextEvent >= NewsImpact) {
            News = true;
            }
         }
      }
   return(News);
}
int GetEntry() {
   double BSUp = iCustom(NULL,0,"001",Arrowperiod,Arrowsticker,200,false,Upper,Downner,0,SignalCandle);
   double BSDn = iCustom(NULL,0,"001",Arrowperiod,Arrowsticker,200,false,Upper,Downner,1,SignalCandle);
   double BSUp1 = iCustom(NULL,0,"001",Arrowperiod,Arrowsticker,200,false,Upper,Downner,0,SignalCandle+1);
   double BSDn1 = iCustom(NULL,0,"001",Arrowperiod,Arrowsticker,200,false,Upper,Downner,1,SignalCandle+1);
   if (BSUp!=EMPTY_VALUE && BSDn==EMPTY_VALUE && BSDn1!=EMPTY_VALUE) return(BUY);
   if (BSDn!=EMPTY_VALUE && BSUp==EMPTY_VALUE && BSUp1!=EMPTY_VALUE) return(SELL);
   return(FLAT);
}
double GetRes() {
   double result=0.0,fractal=0.0;
   for (int ct=1;ct<Bars;ct++) {
      fractal=iFractals(NULL,0,MODE_UPPER,ct);
      if (fractal>0.0) {
         result=fractal;
         break;
         }
      }
   return(result);
}
double GetSup() {
   double result=0.0,fractal=0.0;
   for (int ct=1;ct<Bars;ct++) {
      fractal=iFractals(NULL,0,MODE_LOWER,ct);
      if (fractal>0.0) {
         result=fractal;
         break;
         }
      }
   return(result);
}
double GetSL(int cmd, double Price) { 
   double myStop;
   if (cmd==BUY) {
      if (UseStdSL) {
         if (StopLoss==0) myStop=0.0;
         else myStop=Price-StopLoss*Pt;
         }
      else if (UseSRStopLoss) {
         if (Sup==0.0) myStop=0.0;
         else {
            myStop = Sup-SLPipDiff*Pt;
            if (AddSpread) myStop -= MarketInfo(Symbol(),MODE_SPREAD)*Point;
            }
         }
      else myStop=0.0;
      }
   else if (cmd==SELL) {
      if (UseStdSL) {
         if (StopLoss==0) myStop=0.0;
         else myStop=Price+StopLoss*Pt;
         }
      else if (UseSRStopLoss) {
         if (Res==0.0) myStop=0.0;
         else {
            myStop = Res+SLPipDiff*Pt;
            if (AddSpread) myStop += MarketInfo(Symbol(),MODE_SPREAD)*Point;
            }
         }
      else myStop=0.0;
      }
   return(myStop);
}

double GetTP(int cmd, double Price) {
   double myTake;
   if (cmd==BUY) {
      if (UseStdTP) myTake=Price+TakeProfit*Pt;
      else myTake=0.0;
      }
   else if (cmd==SELL) {
      if (UseStdTP) myTake=Price-TakeProfit*Pt;
      else myTake=0.0;
      }
   return(myTake);
}
void init() {
   if (Digits==5 || Digits==3) X=10;
   else X=1; 
   Pt = X*Point;
   StopRange = MarketInfo(Symbol(),MODE_STOPLEVEL)/X;
   if (UseClosedCandle) SignalCandle=1;
} 
      
int start(){
   Res=GetRes();
   Sup=GetSup();
   BuyTradeExists = false;
   SellTradeExists = false;
   BSCmd=GetEntry();
   if (BSCmd==BUY) {
      BuySignal=true;
      SellSignal=false;
      }
   else if (BSCmd==SELL) {
      SellSignal=true;
      BuySignal=false;
      }
   //int numbuys=0,numsells=0;
   RefreshRates();
   int ct=0;
   for (int l = 0; l < OrdersTotal(); l++) {
      OrderSelect(l, SELECT_BY_POS,MODE_TRADES);
      if (OrderSymbol() == Symbol()  && OrderMagicNumber() == MagicID) {
         if (OrderType() == OP_BUY) {
            while (!CloseSell(0) && ct<50) {
               Sleep(5000);
               ct++;
               }
            if (UseTrailingStop) UpdateTrail(l);
            if (UseCandleTrail && StartCandleTrail) UpdateCandleTrail(l);
            if (UseSRTrailStop) UpdateSRTrailStop(l,Sup);
            if (UseStdBE) GoToBE(l);
            BuyTradeExists = true;
            BuySignal=false;
            //numbuys++;
            }
         else if (OrderType() == OP_SELL) {
            while (!CloseBuy(0) && ct<50) {
               Sleep(5000);
               ct++;
               }
            if (UseTrailingStop) UpdateTrail(l);
            if (UseCandleTrail && StartCandleTrail) UpdateCandleTrail(l);
            if (UseSRTrailStop) UpdateSRTrailStop(l,Res);
            if (UseStdBE) GoToBE(l);
            SellTradeExists = true;
            SellSignal=false;
            //numsells++;
            }
         }
      }
   if (!BuyTradeExists && !SellTradeExists) {
      StartCandleTrail=false;
      }
   double currentSpread = MarketInfo(Symbol(),MODE_SPREAD)/X;
   if (currentSpread>MaxSpread) {
      Comment("Current spread ",NormalizeDouble(currentSpread,1),"exceeds maximal allowed spread ",MaxSpread);
      return;
      }
   if (UseNewsFilter && NewsTime()) {
      Comment("Pending news event for ",Symbol()," in ",minutesUntilNextEvent," minutes...");
      return;
      }
   if ((UseHourTrade1 && !IsTradeTime1()) || (UseHourTrade2 && !IsTradeTime2())) {
      Comment("Outside trading time");
      return;
      }
   Comment("BS Trend: ",BSCmd,"\n",
           "BuySig  : ",BuySignal,"\n",
           "SellSig : ",SellSignal);
   if (BuySignal && !BuyTradeExists && LastBuyTime!=Time[0]) {
      BuyNow();
      }
   else if (SellSignal && !SellTradeExists && LastSellTime!=Time[0]) {
      SellNow();
      }
   return;
}
bool CloseBuy(int ticket) {
   bool err;
   if (ticket == 0) {
      for (int cnt = 0; cnt < OrdersTotal(); cnt++) {
         OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);
         if (OrderSymbol() == Symbol()  && OrderMagicNumber()==MagicID && OrderType() == OP_BUY) {
            RefreshRates();
            err = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(OrderClosePrice(),Digits), Slippage, Blue);
            if (!err) {
               Alert("Close buy unsuccessful - ",err);
               return(false);
               }
            }
         }
      }
   else {
      OrderSelect(ticket, SELECT_BY_POS,MODE_TRADES);
      RefreshRates();
      err = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(OrderClosePrice(),Digits), Slippage, Blue);
      if (!err) {
         Alert("Close buy unsuccessful - ",err);
         return(false);
         }
      }
   return(true);
}
bool CloseSell(int ticket) {
   bool err;
   if (ticket == 0) {
      for (int cnt = 0; cnt < OrdersTotal(); cnt++) {
         OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);
         if (OrderSymbol() == Symbol()  && OrderMagicNumber()==MagicID && OrderType() == OP_SELL) {
            RefreshRates();
            err = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(OrderClosePrice(),Digits), Slippage, Red);
            if (!err) {
               Alert("Close sell unsuccessful - ",err);
               return(false);
               }
            }
         }
      }
   else {
      OrderSelect(ticket, SELECT_BY_POS,MODE_TRADES);
      RefreshRates();
      err = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(OrderClosePrice(),Digits), Slippage, Red);
      if (!err) {
         Alert("Close buy unsuccessful - ",err);
         return(false);
         }
      }
   return(true);
}
void BuyNow() {
   int err;
   CloseSell(0);
   if ((UseHourTrade1 && !IsTradeTime1()) || (UseHourTrade2 && !IsTradeTime2())) {
      //Print("This is not trading time.");
      return;
      }
   RefreshRates();
   double myStop = GetSL(BUY,NormalizeDouble(Ask,Digits));
   double myLots = GetLots(NormalizeDouble(Ask,Digits),myStop);
   double myTake = GetTP(BUY,NormalizeDouble(Ask,Digits));
   if (Bid>myTake && myTake!=0.0) {
      Print("Buy: Too far already...Bid: ",Bid," myStop: ",myStop," myTake: ",myTake);
      return;
      }
   while (!IsTradeAllowed()) Sleep(5000);
   RefreshRates();
   int Chk = 0;
   while (Chk!=GOOD) {
      Chk = IsBuyValid(myStop,myTake);
      if (Chk==TAKE) myTake += Pt;
      else if (Chk==STOP) myStop -= Pt;
      }
   string TC=TradeComment + " Buy";
   err = OrderSend(Symbol(),OP_BUY,myLots,NormalizeDouble(Ask,Digits),Slippage,0,0,TC,MagicID,0,Blue);
   if (err<0) Print ("Buy unsuccessful - ",err);
   else if (OrderSelect(err,SELECT_BY_TICKET,MODE_TRADES)) {
      StartCandleTrail=false;
      ClearSignals();
      if (OrderType() != OP_BUY) {
         Alert("Warning: Broker reversed trade #",err,"!!!!!");
         OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Blue);
         }
      LastBuyTime=Time[0];
      bool result=false;
      int ct=0;
      while (!result && ct<50) {
         ct++;
         Sleep(3000);
         result=OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(myStop,Digits),NormalizeDouble(myTake,Digits),0,CLR_NONE);
         }   
      if (!result) Alert("Error modifying buy order: ",GetLastError());
      }
   return;
}
void SellNow() {
   int err;
   CloseBuy(0);
   if ((UseHourTrade1 && !IsTradeTime1()) || (UseHourTrade2 && !IsTradeTime2())) {
      //Print("This is not trading time.");
      return;
      }
   RefreshRates();
   double myStop = GetSL(SELL,NormalizeDouble(Bid,Digits));
   double myLots = GetLots(NormalizeDouble(Bid,Digits),myStop);
   double myTake = GetTP(SELL,NormalizeDouble(Bid,Digits));
   if (Ask<myTake && myTake!=0.0) {
      Print("Sell: Too far already...Ask: ",Ask," myStop: ",myStop," myTake: ",myTake);
      return;
      }
   while (!IsTradeAllowed()) Sleep(5000);
   RefreshRates();
   int Chk=0;
   while (Chk!=GOOD) {
      Chk = IsSellValid(myStop,myTake);
      if (Chk==TAKE) myTake -= Pt;
      else if (Chk==STOP) myStop += Pt;
      }
   string TC=TradeComment + " Sell";
   err = OrderSend(Symbol(),OP_SELL,myLots,NormalizeDouble(Bid,Digits),Slippage,0,0,TC,MagicID,0,Red);
   if (err<0) Print ("Sell unsuccessful - ",err);
   else if (OrderSelect(err,SELECT_BY_TICKET,MODE_TRADES)) {
      StartCandleTrail=false;
      ClearSignals();
      if (OrderType() != OP_SELL) {
         Alert("Warning: Broker reversed trade #",err,"!!!!!");
         OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Red);
         }
      LastSellTime=Time[0];
      bool result=false;
      int ct=0;
      while(!result && ct<50) {
         ct++;
         Sleep(3000);
         result=OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(myStop,Digits),NormalizeDouble(myTake,Digits),0,CLR_NONE);
         }
      if (!result) Alert("Error modifying buy order: ",GetLastError());
      }
   return;
}

double GetLots(double Price, double Stop) {
   double LotsToRisk,Lots;
   if (!UseMM) return(NoMMLots);
   int StopLossInPips = MathAbs(Price-Stop)/Pt;
   int    Decimals = 0;
   double LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   double LotSize = MarketInfo(Symbol(), MODE_LOTSIZE);
   double LotTickValue = MarketInfo(Symbol(), MODE_TICKVALUE)*X;
   double MIN_lots = MarketInfo(Symbol(),MODE_MINLOT);
   double MAX_lots = MarketInfo(Symbol(),MODE_MAXLOT);

   if(LotStep == 0.01)
      Decimals = 2;
   if(LotStep == 0.1)
      Decimals = 1;
   if (StopLossInPips==0) StopLossInPips = 100;
   LotsToRisk = ((AccountFreeMargin()*Risk)/100)/StopLossInPips;
   Lots = StrToDouble(DoubleToStr(LotsToRisk/LotTickValue,Decimals));
   if (Lots < MIN_lots) Lots = MIN_lots;
   if (Lots > MAX_lots) Lots = MAX_lots;
   return(Lots);    
}

void UpdateTrail (int ticket) {
   RefreshRates();
   double NewStop;
   bool err;
   OrderSelect(ticket, SELECT_BY_POS,MODE_TRADES);
   if (OrderType() == OP_BUY) {
      if (TrailStop>0&&NormalizeDouble(Ask-TrailStart*Pt,Digits)>NormalizeDouble(OrderOpenPrice(),Digits)) {                 
         if(NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(Bid-TrailStop*Pt,Digits)||(OrderStopLoss()==0)) {
            NewStop = Bid-TrailStop*Pt;
            //Print("SL: ",OrderStopLoss()," newSL: ",NewStop);
            if (NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(NewStop,Digits)&& NormalizeDouble(Bid-StopRange*Pt,Digits)>NormalizeDouble(NewStop,Digits)) {
               err=OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(NewStop,Digits),OrderTakeProfit(),0,Blue);
               if (!err) Print ("Error modifying order on TrailStop: ", err);
               }
            }
         }
      }
   else if (OrderType() == OP_SELL) {
      if (TrailStop>0&&NormalizeDouble(Bid+TrailStart*Pt,Digits)<NormalizeDouble(OrderOpenPrice(),Digits)) {                 
         if (NormalizeDouble(OrderStopLoss(),Digits)>NormalizeDouble(Ask+TrailStop*Pt,Digits)||(OrderStopLoss()==0)) {
            NewStop = Ask+TrailStop*Pt;
            //Print("SL: ",OrderStopLoss()," newSL: ",NewStop);
            if (NormalizeDouble(OrderStopLoss(),Digits) > NormalizeDouble(NewStop,Digits) && NormalizeDouble(Ask+StopRange*Pt,Digits)<NormalizeDouble(NewStop,Digits)) {
               err = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(NewStop,Digits),OrderTakeProfit(),0,Red);
               if (!err) Print ("Error modifying order on TrailStop: ", err);
               }
            }
         }
      }
   return;
}
void UpdateSRTrailStop (int ticket, double newStop) {
   bool err;
   OrderSelect(ticket, SELECT_BY_POS,MODE_TRADES);
   if (OrderType() == OP_BUY) {
      newStop -= SLPipDiff*Pt;
      if (AddSpread) newStop -= MarketInfo(Symbol(),MODE_SPREAD)*Point;
      if (NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(newStop,Digits) && NormalizeDouble(Bid-StopRange*Pt,Digits)>NormalizeDouble(newStop,Digits)) {
         //Print("SL: ",OrderStopLoss()," newSL: ",newStop," Bid: ",Bid);
         err = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(newStop,Digits),OrderTakeProfit(),0,Blue);
         if (!err) Print ("Error modifying order on SRTrail: ", err);
         }
      }
   else if (OrderType() == OP_SELL) {
      newStop += SLPipDiff*Pt;
      if (AddSpread) newStop += MarketInfo(Symbol(),MODE_SPREAD)*Point;
      if (NormalizeDouble(OrderStopLoss(),Digits)>NormalizeDouble(newStop,Digits) && NormalizeDouble(Ask+StopRange*Pt,Digits)<NormalizeDouble(newStop,Digits)) {
         //Print("SL: ",OrderStopLoss()," newSL: ",newStop," Ask: ",Ask);
         err = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(newStop,Digits),OrderTakeProfit(),0,Red);
         if (!err) Print ("Error modifying order on SRTrail: ", err);
         }
      }
   return;
}
void UpdateCandleTrail (int ticket) {
   double NewStop;
   bool err;
   OrderSelect(ticket, SELECT_BY_POS,MODE_TRADES);
   if (OrderType() == OP_BUY) {
      NewStop = Low[iLowest(Symbol(),0,MODE_LOW,TrailCandlesBack,0)]-SLPipDiff*Pt;
      Print ("NewStop=",NewStop," TrailCandleBack=",TrailCandlesBack," SLPD=",SLPipDiff*Pt);
      if (NormalizeDouble(Bid,Digits)<=NormalizeDouble(NewStop,Digits)) {
         CloseBuy(ticket);
         return;
         }
      if (NormalizeDouble(OrderStopLoss(),Digits) < NormalizeDouble(NewStop,Digits) && NormalizeDouble(Bid-StopRange*Pt,Digits)>NormalizeDouble(NewStop,Digits)) {
         err = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(NewStop,Digits),OrderTakeProfit(),0,Blue);
         if (!err) Print ("Error modifying order on candletrail: ", err);
         }
      }
   else if (OrderType() == OP_SELL) {
      NewStop = High[iHighest(Symbol(),0,MODE_HIGH,TrailCandlesBack,0)]+SLPipDiff*Pt;
      Print ("NewStop=",NewStop);
      if (NormalizeDouble(Ask,Digits)>=NormalizeDouble(NewStop,Digits)) {
         CloseSell(ticket);
         return;
         }
      if (NormalizeDouble(OrderStopLoss(),Digits) > NormalizeDouble(NewStop,Digits) && NormalizeDouble(Ask+StopRange*Pt,Digits)<NormalizeDouble(NewStop,Digits)) {
         err = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(NewStop,Digits),OrderTakeProfit(),0,Red);
         if (!err) Print ("Error modifying order on candletrail: ", err);
         }
      }
   return;
}

void GoToBE(int ticket) {
   double NewStop;
   bool err;
   OrderSelect(ticket, SELECT_BY_POS,MODE_TRADES);
   if (OrderType() == OP_BUY) {
      NewStop = OrderOpenPrice()+ LockInPips*Pt;
      if (Bid-OrderOpenPrice()>=BreakEvenPips*Pt&&NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(NewStop,Digits)
         && NormalizeDouble(Bid,Digits)>NormalizeDouble(NewStop,Digits)) {
         //Print("Bid: ",Bid," Ask: ",Ask," OpenPrice: ",OrderOpenPrice()," Target: ",BETarget," NewStop: ",NewStop);
         err = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(NewStop,Digits),OrderTakeProfit(),0,Blue);
         if (!err) Print ("Error modifying order on BE: ", err);
         StartCandleTrail=true;
         }
      }
   else if (OrderType() == OP_SELL) {
      NewStop = OrderOpenPrice()- LockInPips*Pt;
      if (OrderOpenPrice()-Ask>=BreakEvenPips*Pt && NormalizeDouble(OrderStopLoss(),Digits)>NormalizeDouble(NewStop,Digits)
          && NormalizeDouble(Ask,Digits)<NormalizeDouble(NewStop,Digits)) {
         //Print("Bid: ",Bid," Ask: ",Ask,"OpenPrice: ",OrderOpenPrice()," Target: ",BETarget," NewStop: ",NewStop);
         err = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(NewStop,Digits),OrderTakeProfit(),0,Red);
         if (!err) Print ("Error modifying order on BE: ", err);
         StartCandleTrail=true;
         }
      }
   return;
}

int IsBuyValid(double Stop, double Take) {
   if (Ask+StopRange*Pt>Take&&Take!=0) return (TAKE);
   if (Bid-StopRange*Pt<Stop) return(STOP);
   return(GOOD);
}

int IsSellValid(double Stop, double Take) {
   if (Bid-StopRange*Pt<Take) return(TAKE);
   if (Ask+StopRange*Pt>Stop&&Stop!=0) return(STOP);
   return(GOOD);   
}

void ClearSignals() {
   BuySignal=false;
   SellSignal=false;
}

