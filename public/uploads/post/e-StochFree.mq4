
#property copyright "© 2009 BJF Trading Group inc."
#property link      "www.iticsoftware.com"

#define major   1
#define minor   0

extern string _tmp1_ = " --- Trade params ---";
extern int AccDigits = 5;
extern double Lots = 1.0;
extern int StopLoss = 100;
extern int TakeProfit = 100;
extern int Slippage = 3;
extern int Magic = 20091107;

extern string _tmp2_ = " --- Stochastic ---";
extern int Stoch.Kperiod = 5;
extern int Stoch.Dperiod = 3;
extern int Stoch.slowing = 3;
extern int Stoch.method = MODE_SMA;
extern int Stoch.price_field = 0;
extern int Stoch.SignalBar = 1;
extern double Stoch.OverboughtLevel = 80.0; 
extern double Stoch.OversoldLevel = 20.0; 


extern string _tmp3_ = " --- Trailing ---";
extern bool TrailingOn = true;
extern int TrailingStart = 30;
extern int TrailingSize = 30;

extern string _tmp4_ = " --- Chart ---";
extern color clBuy = DodgerBlue;
extern color clSell = Red;
extern color clModify = Silver;
extern color clClose = Gold;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#include <stdlib.mqh>
#include <stderror.mqh>

int RepeatN = 5;

int BuyCnt, SellCnt;
int BuyStopCnt, SellStopCnt;
int BuyLimitCnt, SellLimitCnt;

void init() 
{
}

void deinit() 
{
}

void start() 
{
  //-----

  if (TrailingOn) TrailPositions();  

  //-----
  
  double STO_M1 = iStochastic(NULL, 0, Stoch.Kperiod, Stoch.Dperiod, Stoch.slowing, Stoch.method, Stoch.price_field, MODE_MAIN, Stoch.SignalBar);
  double STO_M2 = iStochastic(NULL, 0, Stoch.Kperiod, Stoch.Dperiod, Stoch.slowing, Stoch.method, Stoch.price_field, MODE_MAIN, Stoch.SignalBar+1);
  
  //-----
  
  if (OrdersCountBar0(0) > 0) return;
  
  RecountOrders();

  //-----
     
  double price, sl, tp;
  int ticket;

  if (STO_M1 > Stoch.OversoldLevel && STO_M2 <= Stoch.OversoldLevel)
  {
    if (BuyCnt > 0) return;
    if (CloseOrders(OP_SELL) > 0) return;
    
    //-----
    
    for (int i=0; i<RepeatN; i++)
    {
      RefreshRates();
      price = Ask;
  
      sl = If(StopLoss > 0, price - StopLoss*Point*fpc(), 0);
      tp = If(TakeProfit > 0, price + TakeProfit*Point*fpc(), 0);

      ticket = Buy(Symbol(), GetLots(), price, sl, tp, Magic);
      if (ticket > 0) break;
    }

    return;
  }

  if (STO_M1 < Stoch.OverboughtLevel && STO_M2 >= Stoch.OverboughtLevel)
  {
    if (SellCnt > 0) return;
    if (CloseOrders(OP_BUY) > 0) return;
    
    //-----    
      
    for (i=0; i<RepeatN; i++)
    {  
      RefreshRates();
      price = Bid;
    
      sl = If(StopLoss > 0, price + StopLoss*Point*fpc(), 0);
      tp = If(TakeProfit > 0, price - TakeProfit*Point*fpc(), 0);

      ticket = Sell(Symbol(), GetLots(), price, sl, tp, Magic);
      if (ticket > 0) break;
    }

    return;
  } 
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double If(bool cond, double if_true, double if_false)
{
  if (cond) return (if_true);
  return (if_false);
}

int fpc()
{
  if (AccDigits == 5) return (10);
  if (AccDigits == 6) return (100);
  return (1); 
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double GetLots() 
{
  return (Lots);
}

void RecountOrders()
{
  BuyCnt = 0;
  SellCnt = 0;
  BuyStopCnt = 0;
  SellStopCnt = 0;
  BuyLimitCnt = 0;
  SellLimitCnt = 0;

  int cnt = OrdersTotal();
  for (int i=0; i < cnt; i++) 
  {
    if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
    if (OrderSymbol() != Symbol()) continue;
    if (OrderMagicNumber() != Magic) continue;
    
    int type = OrderType();
    if (type == OP_BUY) BuyCnt++;
    if (type == OP_SELL) SellCnt++;
    if (type == OP_BUYSTOP) BuyStopCnt++;
    if (type == OP_SELLSTOP) SellStopCnt++;
    if (type == OP_BUYLIMIT) BuyLimitCnt++;
    if (type == OP_SELLLIMIT) SellLimitCnt++;
  }
}

int OrdersCountBar0(int TF)
{
  int orders = 0;

  int cnt = OrdersTotal();
  for (int i=0; i<cnt; i++) 
  {
    if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
    if (OrderSymbol() != Symbol()) continue;
    if (OrderMagicNumber() != Magic) continue;

    if (OrderOpenTime() >= iTime(NULL, TF, 0)) orders++;
  }

  cnt = OrdersHistoryTotal();
  for (i=0; i<cnt; i++) 
  {
    if (!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) continue;
    if (OrderSymbol() != Symbol()) continue;
    if (OrderMagicNumber() != Magic) continue;

    if (OrderOpenTime() >= iTime(NULL, TF, 0)) orders++;
  }
 
  return (orders);
}

int CloseOrders(int type1, int type2 = -1) 
{  
  int cnt = OrdersTotal();
  for (int i=cnt-1; i >= 0; i--) 
  {
    if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
    if (OrderSymbol() != Symbol()) continue;
    if (OrderMagicNumber() != Magic) continue;
    
    int type = OrderType();
    if (type != type1 && type != type2) continue;
    
    if (type == OP_BUY) 
    {
      RefreshRates();
      CloseOrder(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID));
      continue;
    }
    
    if (type == OP_SELL) 
    {
      RefreshRates();
      CloseOrder(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK));
      continue;
    }    
  }
  
  int orders = 0;
  cnt = OrdersTotal();
  for (i = 0; i < cnt; i++) 
  {
    if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
    if (OrderSymbol() != Symbol()) continue;
    if (OrderMagicNumber() != Magic) continue;
    
    type = OrderType();
    if (type != type1 && type != type2) continue;
    
    orders++;
  }
  
  return (orders); 
}

void TrailPositions()
{
  int StopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL) + 1;
  double sl;
  
  int cnt = OrdersTotal();
  for (int i=0; i<cnt; i++) 
  {
    if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
    if (OrderSymbol() != Symbol()) continue;
    if (OrderMagicNumber() != Magic) continue;

    int type = OrderType();
    if (type == OP_BUY) 
    {
      if (Bid-OrderOpenPrice() > TrailingStart*Point*fpc()) 
      {
        sl = Bid - TrailingSize*Point*fpc();
                
        if (sl >= Bid - StopLevel*Point) continue;
        
        if (OrderStopLoss() < sl - 1*Point*fpc()) 
        {
          OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), 0, clModify);
        }
      }
    }

    if (type == OP_SELL)
    {
      if (OrderOpenPrice()-Ask > TrailingStart*Point*fpc()) 
      {
        sl = Ask + TrailingSize*Point*fpc();
        
        if (sl <= Ask + StopLevel*Point) continue;
        
        if (OrderStopLoss() > sl + 1*Point*fpc() || OrderStopLoss() == 0) 
        {
          OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), 0, clModify);
        }
      }
    }
  }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int SleepOk = 2000;
int SleepErr = 6000;

int Buy(string symbol, double lot, double price, double sl, double tp, int magic, string comment="") 
{
  int dig = MarketInfo(symbol, MODE_DIGITS);

  price = NormalizeDouble(price, dig);
  sl = NormalizeDouble(sl, dig);
  tp = NormalizeDouble(tp, dig);
    
  string _lot = DoubleToStr(lot, 2);
  string _price = DoubleToStr(price, dig);
  string _sl = DoubleToStr(sl, dig);
  string _tp = DoubleToStr(tp, dig);

  Print("Buy \"", symbol, "\", ", _lot, ", ", _price, ", ", Slippage, ", ", _sl, ", ", _tp, ", ", magic, ", \"", comment, "\"");

  int res = OrderSend(symbol, OP_BUY, lot, price, Slippage, sl, tp, comment, magic, 0, clBuy);
  if (res >= 0) {
    Sleep(SleepOk);
    return (res);
  } 	
   	
  int code = GetLastError();
  Print("Error opening BUY order: ", ErrorDescription(code), " (", code, ")");
  Sleep(SleepErr);
	
  return (-1);
}

int Sell(string symbol, double lot, double price, double sl, double tp, int magic, string comment="") 
{
  int dig = MarketInfo(symbol, MODE_DIGITS);

  price = NormalizeDouble(price, dig);
  sl = NormalizeDouble(sl, dig);
  tp = NormalizeDouble(tp, dig);
  
  string _lot = DoubleToStr(lot, 2);
  string _price = DoubleToStr(price, dig);
  string _sl = DoubleToStr(sl, dig);
  string _tp = DoubleToStr(tp, dig);

  Print("Sell \"", symbol, "\", ", _lot, ", ", _price, ", ", Slippage, ", ", _sl, ", ", _tp, ", ", magic, ", \"", comment, "\"");
  
  int res = OrderSend(symbol, OP_SELL, lot, price, Slippage, sl, tp, comment, magic, 0, clSell);
  if (res >= 0) {
    Sleep(SleepOk);
    return (res);
  } 	
   	
  int code = GetLastError();
  Print("Error opening SELL order: ", ErrorDescription(code), " (", code, ")");
  Sleep(SleepErr);
	
  return (-1);
}

bool CloseOrder(int ticket, double lot, double price) 
{
  if (!OrderSelect(ticket, SELECT_BY_TICKET)) return(false);
  if (OrderCloseTime() > 0) return(false);
  
  int dig = MarketInfo(OrderSymbol(), MODE_DIGITS);
  string _lot = DoubleToStr(lot, 2);
  string _price = DoubleToStr(price, dig);

  Print("CloseOrder ", ticket, ", ", _lot, ", ", _price, ", ", Slippage);
  
  bool res = OrderClose(ticket, lot, price, Slippage, clClose);
  if (res) {
    Sleep(SleepOk);
    return (res);
  } 	
   	
  int code = GetLastError();
  Print("CloseOrder failed: ", ErrorDescription(code), " (", code, ")");
  Sleep(SleepErr);
	
  return (false);
}


