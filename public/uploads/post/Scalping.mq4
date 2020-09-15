//|                                                  Scalping EA.mq4 |
//|                       Copyright ?2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Interbank FX, LLC" //( original template)
 
#property copyright "PicassoInActions , 123@donothing.us" //( original idea)
 
 
#include <stderror.mqh> 
//+------------------------------------------------------------------+
//| Global Variables / Includes                                      |
//+------------------------------------------------------------------+
datetime   CurrTime = 0;
datetime   PrevTime = 0;
     int  TimeFrame = 0;
     int      Shift = 1;
     
     int  SymDigits;
  double  SymPoints;
     int  POS_n_BUY;
     int  POS_n_SELL;
     int  POS_n_BUYSTOP;
     int  POS_n_SELLSTOP;
     int  POS_n_total;
  double  OrderLevelB;
  double  OrderLevelS;
 
//+------------------------------------------------------------------+
//| Expert User Inputs                                               |
//+------------------------------------------------------------------+
extern double               Lots = 0.01;
extern double            MinLots = 0.01;
extern    int              magic = 1111;
extern    int         TakeProfit = 30; 
extern    int           StopLoss = 50; 
extern    int          MaxBuyPos = 1;//maximum Buy positions at once
extern    int         MaxSellPos = 1;//maximum Sell positions at once
extern    int           Distance = 100;
extern    int               Near = 15;
extern    int                Far = 100;

 
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
{
 return(0);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() 
{ 
 return(0); 
}
 
//+------------------------------------------------------------------+
//| Expert start function                                            |
//+------------------------------------------------------------------+
int start() 
{    
 int cnt, total;
 int ticketB, ticketS, ticketC,ticketM;//ticket number of Buy,Sell,Close,Modify
 int MaxOpenPos = MaxBuyPos + MaxSellPos;

//----Count Positions 
 count_position(); 
 RefreshRates();
 
//----Open Pending Orders 
 if(POS_n_BUYSTOP + POS_n_BUY < MaxBuyPos && POS_n_SELL == 0) 
 {
  ticketB=OrderSend(Symbol(),OP_BUYSTOP,Lots,Ask+Distance*Point,1,0,0,"Scalping EA",magic,0,Green);
  if(ticketB>0)
  {
   if(OrderSelect(ticketB,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY Stop order sent : ",OrderOpenPrice());
  }
  else 
  {
   Print("Error sending BUY Stop order : ",GetLastError()); 
   return(0); 
  }
  return(0);   
 }
 
 if(POS_n_SELLSTOP + POS_n_SELL < MaxSellPos && POS_n_BUY == 0) 
 {
  ticketS=OrderSend(Symbol(),OP_SELLSTOP,Lots,Bid-Distance*Point,1,0,0,"Scalping EA",magic,0,Red);
  if(ticketS>0)
  {
   if(OrderSelect(ticketS,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL Stop order sent : ",OrderOpenPrice());
  }
  else 
  {
   Print("Error sending SELL Stop order : ",GetLastError()); 
   return(0); 
  }
  return(0);  
 }
 
//---- delete the useless positions && achieve the hidden TakeProfit and StopLoss
  total=OrdersTotal();
  for(cnt=total-1;cnt>=0;cnt--)
  {
   OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
   if(OrderMagicNumber() != magic) continue;
//----   
   if(OrderType()==OP_BUYSTOP && POS_n_SELL != 0  && OrderSymbol() == Symbol())  OrderDelete(OrderTicket());
   if(OrderType()==OP_SELLSTOP && POS_n_BUY != 0 && OrderSymbol() == Symbol())  OrderDelete(OrderTicket());
//----
   RefreshRates();
   if(OrderType()==OP_BUY  && OrderSymbol() == Symbol())
   {
    if(Ask >= OrderOpenPrice() + TakeProfit*Point || Bid <= OrderOpenPrice() - StopLoss*Point)
    ticketC = OrderClose(OrderTicket(),OrderLots(),Bid,3,Violet);
//    if(Bid <= OrderOpenPrice() - StopLoss*Point) {Lots=2*Lots;ticketC = OrderClose(OrderTicket(),OrderLots(),Bid,3,Violet);}
//    if(Ask >= OrderOpenPrice() + TakeProfit*Point) {Lots=MinLots;ticketC = OrderClose(OrderTicket(),OrderLots(),Bid,3,Violet);}
    if(ticketC <= 0) {Print("Error closing order : ",GetLastError()); }
   }  
   
//----   
   RefreshRates();
   if(OrderType()==OP_SELL && OrderSymbol() == Symbol())
   {
    if(Bid <= OrderOpenPrice() - TakeProfit*Point || Ask >= OrderOpenPrice() + StopLoss*Point)
    ticketC = OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet);
//    if(Ask >= OrderOpenPrice() + StopLoss*Point) {Lots=2*Lots;ticketC = OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet);}
//    if(Bid <= OrderOpenPrice() - TakeProfit*Point) {Lots=MinLots;ticketC = OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet);}
    if(ticketC <= 0) {Print("Error closing order : ",GetLastError()); }
   }  
  }

//----Update Pending Orders in accordance with Price Movements
  RefreshRates();
  total=OrdersTotal();
  for(cnt=total-1;cnt>=0;cnt--)
  {
   OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
   if(OrderMagicNumber() != magic) continue;
//----   
   if(OrderType()==OP_BUYSTOP  && OrderSymbol() == Symbol())
   {
    if((OrderOpenPrice()-Ask)<=Point*Near || (OrderOpenPrice()-Ask)>=Point*Far )
    {
     ticketM=OrderModify(OrderTicket(),Ask+Distance*Point,0,0,0,CLR_NONE );
     if(ticketM <= 0) {Print("Error modify order : ",GetLastError()); }
    }
   }


//----
   if(OrderType()==OP_SELLSTOP && OrderSymbol() == Symbol())   
   {
    if((Bid-OrderOpenPrice())<=Point*Near || (Bid-OrderOpenPrice())>=Point*Far )
    {
     ticketM=OrderModify(OrderTicket(),Bid-Distance*Point,0,0,0,CLR_NONE );
     if(ticketM <= 0) {Print("Error modify order : ",GetLastError()); }
    }
   }
  }
}


//+------------------------------------------------------------------+
//| Seperate Functions                                               |
//+------------------------------------------------------------------+
void count_position()
{
    POS_n_BUY  = 0;
    POS_n_SELL = 0;
    
    POS_n_BUYSTOP = 0;
    POS_n_SELLSTOP = 0;
    
    for( int i = 0 ; i < OrdersTotal() ; i++ )
    {
     if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) == false || OrderMagicNumber() != magic) continue;
//     if( OrderSymbol() != Symbol() )   continue; 

     if( OrderType() == OP_BUY  && OrderSymbol() == Symbol() && OrderMagicNumber()==magic) POS_n_BUY++;
     
     else
     if( OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber()==magic) POS_n_SELL++;
     
     else   
     if( OrderType() == OP_BUYSTOP  && OrderSymbol() == Symbol() && OrderMagicNumber()==magic)
     {
      POS_n_BUYSTOP++;
      OrderLevelB = OrderOpenPrice();
     }
     
     else
     if( OrderType() == OP_SELLSTOP  && OrderSymbol() == Symbol() && OrderMagicNumber()==magic)
     {
      POS_n_SELLSTOP++;
      OrderLevelS = OrderOpenPrice();
     }        
    }
        
    POS_n_total = POS_n_BUY + POS_n_SELL + POS_n_BUYSTOP + POS_n_SELLSTOP;
}