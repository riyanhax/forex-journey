//+------------------------------------------------------------------+
//|                                                       10pips.mq4 |
//|                                                        fortrader |
//|                                                 www.fortrader.ru |
//+------------------------------------------------------------------+
#property copyright "fortrader"
#property link      "www.fortrader.ru"

extern string EAComment = "10pips";
extern int       TakeProfit_Buy = 10;
extern int       StopLoss_Buy = 50;
extern int       TrailingStop_Buy = 50;
extern int       TakeProfit_Sell = 10;
extern int       StopLoss_Sell = 50;
extern int       TrailingStop_Sell = 50;
extern double     Lots = 0.1;

double point;
int digits;

int init()
  {
    if(Digits<4)
      {
         point=0.01;
         digits=2;
      }
      else
      {
         point=0.0001;
         digits=4;
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
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
  if (Volume[0] > 1) return(0);

   int tradeTicket = 0;
   
int total, cnt;

  total=OrdersTotal();


  if(AccountFreeMargin()<(1000*Lots))
     {
       Print("We have no money. Free Margin = ", AccountFreeMargin());   
       return(0);  
     }
  if(total<1)
    {  
       tradeTicket = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,0,EAComment,16384,0,Green);
       if (tradeTicket>0) 
         OrderModify(tradeTicket, OrderOpenPrice(), Bid-StopLoss_Buy*point,Ask+TakeProfit_Buy*point, 0, Green);
       
       Sleep(10000);
       RefreshRates();
       tradeTicket = OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,0,EAComment,16385,0,Red);
       if (tradeTicket>0) 
         OrderModify(tradeTicket, OrderOpenPrice(), Ask+StopLoss_Sell*point,Bid-TakeProfit_Sell*point, 0, Red);
       
    }
  if(total==1)
    {
       OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
       if(OrderType()==OP_BUY)
         {
           tradeTicket = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,0,EAComment,16384,0,Green);
            if (tradeTicket>0) 
               OrderModify(tradeTicket, OrderOpenPrice(), Bid-StopLoss_Buy*point, Ask+TakeProfit_Buy*point, 0, Green);
         }
       if(OrderType()==OP_SELL)
         {
           tradeTicket = OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,0,EAComment,16385,0,Red);
            if (tradeTicket>0) 
               OrderModify(tradeTicket, OrderOpenPrice(), Ask+StopLoss_Sell*point,Bid-TakeProfit_Sell*point, 0, Red);
         }
    }   
  for(cnt=total-1;cnt>=0;cnt--)
     {
       OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
       if(OrderType()==OP_BUY)
         {
           if(TrailingStop_Buy>0)  
             {                 
               if(Bid-OrderOpenPrice()>point*TrailingStop_Buy)
                 {
                   if(OrderStopLoss()<Bid-point*TrailingStop_Buy)
                     {
                       OrderModify(OrderTicket(),OrderOpenPrice(),Bid-point*TrailingStop_Buy,OrderTakeProfit(),0,Green);
                       return(0);
                     }
                 }
             }
         }
       if(OrderType()==OP_SELL)
         {
           if(TrailingStop_Sell>0)  
             {                 
               if((OrderOpenPrice()-Ask)>(point*TrailingStop_Sell))  // Ask - цена продажи
                 {
                   if((OrderStopLoss()>(Ask+point*TrailingStop_Sell)) || (OrderStopLoss()==0))
                     {
                       OrderModify(OrderTicket(),OrderOpenPrice(),Ask+point*TrailingStop_Sell,OrderTakeProfit(),0,Red);
                       return(0);
                     }
                 }
             }
         }
  
     }
   
//----
   return(0);
  }
//+------------------------------------------------------------------+