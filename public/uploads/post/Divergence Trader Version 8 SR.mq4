/*
+--------+
|Divergence Trader
+--------+
*/


// variables declared here are GLOBAL in scope

#property copyright "Ron Thompson"
#property link      "http://www.lightpatch.com/forex"

// user input
extern int    ShortRange=3;
extern int    MidRange=50;
extern int    LongRange=150;
extern double MaximumRisk=20;
extern int    MaxOrdersPerBar=5;
extern double proximity=7;
extern double Lots=0.01;              // how many lots to trade at a time 
extern double MAXlot=3;
extern int    Fast_Period=7;
extern int    Slow_Period=88;
extern double DVBuySell=0.0005;//0.0011
extern double DVStayOut=0.0145;
extern double ProfitMade=20;          // how much money do you expect to make
extern double LossLimit=25;          // how much loss can you tolorate
extern double TrailStop=20;         // trailing stop (999=no trailing stop)
extern int    PLBreakEven=9999;       // set break even when this many pips are made (999=off)
extern int    BasketProfit=  1;      // if equity reaches this level, close trades
extern double TakeProfit = 78;
extern int    BasketLoss=9999;        // if equity reaches this negative level, close trades
extern string Dynamic_Trailing_Stop_Settings = "Dynamic Trailing Stop Settings";
extern bool               EnableTrailingStop = true; // Enable Dynamic Trailing Stop
extern int                    TrailATRPeriod = 7;
extern double             TrailingStopFactor = 2.5;//1.45
// Dynamic Trailing stop (TS) global variables
double PrevBuyStop=0,BuyStop=0;
double PrevSellStop=0,SellStop=0,TrailingStop=0;
// Entry Variance variables
//extern double     EntryVariance = 4;
extern int             BarShift = 1; // must exceed 1
extern double LongRangeAvPeriod = 2;//56
extern double HH_LLAvePeriodEnt = 1;//28
extern double          TpFactor = 0.6;

// externals that don't need to be external
       int    Slippage=0;             // how many pips of slippage can you tolorate
       bool   FileData=false;         // write to file exery tick?
       double Tp1=0;
       bool   UseBasket=false;
// naming and numbering
int      MagicNumber  = 200601182020; // allows multiple experts to trade on same account
string   TradeComment = "Divergence_07_";

// Bar handling
datetime bartime=0;                   // used to determine when a bar has moved
int      bartick=0;                   // number of times bars have moved
int      objtick=0;                   // used to draw objects on the chart
int      tickcount=0;

// Trade control
bool TradeAllowed=true;               // used to manage trades
double EntryCondition=0; // 0=standing by, 1=buy, 2=sell

// Min/Max tracking
double maxOrders;
double maxEquity;
double minEquity;



//+-------------+
//| Custom init |
//|-------------+
// Called ONCE when EA is added to chart or recompiled

int init()
  {
   int    i;
   string o;
   
   //remove the old objects 
   for(i=0; i<Bars; i++) 
     {
      o=DoubleToStr(i,0);
      ObjectDelete("myx"+o);
      ObjectDelete("myz"+o);
     }
   objtick=0;
/*
   ObjectDelete("Cmmt");
   ObjectCreate( "Cmmt", OBJ_TEXT, 0, Time[20], High[20]+(5*Point) );
   ObjectSetText("Cmmt","Divergence=X.XXXX",10,"Arial",White);
*/
   Print("Init happened ",CurTime());
   Comment(" ");
  }

//+----------------+
//| Custom DE-init |
//+----------------+
// Called ONCE when EA is removed from chart

int deinit()
  {
   int    i;
   string o;
   //remove the old objects 
   
   for(i=0; i<Bars; i++) 
     {
      o=DoubleToStr(i,0);
      ObjectDelete("myx"+o);
      ObjectDelete("myz"+o);
     }
   objtick=0;
   
   Print("MAX number of orders ",maxOrders);
   Print("MAX equity           ",maxEquity);
   Print("MIN equity           ",minEquity);
      
   Print("DE-Init happened ",CurTime());
   Comment(" ");
  }


//+-----------+
//| Main      |
//+-----------+
// Called EACH TICK and each Bar[]

int start()
  {
  
  
  // order tracking
   
   double p=Point;
   double spread=Ask-Bid;
   double spread2=(Ask-Bid)+2*Point; // for setting unattended stoploss and takeprofit
   
   int      cnt=0;
   int      gle=0;
   int      OrdersPerSymbol=0;
   
   int      iFileHandle;
  
   // stoploss and takeprofit and close control
   double SL=0;
   double TP=0;
   double CurrentProfit=0;
   double CurrentBasket=0;
   
   // direction control
   bool BUYme=false;
   bool SELLme=false;
   
   
   // Trade stuff
   double diverge;
   double maF1,maF2,maS1;

   // bar counting
   if(bartime!=Time[0]) 
     {
      bartime=Time[0];
      bartick++; 
      objtick++;
      TradeAllowed=true;
     }

   OrdersPerSymbol=0;
   for(cnt=OrdersTotal();cnt>=0;cnt--)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if( OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
        {
         OrdersPerSymbol++;
         if (OrdersTotal()< MaxOrdersPerBar)
            {     
            TradeAllowed=true;
            }
            else
            {
            TradeAllowed=false;
            }
        }
     }
   if(OrdersPerSymbol>maxOrders) maxOrders=OrdersPerSymbol;


   //+-----------------------------+
   //| Insert your indicator here  |
   //| And set either BUYme or     |
   //| SELLme true to place orders |
   //+-----------------------------+

   int    Fast_Price = PRICE_OPEN;
   int    Fast_Mode  = MODE_EMA;
   maF1=iMA(Symbol(),0,Fast_Period,0,Fast_Mode,Fast_Price,0);
   maF2=iMA(Symbol(),0,Fast_Period,0,Fast_Mode,Fast_Price,1);//aaragorn added
   int    Slow_Price = PRICE_OPEN;
   int    Slow_Mode  = MODE_SMMA;
   maS1=iMA(Symbol(),0,Slow_Period,0,Slow_Mode,Slow_Price,0);
   double HH=0,LL=0,ATR=0,LastATR=0,ATAPeriod=1,EntLevel=0;
   HH = High[Highest(NULL,0,MODE_HIGH,HH_LLAvePeriodEnt,0)];    
   LL = Low[Lowest(NULL,0,MODE_LOW,HH_LLAvePeriodEnt,0)];
   double H=0,L=0,EntryVariance=0;
   H = High[Highest(NULL,0,MODE_HIGH,1,BarShift)];   // last bar  
   L = Low[Lowest(NULL,0,MODE_LOW,1,BarShift)];      // last bar
   ATR= iATR(NULL,0,ATAPeriod,0);
   LastATR = iATR(NULL,0,ATAPeriod,1);
   
   diverge=(maF1-maS1);
   EntryVariance = EntryVariance(EntryVariance);
   EntLevel = L+EntryVariance;
   
   double maS2=0,diverge2=0;
   maS2=iMA(Symbol(),0,Slow_Period,0,Slow_Mode,Slow_Price,1);
   diverge2=(maF2-maS2);
   
   double Support=0,Resistance=0;
   
   
//-------------------Resistance------------------//   
    //---Short Range Resistance
    int run2=0,cord11=0,cord12=0;//resistance
    double cord11value=0,cord12value=0,rise2=0,slope2=0;//resistance

    cord11 = Highest(NULL,0,MODE_HIGH,(ShortRange*2),ShortRange);
    cord12 = Highest(NULL,0,MODE_HIGH,ShortRange,0);
    cord11value = High[Highest(NULL,0,MODE_HIGH,(ShortRange*2),ShortRange)];
    cord12value = High[Highest(NULL,0,MODE_HIGH,ShortRange,0)];
    rise2 = cord12value - cord11value;
    run2 = cord11-cord12;
    slope2 = rise2/run2;

    if(rise2>0)
      {
      Resistance = cord12value+(MathAbs(slope2)*cord12);
      }
      else
      {
      Resistance = cord12value-(MathAbs(slope2)*cord12);
      }
    if(cord11value==cord12value)
      {
      cord11=cord11-1;
      }
      ObjectDelete("ShortResistance");
      ObjectCreate("ShortResistance", OBJ_TREND, 0, Time[cord11],cord11value , Time[cord12],cord12value);
      
      ObjectDelete("Cmmt29");
      ObjectCreate("Cmmt29", OBJ_ARROW, 0, Time[cord11],cord11value+(15*p));
      ObjectDelete("Cmmt30");
      ObjectCreate("Cmmt30", OBJ_ARROW, 0, Time[cord12],cord12value+(15*p));
      
      ObjectDelete("Cmmt3199");
      ObjectCreate("Cmmt3199", OBJ_TEXT, 0, Time[40], Resistance+(0*p));
      ObjectSetText("Cmmt3199","Short Range Resistance Slope=  "+DoubleToStr(slope2,6),8,"Arial",White);
      
    //---Mid Range Resistance
    int run21=0,cord111=0,cord121=0,cord121a=0;//resistance
    double cord111value=0,cord121value=0,Resistance1=0,rise21=0,slope21=0,cord121av=0;//resistance

    cord111 = Highest(NULL,0,MODE_HIGH,(MidRange*2),MidRange);             //returns the index value of highest
    cord111value = High[Highest(NULL,0,MODE_HIGH,(MidRange*2),MidRange)];  //returns the value of highest high in far range    
 
    cord121a = Highest(NULL,0,MODE_HIGH,MidRange,MidRange/2);                       //returns the index value of middle ground
    cord121av = High[Highest(NULL,0,MODE_HIGH,MidRange/2,MidRange/2)];                //returns the high value of middle ground
    
    cord121 = Highest(NULL,0,MODE_HIGH,MidRange,0);                        //returns the index value of highest
    cord121value = High[Highest(NULL,0,MODE_HIGH,MidRange,0)];             //returns the value of highest high in close range
   

    rise21 = cord121value - cord111value;
    run21 = cord111-cord121;
    slope21 = rise21/run21;
    if(cord111value==cord121value)
      {
      cord111=cord111-1;
      }
    if(rise21>0)
      {
      Resistance1 = cord121value+(MathAbs(slope21)*cord121);
      }
      else
      {
      Resistance1 = cord121value-(MathAbs(slope21)*cord121);
      }
   
      ObjectDelete("MidResistance");
      ObjectCreate("MidResistance", OBJ_TREND, 0, Time[cord111],cord111value , Time[cord121],cord121value);
      
      ObjectDelete("Cmmt33");
      ObjectCreate("Cmmt33", OBJ_ARROW, 0, Time[cord111],cord111value+(15*p));
      ObjectDelete("Cmmt34");
      ObjectCreate("Cmmt34", OBJ_ARROW, 0, Time[cord121],cord121value+(15*p));
      
      ObjectDelete("Cmmt3599");
      ObjectCreate("Cmmt3599", OBJ_TEXT, 0, Time[40], Resistance1+(-10*p));
      ObjectSetText("Cmmt3599","Mid Range Resistance Slope=  "+DoubleToStr(slope21,6),8,"Arial",White);   
 /*     
      ObjectDelete("Cmmt935");
      ObjectCreate("Cmmt935", OBJ_TEXT, 0, Time[0], Resistance1+(50*p));
      ObjectSetText("Cmmt935","Mid Range cord121=  "+DoubleToStr(cord121,4),8,"Arial",White); 

      ObjectDelete("Cmmt936");
      ObjectCreate("Cmmt936", OBJ_TEXT, 0, Time[0], Resistance1+(60*p));
      ObjectSetText("Cmmt936","Mid Range cord121value=  "+DoubleToStr(cord121value,4),8,"Arial",White);    */   

    //---Long Range Resistance      
    int run22=0,cord112=0,cord122=0;//resistance
    double cord112value=0,cord122value=0,Resistance2=0,rise22=0,slope22=0;//resistance

    cord112 = Highest(NULL,0,MODE_HIGH,(LongRange*4),LongRange);
    cord122 = Highest(NULL,0,MODE_HIGH,LongRange,0);
    cord112value = High[Highest(NULL,0,MODE_HIGH,(LongRange*4),LongRange)];
    cord122value = High[Highest(NULL,0,MODE_HIGH,LongRange,0)];
    rise22 = cord122value - cord112value;
    run22 = cord112-cord122;
    slope22 = rise22/run22;
    if(cord112value==cord122value)
      {
      cord112=cord112-1;
      }

    if(rise22>0)
      {
      Resistance2 = cord122value+(MathAbs(slope22)*cord122);
      }
      else
      {
      Resistance2 = cord122value-(MathAbs(slope22)*cord122);
      }
   
      ObjectDelete("LongResistance");
      ObjectCreate("LongResistance", OBJ_TREND, 0, Time[cord112],cord112value , Time[cord122],cord122value);
      
      ObjectDelete("Cmmt37");
      ObjectCreate("Cmmt37", OBJ_ARROW, 0, Time[cord112],cord112value+(15*p));
      ObjectDelete("Cmmt38");
      ObjectCreate("Cmmt38", OBJ_ARROW, 0, Time[cord122],cord122value+(15*p));
           
      ObjectDelete("Cmmt3999");
      ObjectCreate("Cmmt3999", OBJ_TEXT, 0, Time[40], Resistance2+(-20*p));
      ObjectSetText("Cmmt3999","Long Range Resistance Slope=  "+DoubleToStr(slope22,6),8,"Arial",White);          

      double RAve =0;      
      RAve= ((Resistance)+(Resistance1)+Resistance2)/3; //R=short, R1=mid, R2=long
      double SRAve=0;
      SRAve = (slope22+slope21+slope2)/3;
      
      ObjectDelete("Cmmt940");
      ObjectCreate("Cmmt940", OBJ_TEXT, 0, Time[50], RAve);
      ObjectSetText("Cmmt940","Average Resistance Slope=  "+DoubleToStr(SRAve,6),12,"Arial",Yellow);      
      
      ObjectDelete("Cmmt40");
      ObjectCreate("Cmmt40", OBJ_TEXT, 0, Time[0], RAve);
      ObjectSetText("Cmmt40","Average Resistance=  "+DoubleToStr(RAve,4),8,"Arial",White);
      
      ObjectDelete("AverageResistance");
      ObjectCreate("AverageResistance", OBJ_TREND, 0, Time[cord112],RAve , Time[0],RAve);
      
      ObjectDelete("Cmmt39");
      ObjectCreate("Cmmt39", OBJ_TEXT, 0, Time[0], RAve+(10*p));
      ObjectSetText("Cmmt39","Long Range Resistance=  "+DoubleToStr(Resistance2,4),8,"Arial",White);    
      
      ObjectDelete("Cmmt35");
      ObjectCreate("Cmmt35", OBJ_TEXT, 0, Time[0], RAve+(20*p));
      ObjectSetText("Cmmt35","Mid Range Resistance=  "+DoubleToStr(Resistance1,4),8,"Arial",White);  
      
      ObjectDelete("Cmmt31");
      ObjectCreate("Cmmt31", OBJ_TEXT, 0, Time[0], RAve+(30*p));
      ObjectSetText("Cmmt31","Short Range Resistance=  "+DoubleToStr(Resistance,4),8,"Arial",White);              
     
//-------------------Support------------------//
    //---Short Range Support
    int run42=0,cord411=0,cord412=0;//Support
    double cord411value=0,cord412value=0,rise42=0,slope42=0;//Support

    cord411 = Lowest(NULL,0,MODE_LOW,(ShortRange*4),ShortRange);
    cord412 = Lowest(NULL,0,MODE_LOW,ShortRange,0);
    cord411value = Low[Lowest(NULL,0,MODE_LOW,(ShortRange*4),ShortRange)];
    cord412value = Low[Lowest(NULL,0,MODE_LOW,ShortRange,0)];
    rise42 = cord412value - cord411value;
    run42 = cord411-cord412;
    slope42 = rise42/run42;
    if(cord411value==cord412value)
      {
      cord411=cord411-1;
      }

    if(rise42>0)
      {
      Support = cord412value+(MathAbs(slope42)*cord412);
      }
      else
      {
      Support = cord412value-(MathAbs(slope42)*cord412);
      }
   
      ObjectDelete("ShortSupport");
      ObjectCreate("ShortSupport", OBJ_TREND, 0, Time[cord411],cord411value , Time[cord412],cord412value);
      
      ObjectDelete("Cmmt430");
      ObjectCreate("Cmmt430", OBJ_ARROW, 0, Time[cord411],cord411value+(-15*p));
      ObjectDelete("Cmmt431");
      ObjectCreate("Cmmt431", OBJ_ARROW, 0, Time[cord412],cord412value+(-15*p));
      
      ObjectDelete("Cmmt528");
      ObjectCreate("Cmmt528", OBJ_TEXT, 0, Time[40], Support+(0*p));
      ObjectSetText("Cmmt528","Short Range Support Slope=  "+DoubleToStr(slope42,6),8,"Arial",White);
      
    //---Mid Range Support
    int run421=0,cord4111=0,cord4121=0;//Support
    double cord4111value=0,cord4121value=0,Support41=0,rise421=0,slope421=0;//Support

    cord4111 = Lowest(NULL,0,MODE_LOW,(MidRange*4),MidRange);
    cord4121 = Lowest(NULL,0,MODE_LOW,MidRange,0);
    cord4111value = Low[Lowest(NULL,0,MODE_LOW,(MidRange*4),MidRange)];
    cord4121value = Low[Lowest(NULL,0,MODE_LOW,MidRange,0)];
    rise421 = cord4121value - cord4111value;
    run421 = cord4111-cord4121;
    slope421 = rise421/run421;
    if(cord4111value==cord4121value)
      {
      cord4111=cord4111-1;
      }

    if(rise421>0)
      {
      Support41 = cord4121value+(MathAbs(slope421)*cord4121);
      }
      else
      {
      Support41 = cord4121value-(MathAbs(slope421)*cord4121);
      }
   
      ObjectDelete("MidSupport");
      ObjectCreate("MidSupport", OBJ_TREND, 0, Time[cord4111],cord4111value , Time[cord4121],cord4121value);
      
      ObjectDelete("Cmmt433");
      ObjectCreate("Cmmt433", OBJ_ARROW, 0, Time[cord4111],cord4111value+(-15*p));
      ObjectDelete("Cmmt434");
      ObjectCreate("Cmmt434", OBJ_ARROW, 0, Time[cord4121],cord4121value+(-15*p));
      
      ObjectDelete("Cmmt535");
      ObjectCreate("Cmmt535", OBJ_TEXT, 0, Time[40], Support41);
      ObjectSetText("Cmmt535","Mid Range Support Slope=  "+DoubleToStr(slope421,6),8,"Arial",White);    

    //---Long Range Support      
    int run422=0,cord4112=0,cord4122=0;//Support
    double cord4112value=0,cord4122value=0,Support42=0,rise422=0,slope422=0;//Support

    cord4112 = Lowest(NULL,0,MODE_LOW,(LongRange*4),LongRange);
    cord4122 = Lowest(NULL,0,MODE_LOW,LongRange,0);
    cord4112value = Low[Lowest(NULL,0,MODE_LOW,(LongRange*4),LongRange)];
    cord4122value = Low[Lowest(NULL,0,MODE_LOW,LongRange,0)];
    rise422 = cord4122value - cord4112value;
    run422 = cord4112-cord4122;
    slope422 = rise422/run422;
    if(cord4112value==cord4122value)
      {
      cord4112=cord4112-1;
      }

    if(rise422>0)
      {
      Support42 = cord4122value+(MathAbs(slope422)*cord4122);
      }
      else
      {
      Support42 = cord4122value-(MathAbs(slope422)*cord4122);
      }
   
      ObjectDelete("LongSupport");
      ObjectCreate("LongSupport", OBJ_TREND, 0, Time[cord4112],cord4112value , Time[cord4122],cord4122value);
      
      ObjectDelete("Cmmt437");
      ObjectCreate("Cmmt437", OBJ_ARROW, 0, Time[cord4112],cord4112value+(-15*p));
      ObjectDelete("Cmmt438");
      ObjectCreate("Cmmt438", OBJ_ARROW, 0, Time[cord4122],cord4122value+(-15*p));
           
      ObjectDelete("Cmmt539");
      ObjectCreate("Cmmt539", OBJ_TEXT, 0, Time[40], Support42+(40*p));
      ObjectSetText("Cmmt539","Long Range Support Slope=  "+DoubleToStr(slope422,6),8,"Arial",White);          

      double SAve4 =0;      
      SAve4= (Support+(Support41)+Support42)/3; //S=short, S1=mid, S2=long
      double SAve=0;
      SAve= (slope422+slope421+slope42)/3;
      
      ObjectDelete("Cmmt640");
      ObjectCreate("Cmmt640", OBJ_TEXT, 0, Time[50], SAve4);
      ObjectSetText("Cmmt640","Ave Support Slope=  "+DoubleToStr(SAve,6),12,"Arial",Yellow);
      
      ObjectDelete("Cmmt440");
      ObjectCreate("Cmmt440", OBJ_TEXT, 0, Time[80], SAve4);
      ObjectSetText("Cmmt440","Average Support=  "+DoubleToStr(SAve4,4),8,"Arial",White);
      
      ObjectDelete("AverageSupport");
      ObjectCreate("AverageSupport", OBJ_TREND, 0, Time[cord4112],SAve4 , Time[0],SAve4);         
   
      ObjectDelete("Cmmt428");
      ObjectCreate("Cmmt428", OBJ_TEXT, 0, Time[80], SAve4+(10*p));
      ObjectSetText("Cmmt428","Short Range Support=  "+DoubleToStr(Support,4),8,"Arial",White);
      
      ObjectDelete("Cmmt435");
      ObjectCreate("Cmmt435", OBJ_TEXT, 0, Time[80], SAve4+(20*p));
      ObjectSetText("Cmmt435","Mid Range Support=  "+DoubleToStr(Support41,4),8,"Arial",White);  
      
      ObjectDelete("Cmmt439");
      ObjectCreate("Cmmt439", OBJ_TEXT, 0, Time[80], SAve4+(30*p));
      ObjectSetText("Cmmt439","Long Range Support=  "+DoubleToStr(Support42,4),8,"Arial",White);              
 
   ObjectDelete("Cmmt");
   ObjectCreate("Cmmt", OBJ_TEXT, 0, Time[20], High[20]+(10*p));
   ObjectSetText("Cmmt","Divergence="+DoubleToStr(diverge,4),10,"Arial",White);
   
   
   if( diverge>= DVBuySell       && diverge<= DVStayOut       ) BUYme=true;
   if( diverge<=(DVBuySell*(-1)) && diverge>=(DVStayOut*(-1)) ) SELLme=true;
 
 
        
 /*  if(FileData)
     {
      tickcount++;
      iFileHandle = FileOpen("eaDivergence07", FILE_CSV|FILE_READ|FILE_WRITE, ",");
      FileSeek(iFileHandle, 0, SEEK_END);
      FileWrite(iFileHandle, bartick, " ", tickcount, " ", diverge);
      FileFlush(iFileHandle);
      FileClose(iFileHandle);
     }
*/
   //+------------+
   //| End Insert |
   //+------------+

   //ENTRY LONG (buy, Ask) 
   if(TradeAllowed && BUYme)
      {
      
      //Ask(buy, long)
    double FastSlope=0,SlowSlope=0,PSlowSlope=0,maS3=0,P1SlowSlope=0,maS4=0,P2SlowSlope=0,maS5=0,P3SlowSlope=0,maS6=0,P4SlowSlope=0,maS7=0;
   double P5SlowSlope=0,maS8=0,P6SlowSlope=0,maS9=0,P7SlowSlope=0,maS10=0;
    maS2=iMA(Symbol(),0,Slow_Period,0,Slow_Mode,Slow_Price,1);
    maS3=iMA(Symbol(),0,Slow_Period,0,Slow_Mode,Slow_Price,2);
    maS4=iMA(Symbol(),0,Slow_Period,0,Slow_Mode,Slow_Price,3);
    maS5=iMA(Symbol(),0,Slow_Period,0,Slow_Mode,Slow_Price,4);
    maS6=iMA(Symbol(),0,Slow_Period,0,Slow_Mode,Slow_Price,5);
    maS7=iMA(Symbol(),0,Slow_Period,0,Slow_Mode,Slow_Price,6);  
    maS8=iMA(Symbol(),0,Slow_Period,0,Slow_Mode,Slow_Price,7);
    maS9=iMA(Symbol(),0,Slow_Period,0,Slow_Mode,Slow_Price,8);
    maS10=iMA(Symbol(),0,Slow_Period,0,Slow_Mode,Slow_Price,9);       
    FastSlope = maF1-maF2;
    SlowSlope = maS1-maS2;
    PSlowSlope = maS2-maS3;
    P1SlowSlope = maS3-maS4;
    P2SlowSlope = maS4-maS5; 
    P3SlowSlope = maS5-maS6;
    P4SlowSlope = maS6-maS7;  
    P5SlowSlope = maS7-maS8; 
    P6SlowSlope = maS8-maS9;
    P7SlowSlope = maS9-maS10; 
           /*
      ObjectDelete("Cmmt9");
      ObjectCreate("Cmmt9", OBJ_TEXT, 0, Time[0], High[0]+(75*p));
      ObjectSetText("Cmmt9","FastSlope=  "+DoubleToStr(FastSlope,4),8,"Arial",White); 
      
      ObjectDelete("Cmmt10");
      ObjectCreate("Cmmt10", OBJ_TEXT, 0, Time[0], High[0]+(67*p));
      ObjectSetText("Cmmt10","SlowSlope=  "+DoubleToStr(SlowSlope,4),8,"Arial",White); 
      
      ObjectDelete("Cmmt11");
      ObjectCreate("Cmmt11", OBJ_TEXT, 0, Time[0], High[0]+(59*p));
      ObjectSetText("Cmmt11","PSlowSlope=  "+DoubleToStr(PSlowSlope,4),8,"Arial",White); 

      ObjectDelete("Cmmt12");
      ObjectCreate("Cmmt12", OBJ_TEXT, 0, Time[0], High[0]+(51*p));
      ObjectSetText("Cmmt12","P1SlowSlope=  "+DoubleToStr(P1SlowSlope,4),8,"Arial",White); 
      
      ObjectDelete("Cmmt13");
      ObjectCreate("Cmmt13", OBJ_TEXT, 0, Time[0], High[0]+(43*p));
      ObjectSetText("Cmmt13","P2SlowSlope=  "+DoubleToStr(P2SlowSlope,4),8,"Arial",White);  

      ObjectDelete("Cmmt14");
      ObjectCreate("Cmmt14", OBJ_TEXT, 0, Time[0], High[0]+(35*p));
      ObjectSetText("Cmmt14","P3SlowSlope=  "+DoubleToStr(P3SlowSlope,4),8,"Arial",White); 
      
      ObjectDelete("Cmmt15");
      ObjectCreate("Cmmt15", OBJ_TEXT, 0, Time[0], High[0]+(27*p));
      ObjectSetText("Cmmt15","P4SlowSlope=  "+DoubleToStr(P4SlowSlope,4),8,"Arial",White);   
      
      ObjectDelete("Cmmt16");
      ObjectCreate("Cmmt16", OBJ_TEXT, 0, Time[0], High[0]+(19*p));
      ObjectSetText("Cmmt16","P5SlowSlope=  "+DoubleToStr(P5SlowSlope,4),8,"Arial",White);  

      ObjectDelete("Cmmt17");
      ObjectCreate("Cmmt17", OBJ_TEXT, 0, Time[0], High[0]+(11*p));
      ObjectSetText("Cmmt17","P6SlowSlope=  "+DoubleToStr(P6SlowSlope,4),8,"Arial",White); 
      
      ObjectDelete("Cmmt18");
      ObjectCreate("Cmmt18", OBJ_TEXT, 0, Time[0], High[0]+(3*p));
      ObjectSetText("Cmmt18","P7SlowSlope=  "+DoubleToStr(P7SlowSlope,4),8,"Arial",White); 
       */                
    


   //   if(SlowSlope<PSlowSlope || PSlowSlope<P1SlowSlope ||  P1SlowSlope<P2SlowSlope || P2SlowSlope<P3SlowSlope /*|| P3SlowSlope<P4SlowSlope || P4SlowSlope<P5SlowSlope || P5SlowSlope<P6SlowSlope || P6SlowSlope<P7SlowSlope*/ )
    /*     {
         Lots=0.01;
         }
         else
         {
         LossLimit=20;
         }*/
      // if(maF2<maF1) LossLimit=0;//aaragorn added
      if(LossLimit ==0) SL=0; else SL=Ask-( (LossLimit +7)*Point );
      if(ProfitMade==0) TP=0; else TP=Ask+( (ProfitMade+7)*Point );
      //TP=Ask+TakeProfit*Point;
      //TP=Ask+NormalizeDouble( ((ATR)/1.5),Digits);
      TP=Ask+Tp1;
      if(Ask>L+EntryVariance || TP > maF2+(150*p) || /*midSslope*/ Support41< 0.000117  || Ask> Support+EntryVariance )///*midSslope*/ Support41
      {
      return(0);
      }
      int tkt=0;
      Lots=LotSize();
      if(SL==0)
         {
         Lots=Lots/10;
         if(Lots<0.01){Lots=0.01;}
         }

      tkt=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,SL,TP,TradeComment,MagicNumber,White);
      EntryCondition=1; // 0=standingby, 1=buy, 2=sell
      int handle = 0; 
      if(tkt>0)
         {
         if(OrderSelect(tkt, SELECT_BY_TICKET, MODE_TRADES)) 
            {     
            handle = FileOpen("divergenceEA.txt",FILE_READ|FILE_WRITE);
            if(handle!=-1)
               {
                  FileSeek(handle, 0, SEEK_END);
                  FileWrite(handle, "L OrderTicket: ",OrderTicket()," Long Resistance: ",Resistance2, " Mid Resistance: ", Resistance1, " Short Resistance: ", Resistance," Acct. Equity: ",AccountBalance() );
                  FileWrite(handle, "L OrderTicket: ",OrderTicket()," Long Resistance Slope: ",slope22, " Mid Resistance Slope: ", slope21, " Short Resistance Slope: ", slope2," Acct. Equity: ",AccountEquity() );
                  FileWrite(handle, "L OrderTicket: ",OrderTicket()," Long Support: ",Support42, " Mid Support: ", Support41, " Short Support: ", Support );
                  FileWrite(handle, "L OrderTicket: ",OrderTicket()," Long Support Slope: ",slope422, " Mid Support Slope: ", slope421, " Short Support Slope: ", slope42 );
                  FileWrite(handle, "L OrderTicket: ",OrderTicket()," OrderOpenPrice: ",OrderOpenPrice(), " Ave Support Slope: ", SAve, " Ave Support: ", SAve4," Ave Resistance Slope: ", SRAve, " Ave Resistance: ", RAve );
      
                  FileFlush(handle);
                  FileClose(handle);
               }//if handle
            }//if select  
         }//if tkt>0   
      /*if(Ask<maS1)
      {
      EntryCondition=1.1; // 0=standingby, 1=buy, , 1.1bought below ma 2=sell
      }*/
      gle=GetLastError();
      if(gle==0)
        {
         Print("BUY  Ask=",Ask," bartick=",bartick);
         ObjectCreate("myx"+DoubleToStr(objtick,0), OBJ_TEXT, 0, Time[0], Low[0]-(15*p));
         ObjectSetText("myx"+DoubleToStr(objtick,0),"B",10,"Arial",Yellow);
         bartick=0;
         TradeAllowed=false;
        }
         else 
        {
         Print("-----ERROR----- BUY  Ask=",Ask," error=",gle," bartick=",bartick);
        }
     }
        
   //ENTRY SHORT (sell, Bid)
   if(TradeAllowed && SELLme)
     {
      //Bid (sell, short)
      if(LossLimit ==0) SL=0; else SL=Bid+((LossLimit)*Point );
      if(ProfitMade==0) TP=0; else TP=Bid-((ProfitMade+7)*Point );
      TP=Bid-TakeProfit*Point;
      if(Bid<HH-(proximity*Point) ||/*midRslope*//* slope21 > 0||*//*shortRslope*/ slope2<0 ||  Bid<Resistance-EntryVariance || Bid > maS1)
      {
      return(0);
      }
      int tkt1=0;
      Lots=LotSize();
     if(Bid>Resistance1)//midrangesupport * 60 pips Bid < (Support41+60*p)//slope2>0.0001
         {
         Lots=0.01;
         TP=20;
         }
      tkt1=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,SL,TP,TradeComment,MagicNumber,Red);
      EntryCondition=2; // 0=standingby, 1=buy, 2=sell
      int handle1 = 0;
      if(tkt1>0)
         {
         if(OrderSelect(tkt1, SELECT_BY_TICKET, MODE_TRADES)) 
            {     
            handle1 = FileOpen("divergenceEA.txt",FILE_READ|FILE_WRITE);
            if(handle1!=-1)
               {
               FileSeek(handle1, 0, SEEK_END);
               //FileWrite(handle1, "S OrderTicket: ",tkt1," bartick: ",bartick, " tickcount: ", tickcount, " diverge: ", diverge," Acct. Equity: ",AccountEquity() );
               FileWrite(handle1, "S OrderTicket: ",OrderTicket()," Long Resistance: ",Resistance2, " Mid Resistance: ", Resistance1, " Short Resistance: ", Resistance," Acct. Equity: ",AccountBalance() );
               FileWrite(handle1, "S OrderTicket: ",OrderTicket()," Long Resistance Slope: ",slope22, " Mid Resistance Slope: ", slope21, " Short Resistance Slope: ", slope2," Acct. Equity: ",AccountEquity() );
               FileWrite(handle1, "S OrderTicket: ",OrderTicket()," Long Support: ",Support42, " Mid Support: ", Support41, " Short Support: ", Support );
               FileWrite(handle1, "S OrderTicket: ",OrderTicket()," Long Support Slope: ",slope422, " Mid Support Slope: ", slope421, " Short Support Slope: ", slope42 );
               FileWrite(handle1, "S OrderTicket: ",OrderTicket()," OrderOpenPrice: ",OrderOpenPrice(), " Ave Support Slope: ", SAve, " Ave Support: ", SAve4," Ave Resistance Slope: ", SRAve, " Ave Resistance: ", RAve );
   
               FileFlush(handle1);
               FileClose(handle1);
               }//if handle1
            }//if select  
         }//if tkt1>0   
      /*if(Bid>maS1)
      {
      EntryCondition=2.1; // 0=standingby, 1=buy, , 1.1bought below ma, 2=sell, 2.1 sold above ma
      }*/
      gle=GetLastError();
      if(gle==0)
        {
         Print("SELL Bid=",Bid," bartick=",bartick); 
         ObjectCreate("myx"+DoubleToStr(objtick,0), OBJ_TEXT, 0, Time[0], High[0]+(15*p));
         ObjectSetText("myx"+DoubleToStr(objtick,0),"S",10,"Arial",Red);
         bartick=0;
         TradeAllowed=false;
        }
         else 
        {
         Print("-----ERROR----- SELL Bid=",Bid," error=",gle," bartick=",bartick);
        }
     }

    DynamicTrailStop(); 
   //Basket profit or loss
   CurrentBasket=AccountEquity()-AccountBalance();
   
  // if(CurrentBasket>maxEquity) maxEquity=CurrentBasket;
   //if(CurrentBasket<minEquity) minEquity=CurrentBasket;
    // actual basket closure
   if(UseBasket)
      { 
     /* ObjectDelete("Cmmt7");
      ObjectCreate("Cmmt7", OBJ_TEXT, 0, Time[0], High[0]+(35*p));
      ObjectSetText("Cmmt7","CurrentBasket="+DoubleToStr(CurrentBasket,4),8,"Arial",White);
      ObjectDelete("Cmmt8");
      ObjectCreate("Cmmt8", OBJ_TEXT, 0, Time[0], High[0]+(30*p));
      ObjectSetText("Cmmt8","BasketProfit="+DoubleToStr(BasketProfit,4),8,"Arial",White); */
           
      if( CurrentBasket>=BasketProfit /*|| CurrentBasket<=(BasketLoss*(-1))*/ )
        {
         CloseEverything();
         Print("Basket Profit Closed",BasketProfit);
         EntryCondition=0; // 0=standingby, 1=buy, 2=sell
         UseBasket=false;
        }
      }
 
 //--------------------------Drama---------------------Exits----------------
   

   /* 
    double maS1B=0,maF1B=0; 
    maS1B=iMA(Symbol(),0,Slow_Period,0,Slow_Mode,Slow_Price,2);
    maF1B=iMA(Symbol(),0,Fast_Period,0,Fast_Mode,Fast_Price,2);
     Print("EC: ",EntryCondition,"  &&  ",Ask+(5*Point)," Ask+(5*Point)>maS1 ",maS1);
    */ 
    double LL1=0;
    LL1 = Low[Lowest(NULL,0,MODE_LOW,HH_LLAvePeriodEnt,1)];
    if( EntryCondition==1 && Bid<LL1-NormalizeDouble((((proximity)*2)*Point),Digits)    )
     {
     //int("CLOSING LONGS TRIGGERED");
      //CloseEverything();
      UseBasket=true;
     }
   /*  if( EntryCondition==2 && Ask+(1*Point)>maS1)
     {
     Print("CLOSING SHORTS TRIGGERED");
      CloseEverything();
      EntryCondition=0; // 0=standingby, 1=buy, 2=sell
     }
     */
   //--------------------------------------------------------------------  
 
   // CLOSE order if profit target made
   for(cnt=OrdersTotal();cnt>=0;cnt--)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if( OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber )
        {
        
         if(OrderType()==OP_BUY)
           {
            CurrentProfit=Bid-OrderOpenPrice() ;

            // modify for break even
            if (CurrentProfit >= PLBreakEven*p && OrderOpenPrice()>OrderStopLoss())
              {
               SL=OrderOpenPrice()+(spread*2);
               TP=OrderTakeProfit();
               OrderModify(OrderTicket(),OrderOpenPrice(),SL,TP, White);
               gle=GetLastError();
               if(gle==0)
                 {
                  Print("MODIFY BREAKEVEN BUY  Bid=",Bid," bartick=",bartick); 
                  ObjectCreate("myz"+DoubleToStr(objtick,0), OBJ_TEXT, 0, Time[0], Low[0]-(7*p));
                  ObjectSetText("myz"+DoubleToStr(objtick,0),"BE",15,"Arial",White);
                 }
                  else 
                 {
                  Print("-----ERROR----- MODIFY BREAKEVEN BUY  Bid=",Bid," error=",gle," bartick=",bartick);
                 }
              }

            // modify for trailing stop
            if(CurrentProfit >= TrailStop*p )
              {
               SL=Bid-(TrailStop*p);
               TP=OrderTakeProfit();
               OrderModify(OrderTicket(),OrderOpenPrice(),SL,TP, White);
               gle=GetLastError();
               if(gle==0)
                 {
                  Print ("MODIFY TRAILSTOP BUY  StopLoss=",SL,"  bartick=",bartick,"OrderTicket=",OrderTicket()," CurrProfit=",CurrentProfit); 
                  ObjectCreate("myz"+DoubleToStr(objtick,0), OBJ_TEXT, 0, Time[0], Low[0]-(7*p));
                  ObjectSetText("myz"+DoubleToStr(objtick,0),"TS",15,"Arial",White);
                 }
                  else 
                 {
                  Print("-----ERROR----- MODIFY TRAILSTOP BUY  Bid=",Bid," error=",gle," bartick=",bartick);
                 }
              }

            // did we make our desired BUY profit
            // or did we hit the BUY LossLimit
            if((ProfitMade>0 && CurrentProfit>=(ProfitMade*p)) || (LossLimit>0 && CurrentProfit<=((LossLimit*(-1))*p))  )
              {
               OrderClose(OrderTicket(),Lots,Bid,Slippage,White);
               gle=GetLastError();
               if(gle==0)
                 {
                  Print("CLOSE BUY  Bid=",Bid," bartick=",bartick); 
                  ObjectCreate("myz"+DoubleToStr(objtick,0), OBJ_TEXT, 0, Time[0], Low[0]-(7*p));
                  ObjectSetText("myz"+DoubleToStr(objtick,0),"C",15,"Arial",White);
                 }
                  else 
                 {
                  Print("-----ERROR----- CLOSE BUY  Bid=",Bid," error=",gle," bartick=",bartick);
                 }
              }
              
           } // if BUY


         if(OrderType()==OP_SELL)
           {

            CurrentProfit=OrderOpenPrice()-Ask;
            
            // modify for break even
            if (CurrentProfit >= PLBreakEven*p && OrderOpenPrice()<OrderStopLoss())
              {
               SL=OrderOpenPrice()-(spread*2);
               TP=OrderTakeProfit();
               OrderModify(OrderTicket(),OrderOpenPrice(),SL,TP, Red);
               gle=GetLastError();
               if(gle==0)
                 {
                  Print("MODIFY BREAKEVEN SELL Ask=",Ask," bartick=",bartick);
                  ObjectCreate("myz"+DoubleToStr(objtick,0), OBJ_TEXT, 0, Time[0], Low[0]-(7*p));
                  ObjectSetText("myz"+DoubleToStr(objtick,0),"BE",15,"Arial",Red);
                 }
                  else 
                 {
                  Print("-----ERROR----- MODIFY BREAKEVEN SELL Ask=",Ask," error=",gle," bartick=",bartick);
                 }
              }

            // modify for trailing stop
            if(CurrentProfit >= TrailStop*p)
              {
               SL=Ask+(TrailStop*p);
               TP=OrderTakeProfit();
               OrderModify(OrderTicket(),OrderOpenPrice(),SL,TP, Red);
               gle=GetLastError();
               if(gle==0)
                 {
                  Print ("MODIFY TRAILSTOP SELL StopLoss=",SL,"  bartick=",bartick,"OrderTicket=",OrderTicket()," CurrProfit=",CurrentProfit); 
                  ObjectCreate("myz"+DoubleToStr(objtick,0), OBJ_TEXT, 0, Time[0], Low[0]-(7*p));
                  ObjectSetText("myz"+DoubleToStr(objtick,0),"TS",15,"Arial",Red);
                 }
                  else 
                 {
                  Print("-----ERROR----- MODIFY TRAILSTOP SELL Ask=",Ask," error=",gle," bartick=",bartick);
                 }
              }

            // did we make our desired SELL profit?
            if( (ProfitMade>0 && CurrentProfit>=(ProfitMade*p)) || (LossLimit>0 && CurrentProfit<=((LossLimit*(-1))*p))  )
              {
               OrderClose(OrderTicket(),Lots,Ask,Slippage,Red);
               gle=GetLastError();
               if(gle==0)
                 {
                  Print("CLOSE SELL Ask=",Ask," bartick=",bartick);
                  ObjectCreate("myz"+DoubleToStr(objtick,0), OBJ_TEXT, 0, Time[0], Low[0]-(7*p));
                  ObjectSetText("myz"+DoubleToStr(objtick,0),"C",15,"Arial",Red);
                 }
                  else 
                 {
                  Print("-----ERROR----- CLOSE SELL Ask=",Ask," error=",gle," bartick=",bartick);
                 }
                 
              }

           } //if SELL
           
        } // if(OrderSymbol)
        
     } // for

  } // start()



//+-----------------+
//| CloseEverything |
//+-----------------+
// Closes all OPEN and PENDING orders

int CloseEverything()
  {
   double myAsk;
   double myBid;
   int    myTkt;
   double myLot;
   int    myTyp;

   int i;
   bool result = false;
    
   for(i=OrdersTotal();i>=0;i--)
     {
      OrderSelect(i, SELECT_BY_POS);

      myAsk=MarketInfo(OrderSymbol(),MODE_ASK);            
      myBid=MarketInfo(OrderSymbol(),MODE_BID);            
      myTkt=OrderTicket();
      myLot=OrderLots();
      myTyp=OrderType();
            
      switch( myTyp )
        {
         //Close opened long positions
         case OP_BUY      :result = OrderClose(myTkt, myLot, myBid, Slippage, Red);
         break;
      
         //Close opened short positions
         case OP_SELL     :result = OrderClose(myTkt, myLot, myAsk, Slippage, Red);
         break;

         //Close pending orders
         case OP_BUYLIMIT :
         case OP_BUYSTOP  :
         case OP_SELLLIMIT:
         case OP_SELLSTOP :result = OrderDelete( OrderTicket() );
       }
    
      if(result == false)
        {
         Alert("Order " , myTkt , " failed to close. Error:" , GetLastError() );
         Print("Order " , myTkt , " failed to close. Error:" , GetLastError() );
         Sleep(3000);
        }  

      Sleep(1000);

     } //for
  EntryCondition=0; // 0=standingby, 1=buy, 2=sell
  } // closeeverything

//+------------------------------------------------------------------+
//| Dynamic Trailing Stop                                            |
//+------------------------------------------------------------------+
// Check to see if "EnableTrailingStop" is enabled..if not no need to execute
// Only Modify the "StopLevel" here, since the exits are executed on the next function ExitMarket()
// please make sure that the distance is >= 5 pips from the market, otherwise the stop order modification will be rejected.
// Thank you!
int DynamicTrailStop()
{
    //Print("answer call trailstop");
    if(EnableTrailingStop)
      {

       TrailingStop = (TrailingStopFactor * iATR(Symbol(), 0 , TrailATRPeriod , 1) );
       for(int cnt = 0; cnt < OrdersTotal(); cnt++)
         {
            bool DynamicTrailAllowed = true;
            OrderSelect(cnt, SELECT_BY_POS);
            if(OrderMagicNumber() != MagicNumber)//insures only Patient1 placed orders are dynamic trail stop managed
               {
               DynamicTrailAllowed = False;
               }    
            if(DynamicTrailAllowed && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && TrailingStop > 0)
               {
               if(OrderType() == OP_BUY)// If order is a long position
                  {
                  BuyStop = Bid - TrailingStop;
                  if(BuyStop < PrevBuyStop) // We maintain the highest value
                     {
                     BuyStop = PrevBuyStop;
                     }
                  if(BuyStop > 0 && (Bid - BuyStop) >= Bid - (5 * Point)  && BuyStop > OrderStopLoss())// if new stop loss is allowed and higher than current stop loss
                     {
                     OrderModify(OrderTicket(), OrderOpenPrice(), BuyStop, OrderTakeProfit(), 0);
                     Print("NEW STOP LOSS: ",BuyStop);
                   //  ObjectCreate("myz"+DoubleToStr(objtick,0), OBJ_TEXT, 0, Time[0], Low[0]-(7*Point));
                   //  ObjectSetText("myz"+DoubleToStr(objtick,0),"DTS",6,"Arial",White);
                     }
                  }
                  else 
                  {
                  if(OrderType() == OP_SELL)// If order is a short position
                     {
                     SellStop = Ask + TrailingStop;
                     if(SellStop > PrevSellStop) // We maintain the lowest value
                        {
                        SellStop = PrevSellStop;
                        }
                     if(SellStop > 0 && (SellStop - Ask) >= Ask + (5 * Point)  && SellStop < OrderStopLoss())// if new stop loss is allowed and lower than current stop loss
                        {
                        OrderModify(OrderTicket(), OrderOpenPrice(), SellStop, OrderTakeProfit(), 0);
                        Print("NEW STOP LOSS: ",SellStop);
                        }
                     }//ifOT=S
                  }//ifOT=B
                           
                  if(OrderType() == OP_BUY)
                  {
                     BuyStop = Bid - TrailingStop;
                     if(BuyStop < PrevBuyStop) BuyStop = PrevBuyStop;
                     if(BuyStop > 0 && (Bid - BuyStop) >= 5 * Point && BuyStop > OrderStopLoss())
                        {
                        OrderModify(OrderTicket(), OrderOpenPrice(), BuyStop, OrderTakeProfit(), 0);
                        Print("NEW STOP LOSS: ",BuyStop);
                        }
                  }
                  else 
                  {
                     if(OrderType() == OP_SELL)
                     {
                        SellStop = Ask + TrailingStop;
                        if(SellStop > PrevSellStop) SellStop = PrevSellStop;
                        if(SellStop > 0 && (SellStop - Ask) >= 5 * Point && SellStop < OrderStopLoss())
                           {
                           OrderModify(OrderTicket(), OrderOpenPrice(), SellStop, OrderTakeProfit(), 0);
                           Print("NEW STOP LOSS: ",SellStop);
                           }
                     }
                  }

              }//ifDTA
         PrevBuyStop = BuyStop;
         PrevSellStop = SellStop;
      }//for
   }//ifEnableTS      
return (0);
}//DTS  
double LotSize()
{
    double     lot_min        = MarketInfo( Symbol(), MODE_MINLOT  );
    double     lot_max        = MarketInfo( Symbol(), MODE_MAXLOT  );
    double     lot_step       = MarketInfo( Symbol(), MODE_LOTSTEP );
    double     freemargin     = AccountFreeMargin();
    int        leverage       = AccountLeverage();
    double        lotsize        = MarketInfo( Symbol(), MODE_LOTSIZE );
 
    if( lot_min < 0 || lot_max <= 0.0 || lot_step <= 0.0 || lotsize <= 0 ) 
    {
        Print( "LotSize: invalid MarketInfo() results [", lot_min, ",", lot_max, ",", lot_step, ",", lotsize, "]" );
        return(-1);
    }
    if( leverage <= 0 )
    {
        Print( "LotSize: invalid AccountLeverage() [", leverage, "]" );
        return(-1);
    }
 
    double lot = NormalizeDouble( freemargin * MaximumRisk / leverage / 10.0, 2 );
 
    lot = NormalizeDouble( lot / lot_step, 0 ) * lot_step;
    if ( lot < 0.01 ) lot = 0.01;
    if ( lot > MAXlot ) lot = MAXlot;
 
    double needmargin = NormalizeDouble( lotsize / leverage * Ask * lot, 2 );
 
    if ( freemargin < needmargin )
    {
        
        Print( "LotSize: We have no money. Need Margin = ", needmargin );
        return(-1);
    }
 
    return(lot);
}
//--------------Bar Entry Variance Filter----------------------------+
double EntryVariance(double EV)
{
  double H=0,L=0,Hn=0,Ln=0,EV1=0;
 // H = High[Highest(NULL,0,MODE_HIGH,LongRangeAvPeriod,BarShift)];   // last bar  
 // L = Low[Lowest(NULL,0,MODE_LOW,LongRangeAvPeriod,BarShift)];      // last bar
 // Hn = High[Highest(NULL,0,MODE_HIGH,HH_LLAvePeriodEnt,0)];   // current bar  
  //Ln = Low[Lowest(NULL,0,MODE_LOW,HH_LLAvePeriodEnt,0)];      // current bar
  
  //double H= (iHigh(NULL,0,2)),L= (iLow(NULL,0,2));
  double Spread=Ask-Bid,ATAPeriod=2;
  //Tp1 = (H-L)*TpFactor;
  double LastATR = iATR(NULL,0,ATAPeriod,1);
  Tp1=LastATR-Spread-(10*Point);
  EV1 = Tp1/7;
  if(EV1<Spread+0.0001){EV1=Spread+0.0003;}
  Print("Tp1: ",Tp1," EntryVariance: ",EV1);
  

return(EV1);
}




