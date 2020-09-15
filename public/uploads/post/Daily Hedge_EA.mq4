//+------------------------------------------------------------------+
//|                                                       Raja_Hedge.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"


extern bool STRATEGY_1_ON=TRUE;
extern int MagicNumber1=407830;
extern int MagicNumber2=407831;
extern double LotSize1=0.3;
extern double SO_Distance=3;
extern double SL1=12;
extern double TP1=25;


extern bool STRATEGY_2_ON=TRUE;
extern int MagicNumber3=407832;
extern int MagicNumber4=407833;
extern double LotSize2=0.3;
extern double SL2=10;
extern double TP2=20;

extern bool STRATEGY_3_ON=TRUE;
extern int MagicNumber5=407834;
extern int MagicNumber6=407835;
extern double LotSize3=0.3;
extern double SL3=10;
extern double TP3=20;




extern string comment="Raja_Hedge_EA";

extern int slip=3;



//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
   
   slip=slip*PointValue();
   
   
   SO_Distance*=PointValue();
   SL1*=PointValue();
   TP1*=PointValue();
   
   SL2*=PointValue();
   TP2*=PointValue();
   
   SL3*=PointValue();
   TP3*=PointValue();

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
  int ticket;

//----------------------------Strategy One-----------------------------------------///
if(STRATEGY_1_ON&& TimeHour(TimeCurrent())==0 &&(TimeMinute(TimeCurrent())>=0 && TimeMinute(TimeCurrent())<5) && TotalOrder(11)==0 && TotalOrder(12)==0){
   while(TotalOrder(11)<1){ticket=OrderSend(Symbol(),OP_BUYSTOP,LotSize1,Open[0]+SO_Distance,slip,0,0,comment,MagicNumber1,0,Green);}
   while(TotalOrder(12)<1){ticket=OrderSend(Symbol(),OP_SELLSTOP,LotSize1,Open[0]-SO_Distance,slip,0,0,comment,MagicNumber2,0,Red);}
   
}
//----------------------------Strategy Second-----------------------------------------/// 
 if(STRATEGY_2_ON && TimeHour(TimeCurrent())==0 &&(TimeMinute(TimeCurrent())>=0 && TimeMinute(TimeCurrent())<5) && TotalOrder(21)==0 && TotalOrder(22)==0){
   while(TotalOrder(21)<1){ticket=OrderSend(Symbol(),OP_BUY,LotSize2,Ask,slip,0,0,comment,MagicNumber3,0,Green);}
   while(TotalOrder(22)<1){ticket=OrderSend(Symbol(),OP_SELL,LotSize2,Bid,slip,0,0,comment,MagicNumber4,0,Red);}
}

//----------------------------Strategy Third-----------------------------------------/// 
 if(STRATEGY_3_ON && TimeHour(TimeCurrent())==0 &&(TimeMinute(TimeCurrent())>=0 && TimeMinute(TimeCurrent())<5) && TotalOrder(31)==0 && TotalOrder(32)==0 && TotalOrder(33)==0 && TotalOrder(34)==0){
   while(TotalOrder(31)<1 && High[1]>Ask){ticket=OrderSend(Symbol(),OP_BUYSTOP,LotSize3,High[1],slip,0,0,comment,MagicNumber5,0,Green);}
   while(TotalOrder(32)<1 && High[1]>Ask){ticket=OrderSend(Symbol(),OP_SELLLIMIT,LotSize3,High[1],slip,0,0,comment,MagicNumber6,0,Red);}
   while(TotalOrder(33)<1 && Low[1]<Bid){ticket=OrderSend(Symbol(),OP_BUYLIMIT,LotSize3,Low[1],slip,0,0,comment,MagicNumber5,0,Green);}
   while(TotalOrder(34)<1 && Low[1]<Bid){ticket=OrderSend(Symbol(),OP_SELLSTOP,LotSize3,Low[1],slip,0,0,comment,MagicNumber6,0,Red);}
}
 
modifysltp();
if(TimeHour(TimeCurrent())==23)CloseOrders();
//----
   return(0);
  }
//+------------------------------------------------------------------+


//+-------------------ModifySLTP--------------------------------+
void modifysltp(){
for (int l_pos_0 = 0; l_pos_0 <= OrdersTotal(); l_pos_0++) {
      OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()  &&  OrderStopLoss()==0){
      if(OrderType()==OP_BUYSTOP && OrderMagicNumber()==MagicNumber1 )OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-SL1,OrderOpenPrice()+TP1,0,Green);
      if(OrderType()==OP_SELLSTOP && OrderMagicNumber()==MagicNumber2 )OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+SL1,OrderOpenPrice()-TP1,0,Red);
     
      if(OrderType()==OP_BUY && OrderMagicNumber()==MagicNumber3 )OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-SL2,OrderOpenPrice()+TP2,0,Green);
      if(OrderType()==OP_SELL && OrderMagicNumber()==MagicNumber4 )OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+SL2,OrderOpenPrice()-TP1,0,Red);
    
      
      //if(OrderMagicNumber()==MagicNumber3){
      if(OrderType()==OP_BUYSTOP || OrderType()==OP_BUYLIMIT && OrderMagicNumber()==MagicNumber5 )OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-SL3,OrderOpenPrice()+TP3,0,Green);
      if(OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT && OrderMagicNumber()==MagicNumber6)OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+SL3,OrderOpenPrice()-TP3,0,Red);
     // }
      
      }
      }
}
//+-------------------CloseOrders-------------------------------+
void CloseOrders(){
for (int l_pos_0 = 0; l_pos_0 <= OrdersTotal(); l_pos_0++) {
      OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()  && (OrderMagicNumber()==MagicNumber1 || OrderMagicNumber()==MagicNumber2 || OrderMagicNumber()==MagicNumber3
      || OrderMagicNumber()==MagicNumber4 || OrderMagicNumber()==MagicNumber5 || OrderMagicNumber()==MagicNumber6)){
      if(OrderType()>1)OrderDelete(OrderTicket());
      }
      }
      return(0);
      } 
//+-------------------Total Orders--------------------------------+
int TotalOrder(int mode){
int sum=0;
for (int l_pos_0 = 0; l_pos_0 <= OrdersTotal(); l_pos_0++) {
      OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
      
      
      if (OrderSymbol() == Symbol() && OrderMagicNumber()==MagicNumber1 && OrderType()==OP_BUYSTOP && mode==11)sum++;
      if (OrderSymbol() == Symbol() && OrderMagicNumber()==MagicNumber2 && OrderType()==OP_SELLSTOP && mode==12)sum++;
      
      if (OrderSymbol() == Symbol() && OrderMagicNumber()==MagicNumber3 && OrderType()==OP_BUY && (TimeCurrent()-OrderOpenTime())<3600 && mode==21)sum++;
      if (OrderSymbol() == Symbol() && OrderMagicNumber()==MagicNumber4 && OrderType()==OP_SELL && (TimeCurrent()-OrderOpenTime())<3600 && mode==22)sum++;
      
      
      if (OrderSymbol() == Symbol() && OrderMagicNumber()==MagicNumber5 && OrderType()==OP_BUYSTOP && mode==31)sum++;
      if (OrderSymbol() == Symbol() && OrderMagicNumber()==MagicNumber6 && OrderType()==OP_SELLLIMIT && mode==32)sum++;
      if (OrderSymbol() == Symbol() && OrderMagicNumber()==MagicNumber5 && OrderType()==OP_BUYLIMIT && mode==33)sum++;
      if (OrderSymbol() == Symbol() && OrderMagicNumber()==MagicNumber6 && OrderType()==OP_SELLSTOP && mode==34)sum++;
       }
      return(sum);
}

//+-------------------PointValue--------------------------------+
double PointValue() {
   if (MarketInfo(Symbol(), MODE_DIGITS) == 5.0 || MarketInfo(Symbol(), MODE_DIGITS) == 3.0) return (10.0 * Point);
   return (Point);
}