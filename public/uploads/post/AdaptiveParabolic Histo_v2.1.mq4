//+------------------------------------------------------------------+
//|                                 AdaptiveParabolic Histo_v2.1.mq4 |
//|                                Copyright © 2014, TrendLaboratory |
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |
//|                                   E-mail: igorad2003@yahoo.co.uk |
//+------------------------------------------------------------------+
// List of Prices:
// Price    = 0 - Close  
// Price    = 1 - Open  
// Price    = 2 - High  
// Price    = 3 - Low  
// Price    = 4 - Median Price   = (High+Low)/2  
// Price    = 5 - Typical Price  = (High+Low+Close)/3  
// Price    = 6 - Weighted Close = (High+Low+Close*2)/4

 
#property copyright "Copyright © 2014, TrendLaboratory"
#property link      "http://finance.groups.yahoo.com/group/TrendLaboratory"

#property indicator_separate_window
#property indicator_buffers 2

#property indicator_color1  DodgerBlue
#property indicator_width1  2  
#property indicator_color2  OrangeRed
#property indicator_width2  2  

#property indicator_minimum 0 

//---- 
extern int     TimeFrame         =     0;    //TimeFrame in min
extern int     Price             =     0;    //Price Mode (0...6)
extern int     HiLoMode          =     0;    //0-off,1-on 
extern double  StartAF           =  0.02;    //Start value of Acceleration Factor
extern double  MinStep           =  0.00;    //Minimum Acceleration Factor increment 
extern double  MaxStep           =  0.02;    //Maximum Acceleration Factor increment 
extern double  MaxAF             =   0.2;    //Maximum value of Acceleration Factor   
extern int     AdaptiveMode      =     1;    //0-off,1-Kaufman,2-Ehlers
extern int     AdaptiveSmooth    =     5;    //Adaptive Smoothing Period 
extern double  Filter            =   0.0;    //Filter in pips
extern double  MinChange         =   0.0;    //Min Change in pips  
extern double  IndicatorValue    =     1;    //Indicator Value (ex.1.0)

extern string  alerts            = "--- Alerts & Emails ---";
extern int     AlertMode         =     1;    //Alert Mode: 0-off,1-on
extern int     SoundsNumber      =     5;    //Number of sounds after Signal
extern int     SoundsPause       =     5;    //Pause in sec between sounds 
extern string  UpSound           = "alert.wav";
extern string  DnSound           = "alert2.wav";
extern int     EmailMode         =     0;    //0-on,1-off   
extern int     EmailsNumber      =     1;    //0-on,1-off

//---- 
double UpTrend[];
double DnTrend[];
double UpTrendSAR[];
double DnTrendSAR[];
double AF[];
double trend[];
double inputs[];
//----
int      draw_begin, length; 
string   TF, IndicatorName, short_name, prevmess, prevemail;
double   HighValue[3], LowValue[3], hiprice[3], loprice[3], _point;
datetime prevtime, prevematime, preTime, ptime;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   if(TimeFrame <= Period()) TimeFrame = Period();
   TF = tf(TimeFrame);
   if(TF  == "Unknown timeframe") TimeFrame = Period();
   
   IndicatorDigits(1);
//---- 
   IndicatorBuffers(7);
   SetIndexBuffer(0,   UpTrend); SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(1,   DnTrend); SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(2,UpTrendSAR); 
   SetIndexBuffer(3,DnTrendSAR); 
   
   SetIndexBuffer(4,        AF); 
   SetIndexBuffer(5,     trend); 
   SetIndexBuffer(6,    inputs);
      
   IndicatorName = WindowExpertName();
   short_name    = IndicatorName + "[" + TF + "]("+Price+","+HiLoMode+","+DoubleToStr(StartAF,3)+","+DoubleToStr(MinStep,3)+","+DoubleToStr(MaxStep,3)+","+DoubleToStr(MaxAF,3)+","+DoubleToStr(Filter,1)+","+DoubleToStr(MinChange,1)+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"UpTrend SAR");
   SetIndexLabel(1,"DnTrend SAR");
   
//---- 
   SetIndexDrawBegin(0,2);
   SetIndexDrawBegin(1,2);
//----
    
   _point = Point*MathPow(10,Digits%2);
   if(MaxAF > 0) length = (2/MaxAF - 1);
   
   return(0);
}
//+------------------------------------------------------------------+
//| AdaptiveParabolic Histo_v2.1                                     |
//+------------------------------------------------------------------+
int start()
{
   int shift,limit, counted_bars=IndicatorCounted();
      
   if(counted_bars > 0) limit = Bars - counted_bars - 1;
   if(counted_bars < 0) return(0);
   if(counted_bars < 1)
   { 
   limit = Bars - 1;   
   for(int i=limit;i>=0;i--) 
      {
      UpTrend[i] = EMPTY_VALUE; 
      DnTrend[i] = EMPTY_VALUE;
      }
   }   

   if(TimeFrame != Period())
	{
   limit = MathMax(limit,TimeFrame/Period()+1);   
      
      for(shift = 0;shift < limit;shift++) 
      {	
      int y = iBarShift(NULL,TimeFrame,Time[shift]);
            
      UpTrend[shift] = iCustom(NULL,TimeFrame,IndicatorName,0,Price,HiLoMode,StartAF,MinStep,MaxStep,MaxAF,AdaptiveMode,AdaptiveSmooth,Filter,MinChange,IndicatorValue,
                               "",AlertMode,SoundsNumber,SoundsPause,UpSound,DnSound,EmailMode,EmailsNumber,0,y);     
      DnTrend[shift] = iCustom(NULL,TimeFrame,IndicatorName,0,Price,HiLoMode,StartAF,MinStep,MaxStep,MaxAF,AdaptiveMode,AdaptiveSmooth,Filter,MinChange,IndicatorValue,
                               "",AlertMode,SoundsNumber,SoundsPause,UpSound,DnSound,EmailMode,EmailsNumber,1,y);     
      }
   
   return(0);
   }
   else _AdaptiveSAR(limit);
      
   return(0);
}

void _AdaptiveSAR(int limit)
{   
   for(int shift=limit;shift>=0;shift--) 
   {
      if(prevtime != Time[shift])
      {
      HighValue[2] = HighValue[1]; HighValue[1] = HighValue[0];
      LowValue[2]  = LowValue[1] ; LowValue[1]  = LowValue[0] ;
      hiprice[2]   = hiprice[1]  ; hiprice[1]   = hiprice[0]  ;
      loprice[2]   = loprice[1]  ; loprice[1]   = loprice[0]  ;  
      prevtime     = Time[shift] ;
      }
      
      if(HiLoMode > 0)
      {
      hiprice[0] = High[shift];
      loprice[0] = Low[shift];
      }
      else
      {
      hiprice[0] = iMA(NULL,0,1,0,0,Price,shift);
      loprice[0] = hiprice[0];
      }
      
      if(shift == Bars-2) 
      {
      trend[shift] = 1;
         
      HighValue[1] = hiprice[1];
      HighValue[0] = MathMax(hiprice[0],HighValue[1]);
      LowValue[1]  = loprice[1];
      LowValue[0]  = MathMin(loprice[0],LowValue[1]);
      AF[shift]    = StartAF;   
      UpTrendSAR[shift] = LowValue[0];
      DnTrendSAR[shift] = 0;
      }
      else 
      if(shift < Bars-2)
      {
      HighValue[0] = HighValue[1];
      LowValue [0] = LowValue [1];
      trend[shift] = trend[shift+1];
      AF[shift]    = AF[shift+1];
      
         if(AdaptiveMode > 0)
         { 
         if(HiLoMode > 0) double inprice = iMA(NULL,0,1,0,0,4,shift); else inprice = hiprice[0];
         
            if(AdaptiveMode == 1) inputs[shift] = inprice; 
            else
            if(AdaptiveMode == 2)
            {
               if(UpTrendSAR[shift+1] != 0) inputs[shift] = MathAbs(inprice - UpTrendSAR[shift+1]); 
               else 
               if(DnTrendSAR[shift+1] != 0) inputs[shift] = MathAbs(inprice - DnTrendSAR[shift+1]);
            }
      
         double Step = MinStep + AdaptiveFactor(AdaptiveMode,inputs,length,AdaptiveSmooth,shift)*(MaxStep - MinStep);      
         }
         else Step = MaxStep;
      
      //UpTrendSAR[shift] = EMPTY_VALUE; 
      //DnTrendSAR[shift] = EMPTY_VALUE;
      		   
		   if(trend[shift+1] > 0)
		   {
            if(trend[shift+1] == trend[shift+2])
            {
            if(HighValue[1] > HighValue[2]) AF[shift] = AF[shift+1] + Step;
            if(AF[shift] > MaxAF) AF[shift] = MaxAF;
            if(HighValue[1] < HighValue[2]) AF[shift] = StartAF; 
            } else AF[shift] = AF[shift+1];
            
         UpTrendSAR[shift] = UpTrendSAR[shift+1] + AF[shift]*(HighValue[1] - UpTrendSAR[shift+1]); 
		   	   
		   if(UpTrendSAR[shift] > loprice[1]) UpTrendSAR[shift] = loprice[1];
	      if(UpTrendSAR[shift] > loprice[2]) UpTrendSAR[shift] = loprice[2];
         }
		   else
         if(trend[shift+1] < 0)
         {
            if(trend[shift+1] == trend[shift+2])
            {         
            if(LowValue[1] < LowValue[2]) AF[shift] = AF[shift+1] + Step;  
            if(AF[shift] > MaxAF) AF[shift] = MaxAF;
            if(LowValue[1] > LowValue[2]) AF[shift] = StartAF; 
            } else AF[shift] = AF[shift+1];
         
         DnTrendSAR[shift] = DnTrendSAR[shift+1] + AF[shift]*(LowValue[1] - DnTrendSAR[shift+1]); 
		   		   	   
		   if(DnTrendSAR[shift] < hiprice[1]) DnTrendSAR[shift] = hiprice[1];
	      if(DnTrendSAR[shift] < hiprice[2]) DnTrendSAR[shift] = hiprice[2]; 
         } 

		if(hiprice[0] > HighValue[0]) HighValue[0] = hiprice[0];
		if(loprice[0] <  LowValue[0]) LowValue[0]  = loprice[0];
         
         if(MinChange > 0)
		   {     
		   if(UpTrendSAR[shift] - UpTrendSAR[shift+1] < MinChange*_point && UpTrendSAR[shift]!= 0 && UpTrendSAR[shift+1]!= 0) UpTrendSAR[shift] = UpTrendSAR[shift+1]; 
		   if(DnTrendSAR[shift+1] - DnTrendSAR[shift] < MinChange*_point && DnTrendSAR[shift]!= 0 && DnTrendSAR[shift+1]!= 0) DnTrendSAR[shift] = DnTrendSAR[shift+1]; 
		   } 
      
      if(trend[shift] < 0 && DnTrendSAR[shift] > DnTrendSAR[shift+1]) DnTrendSAR[shift] = DnTrendSAR[shift+1];
		if(trend[shift] > 0 && UpTrendSAR[shift] < UpTrendSAR[shift+1]) UpTrendSAR[shift] = UpTrendSAR[shift+1];
   
         if(trend[shift] < 0 && hiprice[0] >= DnTrendSAR[shift] + Filter*_point) 
		   {
		   trend[shift] =  1;		
		   
		   UpTrendSAR[shift] = LowValue[0]; 
		   DnTrendSAR[shift] = 0;
		   
		   AF[shift]    = StartAF;
		   LowValue[0]  = loprice[0];
		   HighValue[0] = hiprice[0];
		   } 
		   else
		   if(trend[shift] > 0 && loprice[0] <= UpTrendSAR[shift] - Filter*_point) 
		   {
		   trend[shift] = -1; 
		
		   DnTrendSAR[shift] = HighValue[0];
		   UpTrendSAR[shift] = 0;
		   
		   AF[shift]    = StartAF;
		   LowValue[0]  = loprice[0];
		   HighValue[0] = hiprice[0];
		   }  
		
		UpTrend[shift] = 0; 
      DnTrend[shift] = 0;
     
		if(trend[shift] > 0) UpTrend[shift] = IndicatorValue;
      if(trend[shift] < 0) DnTrend[shift] = IndicatorValue; 
		}  
   }
   
   if(AlertMode > 0)
   {
   bool uptrend = trend[1] > 0 && trend[2] <= 0;                  
   bool dntrend = trend[1] < 0 && trend[2] >= 0;
        
      if(uptrend || dntrend)
      {
         if(isNewBar(TimeFrame))
         {
         BoxAlert(uptrend," : BUY Signal at " +DoubleToStr(Close[1],Digits));   
         BoxAlert(dntrend," : SELL Signal at "+DoubleToStr(Close[1],Digits)); 
         }
      
      WarningSound(uptrend,SoundsNumber,SoundsPause,UpSound,Time[1]);
      WarningSound(dntrend,SoundsNumber,SoundsPause,DnSound,Time[1]);
         
         if(EmailMode > 0)
         {
         EmailAlert(uptrend,"BUY" ," : BUY Signal at " +DoubleToStr(Close[1],Digits),EmailsNumber); 
         EmailAlert(dntrend,"SELL"," : SELL Signal at "+DoubleToStr(Close[1],Digits),EmailsNumber); 
         }
      }
   }
}   
   
double seff[2];
     
//----
double AdaptiveFactor(int mode,double& array[],int per,int smooth,int bar)
{
   if(prevematime != Time[bar]){seff[1] = seff[0]; prevematime = Time[bar];} 
      
   if(mode == 1) int len = per; else len = MathMax(20,5*per);
   
   double sum = 0;
   double max = 0, min = 1000000000; 
   
   
      for(int i = 0;i < len;i++) 
      {
         if(mode == 1) sum += MathAbs(array[bar+i] - array[bar+i+1]); 
         else
         {
         if (array[bar+i] > max) max = array[bar+i]; 
         if (array[bar+i] < min) min = array[bar+i]; 
         }
      }
      
      if(mode == 1 && sum!= 0) double eff = MathAbs(array[bar] - array[bar+len])/sum;
      else 
      if(mode == 2 && (max-min) > 0) eff = (array[bar] - min)/(max - min);
   
   seff[0] = EMAOnArray(eff,seff[1],smooth,bar); 
   
   return(seff[0]);
}

double EMAOnArray(double price,double prev,int per,int bar)
{
   if(bar >= Bars - 2) double ema = price;
   else 
   ema = prev + 2.0/(1+per)*(price - prev); 
   
   return(ema);
}
   
string tf(int timeframe)
{
   switch(timeframe)
   {
   case PERIOD_M1:   return("M1");
   case PERIOD_M5:   return("M5");
   case PERIOD_M15:  return("M15");
   case PERIOD_M30:  return("M30");
   case PERIOD_H1:   return("H1");
   case PERIOD_H4:   return("H4");
   case PERIOD_D1:   return("D1");
   case PERIOD_W1:   return("W1");
   case PERIOD_MN1:  return("MN1");
   default:          return("Unknown timeframe");
   }
}

bool isNewBar(int tf)
{
   static datetime pTime;
   bool res=false;
   
   if(tf >= 0)
   {
      if (iTime(NULL,tf,0)!= pTime)
      {
      res=true;
      pTime=iTime(NULL,tf,0);
      }   
   }
   else res = true;
   
   return(res);
}

bool BoxAlert(bool cond,string text)   
{      
   string mess = IndicatorName + "("+Symbol()+","+TF + ")" + text;
   
   if (cond && mess != prevmess)
	{
	Alert (mess);
	prevmess = mess; 
	return(true);
	} 
  
   return(false);  
}

bool Pause(int sec)
{
   if(TimeCurrent() >= preTime + sec) {preTime = TimeCurrent(); return(true);}
   
   return(false);
}

void WarningSound(bool cond,int num,int sec,string sound,datetime ctime)
{
   static int i;
   
   if(cond)
   {
   if(ctime != ptime) i = 0; 
   if(i < num && Pause(sec)) {PlaySound(sound); ptime = ctime; i++;}       	
   }
}

bool EmailAlert(bool cond,string text1,string text2,int num)   
{      
   string subj = "New " + text1 +" Signal from " + IndicatorName + "!!!";    
   string mess = IndicatorName + "("+Symbol()+","+TF + ")" + text2;
   
   if (cond && mess != prevemail)
	{
	if(subj != "" && mess != "") for(int i=0;i<num;i++) SendMail(subj, mess);  
	prevemail = mess; 
	return(true);
	} 
  
   return(false);  
}	            