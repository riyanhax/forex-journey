//+------------------------------------------------------------------+
//|                EA Name:  Mod MACD.mq4                            |
//|               Coded by:  Christina Li @ Wise-EA                  |
//|                    web:  http//www.wix.com/wiseea/wise-ea#!      |
//|                  email:  Contactchristinali@gmail.com            |
//|                Version:  06.14                                   |
//|                 Update:  06/14/2011                              |
//+------------------------------------------------------------------+

#property copyright "Copyright Jim & Lee Brown"
//----
extern string INDI = " --- Indicator Settings --- ";
extern int    Fast_EMA_Period    = 6;
extern int    Slow_EMA_Period    = 12; 
extern int    Signal_Period      = 1;
extern double MA_Period          = 25;
extern string TypeHelp           ="SMA = 0, EMA = 1, SMMA = 2, LWMA = 3";
extern int    MA_Type            = 0;

extern string MM = " --- Money Management Settings --- "; 
extern string DayOpenTime        = "00:00:00";
extern string DayCloseTime       = "23:59:59";
extern string CloseTime_5        = "10:59:59";
extern double OpenLot            = 0.1;
extern int    MagicNumber        = 1234; 
extern double Slippage           = 2; 
extern double StopLoss           = 50; 
extern double TakeProfit         = 100; 
extern bool   UseBE              = false;
extern double BEPoint            = 50;
extern bool   UseTrailingStop    = false;
extern bool   Trail_TickMode     = false;
extern double TrailingStop       = 50;

extern string OTH = " --- Other Settings --- ";
extern string EAName             = "Mod MACD";
extern bool   ScreenDisplay      = true;

int    dig, OB, OS;
double pnt, spread, curma, prevma, curmacd, prevmacd;
string EAComment;
datetime dayopentime, dayclosetime; 

//+------------------------------------------------------------------+
//| INITIALIZATION                                                   |
//+------------------------------------------------------------------+
int init() {
//----      
   pnt=MarketInfo(Symbol(),MODE_POINT);
   dig=MarketInfo(Symbol(),MODE_DIGITS);
   if (dig==3 || dig==5) {
      pnt*=10;
   }  
//----
   EAComment=EAName+", "+Symbol()+Period();
   OB=1;
   OS=1;
//----
   return(0);
  }

//+------------------------------------------------------------------+
//| DEINITIALIZATION                                                 |
//+------------------------------------------------------------------+
int deinit() {
//----
   Comment("");
//----
   return(0);
}

//+------------------------------------------------------------------+
//| MAIN LOOP                                                        |
//+------------------------------------------------------------------+
int start() {
//----
   spread=(Ask-Bid)/pnt;
   curma=iMA(NULL,0,MA_Period,0,MA_Type,PRICE_CLOSE,1);
   prevma=iMA(NULL,0,MA_Period,0,MA_Type,PRICE_CLOSE,2);
   curmacd=iMACD(NULL,0,Fast_EMA_Period,Slow_EMA_Period,Signal_Period,PRICE_CLOSE,MODE_SIGNAL,1);
   prevmacd=iMACD(NULL,0,Fast_EMA_Period,Slow_EMA_Period,Signal_Period,PRICE_CLOSE,MODE_SIGNAL,2);
   
   dayopentime=StrToTime(TimeToStr(TimeCurrent(),TIME_DATE)+" "+DayOpenTime);
   if (DayOfWeek()==5) 
      dayclosetime=StrToTime(TimeToStr(TimeCurrent(),TIME_DATE)+" "+CloseTime_5);
   else if ((DayOfWeek()==4) || (DayOfWeek()==3) || (DayOfWeek()==2) || (DayOfWeek()==1)) 
      dayclosetime=StrToTime(TimeToStr(TimeCurrent(),TIME_DATE)+" "+DayCloseTime);
         
   int count=0;
   for (int i=0; i<OrdersTotal(); i++) {
      if (!OrderSelect(i,SELECT_BY_POS)) continue;
      if (OrderSymbol()!=Symbol()) continue;
      if (OrderMagicNumber()!=MagicNumber) continue;
         
      count++;
      if (UseBE) check_breakeven(); 
      if (UseTrailingStop) check_trailingstop();
      check_close();
   }   
   
   if (count==0) check_open();
   if (ScreenDisplay) checkcomment(); 
//----
   return(0);
}   

//******************************************************************************************************
//******************************************************************************************************

//+------------------------------------------------------------------+
//| FUNCTIONS: Open and Close Condition                              |
//+------------------------------------------------------------------+
void check_open() {
//----
   if ((Close[1]>curma && curmacd>0) && (Close[2]<=prevma || prevmacd<=0)) {
      bool cond_buy=true;
      OS=1;
   }
   else if ((Close[1]<=curma && curmacd<=0) && (Close[2]>prevma || prevmacd>0)) {
      bool cond_sell=true;
      OB=1;
   }

   if (cond_buy && OB==1 && tradetime()) opentrade(OP_BUY);
   else if (cond_sell && OS==1 && tradetime()) opentrade(OP_SELL); 
}

void check_close() {
//----
   if (Close[1]>curma && curmacd>0) bool cond_closesell=true;
   else if (Close[1]<=curma && curmacd<=0) bool cond_closebuy=true;

   if ((cond_closesell && OrderType()==OP_SELL) || (cond_closebuy && OrderType()==OP_BUY)) closetrade();
} 

bool tradetime() {
//----
   if ((TimeCurrent()>=dayopentime) && (TimeCurrent()<dayclosetime)) return (true);    
   else return (false);
}   

//+------------------------------------------------------------------+
//| FUNCTIONS: Order Excution                                        |
//+------------------------------------------------------------------+
void opentrade(int ordertype) {
//---- 
   string typestring;
   double price,stoploss,takeprofit;

   if (ordertype==OP_BUY) {
      price=Ask;
      typestring=" BUY";
   }
   else if (ordertype==OP_SELL) {
      price=Bid;
      typestring=" SELL";
   }
   
   int ticket=OrderSend(Symbol(),ordertype,OpenLot,price,Slippage,0,0,EAComment,MagicNumber,0,Lime);
   if(ticket>0) {
      if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
         Alert(TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS)+" | "+EAComment+" | "+typestring+" order opened : "+" @"+DoubleToStr(OrderOpenPrice(),dig));
         Print(TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS)+" | "+EAComment+" | "+typestring+" order opened : "+" @"+DoubleToStr(OrderOpenPrice(),dig));
         
         if (ordertype==OP_BUY) {
            OB=0;
            if (StopLoss!=0) stoploss=OrderOpenPrice()-StopLoss*pnt;
            else stoploss=0;
            if (TakeProfit!=0) takeprofit=OrderOpenPrice()+TakeProfit*pnt;
            else takeprofit=0;
         }
         else if (ordertype==OP_SELL) {
            OS=0;
            if (StopLoss!=0) stoploss=OrderOpenPrice()+StopLoss*pnt;
            else stoploss=0;
            if (TakeProfit!=0) takeprofit=OrderOpenPrice()-TakeProfit*pnt;
            else takeprofit=0;
         }
         if ((takeprofit!=0) || (stoploss!=0))      
            OrderModify(ticket,OrderOpenPrice(),stoploss,takeprofit,0,CLR_NONE);
      } 
   }
   else {
      Print(TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS)+" | "+EAComment+" | "+" Error opening order : ",GetLastError()); 
   }
} 

void closetrade() {
//---- 
   double price;
   
   if (OrderType()==OP_BUY) price=Bid;
   else if (OrderType()==OP_SELL) price=Ask;      
      
   bool result=OrderClose(OrderTicket(),OrderLots(),price,Slippage,MediumSeaGreen);
   if (result) {
      Alert(TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS)+" | "+EAComment+" | "+" Order closed : "+" @"+DoubleToStr(OrderClosePrice(),dig));
      Print(TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS)+" | "+EAComment+" | "+" Order closed : "+" @"+DoubleToStr(OrderClosePrice(),dig));
   }          
   if (!result) {
      Print(TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS)+" | "+EAComment+" | "+" Error closing order : ",GetLastError());
   }
} 

//+------------------------------------------------------------------+
//| FUNCTIONS: Money Management                                      |
//+------------------------------------------------------------------+
void check_breakeven() {
//----
   if (OrderStopLoss()==OrderOpenPrice()) return;
   else {
      //----
      if (OrderType()==OP_BUY) {
         if ((OrderStopLoss()<OrderOpenPrice()) && (Bid>=OrderOpenPrice()+BEPoint*pnt)) { 
            bool result=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,CLR_NONE);
            if (result) Alert(TimeToStr(TimeCurrent(), TIME_DATE|TIME_SECONDS)+" | "+EAComment+": Set to BreakEven : "+" @"+DoubleToStr(OrderOpenPrice(),dig));
            else Print(TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS)+" | "+"Error set to BreakEven : "+GetLastError());
         }
      }          

      else if (OrderType()==OP_SELL) {
         if ((OrderStopLoss()>OrderOpenPrice()) && (Ask<=OrderOpenPrice()-BEPoint*pnt)) {
            result=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,CLR_NONE);
            if (result) Alert(TimeToStr(TimeCurrent(), TIME_DATE|TIME_SECONDS)+" | "+EAComment+": Set to BreakEven : "+" @"+DoubleToStr(OrderOpenPrice(),dig));
            else Print(TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS)+" | "+"Error set to BreakEven : "+GetLastError());
         }
      }
   }
}

void check_trailingstop() {
//----
   if ((!Trail_TickMode) && (Volume[0]>1)) return;
   if ((OrderType()==OP_BUY) && (Bid>=OrderOpenPrice()+TrailingStop*pnt)) {
      if ((OrderStopLoss()<Bid-TrailingStop*pnt) || (OrderStopLoss()==0))    
         OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TrailingStop*pnt,OrderTakeProfit(),0,Lime);
   } 

   else if ((OrderType()==OP_SELL) && (Ask<=OrderOpenPrice()-TrailingStop*pnt)) {
      if ((OrderStopLoss()>Ask+TrailingStop*pnt) || (OrderStopLoss()==0)) 
         OrderModify(OrderTicket(),OrderOpenPrice(),Ask+TrailingStop*pnt,OrderTakeProfit(),0,Red);
   }
}

//+------------------------------------------------------------------+
//| FUNCTION: Miscellaneous                                          |
//+------------------------------------------------------------------+
void checkcomment() {
//----
   if (Close[1]>curma) string a="ABOVE MA";
   else a="below MA";
   if (curmacd>0) string b="ABOVE 0 LINE";
   else b="below 0 LINE"; 
   
   if (tradetime()) string c="OPEN";
   else if (!tradetime()) c="NOT ALLOWED"; 
   
   Comment("\n-----------------------------"+
           "\n-- "+"Day open time is:  "+TimeToStr(dayopentime)+
           "\n-- "+"Day close time is:  "+TimeToStr(dayclosetime)+
           "\n-- "+"Day of week is:  "+DoubleToStr(DayOfWeek(),0)+
           "\n-- "+"Is time allowed to open?  "+c+ 
           "\n-----------------------------"+ 
           "\n-- "+"Current real time spread is:  "+DoubleToStr(spread,1)+    
           "\n-- "+"Last bar closing price is:  "+DoubleToStr(Close[1],dig)+
           "\n-- "+"Last bar MA reading is:  "+DoubleToStr(curma,dig)+
           "\n-- "+"Last bar MACD reading is:  "+DoubleToStr(curmacd,dig)+
           "\n-- "+"Last bar close was  "+a+
           "\n-- "+"Last MACD was  "+b+
           "\n-----------------------------");
}


