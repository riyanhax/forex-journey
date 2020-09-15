//+------------------------------------------------------------------+
//|                                       AdvancedParabolic_v2.2.mq4 |
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

#property indicator_chart_window
#property indicator_buffers 4

#property indicator_color1  LimeGreen
#property indicator_width1  0  
#property indicator_color2  LightCoral
#property indicator_width2  0  
#property indicator_color3  LimeGreen
#property indicator_width3  1  
#property indicator_color4  LightCoral
#property indicator_width4  1  
 
//---- 
extern int     TimeFrame         =     0;   //TimeFrame in min
extern int     Price             =     0;   //Price Mode (0...6)
extern int     HiLoMode          =     0;   //0-off,1-on 
extern double  StartAF           =  0.02;   //Start value of Acceleration Factor
extern double  Step              =  0.02;   //Acceleration Factor increment 
extern double  MaxAF             =   0.2;   //Maximum value of Acceleration Factor   
extern double  Filter            =   0.0;   //Filter in pips
extern double  MinChange         =   0.0;   //Min Change in pips  
extern int     SignalMode        =     1;   //SignalMode: 0-only Stops,1-Signals & Stops

extern string  alerts            = "--- Alerts & Emails ---";
extern int     AlertMode         =     1;
extern int     SoundsNumber      =     5;    //Number of sounds after Signal
extern int     SoundsPause       =     5;    //Pause in sec between sounds 
extern string  UpSound           = "alert.wav";
extern string  DnSound           = "alert2.wav";
extern int     EmailMode         =     0;    //0-on,1-off   
extern int     EmailsNumber      =     1;    //0-on,1-off

//---- 
double UpTrendSAR[];
double DnTrendSAR[];
double UpSignal[];
double DnSignal[];
double AF[];
double trend[];

//----
int      draw_begin; 
string   TF, IndicatorName, short_name, prevmess, prevemail;
double   HighValue[3], LowValue[3], hiprice[3], loprice[3], _point;
datetime prevtime, preTime, ptime;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   if(TimeFrame <= Period()) TimeFrame = Period();
   TF = tf(TimeFrame);
   
   IndicatorDigits(Digits);
//---- 
   IndicatorBuffers(6);
   SetIndexBuffer(0,UpTrendSAR); SetIndexStyle(0,DRAW_ARROW); SetIndexArrow(0,159);
   SetIndexBuffer(1,DnTrendSAR); SetIndexStyle(1,DRAW_ARROW); SetIndexArrow(1,159);
   SetIndexBuffer(2,  UpSignal); SetIndexStyle(2,DRAW_ARROW); SetIndexArrow(2,108);
   SetIndexBuffer(3,  DnSignal); SetIndexStyle(3,DRAW_ARROW); SetIndexArrow(3,108);
   SetIndexBuffer(4,        AF); 
   SetIndexBuffer(5,     trend); 
      
   IndicatorName = WindowExpertName();
   short_name    = IndicatorName + "[" + TF + "]("+Price+","+HiLoMode+","+DoubleToStr(StartAF,3)+","+DoubleToStr(Step,3)+","+DoubleToStr(MaxAF,3)+","+DoubleToStr(Filter,1)+","+DoubleToStr(MinChange,1)+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"UpTrend SAR");
   SetIndexLabel(1,"DnTrend SAR");
   SetIndexLabel(2,"UpTrend Signal");
   SetIndexLabel(3,"DnTrend Signal");
//---- 
   SetIndexDrawBegin(0,2);
   SetIndexDrawBegin(1,2);
//----
    
   _point   = MarketInfo(Symbol(),MODE_POINT)*MathPow(10,Digits%2);
   return(0);
}
//+------------------------------------------------------------------+
//| AdvancedParabolic_v2.1                                           |
//+------------------------------------------------------------------+
int start()
{
   int shift,limit, counted_bars=IndicatorCounted();
      
   if (counted_bars > 0)  limit = Bars - counted_bars - 1;
   if (counted_bars < 0)  return(0);
   if (counted_bars < 1)
   { 
   limit = Bars - 1;   
   for(int i=limit;i>=0;i--) 
      {
      UpTrendSAR[i] = EMPTY_VALUE; 
      DnTrendSAR[i] = EMPTY_VALUE;
      UpSignal[i]   = EMPTY_VALUE; 
      DnSignal[i]   = EMPTY_VALUE;
      }
   }   

   if(TimeFrame != Period())
	{
   limit = MathMax(limit,TimeFrame/Period()+1);   
      
      for(shift = 0;shift < limit;shift++) 
      {	
      int y = iBarShift(NULL,TimeFrame,Time[shift]);
            
      UpTrendSAR[shift] = iCustom(NULL,TimeFrame,IndicatorName,0,Price,HiLoMode,StartAF,Step,MaxAF,Filter,MinChange,SignalMode,
                                  "",AlertMode,SoundsNumber,SoundsPause,UpSound,DnSound,EmailMode,EmailsNumber,0,y);     
      DnTrendSAR[shift] = iCustom(NULL,TimeFrame,IndicatorName,0,Price,HiLoMode,StartAF,Step,MaxAF,Filter,MinChange,SignalMode,
                                  "",AlertMode,SoundsNumber,SoundsPause,UpSound,DnSound,EmailMode,EmailsNumber,1,y);     
              
         if(SignalMode > 0)
         { 
         UpSignal[shift] = iCustom(NULL,TimeFrame,IndicatorName,0,Price,HiLoMode,StartAF,Step,MaxAF,Filter,MinChange,SignalMode,
                                   "",AlertMode,SoundsNumber,SoundsPause,UpSound,DnSound,EmailMode,EmailsNumber,2,y);      
         DnSignal[shift] = iCustom(NULL,TimeFrame,IndicatorName,0,Price,HiLoMode,StartAF,Step,MaxAF,Filter,MinChange,SignalMode,
                                   "",AlertMode,SoundsNumber,SoundsPause,UpSound,DnSound,EmailMode,EmailsNumber,3,y); 
         }
      }
   
   return(0);
   }
   else _UniSAR(limit);
      
   return(0);
}

void _UniSAR(int limit)
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
      DnTrendSAR[shift] = EMPTY_VALUE;
      }
      else 
      if(shift < Bars-2)
      {
      HighValue[0] = HighValue[1];
      LowValue [0] = LowValue [1];
      trend[shift] = trend[shift+1];
      AF[shift]    = AF[shift+1];
            
      UpTrendSAR[shift] = EMPTY_VALUE; 
      DnTrendSAR[shift] = EMPTY_VALUE;
      UpSignal  [shift] = EMPTY_VALUE; 
      DnSignal  [shift] = EMPTY_VALUE;			
		   
		   if(trend[shift+1] > 0)
		   {
            if(trend[shift+1] == trend[shift+2])
            {
            if(HighValue[1] > HighValue[2]) AF[shift] = AF[shift+1] + Step;
            if(AF[shift] > MaxAF) AF[shift] = MaxAF;
            if(HighValue[1] < HighValue[2]) AF[shift] = StartAF; 
            } else AF[shift] = AF[shift+1];
            
         UpTrendSAR[shift] = UpTrendSAR[shift+1] + AF[shift] * (HighValue[1] - UpTrendSAR[shift+1]); 
		   	   
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
            if(LowValue[1] > LowValue[2]) AF[shift] = StartAF; //AF[shift+1] + Step; 
            } else AF[shift] = AF[shift+1];
         
         DnTrendSAR[shift] = DnTrendSAR[shift+1] + AF[shift] * (LowValue[1] - DnTrendSAR[shift+1]); 
		   		   	   
		   if(DnTrendSAR[shift] < hiprice[1]) DnTrendSAR[shift] = hiprice[1];
	      if(DnTrendSAR[shift] < hiprice[2]) DnTrendSAR[shift] = hiprice[2]; 
         } 

		if(hiprice[0] > HighValue[0]) HighValue[0] = hiprice[0];
		if(loprice[0] <  LowValue[0]) LowValue[0]  = loprice[0];
         
         if(MinChange > 0)
		   {     
		   if(UpTrendSAR[shift] - UpTrendSAR[shift+1] < MinChange*_point && UpTrendSAR[shift]!= EMPTY_VALUE && UpTrendSAR[shift+1]!= EMPTY_VALUE) UpTrendSAR[shift] = UpTrendSAR[shift+1]; 
		   if(DnTrendSAR[shift+1] - DnTrendSAR[shift] < MinChange*_point && DnTrendSAR[shift]!= EMPTY_VALUE && DnTrendSAR[shift+1]!= EMPTY_VALUE) DnTrendSAR[shift] = DnTrendSAR[shift+1]; 
		   } 
      
      if(trend[shift] < 0 && DnTrendSAR[shift] > DnTrendSAR[shift+1]) DnTrendSAR[shift] = DnTrendSAR[shift+1];
		if(trend[shift] > 0 && UpTrendSAR[shift] < UpTrendSAR[shift+1]) UpTrendSAR[shift] = UpTrendSAR[shift+1];
   
         if(trend[shift] < 0 && hiprice[0] >= DnTrendSAR[shift] + Filter*_point) 
		   {
		   trend[shift] =  1;		
		   
		   UpTrendSAR[shift] = LowValue[0]; 
		   if(SignalMode  > 0) UpSignal  [shift] = LowValue[0]; 
		   DnTrendSAR[shift] = EMPTY_VALUE;
		   
		   AF[shift]  = StartAF;
		   LowValue[0]  = loprice[0];
		   HighValue[0] = hiprice[0];
		   } 
		   else
		   if(trend[shift] > 0 && loprice[0] <= UpTrendSAR[shift] - Filter*_point) 
		   {
		   trend[shift] = -1; 
		
		   DnTrendSAR[shift] = HighValue[0];
		   if(SignalMode  > 0) DnSignal  [shift] = HighValue[0]; 
		   UpTrendSAR[shift] = EMPTY_VALUE;
		   
		   AF[shift]  = StartAF;
		   LowValue[0]  = loprice[0];
		   HighValue[0] = hiprice[0];
		   }  
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
         BoxAlert(uptrend," : BUY Signal at " +DoubleToStr(Close[1],Digits)+", StopLoss at "+DoubleToStr(UpSignal[1],Digits));   
         BoxAlert(dntrend," : SELL Signal at "+DoubleToStr(Close[1],Digits)+", StopLoss at "+DoubleToStr(DnSignal[1],Digits)); 
         }
      
      WarningSound(uptrend,SoundsNumber,SoundsPause,UpSound,Time[1]);
      WarningSound(dntrend,SoundsNumber,SoundsPause,DnSound,Time[1]);
         
         if(EmailMode > 0)
         {
         EmailAlert(uptrend,"BUY" ," : BUY Signal at " +DoubleToStr(Close[1],Digits)+", StopLoss at "+DoubleToStr(UpSignal[1],Digits),EmailsNumber); 
         EmailAlert(dntrend,"SELL"," : SELL Signal at "+DoubleToStr(Close[1],Digits)+", StopLoss at "+DoubleToStr(DnSignal[1],Digits),EmailsNumber); 
         }
      }
   }
}   
   
     
//----

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