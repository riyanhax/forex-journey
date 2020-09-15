//|$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
//  Price Action V1
//  hodhabi@gmail.com
//|$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#define     NL    "\n" 
 
extern double Lots = 1;
extern double TP = 100;
extern int   TradeType      = 0;          // 0 to follow the trend, 1 to force buy, 2 to force sell
extern int leverage = 5;
extern double MaximumLossinMoney = 1000;
extern int   MagicNumber        = 250346;
extern bool UseAlerts = false;



 
//+-------------+
//| Custom init |
//|-------------+
int init()
  {
 
  }
 
//+----------------+
//| Custom DE-init |
//+----------------+
int deinit()
  {
 
  }
 
void sendEmail()
{
  if (UseAlerts==true) SendMail("YTF Alert", "New order has been added  "+OrdersTotal()+"   Balance = " +AccountBalance() + " Equity = "+AccountEquity() +" Current Price: " + Close[0]);
  return;
}
 
void DrawHorizentalLine()
{
ObjectCreate("TProfit", OBJ_HLINE, 0, Time[1], Close[0]+500*Point);            
            ObjectSet("Tprofit", OBJPROP_STYLE, STYLE_SOLID);
            ObjectSet("Tprofit", OBJPROP_COLOR, MediumSeaGreen); 
}
 
 
//+------------------------------------------------------------------------+
//| Closes everything
//+------------------------------------------------------------------------+
void CloseAll()
{
  for(int i=OrdersTotal()-1;i>=0;i--)
 {
    OrderSelect(i, SELECT_BY_POS);
    bool result = false;
        if ( OrderType() == OP_BUY && OrderMagicNumber()== MagicNumber)  result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
        if ( OrderType() == OP_SELL && OrderMagicNumber()==MagicNumber)  result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red );
        if (UseAlerts) PlaySound("alert.wav");
 }
  return; 
}
 
 
void CloseAllBuy()
{
  for(int i=OrdersTotal()-1;i>=0;i--)
 {
    OrderSelect(i, SELECT_BY_POS);
    bool result = false;
        if ( OrderType() == OP_BUY && OrderMagicNumber()==MagicNumber)  result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
        if (UseAlerts) PlaySound("alert.wav");
 }
  return; 
}
 
void CloseAllSell()
{
  for(int i=OrdersTotal()-1;i>=0;i--)
 {
    OrderSelect(i, SELECT_BY_POS);
    bool result = false;
        if ( OrderType() == OP_SELL && OrderMagicNumber()==MagicNumber)  result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red );
        if (UseAlerts) PlaySound("alert.wav");
 }
  return; 
}
   
//+------------------------------------------------------------------------+
//| cancels all orders that are in profit
//+------------------------------------------------------------------------+

 
 
 
 
 
 
 
//+------------------------------------------------------------------------+
//| cancels all pending orders 
//+------------------------------------------------------------------------+

 
//+-----------+
//| Main      |
//+-----------+
int start()
  {
   int      OrdersBUY, ticket;
   int      OrdersSELL;
   double   BuyLots, SellLots, BuyProfit, SellProfit;
 
//+------------------------------------------------------------------+
//  Determine last order price                                       |
//-------------------------------------------------------------------+
 
 
      if(OrdersTotal()==0 && TradeType ==1 )
        {
         ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Ask-TP*Point,Ask+leverage*TP*Point,"MLTrendETF",MagicNumber,0,Green);
         TradeType=2;
         
         if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) sendEmail();
           }
         else Print("Error opening BUY order : ",GetLastError()); 
         return(0); 
        }
 
      if(OrdersTotal()==0 && TradeType ==2)
        {
         ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+TP*Point,Bid-TP*leverage*Point,"MLTrendETF",MagicNumber,0,Green);
         TradeType = 1;
         if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) sendEmail();
           }
         else Print("Error opening BUY order : ",GetLastError()); 
         return(0); 
        }
 
 
 
  } // start()