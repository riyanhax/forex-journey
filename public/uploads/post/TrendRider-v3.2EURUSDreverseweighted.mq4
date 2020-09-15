//+------------------------------------------------------------------+
//|                                               TrendRider-v3.2.mq4|
//|                           Copyright © 2006, Done by investor_me. |
//|                                            investor.me@gmail.com |
//+------------------------------------------------------------------+
//Aaragorn's settings for mini account using 4H chart eurusd
//Revised by Aaragorn
#property copyright "Copyright © 2006, Done by investor_me. (timeframe independent)"
#property link      "investor.me@gmail.com"
extern bool Usefilewrite=false;
extern double StopLoss=13; // dd: 25% , sl: 64, ma: 5, min: 20 // dd: 8%, sl:7, ma:2, min: 1, ma_tf=0;
//StopLoss//12=199595.48//13=206124.61//14=crashedminiaccount
extern double TakeProfit=16;//14=211868.39//13=206124.61//16=214289.68
extern int MA=2;
extern int MA_tf=3;
//extern int TrendMAperiod=18;

extern double min=4.2;//on 1H--->10-50835.40//9-59244.54//8-66575.51//7-77322.31//4=145947.40//3==140742.27//5=137892.03//4.5=145557.88//3.8=145876.95//4.1=150901.99//4.2=152916.37//4.3=147006.24
//on 4H--->4.2=199595.48//4.25=191540.66//4.175=198320.15
extern int assurance=0;

extern double risk=0;

extern bool auto_risk=false;

extern int aggression=0;

extern double InitialLots=0.2;
extern bool money_management=true;

extern bool predefined_preferences=false;

extern int MAGIC=1001;
extern double MaxLots=10;

double last_profit=0, last_lots, last_diff, C, C1, C2, EMA, Lots;
int last_order=0, ClosedTrades, buys_met, sells_met, handle=0,typeo=0;

// Bar handling
datetime bartime=0;                   // used to determine when a bar has moved
int      bartick=0;                   // number of times bars have moved
int      objtick=0;                   // used to draw objects on the chart
int      tickcount=0;


int init()  
  { 
   
    last_lots=Lots;  
    if (MA_tf==0) MA_tf=1;
    else if (MA_tf==1) MA_tf=5;
    else if (MA_tf==2) MA_tf=15;
    else if (MA_tf==3) MA_tf=30;
    else if (MA_tf==4) MA_tf=60;
    else if (MA_tf==5) MA_tf=240;
    else if (MA_tf==6) MA_tf=1440;

   if (predefined_preferences)
    {
      if (Symbol()=="EURUSD") { StopLoss=28; MA=4; MA_tf=3; min=24; assurance=17; }
      if (Symbol()=="GBPUSD") { StopLoss=23; MA=20; MA_tf=1; }
      if (Symbol()=="USDJPY") { StopLoss=28; MA=20; MA_tf=3; }
      if (Symbol()=="USDCHF") { StopLoss=23; MA=10; MA_tf=4; }
      if (Symbol()=="AUDUSD") { StopLoss=23; MA=15; MA_tf=0; }
      if (Symbol()=="CADUSD") { StopLoss=28; MA=10; MA_tf=4; }
    }
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

   Print("Init happened ",CurTime());
   Comment(" ");
  }
    return(0); 
  }

int deinit() 
{ 
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
      
   Print("DE-Init happened ",CurTime());
   Comment(" ");
  }

return(0); 
}//deinit

int start()
  {
       // bar counting
   if(bartime!=Time[0]) 
     {
      bartime=Time[0];
      bartick++; 
      objtick++;
      //TradeAllowed=true;
     }
     if(OrdersTotal()==0)
     {
      ObjectDelete("Lots");
     }
   if(!IsTesting() && !IsDemo()) return (0);
   C=iClose(Symbol(),MA_tf,0);
   C1=iClose(Symbol(),MA_tf,1);
   C2=iClose(Symbol(),MA_tf,2);
   EMA=iMA(Symbol(),MA_tf,MA,0,MODE_EMA,PRICE_CLOSE,0);
   double EMATrend=0,EMATrend3=0;
 //  EMATrend=iMA(Symbol(),240,TrendMAperiod,0,MODE_EMA,PRICE_CLOSE,0);
  // EMATrend3=iMA(Symbol(),240,TrendMAperiod,0,MODE_EMA,PRICE_CLOSE,3);
//Print ("c:",DoubleToStr(C,10)," EMA:",DoubleToStr(EMA,10));

   if (PendingOrders()) { return (0); buys_met=0; sells_met=0; }
   
   if (EMA-C>=min*Point /*&& iClose(Symbol(),MA_tf,1)-iOpen(Symbol(),MA_tf,1)>=0*/) { buys_met++; sells_met=0; }
   else if (C-EMA>min*Point /*&& iOpen(Symbol(),MA_tf,1)-iClose(Symbol(),MA_tf,1)>=0*/)  { sells_met++; buys_met=0; } 

   if (/*EMATrend>EMATrend3 &&*/ (EMA-C>min*Point ||(EMA-C>0 && assurance>0)) && buys_met>assurance) { buys_met=0; sells_met=0; OpenOrder(0); }//buy
   else if (/*EMATrend<EMATrend3 &&*/ (C-EMA>min*Point ||(C-EMA>0 && assurance>0)) && sells_met>assurance) { buys_met=0; sells_met=0; OpenOrder(1); }//sell 
  }

void OpenOrder(int type) 
  {
  typeo=type;
   double r=risk;
   int ticket=0,ticket1=0;
   if (auto_risk) r=risk+MathAbs(Close[0]-EMA)*aggression*100;
   if (type==0)
   ticket =  OrderSend(Symbol(),OP_BUY,LongTrendLots(),Ask,2,Ask-Point*StopLoss,Ask+(TakeProfit*(1+r))*Point,"Trend Rider",MAGIC,0,Green); 
                    if(ticket>0)
                    {
                     ObjectDelete("Lots"); 
                     ObjectCreate("Lots", OBJ_TEXT, 0, Time[10], Low[0]+(0*Point));
                     ObjectSetText("Lots","Buy Lots: "+DoubleToStr(LongTrendLots(),2),30,"Arial",Yellow);                   
                     if (Usefilewrite)
                     {
                     if(OrderSelect(ticket, SELECT_BY_TICKET)==true)
                        {
                         handle = FileOpen("TrendRiderLongs.txt",FILE_READ|FILE_WRITE);
                         if(handle!=-1)
                           {
                           FileSeek(handle,0,SEEK_END);
                           FileWrite(handle,"Long OrderTicket: ",OrderTicket(),"  EMA-C @: ",EMA-C," C-C1: ", C-C1," C+C1/2: ", C+C1/2," C+C1+C2/3: ", C+C1+C2/3);
                           //FileWrite(handle,"  ");
           
                           FileFlush(handle);
                           FileClose(handle);
                           }
                         }//select by ticket
                      if(OrderSelect(ticket-1, SELECT_BY_TICKET)==true)
                        {
                        if(OrderSymbol() == Symbol() && OrderMagicNumber() == MAGIC)
                           {
                           if(OrderType()==OP_BUY)
                              {
                              handle = FileOpen("TrendRiderLongs.txt",FILE_READ|FILE_WRITE);
                              if(handle!=-1)
                                {
                                FileSeek(handle,0,SEEK_END);
                                FileWrite(handle,"Long OrderTicket: ",OrderTicket(),"  Profit: ",OrderProfit() );
                                //FileWrite(handle,"  ");

                                FileFlush(handle);
                                FileClose(handle);
                                }
                              }//order type
                           if(OrderType()==OP_SELL)
                              {
                              handle = FileOpen("TrendRiderShorts.txt",FILE_READ|FILE_WRITE);
                              if(handle!=-1)
                                {
                                FileSeek(handle,0,SEEK_END);
                                FileWrite(handle,"Short OrderTicket: ",OrderTicket(),"  Profit: ",OrderProfit() );
                                //FileWrite(handle,"  ");

                                FileFlush(handle);
                                FileClose(handle);
                                }
                              }//order type   
                           }//symbol and magic #   
                        }//select ticket-1       
                      }//use filewrite
                     }//if ticket>0
   else if (type==1)
   ticket1 =  OrderSend(Symbol(),OP_SELL,ShortTrendLots(),Bid,2,Bid+Point*StopLoss,Bid-(TakeProfit*(1+r))*Point,"Trend Rider",MAGIC,0,Red); 
                    if(ticket1>0)
                    {
                    ObjectDelete("Lots");
                    ObjectCreate("Lots", OBJ_TEXT, 0, Time[10], Low[0]+(0*Point));
                    ObjectSetText("Lots","Sell Lots: "+DoubleToStr(ShortTrendLots(),2),30,"Arial",Orange);
                     if (Usefilewrite)
                     {
                     if(OrderSelect(ticket1, SELECT_BY_TICKET)==true)
                        {
                        handle = FileOpen("TrendRiderShorts.txt",FILE_READ|FILE_WRITE);
                        if(handle!=-1)
                          {
                          FileSeek(handle,0,SEEK_END);
                          FileWrite(handle,"Short OrderTicket: ",OrderTicket(),"  C-EMA @: ",C-EMA," C-C1: ", C-C1," C+C1/2: ", C+C1/2," C+C1+C2/3: ", C+C1+C2/3);
                          //FileWrite(handle,"  ");
           
                          FileFlush(handle);
                          FileClose(handle);
                          }
                        }//select by ticket
                     if(OrderSelect(ticket1-1, SELECT_BY_TICKET)==true)
                        {
                        if(OrderSymbol() == Symbol() && OrderMagicNumber() == MAGIC)
                           {
                           if(OrderType()==OP_BUY)
                              {
                              handle = FileOpen("TrendRiderLongs.txt",FILE_READ|FILE_WRITE);
                              if(handle!=-1)
                                {
                                FileSeek(handle,0,SEEK_END);
                                FileWrite(handle,"Long OrderTicket: ",OrderTicket(),"  Profit: ",OrderProfit() );
                                //FileWrite(handle,"  ");

                                FileFlush(handle);
                                FileClose(handle);
                                }
                              }//order type
                           if(OrderType()==OP_SELL)
                              {
                              handle = FileOpen("TrendRiderShorts.txt",FILE_READ|FILE_WRITE);
                              if(handle!=-1)
                                {
                                FileSeek(handle,0,SEEK_END);
                                FileWrite(handle,"Short OrderTicket: ",OrderTicket(),"  Profit: ",OrderProfit() );
                                //FileWrite(handle,"  ");

                                FileFlush(handle);
                                FileClose(handle);
                                }
                              }//order type   
                           }//symbol and magic #   
                        }//select ticket-1     
                      }//use filewrite
                     }//if ticket>0
  
  }//open order

bool PendingOrders()  
  {
   for(int i=0;i<OrdersTotal(); i++)  
      {
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==Symbol() && OrderComment()=="Trend Rider" && OrderMagicNumber()==MAGIC) 
            { last_profit=OrderProfit(); last_lots=OrderLots(); 
              if (OrderType()==OP_SELL) last_order=1; else if (OrderType()==OP_BUY) last_order=2; return(True); }
         else return(false); 
      }   
   }

/*double ProfitMade()
  {
    int i, hstTotal=HistoryTotal();
    for(i=hstTotal-1;i<hstTotal;i++)
        { 
           if (OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)
               {
                Print("Access to history failed with error (",GetLastError(),")");
                break;
               }
           if((OrderType()==OP_BUY || OrderType()==OP_SELL) && OrderMagicNumber()==MAGIC)
                  return (OrderProfit());
        }
   return (0);
  }
  
double GetLots()
  { 
   double prof=ProfitMade();
   double current_lots=Lots;
   double r=risk;
   if (auto_risk) r=risk+MathAbs(Close[0]-EMA)*aggression*100;
   if (last_profit>prof && prof>0) prof=last_profit;
   if (prof>0) 
     { 
      current_lots=last_lots*(1+r);
      RefreshRates();
      if (current_lots*(1000*Ask)>AccountBalance()) 
        { current_lots=AccountBalance()/(1000*Ask); current_lots=MathFloor(current_lots*10)/10; } 
      if (current_lots>=MaxLots) current_lots=MaxLots; 
     } 
   last_lots=current_lots;
   return (current_lots);
  }*/
  

///////////////////////////////////////
double LongTrendLots()
  { 
   if(typeo==0 && LastOrderType()==1 ) 
      {
      Lots=InitialLots;
      Print("REVERSE to Long--Lots: ",Lots);  
      }
   if(typeo==0 && LastOrderType()==0 && Ask<=LastOrderLevel() )
      {
      Print("Before ",Lots);
      Lots=((LastOrderLots())*0.8);
      Print("-Order ",typeo," -LOtype ",LastOrderType()," -Ask ",Ask," -LOLevel ",LastOrderLevel()," -LOLots ",LastOrderLots());
      Print("After ",Lots);
      }
   if(typeo==0 && LastOrderType()==0 && Ask>LastOrderLevel() )
      {
      Print("Before ",Lots);
      Lots=((LastOrderLots())*1.2);
      Print("-Order ",typeo," -LOtype ",LastOrderType()," -Ask ",Ask," -LOLevel ",LastOrderLevel()," -LOLots ",LastOrderLots());
      Print("After ",Lots);
      }
      
    Lots=NormalizeDouble(Lots,2);
    if (Lots < 0.1) Lots=0.1;
    if (Lots>10) Lots=10;    
   return (Lots);
  }
///////////////////////////////////////
double ShortTrendLots()
  {
   if(typeo==1 && LastOrderType()==0 )
      {
      Lots=InitialLots;
      Print("REVERSE to Short---Lots: ",Lots);  
      }
   if(typeo==1 && LastOrderType()==1 && Bid>=LastOrderLevel() )
      {
      Print("Before ",Lots);
      Lots=((LastOrderLots())*0.8);
      Print("-Order ",typeo," -LOtype ",LastOrderType()," -Bid ",Bid," -LOLevel ",LastOrderLevel()," -LOLots ",LastOrderLots());
      Print("After ",Lots);
      }
   if(typeo==1 && LastOrderType()==1 && Bid<LastOrderLevel() )
      {
      Print("Before ",Lots);
      Lots=((LastOrderLots())*1.2);
      Print("-Order ",typeo," -LOtype ",LastOrderType()," -Bid ",Bid," -LOLevel ",LastOrderLevel()," -LOLots ",LastOrderLots());
      Print("After ",Lots);
      } 
    Lots=NormalizeDouble(Lots,2);
    if (Lots < 0.1) Lots=0.1;
    if (Lots>10) Lots=10;    
   return (Lots);
  }  
  
///////////////////////////////////////
double LastOrderType()
  {
    int typ=0;
 // retrieving info from trade history
   int i,hstTotal=HistoryTotal();
   for(i=0;i<hstTotal;i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)    
      {
       //---- check selection result
       if( OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC )
         {
          Print("Access to history failed with error (",GetLastError(),")");
          break;
         }//if symbol and magic # 
       }//select last order  
       // some work with order
       if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
        {
        if( OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC )
          {
          double ii=i;//identifies last closed order's ticket number
          }//if symbol and magic # 
        }//select last order  
     }//for loop
    
     if(OrderSelect(ii,SELECT_BY_POS,MODE_HISTORY)==true)//last closed order on this pair only by this EA code only
         {
         if(OrderSymbol()==Symbol() && OrderComment()=="Trend Rider" && OrderMagicNumber()==MAGIC)
            {
            Print("OrderType(): ",OrderType());
            }
          }  
  return(OrderType());          
  }  
///////////////////////////////////////
double LastOrderLots()
  {
    double Lts=0;
 // retrieving info from trade history
   int i,hstTotal=HistoryTotal();
   for(i=0;i<hstTotal;i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)    
      {
       //---- check selection result
       if( OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC )
         {
          Print("Access to history failed with error (",GetLastError(),")");
          break;
         }//if symbol and magic # 
       }//select last order  
       // some work with order
       if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
        {
        if( OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC )
          {
          double ii=i;//identifies last closed order's ticket number
          }//if symbol and magic # 
        }//select last order  
     }//for loop
    
     if(OrderSelect(ii,SELECT_BY_POS,MODE_HISTORY)==true)//last closed order on this pair only by this EA code only
     {
       if( OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC )
         {  
         ObjectDelete("Lolt"); 
         ObjectCreate("Lolt", OBJ_TEXT, 0, Time[36], High[0]+(-20*Point));
         ObjectSetText("Lolt","LOLots: "+DoubleToStr(OrderLots(),2),18,"Arial",Yellow);                   
         Lts=OrderLots();
         }
      } 
       
        //Print("Last order Lots: ",Lts);
   return (Lts);
  }  
///////////////////////////////////////
double LastOrderLevel()
  {
    double lvl=0;
   // retrieving info from trade history
   int i,hstTotal=HistoryTotal();
   for(i=0;i<hstTotal;i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)    
      {
       //---- check selection result
       if( OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC )
         {
          Print("Access to history failed with error (",GetLastError(),")");
          break;
         }//if symbol and magic # 
       }//select last order  
       // some work with order
       if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
        {
        if( OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC )
          {
          double ii=i;//identifies last closed order's ticket number
          }//if symbol and magic # 
        }//select last order  
     }//for loop
    
     if(OrderSelect(ii,SELECT_BY_POS,MODE_HISTORY)==true)//last closed order on this pair only by this EA code only
     {
       if( OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC )
         {   
          //Print("OrderTicket(): ",OrderTicket());
           ObjectDelete("BuyU");
           ObjectCreate("BuyU", OBJ_TEXT, 0, Time[50], High[0]+(20*Point));
           ObjectSetText("BuyU",DoubleToStr(OrderTicket(),0),18,"Arial",Yellow);
           ObjectDelete("oop");
           ObjectCreate("oop", OBJ_TEXT, 0, Time[30], High[0]+(40*Point));
           ObjectSetText("oop","LastOpenLevel"+DoubleToStr(OrderOpenPrice(),4),20,"Arial",Yellow);
            lvl=OrderOpenPrice();               
         }//symbol and magic       
    }//select 
        //Print("LEVEL Bottom last order number",i);
        //Print("Last order level: ",lvl);
   return (lvl);
  }     