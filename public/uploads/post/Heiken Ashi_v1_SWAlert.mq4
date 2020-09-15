//+------------------------------------------------------------------+
//|                                          Heiken Ashi_SWAlert.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|               Modififed by Igorad for display in separate window |
//|                                       "http://www.forex-tsd.com/"|
//+------------------------------------------------------------------+
//| For Heiken Ashi we recommend next chart settings ( press F8 or   |
//| select on menu 'Charts'->'Properties...'):                       |
//|  - On 'Color' Tab select 'Black' for 'Line Graph'                |
//|  - On 'Common' Tab disable 'Chart on Foreground' checkbox and    |
//|    select 'Line Chart' radiobutton                               |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_width1 3
#property indicator_color2 White
#property indicator_width2 3
#property indicator_maximum 1.05
#property indicator_minimum -0.05
//#property indicator_color3 Red/
//#property indicator_color4 White
//---- buffers
extern int AlertMode   = 0;
extern int WarningMode = 0;

double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double trend[];
//----
int ExtCountedBars=0;
bool UpTrendAlert=false, DownTrendAlert=false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
int init()
  {
//---- indicators
   IndicatorBuffers(5);
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1, ExtMapBuffer2);
  // SetIndexStyle(2,DRAW_HISTOGRAM, 0, 3, Red);
   SetIndexBuffer(2, ExtMapBuffer3);
  // SetIndexStyle(3,DRAW_HISTOGRAM, 0, 3, White);
   SetIndexBuffer(3, ExtMapBuffer4);
   SetIndexBuffer(4,trend);
//----
   SetIndexDrawBegin(0,10);
   SetIndexDrawBegin(1,10);
   //SetIndexDrawBegin(2,10);
   //SetIndexDrawBegin(3,10);
//---- indicator buffers mapping
   //SetIndexBuffer(0,ExtMapBuffer1);
   //SetIndexBuffer(1,ExtMapBuffer2);
   //SetIndexBuffer(2,ExtMapBuffer3);
   //SetIndexBuffer(3,ExtMapBuffer4);
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   double haOpen, haHigh, haLow, haClose;
   if(Bars<=10) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
   int pos=Bars-ExtCountedBars-1;
   while(pos>=0)
     {
      haOpen=(ExtMapBuffer3[pos+1]+ExtMapBuffer4[pos+1])/2;
      haClose=(Open[pos]+High[pos]+Low[pos]+Close[pos])/4;
      haHigh=MathMax(High[pos], MathMax(haOpen, haClose));
      haLow=MathMin(Low[pos], MathMin(haOpen, haClose));
      trend[pos]=trend[pos+1];
      if (haOpen<haClose) 
        {
         trend[pos]=1;
         ExtMapBuffer1[pos]=0;
         ExtMapBuffer2[pos]=1;
         if (WarningMode>0 && pos==0 && trend[1]<0) PlaySound("alert2.wav");
        } 
      else
        {
         trend[pos]=-1;
         ExtMapBuffer1[pos]=1;
         ExtMapBuffer2[pos]=0;
         if (WarningMode>0 && pos==0 && trend[1]>0) PlaySound("alert2.wav");
        } 
      ExtMapBuffer3[pos]=haOpen;
      ExtMapBuffer4[pos]=haClose;
 	   pos--;
     }
//----------   
   string Message;
   
   if ( trend[2]<0 && trend[1]>0 && Volume[0]>1 && !UpTrendAlert)
	  {
	  Message = " "+Symbol()+" M"+Period()+": Signal for BUY";
	  if ( AlertMode>0 ) Alert (Message); 
	  UpTrendAlert=true; DownTrendAlert=false;
	  } 
	 	  
	  if ( trend[2]>0 && trend[1]<0 && Volume[0]>1 && !DownTrendAlert)
	  {
	  Message = " "+Symbol()+" M"+Period()+": Signal for SELL";
	  if ( AlertMode>0 ) Alert (Message); 
	  DownTrendAlert=true; UpTrendAlert=false;
	  } 	         
//----
   return(0);
  }
//+------------------------------------------------------------------+