//------------------------------------------------------------------
#property copyright "mladen"
#property link      "www.forex-TSD.com"
//------------------------------------------------------------------
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 DodgerBlue
#property indicator_color2 Tomato
#property indicator_color3 Tomato
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
//----
extern int Range  = 9;
extern int FastMA = 3;
extern int SlowMA = 30;
extern int filter = 25;
extern int normalizeDigits = 4;
extern bool   alertsOn        = false;
extern bool   alertsOnCurrent = false;
extern bool   alertsMessage   = true;
extern bool   alertsSound     = true;
extern bool   alertsEmail     = false;
extern string soundfile       = "alert2.wav";

//
//
//
//
//

double Downa[];
double Downb[];
double trend[];
double fAMA[];
double mAMA[];
double AMA[];

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

int init()
  {
   IndicatorBuffers(6);
   SetIndexBuffer(0, fAMA); 
   SetIndexBuffer(1, Downa); 
   SetIndexBuffer(2, Downb); 
   SetIndexBuffer(3, trend); 
   SetIndexBuffer(4, mAMA);
   SetIndexBuffer(5, AMA);
   return(0);
}
int deinit()
{
   return(0);
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

int start()
{
   int counted_bars = IndicatorCounted(); 
      if (counted_bars < 0) return(-1); 
      if (counted_bars > 0) counted_bars--;  
         int limit=MathMin(Bars-counted_bars,Bars-1);
         if (trend[limit] == -1) ClearPoint(limit,Downa,Downb);

   //
   //
   //
   //
   //
   
   double k1 = 2.0 / (SlowMA + 1);
   double k2 = 2.0 / (FastMA + 1) - k1;
   for(int i = limit; i>= 0; i--)
   {
      double sdAMA = 0;
      double Noise = 0; for(int k=0; k<Range; k++) Noise += MathAbs(Close[i+k] - Close[i+k+1]);
      double ER    = 0; if(Noise != 0) ER = MathAbs(Close[i] - Close[i+Range]) / Noise;
      double SSC   = (ER*k2+k1);
 
      //
      //
      //
      //
      //
      
      AMA[i]  = AMA[i+1] + NormalizeDouble(SSC*SSC*(Close[i] - AMA[i+1]), normalizeDigits);
      mAMA[i] = AMA[i];
 
         if(filter < 1) fAMA[i] = mAMA[i];
         else
         {
            for(k = i; k <= i + SlowMA - 1; k++)  sdAMA = sdAMA + MathAbs(mAMA[k] - mAMA[k+1]);
               double dAMA  = mAMA[i] - mAMA[i+1];
               if(dAMA >= 0)
                  if(dAMA < NormalizeDouble(filter*sdAMA/(100*SlowMA),4) &&  High[i] <= High[Highest(NULL, 0, MODE_HIGH, 4, i)]+10*Point)
                         fAMA[i] = fAMA[i+1];
                  else   fAMA[i] = mAMA[i];
               else
                  if(MathAbs(dAMA) < NormalizeDouble(filter*sdAMA/(100*SlowMA),4) && Low[i] > Low[Lowest(NULL, 0, MODE_LOW, 4, i)]-10*Point)
                        fAMA[i] = fAMA[i+1];
                  else  fAMA[i] = mAMA[i];
         }
       
      Downa[i] = EMPTY_VALUE;
      Downb[i] = EMPTY_VALUE;
      trend[i] = trend[i+1];
         if (fAMA[i]> fAMA[i+1]) trend[i] =1;
         if (fAMA[i]< fAMA[i+1]) trend[i] =-1;
         if (trend[i]==-1) PlotPoint(i,Downa,Downb,fAMA);
   }
    
   //
   //
   //
   //
   //
      
   if (alertsOn)
   {
      if (alertsOnCurrent)
           int whichBar = 0;
      else     whichBar = 1;
      if (trend[whichBar] != trend[whichBar+1])
      if (trend[whichBar] == 1)
            doAlert("buy");
      else  doAlert("sell");       
   }
   return(0);
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

void doAlert(string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
      if (previousAlert != doWhat || previousTime != Time[0]) {
          previousAlert  = doWhat;
          previousTime   = Time[0];

          //
          //
          //
          //
          //

          message =  StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," AMA STL_Color ",doWhat);
             if (alertsMessage) Alert(message);
             if (alertsEmail)   SendMail(StringConcatenate(Symbol()," AMA STL_Color "),message);
             if (alertsSound)   PlaySound(soundfile);
      }
}
      
//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

void ClearPoint(int i,double& first[],double& second[])
{
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}
void PlotPoint(int i,double& first[],double& second[],double& from[])
{
   if (first[i+1] == EMPTY_VALUE)
      if (first[i+2] == EMPTY_VALUE) 
            { first[i]  = from[i]; first[i+1]  = from[i+1]; second[i] = EMPTY_VALUE; }
      else  { second[i] = from[i]; second[i+1] = from[i+1]; first[i]  = EMPTY_VALUE; }
   else     { first[i]  = from[i]; second[i]   = EMPTY_VALUE; }
}      