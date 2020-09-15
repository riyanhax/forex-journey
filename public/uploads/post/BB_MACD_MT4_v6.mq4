//+------------------------------------------------------------------+
//|                                                  BB_MACD_MT4.mq4 |
//|                      Copyright © 2009, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""

#property indicator_separate_window
#property  indicator_buffers 7


//#property  indicator_color1  Silver    //ExtADXBuffer Histogram
#property  indicator_color1  Lime      //ExtMACDDeltaUpTrendBuffer MACD Signal Uptrend Dots
#property  indicator_color2  Red       //ExtMACDDeltaUpTrendBuffer MACD Signal Downtrend Dots
#property  indicator_color3  Black     //ExtMACDSignalBuffer
#property  indicator_color4  Blue      //ExtUpperBand
#property  indicator_color5  Red       //ExtLowerBand
#property  indicator_color6  Lime      //ExtBB_MACD_UP_SignalBuffer
#property  indicator_color7  Red       //ExtBB_MACD_DOWN_SignalBuffer


/* RP Settings
#property  indicator_color1  Silver    //ExtADXBuffer Histogram
#property  indicator_color2  Lime      //ExtMACDDeltaUpTrendBuffer MACD Signal Uptrend Dots
#property  indicator_color3  Red       //ExtMACDDeltaUpTrendBuffer MACD Signal Downtrend Dots
#property  indicator_color4  Blue      //ExtMACDSignalBuffer
#property  indicator_color5  Lime      //ExtUpperBand
#property  indicator_color6  Red      //ExtLowerBand
#property  indicator_color7  Lime      //ExtBB_MACD_UP_SignalBuffer
#property  indicator_color8  Red       //ExtBB_MACD_DOWN_SignalBuffer
*/

//---- input parameters
extern int       TimeFrame = 0;
extern int       FastEMA=12;
extern int       SlowEMA=26;  
extern int       SignalSMA=10;
extern int       ADXPeriod=16;
extern double    StdDev=1.0;
//extern double    HistogramAdjuster=0;
extern bool      ShowDots=true;

//---- indicator buffers
//double ExtADXBuffer[];
double ExtMACDDeltaUpTrendBuffer[];
double ExtMACDDeltaDownTrendBuffer[];
double ExtMACDSignalBuffer[];
double ExtUpperBand[];
double ExtLowerBand[];
double ExtBB_MACD_UP_SignalBuffer[];
double ExtBB_MACD_DOWN_SignalBuffer[];
double MACDDeltaArray[];

double PointStdDev = 0.0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   //Changes Indicator Style according to ShowDots
   
   int            macdDrawType = DRAW_LINE;  
   if (ShowDots)  {
                  macdDrawType = DRAW_ARROW;  
   }
  
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+1);

   IndicatorBuffers(8);

   /*
   SetIndexBuffer(0, ExtADXBuffer);
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,1);
   SetIndexLabel(0,"Histogram");
   */

   SetIndexBuffer(0, ExtMACDDeltaUpTrendBuffer);
   SetIndexStyle(0,macdDrawType,STYLE_SOLID,1);
   SetIndexArrow(0,108);
   SetIndexLabel(0,"MACD DELTA UP");

   SetIndexBuffer(1, ExtMACDDeltaDownTrendBuffer);
   SetIndexStyle(1,macdDrawType,STYLE_SOLID,1);
   SetIndexArrow(1,108);
   SetIndexLabel(1,"MACD DELTA DN");

   SetIndexBuffer(2, ExtMACDSignalBuffer);
   SetIndexStyle(2,DRAW_LINE,STYLE_DASHDOTDOT,1);
   SetIndexDrawBegin(2,SignalSMA);
   SetIndexLabel(2,"MACD SIGNAL");

   SetIndexBuffer(3, ExtUpperBand);
   SetIndexLabel(3,"MACD SIGNAL Upper Band");

   SetIndexBuffer(4, ExtLowerBand);
   SetIndexLabel(4,"MACD SIGNAL Lower Band");

   SetIndexBuffer(5, ExtBB_MACD_UP_SignalBuffer);
   SetIndexStyle(5,DRAW_ARROW,STYLE_SOLID,1);
   SetIndexArrow(5,115);
   SetIndexLabel(5,"BB_MACD UP");

   SetIndexBuffer(6, ExtBB_MACD_DOWN_SignalBuffer);
   SetIndexStyle(6,DRAW_ARROW,STYLE_SOLID,1);
   SetIndexArrow(6,115);
   SetIndexLabel(6,"BB_MACD DN");

   SetIndexBuffer(7, MACDDeltaArray);


   IndicatorShortName("BB_MACD_MT4_v6("+getTimeFrameName(TimeFrame)+","+FastEMA+","+SlowEMA+","+SignalSMA+","+ADXPeriod+","+StdDev+")");

   if (TimeFrame!=0) SignalSMA = SignalSMA * (TimeFrame/Period());

   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   // Plot defined time frame on to current time frame
   datetime TimeArray[];
   ArrayCopySeries(TimeArray,MODE_TIME,Symbol(),TimeFrame); 
   int i,y;
  
   //limit = limit + SignalSMA;

//---- macd counted in the 1-st buffer
   for(i=0, y=0;i<limit;i++)  {
      if (Time[i]<TimeArray[y]) y++;
      
       MACDDeltaArray[i]=(iMA(NULL,TimeFrame,FastEMA,0,MODE_EMA,PRICE_CLOSE,y)-iMA(NULL,TimeFrame,SlowEMA,0,MODE_EMA,PRICE_CLOSE,y));
       
   }
//---- signal line counted in the 2-nd buffer
   for(i=0, y=0;i<limit;i++)  {
      if (Time[i]<TimeArray[y]) y++;
      //XAverage
      ExtMACDSignalBuffer[i]=iMAOnArray(MACDDeltaArray,0,SignalSMA,0,MODE_EMA,i);
      
      PointStdDev = iStdDevOnArray(MACDDeltaArray,0,SignalSMA,MODE_EMA,0,i);

      ExtUpperBand[i]=ExtMACDSignalBuffer[i] + (StdDev * PointStdDev);
      ExtLowerBand[i]=ExtMACDSignalBuffer[i] - (StdDev * PointStdDev);
      
      
      //Only used to ajust the scale of the ADX Buffer to
      //the MACD lines according to the timeframe
      /*
      double ScaleAdjuster = HistogramAdjuster*50000/(0.0+Period()); 
      double adx = iADX(NULL,TimeFrame,ADXPeriod,PRICE_CLOSE,MODE_MAIN,y);
      ExtADXBuffer[i]=ScaleAdjuster*(MACDDeltaArray[i] - ExtMACDSignalBuffer[i])*(ExtUpperBand[i] - ExtLowerBand[i])*adx*MathAbs(MACDDeltaArray[i]);
      */
      
      ExtMACDDeltaUpTrendBuffer[i]     = EMPTY_VALUE;
      ExtMACDDeltaDownTrendBuffer[i]   = EMPTY_VALUE;
      ExtBB_MACD_UP_SignalBuffer[i]    = EMPTY_VALUE;
      ExtBB_MACD_DOWN_SignalBuffer[i]  = EMPTY_VALUE;
           
      //Paints the MACD Delta Line for UP and DOWN Trends
      if (MACDDeltaArray[i]<MACDDeltaArray[i+1]) {
         ExtMACDDeltaDownTrendBuffer[i]   = MACDDeltaArray[i];
         ExtBB_MACD_DOWN_SignalBuffer[i]  = MACDDeltaArray[i];
      }
      
      if (MACDDeltaArray[i]>MACDDeltaArray[i+1]) {
         ExtMACDDeltaUpTrendBuffer[i]  =MACDDeltaArray[i];
         ExtBB_MACD_UP_SignalBuffer[i] =MACDDeltaArray[i];
      }
      
      if (MACDDeltaArray[i]==MACDDeltaArray[i+1]) {
         if (ExtMACDDeltaUpTrendBuffer[i+1]   ==EMPTY_VALUE)  ExtMACDDeltaUpTrendBuffer[i]=EMPTY_VALUE;
         if (ExtBB_MACD_UP_SignalBuffer[i+1]  ==EMPTY_VALUE)  ExtBB_MACD_UP_SignalBuffer[i]=EMPTY_VALUE;
         if (ExtMACDDeltaDownTrendBuffer[i+1] ==EMPTY_VALUE)  ExtMACDDeltaDownTrendBuffer[i]=EMPTY_VALUE;
         if (ExtBB_MACD_DOWN_SignalBuffer[i+1]==EMPTY_VALUE)  ExtBB_MACD_DOWN_SignalBuffer[i] = EMPTY_VALUE;
      }
      
      //Shows the UP SIGNALS
      if (ExtMACDDeltaUpTrendBuffer[i]>ExtUpperBand[i] || ExtBB_MACD_UP_SignalBuffer[i]>ExtUpperBand[i]) ExtMACDDeltaUpTrendBuffer[i]=EMPTY_VALUE;
      if (ExtBB_MACD_UP_SignalBuffer[i]<=ExtUpperBand[i] && ExtBB_MACD_UP_SignalBuffer[i]>=ExtLowerBand[i]) ExtBB_MACD_UP_SignalBuffer[i]=EMPTY_VALUE; 
      if (ExtMACDDeltaDownTrendBuffer[i]>ExtUpperBand[i]) ExtMACDDeltaDownTrendBuffer[i]=EMPTY_VALUE; 
      
      
      //Shows the DOWN SIGNALS
      if (ExtMACDDeltaDownTrendBuffer[i]<ExtLowerBand[i] || ExtBB_MACD_DOWN_SignalBuffer[i]<ExtLowerBand[i]) ExtMACDDeltaDownTrendBuffer[i]=EMPTY_VALUE;
      if (ExtBB_MACD_DOWN_SignalBuffer[i]>=ExtLowerBand[i] && ExtBB_MACD_DOWN_SignalBuffer[i]<=ExtUpperBand[i]) ExtBB_MACD_DOWN_SignalBuffer[i]=EMPTY_VALUE;
      if (ExtMACDDeltaUpTrendBuffer[i]<ExtLowerBand[i]) ExtMACDDeltaUpTrendBuffer[i]=EMPTY_VALUE; 
      
      
   }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+
string getTimeFrameName(int TimeFrame){
   string TimeFrameStr ="";

   if(TimeFrame==0) TimeFrame = Period();
   switch(TimeFrame)
   {
      case 1 : TimeFrameStr="Period_M1"; break;
      case 5 : TimeFrameStr="M5"; break;
      case 15 : TimeFrameStr="M15"; break;
      case 30 : TimeFrameStr="M30"; break;
      case 60 : TimeFrameStr="H1"; break;
      case 240 : TimeFrameStr="H4"; break;
      case 1440 : TimeFrameStr="D1"; break;
      case 10080 : TimeFrameStr="W1"; break;
      case 43200 : TimeFrameStr="MN1"; break;
      default : TimeFrameStr="TF";
   }
   return (TimeFrameStr);
}