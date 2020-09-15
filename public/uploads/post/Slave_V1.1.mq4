//+------------------------------------------------------------------+
//|                                                        Slave.mq4 |
//+------------------------------------------------------------------+

extern double Trigger = 1.0;
extern double CommissionPips = 0.7;
extern double LotSize = 0.01;
extern int MagicNumber = 1234;
extern double StopLoss = 10.0;
extern double TakeProfit = 10.0;

string FileName;
string SymbolName;

double BidV;
double AskV;
double MidV;
double RemV;
double SpreadV;
double PointV;
double DiffV;

int TicketsLong;
int TicketsShort;

bool TP;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   SymbolName = Symbol();
   if(LotSize<MarketInfo(SymbolName,MODE_MINLOT)){
   LotSize = MarketInfo(SymbolName,MODE_MINLOT);
   Print("Minimum lotsize requires to trade a minimum of "+DoubleToStr(LotSize,2) +" lots. Your lotsize is adjusted.");
   }
   if(LotSize>MarketInfo(SymbolName,MODE_MAXLOT) && MarketInfo(SymbolName,MODE_MAXLOT)>0.00){
   LotSize = MarketInfo(SymbolName,MODE_MAXLOT);
   Print("Maximum lotsize requires to trade a maximum of "+DoubleToStr(LotSize,2) +" lots. Your lotsize is adjusted.");
   }
   if(StopLoss<MarketInfo(SymbolName,MODE_STOPLEVEL) && StopLoss>0.0){
   StopLoss = MarketInfo(SymbolName,MODE_STOPLEVEL);
   Print("StopsLevel of this broker requires a minimum distance of "+DoubleToStr(StopLoss,1) +" pips between your takeprofit and the market. Your stoploss is adjusted.");   
   }
   if(TakeProfit<MarketInfo(SymbolName,MODE_STOPLEVEL)&& TakeProfit>0.0){
   TakeProfit = MarketInfo(SymbolName,MODE_STOPLEVEL);
   Print("StopsLevel of this broker requires a minimum distance of "+DoubleToStr(StopLoss,1) +" pips between your stoploss and the market. Your takeprofit is adjusted.");   
   }
   FileName = StringConcatenate(StringSubstr(SymbolName,0,6),".CSV");
   PointV = 0.0001;
   if(StringSubstr(SymbolName,3,3)=="JPY"){PointV = 0.01;}
   PC();   
//----
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
   RefreshRates();
   BidV = Bid;
   AskV = Ask;
   MidV = (BidV+(AskV-BidV)/2);
   RemV = NewR();
   DiffV = (RemV - MidV)/PointV;
   if(MathAbs(DiffV)>10){DiffV = 0;}
   SpreadV = 0.0;
   if(AskV>BidV){SpreadV = (AskV-BidV)/PointV;}
   if(TicketsShort<1 & TicketsLong<1){
      if(DiffV>=(Trigger+SpreadV+CommissionPips)){
         OrderSend(SymbolName,OP_BUY,LotSize,AskV,0,0,0,DoubleToStr(AskV,Digits),MagicNumber,0,Blue);
      }
      if(DiffV<=-(Trigger+SpreadV+CommissionPips)){
         OrderSend(SymbolName,OP_SELL,LotSize,BidV,0,0,0,DoubleToStr(BidV,Digits),MagicNumber,0,Red);
      }   
      }
      
   PC();
   
   Comment(
      "\n TestKees Arbitrage EA ",
      "\n Bid = ",DoubleToStr(BidV,Digits),
      "\n Ask = ",DoubleToStr(AskV,Digits),
      "\n Mid = ",DoubleToStr(MidV,Digits),
      "\n Spread= ",DoubleToStr(SpreadV,1),
      "\n Remote Mid = ",DoubleToStr(RemV,Digits),
      "\n PriceDifference = ",DoubleToStr(DiffV,1),
      "\n StopLoss = ",DoubleToStr(StopLoss,1),
      "\n TakeProfit = ",DoubleToStr(TakeProfit,1),
      "\n Trigger = ",DoubleToStr(Trigger,1),
      "\n CommissionPips = ",DoubleToStr(CommissionPips,1)
   );
//----
   return(0);
  }
//+------------------------------------------------------------------+

void PC(){
TicketsLong = 0;
TicketsShort = 0;

if (OrdersTotal() >0 ){   
   for(int OC = OrdersTotal() - 1; OC >= 0; OC--){
      if(OrderSelect(OC, SELECT_BY_POS, MODE_TRADES)==1 ){
         if(OrderSymbol()==SymbolName && OrderMagicNumber()==MagicNumber){
            switch(OrderType()){
               case OP_BUY:
                  TicketsLong++;
                  if(OrderStopLoss()==0 && StopLoss !=0 && TakeProfit==0){
                     OrderModify(OrderTicket(),OrderOpenPrice(),BidV-(StopLoss*PointV),OrderTakeProfit(),OrderExpiration(),CLR_NONE);}
                  if(OrderTakeProfit()==0 && StopLoss ==0 && TakeProfit !=0){
                     OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),BidV+(TakeProfit*PointV),OrderExpiration(),CLR_NONE);}
                  if(OrderStopLoss()==0 && OrderTakeProfit()==0 && StopLoss !=0 && TakeProfit !=0){
                     OrderModify(OrderTicket(),OrderOpenPrice(),BidV-(StopLoss*PointV),BidV+(TakeProfit*PointV),OrderExpiration(),CLR_NONE);}
                  break;
               case OP_SELL:
                  TicketsShort++;
                  if(OrderStopLoss()==0 && StopLoss !=0 && TakeProfit==0){
                     OrderModify(OrderTicket(),OrderOpenPrice(),AskV+(StopLoss*PointV),OrderTakeProfit(),OrderExpiration(),CLR_NONE);}
                  if(OrderTakeProfit()==0 && StopLoss ==0 && TakeProfit !=0){
                     OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),AskV-(TakeProfit*PointV),OrderExpiration(),CLR_NONE);}
                  if(OrderStopLoss()==0 && OrderTakeProfit()==0 && StopLoss !=0 && TakeProfit !=0){
                     OrderModify(OrderTicket(),OrderOpenPrice(),AskV+(StopLoss*PointV),BidV-(TakeProfit*PointV),OrderExpiration(),CLR_NONE);}
                  break;
               }
            }
         }
      }
   }
}

double  NewR(){

   double NewValue = 0.00;
   int handle;
   handle=FileOpen(FileName,FILE_CSV|FILE_READ,',');
   if(handle>0) { 
      FileSeek(handle,0,SEEK_SET);
      NewValue = StrToDouble(FileReadString(handle,DOUBLE_VALUE));
      FileClose(handle);
   }
   return(NewValue);
} 