//+------------------------------------------------------------------+
//|                                  Custom candles - by numbers.mq4 |
//+------------------------------------------------------------------+
#property copyright "mladen"
#property link      "mladenfx@gmail.com"

#property indicator_chart_window

//
//
//
//
//

extern int    NumebrOfBarsPerCandle   = 10;
extern string TimeOfAncoredBar        = "2010.09.01 00:00";
extern color  UpCandleColor           = DeepSkyBlue;
extern color  DownCandleColor         = Red;
extern color  NeutralCandleColor      = DimGray;
extern int    DrawingWidth            = 1;
extern bool   FilledCandles           = false;
extern string UniqueCandlesIdentifier = "CustomCandleByNo";

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

int init()   {                  return(0); }
int deinit() { deleteCandles(); return(0); }

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
   
   for (i=limit; i>= 0; i--)
   {
      int startBarShift  = iBarShift(NULL,0,StrToTime(TimeOfAncoredBar));
      int startOfThisBar = startBarShift-NumebrOfBarsPerCandle*MathFloor((startBarShift-i)/NumebrOfBarsPerCandle);
      
         //
         //
         //
         //
         //
         
         datetime startTime  = Time[startOfThisBar];
         datetime endTime    = Time[startOfThisBar];
         double   openPrice  = Open[startOfThisBar];
         double   closePrice = Close[startOfThisBar];
         double   highPrice  = High[startOfThisBar];
         double   lowPrice   = Low[startOfThisBar];
         
            for (int k=1; k<NumebrOfBarsPerCandle && (startOfThisBar-k)>=0; k++)
               {
                  endTime    = Time[startOfThisBar-k];
                  closePrice = Close[startOfThisBar-k];
                  highPrice  = MathMax(highPrice,High[startOfThisBar-k]);
                  lowPrice   = MathMin(lowPrice,Low[startOfThisBar-k]);
               }
               endTime += (NumebrOfBarsPerCandle-k)*Period()*60;

         //
         //
         //
         //
         //
         
         drawCandle(startTime,endTime,openPrice,closePrice,highPrice,lowPrice);
   }

   //
   //
   //
   //
   //
   
   Comment("Current "+Symbol()+" "+NumebrOfBarsPerCandle+" bars candle : ",DoubleToStr(openPrice,Digits),",",DoubleToStr(closePrice,Digits),",",DoubleToStr(highPrice,Digits),",",DoubleToStr(lowPrice,Digits));
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
      
      string   wname = name+":+";
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