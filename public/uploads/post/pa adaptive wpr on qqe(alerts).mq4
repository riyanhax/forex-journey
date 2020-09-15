#property copyright "www.forex-tsd.com"
#property link      "www.forex-tsd.com"


#property indicator_separate_window
#property indicator_buffers    5
#property indicator_color1     MediumVioletRed
#property indicator_color2     MediumVioletRed
#property indicator_color3     LimeGreen
#property indicator_color4     LimeGreen
#property indicator_color5     Gold
#property indicator_width1     3
#property indicator_width3     3
#property indicator_width5     3
#property indicator_levelcolor DarkGoldenrod

//
//
//
//
//

extern string TimeFrame                 = "Current time frame";
extern double filter                    = 1.0;
extern double cycles                    = 5.0;
extern int    WprPrice                  = PRICE_CLOSE;
extern int    WprSmoothingFactor        = 10;
extern double WPFast                    = 2.618;
extern double WPSlow                    = 4.236;
extern bool   divergenceVisible         = true;
extern bool   divergenceOnValuesVisible = true;
extern bool   divergenceOnChartVisible  = true;
extern color  divergenceBullishColor    = Green;
extern color  divergenceBearishColor    = Red;
extern string divergenceUniqueID        = "Qqe Wpr divergence1";
extern bool   HistogramOnSlope          = true;
extern bool   Interpolate               = true;

extern double levelOs                   = -40.0;
extern double levelOb                   = 40;

extern string note                      = "turn on Alert = true; turn off = false";
extern bool   alertsOn                  = true;
extern bool   alertsOnSlope             = false;
extern bool   alertsOnZeroCross         = true;
extern bool   alertsOnObOsCross         = true;
extern bool   alertsOnCurrent           = false;
extern bool   alertsMessage             = true;
extern bool   alertsSound               = true;
extern bool   alertsEmail               = false;
extern bool   alertsNotify              = false;

extern bool   arrowsVisible             = false;
extern bool   arrowsOnSlope             = false;
extern string arrowsIdentifier          = "qqe wpr arrows1";
extern double arrowsDisplacement        = 1.0;
extern color  arrowsUpColor             = DeepSkyBlue;
extern color  arrowsDnColor             = PaleVioletRed;
extern int    arrowsUpCode              = 241;
extern int    arrowsDnCode              = 242;

//
//
//
//
//

double Upa[];
double Upb[];
double Dna[];
double Dnb[];
double wprMa[];
double wpr[];
double trend[];
double slope[];
double vala[];

//
//
//
//
//

string indicatorFileName;
bool   returnBars;
bool   calculateValue;
int    timeFrame;
string shortName;

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
   IndicatorBuffers(9);
   SetIndexBuffer(0,Dna);  SetIndexStyle(0,DRAW_HISTOGRAM); 
   SetIndexBuffer(1,Dnb);  SetIndexStyle(1,DRAW_HISTOGRAM); 
   SetIndexBuffer(2,Upa);  SetIndexStyle(2,DRAW_HISTOGRAM); 
   SetIndexBuffer(3,Upb);  SetIndexStyle(3,DRAW_HISTOGRAM); 
   SetIndexBuffer(4,wprMa);    
   SetIndexBuffer(5,wpr);   
   SetIndexBuffer(6,trend);
   SetIndexBuffer(7,slope);
   SetIndexBuffer(8,vala);
   SetLevelValue(0,0);
   SetLevelValue(1,levelOs);
   SetLevelValue(2,levelOb);
   
      //
      //
      //
      //
      //
   
      indicatorFileName = WindowExpertName();
      returnBars        = (TimeFrame=="returnBars");     if (returnBars)     return(0);
      calculateValue    = (TimeFrame=="calculateValue");
      if (calculateValue)
      {
         int s = StringFind(divergenceUniqueID,":",0);
               shortName = divergenceUniqueID;
               divergenceUniqueID = StringSubstr(divergenceUniqueID,0,s);
               return(0);
      }            
      timeFrame = stringToTimeFrame(TimeFrame);
      
      //
      //
      //
      //
      //
      
      shortName = divergenceUniqueID+": "+timeFrameToString(timeFrame)+"  QQE pa Wpr ("+WprSmoothingFactor+")";
   IndicatorShortName(shortName);
return(0);
}

//
//
//
//
//

int deinit()
{
   
   int lookForLength = StringLen(divergenceUniqueID);
   
   for (int i=ObjectsTotal()-1; i>=0; i--) {
   
   string objectName = ObjectName(i);
   if (StringSubstr(objectName,0,lookForLength) == divergenceUniqueID) ObjectDelete(objectName);
   
   }
   
   if (!calculateValue && arrowsVisible) deleteArrows();
   
return(0);
}

//+------------------------------------------------------------------
//|                                                                  
//+------------------------------------------------------------------
//
//
//
//
//

double emas[][4];
#define iEma 0
#define iEmm 1
#define iEmf 2
#define iEms 3

//
//
//
//
//

int start()
{
   int counted_bars=IndicatorCounted();
   int i,r,limit;
   
   if(counted_bars < 0) return(-1);
   if(counted_bars > 0) counted_bars--;
           limit = MathMin(Bars-counted_bars,Bars-1);
           if (returnBars) { Dna[0] = limit+1; return(0); }

   //
   //
   //
   //
   //

   if (calculateValue || timeFrame == Period())
   {
      if (ArrayRange(emas,0) != Bars) ArrayResize(emas,Bars); 
      
      //
      //
      //
      //
      //
      
      double alpha1 = 2.0/(WprSmoothingFactor+1.0);
      double alpha2 = 1.0/(iHilbertPhase(getPrice(WprPrice,i),filter,cycles,i,0));
      
      
      for (i=limit, r=Bars-i-1; i>=0; i--,r++)
      { 
         double hi   = High[Highest(NULL,0,MODE_HIGH,iHilbertPhase(getPrice(WprPrice,i),filter,cycles,i,1),i)];
         double lo   =  Low[ Lowest(NULL,0,MODE_LOW, iHilbertPhase(getPrice(WprPrice,i),filter,cycles,i,2),i)];         
         if (hi!=lo)
              wpr[i] = 50 +(-100)*(hi - Close[i]) /(hi - lo);
         else wpr[i] = 0;  
                      
       
         wprMa[i]      = wprMa[i+1]      + alpha1 * (wpr[i] - wprMa[i+1]);
         emas[r][iEma] = emas[r-1][iEma] + alpha2 * (MathAbs(wprMa[i+1] - wprMa[i]) - emas[r-1][iEma]);
         emas[r][iEmm] = emas[r-1][iEmm] + alpha2 * (emas[r][iEma]                  - emas[r-1][iEmm]);
         emas[r][iEmf] = emas[r][iEmm]   * WPFast;
         emas[r][iEms] = emas[r][iEmm]   * WPSlow;

         //
         //
         //
         //
         //

         Dna[i] = EMPTY_VALUE;
         Dnb[i] = EMPTY_VALUE;
         Upa[i] = EMPTY_VALUE;
         Upb[i] = EMPTY_VALUE;
         trend[i] = trend[i+1];
         slope[i] = slope[i+1];
         vala[i]  = (i<Bars-1) ? (wprMa[i]>levelOb)  ? 1 : (wprMa[i]<levelOs)  ? -1 : (wprMa[i]<levelOb && wprMa[i]>levelOs) ? 0 : vala[i+1] : 0;     
         if (wprMa[i] > 0)          trend[i] =  1;
         if (wprMa[i] < 0)          trend[i] = -1;
         if (wprMa[i] > wprMa[i+1]) slope[i] =  1;
         if (wprMa[i] < wprMa[i+1]) slope[i] = -1;
         
         if (divergenceVisible)
         {
            CatchBullishDivergence(wprMa,i);
            CatchBearishDivergence(wprMa,i);
         }
                                     
         if (HistogramOnSlope)
         {
           if (trend[i] == 1 && slope[i] == 1) Upa[i] = wprMa[i];
           if (trend[i] == 1 && slope[i] ==-1) Upb[i] = wprMa[i];
           if (trend[i] ==-1 && slope[i] ==-1) Dna[i] = wprMa[i];
           if (trend[i] ==-1 && slope[i] == 1) Dnb[i] = wprMa[i];
         }
         else
         {                  
           if (trend[i] == 1) Upa[i] = wprMa[i];
           if (trend[i] ==-1) Dna[i] = wprMa[i];
         }
           if (!calculateValue) manageArrow(i);         
      }
      manageAlerts();
    return(0);
    } 
   
   //
   //
   //
   //
   //
   
   limit = MathMax(limit,MathMin(Bars-1,iCustom(NULL,timeFrame,indicatorFileName,"returnBars",0,0)*timeFrame/Period()));
   for(i=limit; i>=0; i--)
   {
      int y = iBarShift(NULL,timeFrame,Time[i]);
         wprMa[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",filter,cycles,WprPrice,WprSmoothingFactor,WPFast,WPSlow,divergenceVisible,divergenceOnValuesVisible,divergenceOnChartVisible,divergenceBullishColor,divergenceBearishColor,shortName,Interpolate,4,y);
         trend[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",filter,cycles,WprPrice,WprSmoothingFactor,WPFast,WPSlow,divergenceVisible,divergenceOnValuesVisible,divergenceOnChartVisible,divergenceBullishColor,divergenceBearishColor,shortName,Interpolate,6,y);
         slope[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",filter,cycles,WprPrice,WprSmoothingFactor,WPFast,WPSlow,divergenceVisible,divergenceOnValuesVisible,divergenceOnChartVisible,divergenceBullishColor,divergenceBearishColor,shortName,Interpolate,7,y);
         Dna[i]   = EMPTY_VALUE;
         Dnb[i]   = EMPTY_VALUE;
         Upa[i]   = EMPTY_VALUE;
         Upb[i]   = EMPTY_VALUE;
            
         manageArrow(i);
                
         //
         //
         //
         //
         //
        
         if (!Interpolate || y==iBarShift(NULL,timeFrame,Time[i-1])) continue;

         //
         //
         //
         //
         //

         datetime time = iTime(NULL,timeFrame,y);
            for(int n = 1; i+n < Bars && Time[i+n] >= time; n++) continue;
            for(int k = 1; k < n; k++) 
            {
               wprMa[i+k] = wprMa[i] + (wprMa[i+n] - wprMa[i])* k/n;
            }
     
     //
     //
     //
     //
     //
              
     }
     
     for (i=limit;i>=0;i--)
     {
        if (HistogramOnSlope)
        {
               if (trend[i] == 1 && slope[i] == 1) Upa[i] = wprMa[i];
               if (trend[i] == 1 && slope[i] ==-1) Upb[i] = wprMa[i];
               if (trend[i] ==-1 && slope[i] ==-1) Dna[i] = wprMa[i];
               if (trend[i] ==-1 && slope[i] == 1) Dnb[i] = wprMa[i];
        }
        else
        {                  
               if (trend[i]== 1) Upa[i] = wprMa[i];
               if (trend[i]==-1) Dna[i] = wprMa[i];
        }
                               
   }
   manageAlerts();
   return(0);
}

//+------------------------------------------------------------------
//|                                                                  
//+------------------------------------------------------------------
//
//
//
//
//
//

double getPrice(int type, int i)
{
   switch (type)
   {
      case 7:     return((Open[i]+Close[i])/2.0);
      case 8:     return((Open[i]+High[i]+Low[i]+Close[i])/4.0);
      default :   return(iMA(NULL,0,1,0,MODE_SMA,type,i));
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

double workHil[][27];
#define _price      0
#define _smooth     1
#define _detrender  2
#define _period     3
#define _instPeriod 4
#define _phase      5
#define _deltaPhase 6
#define _Q1         7
#define _I1         8

#define Pi 3.14159265358979323846264338327950288

//
//
//
//
//

double iHilbertPhase(double price, double tfilter, double cyclesToReach, int i, int s=0)
{
   if (ArrayRange(workHil,0)!=Bars) ArrayResize(workHil,Bars);
   int r = Bars-i-1; s = s*9;
      
   //
   //
   //
   //
   //
      
      workHil[r][s+_price]      = price;
      workHil[r][s+_smooth]     = (4.0*workHil[r][s+_price]+3.0*workHil[r-1][s+_price]+2.0*workHil[r-2][s+_price]+workHil[r-3][s+_price])/10.0;
      workHil[r][s+_detrender]  = calcComp(r,_smooth,s);
      workHil[r][s+_Q1]         = 0.15*calcComp(r,_detrender,s)  +0.85*workHil[r-1][s+_Q1];
      workHil[r][s+_I1]         = 0.15*workHil[r-3][s+_detrender]+0.85*workHil[r-1][s+_I1];
      workHil[r][s+_phase]      = workHil[r-1][s+_phase];
      workHil[r][s+_instPeriod] = workHil[r-1][s+_instPeriod];

      //
      //
      //
      //
      //
           
         if (MathAbs(workHil[r][s+_I1])>0)
                     workHil[r][s+_phase] = 180.0/Pi*MathArctan(MathAbs(workHil[r][s+_Q1]/workHil[r][s+_I1]));
           
         if (workHil[r][s+_I1]<0 && workHil[r][s+_Q1]>0) workHil[r][s+_phase] = 180-workHil[r][s+_phase];
         if (workHil[r][s+_I1]<0 && workHil[r][s+_Q1]<0) workHil[r][s+_phase] = 180+workHil[r][s+_phase];
         if (workHil[r][s+_I1]>0 && workHil[r][s+_Q1]<0) workHil[r][s+_phase] = 360-workHil[r][s+_phase];

      //
      //
      //
      //
      //
                        
      workHil[r][s+_deltaPhase] = workHil[r-1][s+_phase]-workHil[r][s+_phase];

         if (workHil[r-1][s+_phase]<90 && workHil[r][s+_phase]>270)
             workHil[r][s+_deltaPhase] = 360+workHil[r-1][s+_phase]-workHil[r][s+_phase];
             workHil[r][s+_deltaPhase] = MathMax(MathMin(workHil[r][s+_deltaPhase],60),7);
      
            //
            //
            //
            //
            //
                  
            double alpha    = 2.0/(1.0+MathMax(tfilter,1));
            double phaseSum = 0; for (int k=0; phaseSum<cyclesToReach*360 && (r-k)>0; k++) phaseSum += workHil[r-k][s+_deltaPhase];
         
               if (k>0) workHil[r][s+_instPeriod]= k;
                  workHil[r][s+_period] = workHil[r-1][s+_period]+alpha*(workHil[r][s+_instPeriod]-workHil[r-1][s+_period]);
   return (workHil[r][s+_period]);
}

//
//
//
//
//

double calcComp(int r, int from, int s)
{
   return((0.0962*workHil[r  ][s+from] + 
           0.5769*workHil[r-2][s+from] - 
           0.5769*workHil[r-4][s+from] - 
           0.0962*workHil[r-6][s+from]) * (0.075*workHil[r-1][s+_period] + 0.54));
}

//
//
//
//
//

void manageAlerts()
{
   if (!calculateValue && alertsOn)
   {
      if (alertsOnCurrent)
           int whichBar = 0;
      else     whichBar = 1; whichBar = iBarShift(NULL,0,iTime(NULL,timeFrame,whichBar));
      
      //
      //
      //
      //
      //
      
      static datetime time1 = 0;
      static string   mess1 = "";
      if (alertsOnSlope && slope[whichBar] != slope[whichBar+1])
      {
         if (slope[whichBar] == 1) doAlert(time1,mess1,whichBar,"sloping up");
         if (slope[whichBar] ==-1) doAlert(time1,mess1,whichBar,"sloping down");         
      }
      static datetime time2 = 0;
      static string   mess2 = "";
      if (alertsOnZeroCross && trend[whichBar] != trend[whichBar+1])
      {
         if (trend[whichBar] ==  1) doAlert(time2,mess2,whichBar,"crossing zero up");
         if (trend[whichBar] == -1) doAlert(time2,mess2,whichBar,"crossing zero down");
      }
      static datetime time3 = 0;
      static string   mess3 = "";
      if (alertsOnObOsCross && vala[whichBar] != vala[whichBar+1])
      {
         if (vala[whichBar]   == -1) doAlert(time3,mess3,whichBar,DoubleToStr(levelOs,2)+" crossed down");
         if (vala[whichBar]   ==  1) doAlert(time3,mess3,whichBar,DoubleToStr(levelOb,2)+" crossed up");         
      }
   }
}   

//
//
//
//
//

void doAlert(datetime& previousTime, string& previousAlert, int forBar, string doWhat)
{
   string message;
   
   if (previousAlert != doWhat || previousTime != Time[forBar]) {
       previousAlert  = doWhat;
       previousTime   = Time[forBar];
       
       //
       //
       //
       //
       //

       message = timeFrameToString(_Period)+" "+_Symbol+" at "+TimeToStr(TimeLocal(),TIME_SECONDS)+" QQE Wpr "+doWhat;
          if (alertsMessage) Alert(message);
          if (alertsNotify)  SendNotification(message);
          if (alertsEmail)   SendMail(_Symbol+" QQE Wpr ",message);
          if (alertsSound)   PlaySound("alert2.wav");
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

void manageArrow(int i)
{
   if (arrowsVisible)
   {
      deleteArrow(Time[i]);
      if(arrowsOnSlope)
      {
      
         if (slope[i] != slope[i+1])
         {
            if (slope[i] == 1) drawArrow(i,arrowsUpColor,arrowsUpCode,false);
            if (slope[i] ==-1) drawArrow(i,arrowsDnColor,arrowsDnCode, true);
         }         
      }
      else
      {
         if (trend[i] != trend[i+1])
         {
            if (trend[i] == 1) drawArrow(i,arrowsUpColor,arrowsUpCode,false);
            if (trend[i] ==-1) drawArrow(i,arrowsDnColor,arrowsDnCode, true);
         }  
      }         
   }         
}       

//
//
//
//
//

void drawArrow(int i,color theColor,int theCode,bool up)
{
   string name = arrowsIdentifier+":"+Time[i];
   double gap  = iATR(NULL,0,20,i);   
   
      //
      //
      //
      //
      //
      
      ObjectCreate(name,OBJ_ARROW,0,Time[i],0);
         ObjectSet(name,OBJPROP_ARROWCODE,theCode);
         ObjectSet(name,OBJPROP_COLOR,theColor);
         if (up)
               ObjectSet(name,OBJPROP_PRICE1,High[i] + arrowsDisplacement * gap);
         else  ObjectSet(name,OBJPROP_PRICE1,Low[i]  - arrowsDisplacement * gap);
}

//
//
//
//
//

void deleteArrows()
{
   string lookFor       = arrowsIdentifier+":";
   int    lookForLength = StringLen(lookFor);
   for (int i=ObjectsTotal()-1; i>=0; i--)
   {
      string objectName = ObjectName(i);
         if (StringSubstr(objectName,0,lookForLength) == lookFor) ObjectDelete(objectName);
   }
}

//
//
//
//
//

void deleteArrow(datetime time)
{
   string lookFor = arrowsIdentifier+":"+time; ObjectDelete(lookFor);
}

//+------------------------------------------------------------------
//|                                                                  
//+------------------------------------------------------------------
//
//
//
//
//

void CatchBullishDivergence(double& values[], int i)
{
   i++;
            ObjectDelete(divergenceUniqueID+"l"+DoubleToStr(Time[i],0));
            ObjectDelete(divergenceUniqueID+"l"+"os" + DoubleToStr(Time[i],0));            
   if (!IsIndicatorLow(values,i)) return;  

   //
   //
   //
   //
   //

   int currentLow = i;
   int lastLow    = GetIndicatorLastLow(values,i+1);
      if (values[currentLow] > values[lastLow] && Low[currentLow] < Low[lastLow])
      {
         if(divergenceOnChartVisible)  DrawPriceTrendLine("l",Time[currentLow],Time[lastLow],Low[currentLow],Low[lastLow],divergenceBullishColor,STYLE_SOLID);
         if(divergenceOnValuesVisible) DrawIndicatorTrendLine("l",Time[currentLow],Time[lastLow],values[currentLow],values[lastLow],divergenceBullishColor,STYLE_SOLID);
      }
      if (values[currentLow] < values[lastLow] && Low[currentLow] > Low[lastLow])
      {
         if(divergenceOnChartVisible)  DrawPriceTrendLine("l",Time[currentLow],Time[lastLow],Low[currentLow],Low[lastLow], divergenceBullishColor, STYLE_DOT);
         if(divergenceOnValuesVisible) DrawIndicatorTrendLine("l",Time[currentLow],Time[lastLow],values[currentLow],values[lastLow], divergenceBullishColor, STYLE_DOT);
      }
}

//
//
//
//
//

void CatchBearishDivergence(double& values[], int i)
{
   i++; 
            ObjectDelete(divergenceUniqueID+"h"+DoubleToStr(Time[i],0));
            ObjectDelete(divergenceUniqueID+"h"+"os" + DoubleToStr(Time[i],0));            
   if (IsIndicatorPeak(values,i) == false) return;

   //
   //
   //
   //
   //
      
   int currentPeak = i;
   int lastPeak = GetIndicatorLastPeak(values,i+1);
      if (values[currentPeak] < values[lastPeak] && High[currentPeak]>High[lastPeak])
      {
         if (divergenceOnChartVisible)  DrawPriceTrendLine("h",Time[currentPeak],Time[lastPeak],High[currentPeak],High[lastPeak],divergenceBearishColor,STYLE_SOLID);
         if (divergenceOnValuesVisible) DrawIndicatorTrendLine("h",Time[currentPeak],Time[lastPeak],values[currentPeak],values[lastPeak],divergenceBearishColor,STYLE_SOLID);
      }
      if(values[currentPeak] > values[lastPeak] && High[currentPeak] < High[lastPeak])
      {
         if (divergenceOnChartVisible)  DrawPriceTrendLine("h",Time[currentPeak],Time[lastPeak],High[currentPeak],High[lastPeak], divergenceBearishColor, STYLE_DOT);
         if (divergenceOnValuesVisible) DrawIndicatorTrendLine("h",Time[currentPeak],Time[lastPeak],values[currentPeak],values[lastPeak], divergenceBearishColor, STYLE_DOT);
      }
}

//
//
//
//
//

bool IsIndicatorPeak(double& values[], int i) { return(values[i] >= values[i+1] && values[i] > values[i+2] && values[i] > values[i-1]); }
bool IsIndicatorLow( double& values[], int i) { return(values[i] <= values[i+1] && values[i] < values[i+2] && values[i] < values[i-1]); }

int GetIndicatorLastPeak(double& values[], int shift)
{
   for(int i = shift+5; i<Bars; i++)
         if (values[i] >= values[i+1] && values[i] > values[i+2] && values[i] >= values[i-1] && values[i] > values[i-2]) return(i);
   return(-1);
}

//
//
//
//
//

int GetIndicatorLastLow(double& values[], int shift)
{
   for(int i = shift+5; i<Bars; i++)
         if (values[i] <= values[i+1] && values[i] < values[i+2] && values[i] <= values[i-1] && values[i] < values[i-2]) return(i);
   return(-1);
}

//+------------------------------------------------------------------
//|                                                                  
//+------------------------------------------------------------------
//
//
//
//
//

void DrawPriceTrendLine(string first,datetime t1, datetime t2, double p1, double p2, color lineColor, double style)
{
   string   label = divergenceUniqueID+first+"os"+DoubleToStr(t1,0);
   if (Interpolate) t2 += Period()*60-1;
    
   ObjectDelete(label);
      ObjectCreate(label, OBJ_TREND, 0, t1+Period()*60-1, p1, t2, p2, 0, 0);
         ObjectSet(label, OBJPROP_RAY, false);
         ObjectSet(label, OBJPROP_COLOR, lineColor);
         ObjectSet(label, OBJPROP_STYLE, style);
}

//
//
//
//
//

void DrawIndicatorTrendLine(string first,datetime t1, datetime t2, double p1, double p2, color lineColor, double style)
{
   int indicatorWindow = WindowFind(shortName);
   if (indicatorWindow < 0) return;
   if (Interpolate) t2 += Period()*60-1;
   
   string label = divergenceUniqueID+first+DoubleToStr(t1,0);
   ObjectDelete(label);
      ObjectCreate(label, OBJ_TREND, indicatorWindow, t1+Period()*60-1, p1, t2, p2, 0, 0);
         ObjectSet(label, OBJPROP_RAY, false);
         ObjectSet(label, OBJPROP_COLOR, lineColor);
         ObjectSet(label, OBJPROP_STYLE, style);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//

string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};

//
//
//
//
//

int stringToTimeFrame(string tfs) {
   tfs = stringUpperCase(tfs);
   for (int i=ArraySize(iTfTable)-1; i>=0; i--)
         if (tfs==sTfTable[i] || tfs==""+iTfTable[i]) return(MathMax(iTfTable[i],Period()));
                                                      return(Period());
}

//
//
//
//
//

string timeFrameToString(int tf) {
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}

//
//
//
//
//

string stringUpperCase(string str) {
   string   s = str;

   for (int length=StringLen(str)-1; length>=0; length--) {
      int tchar = StringGetChar(s, length);
         if((tchar > 96 && tchar < 123) || (tchar > 223 && tchar < 256))
                     s = StringSetChar(s, length, tchar - 32);
         else if(tchar > -33 && tchar < 0)
                     s = StringSetChar(s, length, tchar + 224);
   }
   return(s);
}


      


