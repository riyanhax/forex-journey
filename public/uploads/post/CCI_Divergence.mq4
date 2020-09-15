//+--------------------------------------------------------------------------------------+
//|                                                     Complex_pair_Divergence_V1.0.mq4 |
//|   based on Complex_pairs1.mq4 by Simeon Semonych and FX5_MACD_divergence_V1.1 by hazem@uk2.net|
//|   cooked them together by Finimej                                                    |
//+--------------------------------------------------------------------------------------+
#property copyright "Copyright © 2009, Finimej"
#property link      "http://onix-trade.net/forum/index.php?showtopic=107"
//----
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_color4 Magenta
#property  indicator_level1  0.0
#property  indicator_levelcolor  Black
#property  indicator_levelstyle  STYLE_DOT
//----
#define arrowsDisplacement 0.0001
//---- input parameters
extern string separator1 = "*** Indicator Settings ***";
extern bool   drawIndicatorTrendLines = true;
extern bool   drawPriceTrendLines = true;
extern bool   displayAlert = true;
//---- buffers
double bullishDivergence[];
double bearishDivergence[];
double pair[];
double signal[];
//----
static datetime lastAlertTime;
static string   indicatorName;
//---- parameters
// for monthly
int mn_per = 12;
int mn_fast = 3;
// for weekly
int w_per = 9;
int w_fast = 3;
// for daily
int d_per = 5;
int d_fast = 3;
// for H4
int h4_per = 12;
int h4_fast = 2;
// for H1
int h1_per = 24;
int h1_fast = 8;
// for M30
int m30_per = 16;
int m30_fast = 2;
// for M15
int m15_per = 16;
int m15_fast = 4;
// for M5
int m5_per = 12;
int m5_fast = 3;
// for M1
int m1_per = 30;
int m1_fast = 10;
int per1, per2;
int    signalSMA = 9;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexStyle(2, DRAW_LINE,STYLE_SOLID,2);
   SetIndexStyle(3, DRAW_LINE,STYLE_SOLID,1);
//----   
   SetIndexBuffer(0, bullishDivergence);
   SetIndexLabel(0, bullishDivergence);
   SetIndexBuffer(1, bearishDivergence);
   SetIndexLabel(1, bearishDivergence);
   SetIndexBuffer(2, pair);
   SetIndexLabel(2, Symbol()); 
   SetIndexBuffer(3, signal);   
   SetIndexLabel(3, signal); 
//----   
   SetIndexArrow(0, 233);
   SetIndexArrow(1, 234);
//----
 switch(Period())
     {
       case 1:     per1 = m1_per;  per2 = m1_fast;  break;
       case 5:     per1 = m5_per;  per2 = m5_fast;  break;
       case 15:    per1 = m15_per; per2 = m15_fast; break;
       case 30:    per1 = m30_per; per2 = m30_fast; break;
       case 60:    per1 = h1_per;  per2 = h1_fast;  break;
       case 240:   per1 = h4_per;  per2 = h4_fast;  break;
       case 1440:  per1 = d_per;   per2 = d_fast;   break;
       case 10080: per1 = w_per;   per2 = w_fast;   break;
       case 43200: per1 = mn_per;  per2 = mn_fast;  break;
     }
   indicatorName = "CC_Divergence_v1.0 "+Symbol() + "(" + Period() +", fast MA "+ per2  + ")";
   SetIndexDrawBegin(3, signalSMA);
   IndicatorDigits(Digits + 2);
   IndicatorShortName(indicatorName);

   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   for(int i = ObjectsTotal() - 1; i >= 0; i--)
     {
       string label = ObjectName(i);
       if(StringSubstr(label, 0, 19) != "pair_DivergenceLine")
           continue;
       ObjectDelete(label);   
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int countedBars = IndicatorCounted();
   if(countedBars < 0)
       countedBars = 0;
   CalculateIndicator(countedBars);
//---- 
   RefreshRates();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double pp(int Mode, int Price, int i, int per1, int per2)
  {
   return((iMA(Symbol(), 0, per2, 0, Mode,Price, i)-
           iMA(Symbol(), 0, per1, 0, Mode,Price, i)));
  } 
void CalculateIndicator(int countedBars)
  {
   for(int i = Bars - countedBars; i >= 0; i--)
     {
       Calculatepair(i);
       CatchBullishDivergence(i + 2);
       CatchBearishDivergence(i + 2);
     }              
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Calculatepair(int i)
  {
   int limit;
   int counted_bars = IndicatorCounted();
   double OPEN, HIGH, LOW, CLOSE;
//---- проверка на возможные ошибки
   if(counted_bars < 0) 
       return(-1);
//---- последний посчитанный бар будет пересчитан
   if(counted_bars > 0) 
       counted_bars -= 10;
   limit = Bars - counted_bars;
//---- основной цикл
   int Price = 6;
   int Mode = 3;


       OPEN = pp(Mode, PRICE_OPEN, i, per1, per2);
       HIGH = pp(Mode, PRICE_HIGH, i, per1, per2);
       LOW = pp(Mode, PRICE_LOW, i, per1, per2);
       CLOSE = pp(Mode, PRICE_CLOSE, i, per1, per2);
       pair[i] = (OPEN + HIGH + LOW + CLOSE) / 4;

   if (i==limit-1)
   signal[i] =(pair[limit]); 
   else
   signal[i] = (pair[i]+pair[i+1])/2; 

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CatchBullishDivergence(int shift)
  {
   if(IsIndicatorTrough(shift) == false)
       return;  
   int currentTrough = shift;
   int lastTrough = GetIndicatorLastTrough(shift);
//----   
   if(pair[currentTrough] > pair[lastTrough] && 
      Low[currentTrough] < Low[lastTrough])
     {
       bullishDivergence[currentTrough] = pair[currentTrough] - 
                                          arrowsDisplacement;
       //----
       if(drawPriceTrendLines == true)
           DrawPriceTrendLine(Time[currentTrough], Time[lastTrough], 
                              Low[currentTrough], 
                             Low[lastTrough], Green, STYLE_SOLID);
       //----
       if(drawIndicatorTrendLines == true)
          DrawIndicatorTrendLine(Time[currentTrough], 
                                 Time[lastTrough], 
                                 pair[currentTrough],
                                 pair[lastTrough], 
                                 Green, STYLE_SOLID);
       //----
       if(displayAlert == true)
          DisplayAlert("Classical bullish divergence on: ", 
                        currentTrough);  
     }
//----   
   if(pair[currentTrough] < pair[lastTrough] && 
      Low[currentTrough] > Low[lastTrough])
     {
       bullishDivergence[currentTrough] = pair[currentTrough] - 
                                          arrowsDisplacement;
       //----
       if(drawPriceTrendLines == true)
           DrawPriceTrendLine(Time[currentTrough], Time[lastTrough], 
                              Low[currentTrough], 
                              Low[lastTrough], Green, STYLE_DOT);
       //----
       if(drawIndicatorTrendLines == true)                            
           DrawIndicatorTrendLine(Time[currentTrough], 
                                  Time[lastTrough], 
                                  pair[currentTrough],
                                  pair[lastTrough], 
                                  Green, STYLE_DOT);
       //----
       if(displayAlert == true)
           DisplayAlert("Reverse bullish divergence on: ", 
                        currentTrough);   
     }      
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CatchBearishDivergence(int shift)
  {
   if(IsIndicatorPeak(shift) == false)
       return;
   int currentPeak = shift;
   int lastPeak = GetIndicatorLastPeak(shift);
//----   
   if(pair[currentPeak] < pair[lastPeak] && 
      High[currentPeak] > High[lastPeak])
     {
       bearishDivergence[currentPeak] = pair[currentPeak] + 
                                        arrowsDisplacement;
      
       if(drawPriceTrendLines == true)
           DrawPriceTrendLine(Time[currentPeak], Time[lastPeak], 
                              High[currentPeak], 
                              High[lastPeak], Red, STYLE_SOLID);
                            
       if(drawIndicatorTrendLines == true)
           DrawIndicatorTrendLine(Time[currentPeak], Time[lastPeak], 
                                  pair[currentPeak],
                                  pair[lastPeak], Red, STYLE_SOLID);

       if(displayAlert == true)
           DisplayAlert("Classical bearish divergence on: ", 
                        currentPeak);  
     }
   if(pair[currentPeak] > pair[lastPeak] && 
      High[currentPeak] < High[lastPeak])
     {
       bearishDivergence[currentPeak] = pair[currentPeak] + 
                                        arrowsDisplacement;
       //----
       if(drawPriceTrendLines == true)
           DrawPriceTrendLine(Time[currentPeak], Time[lastPeak], 
                              High[currentPeak], 
                              High[lastPeak], Red, STYLE_DOT);
       //----
       if(drawIndicatorTrendLines == true)
           DrawIndicatorTrendLine(Time[currentPeak], Time[lastPeak], 
                                  pair[currentPeak],
                                  pair[lastPeak], Red, STYLE_DOT);
       //----
       if(displayAlert == true)
           DisplayAlert("Reverse bearish divergence on: ", 
                        currentPeak);   
     }   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsIndicatorPeak(int shift)
  {
   if(pair[shift] >= pair[shift+1] && pair[shift] > pair[shift+2] && 
      pair[shift] > pair[shift-1])
       return(true);
   else 
       return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsIndicatorTrough(int shift)
  {
   if(pair[shift] <= pair[shift+1] && pair[shift] < pair[shift+2] && 
      pair[shift] < pair[shift-1])
       return(true);
   else 
       return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetIndicatorLastPeak(int shift)
  {
   for(int i = shift + 5; i < Bars; i++)
     {
       if(signal[i] >= signal[i+1] && signal[i] >= signal[i+2] &&
          signal[i] >= signal[i-1] && signal[i] >= signal[i-2])
         {
           for(int j = i; j < Bars; j++)
             {
               if(pair[j] >= pair[j+1] && pair[j] > pair[j+2] &&
                  pair[j] >= pair[j-1] && pair[j] > pair[j-2])
                   return(j);
             }
         }
     }
   return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetIndicatorLastTrough(int shift)
  {
    for(int i = shift + 5; i < Bars; i++)
      {
        if(signal[i] <= signal[i+1] && signal[i] <= signal[i+2] &&
           signal[i] <= signal[i-1] && signal[i] <= signal[i-2])
          {
            for (int j = i; j < Bars; j++)
              {
                if(pair[j] <= pair[j+1] && pair[j] < pair[j+2] &&
                   pair[j] <= pair[j-1] && pair[j] < pair[j-2])
                    return(j);
              }
          }
      }
    return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DisplayAlert(string message, int shift)
  {
   if(shift <= 2 && Time[shift] != lastAlertTime)
     {
       lastAlertTime = Time[shift];
       Alert(message, Symbol(), " , ", Period(), " minutes chart");
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawPriceTrendLine(datetime x1, datetime x2, double y1, 
                        double y2, color lineColor, double style)
  {
   string label = "pair_DivergenceLine_v1.0# " + DoubleToStr(x1, 0);
   ObjectDelete(label);
   ObjectCreate(label, OBJ_TREND, 0, x1, y1, x2, y2, 0, 0);
   ObjectSet(label, OBJPROP_RAY, 0);
   ObjectSet(label, OBJPROP_COLOR, lineColor);
   ObjectSet(label, OBJPROP_STYLE, style);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawIndicatorTrendLine(datetime x1, datetime x2, double y1, 
                            double y2, color lineColor, double style)
  {
   int indicatorWindow = WindowFind(indicatorName);
   if(indicatorWindow < 0)
       return;
   string label = "pair_DivergenceLine_v1.0$# " + DoubleToStr(x1, 0);
   ObjectDelete(label);
   ObjectCreate(label, OBJ_TREND, indicatorWindow, x1, y1, x2, y2, 
                0, 0);
   ObjectSet(label, OBJPROP_RAY, 0);
   ObjectSet(label, OBJPROP_COLOR, lineColor);
   ObjectSet(label, OBJPROP_STYLE, style);
  }
//+------------------------------------------------------------------+



