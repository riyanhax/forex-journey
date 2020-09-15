//+------------------------------------------------------------------+
//|                                                       promax.mq4 |
//|                                                Copyright © 2009  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Roslan Rahmat"
#property link      "xroslan@gmail.com"
extern double Lots=0.01;
extern int Risk.Percent=10; 
extern double Pip.Order=5;
extern double Stop.Loss=5;
extern double Trailing=3;
extern int Spread.Limit=5;
extern int Magic.No=111;

int i=0;
int  Slippage=0;

int Stop.Level;
double Margin;
double Spread;
double Lots.Step;
double Min.Lots;
double Max.Lots;
double Lots.Digit;
string EA.Name="Promax_";
string EA.Version="1a";

int init() {
   Lots.Step = NormalizeDouble(MarketInfo(Symbol(), MODE_LOTSTEP),2);
   Min.Lots = NormalizeDouble(MarketInfo(Symbol(), MODE_MINLOT),2);
   Max.Lots = NormalizeDouble(MarketInfo(Symbol(), MODE_MAXLOT),2);
   Margin = NormalizeDouble(MarketInfo(Symbol(), MODE_MARGINREQUIRED),4);
   Stop.Level = MarketInfo(Symbol(), MODE_STOPLEVEL);
   if (Lots.Step==0.01) Lots.Digit=2;
   else if (Lots.Step==0.10) Lots.Digit=1;
   else Lots.Digit=0;
   if (Digits==5||Digits==3) {
      Pip.Order*=10; Stop.Loss*=10; Trailing*=10; Spread.Limit*=10;
   }
   if (Stop.Loss<Stop.Level) Stop.Loss=Stop.Level;   
   return(0);
}
int start()  {

   double Buy.TP=0, Buy.SL=0, Sell.TP=0, Sell.SL=0, Price.Buy=0, Price.Sell=0;
   int No.Buy=0, No.Sell=0, No.BuyStop=0, No.SellStop=0, No.Orders=0;
   bool To.Trade=true;

   Spread=MarketInfo(Symbol(),MODE_SPREAD);
   if (Spread>Spread.Limit) To.Trade=false;
      
   for(i=0;i<OrdersTotal();i++) {
     OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
     if (OrderSymbol()==Symbol()&&OrderMagicNumber()==Magic.No) {
         No.Orders++;
         if(OrderType()==OP_BUY) {
            No.Buy++;
            if (Bid-OrderOpenPrice()>Point*Trailing&&Trailing>0) {
               if (OrderStopLoss()+Point<Bid-Point*Trailing)
                  OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*Trailing,OrderTakeProfit(),0,Yellow);
            }            
            if (OrderStopLoss()>=OrderOpenPrice()) { Delete.Pending(OP_SELLSTOP); }
         }
         if(OrderType()==OP_SELL) {
            No.Sell++;
            if (OrderOpenPrice()-Ask>Point*Trailing&&Trailing>0) {
               if (OrderStopLoss()-Point>Ask+Point*Trailing||OrderStopLoss()==0.0)
                  OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*Trailing,OrderTakeProfit(),0,Yellow);
            }
            if (OrderStopLoss()<=OrderOpenPrice()) { Delete.Pending(OP_BUYSTOP); }
         }
         if (OrderType()==OP_BUYSTOP) { No.BuyStop++; }
         if (OrderType()==OP_SELLSTOP) { No.SellStop++; }          
     }
   }
   if (No.Orders<1&&To.Trade) {
      Price.Buy=Ask+(Pip.Order*Point); 
      Price.Sell=Bid-(Pip.Order*Point);   
      if (Stop.Loss>0) Buy.SL=Price.Buy-Stop.Loss*Point; else Buy.SL=0;
      if (Stop.Loss>0) Sell.SL=Price.Sell+Stop.Loss*Point; else Sell.SL=0;      
      OrderSend(Symbol(),OP_BUYSTOP,Do.Lots(),Price.Buy,Slippage,Buy.SL,0,EA.Name+EA.Version,Magic.No,0,Blue); 
      OrderSend(Symbol(),OP_SELLSTOP,Do.Lots(),Price.Sell,Slippage,Sell.SL,0,EA.Name+EA.Version,Magic.No,0,Red); 
   } 
   return(0);
} 
double Do.Lots() {
   double lots; 
   if (Lots>0) lots=Lots;
   else lots=NormalizeDouble(AccountFreeMargin()/100000*Risk.Percent,Lots.Digit);
   if (lots<Min.Lots) lots=Min.Lots;  
   if (lots>Max.Lots) lots=Max.Lots;     
   return(lots);      
}
void Delete.Pending(int oper) {
   for(int i=0;i<OrdersTotal();i++) {
       OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
       if (OrderSymbol()==Symbol()&&OrderType()==oper) {
            OrderDelete(OrderTicket());
       }
   }     
}

