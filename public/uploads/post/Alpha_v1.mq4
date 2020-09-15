//+------------------------------------------------------------------+
//|                                                        Alpha.mq4 |
//|                      Copyright c 2004, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
//| For Heiken Ashi we recommend next chart settings ( press F8 or   |
//| select on menu 'Charts'->'Properties...'):                       |
//|  - On 'Color' Tab select 'Black' for 'Line Graph'                |
//|  - On 'Common' Tab disable 'Chart on Foreground' checkbox and    |
//|    select 'Line Chart' radiobutton                               |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 White
#property indicator_color3 Red
#property indicator_color4 White
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 3
#property indicator_width4 3

//----
color color1 = Red;
color color2 = White;
color color3 = Red;
color color4 = White;

extern double  alpha=0.04;
extern int     PreSmooth      =  1; // Period of PreSmoothing
extern int     PreSmoothMode  =  0; // PreSmooth MA's Method = 0...3 
double filtonlow[];
double filtonhigh[];

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
//----
int ExtCountedBars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_NONE, 0, 1, color1);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1,DRAW_NONE, 0, 1, color2);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE, 0, 3, color3);
   SetIndexBuffer(2, ExtMapBuffer3);
   SetIndexStyle(3,DRAW_LINE, 0, 3, color4);
   SetIndexBuffer(3, ExtMapBuffer4);
//----
   SetIndexDrawBegin(0,10);
   SetIndexDrawBegin(1,10);
   SetIndexDrawBegin(2,10);
   SetIndexDrawBegin(3,10);
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexBuffer(3,ExtMapBuffer4);
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
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
     //if(pos<10) Print("pos=",pos); 
      double Hi = iMA(NULL,0,PreSmooth,0,PreSmoothMode,2,pos);
      double Lo = iMA(NULL,0,PreSmooth,0,PreSmoothMode,3,pos);
      if(ExtMapBuffer1[pos]==0)ExtMapBuffer1[pos]=Lo;
      if(ExtMapBuffer2[pos]==0)ExtMapBuffer2[pos]=Hi;
      if(ExtMapBuffer1[pos+1]!=0)ExtMapBuffer1[pos]=((1-alpha)*ExtMapBuffer1[pos+1])+(alpha*Lo);
      if(ExtMapBuffer2[pos+1]!=0)ExtMapBuffer2[pos]=((1-alpha)*ExtMapBuffer2[pos+1])+(alpha*Hi); 

      //haOpen=(ExtMapBuffer3[pos+1]+ExtMapBuffer4[pos+1])/2;
      //haClose=(Open[pos]+High[pos]+Low[pos]+Close[pos])/4;
      //haHigh=MathMax(High[pos],MathMax(haOpen, haClose));
      //haLow=MathMin(Low[pos],MathMin(haOpen, haClose));
      /*if (haOpen<haClose) 
        {
         ExtMapBuffer1[pos]=haLow;
         ExtMapBuffer2[pos]=haHigh;
        } 
      else
        {
         ExtMapBuffer1[pos]=haHigh;
         ExtMapBuffer2[pos]=haLow;
        } */
      if(Hi<ExtMapBuffer2[pos] && Lo<ExtMapBuffer1[pos])
      ExtMapBuffer3[pos]=Hi;
      if(Lo>ExtMapBuffer1[pos] && Hi>ExtMapBuffer2[pos])
      ExtMapBuffer4[pos]=Lo;
 	   pos--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+