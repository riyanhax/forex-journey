//+------------------------------------------------------------------+
//|                                                    BBQ_EA_V1.1.2 |
//|                                                        EURUSD M5 |
//|                                   created by Monty666 2013-06-29 |
//+------------------------------------------------------------------+
//
#property copyright "Copyright © 2013 Monty666"
#property link      "BBQ EA"
#include <stdlib.mqh>
#include <stderror.mqh> 

//
//---- input parameters
extern string mm = "MoneyManagement";
extern double Lots = 0.01;
extern bool UseMM = FALSE;
extern double PercentageMM = 10.0;
extern int SlipPage = 3;
extern double MaxSpread = 2.0;
extern double StopLoss     = 50;
extern double TakeProfit   = 11;
extern int TrailingStop = 4;
extern int TrailingStep = 0;
extern int BreakEven = 0;
extern int movestopto = 1;
extern int WaitTime = 16;  // Min
extern string Timefilter = "GMT offset broker";
extern int    ServerTimeZone = 0;
extern int    TimeControl  = 0;
extern int    HourStartGMT   = 10;
extern int    HourStopGMT    = 18;
extern string News   = "Newsfilter";
extern bool AvoidNews        = TRUE;
extern int MinimumImpact     = 2;
extern int MinsBeforeNews    = 60;
extern int MinsAfterNews     = 30;
extern string Friday = "FridayFinalHour";
extern bool   UseFridayFinalTradeTime = TRUE;
extern int    FridayFinalHourGMT = 15;
// signal 1 settings
extern string  Signals0    = "M5";
extern bool M5 = TRUE;
extern int MA_Period = 96;
extern int Slippage_MA = 28;
extern int Williams_Period = 16;
extern int Level_High = 5;
extern int Level_Low = 95;
extern int ATR_Period = 16;
extern int Level_ATR_Stop = 4;
extern int CCI_Period = 26;
extern int Level_CCI_High = 90;
extern int Level_CCI_Low = -110;
// signal 2 settings
extern string  Signals1    = "M15"; 
extern bool M15 = TRUE;
extern int MA_Perioda = 72;
extern int Slippage_MAa = 6;
extern int Williams_Perioda = 40;
extern int Level_Higha = 5;
extern int Level_Lowa = 95;
extern int ATR_Perioda = 22;
extern int Level_ATR_Stopa = 9;
extern int CCI_Perioda = 16;
extern int Level_CCI_Higha = 40;
extern int Level_CCI_Lowa = -40;
// signal 3 settings
extern string  Signals2    = "M30"; 
extern bool M30 = TRUE;
extern int MA_Periodb = 70;
extern int Slippage_MAb = 4;
extern int Williams_Periodb = 30;
extern int Level_Highb = 5;
extern int Level_Lowb = 95;
extern int ATR_Periodb = 22;
extern int Level_ATR_Stopb = 9;
extern int CCI_Periodb = 16;
extern int Level_CCI_Highb = 30;
extern int Level_CCI_Lowb = -30;
// signal 4 settings
extern string  Signals3    = "H1"; 
extern bool H1 = TRUE;
extern int MA_Periodc = 58;
extern int Slippage_MAc = 3;
extern int Williams_Periodc = 30;
extern int Level_Highc = 6;
extern int Level_Lowc = 98;
extern int ATR_Periodc = 19;
extern int Level_ATR_Stopc = 6;
extern int CCI_Periodc = 16;
extern int Level_CCI_Highc = 60;
extern int Level_CCI_Lowc = -60;
// signal 5 settings
// sar adx
extern double SAR_Step = 0.012;
extern double SAR_Maximum = 0.2;
extern double ADX_Level=25;
extern double ADX_Period = 14;
extern string Choose_ADX_Price = "0=close, 1=open, 2=high, 3=low, 4=median, 5=typical, 6=weighted";
extern double ADX_Price = 0;
extern string Choose_ADX_Mode = "0=Base indicator line, 1=+DI indicator line, 2=-DI indicator line";
extern double ADX_Mode = 0;
//
// close
extern string  SignalClose    = "Close settings"; 
extern int Close_Williams = 1;
extern int Williams_Close_Buy = 80;
extern int Williams_Close_Sell = 40;
extern int Only_Profit = 2;
//extern int Only_Profit2 = 12;
extern int Close_CCI = 0;
extern int CCI_Close_Buy = 20;
extern int CCI_Close_Sell = -70;
extern int MagicNumber1           = 19777;
extern string TradeComment       = "BBQ";
//
double point;
int i,D;
int Current;
int gi_240 = 0;
int gi_244 = 0;
int gi_224 = 0;
int gi_228 = 6;
int gi_328;
int g_error_332;
double g_price_336;
double g_price_344;
double g_price_352;
double gd_360;
double gd_368;
double g_iclose_376;
double g_iatr_384;
double g_iwpr_392;
double g_icci_400;
double g_ima_408;
int g_datetime_420;
//
int gi_240a = 0;
int gi_244a = 0;
int gi_224a = 0;
int gi_228a = 6;
int gi_328a;
int g_error_332a;
double g_price_336a;
double g_price_344a;
double g_price_352a;
double gd_360a;
double gd_368a;
double g_iclose_376a;
double g_iatr_384a;
double g_iwpr_392a;
double g_icci_400a;
double g_ima_408a;
int g_datetime_420a;
//
int gi_240b = 0;
int gi_244b = 0;
int gi_224b = 0;
int gi_228b = 6;
int gi_328b;
int g_error_332b;
double g_price_336b;
double g_price_344b;
double g_price_352b;
double gd_360b;
double gd_368b;
double g_iclose_376b;
double g_iatr_384b;
double g_iwpr_392b;
double g_icci_400b;
double g_ima_408b;
int g_datetime_420b;
//
int gi_240c = 0;
int gi_244c = 0;
int gi_224c = 0;
int gi_228c = 6;
int gi_328c;
int g_error_332c;
double g_price_336c;
double g_price_344c;
double g_price_352c;
double gd_360c;
double gd_368c;
double g_iclose_376c;
double g_iatr_384c;
double g_iwpr_392c;
double g_icci_400c;
double g_ima_408c;
int g_datetime_420c;
//
datetime LastTradeTime = 0;
int ThisBarTrade = 0;
int bartime = 0;
//+------------------------------------------------------------------+
//| Time Filter                                                      |
//+------------------------------------------------------------------+
bool TradeSession() {
   int Hour_Start_Trade;
   int Hour_Stop_Trade;
   Hour_Start_Trade = HourStartGMT + ServerTimeZone;
   Hour_Stop_Trade = HourStopGMT + ServerTimeZone;
   if (Hour_Start_Trade < 0)Hour_Start_Trade = Hour_Start_Trade + 24;
   if (Hour_Start_Trade >= 24)Hour_Start_Trade = Hour_Start_Trade - 24;
   if (Hour_Stop_Trade > 24)Hour_Stop_Trade = Hour_Stop_Trade - 24;
   if (Hour_Stop_Trade <= 0)Hour_Stop_Trade = Hour_Stop_Trade + 24;
   if ((UseFridayFinalTradeTime && (Hour()>=FridayFinalHourGMT + ServerTimeZone) && DayOfWeek()==5)||DayOfWeek()==0)return (FALSE); // Friday Control
   if((TimeControl(Hour_Start_Trade,Hour_Stop_Trade)!=1 && TimeControl==1 && Hour_Start_Trade<Hour_Stop_Trade)
        || (TimeControl(Hour_Stop_Trade,Hour_Start_Trade)!=0 && TimeControl==1 && Hour_Start_Trade>Hour_Stop_Trade)
          ||TimeControl==0)return (TRUE); // "Trading Time";
    return (FALSE); // "Non-Trading Time";
}

int TimeControl(int StartHour, int EndHour)
{
   if (Hour()>=StartHour &&  Hour()< EndHour)
      { 
      return(0);
      }
return(1);
}

//+------------------------------------------------------------------+
//| Lots Sizes and Automatic Money Management                        |
//+------------------------------------------------------------------+
 double GetLots()
 { 
   if (UseMM)
    {
      double a, maxLot, minLot;
      a = (PercentageMM * AccountFreeMargin() / 100000);
      double LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
      maxLot  = MarketInfo(Symbol(), MODE_MAXLOT );
      minLot  = MarketInfo(Symbol(), MODE_MINLOT );   
      a =  MathFloor(a / LotStep) * LotStep;
      if (a > maxLot) return(maxLot);
      else if (a < minLot) return(minLot);
      else return(a);
    }    
   else return(Lots);
 }
 
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {

//Calculate digits
    if(Digits==5||Digits==3){ D=10;}
    else{D=1;}
    if(Digits<4)
   {
      point=0.01;
      SlipPage = SlipPage;
      gi_328 = 10;
   }
   else
   {
      point=0.0001;
      SlipPage = SlipPage*10;
      gi_328 = 1;
   }


   return(0);
  }
 
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| MaxSpread                                                        |
//+------------------------------------------------------------------+
bool Mspread() {
   double Spread = Ask-Bid;
   if(Spread <= MaxSpread * point)return (TRUE);
    return (FALSE);
}  


//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
  int cnt, ticket0, ticket1, ticket2, ticket3, total;

   if(Bars<100){
      Print("bars less than 100");
      return(0);
   }
//+------------------------------------------------------------------+
//| newsfilter                                                       |
//+------------------------------------------------------------------+
	bool ContinueTrading=true;
   if(AvoidNews && !IsTesting())
   {
   static int PrevMinute=-1;  
   
   int MinSinceNews=iCustom(NULL,0,"FFCal",true,true,false,true,true,1,0);
   int MinToNews=iCustom(NULL,0,"FFCal",true,true,false,true,true,1,1);
         
   int ImpactSinceNews=iCustom(NULL,0,"FFCal",true,true,false,true,true,2,0);
   int ImpactToNews=iCustom(NULL,0,"FFCal",true,true,false,true,true,2,1);

   if(Minute()!=PrevMinute)
   {
   PrevMinute=Minute();
   if((MinToNews<=MinsBeforeNews &&  ImpactToNews>=MinimumImpact) || (MinSinceNews<=MinsAfterNews && ImpactSinceNews>=MinimumImpact))ContinueTrading=false;
   }
	}
	
//+------------------------------------------------------------------+
//| trailing                                                         |
//+------------------------------------------------------------------+
	createlstoploss(StopLoss);
	createltakeprofit(TakeProfit);
	createsstoploss(StopLoss);
	createstakeprofit(TakeProfit);	

	if(TrailingStop>0)MoveTrailingStop();
	if(BreakEven>0)MoveBreakEven();	
//+------------------------------------------------------------------+
//| signals                                                          |
//+------------------------------------------------------------------+  
	int sign1, sign2, sign3, sign4, sign5, sign6, sign0;

// M5 signal
	if (M5) 
	{
	g_iclose_376 = iClose(NULL, PERIOD_M5, 1);
	g_ima_408 = iMA(NULL, PERIOD_M5, MA_Period, 0, MODE_SMMA, PRICE_CLOSE, 1);
	g_iwpr_392 = iWPR(NULL, PERIOD_M5, Williams_Period, 1);
	g_iatr_384 = iATR(NULL, PERIOD_M5, ATR_Period, 1);
	g_icci_400 = iCCI(NULL, PERIOD_M5, CCI_Period, PRICE_TYPICAL, 1);
	g_datetime_420 = iTime(Symbol(), 0, 0);
// buy	
	if (g_iclose_376 > g_ima_408 + Slippage_MA * gi_328 * point && g_iwpr_392 < (-1 * Level_Low) && g_icci_400 < Level_CCI_Low && g_iatr_384 > Level_ATR_Stop * gi_328 * point) sign0=1;	
// sell
	if (g_iclose_376 < g_ima_408 - Slippage_MA * gi_328 * point && g_iwpr_392 > (-1 * Level_High) && g_icci_400 > Level_CCI_High && g_iatr_384 > Level_ATR_Stop * gi_328 * point) sign0=-1;
   }

// M15 signal
	if (M15) 
	{
	g_iclose_376a = iClose(NULL, PERIOD_M15, 1);
	g_ima_408a = iMA(NULL, PERIOD_M15, MA_Perioda, 0, MODE_SMMA, PRICE_CLOSE, 1);
	g_iwpr_392a = iWPR(NULL, PERIOD_M15, Williams_Perioda, 1);
	g_iatr_384a = iATR(NULL, PERIOD_M15, ATR_Perioda, 1);
	g_icci_400a = iCCI(NULL, PERIOD_M15, CCI_Perioda, PRICE_TYPICAL, 1);
	g_datetime_420a = iTime(Symbol(), 0, 0);
// buy	
	if (g_iclose_376a > g_ima_408a + Slippage_MAa * gi_328 * point && g_iwpr_392a < (-1 * Level_Lowa) && g_icci_400a < Level_CCI_Lowa && g_iatr_384a > Level_ATR_Stopa * gi_328 * point) sign1=1;	
// sell
	if (g_iclose_376a < g_ima_408a - Slippage_MAa * gi_328 * point && g_iwpr_392a > (-1 * Level_Higha) && g_icci_400a > Level_CCI_Higha && g_iatr_384a > Level_ATR_Stopa * gi_328 * point) sign1=-1;
   }

// M30 signal
	if (M30) 
	{
	g_iclose_376b = iClose(NULL, PERIOD_M30, 1);
	g_ima_408b = iMA(NULL, PERIOD_M30, MA_Periodb, 0, MODE_SMMA, PRICE_CLOSE, 1);
	g_iwpr_392b = iWPR(NULL, PERIOD_M30, Williams_Periodb, 1);
	g_iatr_384b = iATR(NULL, PERIOD_M30, ATR_Periodb, 1);
	g_icci_400b = iCCI(NULL, PERIOD_M30, CCI_Periodb, PRICE_TYPICAL, 1);
	g_datetime_420b = iTime(Symbol(), 0, 0);
// buy	
	if (g_iclose_376b > g_ima_408b + Slippage_MAb * gi_328 * point && g_iwpr_392b < (-1 * Level_Lowb) && g_icci_400b < Level_CCI_Lowb && g_iatr_384b > Level_ATR_Stopb * gi_328 * point) sign2=1;	
// sell
	if (g_iclose_376b < g_ima_408b - Slippage_MAb * gi_328 * point && g_iwpr_392b > (-1 * Level_Highb) && g_icci_400b > Level_CCI_Highb && g_iatr_384b > Level_ATR_Stopb * gi_328 * point) sign2=-1;
   }
   

// H1 signal
	if (H1) 
	{
	g_iclose_376c = iClose(NULL, PERIOD_H1, 1);
	g_ima_408c = iMA(NULL, PERIOD_H1, MA_Periodc, 0, MODE_SMMA, PRICE_CLOSE, 1);
	g_iwpr_392c = iWPR(NULL, PERIOD_H1, Williams_Periodc, 1);
	g_iatr_384c = iATR(NULL, PERIOD_H1, ATR_Periodc, 1);
	g_icci_400c = iCCI(NULL, PERIOD_H1, CCI_Periodc, PRICE_TYPICAL, 1);
	g_datetime_420c = iTime(Symbol(), 0, 0);
// buy	
	if (g_iclose_376c > g_ima_408c + Slippage_MAc * gi_328 * point && g_iwpr_392c < (-1 * Level_Lowc) && g_icci_400c < Level_CCI_Lowc && g_iatr_384c > Level_ATR_Stopc * gi_328 * point) sign3=1;	
// sell
	if (g_iclose_376c < g_ima_408c - Slippage_MAc * gi_328 * point && g_iwpr_392c > (-1 * Level_Highc) && g_icci_400c > Level_CCI_Highc && g_iatr_384c > Level_ATR_Stopc * gi_328 * point) sign3=-1;
   }
   
// SAR, ADX
	double SARCurrent  = iSAR(NULL,PERIOD_M5,SAR_Step,SAR_Maximum, Current + 0);
	double SARPrevious = iSAR(NULL,PERIOD_M5,SAR_Step,SAR_Maximum, Current + 1);
	double ADX         = iADX(NULL,PERIOD_M5,ADX_Period, ADX_Price, ADX_Mode, Current + 0);
   if (SARCurrent<Bid && ADX>ADX_Level) sign5=1;
   if (SARCurrent>Ask && ADX>ADX_Level) sign5=-1;

//+------------------------------------------------------------------+
//| count orders                                                     |
//+------------------------------------------------------------------+
	int totalo;
	totalo=0;
	
	for(int io=0;io<OrdersTotal(); io++)
	{
	if(OrderSelect(io,SELECT_BY_POS,MODE_TRADES))
	if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber1)
	{
	totalo++;
	}
	}	
//+------------------------------------------------------------------+
//| close orders                                                     |
//+------------------------------------------------------------------+	
   int datetime_0 = 0;
   for (int pos_4 = 0; pos_4 < OrdersTotal(); pos_4++) 
	{
      if (OrderSelect(pos_4, SELECT_BY_POS, MODE_TRADES) == TRUE) 
		{
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber1) 
			{
            if (OrderType() == OP_BUY) {
               datetime_0 = OrderOpenTime();
               if (close_signal(0, OrderOpenPrice())) OrderClose(OrderTicket(), OrderLots(), Bid, SlipPage, Blue);
            }
            if (OrderType() == OP_SELL) {
               datetime_0 = OrderOpenTime();
               if (close_signal(1, OrderOpenPrice())) OrderClose(OrderTicket(), OrderLots(), Ask, SlipPage, Blue);
            }
         }
      }
   }

//+------------------------------------------------------------------+
//| open orders management                                           |
//+------------------------------------------------------------------+
//
   if(AccountFreeMargin()<(1000*Lots)){
      Print("We have no money. Free Margin = ", AccountFreeMargin());
      return(0);
   }

	static int TimeSent;
	
	if(TradeSession() && ContinueTrading && Mspread() && TimeCurrent() >= TimeSent + (WaitTime * 60) && totalo<1)  {
	
// buy order
	if (M5 && sign0==1) 
	{
	ticket0=OrderSend(Symbol(),OP_BUY,GetLots(),Ask,SlipPage,0,0,TradeComment,MagicNumber1,0,Green);
	TimeSent = TimeCurrent();
	if(ticket0<0)
	{
	Print("OrderSend failed with error #",GetLastError());
	return(0);
	}
	}
// sell order
	if (M5 && sign0==-1) 
	{
	ticket0=OrderSend(Symbol(),OP_SELL,GetLots(),Bid,SlipPage,0,0,TradeComment,MagicNumber1,0,Red);
	TimeSent = TimeCurrent();
	if(ticket0<0)
	{
	Print("OrderSend failed with error #",GetLastError());
	return(0);
	}
	}

// buy order
	if (M15 && sign1==1) 
	{
	ticket1=OrderSend(Symbol(),OP_BUY,GetLots(),Ask,SlipPage,0,0,TradeComment,MagicNumber1,0,Green);
	TimeSent = TimeCurrent();
	if(ticket1<0)
	{
	Print("OrderSend failed with error #",GetLastError());
	return(0);
	}
	}
// sell order
	if (M15 && sign1==-1) 
	{
	ticket1=OrderSend(Symbol(),OP_SELL,GetLots(),Bid,SlipPage,0,0,TradeComment,MagicNumber1,0,Red);
	TimeSent = TimeCurrent();
	if(ticket1<0)
	{
	Print("OrderSend failed with error #",GetLastError());
	return(0);
	}
	}

// buy order2 
	if (M30 && sign2==1 && sign5==1) 
	{
	ticket2=OrderSend(Symbol(),OP_BUY,GetLots(),Ask,SlipPage,0,0,TradeComment,MagicNumber1,0,Green);
	TimeSent = TimeCurrent();
	if(ticket2<0)
	{
	Print("OrderSend failed with error #",GetLastError());
	return(0);
	}
	}
// sell order2
	if (M30 && sign2==-1 && sign5==-1) 
	{
	ticket2=OrderSend(Symbol(),OP_SELL,GetLots(),Bid,SlipPage,0,0,TradeComment,MagicNumber1,0,Red);
	TimeSent = TimeCurrent();
	if(ticket2<0)
	{
	Print("OrderSend failed with error #",GetLastError());
	return(0);
	}
	}


// buy order3
	if (H1 && sign3==1 && sign5==1) 
	{
	ticket3=OrderSend(Symbol(),OP_BUY,GetLots(),Ask,SlipPage,0,0,TradeComment,MagicNumber1,0,Green);
	TimeSent = TimeCurrent();
	if(ticket3<0)
	{
	Print("OrderSend failed with error #",GetLastError());
	return(0);
	}
	}
// sell order3
	if (H1 && sign3==-1 && sign5==-1) 
	{
	ticket3=OrderSend(Symbol(),OP_SELL,GetLots(),Bid,SlipPage,0,0,TradeComment,MagicNumber1,0,Red);
	TimeSent = TimeCurrent();
	if(ticket3<0)
	{
	Print("OrderSend failed with error #",GetLastError());
	return(0);
	}
	}
}

//+------------------------------------------------------------------+
//| open orders end                                                  |
//+------------------------------------------------------------------+
   return(0);
  }


//+------------------------------------------------------------------+
//| trailing functions                                               |
//+------------------------------------------------------------------+

void MoveTrailingStop()
{
   
   for(int cnt=0;cnt<OrdersTotal();cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber1)
      {
         if(OrderType()==OP_BUY)
         {
            if(TrailingStop>0&&NormalizeDouble(Ask-TrailingStep*point,Digits)>NormalizeDouble(OrderOpenPrice()+TrailingStop*point,Digits))  
            {                 
               if((NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(Bid-TrailingStop*point,Digits))||(OrderStopLoss()==0))
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid-TrailingStop*point,Digits),OrderTakeProfit(),0,Blue);
                
               }
            }
         }
         else 
         {
            if(TrailingStop>0&&NormalizeDouble(Bid+TrailingStep*point,Digits)<NormalizeDouble(OrderOpenPrice()-TrailingStop*point,Digits))  
            {                 
               if((NormalizeDouble(OrderStopLoss(),Digits)>(NormalizeDouble(Ask+TrailingStop*point,Digits)))||(OrderStopLoss()==0))
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask+TrailingStop*point,Digits),OrderTakeProfit(),0,Red);
                
               }
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| breakeven                                                     |
//+------------------------------------------------------------------+
void MoveBreakEven()
{
   int cnt,total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber1)
      {
         if(OrderType()==OP_BUY)
         {
            if(BreakEven>0)
            {
               if(NormalizeDouble((Bid-OrderOpenPrice()),Digits)>BreakEven*point)
               {
                  if(NormalizeDouble((OrderStopLoss()-OrderOpenPrice()),Digits)<0)
                  {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+movestopto*point,Digits),OrderTakeProfit(),0,Blue);
                  
                  }
               }
            }
         }
         else
         {
            if(BreakEven>0)
            {
               if(NormalizeDouble((OrderOpenPrice()-Ask),Digits)>BreakEven*point)
               {
                  if(NormalizeDouble((OrderOpenPrice()-OrderStopLoss()),Digits)<0)
                  {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-movestopto*point,Digits),OrderTakeProfit(),0,Red);
               
                  }
               }
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| add TP & SL                                                      |
//+------------------------------------------------------------------+

void createlstoploss(double StopLoss){
   RefreshRates();
   for(int i=0;i<OrdersTotal();i++){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber1){
         if(OrderType()==OP_BUY){
            if(OrderStopLoss()==0){                 
               OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask-StopLoss*point,Digits),OrderTakeProfit(),0,Red);
               return(0);
            }
         }
      }
   }
}

void createsstoploss(double StopLoss){
   RefreshRates();
   for(int i=0;i<OrdersTotal();i++){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber1){
         if(OrderType()==OP_SELL){
            if(OrderStopLoss()==0){                 
               OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid+StopLoss*point,Digits),OrderTakeProfit(),0,Red);
               return(0);
            }
         }
      }
   }
}

void createltakeprofit(double TakeProfit){
   RefreshRates();
   for(int i=0;i<OrdersTotal();i++){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber1){
         if(OrderType()==OP_BUY){
            if(OrderTakeProfit()==0){                 
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(Ask+TakeProfit*point,Digits),0,Red);
               return(0);
            }
         }
      }
   }
}

void createstakeprofit(double TakeProfit){
   RefreshRates();
   int total=OrdersTotal();
   for(int i=0;i<OrdersTotal();i++){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber1){
         if(OrderType()==OP_SELL){
            if(OrderTakeProfit()==0){                 
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(Bid-TakeProfit*point,Digits),0,Red);
               return(0);
            }
         }
      }
   }
}


//+------------------------------------------------------------------+
//| close by signal                                                  |
//+------------------------------------------------------------------+   
bool close_signal(int ai_0, double ad_4) {
   if (ai_0 == 0) {
      if (Close_Williams > 0 && (-1.0 * g_iwpr_392) < Williams_Close_Buy && Only_Profit < 0 || Bid > ad_4 + Only_Profit * gi_328 * point) return (1);
      if (Close_CCI > 0 && g_icci_400 > CCI_Close_Buy) return (1);
      if (gi_224 > 0 && g_iatr_384 < gi_228 * gi_328 * point) return (1);
      if (gi_240 == 1 && iClose(NULL, 0, 1) < g_ima_408) return (1);
      if (gi_244 == 1 && g_ima_408 < iMA(NULL, 0, MA_Period, 0, MODE_SMMA, PRICE_CLOSE, 2)) return (1);
   }
   if (ai_0 == 1) {
      if (Close_Williams > 0 && (-1.0 * g_iwpr_392) > Williams_Close_Sell && Only_Profit < 0 || Ask < ad_4 - Only_Profit * gi_328 * point) return (1);
      if (Close_CCI > 0 && g_icci_400 < CCI_Close_Sell) return (1);
      if (gi_224 > 0 && g_iatr_384 < gi_228 * gi_328 * point) return (1);
      if (gi_240 == 1 && iClose(NULL, 0, 1) > g_ima_408) return (1);
      if (gi_244 == 1 && g_ima_408 > iMA(NULL, 0, MA_Period, 0, MODE_SMMA, PRICE_CLOSE, 2)) return (1);
   }
   return (0);
}	
//+------------------------------------------------------------------+
//| end                                                              |
//+------------------------------------------------------------------+