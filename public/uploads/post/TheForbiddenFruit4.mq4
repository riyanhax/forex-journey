
#property copyright "Cuong V Truong"


extern int AccountMarginValue = 500;
extern int TakeProfit=10;
extern int StopLoss=5000;
extern double LotSize = 0.01;
extern double MaxOrders = 150;
extern double MaxSpread = 20;
extern double BarsToLookBack = 400; // This variable is for iHighest and iLowest values.
string EAname = "TheForbiddenFruit";


/*
static input string SettingForSellBox1 = "---------------------"; // ------ Expert Settings ------
//SellBox1 
extern bool ActivateSellBox = False; // Turn it on or off
//BuyBox1
extern bool ActivateBuyBox = False; // Turn it on or off
*/

static input string PriceSettings = "---------------------"; // ------ Expert Settings ------
extern double MustBeLower  = 1.10; //Price must be lower than this value to sell
extern double MustBeHigher = 1.06; //Price must be higher than this value to sell


/*
static input string PriceBreakOutOfBox = "---------------------"; // ------ Expert Settings ------
extern bool ActivateBreakOutAbove = False; // Turn it on or off
extern double PriceBreakOutAbove = 0;
extern bool ActivateBreakDownBelow = False; // Turn it on or off
extern double PriceBreakDownBelow = 0;

extern double StartingDeposit = 1000;
extern double MoneyAboveBalance=10; //how much profit above the balance before EA can close trades

*/

/*
static input string AutoClose = "---------------------"; // ------ Expert Settings ------
extern bool ActivateAutoCloseBreakOutOfRange = False; // Turn it on or off
extern double HowManyPipsToAutoClose = 10;
*/


static input string OtherSettings = "---------------------"; // ------ Expert Settings ------

extern bool UseMoveToBreakeven=false;
 int 	WhenToMoveToBE=2;
extern int  PipsToLockIn=5;
extern bool UseTrailingStop = false;
extern  int  WhenToTrail=100;
extern  int  TrailAmount=100;

  bool UseCandleTrail=false;
  int  PadAmount=10;
  int  CandlesBack=5;
  bool UsePercentStop=false;
  double  RiskPercent=2;//in the video these were integers. I changed them to doubles so that you could use 0.5% risk if you wish.
  bool UsePercentTakeProfit=false;
  double  RewardPercent=4;
 int  FastMA=5;
 int  FastMaShift=0;
 int  FastMaMethod=1;
 int  FastMaAppliedTo=0;
 int  SlowMA=10;
 int  SlowMaShift=0;
 int  SlowMaMethod=1;
 int  SlowMaAppliedTo=0;

extern int  MagicNumber = 9151982;
double      pips;


extern double slip = 3.0;
double totaltrades;
int CountTrades;
int AccountMargin;

double HalfPrice = (MustBeLower+MustBeHigher) /2;

// double CloseBuyValue = 1.03; //price of EURUSD at 52 weeks low
// double CloseSellValue = 1.17; //price of EURUSD at 52 weeks high


//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   	double ticksize = MarketInfo(Symbol(), MODE_TICKSIZE);
   	if (ticksize == 0.00001 || ticksize == 0.001)
	   pips = ticksize*10;
	   else pips =ticksize;
	  
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {


//========================================================================
//=================== Display Account information ========================
int CurrentBalance = DoubleToStr(AccountBalance());
int CurrentEquity  = DoubleToStr(AccountEquity());


Comment(StringFormat("Show prices \nAsk = %G \nBid = %G \nBalance = %d \nEquity = %d ",Ask,Bid,CurrentBalance,CurrentEquity));

//========================================================================
//========================================================================

if( (AccountMargin >= AccountMarginValue) && (MarketInfo(NULL,MODE_SPREAD) < MaxSpread) )
      {
         MarketInfo(NULL,MODE_TRADEALLOWED);
         return;
      };  
   
  
  /*
  if(OpenOrdersThisPair(Symbol())>=1)
   {
      if(UseMoveToBreakeven)MoveToBreakeven();
      if(UseTrailingStop)AdjustTrail();
   }
 */
  // if(UseMoveToBreakeven)MoveToBreakeven();
 //  if(UseTrailingStop)AdjustTrail();
   
//    CheckForMaTrade();

BuySell();




   
//----
  
  }
//+------------------------------------------------------------------+
//Move to breakeven function
//+------------------------------------------------------------------+
void MoveToBreakeven()
{
   for(int b=OrdersTotal()-1; b >= 0; b--)
	{
	if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
      if(OrderMagicNumber()== MagicNumber)
         if(OrderSymbol()==Symbol())
            if(OrderType()==OP_BUY)
               if(Bid-OrderOpenPrice()>WhenToMoveToBE*pips)
                  if(OrderOpenPrice()>OrderStopLoss())
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+(PipsToLockIn*pips),OrderTakeProfit(),0,CLR_NONE)) GetLastError() ;
                       
   }
   for (int s=OrdersTotal()-1; s >= 0; s--)
	     {
         if(OrderSelect(s,SELECT_BY_POS,MODE_TRADES))
	        if(OrderMagicNumber()== MagicNumber)
	           if(OrderSymbol()==Symbol())
	              if(OrderType()==OP_SELL)
                  if(OrderOpenPrice()-Ask>WhenToMoveToBE*pips)
                     if(OrderOpenPrice()<OrderStopLoss())    
                        if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-(PipsToLockIn*pips),OrderTakeProfit(),0,CLR_NONE)) GetLastError();
        }
}
//+------------------------------------------------------------------+
//trailing stop function
//+------------------------------------------------------------------+
void AdjustTrail()
{
int buyStopCandle= iLowest(NULL,0,1,CandlesBack,1); 
int sellStopCandle=iHighest(NULL,0,2,CandlesBack,1); 

//buy order section
      for(int b=OrdersTotal()-1;b>=0;b--)
	      {
         if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
           if(OrderMagicNumber()==MagicNumber)
              if(OrderSymbol()==Symbol())
                  if(OrderType()==OP_BUY)
                     if(UseCandleTrail)
                        {  if(IsNewCandle())
                              if(OrderStopLoss()<Low[buyStopCandle]-PadAmount*pips)
                                 if(!OrderModify(OrderTicket(),OrderOpenPrice(),Low[buyStopCandle]-PadAmount*pips,OrderTakeProfit(),0,CLR_NONE)) GetLastError();
                        }
                     else  if(Bid-OrderOpenPrice()>WhenToTrail*pips) 
                              if(OrderStopLoss()<Bid-pips*TrailAmount)
                                 if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid-(TrailAmount*pips),OrderTakeProfit(),0,CLR_NONE)) GetLastError();
         }
//sell order section
      for(int s=OrdersTotal()-1;s>=0;s--)
	      {
         if(OrderSelect(s,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()== MagicNumber)
               if(OrderSymbol()==Symbol())
                  if(OrderType()==OP_SELL)
                    if(UseCandleTrail)
                       {   if(IsNewCandle())
                              if(OrderStopLoss()>High[sellStopCandle]+PadAmount*pips)
                                 if(!OrderModify(OrderTicket(),OrderOpenPrice(),High[sellStopCandle]+PadAmount*pips,OrderTakeProfit(),0,CLR_NONE)) GetLastError();
                       }
                    else   if(OrderOpenPrice()-Ask>WhenToTrail*pips)
                              if(OrderStopLoss()>Ask+TrailAmount*pips)
                                 if(!OrderModify(OrderTicket(),OrderOpenPrice(),Ask+(TrailAmount*pips),OrderTakeProfit(),0,CLR_NONE)) GetLastError();
         }
}
//+------------------------------------------------------------------+
//insuring its a new candle function
//+------------------------------------------------------------------+
bool IsNewCandle()
{
   static int BarsOnChart=0;
	if (Bars == BarsOnChart)
	return (false);
	BarsOnChart = Bars;
	return(true);
}


//+------------------------------------------------------------------+
//order entry function
//+------------------------------------------------------------------+
void OrderEntry(int direction)
{
   double Equity=AccountEquity();
   double RiskedAmount=Equity*RiskPercent*0.01;
   double RewardAmount=Equity*RewardPercent*0.01;
   Comment(RewardAmount);
   if(direction==0)
   {
      double bsl=0;
      double btp=0;
      if(StopLoss!=0)bsl=Ask-(StopLoss*pips);
      if(UsePercentStop)bsl=Ask-(RiskedAmount/(LotSize*10))*pips;
      if(TakeProfit!=0)btp=Ask+(TakeProfit*pips);
      if(UsePercentTakeProfit)btp=Ask+(RewardAmount/(LotSize*10))*pips;
      if(OpenOrdersThisPair(Symbol())>=0)
      
      int buyticket = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,0,0,EAname,MagicNumber,0,Green);
      if(buyticket>0)
      if(!OrderModify(buyticket,OrderOpenPrice(),bsl,btp,0,CLR_NONE)) GetLastError();
   }
   
   if(direction==1)
   {
      double ssl=0;
      double stp=0;
      if(StopLoss!=0)ssl=Bid+(StopLoss*pips);
      if(UsePercentStop)ssl=Bid+(RiskedAmount/(LotSize*10))*pips;
      if(TakeProfit!=0)stp=Bid-(TakeProfit*pips);
      if(UsePercentTakeProfit)stp=Bid-(RewardAmount/(LotSize*10))*pips;
      if(OpenOrdersThisPair(Symbol())>=0)

      int sellticket = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,0,0,EAname,MagicNumber,0,Red);
      if(sellticket>0)
      if(!OrderModify(sellticket,OrderOpenPrice(),ssl,stp,0,CLR_NONE)) GetLastError();
   }
   
}
//+------------------------------------------------------------------+
//checks to see if any orders open on this currency pair.
//+------------------------------------------------------------------+
int OpenOrdersThisPair(string pair)
{
  int total=0;
   for(int i=OrdersTotal()-1; i >= 0; i--)
	  {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderSymbol()== pair) total++;
	  }
	  return (total);
}

//+------------------------------------------------------------------+

void CloseAllOrders() {
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--) {
      if(!OrderSelect(trade, SELECT_BY_POS, MODE_TRADES))continue;
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if ( (OrderType() == OP_BUY) || (OrderType()== OP_SELL) ) 
            if(!OrderClose(OrderTicket(), OrderLots(), Bid, slip, Blue)) GetLastError();
         }
         Sleep(1000);
      }
   }
}

void CloseBuy() {
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--) {
      if(!OrderSelect(trade, SELECT_BY_POS, MODE_TRADES))continue;
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) 
             if(!OrderClose(OrderTicket(), OrderLots(), Bid, slip, Blue)) GetLastError();
         }
         Sleep(1000);
      }
   }
}

void CloseSell() {
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--) {
      if(!OrderSelect(trade, SELECT_BY_POS, MODE_TRADES))continue;
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_SELL) 
             if(!OrderClose(OrderTicket(), OrderLots(), Bid, slip, Blue)) GetLastError();
         }
         Sleep(1000);
      }
   }
}

double CalculateProfit() {
   double Profit = 0;
   double cnt;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      if(!OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES))continue;
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) Profit += OrderProfit();
   }
   return (Profit);
}

int CountBuyTrades() {
   int countbuytrade = 0;
   for (int buytrade = OrdersTotal() - 1; buytrade >= 0; buytrade--) {
      if(!OrderSelect(buytrade, SELECT_BY_POS, MODE_TRADES)) continue;
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_BUY) countbuytrade++;
   }
   return (countbuytrade);
}

int CountSellTrades() {
   int countselltrade = 0;
   for (int selltrade = OrdersTotal() - 1; selltrade >= 0; selltrade--) {
      if(!OrderSelect(selltrade, SELECT_BY_POS, MODE_TRADES)) continue;
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_SELL) countselltrade++;
   }
   return (countselltrade);
}

//======================================================


//============================================= Start of Buy Box 1 ==================================
//==================== BUY RULE Range 1 box =========================================================
//==================== Important: Price can be in narrow range ======================================
//====================            Variables can be created for user to input ========================
//==================== Note: In smaller range, the number of bars to look back might be less ========
//==================== Bool: Create option to turn range 1 box true or false ========================
//===================================================================================================
// Buy Rule when price is above $1 and below $1.06
void BuySell()
{
    if(  (Bid >  MustBeHigher) && (Bid < HalfPrice) ) 
      {
         double MaxBuyTrades = CountBuyTrades();
         if( (MaxBuyTrades < MaxOrders) && Bid < iLowest(NULL,0,0,BarsToLookBack,0)  && (iMACD(NULL,0,1,2,2,0,0,0) < 0) && (iDeMarker(NULL,0,14,0) < 0.3) &&  (Bid < iMA(NULL,0,1,0,0,PRICE_MEDIAN,0)) && (iCCI(NULL,0,3,0,0) <= -100) ) //buy rule
         if(IsNewCandle()) 
         OrderEntry(0);   
            
       }
   else
   {
     if((Bid < MustBeLower) && (Bid > HalfPrice) )
      {
         double MaxSellTrades = CountSellTrades();
         if( (MaxSellTrades < MaxOrders) && Bid > iHighest(NULL,0,0,BarsToLookBack,0) && (iMACD(NULL,0,1,2,2,0,0,0) > 0) && (iDeMarker(NULL,0,14,0) > 0.7) && (Bid > iMA(NULL,0,1,0,0,PRICE_MEDIAN,0)) && (iCCI(NULL,0,3,0,0) >= 100) ) //sell rule
         if(IsNewCandle()) 
          OrderEntry(1);
         
      }
   } 
};
//============================================= End of Buy Box 1 ====================================
//===================================================================================================



/*
//============================================= Start of Sell Box 1 =================================
//==================== SELL RULE Range 1 box ========================================================
//==================== Important: Price can be in narrow range ======================================
//====================            Variables can be created for user to input ========================
//==================== Note: In smaller range, the number of bars to look back might be less ========
//==================== Bool: Create option to turn range 1 box true or false ========================
//===================================================================================================
// Sell Rule - Sell when price is above $1.06 and below $1.10
void SellRule()
{
   if(ActivateSellBox == True)
   {
     if((Bid < MustBeLower) && (Bid > HalfPrice) )
      {
         double MaxSellTrades = CountSellTrades();
         if( (MaxSellTrades < MaxOrders) && Bid > iHighest(NULL,0,0,BarsToLookBack,0) && (iMACD(NULL,0,1,2,2,0,0,0) > 0) && (iDeMarker(NULL,0,14,0) > 0.7) && (Bid > iMA(NULL,0,1,0,0,PRICE_MEDIAN,0)) && (iCCI(NULL,0,3,0,0) >= 100) ) //sell rule
         if(IsNewCandle()) 
          OrderEntry(1);
         
      }
   }
};
//============================================= End of Sell Box 1 ====================================
//===================================================================================================

*/

/* This function won't work, need to fix it later
//--- SELL rule long range
double HighBidAmount = Bid + (200*pips);
 if( ( HighBidAmount > iMA(NULL,0,200,0,0,0,0)) && (Bid > iHighest(NULL,0,0,5,0)) )
 {
   if(IsNewCandle()) OrderEntry(1);
    OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,0,0,NULL,MagicNumber,0,Yellow); 
 }
*/





// Sell if price is 250 pips above 20 days MA
// Need its own order function with trailing.
// Sell if Bid is greater than iLowest(2000 bars).

// Price crossover (is it possible?) (is this called MovingAverage cross)
// if price cross down $1.05 then cross up to $1.17



// create a loop to check for account balance. if profit less than starting balance then break out of loop
// 'for loop' must also count profits earned inside of range box.
// I'll try to put this 'for loop' inside or outside of buybox1 and sellbox1.


/*
//===================================================================================================
//============================ Beginning of Price Breakout function =================================
// rule to close sell order if price breakout above
if(ActivateBreakOutAbove == True)
{
if( (Bid > PriceBreakOutAbove) && (AccountBalance() > (StartingDeposit + MoneyAboveBalance) ) ) CloseAllOrders();
};
// rule to close buy order if price breakdown below
if(ActivateBreakDownBelow == True)
{
if(  (Bid < PriceBreakDownBelow) && (AccountBalance() > (StartingDeposit + MoneyAboveBalance) ) ) CloseAllOrders();
};

// This code is not working properly. Need fix

// Maybe I should add a time expired function to close all trades if AccountBalance is > then StartingDeposit.
//============================ End of Price Breakout function =======================================
//===================================================================================================
*/


/*

//===================================================================================================
//================================== Saftey Features Function =======================================

if( (MarketInfo(NULL,MODE_SPREAD) < MaxSpread) && (AccountBalance() > (StartingDeposit + MoneyAboveBalance)) ) CloseAllOrders();

//===================================================================================================
//===================================================================================================

*/


/*

//===================================================================================================
//============================ Auto Close Range incase of Breakout ==================================
// This function automatically close if price move outside the range box.
if(ActivateAutoCloseBreakOutOfRange == True)
{
if( (Bid > (MustBeHigher + (HowManyPipsToAutoClose*pips))) && (AccountBalance() > (StartingDeposit + MoneyAboveBalance) ) ) CloseAllOrders();
if( (Bid < (MustBeLower  - (HowManyPipsToAutoClose*pips))) && (AccountBalance() > (StartingDeposit + MoneyAboveBalance) ) ) CloseAllOrders();
};

// This box caused trading error, need to fix.
//===================================================================================================
//===================================================================================================

*/

// Close all buy order if price is below $1.05
// CLose all sell order if price is above $1.18

//////================================================

/*

//closing buy function    
   if(Ask < CloseBuyValue)
{
      
   if(OrderType()==OP_BUY)
   CloseBuy();
}

//closing buy function    
   if(Bid <  iBands(NULL,0,200,2,0,0,0,0) )
{
      
       for (int buytrade = OrdersTotal() - 1; buytrade >= 0; buytrade--) 
       {
         if(OrderSelect(buytrade, SELECT_BY_POS, MODE_TRADES) );
          if(OrderMagicNumber()== MagicNumber)
               if(OrderSymbol()==Symbol())
                  if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, slip, Blue);
       }
}

//closing sell function 
if(Bid > CloseSellValue)
{
   
   if(OrderType()==OP_SELL)
    CloseSell();
}

//closing sell function    
   if(Bid > iBands(NULL,0,200,2,0,0,0,0) )
{
      
       for (int selltrade = OrdersTotal() - 1; selltrade >= 0; selltrade--) 
       {
         if(OrderSelect(selltrade, SELECT_BY_POS, MODE_TRADES) );
          if(OrderMagicNumber()== MagicNumber)
               if(OrderSymbol()==Symbol())
                  if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), Bid, slip, Blue);
       }
}
   

*/