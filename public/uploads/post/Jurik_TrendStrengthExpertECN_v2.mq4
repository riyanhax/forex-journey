//+------------------------------------------------------------------+
//|                                       TrendStrengthExpert_v2.mq4 |
//|                           Copyright © 2007, TrendLaboratory Ltd. |
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |
//|                                   E-mail: igorad2003@yahoo.co.uk |
//+------------------------------------------------------------------+
// #property copyright "Copyright © 2007, TrendLaboratory Ltd."
// #property link      "http://finance.groups.yahoo.com/group/TrendLaboratory"

#include <stdlib.mqh>

//---- input parameters
extern string     Expert_Name    = "TrendStrengthExpert_v2";

extern int        Magic          = 0;    // if Magic=0 then AutoMagic
extern int        Slippage       = 3;
extern bool       ECNbroker      = true;

extern string     Main_data      = " Trade Volume & Trade Method";
extern double     Lots           =   0.1;    // Trade Volume 
extern int        MaxOrders      =     1;
extern double     TakeProfit     =     0;    // Take Profit Value in pips 
extern double     StopLoss       =     0;    // Initial Stop Value in pips
extern int        TrailingMode   =     2;    // 0-off,1-standard,2-System by TE  
extern double     TrailingStop   =     0;    // Trailing Stop Value in pips
extern double     MoneyRisk      =     1;    // Deviation of VoltyChannel_Stop or MoneyRisk
extern double     BreakEven      =     0;    // Break-Even Value in pips
extern double     ProfitLock     =     0;    // Profit Lock in pips
extern int        ExitMode       =     0;    // System Exit Switch:0-off,1-TS,2-TE,3-AddSignal,4-any first,5-signal
extern bool       SignalMail     = False;    // E-mail Alert Switch

extern string     Time_Inputs    = " Timing parameters ";
extern int        StartHour      =     0;    // Start Hour of Trade Session 
extern int        StartMinute    =     0;    // Start Minute of Trade Session 
extern int        EndHour        =    23;    // End Hour of Trade Session
extern int        EndMinute      =     0;    // End Hour of Trade Session
extern int        CloseTimeMode  =     0;    // CloseTime mode: 0-off,1-on
extern int        CloseHour      =    24;    // Trade Close Hour   
extern int        CloseMinute    =     0;    // Trade Close Minute   

extern string     TE_Inputs      = " JurikTrendEnvelope parameters";
extern int        TE_TimeFrame   =     0;    // Time Frame in min
extern int        Length         =     34;
extern int        mamode         =     MODE_LWMA;
extern int        Price          =     0;
extern double     Phase          =     0;
extern double     Deviation      =     0.5;
extern int        UseSignal      =     0; 
extern int        AlertMode      =     0;
extern int        WarningMode    =     0;
extern int        TE_CurBar      =     1;    // Shift relative to the current bar
extern int        TE_Mode        =     0;    // TE Mode: 0-off,1-trend(confirmation),2-signal

extern string     VS_Inputs      = " VoltyChannel_Stop parameters";
extern int        VS_TimeFrame   =     0;    // Time Frame in min
extern int        VS_Price       =     0;    // Applied Price: 0-C,1-O,2-H,3-L,4-Median,5-Typical,6-Weighted
extern int        VS_JMALength    =    1;    // MA's Period  
extern int        VS_ATRLength   =    10;    // ATR's Period
extern double     VS_Kv          =     4;    // Volatility's Factor or Multiplier
extern int        VS_CurBar      =     1;    // Shift relative to the current bar
extern int        VS_Mode        =     0;    // VS Mode: 0-off,1-trend(confirmation),2-signal

extern string     TS_Inputs      = " Jurik TrendStrength parameters";
extern int        TS_TimeFrame   =     0;    // Time Frame in min
extern int        RsxLength      =     35;
extern int        TS_Price       =     0;
extern int        SmoothLength   =     5;
extern int        SmoothPhase    =     0;
extern double     K              =     8.0; // Multiplier 
extern int        TS_CurBar      =     1;    // Shift relative to the current bar
extern int        TS_Mode        =     1;    // TS Mode: 0-off,1-trend(confirmation),2-signal

extern string     Add_Inputs     = " Additional parameters";
extern int        Add_TimeFrame  =     0;    // Time Frame in min
extern string     x              = "Jurik Settings";
extern int        FastLength     =     5;
extern int        SlowLength     =     10;
extern int        FastPhase      =      0;
extern int        SlowPhase      =      0;
extern string     xx             = "Jurik STC Settings";
extern int        Add_Phase      =     0;
extern int        STCPeriod      =     10;
extern int        FastMAPeriod   =     23;
extern int        FastMAPhase    =     0;
extern int        SlowMAPeriod   =     50;
extern int        SlowMAPhase    =     0;
extern int        FilterMode     =     3;
extern string     N_RSXPeriod    =    "JRSX Settings";
extern int        Add_RsxLength  =     7;
extern int        Add_Price      =     0;
extern int        Add_SmoothLength=    5;
extern int        Add_SmoothPhase =    0;
extern int        Add_CurBar     =     1;    // Shift relative to the current bar
extern int        Add_Mode       =     0;    // Add Mode: 0-off,1-trend(confirmation),2-signal

extern string     AS_Inputs      = " AbsoluteStrength parameters";
extern int        AS_TimeFrame   =   240;    // Time Frame in min
extern int        AS_MathMode    =     0;    // 0-RSI method; 1-Stoch method; 2-ADX method
extern int        AS_Length      =    10;    // Period of evaluation
extern int        AS_Smooth      =     5;    // Period of smoothing
extern int        AS_Signal      =     5;    // Period of Signal Line
extern int        AS_Price       =     0;    // Price mode : 0-Close,1-Open,2-High,3-Low,4-Median,5-Typical,6-Weighted
extern int        AS_ModeMA      =     3;    // Mode of Moving Average
extern int        AS_CurBar      =     1;    // Shift relative to the current bar
extern int        AS_Mode        =     1;    // Add Mode: 0-off,1-trend(confirmation),2-signal

extern string     MM_inputs      = " MoneyManagement by L.Williams ";
extern bool       MM             = false;    // ÌÌ Switch
extern double     MaxRisk        =  0.05;    // Risk Factor
extern double     MaxLoss        =  1000;    // Maximum Loss by 1 Lot


double   PointRatio = 1;   //10 is for 5 digit, 1 is for 4 digit

int      OrderBar=0;
double   Lotsi;
int      BEvent=0, TriesNum=5;
datetime CurrBar,PrevBar;
double   UpLine, DnLine;
double   TStrend, pTStrend, VStrend, pVStrend, Addtrend, pAddtrend, TEtrend, pTEtrend;
double   Bulls, sBulls, Bears, sBears;
double   _Point;
int      aMagic;
int      digit;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
{
//---- Magic No. Calculation Boxter
   if(Magic==0){
      int MNSymbol,MNEACode,MNPeriod,a;  //definition magic no. variables for Symbol, EA name and Period
      MNPeriod=Period();
      for (a = 1; a < 7; a++) MNSymbol += StringGetChar(Symbol(), a);
      for (a = 1; a < StringLen(WindowExpertName())+1; a++) MNEACode += StringGetChar(WindowExpertName(), a);
      aMagic=1*MNSymbol+100*MNPeriod+10000*MNEACode;  //Magic Number generation
   }
   else aMagic = Magic;

   digit  = MarketInfo(Symbol(),MODE_DIGITS);
   if(digit==3 || digit==5) PointRatio=10;   //10 is for 5 digit, 1 is for 4 digit
   _Point = Point * PointRatio;
//----
   Comment ("Magic No. "+aMagic+"\n"+
            "Indicators: "+"\n"+
            "JurikTrendEnvelope; VoltyChannel_Stop; Jurik TrendStrength; AbsoluteStrength; JurikAddSignal");
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
   if (TE_TimeFrame==0) TE_TimeFrame = Period();
   if (TS_TimeFrame==0) TS_TimeFrame = Period();
   if (VS_TimeFrame==0) VS_TimeFrame = Period();
   if (Add_TimeFrame==0) Add_TimeFrame = Period();  
   if (AS_TimeFrame==0) AS_TimeFrame = Period(); 
   
   if(iBars(Symbol(),VS_TimeFrame) < 100 || IsTradeAllowed()==false) return(0); 
      
   if(AccountFreeMargin()< 1000*MoneyManagement()){
   Print("We have no money. Free Margin = ", AccountFreeMargin());
   return(0);  
   }
   CurrBar = iTime(Symbol(),0,0);
   
   datetime TimeClose = StrToTime(CloseHour+":"+CloseMinute); 
   
   if (CurrBar != PrevBar)
   {
      if(TrailingMode==2)
      {
      UpLine  = iCustom(Symbol(),VS_TimeFrame,"VoltyChannel_Stop_v2.2",VS_Price,VS_JMALength,VS_ATRLength,VS_Kv,1,0,0,0,0,VS_CurBar);
      DnLine  = iCustom(Symbol(),VS_TimeFrame,"VoltyChannel_Stop_v2.2",VS_Price,VS_JMALength,VS_ATRLength,VS_Kv,1,0,0,0,1,VS_CurBar);
      }
      else
      if(TrailingMode==3)
      {
      UpLine  = iCustom(Symbol(),TE_TimeFrame,"JurikTrendEnvelopes",Length,mamode,Price,Phase,Deviation,0,0,0,0,TE_CurBar);
      DnLine  = iCustom(Symbol(),TE_TimeFrame,"JurikTrendEnvelopes",Length,mamode,Price,Phase,Deviation,0,0,0,1,TE_CurBar);
      }      
      
      int Signal = TradeSignal();
      //Print(" Sig=",Signal);      
      if(ScanTrades()>0)
      {
         if(ExitMode == 1)
         {
         if (TStrend > 0 && pTStrend < 0) CloseOrder(2);
         if (TStrend < 0 && pTStrend > 0) CloseOrder(1);
         }
         else
         if(ExitMode == 2)
         {
         if (TEtrend > 0 && pTEtrend < 0) CloseOrder(2);
         if (TEtrend < 0 && pTEtrend > 0) CloseOrder(1);
         }
         else
         if(ExitMode == 3)
         {
         if (VStrend > 0 && pVStrend < 0) CloseOrder(2);
         if (VStrend < 0 && pVStrend > 0) CloseOrder(1);
         }
         else
         if(ExitMode == 4)
         {
         if (Addtrend > 0 && pAddtrend < 0) CloseOrder(2);
         if (Addtrend < 0 && pAddtrend > 0) CloseOrder(1);
         }
         else
         if(ExitMode == 5)
         {
         if ((TStrend > 0 && pTStrend < 0)||(VStrend > 0 && pVStrend < 0) || (TEtrend > 0 && pTEtrend < 0)) CloseOrder(2);
         if ((TStrend < 0 && pTStrend > 0)||(VStrend < 0 && pVStrend > 0) || (TEtrend < 0 && pTEtrend > 0)) CloseOrder(1);
         }
         else
         if(ExitMode == 6)
         {
         if (Signal > 0) CloseOrder(2);
         if (Signal < 0) CloseOrder(1);
         }
         else
         if(ExitMode == 7)
         {
         if ((TStrend > 0 && pTStrend < 0)||(VStrend > 0 && pVStrend < 0)||(Bulls > sBulls && Bulls > Bears)) CloseOrder(2);
         if ((TStrend < 0 && pTStrend > 0)||(VStrend < 0 && pVStrend > 0)||(Bears > sBears && Bulls < Bears)) CloseOrder(1);
         }
         else
         if(ExitMode == 8)
         {
         if ((Bulls > sBulls)||(Bears < sBears)) CloseOrder(2);
         if ((Bulls < sBulls)||(Bears > sBears)) CloseOrder(1);
         }
         else
         if(ExitMode == 9)
         {
         if ((TStrend > 0 && pTStrend < 0)||(Bulls > sBulls/* && Bulls > Bears*/)) CloseOrder(2);
         if ((TStrend < 0 && pTStrend > 0)||(Bears > sBears/* && Bulls < Bears*/)) CloseOrder(1);
         }
      
      if (CloseTimeMode > 0 && TimeCurrent() >= TimeClose) CloseOrder(0); 
      }
      
      if(ScanTrades() < MaxOrders)
      {
      if (Signal > 0) BuyOrdOpen() ;
      if (Signal < 0) SellOrdOpen();
      }
   }
   else
   if(ScanTrades()>0)
   {
   if(BreakEven > 0 || TrailingMode>0) TrailStop();
   }
   PrevBar = CurrBar;
   
//----
   return(0);
}

//-----------------------------------------------------
// Function Scan Trades
//-----------------------------------------------------
int ScanTrades()
{   
   int total = OrdersTotal();
   int numords = 0;
      
   for(int cnt=0; cnt<total; cnt++) 
   {        
   OrderSelect(cnt, SELECT_BY_POS);            
   if(OrderSymbol() == Symbol() && OrderType()<=OP_SELLSTOP && OrderMagicNumber() == aMagic) 
   numords++;
   }
   return(numords);
}  
//-----------------------------------------------------
// Function TimeCondition
//-----------------------------------------------------
bool TimeCondition()
{
   bool result = false;
   
   datetime SessionStart = StrToTime(StartHour+":"+StartMinute);
   datetime SessionEnd   = StrToTime(EndHour+":"+EndMinute);
   
   if (StartHour < EndHour)
   result = TimeCurrent() >= SessionStart && TimeCurrent() < SessionEnd;      
   else
   if (StartHour > EndHour)
   result = (TimeCurrent() > SessionStart && TimeHour(TimeCurrent()) < 24)
          ||(TimeHour(TimeCurrent()) >= 0 && TimeCurrent() < SessionEnd);
   
   return(result);
}   
//-----------------------------------------------------
// Function TS_Trend
//-----------------------------------------------------
int TS_Trend(int mode)
{   
   int result = 0; 
   
   TStrend  = iCustom(Symbol(),TS_TimeFrame,"Jurik TrendStrength2",RsxLength,Price,SmoothLength,SmoothPhase,K,6,TS_CurBar);
   pTStrend = iCustom(Symbol(),TS_TimeFrame,"Jurik TrendStrength2",RsxLength,Price,SmoothLength,SmoothPhase,K,6,TS_CurBar+1);
          
   if (mode == 1)
   {
   if (TStrend > 0) result =  mode;
   if (TStrend < 0) result = -mode; 
   }
   else
   if (mode == 2)
   {
   if (TStrend > 0 && pTStrend < 0) result =  mode;  
   if (TStrend < 0 && pTStrend > 0) result = -mode;
   }
   else
   if(mode == 0) result = 0;
   
   return(result); 
}
//-----------------------------------------------------
// Function TE_Trend
//-----------------------------------------------------
int TE_Trend(int mode)
{   
   int result = 0; 
   
   TEtrend  = iCustom(Symbol(),TE_TimeFrame,"JurikTrendEnvelopes",Length,mamode,Price,Phase,Deviation,0,0,0,6,TE_CurBar);
   pTEtrend = iCustom(Symbol(),TE_TimeFrame,"JurikTrendEnvelopes",Length,mamode,Price,Phase,Deviation,0,0,0,6,TE_CurBar+1);
   //Print("TEtrend=",TEtrend);       
   if (mode == 1)
   {
   if (TEtrend > 0) result =  mode;
   if (TEtrend < 0) result = -mode; 
   }
   else
   if (mode == 2)
   {
   if (TEtrend > 0 && pTEtrend < 0) result =  mode;  
   if (TEtrend < 0 && pTEtrend > 0) result = -mode;
   }
   else
   if(mode == 0) result = 0;
   
   return(result); 
}
//-----------------------------------------------------
// Function VS_Trend
//-----------------------------------------------------
int VS_Trend(int mode)
{   
   int result = 0; 
   
   VStrend  = iCustom(Symbol(),VS_TimeFrame,"VoltyChannel_Stop_v2.2",VS_Price,VS_JMALength,VS_ATRLength,VS_Kv,1,0,0,0,6,VS_CurBar);
   pVStrend = iCustom(Symbol(),VS_TimeFrame,"VoltyChannel_Stop_v2.2",VS_Price,VS_JMALength,VS_ATRLength,VS_Kv,1,0,0,0,6,VS_CurBar+1);
   //Print("TEtrend=",TEtrend);       
   if (mode == 1)
   {
   if (VStrend > 0) result =  mode;
   if (VStrend < 0) result = -mode; 
   }
   else
   if (mode == 2)
   {
   if (VStrend > 0 && pVStrend < 0) result =  mode;  
   if (VStrend < 0 && pVStrend > 0) result = -mode;
   }
   else
   if(mode == 0) result = 0;
   
   return(result); 
}
//-----------------------------------------------------
// Function Add_Trend
//-----------------------------------------------------
int Add_Trend(int mode)
{   
   int result = 0; 
   
   Addtrend  = iCustom(Symbol(),Add_TimeFrame,"JurikAddSignal","",FastLength,SlowLength,FastPhase,SlowPhase,"",
   STCPeriod,FastMAPeriod,FastMAPhase,SlowMAPeriod,SlowMAPhase,FilterMode,"",Add_RsxLength,
   Add_Price,SmoothLength,SmoothPhase,0,2,Add_CurBar);
   
   pAddtrend = iCustom(Symbol(),Add_TimeFrame,"JurikAddSignal","",FastLength,SlowLength,FastPhase,SlowPhase,"",
   STCPeriod,FastMAPeriod,FastMAPhase,SlowMAPeriod,SlowMAPhase,FilterMode,"",Add_RsxLength,
   Add_Price,SmoothLength,SmoothPhase,0,2,Add_CurBar+1);
      
   if (mode == 1)
   {
   if (Addtrend > 0) result =  mode;
   if (Addtrend < 0) result = -mode; 
   }
   else
   if (mode == 2)
   {
   if (Addtrend > 0 && pAddtrend < 0) result =  mode;
   if (Addtrend < 0 && pAddtrend > 0) result = -mode; 
   }
   else
   if(mode == 0) result = 0;
   
   return(result); 
}
//-----------------------------------------------------
// Function AbStrength
//-----------------------------------------------------
int AbStrength(int mode)
{   
   int result = 0; 
   
   Bulls  = iCustom(Symbol(),AS_TimeFrame,"AbsoluteStrength_v1.1",AS_MathMode,AS_Length,AS_Smooth,AS_Signal,AS_Price,AS_ModeMA,0,0,0,AS_CurBar);
   sBulls = iCustom(Symbol(),AS_TimeFrame,"AbsoluteStrength_v1.1",AS_MathMode,AS_Length,AS_Smooth,AS_Signal,AS_Price,AS_ModeMA,0,0,2,AS_CurBar);
   
   Bears  = iCustom(Symbol(),AS_TimeFrame,"AbsoluteStrength_v1.1",AS_MathMode,AS_Length,AS_Smooth,AS_Signal,AS_Price,AS_ModeMA,0,0,1,AS_CurBar);
   sBears = iCustom(Symbol(),AS_TimeFrame,"AbsoluteStrength_v1.1",AS_MathMode,AS_Length,AS_Smooth,AS_Signal,AS_Price,AS_ModeMA,0,0,3,AS_CurBar);
   
   if (mode == 1)
   {
   if (Bulls > sBulls) result =  mode;
   if (Bears > sBears) result = -mode; 
   }
   else
   if (mode == 2)
   {
   if (Bulls > sBulls && Bulls > Bears) result =  mode;
   if (Bears > sBears && Bulls < Bears) result = -mode; 
   }
   else
   if(mode == 0) result = 0;
   
   return(result); 
}
//-----------------------------------------------------
// Function TradeSignal
//-----------------------------------------------------
int TradeSignal()
{   
   int Signal =0;
   
   if (TS_Mode>0 || ExitMode == 1 || ExitMode == 5 || ExitMode == 7 || ExitMode == 9) int TS =  TS_Trend(TS_Mode); else TS=0;
   if (TE_Mode>0 || ExitMode == 2 || ExitMode == 5) int TE  = TE_Trend(TE_Mode); else TE=0;
   if (VS_Mode>0 || ExitMode == 3 || ExitMode == 5 || ExitMode == 7) int VS  = VS_Trend(VS_Mode); else VS=0; 
   if (Add_Mode>0 || ExitMode ==4) int AD =  Add_Trend(Add_Mode); else AD=0; 
   if (AS_Mode>0 || ExitMode > 6 ) int AS =  AbStrength(AS_Mode); else AS=0;    
     
   
   if (TimeCondition())
   {
   if ( TE == TE_Mode && VS == VS_Mode && TS == TS_Mode && AD == Add_Mode && AS == AS_Mode) Signal = 1;
   if ( TE ==-TE_Mode && VS ==-VS_Mode && TS ==-TS_Mode && AD ==-Add_Mode && AS ==-AS_Mode) Signal =-1;
   }  
 
   return(Signal);
}
//-----------------------------------------------------
// Function MoneyManagement (Williams)
//-----------------------------------------------------
double MoneyManagement()
{
   double lot_min =MarketInfo(Symbol(),MODE_MINLOT);
   double lot_max =MarketInfo(Symbol(),MODE_MAXLOT);
   double lot_step=MarketInfo(Symbol(),MODE_LOTSTEP);
   double contract=MarketInfo(Symbol(),MODE_LOTSIZE);
   double vol;
//--- check data
   if(lot_min<0 || lot_max<=0.0 || lot_step<=0.0) 
   {
   Print("CalculateVolume: invalid MarketInfo() results [",lot_min,",",lot_max,",",lot_step,"]");
   return(0);
   }
   if(AccountLeverage()<=0)
   {
   Print("CalculateVolume: invalid AccountLeverage() [",AccountLeverage(),"]");
   return(0);
   }
//--- basic formula
   if ( MM )
   {
      if (MaxLoss>0) vol = NormalizeDouble(AccountFreeMargin()*MaxRisk/MaxLoss,2);
      else   
      vol=NormalizeDouble(AccountFreeMargin()*MaxRisk*AccountLeverage()/contract,2);
   }
   else
   vol=Lots;
//--- check min, max and step
   vol=NormalizeDouble(vol/lot_step,0)*lot_step;
   if(vol<lot_min) vol=lot_min;
   if(vol>lot_max) vol=lot_max;
//---
   return(vol);
}   

//-----------------------------------------------------
// Function TrailStop
//-----------------------------------------------------
void TrailStop()
{
   int    error;  
   bool   result=false;
   double Gain = 0;
   double BuyStop;
    
   for (int cnt=0;cnt<OrdersTotal();cnt++)
   { 
   OrderSelect(cnt, SELECT_BY_POS);   
   int mode=OrderType();    
      if ( OrderSymbol()==Symbol() && OrderMagicNumber()==aMagic) 
      {
         if (mode==OP_BUY) 
         {
			   if ( BreakEven > 0 && BEvent==0 )
			   {
			   Gain = (MarketInfo(Symbol(),MODE_BID) - OrderOpenPrice())/_Point;
			      if( Gain >= BreakEven && OrderStopLoss()<=OrderOpenPrice()+ProfitLock*_Point) 
			      {
			      BuyStop = NormalizeDouble(OrderOpenPrice()+ProfitLock*_Point,Digits);
			      BEvent=1;
			      }
			   }
			   else if( TrailingMode==1 && TrailingStop > 0 ) BuyStop = NormalizeDouble(MarketInfo(Symbol(),MODE_BID) - TrailingStop*_Point,Digits);
			        else if( (TrailingMode==2 || TrailingMode==3) && UpLine>0) BuyStop = NormalizeDouble(UpLine,Digits);
			   
			   if( NormalizeDouble(OrderOpenPrice(),Digits)<= BuyStop) 
            {   
			      if ( BuyStop > NormalizeDouble(OrderStopLoss(),Digits) || OrderStopLoss() == 0) 
			      {
			         for(int k = 0 ; k < TriesNum; k++)
                  {
                     result = OrderModify(OrderTicket(),OrderOpenPrice(),BuyStop,OrderTakeProfit(),0,Lime);
                     error=GetLastError();
                     if(error==0) break;
                     else {Sleep(5000); RefreshRates(); continue;}
                  }   		 
               }            
            }
         }   
// - SELL Orders          
         if (mode==OP_SELL)
         {
            if ( BreakEven > 0 && BEvent==0)
			   {
			   Gain = (OrderOpenPrice()-MarketInfo(Symbol(),MODE_ASK))/_Point;
			   
			      if( Gain >= BreakEven && (OrderStopLoss()>=OrderOpenPrice()-ProfitLock*_Point || OrderStopLoss()== 0)) 
			      {
			      double SellStop = NormalizeDouble(OrderOpenPrice()-ProfitLock*_Point,Digits);
			      BEvent=-1;
			      }
			   }
			   else 
			   if (TrailingMode==1 && TrailingStop > 0) SellStop = NormalizeDouble(MarketInfo(Symbol(),MODE_ASK) + TrailingStop*_Point,Digits);   
            else
            if( (TrailingMode==2 || TrailingMode==3) && DnLine>0) SellStop = NormalizeDouble(DnLine,Digits);
                        
            if(NormalizeDouble(OrderOpenPrice(),Digits) >= SellStop && SellStop>0) 
            {
               if( SellStop < NormalizeDouble(OrderStopLoss(),Digits) || OrderStopLoss() == 0) 
               {
                  for( k = 0 ; k < TriesNum; k++)
                  {
                  result = OrderModify(OrderTicket(),OrderOpenPrice(),
			                              SellStop,
			                              OrderTakeProfit(),0,Orange);
                  error=GetLastError();
                     if(error==0) break;
                     else {Sleep(5000); RefreshRates(); continue;}
                  }
               }   
   			}	    
         }
      }
   }     
}

//-----------------------------------------------------
// Function Open Sell Orders
//-----------------------------------------------------
void SellOrdOpen(){		     
   double SellPrice = Bid;
   double StopPrice = Bid;
        	  
   if (StopLoss > 0) double SellStop  = StopPrice + StopLoss*_Point; 
	else	if( TrailingMode==2 && DnLine>0) SellStop = NormalizeDouble(DnLine,Digits); 
	      else SellStop = 0;  
   if (TakeProfit  > 0) double SellProfit = SellPrice - TakeProfit*_Point; 
   else SellProfit=0;
   
   if (!ECNbroker){
   	int ticket = OrderSend(Symbol(),OP_SELL,MoneyManagement(),NormalizeDouble(SellPrice,Digits),Slippage*_Point,
   	                       NormalizeDouble(SellStop,Digits),NormalizeDouble(SellProfit,Digits),Expert_Name+" SELL",aMagic,0,Red);
   	if(ticket > 0) {
         if (OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)) {
 
      		Print("SELL order opened: ", OrderOpenPrice());
            BEvent=0;
            if (SignalMail) SendMail("[Signal Alert]", "[" + Symbol() + "] " + DoubleToStr(Bid, Digits) + " Open Sell");
   		}
   		else Print("SELL: OrderSelect failed with error #",GetLastError());
      }
      else Print("SELL: OrderSend failed with error #",GetLastError());  
      return(0);
   }
   else {
      ticket = OrderSend(Symbol(),OP_SELL,MoneyManagement(),NormalizeDouble(SellPrice,Digits),Slippage*_Point,
                         0,0,Expert_Name+" SELL",aMagic,0,Red);               
      if(ticket > 0) {
         if (OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)) {
   
      		OrderModify(ticket,OrderOpenPrice(),NormalizeDouble(SellStop,Digits),NormalizeDouble(SellProfit,Digits),0,CLR_NONE);
      		Print("SELL order opened: ", OrderOpenPrice());
            BEvent=0;
            if (SignalMail) SendMail("[Signal Alert]", "[" + Symbol() + "] " + DoubleToStr(Bid, Digits) + " Open Sell");
   		}
   		else Print("SELL: ECN OrderSelect failed with error #",GetLastError());
      }
      else Print("SELL: ECN OrderSend failed with error #",GetLastError());
      return(0);
   }	
}
//-----------------------------------------------------
// Function Open Buy Orders
//-----------------------------------------------------
void BuyOrdOpen()
{		     
   double BuyPrice  = Ask;
   double StopPrice = Ask;
   double BuyStop;
      
   if (StopLoss > 0) BuyStop  = StopPrice - StopLoss *_Point; 
	else if ( TrailingMode==2 && UpLine > 0) BuyStop = NormalizeDouble(UpLine,Digits); 
	     else BuyStop = 0;
   if (TakeProfit  > 0) double BuyProfit= BuyPrice + TakeProfit*_Point; 
   else BuyProfit=0;  
   
	if (!ECNbroker){	 
   	int ticket = OrderSend(Symbol(),OP_BUY, MoneyManagement(),NormalizeDouble(BuyPrice,Digits),Slippage*_Point,
	                          NormalizeDouble(BuyStop,Digits),NormalizeDouble(BuyProfit,Digits),Expert_Name+" BUY",aMagic,0,Blue);  
      if(ticket > 0) {
         if (OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)) {
     
      		Print("BUY order opened: ", OrderOpenPrice());
            BEvent=0;
            if (SignalMail) SendMail("[Signal Alert]", "[" + Symbol() + "] " + DoubleToStr(Ask, Digits) + " Open Buy");
   		}
   		else Print("BUY : OrderSelect failed with error #",GetLastError());
      }
      else Print("BUY : OrderSend failed with error #",GetLastError());
      return(0);
   }
   else {
   	ticket = OrderSend(Symbol(),OP_BUY, MoneyManagement(),NormalizeDouble(BuyPrice,Digits),Slippage*_Point,
	                      0,0,Expert_Name+" BUY",aMagic,0,Blue);  
      if(ticket > 0) {
         if (OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)) {
            OrderModify(ticket,OrderOpenPrice(),NormalizeDouble(BuyStop,Digits),NormalizeDouble(BuyProfit,Digits),0,CLR_NONE);
    
      		Print("BUY order opened: ", OrderOpenPrice());
            BEvent=0;
            if (SignalMail) SendMail("[Signal Alert]", "[" + Symbol() + "] " + DoubleToStr(Ask, Digits) + " Open Buy");
   		}
   		else Print("BUY: ECN OrderSelect failed with error #",GetLastError());
      }
      else Print("BUY: ECN OrderSend failed with error #",GetLastError());
      return(0);
   }   
} 

//-----------------------------------------------------
// Function CloseOrder
//-----------------------------------------------------
void CloseOrder(int mode)  
{
   bool result=false; 
   int  total=OrdersTotal();
   
   for (int i=0; i<=OrdersTotal(); i++)  
   {
   OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if (OrderMagicNumber() == aMagic && OrderSymbol() == Symbol()) 
      {
      if ((mode == 0 || mode ==1) && OrderType()==OP_BUY ) result=CloseAtMarket(OrderTicket(),OrderLots(),Aqua);
      if ((mode == 0 || mode ==2) && OrderType()==OP_SELL) result=CloseAtMarket(OrderTicket(),OrderLots(),Pink);
      }
   }
}

//-----------------------------------------------------
// Function CloseAtMarket
//-----------------------------------------------------
bool CloseAtMarket(int ticket,double lot,color clr) 
{
   bool result = false; 
   int  ntr;
      
   int tries=0;
   while (!result && tries < TriesNum) 
   {
      RefreshRates();
      result=OrderClose(ticket,lot,OrderClosePrice(),Slippage*_Point,clr);
      tries++;
   }
   if (!result) Print("Error closing order : ",ErrorDescription(GetLastError()));
   return(result);
}

