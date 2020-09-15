//+------------------------------------------------------------------+
//|                                             Level Scalper V4.mq4 |
//|                                           djindyfx@sbcglobal.net |
//|      http://www.learncurrencytrading.com/fxforum/blogs/djindyfx/ |
//+------------------------------------------------------------------+
#property copyright "djindyfx@sbcglobal.net"
#property link      "http://www.learncurrencytrading.com/fxforum/blogs/djindyfx/"

//---- input parameters -----
extern int        pips=10; // Distance between levels
extern double     lots=0.1;
extern int        FixedSpread=4;
extern int        NbLevels=5; // Number of levels of the pending orders (for each target, buy and sell)
extern bool       ContinueTrading=false;

// ----- Kill all trades -----
extern bool       CloseAllOrders=false;

// ----- Entry times / Start Times -----
extern bool       UseEntryTime=false;
extern int        EntryTime=0;

// ----- EA Display Settings -----
  extern string note = "EA Display Settings";
  extern int      WhatCorner=1;
  extern color    FontColor = LawnGreen;
  extern int      FontSize=10;
  extern string   FontType="Calibri";
  extern int      MoveUpDown = 15 ;
  extern int      SideDistance = 2;

// -----Global Fixed Variables
bool closing = true;
bool Enter = true;
int Magic = 20080825;
int ProfitTarget=0; 

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//---- Delete All Items from the Screen -----
   ObjectDelete("ObjLots_Label");
   ObjectDelete("ObjBuyGoal_Label");
   ObjectDelete("ObjBuyGoalProfit_Label");
   ObjectDelete("ObjSellGoal_Label");
   ObjectDelete("ObjSellGoalProfit_Label");
   ObjectDelete("ObjLevels_Label");
   ObjectDelete("ObjPairTotal_Label");
   ObjectDelete("ObjInitialprice_Label");
   ObjectDelete("ObjSellGoalStop_Label");
   ObjectDelete("ObjBuyGoalStop_Label");
   ObjectDelete("ObjContinueTrading_Label");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
   int ticket=0, cpt=0, profit=0, total=0, pairtotal=0, BuyGoalProfit=0, SellGoalProfit=0, PipsLot;
   double BuyGoal=0, BuyGoalStop=0, SellGoal=0, SellGoalStop=0, spread=FixedSpread, InitialPrice=0;
//----
   if(pips<MarketInfo(Symbol(),MODE_STOPLEVEL)+spread) pips=1+MarketInfo(Symbol(),MODE_STOPLEVEL)+spread;
   if(lots<MarketInfo(Symbol(),MODE_MINLOT)) lots=MarketInfo(Symbol(),MODE_MINLOT);
   for(cpt=0;cpt<OrdersTotal();cpt++)
   {
      OrderSelect(cpt,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol()&& OrderMagicNumber()==Magic)
      {
         pairtotal++;
         if(!InitialPrice) InitialPrice=StrToDouble(OrderComment());
      }
   }
   // ----- Kill all Open / Pending Orders -----
   if(CloseAllOrders == true) {KillSession();return(0);}
   
   if(closing == true && pairtotal>=1) {EndSession();return(0);}
  
   if(pairtotal==0 && Enter && (!UseEntryTime || (UseEntryTime && Hour()==EntryTime))) //we can set up a new "price catcher"
   {
      closing = false;
      InitialPrice=Ask;
      
      // ----- Take Profit / Stop Loss set up -----
      BuyGoal=InitialPrice+(NbLevels+1)*pips*Point;
      SellGoal=InitialPrice-(NbLevels+1)*pips*Point;
      BuyGoalStop = SellGoal-spread*Point;
      SellGoalStop = BuyGoal+spread*Point;

      for(cpt=1;cpt<=NbLevels;cpt++)
      {
         OrderSend(Symbol(),OP_BUYSTOP,lots,InitialPrice+cpt*pips*Point,2,BuyGoalStop,BuyGoal,DoubleToStr(InitialPrice,MarketInfo(Symbol(),MODE_DIGITS)),Magic,0);
         OrderSend(Symbol(),OP_SELLSTOP,lots,InitialPrice-cpt*pips*Point,2,SellGoalStop,SellGoal,DoubleToStr(InitialPrice,MarketInfo(Symbol(),MODE_DIGITS)),Magic,0);
      }
    }
    else // We have open Orders
    {
      // ----- Add more levels -----
      BuyGoal=InitialPrice+(NbLevels+1)*pips*Point;
      SellGoal=InitialPrice-(NbLevels+1)*pips*Point;
      BuyGoalStop = SellGoal-spread*Point;
      SellGoalStop = BuyGoal+spread*Point;
      
      // ----- Close all Pending orders after TP / SL is hit -----
      if(Bid>=BuyGoal){closing = true; EndSession();return(0);}
      if(Ask<=SellGoal){closing = true; EndSession();return(0);}

      // ----- continue Closing all pending orders -----
      if(closing==true) {EndSession();return(0);}

      // -----Check Profits -----
      BuyGoalProfit=CheckProfits(lots,OP_BUY,false,InitialPrice);
      SellGoalProfit=CheckProfits(lots,OP_SELL,false,InitialPrice);

      if(BuyGoalProfit<ProfitTarget)
      // - Incriment Lots Buy
      {
         for(cpt=NbLevels;cpt>=1; cpt--)
         {
            if(Ask<=(InitialPrice+(cpt*pips-MarketInfo(Symbol(),MODE_STOPLEVEL))*Point))
            {
               ticket=OrderSend(Symbol(),OP_BUYSTOP,cpt*lots,InitialPrice+cpt*pips*Point,2,BuyGoalStop,BuyGoal,DoubleToStr(InitialPrice,MarketInfo(Symbol(),MODE_DIGITS)),Magic,0);
            }
            if(ticket>0) BuyGoalProfit+=lots*(BuyGoal-InitialPrice-cpt*pips*Point)/Point;
         }
      }
      if(SellGoalProfit<ProfitTarget)
      // - Incriment Lots Sell
      {
         for(cpt=NbLevels;cpt>=1; cpt--)
         {
            if(Bid>=(InitialPrice-(cpt*pips-MarketInfo(Symbol(),MODE_STOPLEVEL))*Point))
            {
               ticket=OrderSend(Symbol(),OP_SELLSTOP,cpt*lots,InitialPrice-cpt*pips*Point,2,SellGoalStop,SellGoal,DoubleToStr(InitialPrice,MarketInfo(Symbol(),MODE_DIGITS)),Magic,0);
            }
            if(ticket>0) SellGoalProfit+=lots*(InitialPrice-SellGoal-cpt*pips*Point)/Point;
         }
      }
   }
   
   
   // ----- Object Data Set up -----
   
   string ObjLots= DoubleToStr(lots,2);
   string ObjPips = pips;
   string ObjLevels = NbLevels;
   string ObjBuyGoal = DoubleToStr(BuyGoal,Digits);
   string ObjBuyGoalProfit = BuyGoalProfit;
   string ObjSellGoal = DoubleToStr(SellGoal,Digits);
   string ObjSellGoalProfit = SellGoalProfit;
   string ObjPairTotal = pairtotal;
   string ObjInitialprice = DoubleToStr(InitialPrice,Digits);
   string ObjBuyGoalStop = DoubleToStr(BuyGoalStop,Digits);
   string ObjSellGoalStop = DoubleToStr(SellGoalStop,Digits);
   string ObjContinueTrading = ContinueTrading;
   
//----- Object Distances

   int YInitialDistance, Ydist01, Ydist02, Ydist03, Ydist04, Ydist05, Ydist06, Ydist07, Ydist08, Ydist09, DistFromSide, YDistInc;
   DistFromSide = SideDistance;
   
   YInitialDistance = MoveUpDown;
   YDistInc = 15;
   Ydist01 = YInitialDistance + YDistInc;
   Ydist02 = Ydist01 + YDistInc +10;
   Ydist03 = Ydist02 + YDistInc;
   Ydist04 = Ydist03 + YDistInc;
   Ydist05 = Ydist04 + YDistInc +10;
   Ydist06 = Ydist05 + YDistInc;
   Ydist07 = Ydist06 + YDistInc+10;
   Ydist08 = Ydist07 + YDistInc;
   Ydist09 = Ydist08 + YDistInc;
   
   //----- Screen Data

  ObjectCreate("ObjContinueTrading_Label", OBJ_LABEL, 0, 0, 0);
  ObjectSetText("ObjContinueTrading_Label", "Continuous Trade " + ObjContinueTrading, FontSize, FontType, FontColor);
  ObjectSet("ObjContinueTrading_Label", OBJPROP_CORNER, WhatCorner);
  ObjectSet("ObjContinueTrading_Label", OBJPROP_XDISTANCE, DistFromSide);
  ObjectSet("ObjContinueTrading_Label", OBJPROP_YDISTANCE, YInitialDistance);
  
  ObjectCreate("ObjLots_Label", OBJ_LABEL, 0, 0, 0);
  ObjectSetText("ObjLots_Label", "Lots " + ObjLots, FontSize, FontType, FontColor);
  ObjectSet("ObjLots_Label", OBJPROP_CORNER, WhatCorner);
  ObjectSet("ObjLots_Label", OBJPROP_XDISTANCE, DistFromSide);
  ObjectSet("ObjLots_Label", OBJPROP_YDISTANCE, Ydist01);
  
  ObjectCreate("ObjLevels_Label", OBJ_LABEL, 0, 0, 0);
  ObjectSetText("ObjLevels_Label", "Levels " + ObjLevels, FontSize, FontType, FontColor);
  ObjectSet("ObjLevels_Label", OBJPROP_CORNER, WhatCorner);
  ObjectSet("ObjLevels_Label", OBJPROP_XDISTANCE, DistFromSide+60);
  ObjectSet("ObjLevels_Label", OBJPROP_YDISTANCE, Ydist01);
  
  ObjectCreate("ObjInitialprice_Label", OBJ_LABEL, 0, 0, 0);
  ObjectSetText("ObjInitialprice_Label", "Start Price " + ObjInitialprice, FontSize, FontType, FontColor);
  ObjectSet("ObjInitialprice_Label", OBJPROP_CORNER, WhatCorner);
  ObjectSet("ObjInitialprice_Label", OBJPROP_XDISTANCE, DistFromSide);
  ObjectSet("ObjInitialprice_Label", OBJPROP_YDISTANCE, Ydist02);
  
  ObjectCreate("ObjBuyGoal_Label", OBJ_LABEL, 0, 0, 0);
  ObjectSetText("ObjBuyGoal_Label", "Buy TP " + ObjBuyGoal, FontSize, FontType, FontColor);
  ObjectSet("ObjBuyGoal_Label", OBJPROP_CORNER, WhatCorner);
  ObjectSet("ObjBuyGoal_Label", OBJPROP_XDISTANCE, DistFromSide);
  ObjectSet("ObjBuyGoal_Label", OBJPROP_YDISTANCE, Ydist03);

  ObjectCreate("ObjSellGoal_Label", OBJ_LABEL, 0, 0, 0);
  ObjectSetText("ObjSellGoal_Label", "Sell TP " + ObjSellGoal, FontSize, FontType, FontColor);
  ObjectSet("ObjSellGoal_Label", OBJPROP_CORNER, WhatCorner);
  ObjectSet("ObjSellGoal_Label", OBJPROP_XDISTANCE, DistFromSide);
  ObjectSet("ObjSellGoal_Label", OBJPROP_YDISTANCE, Ydist04);

  ObjectCreate("ObjBuyGoalProfit_Label", OBJ_LABEL, 0, 0, 0);
  ObjectSetText("ObjBuyGoalProfit_Label", "Buy Pips  " + ObjBuyGoalProfit, FontSize, FontType, FontColor);
  ObjectSet("ObjBuyGoalProfit_Label", OBJPROP_CORNER, WhatCorner);
  ObjectSet("ObjBuyGoalProfit_Label", OBJPROP_XDISTANCE, DistFromSide);
  ObjectSet("ObjBuyGoalProfit_Label", OBJPROP_YDISTANCE, Ydist05);

  ObjectCreate("ObjSellGoalProfit_Label", OBJ_LABEL, 0, 0, 0);
  ObjectSetText("ObjSellGoalProfit_Label", "Sell Pips  " + ObjSellGoalProfit, FontSize, FontType, FontColor);
  ObjectSet("ObjSellGoalProfit_Label", OBJPROP_CORNER, WhatCorner);
  ObjectSet("ObjSellGoalProfit_Label", OBJPROP_XDISTANCE, DistFromSide);
  ObjectSet("ObjSellGoalProfit_Label", OBJPROP_YDISTANCE, Ydist06);

  ObjectCreate("ObjPairTotal_Label", OBJ_LABEL, 0, 0, 0);
  ObjectSetText("ObjPairTotal_Label", "Total Trades  " + ObjPairTotal, FontSize, FontType, FontColor);
  ObjectSet("ObjPairTotal_Label", OBJPROP_CORNER, WhatCorner);
  ObjectSet("ObjPairTotal_Label", OBJPROP_XDISTANCE, DistFromSide);
  ObjectSet("ObjPairTotal_Label", OBJPROP_YDISTANCE, Ydist07);

/* 
  ObjectCreate("ObjBuyGoalStop_Label", OBJ_LABEL, 0, 0, 0);
  ObjectSetText("ObjBuyGoalStop_Label", "Buy SL " + ObjBuyGoalStop, FontSize, FontType, FontColor);
  ObjectSet("ObjBuyGoalStop_Label", OBJPROP_CORNER, WhatCorner);
  ObjectSet("ObjBuyGoalStop_Label", OBJPROP_XDISTANCE, DistFromSide);
  ObjectSet("ObjBuyGoalStop_Label", OBJPROP_YDISTANCE, Ydist04);

  ObjectCreate("ObjSellGoalStop_Label", OBJ_LABEL, 0, 0, 0);
  ObjectSetText("ObjSellGoalStop_Label", "Sell SL " + ObjSellGoalStop, FontSize, FontType, FontColor);
  ObjectSet("ObjSellGoalStop_Label", OBJPROP_CORNER, WhatCorner);
  ObjectSet("ObjSellGoalStop_Label", OBJPROP_XDISTANCE, DistFromSide);
  ObjectSet("ObjSellGoalStop_Label", OBJPROP_YDISTANCE, Ydist07);
*/

    
//----
   return(0);
  }
//+------------------------------------------------------------------+

int CheckProfits(double lots, int Goal, bool Current, double InitialPrice)
{
   int profit=0, cpt;
   if(Current)//return current profit
   {
      for(cpt=0;cpt<OrdersTotal();cpt++)
      {
         OrderSelect(cpt, SELECT_BY_POS, MODE_TRADES);
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == Magic && StrToDouble(OrderComment())==InitialPrice)
         {
            if(OrderType()==OP_BUY) profit+=(Bid-OrderOpenPrice())/Point*OrderLots()/lots;
            if(OrderType()==OP_SELL) profit+=(OrderOpenPrice()-Ask)/Point*OrderLots()/lots;
         }
      }
      return(profit);
   }
   else
   {
      if(Goal==OP_BUY)
      {
         for(cpt=0;cpt<OrdersTotal();cpt++)
         {
            OrderSelect(cpt, SELECT_BY_POS, MODE_TRADES);
            if(OrderSymbol()==Symbol() && OrderMagicNumber() == Magic && StrToDouble(OrderComment())==InitialPrice)
            {
               if(OrderType()==OP_BUY) profit+=(OrderTakeProfit()-OrderOpenPrice())/Point*OrderLots()/lots;
               if(OrderType()==OP_SELL) profit-=(OrderStopLoss()-OrderOpenPrice())/Point*OrderLots()/lots;
               if(OrderType()==OP_BUYSTOP) profit+=(OrderTakeProfit()-OrderOpenPrice())/Point*OrderLots()/lots;
            }
         }
         return(profit);
      }
      else
      {
         for(cpt=0;cpt<OrdersTotal();cpt++)
         {
            OrderSelect(cpt, SELECT_BY_POS, MODE_TRADES);
            if(OrderSymbol()==Symbol() && OrderMagicNumber() == Magic && StrToDouble(OrderComment())==InitialPrice)
            {
               if(OrderType()==OP_BUY) profit-=(OrderOpenPrice()-OrderStopLoss())/Point*OrderLots()/lots;
               if(OrderType()==OP_SELL) profit+=(OrderOpenPrice()-OrderTakeProfit())/Point*OrderLots()/lots;
               if(OrderType()==OP_SELLSTOP) profit+=(OrderOpenPrice()-OrderTakeProfit())/Point*OrderLots()/lots;
               
            }
         }
         return(profit);
      }
   }
}

bool EndSession()
{
   int OrderCnt, total=OrdersTotal();
   for(OrderCnt=0;OrderCnt<total;OrderCnt++)
   {
      OrderSelect(OrderCnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()== Magic && OrderType()>0) OrderDelete(OrderTicket());
    }
      if(!ContinueTrading)  Enter=false;
      return(true);
}


bool KillSession()
{
   int OrderCnt, total=OrdersTotal();
   for(OrderCnt=0;OrderCnt<total;OrderCnt++)
   {
      OrderSelect(OrderCnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()== Magic && OrderType()== OP_BUYSTOP) OrderDelete(OrderTicket());
      else if(OrderSymbol()==Symbol() && OrderMagicNumber() == Magic && OrderType() == OP_SELLSTOP) OrderDelete(OrderTicket());      
      else if(OrderSymbol()==Symbol() && OrderMagicNumber() == Magic && OrderType() ==OP_BUY) OrderClose(OrderTicket(),OrderLots(),Bid,3);
      else if(OrderSymbol()==Symbol() && OrderMagicNumber() == Magic && OrderType() ==OP_SELL) OrderClose(OrderTicket(),OrderLots(),Ask,3);
       
    }
      if(!ContinueTrading)  Enter=false;
      return(true);
}

// -----  revision notes ------
/*
   V 2
1)  corrected code errors where is looks through the orders.  It must find the Magic # before addition is done
   V 3
2)  Added KillSession so that all trades could be closed.
   V 4
3)  Adjusted Text for on screen display




*/



