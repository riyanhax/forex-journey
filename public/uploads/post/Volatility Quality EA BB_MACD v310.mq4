//+------------------------------------------------------------------+
//|                        Volatility Quality EA BB_MACD 310.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2010,jyt"
#property link      "nope"

//+----------------------------------------------------------------------------+
//|  External inputs                                                           |
//+----------------------------------------------------------------------------+

#define EAName "Volatility Quality EA BB_MACD 310"
string  comment="EA";                     // comment to display in the order



extern int magic                          = 0; // magic number required if you use different settings on a same pair, same timeframe
bool useprint                             = false; // use print
bool onlybuy                              = false; // only enter buy orders
bool onlysell                             = false; // only enter sell orders

extern bool ecn                           = false;// make the expert compatible with ecn brokers


#define SIGNAL_NONE 0
#define SIGNAL_BUY   1
#define SIGNAL_SELL  2
#define SIGNAL_CLOSEBUY 3
#define SIGNAL_CLOSESELL 4

extern string S1="---------------- Entry Settings";

extern double gamma=0.7; //Laguerre RSI Indicator
extern bool    Crash                      = false;
extern int     TimeFrame                  = 0; //30;
extern int     Length                     = 8; //5;
extern int     Method                     = 3;
extern int     Smoothing                  = 2; //1;
extern int     Filter                     = 2; //5;
extern bool    RealTime                   = true;
extern bool    Steady                     = false; // true; //
extern bool    Color                      = true;
extern bool    Alerts                     = true;
extern bool    EmailON                    = false;
extern bool    SignalPrice                = true;
extern color   SignalPriceBUY             = Yellow;
extern color   SignalPriceSELL            = Aqua;
extern int     CountBars                   =1485;
extern bool    SignalMail                 = False;
extern bool    EachTickMode               = False;

extern string S2="---------------- Money Management";

extern bool    UseMM                      = true; 
extern double Lots                        = 0.1;//|------------lots size
extern double lots                        = 0.1;//|------------lots size
extern bool RiskMM                        = true; // false-------risk management
extern double RiskPercent                 = 2;// 1; --------risk percentage
extern bool    Martingale                 = true; // false;//|-----------------martingale
extern double Multiplier                  = 2.0;//|-----------------multiplier martingale
extern double MinLots                     = 0.01;//|-------------------minlots
extern double MaxLots                     = 100;//|--------------------maxlots
extern int MaximumRisk                    = 0.05;
extern int        DecreaseFactor          = 0;        //
extern bool       MM                      = false;     //Money management
extern bool       AccountIsMicro          = false;	//Micro means 0.01 lot size is allowed
extern double risk                        =1; // risk in percentage of the account
extern double minlot                      =0.01; // minimum lots size
extern double maxlot                      =100; // maximum lots size
extern int lotdigits                      =2; // lot digits, 1=0.1, 2=0.01
extern bool martingale                    =false; // enable the martingale, set maxtrades to 1
double multiplier                         =2.0; // multiplier used for the martingale
double closepercent1                      =75;

extern string S3="---------------- Profit Management";

bool basketpercent                  =false;         // enable the basket percent
double profit                       = 1; //0.1; // close all orders if a profit of 10 percents has been reached
double loss                         = 100;                  // close all orders if a loss of 30 percents has been reached
bool basketpips                     = false;            // enable the basket pips
double profitpips                   = 12;             // close all orders if a profit of 10 percents has been reached
double losspips                     = 10000;            // close all orders if a loss of 30 percents has been reached
bool basketdollars                  = false;         // enable basket dollars
double dollars                      = 20;  // 5; //target in dollars

extern string S4="---------------- Order Management";

extern int MaxTradePerBar                 = 1;

extern string  _SL_TP   = "This system use ATR to Set TP&SL";
                  
extern int      ATR_PERIOD                = 191;   
extern int      ATR_Multiple              =7;
extern string    SAR_DES                  = "Select 1 if do you want to use Parabolic SARS to check the trend signal";
extern int      USE_SAR                   = 1;//option 3
extern double    SARStep                  = 0.02;
extern double    SARMax                   = 0.2;
extern int    maMethodBand                = MODE_SMA;     // ma_method for iStd(), 0:SMA 1:EMA 2:SMMA 3:LWMA
extern int    nPeriod                     = 20;           // bars in timeFrame
extern int    appliedPrice                = PRICE_CLOSE;  // 0:CLOSE 1:OPEN 2:HIGH 3:LOW 4:MEDIAN 5:TYPICAL 6:WEIGHTED
extern int     Fixed_TP                   = 100; // 150
extern double  TakeProfit_ATR             = 1.9;
extern int     Fixed_SL                   = 10;
extern double  StopLoss_ATR               = 0.7 ;

extern bool StopLossMode                  = True;
extern bool UseStopLoss                   = True;
extern int  StopLoss                      = 55; //50;//|-stop loss
extern bool TakeProfitMode                = False;
extern bool UseTakeProfit                 = False;
extern int TakeProfit                     = 170; //|-take profit
extern bool HideSL                        = false; //|--hide stop loss
extern bool HideTP                        = false; //|--hide take profit
extern int TrailingProfit                 = 30; //0; //|-trailing stop after profit reached


extern bool UseTrailingStop               = False;
extern int TrailingStop                   = 35; //0;//|------trailing stop
extern int TrailingStep                   = 1; //0;//|-------trailing step
extern int BreakEven                      = 3; //0;//|-break even
extern int MaxOrders                      =100; //|-----maximum orders allowed
extern int Slippage                       =3; //|---------slippage
extern double MaxSpread_Allowed           = 5; //|----------Max Spread Allowed
extern double slippage                    =0; // maximum difference in pips between signal and order
extern double maxspread                   =0; // maximum spread allowed by the expert, 0=disabled


extern int MagicNumber                    = 0; //|------------------magic number


extern string adordersmanagement="Advanced Order Management";
extern bool oppositeclose=true;          // close the orders on an opposite signal
extern bool reversesignals=false;        // reverse the signals, long if short, short if long
extern int maxtrades=100;                // maximum trades allowed by the traders
extern int tradesperbar=1;               // maximum trades per bar allowed by the expert
extern bool hidesl=false;                // hide stop loss
extern bool hidetp=false;                // hide take profit
extern double stoploss=40;                // stop loss
extern double takeprofit=0;              // take profit
extern double trailingstart=0;           // profit in pips required to enable the trailing stop
extern double trailingstop=0;            // trailing stop

int expiration=1440;                 // expiration in minutes for pending orders
double trailingprofit=0;          // trailing profit
extern double trailingstep=1;            // margin allowed to the market to enable the trailing stop
extern double breakevengain=30;           // gain in pips required to enable the break even
extern double breakeven=0;               // break even

extern bool onetimecalculation=false;    // calculate entry logics one time per bar
extern double stop=0;                    // stoptake=stoploss and takeprofit
extern double trailing=0;                // trailing=trailingstart and trailingstop

extern string S5="---------------- MA Filter";

extern bool MAFilter             = true; //false;//|moving average filter
extern int  MAPeriod             = 14; //20;//|-ma filter period
extern int  MAMethod             = 1;     //0;//-ma filter method
extern int  MAPrice              = 0;   //|-ma filter price


extern string S6="---------------- BB MACD Settings";

extern bool UseBBMACDEntry       =true;//use bb macd for entry
extern bool UseBBMACDExit        =true;//-use bb macd for exit
extern bool HighRisk             =true;//first color change of bb macd dots
extern bool MediumRisk           =false;//dots cross the midband
extern bool LowRisk              =false;//-diamonds form in our direction
extern int BBMTimeFrame          =0;//-bb macd timeframe
extern int FastEMA               =12;//-bb macd fast ema
extern int SlowEMA               =26;//-bb macd slow ema
extern int SignalSMA             =10;//-bb macd signal sma
extern int ADXPeriod             =16;//-bb macd adx period
extern double StdDev             =1.0;//-bb macd standard deviation
extern bool ShowDots             =true;//-bb macd show dots

extern string S7="---------------- Time Filter";
/*
extern bool TradeOnSunday=true;//time filter on sunday
extern bool MondayToThursdayTimeFilter=false;//|-time filter the week
extern int MondayToThursdayStartHour=0;//start hour time filter the week
extern int MondayToThursdayEndHour=24;//end hour time filter the week
extern bool FridayTimeFilter=false;//time filter on friday
extern int FridayStartHour=0;//start hour time filter on friday
extern int FridayEndHour=21;//end hour time filter on friday
extern bool CloseOutSide=false;//close the trades outside the time filter
*/
extern bool TimeFilter=false; //time filter
extern int StartHour=0;
extern int EndHour=23;

string timefilter="Time Filter";

bool usetimefilter=false;
int summergmtshift=2;             // gmt offset of the broker
int wintergmtshift=1;             // gmt offset of the broker
bool mondayfilter=false;          // enable special time filter on friday
int mondayhour=12;                // start to trade after this hour
int mondayminute=0;               // minutes of the friday hour
bool weekfilter=false;            // enable time filter
int starthour=7;                  // start hour to trade after this hour
int startminute=0;                // minutes of the start hour
int endhour=21;                   // stop to trade after this hour
int endminute=0;                  // minutes of the start hour
bool tradesunday=true;            // trade on sunday
bool fridayfilter=false;          // enable special time filter on friday
int fridayhour=12;                // stop to trade after this hour
int fridayminute=0;               // minutes of the friday hour

string timeout="Time Outs and Targets";

bool usetimeout=false;            // time out, we close the order if after timeout minutes we are over target pips
int timeout1=30;                  // time out 1
int target1=7;                    // target 1
int timeout2=70;                  // time out 2
int target2=5;                    // target 2
int timeout3=95;                  // time out 3
int target3=4;                    // target 3
int timeout4=120;                 // time out 4
int target4=2;                    // target 4
int timeout5=150;                 // time out 5
int target5=-5;                   // target 5
int timeout6=180;                 // time out 6
int target6=-8;                   // target 6
int timeout7=210;                 // time out 7
int target7=-15;                  // target 7

extern string S8="---------------- Extras";

extern bool CloseAtOpposite     = true;//close trade at opposite signal
extern bool Hedge               = false;//enter an opposite trade
extern int HedgeSL              = 0;//stop loss
extern int HedgeTP              = 0;//take profit
extern bool ReverseSystem       = false;//buy instead of sell, sell instead of buy

/*
extern bool ReverseAtStop=false;//|--------------buy instead of sell, sell instead of buy
extern int Expiration=240;//|--------------------expiration in minute for the reverse pending order
extern bool Comments=true;//|--------------------allow comments on chart
*/

//+----------------------------------------------------------------------------+
//|  Internal parameters                                                       |
//|-------------------------------------------------------------------------+
datetime tstart,tend,tfriday,tmonday,lastbuyopentime,lastsellopentime,time,time2,time3,time4,time5;
int i,bc=-1,cnt,tpb,tps,tries=100,lastorder,buyorderprofit,sellorderprofit,lotsize;

int nstarthour,nendhour,nfridayhour,nmondayhour,number,ticket,gmtshift,tradetime,expire,
total,totalbuy,totalsell,totalstopbuy,totalstopsell,totallimitbuy,totallimitsell;

string istarthour,istartminute,iendhour,iendminute,ifridayhour,ifridayminute,imondayhour,imondayminute;
double cb,sl,tp,blots,slots,lastbuylot,lastselllot,lastlot,lastprofit,mlots,win[14],sum[14],totalpips,totalprofit,percentprofit,percentloss;
double lastbuyopenprice,lastsellopenprice,lastbuyprofit,lastsellprofit,tradeprofit,buyorderpips,sellorderpips,closelot;


datetime Time0;

double maxEquity,minEquity,Balance=0.0;
double LotsFactor                   = 1;
double InitialLotsFactor            = 1;
int TradePerBar                     = 0;
int BarCount                        = -1;
int digits;
double point,mt;
int SellValue,BuyValue;

//-------------------------------------------------

double NbBarsU1                     =0;
double NbBarsU2                     =0;
double BarU1                        =0;
double BarU2                        =0;
double ShiftU1                      =0;
double ShiftU2                      =0;

double NbBarsD1                     =0;
double NbBarsD2                     =0;
double BarD1                        =0;
double BarD2                        =0;
double ShiftD1                      =0;
double ShiftD2                      =0;

int Current;
bool TickCheck = False;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init() {
   BarCount = Bars;

   if (EachTickMode) Current = 0; else Current = 1;
 
     //|--------- initialization
   if(Digits==3 || Digits==5)
   {
      point=Point*10;
      mt=10;
   }else{
      point=Point;
      mt=1;
   }
      if(Digits<4)
   {
      digits=2;
   }
    else
   {
      digits=1; // to be checked out
   }

 //--------------------------------
   if(basketpercent){
      percentprofit=AccountBalance()*profit*0.01;
      percentloss=-1*AccountBalance()*loss*0.01;
   }
    if(stop>0){
      stoploss=stop;
      takeprofit=stop;
   }
   if(UseMM){
      if(minlot>=1){lotsize=100000;}
      if(minlot<1){lotsize=10000;}
      if(minlot<0.1){lotsize=1000;}
   }
   closelot=NormalizeDouble(closepercent1*0.01*lots,lotdigits);
   
   
 //--------------------------------     
   return(0);
}
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() {
   return(0);
}
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() {

   if (Volume[0] != 1)  //looks at only first tick of new (current) bar
   return(0);

   int Order = SIGNAL_NONE;
   int Total, Ticket;
   double StopLossLevel, TakeProfitLevel;



   if (EachTickMode && Bars != BarCount) TickCheck = False;
   Total = OrdersTotal();
   Order = SIGNAL_NONE;

   //+------------------------------------------------------------------+
   //| Variable Begin                                                   |
   //+------------------------------------------------------------------+

  //|--------- VQ
             
      double VQ1=iCustom(Symbol(),0,"VQ",Crash,TimeFrame,Length,Method,Smoothing,Filter,RealTime,Steady,Color,Alerts,EmailON,SignalPrice,SignalPriceBUY,SignalPriceSELL,CountBars,3,1);
      double VQ2=iCustom(Symbol(),0,"VQ",Crash,TimeFrame,Length,Method,Smoothing,Filter,RealTime,Steady,Color,Alerts,EmailON,SignalPrice,SignalPriceBUY,SignalPriceSELL,CountBars,4,1);
  
    
      double VQup0=iCustom(NULL,0,"VQforEA",Crash,TimeFrame,Length,Method,Smoothing,Filter,1,0);  //curr bar
      double VQdn0=iCustom(NULL,0,"VQforEA",Crash,TimeFrame,Length,Method,Smoothing,Filter,2,0);  //curr bar
       
      double VQup1=iCustom(NULL,0,"VQforEA",Crash,TimeFrame,Length,Method,Smoothing,Filter,1,1); //up BUFFER '1'. (for Green Line)
      double VQdn1=iCustom(NULL,0,"VQforEA",Crash,TimeFrame,Length,Method,Smoothing,Filter,2,1); //dwn BUFFER '2'. (for Red Line)

      double VQup2=iCustom(NULL,0,"VQforEA",Crash,TimeFrame,Length,Method,Smoothing,Filter,1,2); //up BUFFER '1' - for Green 1 BAR BACK.
      double VQdn2=iCustom(NULL,0,"VQforEA",Crash,TimeFrame,Length,Method,Smoothing,Filter,2,2); //dwn BUFFER '2' - for Red 1 BAR BACK.

      //   Print("RAW VQup0 ",VQup0," VQup1",VQup1," VQup2 ",VQup2," VQdn0 ",VQdn0," VQdn1 ",VQdn1," VQdn2",VQdn2);

      if(VQup1 >300)VQup1=0; //Convert214567... to usable value. //EMPTY_VALUE, most likely
      if(VQup2 >300)VQup2=0; //Convert214567... to usable value.

      if(VQdn1 >300)VQdn1=0; //Convert214567... to usable value.
      if(VQdn2 >300)VQdn2=0; //Convert214567... to usable value.

      if(VQup0 >300)VQup0=0; //Convert214567... to usable value.
      if(VQdn0 >300)VQdn0=0; //Convert214567... to usable value.

 //|---------moving average filter    
  
      double MAF=iMA(Symbol(),0,MAPeriod,0,MAMethod,MAPrice,1);
      bool MABUY=false;
      bool MASELL=false;
      if((MAFilter==false)||(MAFilter&&Bid>MAF))MABUY=true;
      if((MAFilter==false)||(MAFilter&&Ask<MAF))MASELL=true;
      
            //|---------bb macd

      bool BBMBUY=false;
      bool BBMSELL=false;
      
      double BBDotsUa=iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,0,2);
      double BBDotsDa=iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,1,2);
      double BBDotsU=iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,0,1);
      double BBDotsD=iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,1,1);
      
      double BBDiamUa=iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,5,2);
      double BBDiamDa=iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,6,2);
      double BBDiamU=iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,5,1);
      double BBDiamD=iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,6,1);
      
      double BBMmida=iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,2,2);
      double BBMmid=iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,2,1);


      if(BarU1==0&&BarU2==0)
      {
         for(int m=2;m<=50;m++)
         {
            if((BarU2!=0&&BarU2<100&&BarU1==0)||(BarU2==0&&BarU1!=0&&BarU1<100))continue;
            if(BBDotsU<100&&iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,0,m)<100)
            {BarU1=iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,0,m);ShiftU1=m;}
            if(BBDotsU<100&&iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,1,m)<100)
            {BarU2=iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,1,m);ShiftU2=m;}
         }
      }
      if(BarD1==0&&BarD2==0)
      {
         for(int n=2;n<=50;n++)
         {
            if((BarD2!=0&&BarD2<100&&BarD1==0)||(BarD2==0&&BarD1!=0&&BarD1<100))continue;
            if(BBDotsD<100&&iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,1,n)<100)
            {BarD1=iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,1,n);ShiftD2=n;}
            if(BBDotsD<100&&iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,0,n)<100)
            {BarD2=iCustom(Symbol(),0,"BB_MACD_MT4_v6",BBMTimeFrame,FastEMA,SlowEMA,SignalSMA,ADXPeriod,StdDev,ShowDots,0,n);ShiftD2=n;}
         }
      }
 
 //|-----------------  Algo bb macd       
 
      if((UseBBMACDEntry==false||(UseBBMACDEntry&&
      (HighRisk&&BBDotsU<100&&BarU2!=0&&BarU2<100)
      ||(MediumRisk&&((BBDotsDa<100&&BBDotsDa<BBMmida&&BBDotsD<100&&BBDotsD>BBMmid)||(BBDotsUa<100&&BBDotsUa<BBMmida&&BBDotsU<100&&BBDotsU>BBMmid)
      ||(BBDotsDa<100&&BBDotsDa<BBMmida&&BBDotsU<100&&BBDotsU>BBMmid)||(BBDotsUa<100&&BBDotsUa<BBMmida&&BBDotsD<100&&BBDotsD>BBMmid)
      ||(BBDiamUa<100&&BBDiamUa<BBMmida&&BBDotsD<100&&BBDotsD>BBMmid)||(BBDiamDa<100&&BBDiamDa<BBMmida&&BBDotsD<100&&BBDotsD>BBMmid)))
      ||(LowRisk&&BBDiamU<100)))
      ){BBMBUY=true;BarU1=0;BarD1=0;BarU2=0;BarD2=0;ShiftU1=0;ShiftD1=0;ShiftU2=0;ShiftD2=0;}
      
      if((UseBBMACDEntry==false||(UseBBMACDEntry&&
      (HighRisk&&BBDotsD<100&&BarD2!=0&&BarD2<100)
      ||(MediumRisk&&((BBDotsDa<100&&BBDotsDa>BBMmida&&BBDotsD<100&&BBDotsD<BBMmid)||(BBDotsUa<100&&BBDotsUa>BBMmida&&BBDotsU<100&&BBDotsU<BBMmid)
      ||(BBDotsDa<100&&BBDotsDa>BBMmida&&BBDotsU<100&&BBDotsU<BBMmid)||(BBDotsUa<100&&BBDotsUa>BBMmida&&BBDotsD<100&&BBDotsD<BBMmid)
      ||(BBDiamUa<100&&BBDiamUa>BBMmida&&BBDotsD<100&&BBDotsD<BBMmid)||(BBDiamDa<100&&BBDiamDa>BBMmida&&BBDotsD<100&&BBDotsD<BBMmid)))
      ||(LowRisk&&BBDiamD<100)))
      ){BBMSELL=true;BarU1=0;BarD1=0;BarU2=0;BarD2=0;ShiftU1=0;ShiftD1=0;ShiftU2=0;ShiftD2=0;}
      
      if(BBMBUY==false&&BBMSELL==false){BarU1=0;BarD1=0;BarU2=0;BarD2=0;ShiftU1=0;ShiftD1=0;ShiftU2=0;ShiftD2=0;}
    
//|-----------------  inf bb macd     
      
      bool BUY=false;
      bool SELL=false;
      bool SignalBUY=false;
      bool SignalSELL=false;
      bool CloseBUY=false;
      bool CloseSELL=false;

      if(VQ1>0&&VQ1!=EMPTY_VALUE)
         {
         BUY=true;
         // Confirmation
         if (BBMBUY==true) 
            {
            SignalBUY=true;
            }
         CloseSELL=true;
         }
         
      if(VQ2>0&&VQ2!=EMPTY_VALUE)
         {
         SELL=true;
         SignalSELL=true;
         CloseBUY=true;
         }
         
       if ( VQdn1>0 && VQdn2 ==0 && VQup1 ==0 && VQup0 == 0)
         {
         //Print("SELL  VQup0 ",VQup0," VQup1 ",VQup1," VQup2 ",VQup2," VQdn0 ",VQdn0," VQdn1 ",VQdn1," VQdn2 ",VQdn2);
         SellValue=1;
         }

      if (VQup1 >0 && VQup2 ==0 && VQdn1 ==0 && VQdn0 == 0)
         {
         //Print("BUY   VQup0 ",VQup0," VQup1 ",VQup1," VQup2 ",VQup2," VQdn0 ",VQdn0," VQdn1 ",VQdn1," VQdn2 ",VQdn2);
         BuyValue=1;
         }        
// ---------------------  ALgo final 
    
//  if(BUY ||(TradePerBar<=MaxTradePerBar)&&MABUY &&BBMBUY )
//      { 
//         if(ReverseSystem)
//               SignalSELL=true;
//         else  
//               {
//               SignalBUY=true;
//               CloseSELL=true;
//               }
//       }
       
//  if(SELL||(TradePerBar<=MaxTradePerBar)&&MASELL&&BBMSELL)
//      {
//          if(ReverseSystem)
//               SignalBUY=true;
//           else 
//               {
//               SignalSELL=true;
//                CloseBUY=true;
//               }   
//      }           
 //|---------risk management

   if(RiskMM)  CalculateMM();

//|---------close orders

//   if(CloseAtOpposite&&Hedge==false&&SELL)
//  {
//      if(ReverseSystem)CloseSellOrders(MagicNumber);else CloseBuyOrders(MagicNumber);
//   }
//   if(CloseAtOpposite&&Hedge==false&&BUY)
//   {
//      if(ReverseSystem)CloseBuyOrders(MagicNumber);else CloseSellOrders(MagicNumber);
//   }

//|---------hidden sl-tp

//   if(Hedge==false&&HideSL&&StopLoss>0)
//   {
//      CloseBuyOrdersHiddenSL(MagicNumber);CloseSellOrdersHiddenSL(MagicNumber);
//   }
//   if(Hedge==false&&HideTP&&TakeProfit>0)
//   {
//      CloseBuyOrdersHiddenTP(MagicNumber);CloseSellOrdersHiddenTP(MagicNumber);
//   }

//|---------time filter

   string TIFI="false";if(TimeFilter){if(!(Hour()>=StartHour && Hour()<=EndHour)){TIFI="true";}}
/*   if((TradeOnSunday==false&&DayOfWeek()==0)||(MondayToThursdayTimeFilter&&DayOfWeek()>=1&&DayOfWeek()<=4&&!(Hour()>=MondayToThursdayStartHour
   &&Hour()<MondayToThursdayEndHour))||(FridayTimeFilter&&DayOfWeek()==5&&!(Hour()>=FridayStartHour&&Hour()<FridayEndHour)))
   {
      if(CloseOutSide){CloseBuyOrders(MagicNumber);CloseSellOrders(MagicNumber);}
      return(0);
   }
*/
            
   //+------------------------------------------------------------------+
   //| Variable End                                                     |
   //+------------------------------------------------------------------+

   //Check position
   bool IsTrade = False;

   for (int i = 0; i < Total; i ++) {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderType() <= OP_SELL &&  OrderSymbol() == Symbol()) {
         IsTrade = True;
         if(OrderType() == OP_BUY) {
            //Close

            //+------------------------------------------------------------------+
            //| Signal Begin(Exit Buy)                                           |
            //+------------------------------------------------------------------+

            if (CloseBUY==true) 
                  Order= SIGNAL_CLOSEBUY;
                  

            //+------------------------------------------------------------------+
            //| Signal End(Exit Buy)                                             |
            //+------------------------------------------------------------------+

            if (Order == SIGNAL_CLOSEBUY && ((EachTickMode && !TickCheck) || (!EachTickMode && (Bars != BarCount)))) {
   
                RefreshRates();
               ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),slippage*mt); // Slippage ??
                             
               if (SignalMail) SendMail("[Signal Alert]", "[" + Symbol() + "] " + DoubleToStr(Bid, Digits) + " Close Buy");
               if (!EachTickMode) BarCount = Bars;
               IsTrade = False;
               continue;
            }
            //Trailing stop
            if(UseTrailingStop && TrailingStop > 0) {                 
               if(Bid - OrderOpenPrice() > Point * TrailingStop) {
                  if(OrderStopLoss() < Bid - Point * TrailingStop) {
                     OrderModify(OrderTicket(), OrderOpenPrice(), Bid - Point * TrailingStop, OrderTakeProfit(), 0, MediumSeaGreen);
                     if (!EachTickMode) BarCount = Bars;
                     continue;
                  }
               }
            }
         } 
         else   // to check if else necessary 
         
         {
         
            //Close

            //+------------------------------------------------------------------+
            //| Signal Begin(Exit Sell)                                          |
            //+------------------------------------------------------------------+
            if (CloseSELL == true) 
                  Order= SIGNAL_SELL;

            //+------------------------------------------------------------------+
            //| Signal End(Exit Sell)                                            |
            //+------------------------------------------------------------------+

            if (Order == SIGNAL_CLOSESELL && ((EachTickMode && !TickCheck) || (!EachTickMode && (Bars != BarCount)))) {
            
               RefreshRates();
               ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),slippage*mt); // just Slippage instead

                              
               if (SignalMail) SendMail("[Signal Alert]", "[" + Symbol() + "] " + DoubleToStr(Ask, Digits) + " Close Sell");
               if (!EachTickMode) BarCount = Bars;
               IsTrade = False;
               continue;
            }
            //Trailing stop
            if(UseTrailingStop && TrailingStop > 0) {                 
               if((OrderOpenPrice() - Ask) > (Point * TrailingStop)) {
                  if((OrderStopLoss() > (Ask + Point * TrailingStop)) || (OrderStopLoss() == 0)) {
                     OrderModify(OrderTicket(), OrderOpenPrice(), Ask + Point * TrailingStop, OrderTakeProfit(), 0, DarkOrange);
                     if (!EachTickMode) BarCount = Bars;
                     continue;
                  }
               }
            }
         }
      }
   }

   //+------------------------------------------------------------------+
   //| Signal Begin(Entry)                                              |
   //+------------------------------------------------------------------+

            if (SignalBUY==true) 
                  Order= SIGNAL_BUY;
                  
            if (SignalSELL==true) 
                  Order= SIGNAL_SELL;

   //+------------------------------------------------------------------+
   //| Signal End                                                       |
   //+------------------------------------------------------------------+

  if(UseMM)
      {
      double Lot=NormalizeDouble(AccountFreeMargin()*MaximumRisk/1000.0,digits);
         if (Lot>9) Lot=9;
      }  
     else Lot=Lots;     
  
   //+------------------------------------------------------------------+
   //| Signal End                                                       |
   //+------------------------------------------------------------------+ 
   
   //Buy
   if (Order == SIGNAL_BUY && ((EachTickMode && !TickCheck) || (!EachTickMode && (Bars != BarCount)))) {
      if(!IsTrade) {
         //Check free margin
         if (AccountFreeMargin() < (1000 * Lots)) {
            Print("We have no money. Free Margin = ", AccountFreeMargin());
            return(0);
         }

         RefreshRates();
         if (UseStopLoss) StopLossLevel = Ask - StopLoss * Point; else StopLossLevel = 0.0;
         if (UseTakeProfit) TakeProfitLevel = Ask + TakeProfit * Point; else TakeProfitLevel = 0.0;

         Ticket = OrderSend(Symbol(), OP_BUY, Lot, Ask, Slippage, StopLossLevel, TakeProfitLevel, "Buy(#" + MagicNumber + ")", MagicNumber, 0, DodgerBlue);
         if(Ticket > 0) {
            if (OrderSelect(Ticket, SELECT_BY_TICKET, MODE_TRADES)) {
				Print("BUY order opened : ", OrderOpenPrice());
                if (SignalMail) SendMail("[Signal Alert]", "[" + Symbol() + "] " + DoubleToStr(Ask, Digits) + " Open Buy");
			} else {
				Print("Error opening BUY order : ", GetLastError());
			}
         }
         if (EachTickMode) TickCheck = True;
         if (!EachTickMode) BarCount = Bars;
         return(0);
      }
   }

   //Sell
   if (Order == SIGNAL_SELL && ((EachTickMode && !TickCheck) || (!EachTickMode && (Bars != BarCount)))) {
      if(!IsTrade) {
         //Check free margin
         if (AccountFreeMargin() < (1000 * Lots)) {
            Print("We have no money. Free Margin = ", AccountFreeMargin());
            return(0);
         }
         RefreshRates();
         if (UseStopLoss) StopLossLevel = Bid + StopLoss * Point; else StopLossLevel = 0.0;
         if (UseTakeProfit) TakeProfitLevel = Bid - TakeProfit * Point; else TakeProfitLevel = 0.0;

         Ticket = OrderSend(Symbol(), OP_SELL, Lot, Bid, Slippage, StopLossLevel, TakeProfitLevel, "Sell(#" + MagicNumber + ")", MagicNumber, 0, DeepPink);
         if(Ticket > 0) {
            if (OrderSelect(Ticket, SELECT_BY_TICKET, MODE_TRADES)) {
				Print("SELL order opened : ", OrderOpenPrice());
                if (SignalMail) SendMail("[Signal Alert]", "[" + Symbol() + "] " + DoubleToStr(Bid, Digits) + " Open Sell");
			} else {
				Print("Error opening SELL order : ", GetLastError());
			}
         }
         if (EachTickMode) TickCheck = True;
         if (!EachTickMode) BarCount = Bars;
         return(0);
      }
   }

   if (!EachTickMode) BarCount = Bars;

   return(0);
}

//+------------------------------------------------------------------+
//+----------------------------------------------------------------------------+
//|  Open orders function                                                      |
//+----------------------------------------------------------------------------+

int open(int type,double lots,double price,double stoploss,double takeprofit,int expire,color clr){
   int ticket=0;
   if(lots<minlot)lots=minlot;
   if(lots>maxlot)lots=maxlot;
   if(type==OP_BUY || type==OP_BUYSTOP || type==OP_BUYLIMIT){
      if(hidesl==false && stoploss>0){sl=price-stoploss*point;}else{sl=0;}
      if(hidetp==false && takeprofit>0){tp=price+takeprofit*point;}else{tp=0;}
   }
   if(type==OP_SELL || type==OP_SELLSTOP || type==OP_SELLLIMIT){
      if(hidesl==false && stoploss>0){sl=price+stoploss*point;}else{sl=0;}
      if(hidetp==false && takeprofit>0){tp=price-takeprofit*point;}else{tp=0;}
   }
   ticket=OrderSend(Symbol(),type,NormalizeDouble(lots,lotdigits),NormalizeDouble(price,Digits),slippage*mt,sl,tp,
   comment+" "+DoubleToStr(MagicNumber,0),MagicNumber,expire,clr);
   return(ticket);
}

//+----------------------------------------------------------------------------+
//|  Lots optimized functions                                                  |
//+----------------------------------------------------------------------------+

double lotsoptimized(){
   double lot;
   if(stoploss>0)lot=AccountBalance()*(risk/100)/(stoploss*point/MarketInfo(Symbol(),MODE_TICKSIZE)*MarketInfo(Symbol(),MODE_TICKVALUE));
   else lot=NormalizeDouble((AccountBalance()/lotsize)*minlot*risk,lotdigits);
   //lot=AccountFreeMargin()/(100.0*(NormalizeDouble(MarketInfo(Symbol(),MODE_MARGINREQUIRED),4)+5.0)/risk)-0.05;
   return(lot);
}

//+----------------------------------------------------------------------------+
//|  Time filter functions                                                     |
//+----------------------------------------------------------------------------+

bool checktime(){
   if(TimeCurrent()<win[TimeYear(TimeCurrent())-1999] && TimeCurrent()>sum[TimeYear(TimeCurrent())-1999])gmtshift=summergmtshift;
   else gmtshift=wintergmtshift;

   string svrdate=Year()+"."+Month()+"."+Day();

   if(mondayfilter){
      nmondayhour=mondayhour+(gmtshift);if(nmondayhour>23)nmondayhour=nmondayhour-24;
      if(nmondayhour<10)imondayhour="0"+nmondayhour;
      if(nmondayhour>9)imondayhour=nmondayhour;
      if(mondayminute<10)imondayminute="0"+mondayminute;
      if(mondayminute>9)imondayminute=mondayminute;
      tmonday=StrToTime(svrdate+" "+imondayhour+":"+imondayminute);
   }
   if(weekfilter){
      nstarthour=starthour+(gmtshift);if(nstarthour>23)nstarthour=nstarthour-24;
      if(nstarthour<10)istarthour="0"+nstarthour;
      if(nstarthour>9)istarthour=nstarthour;
      if(startminute<10)istartminute="0"+startminute;
      if(startminute>9)istartminute=startminute;
      tstart=StrToTime(svrdate+" "+istarthour+":"+istartminute);

      nendhour=endhour+(gmtshift);if(nendhour>23)nendhour=nendhour-24;
      if(endhour<10)iendhour="0"+nendhour;
      if(endhour>9)iendhour=nendhour;
      if(endminute<10)iendminute="0"+endminute;
      if(endminute>9)iendminute=endminute;
      tend=StrToTime(svrdate+" "+iendhour+":"+iendminute);
   }
   if(fridayfilter){
      nfridayhour=fridayhour+(gmtshift);if(nfridayhour>23)nfridayhour=nfridayhour-24;
      if(nfridayhour<10)ifridayhour="0"+nfridayhour;
      if(nfridayhour>9)ifridayhour=nfridayhour;
      if(fridayminute<10)ifridayminute="0"+fridayminute;
      if(fridayminute>9)ifridayminute=fridayminute;
      tfriday=StrToTime(svrdate+" "+ifridayhour+":"+ifridayminute);
   }
   if(weekfilter && (nstarthour<=nendhour && TimeCurrent()<tstart || TimeCurrent()>tend) || (nstarthour>nendhour && TimeCurrent()<tstart && TimeCurrent()>tend))return(true);
   if(tradesunday==false && DayOfWeek()==0)return(true);
   if(fridayfilter && DayOfWeek()==5 && TimeCurrent()>tfriday)return(true);
   if(mondayfilter && DayOfWeek()==1 && TimeCurrent()<tmonday)return(true);
   return(false);
}

//+----------------------------------------------------------------------------+
//|  Counter                                                                   |
//+----------------------------------------------------------------------------+

int count(int type){
   cnt=0;
   if(OrdersTotal()>0){
      for(i=OrdersTotal();i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==Symbol() && OrderType()==type && OrderMagicNumber()==MagicNumber)cnt++;
      }
      return(cnt);
   }
}

//+----------------------------------------------------------------------------+
//|  Close functions                                                           |
//+----------------------------------------------------------------------------+

void close(int type){
   if(OrdersTotal()>0){
      for(i=OrdersTotal()-1;i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(type==OP_BUY && OrderType()==OP_BUY){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){
               RefreshRates();
               OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),slippage*mt);
            }
         }
         if(type==OP_SELL && OrderType()==OP_SELL){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){
               RefreshRates();
               OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),slippage*mt);
            }
         }
         if(type==3){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){
               RefreshRates();
               OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),slippage*mt);
            }
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){
               RefreshRates();
               OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),slippage*mt);
            }
         }
      }
   }
}

void hideclose(int type){
   if(OrdersTotal()>0){
      for(i=OrdersTotal()-1;i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(type==OP_BUY && OrderType()==OP_BUY){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber
            && (hidesl && stoploss>0 && OrderProfit()<=(-1)*stoploss*OrderLots()*10-MarketInfo(Symbol(),MODE_SPREAD)*OrderLots()*10/mt)
            || (hidetp && takeprofit>0 && OrderProfit()>=takeprofit*OrderLots()*10)){
               RefreshRates();
               OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),slippage*mt);
            }
         }
         if(type==OP_SELL && OrderType()==OP_SELL){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber
            && (hidesl && stoploss>0 && OrderProfit()<=(-1)*stoploss*OrderLots()*10-MarketInfo(Symbol(),MODE_SPREAD)*OrderLots()*10/mt)
            || (hidetp && takeprofit>0 && OrderProfit()>=takeprofit*OrderLots()*10)){
               RefreshRates();
               OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),slippage*mt);
            }
         }
      }
   }
}

void closetime(int type){
   tradeprofit=0;
   tradetime=0;
   if(OrdersTotal()>0){
      for(i=OrdersTotal();i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(type==OP_BUY && OrderType()==OP_BUY){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){ 
               tradeprofit=NormalizeDouble(OrderClosePrice()-OrderOpenPrice(),Digits);
               tradetime=TimeCurrent()-OrderOpenTime();
               if((tradeprofit>=target1*point &&  tradetime>timeout1*60 && tradetime<timeout2*60)
               || (tradeprofit>=target2*point &&  tradetime>timeout2*60 && tradetime<timeout3*60)
               || (tradeprofit>=target3*point &&  tradetime>timeout3*60 && tradetime<timeout4*60)
               || (tradeprofit>=target4*point &&  tradetime>timeout4*60 && tradetime<timeout5*60)
               || (tradeprofit>=target5*point &&  tradetime>timeout5*60 && tradetime<timeout6*60)
               || (tradeprofit>=target6*point &&  tradetime>timeout6*60 && tradetime<timeout7*60)
               || (tradeprofit>=target7*point &&  tradetime>timeout7*60)){
                  RefreshRates();
                  OrderClose(OrderTicket(),OrderLots(),Bid,slippage*mt);
               }
            }
         }
         if(type==OP_SELL && OrderType()==OP_SELL){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){ 
               tradeprofit=NormalizeDouble(OrderClosePrice()-OrderOpenPrice(),Digits);
               tradetime=TimeCurrent()-OrderOpenTime();
               if((tradeprofit>=target1*point &&  tradetime>timeout1*60 && tradetime<timeout2*60)
               || (tradeprofit>=target2*point &&  tradetime>timeout2*60 && tradetime<timeout3*60)
               || (tradeprofit>=target3*point &&  tradetime>timeout3*60 && tradetime<timeout4*60)
               || (tradeprofit>=target4*point &&  tradetime>timeout4*60 && tradetime<timeout5*60)
               || (tradeprofit>=target5*point &&  tradetime>timeout5*60 && tradetime<timeout6*60)
               || (tradeprofit>=target6*point &&  tradetime>timeout6*60 && tradetime<timeout7*60)
               || (tradeprofit>=target7*point &&  tradetime>timeout7*60)){
                  RefreshRates();
                  OrderClose(OrderTicket(),OrderLots(),Ask,slippage*mt);
               }
            }
         }
      }
   }
}

void delete(int type){
   if(OrdersTotal()>0){
      for(i=OrdersTotal();i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(type!=6){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==type){
               OrderDelete(OrderTicket());
            }
         }
         if(type==6){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP
            || OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT){
               OrderDelete(OrderTicket());
            }
         }   
      }
   }
}

//+----------------------------------------------------------------------------+
//|  Modifications functions                                                   |
//+----------------------------------------------------------------------------+

void movebreakeven(double breakevengain,double breakeven){
   RefreshRates();
   if(OrdersTotal()>0){
      for(i=OrdersTotal();i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){
            if(OrderType()==OP_BUY){
               if(NormalizeDouble((Bid-OrderOpenPrice()),Digits)>=NormalizeDouble(breakevengain*point,Digits)){
                  if((NormalizeDouble((OrderStopLoss()-OrderOpenPrice()),Digits)<NormalizeDouble(breakeven*point,Digits)) || OrderStopLoss()==0){
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+breakeven*point,Digits),OrderTakeProfit(),0,Blue);
                     return(0);
                  }
               }
            }
            else{
               if(NormalizeDouble((OrderOpenPrice()-Ask),Digits)>=NormalizeDouble(breakevengain*point,Digits)){
                  if((NormalizeDouble((OrderOpenPrice()-OrderStopLoss()),Digits)<NormalizeDouble(breakeven*point,Digits)) || OrderStopLoss()==0){
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-breakeven*point,Digits),OrderTakeProfit(),0,Red);
                     return(0);
                  }
               }
            }
         }
      }
   }
}

void movetrailingstop(double trailingstart,double trailingstop){
   RefreshRates();
   if(OrdersTotal()>0){
      for(i=OrdersTotal();i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){
            if(OrderType()==OP_BUY){
               if(NormalizeDouble(Ask,Digits)>NormalizeDouble(OrderOpenPrice()+trailingstart*point,Digits)
               && NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(Bid-(trailingstop+trailingstep)*point,Digits)){
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid-trailingstop*point,Digits),OrderTakeProfit(),0,Blue);
                  return(0);
               }
            }
            else{
               if(NormalizeDouble(Bid,Digits)<NormalizeDouble(OrderOpenPrice()-trailingstart*point,Digits)
               && (NormalizeDouble(OrderStopLoss(),Digits)>(NormalizeDouble(Ask+(trailingstop+trailingstep)*point,Digits))) || (OrderStopLoss()==0)){                 
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask+trailingstop*point,Digits),OrderTakeProfit(),0,Red);
                  return(0);
               }
            }
         }
      }
   }
}

void movetrailingprofit(double trailingstart,double trailingprofit){
   RefreshRates();
   for(i=OrdersTotal();i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
         if(OrderSymbol()==Symbol()&& OrderMagicNumber()==MagicNumber){
            if(OrderType()==OP_BUY){
               if(NormalizeDouble(Bid-OrderOpenPrice(),Digits)<=NormalizeDouble((-1)*trailingstart*point,Digits)){
                  if(NormalizeDouble(OrderTakeProfit(),Digits)>NormalizeDouble(Bid+(trailingprofit+trailingstep)*point,Digits)
                  || NormalizeDouble(OrderTakeProfit(),Digits)==0){
                     OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(Bid+trailingprofit*point,Digits),0,Blue);
                  }
               }
            }
            if(OrderType()==OP_SELL){
               if(NormalizeDouble(OrderOpenPrice()-Ask,Digits)<=NormalizeDouble((-1)*trailingstart*point,Digits)){
                  if(NormalizeDouble(OrderTakeProfit(),Digits)<NormalizeDouble(Ask-(trailingprofit+trailingstep)*point,Digits)){
                     OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(Ask-trailingprofit*point,Digits),0,Red);
                  }
               }
            }
         }
      }
   }
}

void ecnmodify(double stoploss,double takeprofit){
   for(i=OrdersTotal();i>=0;i--){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){
         if(OrderType()==OP_BUY){
            if(OrderStopLoss()==0){
               RefreshRates();
               OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask-stoploss*point,Digits),OrderTakeProfit(),0,Red);
            }
            if(OrderTakeProfit()==0){
               RefreshRates();
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(Ask+takeprofit*point,Digits),0,Red);
            }
         }
         if(OrderType()==OP_SELL){
            if(OrderStopLoss()==0){
               RefreshRates();
               OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid+stoploss*point,Digits),OrderTakeProfit(),0,Red);
            }
            if(OrderTakeProfit()==0){
               RefreshRates();
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(Bid-takeprofit*point,Digits),0,Red);
            }
         }
      }
   }
}
//|---------close buy orders

int CloseBuyOrders(int Magic)
{
  int total=OrdersTotal();

  for (int cnt=total-1;cnt>=0;cnt--)
  {
    OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
    if(OrderMagicNumber()==MagicNumber&&OrderSymbol()==Symbol())
    {
      if(OrderType()==OP_BUY)
      {
        OrderClose(OrderTicket(),OrderLots(),Bid,3);
      }
    }
  }
  return(0);
}

int CloseBuyOrdersHiddenTP(int Magic)
{
  int total=OrdersTotal();

  for (int cnt=total-1;cnt>=0;cnt--)
  {
    OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
    if(OrderMagicNumber()==MagicNumber&&OrderSymbol()==Symbol())
    {
      if(OrderType()==OP_BUY&&Bid>(OrderOpenPrice()+TakeProfit*point))
      {
        OrderClose(OrderTicket(),OrderLots(),Bid,3);
      }
    }
  }
  return(0);
}

int CloseBuyOrdersHiddenSL(int Magic)
{
  int total=OrdersTotal();

  for (int cnt=total-1;cnt>=0;cnt--)
  {
    OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
    if(OrderMagicNumber()==MagicNumber&&OrderSymbol()==Symbol())
    {
      if(OrderType()==OP_BUY&&Bid<(OrderOpenPrice()-StopLoss*point))
      {
        OrderClose(OrderTicket(),OrderLots(),Bid,3);
      }
    }
  }
  return(0);
}

//|---------close sell orders

int CloseSellOrders(int Magic)
{
  int total=OrdersTotal();

  for(int cnt=total-1;cnt>=0;cnt--)
  {
    OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
    if(OrderMagicNumber()==MagicNumber&&OrderSymbol()==Symbol())
    {
      if(OrderType()==OP_SELL)
      {
        OrderClose(OrderTicket(),OrderLots(),Ask,3);
      }
    }
  }
  return(0);
}

int CloseSellOrdersHiddenTP(int Magic)
{
  int total=OrdersTotal();

  for(int cnt=total-1;cnt>=0;cnt--)
  {
    OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
    if(OrderMagicNumber()==MagicNumber&&OrderSymbol()==Symbol())
    {
      if(OrderType()==OP_SELL&&Ask<(OrderOpenPrice()-TakeProfit*point))
      {
        OrderClose(OrderTicket(),OrderLots(),Ask,3);
      }
    }
  }
  return(0);
}

int CloseSellOrdersHiddenSL(int Magic)
{
  int total=OrdersTotal();

  for(int cnt=total-1;cnt>=0;cnt--)
  {
    OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
    if(OrderMagicNumber()==MagicNumber&&OrderSymbol()==Symbol())
    {
      if(OrderType()==OP_SELL&&Ask>(OrderOpenPrice()+StopLoss*point))
      {
        OrderClose(OrderTicket(),OrderLots(),Ask,3);
      }
    }
  }
  return(0);
}
//|---------count orders

int CountOrders(int Type,int Magic)
{
   int _CountOrd;
   _CountOrd=0;
   for(int i=0;i<OrdersTotal();i++)
   {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol())
      {
         if((OrderType()==Type&&(OrderMagicNumber()==MagicNumber)||MagicNumber==0))_CountOrd++;
      }
   }
   return(_CountOrd);
}

//|---------trailing stop

void MoveTrailingStop()
{
   int cnt,total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol()&&OrderMagicNumber()==MagicNumber)
      {
         if(OrderType()==OP_BUY)
         {
            if(TrailingStop>0&&NormalizeDouble(Ask-TrailingStep*point,digits)>NormalizeDouble(OrderOpenPrice()+TrailingProfit*point,digits))  
            {                 
               if((NormalizeDouble(OrderStopLoss(),digits)<NormalizeDouble(Bid-TrailingStop*point,digits))||(OrderStopLoss()==0))
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid-TrailingStop*point,digits),OrderTakeProfit(),0,Blue);
                  return(0);
               }
            }
         }
         else 
         {
            if(TrailingStop>0&&NormalizeDouble(Bid+TrailingStep*point,digits)<NormalizeDouble(OrderOpenPrice()-TrailingProfit*point,digits))  
            {                 
               if((NormalizeDouble(OrderStopLoss(),digits)>(NormalizeDouble(Ask+TrailingStop*point,digits)))||(OrderStopLoss()==0))
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask+TrailingStop*point,digits),OrderTakeProfit(),0,Red);
                  return(0);
               }
            }
         }
      }
   }
}

//|---------break even

void MoveBreakEven()
{
   int cnt,total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol()&&OrderMagicNumber()==MagicNumber)
      {
         if(OrderType()==OP_BUY)
         {
            if(BreakEven>0)
            {
               if(NormalizeDouble((Bid-OrderOpenPrice()),digits)>BreakEven*point)
               {
                  if(NormalizeDouble((OrderStopLoss()-OrderOpenPrice()),digits)<0)
                  {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+0*point,digits),OrderTakeProfit(),0,Blue);
                     return(0);
                  }
               }
            }
         }
         else
         {
            if(BreakEven>0)
            {
               if(NormalizeDouble((OrderOpenPrice()-Ask),digits)>BreakEven*point)
               {
                  if(NormalizeDouble((OrderOpenPrice()-OrderStopLoss()),digits)<0)
                  {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-0*point,digits),OrderTakeProfit(),0,Red);
                     return(0);
                  }
               }
            }
         }
      }
   }
}

//|---------calculate money management

void CalculateMM()
{
   double MinLots=MarketInfo(Symbol(),MODE_MINLOT);
   double MaxLots=MarketInfo(Symbol(),MODE_MAXLOT);
   Lots=AccountFreeMargin()/100000*RiskPercent;
   Lots=MathMin(MaxLots,MathMax(MinLots,Lots));
   if(MinLots<0.1)Lots=NormalizeDouble(Lots,2);
   else
   {
     if(MinLots<1)Lots=NormalizeDouble(Lots,1);
     else Lots=NormalizeDouble(Lots,0);
   }
   if(Lots<MinLots)Lots=MinLots;
   if(Lots>MaxLots)Lots=MaxLots;
   return(0);
}
//|---------martingale

int MartingaleFactor()
{
   int histotal=OrdersHistoryTotal();
   if (histotal>0)
   {
      for(int cnt=histotal-1;cnt>=0;cnt--)
      {
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_HISTORY))
         {
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
            {
               if(OrderProfit()<0)
               {
                  LotsFactor=LotsFactor*Multiplier;
                  return(LotsFactor);
               }
               else
               {
                  LotsFactor=InitialLotsFactor;
                  if(LotsFactor<=0)
                  {
                     LotsFactor=1;
                  }
                  return(LotsFactor);
               }
            }
         }
      }
   }
   return(LotsFactor);
}

//+----------------------------------------------------------------------------+
//|  CALCULATE SAR Trend                                                       |
//+----------------------------------------------------------------------------+
int SAR()
   {  
int SARTrend;
   //SAR
   double SARSignal = iSAR(Symbol(),0,SARStep,SARMax,0);
   
      if (SARSignal<Close[1])  //1 = buy, 2 = sell
         {
         SARTrend = 1;
         } 
      else  
         {
         SARTrend = 2;
         }
    
     return (SARTrend); 
   }     

//+----------------------------------------------------------------------------+
//|  CALCULATE TP/SL w/ ATR                                                         |
//+----------------------------------------------------------------------------+

int calculate_tpsl_atr(int TYPE_ORDER)
{

double   ATR = iATR(Symbol(), 0, ATR_PERIOD, 0);
double   STD=  iStdDev(Symbol(), 0, nPeriod, 0, maMethodBand, appliedPrice, 0);
double   SL,TP, LOT;
   
if (TYPE_ORDER == SIGNAL_BUY)
   {
   TP = NormalizeDouble((Ask+(ATR* TakeProfit_ATR))*point,Digits);
   //TP  = NormalizeDouble( Ask+(ATR*ATR_Multiple+ 2*Point*MyPoint),Digits);

   //SL  = NormalizeDouble(Ask-(ATR*ATR_Multiple- 2*Point*MyPoint),Digits);   
   SL = NormalizeDouble( Ask-(ATR+3*STD),Digits);
   }

if (TYPE_ORDER == SIGNAL_SELL)
   { 
   TP = NormalizeDouble((Bid-(ATR * TakeProfit_ATR))*point,Digits);  
   //TP = NormalizeDouble(Bid-(ATR*ATR_Multiple- 2*Point*MyPoint),Digits);

   // SL = NormalizeDouble(Bid+(ATR*ATR_Multiple+ 2*Point*MyPoint),Digits);            
   SL = NormalizeDouble( Bid+(ATR+3*STD),Digits);
  
   }
}                      
                       
   
   
   

//+----------------------------------------------------------------------------+
//|  Error functions                                                           |
//+----------------------------------------------------------------------------+

string errordescription(int code){
   string error;
   switch(code){
      case 0:
      case 1:error="no error";break;
      case 2:error="common error";break;
      case 3:error="invalid trade parameters";break;
      case 4:error="trade server is busy";break;
      case 5:error="old version of the client terminal";break;
      case 6:error="no connection with trade server";break;
      case 7:error="not enough rights";break;
      case 8:error="too frequent requests";break;
      case 9:error="malfunctional trade operation";break;
      case 64:error="account disabled";break;
      case 65:error="invalid account";break;
      case 128:error="trade timeout";break;
      case 129:error="invalid price";break;
      case 130:error="invalid stops";break;
      case 131:error="invalid trade volume";break;
      case 132:error="market is closed";break;
      case 133:error="trade is disabled";break;
      case 134:error="not enough money";break;
      case 135:error="price changed";break;
      case 136:error="off quotes";break;
      case 137:error="broker is busy";break;
      case 138:error="requote";break;
      case 139:error="order is locked";break;
      case 140:error="long positions only allowed";break;
      case 141:error="too many requests";break;
      case 145:error="modification denied because order too close to market";break;
      case 146:error="trade context is busy";break;
      case 4000:error="no error";break;
      case 4001:error="wrong function pointer";break;
      case 4002:error="array index is out of range";break;
      case 4003:error="no memory for function call stack";break;
      case 4004:error="recursive stack overflow";break;
      case 4005:error="not enough stack for parameter";break;
      case 4006:error="no memory for parameter string";break;
      case 4007:error="no memory for temp string";break;
      case 4008:error="not initialized string";break;
      case 4009:error="not initialized string in array";break;
      case 4010:error="no memory for array\' string";break;
      case 4011:error="too long string";break;
      case 4012:error="remainder from zero divide";break;
      case 4013:error="zero divide";break;
      case 4014:error="unknown command";break;
      case 4015:error="wrong jump (never generated error)";break;
      case 4016:error="not initialized array";break;
      case 4017:error="dll calls are not allowed";break;
      case 4018:error="cannot load library";break;
      case 4019:error="cannot call function";break;
      case 4020:error="expert function calls are not allowed";break;
      case 4021:error="not enough memory for temp string returned from function";break;
      case 4022:error="system is busy (never generated error)";break;
      case 4050:error="invalid function parameters count";break;
      case 4051:error="invalid function parameter value";break;
      case 4052:error="string function internal error";break;
      case 4053:error="some array error";break;
      case 4054:error="incorrect series array using";break;
      case 4055:error="custom indicator error";break;
      case 4056:error="arrays are incompatible";break;
      case 4057:error="global variables processing error";break;
      case 4058:error="global variable not found";break;
      case 4059:error="function is not allowed in testing mode";break;
      case 4060:error="function is not confirmed";break;
      case 4061:error="send mail error";break;
      case 4062:error="string parameter expected";break;
      case 4063:error="integer parameter expected";break;
      case 4064:error="double parameter expected";break;
      case 4065:error="array as parameter expected";break;
      case 4066:error="requested history data in update state";break;
      case 4099:error="end of file";break;
      case 4100:error="some file error";break;
      case 4101:error="wrong file name";break;
      case 4102:error="too many opened files";break;
      case 4103:error="cannot open file";break;
      case 4104:error="incompatible access to a file";break;
      case 4105:error="no order selected";break;
      case 4106:error="unknown symbol";break;
      case 4107:error="invalid price parameter for trade function";break;
      case 4108:error="invalid ticket";break;
      case 4109:error="trade is not allowed";break;
      case 4110:error="longs are not allowed";break;
      case 4111:error="shorts are not allowed";break;
      case 4200:error="object is already exist";break;
      case 4201:error="unknown object property";break;
      case 4202:error="object is not exist";break;
      case 4203:error="unknown object type";break;
      case 4204:error="no object name";break;
      case 4205:error="object coordinates error";break;
      case 4206:error="no specified subwindow";break;
      default:error="unknown error";
   }
   return(error);
}

void Comments() {
   string NL = "\n";
   string displaying = "" 
      + "\n" 
      + "sRs Trade Management Robot 1.2" 
      + "\n" 
      + "------------------------------------------------" 
      + "\n" 
      + "Account Information:" 
      + "\n" 
      + "Account Name:         " + AccountName() 
      + "\n" 
      + "Account Number:       " + AccountNumber() 
      + "\n" 
      + "Account Leverage:     " + DoubleToStr(AccountLeverage(), 0) 
      + "\n" 
      + "Account Balance:      " + DoubleToStr(AccountBalance(), 2) 
      + "\n" 
      + "Account Currency:     " + AccountCurrency() 
      + "\n" 
      + "Account Equity:       " + DoubleToStr(AccountEquity(), 2) 
      + "\n" 
   + "------------------------------------------------";
   }

//+------------------------------------------------------------------+