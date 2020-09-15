//+------------------------------------------------------------------+
//|                                                          kutu.mq4|
//|                                                                  |
//|To be run on any charts only. Use at your own risk.               |
//+------------------------------------------------------------------+


#include <stdlib.mqh>
//+------------------------------------------------------------------+
//| Common External variables                                        |
//+------------------------------------------------------------------+
extern double Lots = 0.1;
extern double StopLoss = 0.00;
extern double TakeProfit = 10.00;
extern double TrailingStop = 0.00;

//+------------------------------------------------------------------+
//| External variables                                               |
//+------------------------------------------------------------------+
extern double MaxTrades = 10;
extern double Pips = 10;
extern double SecureProfit = 10;
extern double AccountProtection = 1;
extern double OrderstoProtect = 3;
extern double ReverseCondition = 0;
extern double EURUSDPipValue = 10;
extern double GBPUSDPipValue = 10;
extern double USDCHFPipValue = 7.94;
extern double USDJPYPipValue = 9.03;
extern double mm = 0;
extern double risk = 12;
extern double AccountisNormal = 0;
extern double TimeZoneofData = 0;

//+------------------------------------------------------------------+
//| Global variables                                               |
//+------------------------------------------------------------------+
double OpenOrders = 0;
int cnt = 0;
double slippage = 5;
double sl = 0;
double tp = 0;
double BuyPrice = 0;
double SellPrice = 0;
double lotsi = 0;
double mylotsi = 0;
double mode = 0;
double MyOrderType=0;
bool ContinueOpening = True;
double LastPrice = 0;
double PreviousOpenOrders = 0;
double Profit = 0;
double LastTicket = 0;
double LastType = 0;
double LastClosePrice = 0;
double LastLots = 0;
double PipValue = 0;
bool Reversed = False;
string text = "";
string text2 = "";
double Loop = 0;



//+------------------------------------------------------------------+
//| Initialization                                                   |
//+------------------------------------------------------------------+

int init()
{
   return(0);
}
int start()
{
//+------------------------------------------------------------------+
//| Local variables                                                  |
//+------------------------------------------------------------------+

if( AccountisNormal == 1 ) {
   if( mm != 0 ) lotsi = MathCeil(AccountBalance() * risk / 10000) ; else lotsi = Lots;
}
else {
   if( mm != 0 ) lotsi = MathCeil(AccountBalance() * risk / 10000) / 10 ; else lotsi = Lots;
}

if( lotsi > 100 ) lotsi = 100;

OpenOrders = 0;
for( cnt = 0; cnt < OrdersTotal(); cnt++ ) {
   OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
   if( OrderSymbol() ==  Symbol() ) OpenOrders++;
}

      
if( PreviousOpenOrders > OpenOrders ) {
   for( cnt = OrdersTotal()-1; cnt >= 0; cnt-- ) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      mode = OrderType();
      if( OrderSymbol() == Symbol() ) {
         if( mode ==  OP_BUY )  OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slippage,Blue);
         if( mode ==  OP_SELL ) OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slippage,Red);
         return(0);
      }
   }
}

PreviousOpenOrders = OpenOrders;
if( OpenOrders >= MaxTrades ) ContinueOpening = False ; else ContinueOpening = True;

if( LastPrice == 0 ) {
   for( cnt = 0; cnt < OrdersTotal(); cnt++ ) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if( OrderSymbol() == Symbol() ) {
         LastPrice = OrderOpenPrice();
         if(OrderType()==OP_BUY)  MyOrderType=2;
         if(OrderType()==OP_SELL)  MyOrderType=1;
      }
   }
}

double bucuatas, bucubawah, teatas30, tebawah30;
double biru1, biru30, biru60, biru240, merah1, merah30, merah60, merah240;

   //teatas1=iCustom(0,PERIOD_M1,"TraderWawasan TE v2.0",0,0);
   //tebawah1=iCustom(0,PERIOD_M1,"TraderWawasan TE v2.0",1,0);
   teatas30=iCustom(0,PERIOD_M30,"TraderWawasan TE v2.0",0,0);
   teatas30=iCustom(0,PERIOD_M30,"TraderWawasan TE v2.0",1,0);
   biru1=iCustom(0,PERIOD_M1,"TraderWawasan MACD",0,0);
   biru30=iCustom(0,PERIOD_M30,"TraderWawasan MACD",0,0);
   biru60=iCustom(0,PERIOD_H1,"TraderWawasan MACD",0,0);
   biru240=iCustom(0,PERIOD_H4,"TraderWawasan MACD",0,0);
   merah1=iCustom(0,PERIOD_M1,"TraderWawasan MACD",1,0);
   merah30=iCustom(0,PERIOD_M30,"TraderWawasan MACD",1,0);
   merah60=iCustom(0,PERIOD_H1,"TraderWawasan MACD",1,0);
   merah240=iCustom(0,PERIOD_H4,"TraderWawasan MACD",1,0); 
   bucuatas=iCustom(0,PERIOD_M1,"ZigZag",0,0);
   bucubawah=iCustom(0,PERIOD_M1,"ZigZag",1,0);


if( OpenOrders < 1 ) MyOrderType=0;
if( OpenOrders < 1 && bucuatas < bucubawah && biru60<merah60 && biru240<merah240 ) {
   LastPrice = 0;
   MyOrderType=1; //sell condition
}
if( OpenOrders < 1 && bucuatas > bucubawah && biru60>merah60 && biru240>merah240) {
   LastPrice = 0;
   MyOrderType=2; //buy condition
}

for( cnt = OrdersTotal()-1; cnt >= 0; cnt-- ) {
   OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
   if( OrderSymbol() == Symbol() && Reversed == False ) {
      if( OrderType() ==  OP_SELL ) {
         if( TrailingStop > 0 ) {
            if( OrderOpenPrice() - Ask >= TrailingStop * Point + Pips * Point ) {
               if( OrderStopLoss() > Ask + Point * TrailingStop || OrderStopLoss() ==  0 ) {
                  OrderModify(OrderTicket(),OrderOpenPrice(),Ask + Point * TrailingStop,OrderClosePrice() - TakeProfit * Point - TrailingStop * Point,0,Purple);
                  return(0);
               }
            }
         }
      }
      if( OrderType() == OP_BUY ) {
         if( TrailingStop > 0 ) {
            if( Bid - OrderOpenPrice() >= TrailingStop * Point + Pips * Point ) {
               if( OrderStopLoss() < Bid - Point * TrailingStop ) {
                  OrderModify(OrderTicket(),OrderOpenPrice(),Bid - Point * TrailingStop,OrderClosePrice() + TakeProfit * Point + TrailingStop * Point,0,Yellow);
                  return(0);
               }
            }
         }
      }
   }
}

Profit = 0;
LastTicket = 0;
LastType = 0;
LastClosePrice = 0;
LastLots = 0;

for( cnt = 0; cnt < OrdersTotal(); cnt++ ) {
   OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
   if( OrderSymbol() == Symbol() ) {
      LastTicket = OrderTicket();
      if( OrderType() ==  OP_BUY ) LastType = 0;
      if( OrderType() ==  OP_SELL ) LastType = 1;
      LastClosePrice = OrderClosePrice();
      LastLots = OrderLots();
      if( LastType == 0 ) {
         if( OrderClosePrice() < OrderOpenPrice() ) {
            Profit = Profit - (OrderOpenPrice() - OrderClosePrice()) * OrderLots() / Point;
         }
         if( OrderClosePrice() > OrderOpenPrice() ) {
            Profit = Profit + (OrderClosePrice() - OrderOpenPrice()) * OrderLots() / Point;
         }
      }
      if( LastType == 1 ) {
         if( OrderClosePrice() > OrderOpenPrice() ) {
            Profit = Profit - (OrderClosePrice() - OrderOpenPrice()) * OrderLots() / Point;
         }
         if( OrderClosePrice() < OrderOpenPrice() ) {
            Profit = Profit + (OrderOpenPrice() - OrderClosePrice()) * OrderLots() / Point;
         }
      }
   }
}

Profit = Profit * PipValue;
text2 = "Profit: $" + DoubleToStr(Profit,2) + " +/- ";
if( OpenOrders >= MaxTrades - OrderstoProtect && AccountProtection ==  1 ) {
   if( MyOrderType == 2 && Bid == tp ) {
      OrderClose(LastTicket,LastLots,LastClosePrice,slippage,Yellow);
      ContinueOpening = False;
      return(0);
   }
   if( MyOrderType == 1 && Ask == tp ) {
      OrderClose(LastTicket,LastLots,LastClosePrice,slippage,Yellow);
      ContinueOpening = False;
      return(0);
   }
}

if( MyOrderType == 1 && ContinueOpening ) {
   if( Bid - LastPrice >= Pips * Point || OpenOrders < 1 ) {
      SellPrice = Bid;
      LastPrice = 0;
      if( TakeProfit ==  0 ) tp = 0 ; else tp = SellPrice - TakeProfit * Point;
      if( StopLoss ==  0 ) sl = 0 ; else sl = SellPrice + StopLoss * Point;
      if( OpenOrders != 0 ) {
         mylotsi = lotsi;
         for(cnt =0;cnt <OpenOrders;cnt ++) {
            if( MaxTrades > 12 ) mylotsi = NormalizeDouble(mylotsi * 1.5,1) ; else mylotsi = NormalizeDouble(mylotsi * 2,1);
         }
      }
      else {
         mylotsi = lotsi;
      }
      if( mylotsi > 100 ) mylotsi = 100;
      OrderSend(Symbol(),OP_SELL,mylotsi,SellPrice,slippage,sl,tp,"",0,0,Red);
      return(0);
   }
}

if( MyOrderType == 2 && ContinueOpening ) {
   if( LastPrice - Ask >= Pips * Point || OpenOrders < 1 ) {
      BuyPrice = Ask;
      LastPrice = 0;
      if( TakeProfit ==  0 ) tp = 0 ; else tp = BuyPrice + TakeProfit * Point;
      if( StopLoss ==  0 ) sl = 0 ; else sl = BuyPrice - StopLoss * Point;
      if( OpenOrders != 0 ) {
         mylotsi = lotsi;
         for(cnt =0;cnt <OpenOrders;cnt ++) {
            if( MaxTrades > 12 ) mylotsi = NormalizeDouble(mylotsi * 1.5,1) ; else mylotsi = NormalizeDouble(mylotsi * 2,1);
         }
      }
      else {
         mylotsi = lotsi;
      }
      if( mylotsi > 100 ) mylotsi = 100;
      OrderSend(Symbol(),OP_BUY,mylotsi,BuyPrice,slippage,sl,tp,"",0,0,Blue);
      return(0);
   }
}

return(0);
}