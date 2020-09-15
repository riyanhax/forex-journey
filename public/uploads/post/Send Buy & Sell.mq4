//+------------------------------------------------------------------+
//|                                                send_buy&sell.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"
#property show_inputs

//---- Parametres Externes
extern double   BuyLots = 1.0;
extern int      BuyStopLoss = 0;
extern int      BuyTakeProfit = 0;
extern double   SellLots = 1.0;
extern int      SellStopLoss = 0; 
extern int      SellTakeProfit = 0;

//+------------------------------------------------------------------+
//| script "send pending order with expiration data"                 |
//+------------------------------------------------------------------+
int start()
  {
   int    ticket,expiration;
   double point;
//----
   point=MarketInfo(Symbol(),MODE_POINT);
   expiration=CurTime()+PERIOD_D1*60;
//----
   while(true)
     {
      ticket=OrderSend(Symbol(),OP_SELL,SellLots,Bid,0,Bid+SellStopLoss*Point,Bid-SellTakeProfit*Point,"SELL",NULL,0,Red);
      if(ticket<=0) Print("Error = ",GetLastError());
      else { Print("ticket = ",ticket); break; }
      //---- 10 seconds wait
      Sleep(10000);
     }
     while(true)
     {
      ticket=OrderSend(Symbol(),OP_BUY,BuyLots,Ask,0,Ask-BuyStopLoss*Point,Ask+BuyTakeProfit*Point,"BUY",NULL,0,Lime);
      if(ticket<=0) Print("Error = ",GetLastError());
      else { Print("ticket = ",ticket); break; }
      //---- 10 seconds wait
      Sleep(10000);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+