//+------------------------------------------------------------------+
//|                                                 Multi Signal.mq4 |
//|                                              Copyright 2013, GVC |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, GVC"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window

extern int    xAxis = 0;
extern int    yAxis = 100;
extern int    FontSize = 18;
extern string FontType = "Arial Bold" ; //"Comic Sans MS";
extern int    WhatCorner = 0;
extern string note2  =  "Default Font Color";
extern color  FontColor  =  Yellow;

extern int    SizeBackGround    = 110;      // Size for background

extern int     AlertCandle         = 1;                                                                                                         //
extern bool    ShowChartAlerts     = true;                                                                                                     //
extern string  AlertEmailSubject   = "";                                                                                                        //
                                                                                                                                                //
datetime       LastAlertTime       = -999999;                                                                                                                    //
                    
datetime Time0;      
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  IndicatorShortName("Multi Signal");
//---- indicators
  //Background
  if(ObjectFind("Background")==-1)
  {
  ObjectCreate("Background",OBJ_LABEL,0,0,0);
  ObjectSet("Background",OBJPROP_CORNER,0);
  ObjectSet("Background",OBJPROP_BACK,FALSE);
  ObjectSet("Background",OBJPROP_YDISTANCE,11);
  ObjectSet("Background",OBJPROP_XDISTANCE,0);
  ObjectSetText("Background","g",SizeBackGround,"Webdings",CadetBlue);
  }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   Comment(" " );
   ObjectDelete("Background");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   ///int li_0 = 0;
   double Ide1 = iRSI(NULL, 0, 14,PRICE_CLOSE, 0);   
   string ls_12 = "RSI   :    ";
   string ls_13 = "   No Signal";
   if (Ide1 > 50) ls_13 = "   Possible Buy";
   if (Ide1 < 50) ls_13 = "   Possible Sell";
   ls_12 = ls_12 + ls_13;
   //-----------------------------------------------------------------------
   string ls_14 = "SAR  :    ";
   string ls_15 = "   No Signal ";
   if (iSAR(NULL, 0, 0.02, 0.2, 0) < Ask ) ls_15 = "   Possible Buy";
   if (iSAR(NULL, 0, 0.02, 0.2, 0) > Ask ) ls_15 = "   Possible Sell";
   ls_14 = ls_14 + ls_15;
   //----------------------------------------------------------------------------------------------------------
   string ls_17 = "   No Signal ";
   if(iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,0) > iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,0)
   && iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,0) > iMA(NULL,0,10,0,MODE_EMA,PRICE_CLOSE,0))
   ls_17 = "   Possible Buy";
   if(iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,0) < iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,0)
   && iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,0) < iMA(NULL,0,10,0,MODE_EMA,PRICE_CLOSE,0))
    ls_17 = "   Possible Sell";
   string ls_16 = "MA   :    ";    
   ls_16 = ls_16 + ls_17;
   //----------------------------------------------------------------------------------------------------------
    string ls_18 = "   No Signal ";
   double main=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   double signal=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);  
   string ls_19 = "MACD:  ";
   if(main > signal && signal >0) ls_18 = "   Possible Buy";
   if(main <signal && signal < 0) ls_18 = "   Possible Sell";
   ls_19 = ls_19 + ls_18;
   //--------------------------------------------------------------------------------------------------------
   double adx= iADX(NULL,0,14,PRICE_CLOSE,0,0);
   double d_p= iADX(NULL,0,14,PRICE_CLOSE,1,0);
   double d_n= iADX(NULL,0,14,PRICE_CLOSE,2,0); 
   string ls_20 = "   No Signal ";
   string ls_21 = "ADX  :    ";
   if(  ( d_p > 20 && adx < 20 && d_n < 20 && adx > d_n)
      ||( d_p > 25 && adx < 25 && d_n < 20 && adx > d_n)
      ||( d_p > 25 && d_n < 20 && adx < 20 && d_n > adx)
      ||( d_p > 25 && adx > 25 && d_n < 20 && d_p > adx) 
      ||( adx > 25 && d_p > 25 && d_n < 15 && adx > d_p)  
      ||( adx > 25 && d_p < 25 && d_n < 20 && d_p > d_n)
      ||( adx > 20 && d_p < 20 && d_n < 20 && d_p > d_n)  )
      ls_20 = "   Possible Buy";
      if(  ( d_n > 20 && adx < 20 && d_p < 20 && adx > d_p)
      ||( d_n > 25 && adx < 25 && d_p < 20 && adx > d_p)
      ||( d_n > 25 && d_p < 20 && adx < 20 && d_p > adx)
      ||( d_n > 25 && adx > 25 && d_p < 20 && d_n > adx) 
      ||( adx > 25 && d_n > 25 && d_p < 15 && adx > d_n)
      ||( adx > 25 && d_n < 25 && d_p < 20 && d_n > d_p)
      ||( adx > 20 && d_n < 20 && d_p < 20 && d_n > d_p)  )
      ls_20 = "   Possible Sell";
      ls_21 = ls_21 + ls_20;
      //-----------------------------------------------------------------------------------------------------------
   string ls_22 = "No Signal";   
   if(ls_13=="   Possible Buy" && ls_15=="   Possible Buy" && ls_17=="   Possible Buy" && ls_18=="   Possible Buy" && ls_20=="   Possible Buy")      
   ls_22 = "OPEN BUY" ;
   if(ls_13=="   Possible Buy" && ls_15=="   Possible Buy" && ls_17=="   Possible Buy" && ls_18=="   Possible Buy" && ls_20=="   Possible Buy" && Time0 != Time[0])
   {
      Alert(Symbol() +  "---"+ DoubleToStr(Bid, Digits) + "---"+"Open Buy");
      Time0 = Time[0];  
   }
   if(ls_13=="   Possible Sell" && ls_15=="   Possible Sell" && ls_17=="   Possible Sell" && ls_18=="   Possible Sell" && ls_20=="   Possible Sell")   
   ls_22 = "OPEN SELL"; 
   if(ls_13=="   Possible Sell" && ls_15=="   Possible Sell" && ls_17=="   Possible Sell" && ls_18=="   Possible Sell" && ls_20=="   Possible Sell" && Time0 != Time[0])
    {
      Alert(Symbol() +  "---"+ DoubleToStr(Ask, Digits) + "---"+"Open Sell");
      Time0 = Time[0];  
   }
   ObjectCreate("Signal", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Signal", ls_22, FontSize, FontType, FontColor);
   ObjectSet("Market_Price_Label", OBJPROP_CORNER, WhatCorner);
   ObjectSet("Signal", OBJPROP_XDISTANCE, xAxis);
   ObjectSet("Signal", OBJPROP_YDISTANCE, yAxis);
   Comment("=====Multi Signal=====","\n",
           ls_12 
           + "\n" 
           + ls_14
           + "\n" 
           + ls_16
           + "\n" 
           + ls_19 
           + "\n" 
           + ls_21      
           + "\n");
//----
   
  }
//+------------------------------------------------------------------+