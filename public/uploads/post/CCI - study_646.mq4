//+------------------------------------------------------------------+
//|                      Mladen 11 Oct 2011                          |
//+------------------------------------------------------------------+
#property copyright "www,forex-tsd.com"
#property link      "www,forex-tsd.com"

#property indicator_separate_window
#property indicator_buffers 5
#property indicator_color1  DeepSkyBlue
#property indicator_color2  Yellow
#property indicator_color3  Yellow
#property indicator_color4  Red
#property indicator_color5  Silver
#property indicator_width1  2
#property indicator_width4  2
#property indicator_width5  2

//
//
//
//
//

extern string TimeFrame                    = "Current time frame";
extern int    CciPeriod                    = 14;//***********NB
extern int    CciMaMethod                  = MODE_SMA;
extern int    CciPrice                     = PRICE_TYPICAL;
extern int    SmoothPeriod                 = 0;//********************** NB
extern int    SmoothMethod                 = MODE_SMA;
extern double OverSold                     = -166;
extern double OverBought                   =  166;
extern bool   divergenceVisible            = true;
extern bool   divergenceOnIndicatorVisible = true;
extern bool   divergenceOnChartVisible     = true;
extern color  divergenceBullishColor       = DeepSkyBlue;
extern color  divergenceBearishColor       = Red;
extern string divergenceUniqueID           = "ccidiv1";
extern bool   HistogramOnSlope             = true;
extern bool   Interpolate                  = true;
extern bool   ShowHistogram                = true;

//
//
//
//
//

double cci[];
double ccihua[];
double ccihub[];
double ccihda[];
double ccihdb[];
double trend[];
double prices[];

string indicatorFileName;
bool   calculateValue;
bool   returnBars;
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
   IndicatorBuffers(7);
      int style = DRAW_HISTOGRAM; 
         if (!ShowHistogram) style = DRAW_NONE;
         SetIndexBuffer(0,ccihua); SetIndexStyle(0,style);
         SetIndexBuffer(1,ccihub); SetIndexStyle(1,style);
         SetIndexBuffer(2,ccihda); SetIndexStyle(2,style);
         SetIndexBuffer(3,ccihdb); SetIndexStyle(3,style);
         SetIndexBuffer(4,cci);
         SetIndexBuffer(5,prices);
         SetIndexBuffer(6,trend);
            SetLevelValue(0,0);
            SetLevelValue(1,OverBought);
            SetLevelValue(2,OverSold);
         
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
         
         string add = " - "+getAverageName(SmoothMethod)+" smoothed (";
            if (SmoothPeriod <= 1) add = " (";
   shortName = divergenceUniqueID+": "+timeFrameToString(timeFrame)+" cci of "+getAverageName(CciMaMethod)+add+CciPeriod+","+SmoothPeriod+")";
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
   for (int i=ObjectsTotal()-1; i>=0; i--) 
   {
      string objectName = ObjectName(i); if (StringSubstr(objectName,0,lookForLength) == divergenceUniqueID) ObjectDelete(objectName);
   }
   return(0);
}


//+-----------------------------------------------------------------------------------------------------------------------------------+
//|                                                                                                                                   |
//+-----------------------------------------------------------------------------------------------------------------------------------+
//
//
//
//

int start()
{
   int limit,n,counted_bars=IndicatorCounted();
      if(counted_bars<0) return(-1);
      if(counted_bars>0) counted_bars--;
         limit = MathMin(Bars-counted_bars,Bars-1);
         if (returnBars) { ccihua[0] = limit; return(0); }

   //
   //
   //
   //
   //

   if (calculateValue || timeFrame == Period())
   {
      for(int i=limit; i>=0; i--)
      {
         trend[i]  = trend[i+1];
         prices[i] = getPrice(CciPrice,i);
            double avg = iCustomMa(prices[i],CciPeriod,CciMaMethod,i,0);
            double dev = 0; for(int k=0; k<CciPeriod; k++) dev += MathAbs(prices[i+k]-avg); dev /= CciPeriod;
               if (dev!=0)
                     cci[i] = iCustomMa((prices[i]-avg)/(0.015*dev),SmoothPeriod,SmoothMethod,i,1);
               else  cci[i] = iCustomMa(0                          ,SmoothPeriod,SmoothMethod,i,1);          
               if (divergenceVisible)
               {
                  CatchBullishDivergence(cci,i);
                  CatchBearishDivergence(cci,i);
               }           
            
            //
            //
            //
            //
            //
                  
            while (true)
            {
               if (HistogramOnSlope)
               {
                  if (cci[i] > 0 && cci[i] > cci[i+1]) { trend[i]=  2; break; }
                  if (cci[i] > 0 && cci[i] < cci[i+1]) { trend[i]=  1; break; }
                  if (cci[i] < 0 && cci[i] > cci[i+1]) { trend[i]= -1; break; }
                  if (cci[i] < 0 && cci[i] < cci[i+1]) { trend[i]= -2; break; }
               }
               else
               {
                  if (cci[i] > OverBought) { trend[i]= 2; break; }
                  if (cci[i] > 0)          { trend[i]= 1; break; }
                  if (cci[i] < OverSold)   { trend[i]=-2; break; }
                  if (cci[i] < 0)          { trend[i]=-1; break; }
               }
               break;
            }
      
            //
            //
            //
            //
            //
      
            if (trend[i]== 2) ccihua[i] = cci[i]; else ccihua[i] = EMPTY_VALUE;
            if (trend[i]== 1) ccihub[i] = cci[i]; else ccihub[i] = EMPTY_VALUE;
            if (trend[i]==-1) ccihda[i] = cci[i]; else ccihda[i] = EMPTY_VALUE;
            if (trend[i]==-2) ccihdb[i] = cci[i]; else ccihdb[i] = EMPTY_VALUE;
      }
      return(0);
   }
   
   //
   //
   //
   //
   //
   
   limit = MathMax(limit,MathMin(Bars-1,iCustom(NULL,timeFrame,indicatorFileName,"returnBars",0,0)*timeFrame/Period()));
   for (i=limit;i>=0;i--)
   {
      int y = iBarShift(NULL,timeFrame,Time[i]);
         cci[i]   = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",CciPeriod,CciMaMethod,CciPrice,SmoothPeriod,SmoothMethod,OverSold,OverBought,divergenceVisible,divergenceOnIndicatorVisible,divergenceOnChartVisible,divergenceBullishColor,divergenceBearishColor,shortName,HistogramOnSlope,Interpolate,4,y);
         trend[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",CciPeriod,CciMaMethod,CciPrice,SmoothPeriod,SmoothMethod,OverSold,OverBought,divergenceVisible,divergenceOnIndicatorVisible,divergenceOnChartVisible,divergenceBullishColor,divergenceBearishColor,shortName,HistogramOnSlope,Interpolate,6,y);

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
            for(n = 1; i+n < Bars && Time[i+n] >= time; n++) continue;	
            for(k = 1; k < n; k++)
               cci[i+k] = cci[i] + (cci[i+n] - cci[i])*k/n;
   }
   for (i=limit;i>=0;i--)
   {
      if (trend[i]== 2) ccihua[i] = cci[i]; else ccihua[i] = EMPTY_VALUE;
      if (trend[i]== 1) ccihub[i] = cci[i]; else ccihub[i] = EMPTY_VALUE;
      if (trend[i]==-1) ccihda[i] = cci[i]; else ccihda[i] = EMPTY_VALUE;
      if (trend[i]==-2) ccihdb[i] = cci[i]; else ccihdb[i] = EMPTY_VALUE;
   }
   return(0);         
}


//+----------------------------------------------------------------------+
//|                                                                      |
//+----------------------------------------------------------------------+
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
      default :   return(iMA(NULL,0,1,0,MODE_SMA,MathMax(MathMin(type,6),1),i));
   }      
}

//+----------------------------------------------------------------------------+
//|                                                                            |
//+----------------------------------------------------------------------------+
//
//
//
//
//

string methodNames[] = {"SMA","EMA","Double smoothed EMA","Double EMA","Tripple EMA","Smoothed MA","Linear weighted MA","Parabolic weighted MA","Alexander MA","Volume weghted MA","Hull MA","Triangular MA","Sine weighted MA","Liner regression","NonLag MA","Zero lag EMA"};
string getAverageName(int& method)
{
   int max = ArraySize(methodNames)-1;
      method=MathMax(MathMin(method,max),0); return(methodNames[method]);
}

//
//
//
//
//

#define _maWorkBufferx1 2
#define _maWorkBufferx2 4
#define _maWorkBufferx3 6
double iCustomMa(double price, double length, int mode, int r, int instanceNo=0)
{
   r = Bars-r-1; length = MathMax(length,1);
   switch (mode)
   {
      case 0  : return(iSma(price,length,r,instanceNo));
      case 1  : return(iEma(price,length,r,instanceNo));
      case 2  : return(iDsema(price,length,r,instanceNo));
      case 3  : return(iDema(price,length,r,instanceNo));
      case 4  : return(iTema(price,length,r,instanceNo));
      case 5  : return(iSmma(price,length,r,instanceNo));
      case 6  : return(iLwma(price,length,r,instanceNo));
      case 7  : return(iLwmp(price,length,r,instanceNo));
      case 8  : return(iAlex(price,length,r,instanceNo));
      case 9  : return(iWwma(price,length,r,instanceNo));
      case 10 : return(iHull(price,length,r,instanceNo));
      case 11 : return(iTma(price,length,r,instanceNo));
      case 12 : return(iSineWMA(price,length,r,instanceNo));
      case 13 : return(iLinr(price,length,r,instanceNo));
      case 14 : return(iNonLagMa(price,length,r,instanceNo));
      case 15 : return(iZeroLag(price,length,r,instanceNo));
      default : return(0);
   }
}

//+------------------------------------------------------------------
//|                                                                  
//+------------------------------------------------------------------
//
//
//
//
//

double workSma[][_maWorkBufferx1];
double iSma(double price, double period, int r, int instanceNo=0)
{
   if (ArraySize(workSma)!= Bars) ArrayResize(workSma,Bars);

   //
   //
   //
   //
   //
      
   workSma[r][instanceNo] = price;
   double sum = price; 
         for(int k=1; k<period && (r-k)>=0; k++) sum += workSma[r-k][instanceNo];  
   return(sum/k);
}

//
//
//
//
//

double workEma[][_maWorkBufferx1];
double iEma(double price, double period, int r, int instanceNo=0)
{
   if (ArraySize(workEma)!= Bars) ArrayResize(workEma,Bars);

   //
   //
   //
   //
   //
      
   double alpha = 2.0 / (1.0+period);
          workEma[r][instanceNo] = workEma[r-1][instanceNo]+alpha*(price-workEma[r-1][instanceNo]);
   return(workEma[r][instanceNo]);
}

//
//
//
//
//

double workDsema[][_maWorkBufferx2];
#define _ema1 0
#define _ema2 1

double iDsema(double price, double period, int r, int instanceNo=0)
{
   if (ArraySize(workDsema)!= Bars) ArrayResize(workDsema,Bars); instanceNo*=2;

   //
   //
   //
   //
   //
      
   double alpha = 2.0 /(1.0+MathSqrt(period));
          workDsema[r][_ema1+instanceNo] = workDsema[r-1][_ema1+instanceNo]+alpha*(price                         -workDsema[r-1][_ema1+instanceNo]);
          workDsema[r][_ema2+instanceNo] = workDsema[r-1][_ema2+instanceNo]+alpha*(workDsema[r][_ema1+instanceNo]-workDsema[r-1][_ema2+instanceNo]);
   return(workDsema[r][_ema2+instanceNo]);
}

//
//
//
//
//

double workDema[][_maWorkBufferx2];
#define _ema1 0
#define _ema2 1

double iDema(double price, double period, int r, int instanceNo=0)
{
   if (ArraySize(workDema)!= Bars) ArrayResize(workDema,Bars); instanceNo*=2;

   //
   //
   //
   //
   //
      
   double alpha = 2.0 / (1.0+period);
          workDema[r][_ema1+instanceNo] = workDema[r-1][_ema1+instanceNo]+alpha*(price                        -workDema[r-1][_ema1+instanceNo]);
          workDema[r][_ema2+instanceNo] = workDema[r-1][_ema2+instanceNo]+alpha*(workDema[r][_ema1+instanceNo]-workDema[r-1][_ema2+instanceNo]);
   return(workDema[r][_ema1+instanceNo]*2.0-workDema[r][_ema2+instanceNo]);
}

//
//
//
//
//

double workTema[][_maWorkBufferx3];
#define _ema1 0
#define _ema2 1
#define _ema3 2

double iTema(double price, double period, int r, int instanceNo=0)
{
   if (ArraySize(workTema)!= Bars) ArrayResize(workTema,Bars); instanceNo*=3;

   //
   //
   //
   //
   //
      
   double alpha = 2.0 / (1.0+period);
          workTema[r][_ema1+instanceNo] = workTema[r-1][_ema1+instanceNo]+alpha*(price                        -workTema[r-1][_ema1+instanceNo]);
          workTema[r][_ema2+instanceNo] = workTema[r-1][_ema2+instanceNo]+alpha*(workTema[r][_ema1+instanceNo]-workTema[r-1][_ema2+instanceNo]);
          workTema[r][_ema3+instanceNo] = workTema[r-1][_ema3+instanceNo]+alpha*(workTema[r][_ema2+instanceNo]-workTema[r-1][_ema3+instanceNo]);
   return(workTema[r][_ema3+instanceNo]+3.0*(workTema[r][_ema1+instanceNo]-workTema[r][_ema2+instanceNo]));
}

//
//
//
//
//

double workSmma[][_maWorkBufferx1];
double iSmma(double price, double period, int r, int instanceNo=0)
{
   if (ArrayRange(workSmma,0)!= Bars) ArrayResize(workSmma,Bars);

   //
   //
   //
   //
   //

   if (r<period)
         workSmma[r][instanceNo] = price;
   else  workSmma[r][instanceNo] = workSmma[r-1][instanceNo]+(price-workSmma[r-1][instanceNo])/period;
   return(workSmma[r][instanceNo]);
}

//
//
//
//
//

double workLwma[][_maWorkBufferx1];
double iLwma(double price, double period, int r, int instanceNo=0)
{
   if (ArraySize(workLwma)!= Bars) ArrayResize(workLwma,Bars);
   
   //
   //
   //
   //
   //
   
   workLwma[r][instanceNo] = price;
      double sumw = period;
      double sum  = period*price;

      for(int k=1; k<period && (r-k)>=0; k++)
      {
         double weight = period-k;
                sumw  += weight;
                sum   += weight*workLwma[r-k][instanceNo];  
      }             
      return(sum/sumw);
}

//
//
//
//
//

double workLwmp[][_maWorkBufferx1];
double iLwmp(double price, double period, int r, int instanceNo=0)
{
   if (ArraySize(workLwmp)!= Bars) ArrayResize(workLwmp,Bars);
   
   //
   //
   //
   //
   //
   
   workLwmp[r][instanceNo] = price;
      double sumw = period*period;
      double sum  = sumw*price;

      for(int k=1; k<period && (r-k)>=0; k++)
      {
         double weight = (period-k)*(period-k);
                sumw  += weight;
                sum   += weight*workLwmp[r-k][instanceNo];  
      }             
      return(sum/sumw);
}

//
//
//
//
//

double workAlex[][_maWorkBufferx1];
double iAlex(double price, double period, int r, int instanceNo=0)
{
   if (ArraySize(workAlex)!= Bars) ArrayResize(workAlex,Bars);
   if (period<4) return(price);
   
   //
   //
   //
   //
   //

   workAlex[r][instanceNo] = price;
      double sumw = period-2;
      double sum  = sumw*price;

      for(int k=1; k<period && (r-k)>=0; k++)
      {
         double weight = period-k-2;
                sumw  += weight;
                sum   += weight*workAlex[r-k][instanceNo];  
      }             
      return(sum/sumw);
}

//
//
//
//
//

double workTma[][_maWorkBufferx1];
double iTma(double price, double period, int r, int instanceNo=0)
{
   if (ArraySize(workTma)!= Bars) ArrayResize(workTma,Bars);
   
   //
   //
   //
   //
   //
   
   workTma[r][instanceNo] = price;

      double half = (period+1.0)/2.0;
      double sum  = price;
      double sumw = 1;

      for(int k=1; k<period && (r-k)>=0; k++)
      {
         double weight = k+1; if (weight > half) weight = period-k;
                sumw  += weight;
                sum   += weight*workTma[r-k][instanceNo];  
      }             
      return(sum/sumw);
}

//
//
//
//
//

double workSineWMA[][_maWorkBufferx1];
#define Pi 3.14159265358979323846264338327950288

double iSineWMA(double price, int period, int r, int instanceNo=0)
{
   if (period<1) return(price);
   if (ArraySize(workSineWMA)!= Bars) ArrayResize(workSineWMA,Bars);
   
   //
   //
   //
   //
   //
   
   workSineWMA[r][instanceNo] = price;
      double sum  = 0;
      double sumw = 0;
  
      for(int k=0; k<period && (r-k)>=0; k++)
      { 
         double weight = MathSin(Pi*(k+1.0)/(period+1.0));
                sumw  += weight;
                sum   += weight*workSineWMA[r-k][instanceNo]; 
      }
      return(sum/sumw);
}

//
//
//
//
//

double workWwma[][_maWorkBufferx1];
double iWwma(double price, double period, int r, int instanceNo=0)
{
   if (ArraySize(workWwma)!= Bars) ArrayResize(workWwma,Bars);
   
   //
   //
   //
   //
   //
   
   workWwma[r][instanceNo] = price;
      int    i    = Bars-r-1;
      double sumw = Volume[i];
      double sum  = sumw*price;

      for(int k=1; k<period && (r-k)>=0; k++)
      {
         double weight = Volume[i+k];
                sumw  += weight;
                sum   += weight*workWwma[r-k][instanceNo];  
      }             
      return(sum/sumw);
}


//
//
//
//
//

double workHull[][_maWorkBufferx2];
double iHull(double price, double period, int r, int instanceNo=0)
{
   if (ArrayRange(workHull,0)!= Bars) ArrayResize(workHull,Bars);

   //
   //
   //
   //
   //

      int HmaPeriod  = MathMax(period,2);
      int HalfPeriod = MathFloor(HmaPeriod/2);
      int HullPeriod = MathFloor(MathSqrt(HmaPeriod));
      double hma,hmw,weight; instanceNo *= 2;

         workHull[r][instanceNo] = price;

         //
         //
         //
         //
         //
               
         hmw = HalfPeriod; hma = hmw*price; 
            for(int k=1; k<HalfPeriod && (r-k)>=0; k++)
            {
               weight = HalfPeriod-k;
               hmw   += weight;
               hma   += weight*workHull[r-k][instanceNo];  
            }             
            workHull[r][instanceNo+1] = 2.0*hma/hmw;

         hmw = HmaPeriod; hma = hmw*price; 
            for(k=1; k<period && (r-k)>=0; k++)
            {
               weight = HmaPeriod-k;
               hmw   += weight;
               hma   += weight*workHull[r-k][instanceNo];
            }             
            workHull[r][instanceNo+1] -= hma/hmw;

         //
         //
         //
         //
         //
         
         hmw = HullPeriod; hma = hmw*workHull[r][instanceNo+1];
            for(k=1; k<HullPeriod && (r-k)>=0; k++)
            {
               weight = HullPeriod-k;
               hmw   += weight;
               hma   += weight*workHull[r-k][1+instanceNo];  
            }
   return(hma/hmw);
}

//
//
//
//
//

double workLinr[][_maWorkBufferx1];
double iLinr(double price, double period, int r, int instanceNo=0)
{
   if (ArraySize(workLinr)!= Bars) ArrayResize(workLinr,Bars);

   //
   //
   //
   //
   //
   
      period = MathMax(period,1);
      workLinr[r][instanceNo] = price;
         double lwmw = period; double lwma = lwmw*price;
         double sma  = price;
         for(int k=1; k<period && (r-k)>=0; k++)
         {
            double weight = period-k;
                   lwmw  += weight;
                   lwma  += weight*workLinr[r-k][instanceNo];  
                   sma   +=        workLinr[r-k][instanceNo];
         }             
   
   return(3.0*lwma/lwmw-2.0*sma/period);
}

//
//
//
//
//

double workZl[][_maWorkBufferx2];
#define _price 0
#define _zlema 1

double iZeroLag(double price, double length, int r, int instanceNo=0)
{
   if (ArrayRange(workZl,0)!=Bars) ArrayResize(workZl,Bars); instanceNo *= 2;

   //
   //
   //
   //
   //

   double alpha = 2.0/(1.0+length); 
   int    per   = (length-1.0)/2.0; 

   workZl[r][_price+instanceNo] = price;
   if (r<per)
          workZl[r][_zlema+instanceNo] = price;
   else   workZl[r][_zlema+instanceNo] = workZl[r-1][_zlema+instanceNo]+alpha*(2.0*price-workZl[r-per][_price+instanceNo]-workZl[r-1][_zlema+instanceNo]);
   return(workZl[r][_zlema+instanceNo]);
}

//
//
//
//
//

#define Pi       3.14159265358979323846264338327950288
#define _length  0
#define _len     1
#define _weight  2

double  nlm.values[3][_maWorkBufferx1];
double  nlm.prices[ ][_maWorkBufferx1];
double  nlm.alphas[ ][_maWorkBufferx1];

//
//
//
//
//

double iNonLagMa(double price, double length, int r, int instanceNo=0)
{
   if (ArrayRange(nlm.prices,0) != Bars) ArrayResize(nlm.prices,Bars);
                               nlm.prices[r][instanceNo]=price;
   if (length<3 || r<3) return(nlm.prices[r][instanceNo]);
   
   //
   //
   //
   //
   //
   
   if (nlm.values[_length][instanceNo] != length)
   {
      double Cycle = 4.0;
      double Coeff = 3.0*Pi;
      int    Phase = length-1;
      
         nlm.values[_length][instanceNo] = length;
         nlm.values[_len   ][instanceNo] = length*4 + Phase;  
         nlm.values[_weight][instanceNo] = 0;

         if (ArrayRange(nlm.alphas,0) < nlm.values[_len][instanceNo]) ArrayResize(nlm.alphas,nlm.values[_len][instanceNo]);
         for (int k=0; k<nlm.values[_len][instanceNo]; k++)
         {
            if (k<=Phase-1) 
                 double t = 1.0 * k/(Phase-1);
            else        t = 1.0 + (k-Phase+1)*(2.0*Cycle-1.0)/(Cycle*length-1.0); 
            double beta = MathCos(Pi*t);
            double g = 1.0/(Coeff*t+1); if (t <= 0.5 ) g = 1;
      
            nlm.alphas[k][instanceNo]        = g * beta;
            nlm.values[_weight][instanceNo] += nlm.alphas[k][instanceNo];
         }
   }
   
   //
   //
   //
   //
   //
   
   if (nlm.values[_weight][instanceNo]>0)
   {
      double sum = 0;
           for (k=0; k < nlm.values[_len][instanceNo]; k++) sum += nlm.alphas[k][instanceNo]*nlm.prices[r-k][instanceNo];
           return( sum / nlm.values[_weight][instanceNo]);
   }
   else return(0);           
}


//+------------------------------------------------------------------
//|                                                                  
//+------------------------------------------------------------------
//
//
//
//
//

void CatchBullishDivergence(double& buff[], int i)
{
   i++; ObjectDelete(divergenceUniqueID+"l"+DoubleToStr(Time[i],0));
        ObjectDelete(divergenceUniqueID+"l"+"os" + DoubleToStr(Time[i],0));            
   if (!IsIndicatorLow(buff,i)) return;  

   int currentLow = i; int lastLow = GetIndicatorLastLow(buff,i+1); checkBullishDivergence(buff,currentLow,lastLow);
}

//
//
//
//
//

bool checkBullishDivergence(double& buff[], int currentLow, int lastLow)
{
   bool answer=false;
   
   //
   //
   //
   //
   //
   
   if (buff[currentLow] > buff[lastLow] && Low[currentLow] < Low[lastLow])
   {
      if(divergenceOnChartVisible) DrawPriceTrendLine("l",Time[currentLow],Time[lastLow],Low[currentLow],Low[lastLow],divergenceBullishColor,STYLE_SOLID);
      if(divergenceOnIndicatorVisible) DrawIndicatorTrendLine("l",Time[currentLow],Time[lastLow],buff[currentLow],buff[lastLow],divergenceBullishColor,STYLE_SOLID);
      answer= true;
   }
   if (buff[currentLow] < buff[lastLow] && Low[currentLow] > Low[lastLow])
   {
      if(divergenceOnChartVisible)  DrawPriceTrendLine("l",Time[currentLow],Time[lastLow],Low[currentLow],Low[lastLow], divergenceBullishColor, STYLE_DOT);
      if(divergenceOnIndicatorVisible) DrawIndicatorTrendLine("l",Time[currentLow],Time[lastLow],buff[currentLow],buff[lastLow], divergenceBullishColor, STYLE_DOT);
      answer= true;
   }
   return(answer);
}

//
//
//
//
//

void CatchBearishDivergence(double& buff[], int i)
{
   i++; ObjectDelete(divergenceUniqueID+"h"+DoubleToStr(Time[i],0));
        ObjectDelete(divergenceUniqueID+"h"+"os" + DoubleToStr(Time[i],0));            
   if (IsIndicatorPeak(buff,i) == false) return;

   int currentPeak = i; int lastPeak = GetIndicatorLastPeak(buff,i+1); checkBearishDivergence(buff,currentPeak,lastPeak);
}

//
//
//
//
//

bool checkBearishDivergence(double& buff[], int currentPeak, int lastPeak)
{
   bool answer=false;
   
   //
   //
   //
   //
   //
   
   if (buff[currentPeak] < buff[lastPeak] && High[currentPeak] > High[lastPeak])
   {
      if (divergenceOnChartVisible)  DrawPriceTrendLine("h",Time[currentPeak],Time[lastPeak],High[currentPeak],High[lastPeak],divergenceBearishColor,STYLE_SOLID);
      if (divergenceOnIndicatorVisible) DrawIndicatorTrendLine("h",Time[currentPeak],Time[lastPeak],buff[currentPeak],buff[lastPeak],divergenceBearishColor,STYLE_SOLID);
      answer= true;
   }
   if(buff[currentPeak] > buff[lastPeak] && High[currentPeak] < High[lastPeak])
   {
      if (divergenceOnChartVisible)  DrawPriceTrendLine("h",Time[currentPeak],Time[lastPeak],High[currentPeak],High[lastPeak], divergenceBearishColor, STYLE_DOT);
      if (divergenceOnIndicatorVisible) DrawIndicatorTrendLine("h",Time[currentPeak],Time[lastPeak],buff[currentPeak],buff[lastPeak], divergenceBearishColor, STYLE_DOT);
      answer= true;
   }
   return(answer);
}

//
//
//
//
//

bool IsIndicatorPeak(double& buff[], int i) { return(buff[i] >= buff[i+1] && buff[i] > buff[i+2] && buff[i] > buff[i-1]); }
bool IsIndicatorLow( double& buff[], int i) { return(buff[i] <= buff[i+1] && buff[i] < buff[i+2] && buff[i] < buff[i-1]); }
int GetIndicatorLastPeak(double& buff[], int shift)
{
   for(int i = shift+5; i<Bars; i++) if (buff[i] >= buff[i+1] && buff[i] > buff[i+2] && buff[i] >= buff[i-1] && buff[i] > buff[i-2]) return(i);
   return(-1);
}
int GetIndicatorLastLow(double& buff[], int shift)
{
   for(int i = shift+5; i<Bars; i++) if (buff[i] <= buff[i+1] && buff[i] < buff[i+2] && buff[i] <= buff[i-1] && buff[i] < buff[i-2]) return(i);
   return(-1);
}

//+---------------------------------------------------------------------------------------------------------------------------------------------
//|                                                                  
//+---------------------------------------------------------------------------------------------------------------------------------------------
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


//+-------------------------------------------------------------------
//|                                                                  
//+-------------------------------------------------------------------

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
      int char = StringGetChar(s, length);
         if((char > 96 && char < 123) || (char > 223 && char < 256))
                     s = StringSetChar(s, length, char - 32);
         else if(char > -33 && char < 0)
                     s = StringSetChar(s, length, char + 224);
   }
   return(s);
}

//==================================================================+