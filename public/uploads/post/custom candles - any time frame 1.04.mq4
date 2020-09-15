//+------------------------------------------------------------------+
//|                              Custom candles - any time frame.mq4 |
//+------------------------------------------------------------------+
#property copyright "mladen"
#property link      "mladenfx@gmail.com"

#property indicator_chart_window

//
//
//
//
//

enum timeFrames
{
   tf_cu,         // Current time frame
   tf_m1,         // 1 minute
   tf_m2,         // 2 minutes
   tf_m3,         // 3 minutes
   tf_m4,         // 4 minutes
   tf_m5,         // 5 minutes
   tf_m6,         // 6 minutes
   tf_m10 =10,    // 10 minutes
   tf_m12 =12,    // 12 minutes
   tf_m15 =15,    // 15 minutes
   tf_m20 =20,    // 20 minutes
   tf_m30 =30,    // 30 minutes
   tf_h1  =60,    // 1 hour
   tf_h2  =120,   // 2 hours
   tf_h3  =180,   // 3 hours
   tf_h4  =240,   // 4 hours
   tf_h6  =360,   // 6 hours
   tf_h8  =480,   // 8 hours
   tf_h12 =720,   // 12 hours
   tf_d1  =1440,  // daily
   tf_w1  =10080, // weekly
   tf_mn  =43200  // monthly
};
extern timeFrames TimeFrame               = tf_cu;
extern color      UpCandleColor           = DeepSkyBlue;
extern color      DownCandleColor         = Red;
extern color      NeutralCandleColor      = DimGray;
extern int        DrawingWidth            = 1;
extern bool       FilledCandles           = false;
extern bool       BoxedWick               = false;
extern string     UniqueCandlesIdentifier = "CustomCandleAny";
extern int        barsToDraw              = 0;

//
//
//
//
//

int timeFrame;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

int init()
{
   timeFrame = MathMax(TimeFrame,_Period);
         if (MathFloor(timeFrame/Period())*Period() != timeFrame) timeFrame = Period();
   return(0);
}
int deinit() { deleteCandles(); Comment(""); return(0); }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

int start()
{
   static int oldBars = 0;
   int counted_bars=IndicatorCounted();
   int i,limit;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
           limit=MathMin(Bars-counted_bars,Bars-1);
           if (oldBars!=Bars)
           {
               deleteCandles();
                  oldBars = Bars;
                  limit   = Bars-1;
           }               

   //
   //
   //
   //
   //
   
   int barsToDisplay = barsToDraw; if (barsToDisplay<=0) barsToDisplay=Bars;
   for (i=limit; i>= 0; i--)
   {
      datetime startingTime;
      int      barsPassed;
      int      startOfThisBar;

         while (true)
         {
            if (timeFrame<60)
            {
               startingTime   = StrToTime(TimeToStr(Time[i],TIME_DATE)+toHour(TimeHour(Time[i])));
               barsPassed     = MathFloor((Time[i]-startingTime)/(timeFrame*60));
               startOfThisBar = iBarShift(NULL,0,startingTime+barsPassed*timeFrame*60);
               break;
            }
            if (timeFrame<1440)
            {
               startingTime   = StrToTime(TimeToStr(Time[i],TIME_DATE)+" 00:00");
               barsPassed     = MathFloor((Time[i]-startingTime)/(timeFrame*60));
               startOfThisBar = iBarShift(NULL,0,startingTime+barsPassed*timeFrame*60);
               break;
            }
            startingTime   = iTime(NULL,timeFrame,iBarShift(NULL,timeFrame,Time[i]));
            startOfThisBar = iBarShift(NULL,0,startingTime);
            break;
         }         

         //
         //
         //
         //
         //
         
            datetime startTime  = Time[startOfThisBar];
            datetime endTime    = startTime+(timeFrame-1)*60;
            double   openPrice  = Open[startOfThisBar];
            double   closePrice = Close[startOfThisBar];
            double   highPrice  = High[startOfThisBar];
            double   lowPrice   = Low[startOfThisBar];
         
            for (int k=1; Time[startOfThisBar-k]>0 && Time[startOfThisBar-k]<=endTime; k++)
               {
                  closePrice = Close[startOfThisBar-k];
                  highPrice  = MathMax(highPrice,High[startOfThisBar-k]);
                  lowPrice   = MathMin(lowPrice,Low[startOfThisBar-k]);
               }

         //
         //
         //
         //
         //
         
         if (i<barsToDisplay) drawCandle(startTime,endTime,openPrice,closePrice,highPrice,lowPrice);
   }

   //
   //
   //
   //
   //
   
   Comment("Current "+Symbol()+" "+timeFrameToString(timeFrame)+" candle : ",DoubleToStr(openPrice,Digits),",",DoubleToStr(highPrice,Digits),",",DoubleToStr(lowPrice,Digits),",",DoubleToStr(closePrice,Digits));
   return(0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

string toHour(int hour)
{
   if (hour<10)
         return(" 0"+hour+":00");
   else  return(" " +hour+":00");
}

//
//
//
//
//

void deleteCandles()
{
   int searchLength = StringLen(UniqueCandlesIdentifier);
   for (int i=ObjectsTotal()-1; i>=0; i--)
   {
      string name = ObjectName(i);
         if (StringSubstr(name,0,searchLength) == UniqueCandlesIdentifier)  ObjectDelete(name);
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

void drawCandle(datetime startTime, datetime endTime, double openPrice, double closePrice, double highPrice, double lowPrice)
{
   color candleColor = NeutralCandleColor;
   
      if (closePrice>openPrice) candleColor = UpCandleColor;
      if (closePrice<openPrice) candleColor = DownCandleColor;

   //
   //
   //
   //
   //
         
      string name = UniqueCandlesIdentifier+":"+startTime;
      if (ObjectFind(name)==-1)
          ObjectCreate(name,OBJ_RECTANGLE,0,startTime,openPrice,endTime,closePrice);
             ObjectSet(name,OBJPROP_PRICE1,openPrice);
             ObjectSet(name,OBJPROP_PRICE2,closePrice);
             ObjectSet(name,OBJPROP_TIME1 ,startTime);
             ObjectSet(name,OBJPROP_TIME2 ,endTime);
             ObjectSet(name,OBJPROP_COLOR ,candleColor);
             ObjectSet(name,OBJPROP_STYLE ,STYLE_SOLID);
             ObjectSet(name,OBJPROP_BACK  ,FilledCandles);
             ObjectSet(name,OBJPROP_WIDTH ,DrawingWidth);
             
      //
      //
      //
      //
      //
                   
      datetime wickTime = startTime+(endTime-startTime)/2;
      double   upPrice  = MathMax(closePrice,openPrice);
      double   dnPrice  = MathMin(closePrice,openPrice);
      
      if (BoxedWick)
      {
         string   wname = name+":+";
         if (ObjectFind(wname)==-1)
             ObjectCreate(wname,OBJ_RECTANGLE,0,startTime,highPrice,endTime,lowPrice);
                ObjectSet(wname,OBJPROP_PRICE1,highPrice);
                ObjectSet(wname,OBJPROP_PRICE2,lowPrice);
                ObjectSet(wname,OBJPROP_TIME1 ,startTime);
                ObjectSet(wname,OBJPROP_TIME2 ,endTime);
                ObjectSet(wname,OBJPROP_COLOR ,candleColor);
                ObjectSet(wname,OBJPROP_STYLE ,STYLE_SOLID);
                ObjectSet(wname,OBJPROP_BACK  ,false);
                ObjectSet(wname,OBJPROP_WIDTH ,DrawingWidth);
      }
      else
      {
         wname = name+":+";
         if (ObjectFind(wname)==-1)
             ObjectCreate(wname,OBJ_TREND,0,wickTime,highPrice,wickTime,upPrice);
                ObjectSet(wname,OBJPROP_PRICE1,highPrice);
                ObjectSet(wname,OBJPROP_PRICE2,upPrice);
                ObjectSet(wname,OBJPROP_TIME1 ,wickTime);
                ObjectSet(wname,OBJPROP_TIME2 ,wickTime);
                ObjectSet(wname,OBJPROP_COLOR ,candleColor);
                ObjectSet(wname,OBJPROP_STYLE ,STYLE_SOLID);
                ObjectSet(wname,OBJPROP_RAY   ,false);
                ObjectSet(wname,OBJPROP_WIDTH ,DrawingWidth);

         wname = name+":-";
         if (ObjectFind(wname)==-1)
             ObjectCreate(wname,OBJ_TREND,0,wickTime,dnPrice,wickTime,lowPrice);
                ObjectSet(wname,OBJPROP_PRICE1,dnPrice);
                ObjectSet(wname,OBJPROP_PRICE2,lowPrice);
                ObjectSet(wname,OBJPROP_TIME1 ,wickTime);
                ObjectSet(wname,OBJPROP_TIME2 ,wickTime);
                ObjectSet(wname,OBJPROP_COLOR ,candleColor);
                ObjectSet(wname,OBJPROP_STYLE ,STYLE_SOLID);
                ObjectSet(wname,OBJPROP_RAY   ,false);
                ObjectSet(wname,OBJPROP_WIDTH ,DrawingWidth);
      }                
}

//+-------------------------------------------------------------------
//|                                                                  
//+-------------------------------------------------------------------
//
//
//
//
//

string sTfTable[] = {"M1","M2","M3","M4","M5","M6","M10","M12","M15","M20","M30","H1","H2","H3","H4","H6","H8","H12","D1","W1","MN"};
int    iTfTable[] = {1,2,3,4,5,6,10,12,15,20,30,60,120,180,240,360,480,720,1440,10080,43200};

string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}