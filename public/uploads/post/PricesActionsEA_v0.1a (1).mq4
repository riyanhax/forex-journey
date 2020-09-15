//===================================================================================================================//
// email: nikolaospantzos@gmail.com                                                                                  //       
//===================================================================================================================//
#property copyright "Copyright 2012 by PanNik"
//----------------------- Externals ----------------------------------------------------------------
extern string OpenParametre     = "==== Set Signals Parametre ====";
extern string TypeSignalUseInf  = "1:normal signal, 2:reverse signal";
extern int    TypeSignalUse     = 2;        // Signal to open
extern int    RangeLevel        = 11;       // Limit range
extern int    CountBars         = 14;       // Bars cnt
extern string Money_Management  = "==== Money Management ====";
extern bool   MoneyManagement   = true;     // Auto lot size
extern bool   RiskBaseStopLoss  = false;    // Calculate risk factor base stop loss
extern double RiskFactor        = 1;        // Risk for money management (from 0.1 to 50)
extern double ManualLotSize     = 0.01;     // Manual lot size
extern bool   RecoveryLot       = false;    // Recovery lot if loss order
extern double MultiplierLot     = 2;        // Multiplier lot recovery
extern string SetOrders         = "==== Set Orders Parametre ====";
extern bool   UseTakeProfit     = false;    // Use take profit
extern double TakeProfit        = 20;       // Profit for all orders
extern bool   UseStopLoss       = false;    // Use stop loss
extern double StopLoss          = 20;       // Loss for all orders
extern bool   UseTrailingStop   = false;    // Use trailing stop loss
extern double TrailingStop      = 40;       // Pips for trailing stop
extern bool   UseBreakEven      = false;    // Use break even 
extern double BreakEven         = 2;        // Pips for break even
extern double BreakEvenAfter    = 10;       // Pips plus break even
extern string CloseOrders       = "==== Close Orders ====";
extern bool   AutoCloseOrders   = true;     // Auto close ordres
extern string TimeFilter        = "==== Time Filter ====";
extern bool   UseTimeFilter     = false;    //Start stop time
extern int    TimeStartTrade    = 0;        //Time to start trade expert
extern int    TimeEndTrade      = 0;        //Time to stop trade expert
extern string ManageOrders      = "==== Manage Orders Set ====";
extern double MaxSpread         = 0;        // Maximum spread in pips, 0:Not check spread
extern double Slippage          = 3;        // Maximum slipage in pips
extern int    MagicNumber       = 777;      // Identifier
extern int    MaxOpenPositions  = 100;      //Maximum opened orders
extern string SetGeneral        = "==== General Set ====";
extern bool   UseCompletedBars  = true;     // Calculate price if bars in completed
extern bool   RunNDDbroker      = false;    // If broker not accept sl or tp in open order
extern int    SizeBackGround    = 156;      // Size for background
extern bool   SoundAlert        = true;     // Play sound if open, close or modify order
//===================================================================================================================//
string SoundFileAtOpen="alert.wav";
string SoundFileAtClose="alert2.wav";
string SoundModify="tick.wav";
string ExpertName;
string EASymbol;
double DigitPoint;
double StopLevel;
double LocalTrail;
double CurrentSpread;
double Spread;
double TotalProfitLoss=0;
double TotalPips=0;
double BufferHL=0;
double BufferCO=0;
double BufferCOcur=0;
int Singal=0;
int TotalTrades=0;
int WinsTrades=0;
int LossesTrades=0;
int OrderTime;
int MultiplierPoint;
int StartTime;
int TimeBusy;
int OrdersOpened;
int RunOrders;
bool CheckSpread;
bool CountHistory=true;
bool StartBuyRoutine=false;
bool StartSellRoutine=false;
bool CompleteBar=true;
static datetime TimePrev=0;
//===================================================================================================================//
//init function
int init()
{
//------------------------------------------------------
//Started information
ExpertName=WindowExpertName();
EASymbol=Symbol();
StartTime=TimeLocal();
//------------------------------------------------------
//Broker 4 or 5 digits
DigitPoint=MarketInfo(Symbol(),MODE_POINT);
MultiplierPoint=1;
if(MarketInfo(Symbol(),MODE_DIGITS)==3||MarketInfo(Symbol(),MODE_DIGITS)==5)
{
MultiplierPoint=10;
DigitPoint*=MultiplierPoint;
}
//------------------------------------------------------
//Minimum trailing, take profit and stop loss
StopLevel=MathMax(MarketInfo(Symbol(),MODE_FREEZELEVEL)/MultiplierPoint,MarketInfo(Symbol(),MODE_STOPLEVEL)/MultiplierPoint);
if((TrailingStop>0)&&(TrailingStop<StopLevel)) TrailingStop=StopLevel;
if((BreakEven>0)&&(BreakEven<StopLevel)) BreakEven=StopLevel;
if((TakeProfit>0)&&(TakeProfit<StopLevel)) TakeProfit=StopLevel;
if((StopLoss>0)&&(StopLoss<StopLevel)) StopLoss=StopLevel;
//------------------------------------------------------
//Confirm range
TypeSignalUse=MathMin(MathMax(TypeSignalUse,1),2);
MultiplierLot=MathMin(MathMax(MultiplierLot,1),4);
//------------------------------------------------------
//Background
if(ObjectFind("Background")==-1)
{
ObjectCreate("Background",OBJ_LABEL,0,0,0);
ObjectSet("Background",OBJPROP_CORNER,0);
ObjectSet("Background",OBJPROP_BACK,FALSE);
ObjectSet("Background",OBJPROP_YDISTANCE,15);
ObjectSet("Background",OBJPROP_XDISTANCE,0);
ObjectSetText("Background","g",SizeBackGround,"Webdings",DimGray);
}
//------------------------------------------------------
start();//For show comment if market is closed
return(0);
}
//===================================================================================================================//
//deinit function
int deinit()
{
//------------------------------------------------------
//Clear chart
ObjectDelete("Background");
Comment("");
return(0);
}
//===================================================================================================================//
//start function
int start()
{
CompleteBar=true;
CheckSpread=true;
LocalTrail=TrailingStop;
OrdersOpened=OrdersTotal();
GetSignal();
//------------------------------------------------------
//Completed bars
if(UseCompletedBars==true)
{
if(TimePrev==Time[0])
{
CompleteBar=false;
}
TimePrev=Time[0];
}
//------------------------------------------------------
//Market spread
Spread=MarketInfo(Symbol(),MODE_SPREAD)/MultiplierPoint;
//------------------------------------------------------
//Check spread
if(!IsTesting())
{
if((Spread>MaxSpread)&&(MaxSpread>0))//for forward test warning message
{
CheckSpread=false;
Print("Spread is greater than MaxSpread!!! (Spread: "+DoubleToStr(Spread,1)+" || MaxSpread: "+DoubleToStr(MaxSpread,1)+")");
Print("Expert check again spread....");
CurrentSpread=Spread;
}
//---
if((Spread<CurrentSpread)&&(Spread<=MaxSpread))
{
Print("Spread now is OK!!!");
CurrentSpread=0;
}
}
else
if((Spread>MaxSpread)&&(MaxSpread>0))//for backtest warning message
{
CheckSpread=false;
Print("Spread is greater than MaxSpread!!! (Spread: "+DoubleToStr(Spread,1)+" || MaxSpread: "+DoubleToStr(MaxSpread,1)+")");
}
//------------------------------------------------------
//Do if there is opened orders
if((isMgNum(MagicNumber)>0)&&(CompleteBar==true))
{
RunOrders=1;//there is open order
//------------------------------------------------------
//Call modify orders functions
if((UseTrailingStop==true)||(UseBreakEven==true)) ModifyOrders();
//------------------------------------------------------
//Call close orders functions
if(AutoCloseOrders==true) CloseOrders();
}//End if(isMgNum(MagicNumber)>0)
//------------------------------------------------------
//Check time to trade
if(UseTimeFilter==true)
{
if((TimeStartTrade<TimeEndTrade)&&((TimeHour(TimeCurrent())<TimeStartTrade)||(TimeHour(TimeCurrent())>TimeEndTrade))) return(0);
else
if((TimeStartTrade>TimeEndTrade)&&((TimeHour(TimeCurrent())<TimeStartTrade)&&(TimeHour(TimeCurrent())>=TimeEndTrade))) return(0);
}
//------------------------------------------------------
//Start check signal
if((CheckSpread==true)&&(CompleteBar==true))
{
//------------------------------------------------------
//Buy
if(isMgNum(MagicNumber)<MaxOpenPositions)
{
if(Singal==1) OpenPosition(OP_BUY);
}
//------------------------------------------------------
//Sell
if(isMgNum(MagicNumber)<MaxOpenPositions)
{
if(Singal==-1) OpenPosition(OP_SELL);
}
//------------------------------------------------------
}//End if((CheckSpread==true)...
//------------------------------------------------------
//Call comment function every tick
if(!IsTesting()) CommentScreen();
//------------------------------------------------------
//Count history orders
if((RunOrders==1)&&(isMgNum(MagicNumber)==0))
{
RunOrders=0;
CountHistory=true;
}
else
CountHistory=false;
//------------------------------------------------------
return(0);
}
//===================================================================================================================//
//open orders
void OpenPosition(int PositionType)
{
int OpenOrderTicket;
bool WasOrderModified;
double Price;
double OpenPrice;
color OpenColor;
string TypeOfOrder;
int TryCnt=0;
//------------------------------------------------------
//Calculate take profit and stop loss in pips
double TP,SL;
double OrderTP=NormalizeDouble(TakeProfit*DigitPoint,Digits);
double OrderSL=NormalizeDouble(StopLoss*DigitPoint,Digits);
double TrailingSL=NormalizeDouble(TrailingStop*DigitPoint,Digits);
//------------------------------------------------------
while(true)
{
//------------------------------------------------------
//Buy stop loss and take profit in price
if(PositionType==OP_BUY)
{
TP=0;
SL=0;
OpenPrice=NormalizeDouble(Ask,Digits);
OpenColor=Blue;
if((TakeProfit>0)&&(UseTakeProfit==true)) TP=NormalizeDouble(Ask+OrderTP,Digits);
if((StopLoss>0)&&(UseStopLoss==true)) SL=NormalizeDouble(Bid-OrderSL,Digits);
if((TrailingStop>0)&&(UseStopLoss==false)&&(UseTrailingStop==true)&&(SL==0)) SL=NormalizeDouble(Bid-TrailingSL,Digits);
TypeOfOrder="Buy";
}
//------------------------------------------------------
//Sell stop loss and take profit in price
if(PositionType==OP_SELL)
{
TP=0;
SL=0;
OpenPrice=NormalizeDouble(Bid,Digits);
OpenColor=Red;
if((TakeProfit>0)&&(UseTakeProfit==true)) TP=NormalizeDouble(Bid-OrderTP,Digits);
if((StopLoss>0)&&(UseStopLoss==true)) SL=NormalizeDouble(Ask+OrderSL,Digits);
if((TrailingStop>0)&&(UseStopLoss==false)&&(UseTrailingStop==true)&&(SL==0)) SL=NormalizeDouble(Ask+TrailingSL,Digits);
TypeOfOrder="Sell";
}
//------------------------------------------------------
//NDD broker, no sl no tp
if(RunNDDbroker==true)
{
TP=0;
SL=0;
}
//------------------------------------------------------
//Send orders
OpenOrderTicket=OrderSend(EASymbol,PositionType,CalcLots(),OpenPrice,Slippage,SL,TP,ExpertName,MagicNumber,0,OpenColor);
TryCnt++;
//---
if(OpenOrderTicket>0)
{
if(SoundAlert==true) PlaySound(SoundFileAtOpen);
break;
}
//---try 3 times to open
if(TryCnt==3)
{
Print(ExpertName+": Could not open order "+TypeOfOrder);
break;
}
//---
else
{
Print(ExpertName+": receives new data and try again open order");
Sleep(100);
RefreshRates();
}
//---
}//End while(true)
//------------------------------------------------------
//NDD send stop loss and take profit
if((RunNDDbroker==true)&&(OpenOrderTicket>0))
{
if(OrderSelect(OpenOrderTicket,SELECT_BY_TICKET))
{
TryCnt=0;
//------------------------------------------------------
//Modify stop loss and take profit buy order
if((OrderType()==OP_BUY)&&(OrderStopLoss()==0)&&(OrderTakeProfit()==0))
{
while(true) 
{
if((TakeProfit>0)&&(UseTakeProfit==true)) TP=NormalizeDouble(Ask+OrderTP,Digits); else TP=0;
if((StopLoss>0)&&(UseStopLoss==true)) SL=NormalizeDouble(Bid-OrderSL,Digits); else SL=0;
if((TrailingStop>0)&&(UseStopLoss==false)&&(UseTrailingStop==true)) SL=NormalizeDouble(Bid-TrailingStop,Digits); else SL=0;
//---
WasOrderModified=OrderModify(OrderTicket(),NormalizeDouble(OrderOpenPrice(),Digits),SL,TP,0,Blue);
TryCnt++;
//---
if(WasOrderModified>0)
{
if(SoundAlert==true) PlaySound(SoundModify);
Print(ExpertName+": modify buy by NDDmode, ticket: "+OrderTicket());
break;
}
//---try 3 times to modify
if(TryCnt==3)
{
Print(ExpertName+": Could not modify, ticket: "+OrderTicket());
break;
}
//---
else
{
Print("Error: ",GetLastError()+" || "+ExpertName+": receives new data and try again modify order");
RefreshRates();
}
//---
}//End while(true)
}//End if((OrderType()
//------------------------------------------------------
//Modify stop loss and take profit sell order
if((OrderType()==OP_SELL)&&(OrderStopLoss()==0)&&(OrderTakeProfit()==0))
{
while(true) 
{
if((TakeProfit>0)&&(UseTakeProfit==true)) TP=NormalizeDouble(Bid-OrderTP,Digits); else TP=0;
if((StopLoss>0)&&(UseStopLoss==true)) SL=NormalizeDouble(Ask+OrderSL,Digits); else SL=0;
if((TrailingStop>0)&&(UseStopLoss==false)&&(UseTrailingStop==true)) SL=NormalizeDouble(Ask+TrailingStop,Digits); else SL=0;
//---
WasOrderModified=OrderModify(OrderTicket(),NormalizeDouble(OrderOpenPrice(),Digits),SL,TP,0,Red);
TryCnt++;
//---
if(WasOrderModified>0)
{
if(SoundAlert==true) PlaySound(SoundModify);
Print(ExpertName+": modify sell by NDDmode, ticket: "+OrderTicket());
break;
}
//---try 3 times to modify
if(TryCnt==3)
{
Print(ExpertName+": Could not modify, ticket: "+OrderTicket());
break;
}
//---
else
{
Print("Error: ",GetLastError()+" || "+ExpertName+": receives new data and try again modify order");
RefreshRates();
}
//---
}//End while(true)
}//End if((OrderType()
//------------------------------------------------------
}//End OrderSelect(...
//------------------------------------------------------
}//End if(RunNDDbroker==true)
return(0);
}
//===================================================================================================================//
//modify orders
void ModifyOrders()
{
double LocalStopLoss=0;
bool WasOrderModified;
string CommentModify;
int TryCnt=0;
//------------------------------------------------------
//Select order
for(int i=0; i<OrdersTotal(); i++)
{
if(OrderSelect(i,SELECT_BY_POS)==True)
{
if((OrderSymbol()==EASymbol)&&(OrderMagicNumber()==MagicNumber))
{
//------------------------------------------------------
//Modify buy
if(OrderType()==OP_BUY)
{
TryCnt=0;
LocalStopLoss=0.0;
while(true)
{
//-----------------------
//Break even
if((LocalStopLoss==0)&&(BreakEven>0)&&(UseBreakEven==true)&&(Bid-OrderOpenPrice()>=(BreakEven+BreakEvenAfter)*DigitPoint)&&(NormalizeDouble(OrderOpenPrice()+BreakEven*DigitPoint,Digits)<=Bid-(StopLevel*DigitPoint))&&(OrderStopLoss()<OrderOpenPrice()))
{
LocalStopLoss=NormalizeDouble(OrderOpenPrice()+BreakEven*DigitPoint,Digits);
CommentModify="break even";
}
//-----------------------
//Trailing stop
if((LocalStopLoss==0)&&(LocalTrail>0)&&(UseTrailingStop==true)&&(NormalizeDouble(Bid-LocalTrail*DigitPoint,Digits)>OrderStopLoss()))
{
LocalStopLoss=NormalizeDouble(Bid-LocalTrail*DigitPoint,Digits);
CommentModify="trailing stop";
}
//-----------------------
//Modify
if((LocalStopLoss>0)&&(LocalStopLoss!=NormalizeDouble(OrderStopLoss(),Digits)))
{
WasOrderModified=OrderModify(OrderTicket(),0,LocalStopLoss,NormalizeDouble(OrderTakeProfit(),Digits),0,Blue);
TryCnt++;
}
else break;
//---
if(WasOrderModified>0)
{
if(SoundAlert==true) PlaySound(SoundModify);
Print(ExpertName+": modify buy by "+CommentModify+", ticket: "+OrderTicket());
break;
}
//---try 3 times to modify
if(TryCnt==3)
{
Print(ExpertName+": Could not modify, ticket: "+OrderTicket());
break;
}
//---
else
{
Print("Error: ",GetLastError()+" || "+ExpertName+": receives new data and try again modify order");
RefreshRates();
}
//---
}//End while(true)
}//End if(OrderType()
//------------------------------------------------------
//Modify sell
if(OrderType()==OP_SELL)
{
LocalStopLoss=0.0;
TryCnt=0;
while(true)
{
//-----------------------
//Break even
if((LocalStopLoss==0)&&(BreakEven>0)&&(UseBreakEven==true)&&(OrderOpenPrice()-Ask>=(BreakEven+BreakEvenAfter)*DigitPoint)&&(NormalizeDouble(OrderOpenPrice()-BreakEven*DigitPoint,Digits)>=Ask+(StopLevel*DigitPoint))&&(OrderStopLoss()>OrderOpenPrice()))
{
LocalStopLoss=NormalizeDouble(OrderOpenPrice()-BreakEven*DigitPoint,Digits);
CommentModify="break even";
}
//-----------------------
//Trailing stop
if((LocalStopLoss==0)&&(LocalTrail>0)&&(UseTrailingStop==true)&&(NormalizeDouble(Ask+LocalTrail*DigitPoint,Digits)<OrderStopLoss()))
{
LocalStopLoss=NormalizeDouble(Ask+LocalTrail*DigitPoint,Digits);
CommentModify="trailing stop";
}
//-----------------------
//Modify
if((LocalStopLoss>0)&&(LocalStopLoss!=NormalizeDouble(OrderStopLoss(),Digits)))
{
WasOrderModified=OrderModify(OrderTicket(),0,LocalStopLoss,NormalizeDouble(OrderTakeProfit(),Digits),0,Red);
TryCnt++;
}
else break;
//---
if(WasOrderModified>0)
{
if(SoundAlert==true) PlaySound(SoundModify);
Print(ExpertName+": modify sell by "+CommentModify+", ticket: "+OrderTicket());
break;
}
//---try 3 times to modify
if(TryCnt==3)
{
Print(ExpertName+": Could not modify, ticket: "+OrderTicket());
break;
}
//---
else
{
Print("Error: ",GetLastError()+" || "+ExpertName+": receives new data and try again modify order");
RefreshRates();
}
//---
}//End while(true)
}//End if(OrderType()
//------------------------------------------------------
}//End if((OrderSymbol()...
}//End OrderSelect(...
}//End for(...
return(0);
}
//===================================================================================================================//
//close orders
void CloseOrders()
{
int TryCnt=0;
bool CloseBuy=false;
bool CloseSell=false;
bool WasOrderClosed;
double SumLots=0;
double ModeLotPair=NormalizeDouble(MarketInfo(Symbol(),MODE_TICKVALUE)*MarketInfo(Symbol(),MODE_TICKSIZE)/DigitPoint,5);
//------------------------------------------------------
for(int i=OrdersTotal()-1; i>=0; i--)
{
if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
{
if((OrderSymbol()==EASymbol)&&(OrderMagicNumber()==MagicNumber))
{
SumLots+=OrderLots();
//------------------------------------------------------
if(AccountEquity()-AccountBalance()>SumLots*ModeLotPair)
{
CloseBuy=true;
CloseSell=true;
}
//------------------------------------------------------
//Close buy
if(OrderType()==OP_BUY)
{
TryCnt=0;
while(true) 
{
//------------------------------------------------------
if(CloseBuy==true)
{
WasOrderClosed=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),Slippage,Yellow);
TryCnt++;
}
else break;
//---
if(WasOrderClosed>0)
{
if(SoundAlert==true) PlaySound(SoundFileAtClose);
Print(ExpertName+": close buy, ticket: "+OrderTicket());
break;
}
//---try 3 times to close
if(TryCnt==3)
{
Print(ExpertName+": Could not close, ticket: "+OrderTicket());
break;
}
//---
else
{
Print("Error: ",GetLastError()+" || "+ExpertName+": receives new data and try again close order");
RefreshRates();
}
//---
}//End while(...
}//End if(OrderType()==OP_BUY)
//------------------------------------------------------
//Close sell
if(OrderType()==OP_SELL)
{
TryCnt=0;
while(true) 
{
//------------------------------------------------------
if(CloseSell==true)
{
WasOrderClosed=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),Slippage,Yellow);
TryCnt++;
}
else break;
//---
if(WasOrderClosed>0)
{
if(SoundAlert==true) PlaySound(SoundFileAtClose);
Print(ExpertName+": close sell, ticket: "+OrderTicket());
break;
}
//---try 3 times to close
if(TryCnt==3)
{
Print(ExpertName+": Could not close, ticket: "+OrderTicket());
break;
}
//---
else
{
Print("Error: ",GetLastError()+" || "+ExpertName+": receives new data and try again close order");
RefreshRates();
}
//---
}//End while(...
}//End if(OrderType()==OP_SELL)
//------------------------------------------------------
}//End if((OrderSymbol()...
}//End OrderSelect(...
}//End for(...
return(0);
}
//===================================================================================================================//
//Get magic number orders
int isMgNum(int Magic)
{
int SumOrders=0;
for(int i=0; i<OrdersTotal(); i++)
{
if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
{
if((OrderMagicNumber()==Magic)&&(OrderSymbol()==Symbol())) SumOrders++;
}
}
return(SumOrders);
}
//===================================================================================================================//
//lot size
double CalcLots()
{
double MinLot=MarketInfo(Symbol(),MODE_MINLOT);
double MaxLot=MarketInfo(Symbol(),MODE_MAXLOT);
double LotStep=MarketInfo(Symbol(),MODE_LOTSTEP);
double LotValue=MarketInfo(Symbol(),MODE_LOTSIZE);
double LotSize,Lot;
double LastLot=0;
int LotDigit;
//------------------------------------------------------
//Limit risk level
RiskFactor=MathMin(MathMax(RiskFactor,0.1),50);//Risk between 0.1 - 50
//------------------------------------------------------
//Auto lot size
if((MoneyManagement==true)&&((UseStopLoss==false)||(RiskBaseStopLoss==false))) LotSize=(AccountFreeMargin()/LotValue)*RiskFactor;
if((MoneyManagement==true)&&(UseStopLoss==true)&&(RiskBaseStopLoss==true)) LotSize=(AccountEquity()*(RiskFactor/100))/StopLoss;
//if(MoneyManagement==true) LotSize=(AccountFreeMargin()/LotValue)*RiskFactor;
//------------------------------------------------------
//Manual lot size
if(MoneyManagement==false) LotSize=ManualLotSize;
//------------------------------------------------------
//Lot digit
if(LotStep==1) LotDigit=0;
if(LotStep==0.1) LotDigit=1;
if(LotStep==0.01) LotDigit=2;
if(MinLot==0.01) LotDigit=2;
//------------------------------------------------------
//lot size
Lot=NormalizeDouble(MathMin(MathMax(LotSize,MinLot),MaxLot),LotDigit);
//------------------------------------------------------
return(Lot);
}
//===================================================================================================================//
//comment in chart
void CommentScreen()
{
string FirstOrderString="First Order Opened:  Not opened order yet";
string MMstring="";
string StringNN="";
string StringTM="";
string StringSpread="";
double PrintMaxSpread=MaxSpread;
//------------------------------------------------------
//Calculate total profit or loss, trades and pips
if(CountHistory==true)
{
for(int iCnt=OrdersHistoryTotal()-1; iCnt>=0; iCnt--)
{      
if(OrderSelect(iCnt,SELECT_BY_POS,MODE_HISTORY))
{
if((OrderType()<=OP_SELL)&&(OrderMagicNumber()==MagicNumber))
{
OrderTime=OrderOpenTime();//Calculate time to open first order
TotalTrades++;//Calculate total orders
//------------------------------------------------------
//wins orders
if(OrderProfit()>=0)
{
WinsTrades++;
TotalProfitLoss+=OrderProfit()+OrderCommission()+OrderSwap();
TotalPips+=(MathMax(OrderOpenPrice(),OrderClosePrice())-MathMin(OrderOpenPrice(),OrderClosePrice()))/
(MarketInfo(OrderSymbol(),MODE_POINT)*MultiplierPoint);
}
//------------------------------------------------------
//Losses orders
if(OrderProfit()<0)
{
LossesTrades++;
TotalProfitLoss-=MathAbs(OrderProfit()+OrderCommission()+OrderSwap());
TotalPips-=(MathMax(OrderOpenPrice(),OrderClosePrice())-MathMin(OrderOpenPrice(),OrderClosePrice()))/
(MarketInfo(OrderSymbol(),MODE_POINT)*MultiplierPoint);
}
//------------------------------------------------------
}//End if((...
}//End OrderSelect(...
}//End for(...
}
//------------------------------------------------------
//String first order
if(TimeToStr(OrderTime,TIME_DATE)>"2000") FirstOrderString="First Order Opened:  "+TimeToStr(OrderTime,TIME_DATE|TIME_SECONDS);
//------------------------------------------------------
//String money management
if(MoneyManagement==true) MMstring="AUTO";
if(MoneyManagement==false) MMstring="MANUAL";
//------------------------------------------------------
//String spread
if(MaxSpread==0) StringSpread="   EA NOT CHECK SPREAD,  Expert running";
if((Spread<=MaxSpread)&&(MaxSpread>0)) StringSpread="   SPREAD IS ACCEPT,  Expert is running";
if((Spread>MaxSpread)&&(MaxSpread>0)) StringSpread="SPREAD IS NOT ACCEPT. EA stop running";
//------------------------------------------------------
//Comment in chart
Comment("=============================","\n",
" ACCOUNT NUMBER : ",AccountNumber(),"\n",
" ACCOUNT NAME     : ",AccountName(),"\n",
"=============================","\n",
" MAXIMUM SPREAD: ",PrintMaxSpread,",  PAIR SPREAD: ",Spread,"\n",
StringSpread,"\n",
"=============================","\n",
" Money Management: ",MMstring,",  LOT : ",CalcLots(),"\n",
"=============================","\n",
FirstOrderString,"\n",
"=============================","\n",
"Magic Number: ",MagicNumber,",  Total_Trades: ",TotalTrades,"\n",
"WINS_TRADES : ",WinsTrades,",  LOSSES_TRADES: ",LossesTrades,"\n",
"TOTAL_PIPS  : ",TotalPips,",  TOTAL_P/L: ",TotalProfitLoss,"\n",
"=============================","\n",
"CurrentLevel: ",DoubleToStr(MathAbs((BufferHL-BufferCO)/BufferCOcur),2),"   OpeningLevel: ",DoubleToStr(RangeLevel,2),"\n",
"=============================");
//------------------------------------------------------
return(0);
}
//===================================================================================================================//
//Orders signals
void GetSignal()
{
int TypeOfSignals=0;
Singal=0;
BufferHL=0;
BufferCO=0;
BufferCOcur=0;
//------------------------------------------------------
for(int i=0; i<CountBars; i++)
{
BufferHL+=((High[i+1]-High[i+2])+(High[i+1]-Low[i+2])+(Low[i+1]-High[i+2])+(Low[i+1]-Low[i+2]))/DigitPoint;
BufferCO+=((Close[i+1]-Close[i+2])+(Close[i+1]-Open[i+2])+(Open[i+1]-Close[i+2])+(Open[i+1]-Open[i+2]))/DigitPoint;
BufferCOcur+=((Close[i+1]-Open[i+1])+(Close[i+2]-Open[i+2]))/DigitPoint;
}
//------------------------------------------------------
if(TypeSignalUse==1) TypeOfSignals=1;
if(TypeSignalUse==2) TypeOfSignals=-1;
//------------------------------------------------------
if((BufferCOcur!=0)&&(BufferCO!=0))
{
if((BufferHL-BufferCO)/BufferCOcur>RangeLevel) Singal=1*TypeOfSignals;
if((BufferHL-BufferCO)/BufferCOcur<RangeLevel*(-1)) Singal=-1*TypeOfSignals;
}
//------------------------------------------------------
return(0);
}
//===================================================================================================================//
//End code

