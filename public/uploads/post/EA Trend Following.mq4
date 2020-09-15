//+------------------------------------------------------------------+
//|                                           EA Trend Following.mq4 |
//|                                      Copyright © 2012, Graper 71 |
//|                                      http://www.trading-team.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, Graper 71."
#property link      "http://www.trading-team.net"

//external input parameters

extern string    S1 ="--- Display Function --- ";
extern bool      DisplayInfo=false;

extern string    S2 ="--- Money Management Method: 1FL - 2 FP - 3FF ---";
extern int       Money_Management_Method=3;                 
extern double    FixedLotSize=0.10;
extern double    Fixed_Percent_Risk=1.00;
extern double    Fractional_Lot=0.10;                       
extern int       Fractional_Capital=1000;                   

extern string    S3 ="--- Order Management ---";
extern double    StopLoss=25;
extern bool      IsBreakEvenStop=false;
extern int       BreakEvenStep=15;
extern int       BreakEvenPip=3;

extern string    S4 ="--- Trading Time Filter --- ";
extern bool      TradingHours=true;
extern int       StartHour=2;
extern int       EndHour=22;
extern bool      WeekEndClose=true;
extern int       FridayCloseHour=21;

extern string    S5 ="MA Type: 0SMA - 1EMA - 2SMMA - 3LWMA ";
extern int       Ma_Method=0;

extern string    S6 ="--- Strategy Indicators Settings --- ";
extern int       Ma_Period=40;
extern int       Rsi_Period=38;
extern int       CCI_Period=28;
extern int       ADX_Period=7;
extern int       CCI_Level=80;
extern int       ADX_Level=20;

extern string    S7 ="--- Expert Settings --- ";
extern int       MagicNumber=11111;
extern double    MySlippage=0.5;

int MyPoint; int res;
datetime lastOrder = 0;
bool NoTradeFlag;
int   Time_0;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
{
Time_0 = Time[0];
   
// Compatibility with 0,1,2,3,4,5 digits prices
   
if(Digits==3 || Digits==5) MyPoint=10; 

else MyPoint=1; 

} 

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
{
return(0);
}
// Check old bar (0) - new bar (1)
int NewBar()
    {
    int New_Bar=0;                                           
    if (Time_0 != Time[0])                                  
      {
      New_Bar = 1; 
      NoTradeFlag=false;                                             
      Time_0 = Time[0]; 
      }
   return(New_Bar);
   }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{

// Display account info on the chart window
if (DisplayInfo==true)  PrintInfo();

// Check open positions by Magic ID

int i; bool alreadyOrder; 
for (i=0;i<OrdersTotal();i++)

// Check for opened position
   {
   OrderSelect(i,SELECT_BY_POS);
   if (OrderSymbol() == Symbol() && OrderMagicNumber()== MagicNumber)
      {
      alreadyOrder = true; bool NoStopLoss; bool moveToBreakeven; 
          
      // Check if Stop Level is at Breakeven
      if(IsBreakEvenStop==true)
        {
           
         if(NormalizeDouble(OrderStopLoss(),4)==NormalizeDouble(OrderOpenPrice()+BreakEvenPip*Point*MyPoint,4 ) || 
            NormalizeDouble(OrderStopLoss(),4)==NormalizeDouble(OrderOpenPrice()-BreakEvenPip*Point*MyPoint,4) )
          
         moveToBreakeven=true;
           
         else
         moveToBreakeven=false;
            {
                              
            // Check for conditions to move Stop Level at Breakeven
          
            if (OrderType()==OP_BUY && moveToBreakeven==false && Bid>=(OrderOpenPrice()+ (StopLoss+BreakEvenStep)*Point*MyPoint))
               {
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+BreakEvenPip*Point*MyPoint,0,0,Green);
               GetLastError();
               Print ("Stop level modified at breakeven.");
               }
           if (OrderType()==OP_SELL && moveToBreakeven==false && Ask<=(OrderOpenPrice()- (StopLoss+BreakEvenStep)*Point*MyPoint))
              {
              OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-BreakEvenPip*Point*MyPoint,0,0,Green);
              GetLastError();
              Print ("Stop level modified at breakeven.");
           }
         }
       }
// Check for close positions by trading system rules

      if (OrderType()==OP_BUY && iOpen(NULL,0,0)<=iMA(NULL,0,Ma_Period,0,Ma_Method,PRICE_OPEN,0) &&
          iMA(NULL,0,Ma_Period,0,Ma_Method,PRICE_OPEN,0)>OrderOpenPrice())     
          {          
          OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), 0, Blue);
          GetLastError();
          Print ("Buy position closed at " +DoubleToStr(OrderClosePrice(),4));
          }
      if (OrderType()==OP_SELL && iOpen(NULL,0,0)>=iMA(NULL,0,Ma_Period,0,Ma_Method,PRICE_OPEN,0) &&
          iMA(NULL,0,Ma_Period,0,Ma_Method,PRICE_OPEN,0)<OrderOpenPrice())
          {
          OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), 0, Blue);
          GetLastError();
          Print ("Sell position closed at " +DoubleToStr(OrderClosePrice(),4));  
          }
     
// Check for closing opened positions on friday evening
      if(FridayCloseHour<=EndHour){FridayCloseHour=EndHour;}                                    //CELLO  (CONTROLLO FridayCloseHour)

      if (WeekEndClose==true)
            {
            if (OrderType()==OP_BUY && DayOfWeek()==5 && Hour()>FridayCloseHour )               //CELLO (TOTLO =)
               {                      
               OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), 0, Blue);
               GetLastError();
               Print ("Buy position Weekend closed at " +DoubleToStr(OrderClosePrice(),4));
               }
            if (OrderType()==OP_SELL && DayOfWeek()==5 && Hour()>=FridayCloseHour )             //CELLO (TOTLO =)
               {  
                OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), 0, Blue);
                GetLastError();
                Print ("Sell position Weekend closed at " +DoubleToStr(OrderClosePrice(),4));
                }  
            }
       }
   if (OrderSymbol() == Symbol() && OrderMagicNumber()!= MagicNumber)
      {
      alreadyOrder = false; 
      }   
    }
// Manage Lot size      
   double MyLots;
   double Free   =AccountFreeMargin();                       
   double One_Lot=MarketInfo(Symbol(),MODE_MARGINREQUIRED);  
   double LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   double MaxLot = MarketInfo(Symbol(), MODE_MAXLOT);
   double MinLot = MarketInfo(Symbol(), MODE_MINLOT);
   double Lots_max=MathFloor(Free/One_Lot/LotStep )*LotStep ;  
   int Lots_Fractional=AccountFreeMargin()/Fractional_Capital;  


      if (Money_Management_Method==1)   
         {
         MyLots=FixedLotSize;
         if( MyLots < MinLot) { MyLots = MinLot; }
         if( MyLots > MaxLot) { MyLots = MaxLot; }
            if ((MyLots*One_Lot) > Free)                                                            
            {            
            Print("No margin for open position. Decrease FixedLotSize");  
            return(0);                                                                        
            }                                                                                   
         }
      if (Money_Management_Method==2)
         {
   		MyLots = Free*(Fixed_Percent_Risk/100)/(StopLoss*Market(Symbol(),3)/MarketInfo(Symbol(),MODE_TICKSIZE)*MarketInfo(Symbol(),MODE_TICKVALUE));   
   
         MyLots = MathFloor ( MyLots / LotStep ) * LotStep ;
         MyLots = MathMin ( MaxLot, MyLots);
 
            if(MyLots  < MinLot)
            {                        
               Print("No margin for open position. Decrease Stop level or increase Risk Percent.");
               return(0);  
            }
            if((MyLots*One_Lot) > Free)
            {                        
               Print("No margin for open position. Decrease Stop level or increase Risk Percent.");
               return(0);  
            }

         }
      if (Money_Management_Method==3)   
         {
         if (Lots_Fractional<1)
            {
            MyLots=Fractional_Lot;
            if( MyLots < MinLot) { MyLots = MinLot; }
            if( MyLots > MaxLot) { MyLots = MaxLot; }
                  if (MyLots*One_Lot> Free)                                                                                         
                  {  
                  Print("No margin for open position. Decrease Fractional_Capital, Fractional_Lot or increase Starting Capital.");  
                  return(0);                                                                                                        
                  }                                                                                   
            }
         if (Lots_Fractional>=1)
            {
            MyLots=Lots_Fractional*Fractional_Lot;
            if( MyLots < MinLot) { MyLots = MinLot; }
            if( MyLots > MaxLot) { MyLots = MaxLot; }
                  if (MyLots*One_Lot>Free)                                                                     
                  {  
                  Print("No margin for open position. Decrease Fractional_Capital, Fractional_Lot or increase Starting Capital.");
                  return(0);  
                  }                                                                                   
            }
         }
         
      
// Manage Trading Time
   
   if (DayOfWeek()==0 || DayOfWeek()==6)
   return;
   
   if (TradingHours==true)
      {
      bool IsTradingTime=false;
      if (Hour()>=StartHour && Hour()<=EndHour)
      IsTradingTime=true;
      }
   if (TradingHours==false)
      {
      IsTradingTime=true;
      }
   {
// Check for a new bar and EA previous orders          
   NewBar(); 
     {

// Verify condition for open Long position 
      
      if (!alreadyOrder && NoTradeFlag==False && IsTradingTime==true &&
          iOpen(NULL,0,0)>=iMA(NULL,0,Ma_Period,0,Ma_Method,PRICE_OPEN,0) &&     
          iLow(NULL,0,1)<=iMA(NULL,0,Ma_Period,0,Ma_Method,PRICE_OPEN,1) && 
          iCCI(NULL,0,CCI_Period,PRICE_OPEN,0)>=CCI_Level &&                               
          iADX(NULL,0,ADX_Period,PRICE_OPEN,MODE_MAIN,0)>=ADX_Level &&
          iRSI(NULL,0,Rsi_Period,PRICE_OPEN,0)>50
          )                                                     
   
// Send Long Order
         {
         NoTradeFlag=True; 
         res=OrderSend(Symbol(),OP_BUY,MyLots,Ask,MySlippage,0,0,"",MagicNumber,0,Blue); 
         OrderModify(res,OrderOpenPrice(),Ask-StopLoss*Point*MyPoint,0,0,Green);
         res=-1; 
         GetLastError();
         Print ("Long position opened at "+DoubleToStr(OrderOpenPrice(),4));
         }         

// Verify conditions for open Short position
   
      if (!alreadyOrder && NoTradeFlag==False && IsTradingTime==true &&          
          iOpen(NULL,0,0)<=iMA(NULL,0,Ma_Period,0,Ma_Method,PRICE_OPEN,0) &&    
          iHigh(NULL,0,1)>=iMA(NULL,0,Ma_Period,0,Ma_Method,PRICE_OPEN,1) &&                           
          iADX(NULL,0,ADX_Period,PRICE_OPEN,MODE_MAIN,0)>=ADX_Level &&
          iCCI(NULL,0,CCI_Period,PRICE_OPEN,0)<= -(CCI_Level) &&
          iRSI(NULL,0,Rsi_Period,PRICE_OPEN,0)<50
          )                       
   
// Send Short Order
          {
          NoTradeFlag=True;
          res=OrderSend(Symbol(),OP_SELL,MyLots,Bid,MySlippage,0,0,"",MagicNumber,0,Red); 
          OrderModify(res,OrderOpenPrice(),Bid+StopLoss*Point*MyPoint,0,0,Green);
          res=-1; 
          GetLastError();
          Print ("Short position opened at " + DoubleToStr(OrderOpenPrice(),4));
          }      
      }
   }
   return(0);
  }
//+-----------------------------------------------------------------------------------------------------------+

void PrintInfo() {
   string cmt="";
      cmt = "========================";
      cmt =  cmt + "\nAccount Name: [ " + AccountName() + " ]";            
      cmt =  cmt + "\nAccount Leverage: [ " + DoubleToStr( AccountLeverage(), 0 ) + " ]";      
      cmt =  cmt + "\nMin Lot: [ " + DoubleToStr( MarketInfo(Symbol(),MODE_MINLOT), 3 ) + " ]";      
      cmt =  cmt + "\nLot Step: [ " + DoubleToStr( MarketInfo(Symbol(),MODE_LOTSTEP), 3 ) + " ]"; 
      cmt =  cmt + "\nPip Value: [ " + DoubleToStr( MarketInfo(Symbol(),MODE_TICKVALUE), 2 ) + " ]";     
      cmt =  cmt + "\nCurrent Profit: [ " + DoubleToStr(AccountEquity()-AccountBalance(),2) + " ]";
      cmt =  cmt + "\nAccount Balance: [ " + DoubleToStr(AccountBalance(),2) + " ]";
      cmt =  cmt + "\nAccount Equity: [ " + DoubleToStr(AccountEquity(),2) + " ]";      
      cmt =  cmt + "\n========================";
      Comment(cmt);
}

   double Market(string coppia, int type) 
{
int Digits.pips,multiplier,pips2points;
double pips2dbl,ask,bid;
int dg=MarketInfo(coppia,MODE_DIGITS);
double point=MarketInfo(coppia,MODE_POINT);
        if (dg == 5 || dg == 3) {      // DE30=1/JPY=3/EURUSD=5 http://forum.mql4.com/43064#515262
                pips2dbl    = point*10; pips2points = 10;   Digits.pips = 1;
    } else {    pips2dbl    = point;    pips2points =  1;   Digits.pips = 0; }
         if (dg == 0) multiplier = 0.1;
         if (dg == 1) multiplier = 1;        
         if (dg == 2) multiplier = 10;
         if (dg == 3) multiplier = 100;
         if (dg == 4) multiplier = 10000;
         if (dg == 5) multiplier = 10000;       
   if(type==1)return( Digits.pips);
   if(type==2)return( pips2points);
   if(type==3)return( pips2dbl);
   if(type==4)return( multiplier);
}