
#property copyright "GVC"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#define  NL    "\n"
extern int    WhatCorner = 3;
extern int    xAxis = 300;
extern int    yAxis = 10;
extern int    FontSize = 20;
extern string FontType = "Arial Bold" ; //"Comic Sans MS";
extern string note2  =  "Default Font Color";
extern color  FontColor  =  Blue;
extern color  FontColorUp  =  Lime;  
extern color  FontColorDn  =  Red; 

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
 ObjectsDeleteAll();  
  ObjectsDeleteAll(0,OBJ_LABEL); 
  ObjectDelete("Market_Price_Label");  
  Comment ("");
   return(0);
  
  }
  
//------------------------------------------------------------------------------------ 
 
   int    GetProfitOpenPosInPoint(string sy="", int op=-1, int mn=-1) {
  double p;
  int    i, k=OrdersTotal(), pr=0;

  if     (sy=="0") sy=Symbol();
  for    (i=0; i<k; i++) {
  if     (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
  if     ((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op)) {
  if     (mn<0 || OrderMagicNumber()==mn) {
         p=MarketInfo(OrderSymbol(), MODE_POINT);
  if     (p==0) if (StringFind(OrderSymbol(), "JPY")<0) p=0.0001; else p=0.01;
  if     (OrderType()==OP_BUY) {
         pr+=(MarketInfo(OrderSymbol(), MODE_BID)-OrderOpenPrice())/p;
  }
  if (OrderType()==OP_SELL) {
         pr+=(OrderOpenPrice()-MarketInfo(OrderSymbol(), MODE_ASK))/p;
  } } } } }
  return (pr);
  }
   
   
  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
   
  {
   int    counted_bars=IndicatorCounted();
 if (OrdersTotal()==0) 
   {
      Comment("No trades to monitor");
      return;
   }   
   
   double   tu=GetProfitOpenPosInPoint     ();
   double PipsProfit=GetProfitOpenPosInPoint();
     
  // string ScreenMessage;
 //Comment("Profit = ", PipsProfit, NL);
 
 string Market_Price='';
 Market_Price = StringConcatenate("PipsProfit = ",DoubleToStr (tu/MathPow(10,DecPts()), DecPts()),"\n");

if (PipsProfit > 0) FontColor = FontColorUp;
    if (PipsProfit < 0) FontColor = FontColorDn;
    if (PipsProfit ==0) FontColor = FontColor;   

     
   ObjectCreate("Market_Price_Label", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Market_Price_Label", Market_Price, FontSize, FontType, FontColor);
   ObjectSet("Market_Price_Label", OBJPROP_CORNER, WhatCorner);
   ObjectSet("Market_Price_Label", OBJPROP_XDISTANCE, xAxis);
   ObjectSet("Market_Price_Label", OBJPROP_YDISTANCE, yAxis);
   
 
 
   return(0);
  }
  int DecPts() {

 if (Digits==3 || Digits==5) 
    return(1); 
  else if (Digits==2 || Digits==4) 
    return(0); 
  else
    return(0);            
} // end funcion()
  
//+------------------------------------------------------------------+