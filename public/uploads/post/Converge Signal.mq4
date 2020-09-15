//+------------------------------------------------------------------+
//|                                           Convergence Signal.mq4 |
//|                                              Copyright 2013, GVC |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, GVC"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window


extern int    xAxis = 0;
extern int    yAxis = 100;
extern int    FontSize = 20;
extern string FontType = "Arial Bold" ; //"Comic Sans MS";
extern string note2  =  "Default Font Color";
extern color  FontColor  =  Yellow;
extern int    SizeBackGround    = 110;      // Size for background


extern int     AlertCandle         = 1;                                                                                                         //
extern bool    ShowChartAlerts     = false;                                                                                                     //
extern string  AlertEmailSubject   = "";                                                                                                        //
                                                                                                                                                //
datetime       LastAlertTime       = -999999;                                                                                                   //
                                                                                                                                                //
string         AlertTextCrossUp    = "BUY";          //---- type your desired text between the quotes                         //
string         AlertTextCrossDown  = "SELL";        //---- type your desired text between the quotes                         //
                                                                                                                                                //
                                                                                                                                               //
datetime Time0;                    
                                                                                                                                                //
// ============================================================================================================================================ 

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  IndicatorShortName("Converge Signal");
  //ExpertName=IndicatorShortName("Converge Signal");
//---- indicators
  //Background
  if(ObjectFind("Background")==-1)
  {
  ObjectCreate("Background",OBJ_LABEL,0,0,0); 
  ObjectSet("Background",OBJPROP_BACK,FALSE);
  ObjectSet("Background",OBJPROP_YDISTANCE,11);
  ObjectSet("Background",OBJPROP_XDISTANCE,0);
  ObjectSetText("Background","g",SizeBackGround,"Webdings",CadetBlue);
  }
  if(ObjectFind("Background")==-1)
//----
   
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----

   ObjectsDeleteAll(0,OBJ_LABEL);
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
  
   double ibb0 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 0);
   double ibb1 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 0);
   string ls_12 = "BollBands:    ";
   string ls_13 = "   No Signal";
   if (High[0] > ibb0)ls_13= "   Sell";
   if (Low[0] < ibb1) ls_13 = "   Buy";
   ls_12 = ls_12 + ls_13;
   //-----------------------------------------------------------------------
   double ist  = iStochastic(NULL, 0, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 0);
   string ls_14 = "Stoch:         ";
   string ls_15 = "    No Signal ";
   if (ist > 80) ls_15 = "    Sell";
   if (ist < 20) ls_15 = "    Buy";
   ls_14 = ls_14 + ls_15;
   //----------------------------------------------------------------------------------------------------------
   double Irs1 = iRSI(NULL, 0, 14, PRICE_CLOSE, 0);
   string ls_16 = "RSI:            ";
   string ls_17 = "   No Signal ";
   if (Irs1 < 25) ls_17 = "   Buy ";
   if (Irs1 > 75) ls_17 = "   Sell ";
   ls_16 = ls_16 + ls_17;
   //----------------------------------------------------------------------------------------------------------
   double l_iac = iAC(NULL, 0, 0);
   double l_iac1 = iAC(NULL, 0, 1);
   string ls_18 = "AC:            ";
   string ls_19 = "No Signal ";
   if (l_iac1 < l_iac) ls_19 = "    Buy";
   if (l_iac1 > l_iac) ls_19 = "    Sell";
   ls_18 = ls_18 + ls_19;
   
   //---------------------------------------------------------
   string ls_20 = "No Signal";
   
   if (High[0] > ibb0 && ist > 80 && Irs1 > 75) ls_20 = "SELL"; 
   if (High[0] > ibb0 && ist > 80 && Irs1 > 75 && Time0 != Time[0])
   {
      Alert(Symbol() +  "---"+ DoubleToStr(Ask, Digits) + "---"+"Open Sell");
      Time0 = Time[0];  
   }
   if (Low[0] < ibb1 && ist < 20 && Irs1 < 25) ls_20 = "BUY";
   if (Low[0] < ibb1 && ist < 20 && Irs1 < 25 && Time0 != Time[0])
   {
      Alert(Symbol() +  "---"+ DoubleToStr(Bid, Digits) + "---"+"Open Buy");
      Time0 = Time[0];  
   }
   
   ObjectCreate("Signal", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Signal", ls_20, FontSize, FontType, FontColor);
   //ObjectSet("Market_Price_Label", OBJPROP_CORNER, WhatCorner);
   ObjectSet("Signal", OBJPROP_XDISTANCE, xAxis);
   ObjectSet("Signal", OBJPROP_YDISTANCE, yAxis);
    
   Comment("===================","\n",
           ls_12 
           + "\n" 
           + ls_14
           + "\n" 
           + ls_16
            + "\n" 
           + ls_18     
           + "\n");
//----
                                                                                                                                                  //
                                                                                                                              //

   return(0);
  }
//+------------------------------------------------------------------+
 