//|                                          Copyright  2007,Alejandro Galindo |
//|                                          Copyright  2007,Kalenzo           |
//|                    some modifications by cocoracas                         |
//+----------------------------------------------------------------------------+
#property copyright "Copyright  2007, cocoracas"
#property link      "http://www.forex-tsd.com"

extern   int      MaxTrades = 5;
extern   int      Pips = 60;
extern   double   TakeProfit = 45;
extern   double   TrailingStop = 0;
extern   double   InitialStop = 00;
extern double LotSize=0.01;
extern string Note1 = "TF DAILY";
extern int   MACDTimeFrame = 0;
extern int      SecureProfit = 10;
int      AccountProtection = 1;
int      OrdersToProtect = 4;
int      ReverseCondition = 0;
double   FirstOrderLots=0.01;
int      OrdersOpened = 0;
int      cnt = 0;
double   lots = 0.01;
int      slippage = 2;
double   stoploss = 0;
double   takeprofit = 0;
double   bprice = 0;
double   sprice = 0;
double   lotsi = 0;
int      type = 0;
int      state = 0;
bool     EnableTrading = true;
double   openprice = 0;
int      PreviousOrders = 0;
double   Profit = 0;
int      LastTicket = 0;
int      LastType = 0;
double   LastClosePrice = 0;
double   LastLots = 0;
double   PipValue = 0;
string   text2 = "";
string   text = "";
double   lotstmp;
double trade;
double trade1;
int trendtype;



//---- input parameters
extern int RSIOMA          = 3;
extern int RSIOMA_MODE     = MODE_EMA;
extern int RSIOMA_PRICE    = PRICE_CLOSE;

extern int Ma_RSIOMA       = 21,
           Ma_RSIOMA_MODE  = MODE_EMA;

extern int BuyTrigger      = 70;
extern int SellTrigger     = 30;


extern int MainTrendLong   = 50;
extern int MainTrendShort  = 50;
double RSIBuffer[];
double PosBuffer[];
double NegBuffer[];

double bdn[],bup[];
double sdn[],sup[];

double marsioma[];


//---- buffers

string short_name;
double rel,rel1,negative,positive;
int i;
int MAFastPeriod=3;
int MAFastShift=0;
int MAFastMethod=MODE_SMA;
int MAFastPrice=PRICE_CLOSE;

int MASlowPeriod=8;
int MASlowShift=0;
int MASlowMethod=MODE_SMA;
int MASlowPrice=PRICE_CLOSE;
int rete;
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

int init()
{
 

  return(0);
}

//+------------------------------------------------------------------+

int deinit()
{

  return(0);
}

//+------------------------------------------------------------------+

int start()
{
double macd = iMACD(NULL,0,5,13,1,PRICE_CLOSE,MODE_MAIN,0);
  int    counted_bars=IndicatorCounted();
   double rel,rel1,negative,positive;


  double fast1=iMA(Symbol(),0,MAFastPeriod,MAFastShift,MAFastMethod,MAFastPrice,1);
  double fast2=iMA(Symbol(),0,MAFastPeriod,MAFastShift,MAFastMethod,MAFastPrice,2);
  double slow1=iMA(Symbol(),0,MASlowPeriod,MASlowShift,MASlowMethod,MASlowPrice,1);
  double slow2=iMA(Symbol(),0,MASlowPeriod,MASlowShift,MASlowMethod,MASlowPrice,2);
  if (fast1>slow1&&fast2<slow2) rete = 2;
  if (fast1<slow1&&fast2>slow2) rete = 1;
   
//----
   if(Bars<=RSIOMA) return(0);
//---- initial zero
   if(counted_bars<1)
      for(i=1;i<=RSIOMA;i++) RSIBuffer[Bars-i]=0.0;
//----
   i=Bars-RSIOMA-1;
   int ma = i;
   if(counted_bars>=RSIOMA) i=Bars-counted_bars-1;
   while(i>=0)
     {
      double sumn=0.0,sump=0.0;
      if(i==Bars-RSIOMA-1)
        {
         int k=Bars-2;
         //---- initial accumulation
         while(k>=i)
           {
            
            double cma = iMA(Symbol(),0,RSIOMA,0,RSIOMA_MODE,RSIOMA_PRICE,k);
            double pma = iMA(Symbol(),0,RSIOMA,0,RSIOMA_MODE,RSIOMA_PRICE,k+1);
            
            rel=cma-pma;
            
            if(rel>0) sump+=rel;
            else      sumn-=rel;
            k--;
           }
         positive=sump/RSIOMA;
         negative=sumn/RSIOMA;
        }
      else
        {
         //---- smoothed moving average
         double ccma = iMA(Symbol(),0,RSIOMA,0,RSIOMA_MODE,RSIOMA_PRICE,i);
         double ppma = iMA(Symbol(),0,RSIOMA,0,RSIOMA_MODE,RSIOMA_PRICE,i+1);
            
         rel=ccma-ppma;
         
         if(rel>0) sump=rel;
         else      sumn=-rel;
         positive=(PosBuffer[i+1]*(RSIOMA-1)+sump)/RSIOMA;
         negative=(NegBuffer[i+1]*(RSIOMA-1)+sumn)/RSIOMA;
        }
         //    Comment(rel);
      PosBuffer[i]=positive;
      NegBuffer[i]=negative;
      if(negative==0.0) RSIBuffer[i]=0.0;
      else
      {
          RSIBuffer[i]=100.0-100.0/(1+positive/negative);
          
          bdn[i] = 0;
          bup[i] = 0;
          sdn[i] = 0;
          sup[i] = 0;
          
          if(RSIBuffer[i]>MainTrendLong)
          bup[i] = -10;
          
          if(RSIBuffer[i]<MainTrendShort)
          bdn[i] = -10;
          
          if(RSIBuffer[i]<30 && RSIBuffer[i]>RSIBuffer[i+1])
          sup[i] = -10;
          
          if(RSIBuffer[i]>70 && RSIBuffer[i]<RSIBuffer[i+1])
          sdn[i] = -10;
            
          
      }    
      i--;
     }
     
     while(ma>=0)
     {
         marsioma[ma] = iMAOnArray(RSIBuffer,0,Ma_RSIOMA,0,Ma_RSIOMA_MODE,ma); 
         ma--;
     }    



//Comment(rel);
if(LotSize==0)
{
if (AccountBalance()>10000)
FirstOrderLots = AccountBalance()/50000;
if (AccountBalance()<10000)
FirstOrderLots = AccountBalance()/600;
if (AccountBalance()>50000)
FirstOrderLots = AccountBalance()/50000;
}
else
FirstOrderLots=LotSize;

lotsi = NormalizeDouble(FirstOrderLots,2);
if (lotsi > 100.0) lotsi = 100;
if (lotsi<0.01) lotsi=0.1;
string tripo;
if (rel > 0 && macd > 0) tripo = "BUY";
if (rel < 0 && macd < 0) tripo = "SELL";
OrdersOpened = 0;
Comment("USE ONLY WITH EUR/USD IN 30M TIME FRAME","\n");
for (cnt = 0; cnt < OrdersTotal(); cnt++)
{
 OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
 if (OrderSymbol() == Symbol()) OrdersOpened++;
}

PipValue=MarketInfo(Symbol(),MODE_TICKVALUE); 
if (PipValue == 0.0) PipValue = 5;

if (PreviousOrders > OrdersOpened)
   {
   for (cnt = OrdersTotal(); cnt >= 0; cnt--)
      {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      type = OrderType();
      if (OrderSymbol() == Symbol())
         {
         if (type == OP_BUY)  OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slippage,Blue);
         if (type == OP_SELL) OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slippage,Red);
         //return(0);
         }
      }
   }

PreviousOrders = OrdersOpened;
if (OrdersOpened >= MaxTrades) EnableTrading = false; else EnableTrading = true;

if (openprice == 0.0)
   {
   for (cnt = 0; cnt < OrdersTotal(); cnt++)
      {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      type = OrderType();
      if (OrderSymbol() == Symbol())
         {
         openprice = OrderOpenPrice();
         if (type == OP_BUY)  state = 2;
         if (type == OP_SELL) state = 1;
         }
      }
   }
//double ma34 = iMA(NULL,PERIOD_M1,2,0,MODE_EMA,PRICE_CLOSE,0);
//double ma89 = iMA(NULL,PERIOD_M1,5,0,MODE_EMA,PRICE_CLOSE,0);
//double sarCurrent          = iSAR(NULL,PERIOD_M5,0.009,0.2,0);
//double sarPrevious         = iSAR(NULL,PERIOD_M5,0.009,0.2,1);

if (OrdersOpened < 1)
   {
   state = 3;
   if (rel > 0 && rete == 2) state = 2;
   if (rel < 0 && rete == 1) state = 1;
   if (ReverseCondition == 1)
      {
      if (state == 1)
         {
         state = 2;
         }
            else
         {
         if (state == 2)
            {
            state = 1;
            }
         }
      }
   }

for (cnt = OrdersTotal(); cnt >= 0; cnt--)
   {
   OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
   if (OrderSymbol() == Symbol())
      {
      if (OrderType() == OP_SELL)
         {
         if (TrailingStop > 0.0)
            {
            if (OrderOpenPrice() - Ask >= (TrailingStop + Pips) * Point)
               {
               if (OrderStopLoss() > Ask + Point * TrailingStop)
                  {
                  OrderModify(OrderTicket(),OrderOpenPrice(),Ask + Point * TrailingStop,OrderClosePrice() - TakeProfit * Point - TrailingStop * Point,800,Purple);
                  return(0);
                  }
               }
            }
         }
      if (OrderType() == OP_BUY)
         {
         if (TrailingStop > 0.0)
            {
            if (Bid - OrderOpenPrice() >= (TrailingStop + Pips) * Point)
               {
               if (OrderStopLoss() < Bid - Point * TrailingStop)
                  {
                  OrderModify(OrderTicket(),OrderOpenPrice(),Bid - Point * TrailingStop,OrderClosePrice() + TakeProfit * Point + TrailingStop * Point,800,Yellow);
                  return(0);
                  }
               }
            }
         }
      }
   }

Profit = 0;
LastTicket = 0;
LastType = 0;
LastClosePrice = 0;
LastLots = 0;

for (cnt = 0; cnt < OrdersTotal(); cnt++)
   {
   OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
   if (OrderSymbol() == Symbol())
      {
      LastTicket = OrderTicket();
      if (OrderType() == OP_BUY)  LastType = 0;
      if (OrderType() == OP_SELL) LastType = 1;
      LastClosePrice = OrderClosePrice();
      LastLots = OrderLots();
      if (LastType == 0)
         {
         if (OrderClosePrice() < OrderOpenPrice()) Profit -= (OrderOpenPrice() - OrderClosePrice()) * OrderLots() / Point;
         if (OrderClosePrice() > OrderOpenPrice()) Profit += (OrderClosePrice() - OrderOpenPrice()) * OrderLots() / Point;
         }
      if (LastType == 1)
         {
         if (OrderClosePrice() > OrderOpenPrice()) Profit -= (OrderClosePrice() - OrderOpenPrice()) * OrderLots() / Point;
         if (OrderClosePrice() < OrderOpenPrice()) Profit += (OrderOpenPrice() - OrderClosePrice()) * OrderLots() / Point;
         }
      }
   }

Profit = Profit * PipValue;
text = "Profit: $" + DoubleToStr(Profit,2) + " +/-";

   if (LastType == 0 && state == 1)
      {
      OrderClose(LastTicket,LastLots,LastClosePrice,slippage,Yellow);
      EnableTrading = false;
      return(0);
      }

   if (LastType == 1 && state == 2)
      {
      OrderClose(LastTicket,LastLots,LastClosePrice,slippage,Yellow);
      EnableTrading = false;
      return(0);
      }


if ((OrdersOpened >= MaxTrades - OrdersToProtect) && (AccountProtection == 1))
   {
   if (Profit >= SecureProfit)
      {
      OrderClose(LastTicket,LastLots,LastClosePrice,slippage,Yellow);
      EnableTrading = false;
      return(0);
      }
   }


if (!IsTesting())
   {
   if (state == 3)
      text2 = "No conditions to open trades";
         else
      text2 = "                         ";
   }

if ((state == 1) && EnableTrading)
   {
   if ((Bid - openprice >= Pips * Point) || (OrdersOpened < 1))
      {
      sprice = Bid;
      openprice = 0;
      if (TakeProfit == 0.0)
         takeprofit = 0;
            else
         takeprofit = sprice - TakeProfit * Point;
      if (InitialStop == 0.0)
         stoploss = 0;
            else
         stoploss = sprice + InitialStop * Point;
      if (OrdersOpened != 0)
       {
        
         lots = lotsi;
         for (cnt = 1; cnt <= OrdersOpened; cnt++)
         {
          if (MaxTrades>12) { lots=NormalizeDouble(lots*3,2); }
			 else { lots=NormalizeDouble(lots*3,2); }
         }
       }
      else
       {
         lots = lotsi;
       }
      if (lots > 100.0) lots = 100;
      OrderSend(Symbol(),OP_SELL,lots,sprice,slippage,0,0,0,0,0,Red);
      return(0);
      }
   }

if ((state == 2) && EnableTrading)
   {
   if ((openprice - Ask >= Pips * Point) || (OrdersOpened < 1))
      {
      bprice = Ask;
      openprice = 0;
      if (TakeProfit == 0.0) takeprofit = 0; else takeprofit = bprice + TakeProfit * Point;
      if (InitialStop == 0.0) stoploss = 0; else stoploss = bprice - InitialStop * Point;
      if (OrdersOpened != 0)
         {
         lots = lotsi;
         for (cnt = 1; cnt <= OrdersOpened; cnt++)
            {
          if (MaxTrades>12) { lots=NormalizeDouble(lots*3,2); }
			 else { lots=NormalizeDouble(lots*3,2); }
            }
         }
            else
         {
         lots = lotsi;
         }
      if (lots > 100.0) lots = 100;
      OrderSend(Symbol(),OP_BUY,lots,bprice,slippage,0,0,0,0,0,Blue);
      return(0);
      }
   }
return(0);
}




