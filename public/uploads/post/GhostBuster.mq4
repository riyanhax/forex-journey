 //+------------------------------------------------------------------+
//|   29-2-2012    symware@tin.it                      GhostBuster    |
//|                                                                   |
//|   TF: 1h - Currency pair: any profitable                          |
//|                                                                   |
//|------------------------------------------------------------------ |
//|  This program is freeware, so feel free to modify it in order     |
//|  to make it more profitable. Please do not change these info.     |
//|                                                                   |
//|------------------------------------------------------------------ |
//|                                                                   |
//|  The EA trade with the basket logic even if every trade has       |
//|  his own Take Profit and Stop Loss.                               |
//|  The EA opens one trade every hour accordingly with the trend     |
//|  and only if the LAST BAR is higher than the average BARS         |
//|  for that hour. That's all. Very simple.                          |
//|                                                                   |
//|  All trade are closed when target is reached. Target is lowered   |
//|  by the EA when trades increase to much.                          |
//|  The EA has also a Trailing Stop feature, but in my test it       |
//|  didn't prove to be of any utility.                               |
//|  The feature TOTAL PROFIT works only if you don't use others EA   |
//|  or manual trading.                                               |
//|                                                                   |
//|  i.e.: you are trading at 11.44 AM and the actual 1h BAR is now   |
//|  greater than the average candles for this hour.                  |
//|  Trend is UP and the last BAR is GREEN, the EA opens a buy        |
//|  position. If trend is DOWN and the last candle is RED the EA     |
//|  opens a sell position.                                           |
//|-------------------------------------------------------------------|
//|  Please remember to first test GhostBuster EA on a demo account.  |
//|  Don't exagerate, it could blown your account.                    |
//|  You run it at your own risk.                                     |
//|                                             Have great pips       |
//+-------------------------------------------------------------------+

#define  NL    "\n"
#property copyright "symware"
 
//--------- input parameters
extern int     BackDays            = 50; 
extern double  Lots                = 0.01;
extern int     Slippage            = 2;
extern double  SL                  = 210; //pips
extern double  TP                  = 150; //pips
extern double  Target              = 10; //dollar or your valute
extern string  Ts                  = "**Trailing Stop Input**"; 
extern bool    TrailingStop        = false;
extern double  TrailingStart       = 10;//pips
extern string  Be                  = "**Break Eeven Input**"; 
extern double  BreakEvenIs         = 5;//pips
//extern double  MaxSpread           = 2;
extern int     Magic               = 232232;
bool           CloseAll            = false;   
extern int     Periods             = 40;

   
extern string  th="----Trading hours----";
extern string  Trade_Hours         = "Set Morning & Evening Hours";
extern string  Trade_Hoursi        = "Use 24 hour, local time clock";
extern string  Trade_Hours_M       = "Morning Hours 0-12";
extern int     start_hourm         = 7;// your local time morning
extern int     start_minm          = 0;
extern int     end_hourm           = 12;
extern int     end_minm            = 0;
extern string  Trade_Hours_E       = "Evening Hours 12-24";
extern int     start_houre         = 12;// your local time afternoon
extern int     start_mine          = 0;
extern int     end_houre           = 22;
extern int     end_mine            = 0;

extern string  div                 = "";
extern int     DisplayGapSize      = 27;


string         Gap, ScreenMessage, TradeComment;
int            OldBars, multiplier, errore, iOrder, iBuy, iSell, PBull, PBear, ABull, ABear, FBull, FBear, H;
static double  dAccountBalance, dAccountBalanceInizio, MMHour, MMDay, MMWeek, Med, Meb, NewTarget; 
static double  dProfit, dTotale, MaxLoss, PREZZO, PMedia, AMedia, FMedia, PBody, ABody, FBody, PWicks, AWicks, FWicks, PVol, AVol, FVol; 
string         PipDescription=" pips", Trend, msg="GhostBuster", mm;
bool           FlagOra=false, Flag=false, FlagTS;   
 


 
// **********************************************************************
// expert initialization function                                       |
// **********************************************************************
 
int init()
{

   if (Period() != PERIOD_H1) 
   	{
      MessageBox("GhostBuster is designed to run on 1h chart");
   	}

    ObjectsDeleteAll(0,EMPTY);
   //Adapt to digit
   if(Digits == 2 || Digits == 4) multiplier = 1;
   if(Digits == 3 || Digits == 5) multiplier = 10;
   if(Digits == 6) multiplier = 100;   
   if(Digits == 7) multiplier = 1000;   

   if (TrailingStop==true && TrailingStart  <= MarketInfo(Symbol(),MODE_STOPLEVEL/multiplier)) {MessageBox("TS Start: cant be egual or less then "+ MarketInfo(Symbol(),MODE_STOPLEVEL)+". Now it has been changed at "+ MarketInfo(Symbol(),MODE_STOPLEVEL)*2); TrailingStart=MarketInfo(Symbol(),MODE_STOPLEVEL/multiplier)*2;}    

   TP            *= multiplier; TP            *=Point; TP            =NormalizeDouble(TP,Digits);
   SL            *= multiplier; SL            *=Point; SL            =NormalizeDouble(SL,Digits);
   TrailingStart *= multiplier; TrailingStart *=Point; TrailingStart =NormalizeDouble(TrailingStart,Digits);
   BreakEvenIs   *= multiplier; BreakEvenIs   *=Point; BreakEvenIs   =NormalizeDouble(BreakEvenIs,Digits);

   Gap="";
   if (DisplayGapSize >0)
   {
      for (int cc=0; cc< DisplayGapSize; cc++) { Gap = StringConcatenate(Gap, " "); }   
   }
   bool TradeTimeOk = CheckTradingTimes();
   if (TradeTimeOk) FlagOra=true; else FlagOra=false;
   dAccountBalanceInizio=AccountBalance(); 
         
return(0);
}



//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
 
int start()
{
   iOrder=0; iBuy=0; iSell=0; dProfit=0; 
   
   if (MarketInfo(Symbol(), MODE_ASK) >= iMA(Symbol(), 0, Periods, 0, MODE_EMA, PRICE_CLOSE,1)) Trend="UP"; else Trend="DOWN";
         for (int i=OrdersTotal()-1; i>=0; i--)
               {
               OrderSelect(i,SELECT_BY_POS);
                  if (OrderMagicNumber()==Magic && OrderType()== OP_BUY)   { iBuy++;  dProfit=dProfit+OrderProfit()+OrderCommission(); }
                  if (OrderMagicNumber()==Magic && OrderType()== OP_SELL)  { iSell++; dProfit=dProfit+OrderProfit()+OrderCommission(); }
              }
   iOrder=iBuy+iSell; NewTarget=Target;
   if (iOrder>5)   NewTarget=Target/2;
   if (iOrder>10)  NewTarget=Target/4;
   if (iOrder>15)  NewTarget=5;
   
   if (dProfit>=NewTarget) CloseAll();
   if (dProfit<MaxLoss) MaxLoss=dProfit;
   
   if (iOrder > 0 && TrailingStop == true) TrailingStop();
   if (iOrder ==0) { Flag=false; FlagTS=false; }
   if (CloseAll==true) CloseAll();
      
   if (FlagOra==true && CloseAll==false && Flag==false && mm=="GREEN" && Med>=AMedia && Trend=="UP"   ) { Flag=true; Buy();  } 
   if (FlagOra==true && CloseAll==false && Flag==false && mm=="RED"   && Med>=AMedia && Trend=="DOWN" ) { Flag=true; Sell(); } 

   if (OldBars != Bars)
      {
         PMedia=0; AMedia=0; FMedia=0; PBody=0; ABody=0; FBody=0; PWicks=0; AWicks=0; FWicks=0;
         PBull=0; PBear=0; ABull=0; ABear=0; FBull=0; FBear=0; PVol=0; AVol=0; FVol=0;
         
         OldBars = Bars; Flag=false;
         bool TradeTimeOk = CheckTradingTimes();
         if (TradeTimeOk) FlagOra=true; else FlagOra=false;
         H = Hour();         
         for (i=BackDays*24; i>1; i--)
               {
               if (StrToInteger(StringSubstr(TimeToStr(iTime(Symbol(), PERIOD_H1, i)),11,2)) ==  H)   
                   {  
                   PMedia=PMedia+(iHigh(Symbol(), PERIOD_H1, i-1)-iLow(Symbol(), PERIOD_H1, i-1));  
                   AMedia=AMedia+(iHigh(Symbol(), PERIOD_H1, i  )-iLow(Symbol(), PERIOD_H1, i  ));  
                   FMedia=FMedia+(iHigh(Symbol(), PERIOD_H1, i+1)-iLow(Symbol(), PERIOD_H1, i+1));  
                   
                   PBody=PBody+MathAbs((iOpen(Symbol(), PERIOD_H1, i-1)-iClose(Symbol(), PERIOD_H1, i-1)));
                   ABody=ABody+MathAbs((iOpen(Symbol(), PERIOD_H1, i  )-iClose(Symbol(), PERIOD_H1, i )));
                   FBody=FBody+MathAbs((iOpen(Symbol(), PERIOD_H1, i+1)-iClose(Symbol(), PERIOD_H1, i+1)));

                   if (iOpen(Symbol(), PERIOD_H1, i-1) < iClose(Symbol(), PERIOD_H1, i-1)) PBull++;
                   if (iOpen(Symbol(), PERIOD_H1, i-1) > iClose(Symbol(), PERIOD_H1, i-1)) PBear++;
                   if (iOpen(Symbol(), PERIOD_H1, i  ) < iClose(Symbol(), PERIOD_H1, i  )) ABull++;
                   if (iOpen(Symbol(), PERIOD_H1, i  ) > iClose(Symbol(), PERIOD_H1, i  )) ABear++;
                   if (iOpen(Symbol(), PERIOD_H1, i+1) < iClose(Symbol(), PERIOD_H1, i+1)) FBull++;
                   if (iOpen(Symbol(), PERIOD_H1, i+1) > iClose(Symbol(), PERIOD_H1, i+1)) FBear++;
                   
                   PVol=PVol+(iVolume(Symbol(), PERIOD_H1, i-1));
                   AVol=AVol+(iVolume(Symbol(), PERIOD_H1, i  ));
                   FVol=FVol+(iVolume(Symbol(), PERIOD_H1, i+1));
                   }  
               }
         PMedia=NormalizeDouble((PMedia/multiplier/Point/BackDays),1);
         AMedia=NormalizeDouble((AMedia/multiplier/Point/BackDays),1);
         FMedia=NormalizeDouble((FMedia/multiplier/Point/BackDays),1);
         PBody=NormalizeDouble((PBody/multiplier/Point/BackDays),1);
         ABody=NormalizeDouble((ABody/multiplier/Point/BackDays),1);
         FBody=NormalizeDouble((FBody/multiplier/Point/BackDays),1);
         PWicks=NormalizeDouble((PMedia-PBody)/2,1);
         AWicks=NormalizeDouble((AMedia-ABody)/2,1);
         FWicks=NormalizeDouble((FMedia-FBody)/2,1);
         PVol=NormalizeDouble(PVol/BackDays,0);
         AVol=NormalizeDouble(AVol/BackDays,0);
         FVol=NormalizeDouble(FVol/BackDays,0);
      }

   Report();
      
return(0);
}

 
 
//****************************************************************************************************************
//*********************************                    ORDERS              ***************************************
//****************************************************************************************************************
 
void Buy()
{
            PREZZO = MarketInfo(Symbol(), MODE_ASK); 
            int ticket = OrderSend(Symbol(), OP_BUY, Lots, PREZZO, Slippage, 0, 0, "GhostBuster "+Magic, Magic, 0,Blue); //---  buy 
            errore = GetLastError(); 
            if (ticket == -1 && errore > 1) {ErrorHandler(); return(0);}
            Flag=true; Sleep(1500); 
            
         for (int i=OrdersTotal()-1; i>=0; i--)
               {
               OrderSelect(i,SELECT_BY_POS);
               if (OrderMagicNumber()==Magic && OrderType()== OP_BUY) //TP e SL 
               if (OrderStopLoss()==0 || OrderTakeProfit()==0) OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice()-SL, OrderOpenPrice()+TP, 0, Blue);
               }            
  return(0);
}

void Sell()
{
            PREZZO = MarketInfo(Symbol(), MODE_BID);             
            int ticket = OrderSend(Symbol(), OP_SELL, Lots, PREZZO, Slippage, 0, 0, "GhostBuster "+Magic, Magic, 0, Red); //---  buy 
            errore = GetLastError();
            if (ticket == -1 && errore > 1) {ErrorHandler(); return(0);}
            Flag=true; Sleep(1500); 

         for (int i=OrdersTotal()-1; i>=0; i--)
               {
               OrderSelect(i,SELECT_BY_POS);
               if (OrderMagicNumber()==Magic && OrderType()== OP_SELL) //TP e SL
                  if (OrderStopLoss()==0 || OrderTakeProfit()==0) OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice()+SL, OrderOpenPrice()-TP, 0, Red);
               }                        
   return(0);
}
 


//****************************************************************************************************************
//***********************************************     REPORT   ***************************************************
//****************************************************************************************************************
 
void Report()
{
   Med=NormalizeDouble(((iHigh(Symbol(),0,0)-iLow(Symbol(),0,0))/Point/multiplier),1);
   Meb=NormalizeDouble((MathAbs(iOpen(Symbol(),0,0)-iClose(Symbol(),0,0))/Point/multiplier),1);
      
   if (IsTesting() && !IsVisualMode()) return(0);
   if (iOpen(Symbol(),0,0)<=iClose(Symbol(),0,0)) mm="GREEN"; else mm="RED";
   ScreenMessage = "";
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, NL);
   ScreenMessage = StringConcatenate(ScreenMessage, Gap, TimeToStr(TimeLocal(), TIME_DATE|TIME_MINUTES|TIME_SECONDS), NL );
 
   double i;
   int m,s,k;
   m=Time[0]+Period()*60-CurTime();
   i=m/60.0;
   s=m%60;
   m=(m-m%60)/60;
   
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, m + " minutes " + s + " seconds left to bar end", NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Candle hour: ", H-1, " --------------------------------------------", NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Average H-L:    ", PMedia, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Average body:  ", PBody, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Average wicks: ", PWicks, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Bull/Bear:      ", PBull, " / ", PBear, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Average volume: ", PVol, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Candle hour: ", H,   " ------------------------- ACTUAL CANDLE ------------------", NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Average H-L:    ", AMedia, "                     ", Med, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Average body:  ", ABody, "                     ", Meb, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Average wicks: ", AWicks, "                       ", (Med-Meb/2), NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Bull/Bear:      ", ABull, " / ", ABear, "                    ", mm, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Average volume: ", AVol, "                 ", iVolume(Symbol(), 0,0), NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Candle Hour: ", H+1, " -----------------------------------------------------------------", NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Average H-L:    ", FMedia, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Average body:  ", FBody, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Average wicks: ", FWicks, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Bull/Bear:      ", FBull, " / ", FBear, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Average volume: ", FVol, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "-----------------------------------------------------------------", NL, NL);  
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Gain: ", DoubleToStr(dProfit,2), "  -  Total profit: ", AccountBalance()-dAccountBalanceInizio, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Open buy/sell: ", iBuy," / ",iSell, NL);
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Max loss: ", MaxLoss, NL);
   if (FlagTS==true) {ScreenMessage = StringConcatenate(ScreenMessage,Gap, "*********** TRAILING STOP ACTIVATED **********", NL);}
                     else
                     {ScreenMessage = StringConcatenate(ScreenMessage,Gap, "                                             ", NL);}

   if (FlagOra==false)
            {
            ScreenMessage = StringConcatenate(ScreenMessage, NL, Gap, "***** OUTSIDE TRADING HOURS *****", NL);
            Comment(ScreenMessage);return(0);
            } 
   ScreenMessage = StringConcatenate(ScreenMessage,Gap, "Spread: ", MarketInfo(Symbol(), MODE_SPREAD)/multiplier, PipDescription,  NL);

   if (start_hourm == 0 && end_hourm == 12 && start_houre == 12 && end_houre == 24) ScreenMessage = StringConcatenate(ScreenMessage,Gap, "            24H trading", NL);
                     else
                     {
                     ScreenMessage = StringConcatenate(ScreenMessage,Gap, "            start_hour_m: ", DoubleToStr(start_hourm, 0),".",DoubleToStr(start_minm, 0), 
                     ": end_hour_m: ", DoubleToStr(end_hourm, 0), ".", DoubleToStr(end_minm, 0),NL);
                     ScreenMessage = StringConcatenate(ScreenMessage,Gap, "            start_hour_e: ", DoubleToStr(start_houre, 0),".",DoubleToStr(start_mine, 0), 
                     ": end_hour_e: ", DoubleToStr(end_houre, 0), ".", DoubleToStr(end_mine, 0),NL);
                     }

   Comment(ScreenMessage);

 return(0);
   
}//report()




//****************************************************************************************************************
//***************************************     CHECK TRADING TIMES   **********************************************
//****************************************************************************************************************

bool CheckTradingTimes()
{
   int hour = TimeHour  (TimeLocal() );
   int min  = TimeMinute(TimeLocal() );   
      
      if (end_hourm < start_hourm)	{ end_hourm += 24; }
   	if (end_houre < start_houre) 	{ end_houre += 24; }
	
	bool okTrade = false;
	
	okTrade = (hour > start_hourm  &&  hour < end_hourm)  ||  (hour > start_houre && hour < end_houre);

   if (hour == start_hourm && min >= start_minm ) okTrade = true;
   if (hour == end_hourm   && min <= end_minm   ) okTrade = true;

   if (hour == start_houre && min >= start_mine ) okTrade = true;
   if (hour == end_houre   && min <= end_mine   ) okTrade = true;
   

	if (!okTrade && hour < 12)
	{
 		hour += 24;
	   okTrade = (hour > start_hourm  &&  hour < end_hourm)  ||  (hour > start_houre && hour < end_houre);

      if (hour == start_hourm && min >= start_minm ) okTrade = true;
      if (hour == end_hourm   && min <= end_minm   ) okTrade = true;

      if (hour == start_houre && min >= start_mine ) okTrade = true;
      if (hour == end_houre   && min <= end_mine   ) okTrade = true;

	}

   if (hour >= MathMax(end_hourm, end_houre))
   {      
      okTrade = false;
   }
   return(okTrade);

}//bool CheckTradingTimes()



//****************************************************************************************************************
//*************************************           ErrorHandler         *******************************************
//****************************************************************************************************************
 
void ErrorHandler()
{
   switch (errore)
     {     
     case  2: MessageBox (" 2 - Common error",msg); break; 
     case  3: MessageBox (" 3 - Invalid trade parameter",msg); break; 
     case  4: MessageBox (" 4 - Trade server is busy",msg); break;
     case  5: MessageBox (" 5 - Old version of client terminal",msg);break; 
     case  6: MessageBox (" 6 - No connection with trade server",msg);break; 
     case  7: MessageBox (" 7 - No enought rights",msg); break;
     case  8: MessageBox (" 8 - Too frequent request",msg); break;
     case  9: MessageBox (" 9 - Malfunctional trade operation",msg);break;
     case 64: MessageBox ("64 - Account disabled",msg);break;
     case 65: MessageBox ("65 - Invalid account",msg);break;
      
     case 128: MessageBox ("128 - Trade timeout",msg); break;
     case 129: MessageBox ("129 - Invalid price",msg); break;
     case 130: MessageBox ("130 - Invalid stops",msg);break;
     case 131: MessageBox ("131 - Invalid trade volume",msg);break;
     case 132: MessageBox ("132 - Market is closed",msg);break;
     case 133: MessageBox ("133 - Trade is disabled",msg);break;
     case 134: MessageBox ("134 - Not enought money",msg);break;
     case 135: MessageBox ("135 - Price changed",msg);break;
     case 136: MessageBox ("136 - Off quotes",msg);break;
     case 137: MessageBox ("137 - Broker is busy",msg);break;
     case 138: MessageBox ("138 - Requote",msg);break;
     case 139: MessageBox ("139 - Order is locked",msg);break;
     case 140: MessageBox ("140 - Long position only allowed",msg);break;
     case 141: MessageBox ("141 - Too many request",msg);break;
     
     case 145: MessageBox ("145 - Modification denied because order too close to market",msg);break;
     case 148: MessageBox ("148 - The amount of orders has reached the limit set by the broker",msg);break;
     case 149: MessageBox ("149 - Hedging disabled",msg);break;
     case 150: MessageBox ("150 - Action contravening the FIFO rule",msg);break;

   }
         
  return(0);
}




//****************************************************************************************************************
//***************************************       TrailingStop OK OK OK   ********************************************
//****************************************************************************************************************

void TrailingStop()
{
  //Check position
   for (int i = OrdersTotal()-1; i >=0; i --) 
      {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
         if(OrderType() == OP_BUY && OrderMagicNumber()==Magic) 
               {
               if(MarketInfo(Symbol(),MODE_BID) - OrderOpenPrice() >= TrailingStart) 
                  {
                  if((MarketInfo(Symbol(),MODE_BID) - (OrderStopLoss()+(TrailingStart-BreakEvenIs))) >= Point*multiplier/2 ) 
                     {
                     OrderModify(OrderTicket(), OrderOpenPrice(), MarketInfo(Symbol(),MODE_BID) - (TrailingStart-BreakEvenIs), OrderTakeProfit(), 0, MediumSeaGreen);
                     FlagTS=true;
                     }
                  } 
                } 
          else 
          {
          if(OrderType()==OP_SELL && OrderMagicNumber()== Magic)
              {
              if((OrderOpenPrice() - MarketInfo(Symbol(),MODE_ASK)) >=  TrailingStart) 
                  {
                  if((OrderStopLoss()-(TrailingStart-BreakEvenIs)) - MarketInfo(Symbol(),MODE_ASK) >= Point*multiplier/2)   
                     {
                     OrderModify(OrderTicket(), OrderOpenPrice(), MarketInfo(Symbol(),MODE_ASK) + (TrailingStart-BreakEvenIs), OrderTakeProfit(), 0, DarkOrange);
                     FlagTS=true;
                     }
                  }
               }
           }
      }
   return(0);
 
} 




//****************************************************************************************************************
//*******************************                  CloseAll            *******************************************
//****************************************************************************************************************

void CloseAll()
{
   int i; bool result=false;
 
   for (i=OrdersTotal()-1;i>=0;i--)
      {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if (OrderType()== OP_BUY  && OrderMagicNumber()==Magic)  result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),Slippage,Violet);
         if (OrderType()== OP_SELL && OrderMagicNumber()==Magic)  result=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),Slippage,Violet);
         errore=GetLastError();
         if(result==false && errore>1) {ErrorHandler(); CloseAll();}
      }
//   ObjectsDeleteAll(0,EMPTY);          
return(0);
}
   



