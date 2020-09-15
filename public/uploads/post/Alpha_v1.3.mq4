//+------------------------------------------------------------------+
//|                                                  Alpha_v11.3.mq4 |
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
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 White
#property indicator_width1 3
#property indicator_width2 3

//----
extern double  alpha             =0.04;
extern int     PreSmooth         =   1;   // Period of PreSmoothing
extern int     PreSmoothMode     =   0;   // PreSmooth MA's Method = 0...3 
extern int     WarningMode       =   0;   // Sound Warning switch(0-off,1-on) 
extern int     AlertMode         =   0;   // Sound Alert switch (0-off,1-on)



string  Up_Sound          = "alert.wav";
string  Dn_Sound          = "alert2.wav";
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
//----
int ExtCountedBars=0;
string short_name, TF, IndicatorName, prevmess;
datetime prevTime, preTime;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
int init()
  {
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
//---- indicators
   IndicatorBuffers(4);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexStyle(1,DRAW_LINE);
   
   SetIndexBuffer(2, ExtMapBuffer3);
   SetIndexBuffer(3, ExtMapBuffer4);
//----
   SetIndexDrawBegin(0,PreSmooth);
   SetIndexDrawBegin(1,PreSmooth);
   //---- indicator buffers mapping
      switch(Period())
   {
   case 1     : TF = "M1" ; break;
   case 5     : TF = "M5" ; break;
   case 15    : TF = "M15"; break;
   case 30    : TF = "M30"; break;
   case 60    : TF = "H1" ; break;
   case 240   : TF = "H4" ; break;
   case 1440  : TF = "D1" ; break;
   case 10080 : TF = "W1" ; break;
   case 43200 : TF = "MN1"; break;
   } 

   short_name="Alpha["+TF+"]("+DoubleToStr(alpha,2)+","+PreSmooth+","+PreSmoothMode+")";
   IndicatorShortName(short_name);
   SetIndexLabel(1,"UpTrend");
   SetIndexLabel(0,"DnTrend");
   
   
   
   IndicatorName = WindowExpertName();
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
   int    i,pos,limit,counted_bars=IndicatorCounted();
   if (counted_bars < 0) return(-1);
      
   if(counted_bars<1)
      for(i=0;i<=Bars-1;i++) 
      {
      ExtMapBuffer1[i] = EMPTY_VALUE;
      ExtMapBuffer2[i] = EMPTY_VALUE;
      }
      
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   
   for(pos=limit;pos>=0;pos--)
   {
   
   double Hi = iMA(NULL,0,PreSmooth,0,PreSmoothMode,2,pos);
   double Lo = iMA(NULL,0,PreSmooth,0,PreSmoothMode,3,pos);
   
      if(pos > Bars - PreSmooth -1)
      {
      ExtMapBuffer3[pos]=Hi; 
      ExtMapBuffer4[pos]=Lo;
      }
      else
      if(pos <= Bars - PreSmooth -1)
      {
      ExtMapBuffer3[pos]=((1-alpha)*ExtMapBuffer3[pos+1])+(alpha*Lo);
      ExtMapBuffer4[pos]=((1-alpha)*ExtMapBuffer4[pos+1])+(alpha*Hi); 

      if(Hi<ExtMapBuffer4[pos] && Lo<ExtMapBuffer3[pos]) ExtMapBuffer1[pos]=Hi; else ExtMapBuffer1[pos]=EMPTY_VALUE; 
      if(Lo>ExtMapBuffer3[pos] && Hi>ExtMapBuffer4[pos]) ExtMapBuffer2[pos]=Lo; else ExtMapBuffer2[pos]=EMPTY_VALUE;
 	   
         if ((AlertMode > 0 || WarningMode > 0) && pos == 0) 
         {
            for(i=0;i<2;i++)
            {
            bool upsig = ExtMapBuffer2[pos+i] > 0 && ExtMapBuffer2[pos+i+1] == EMPTY_VALUE && ExtMapBuffer2[pos+i] != EMPTY_VALUE;
            bool dnsig = ExtMapBuffer1[pos+i] > 0 && ExtMapBuffer1[pos+i+1] == EMPTY_VALUE && ExtMapBuffer1[pos+i] != EMPTY_VALUE;   
         
               if(i == 0 && WarningMode > 0) 
               {
               if(upsig) WarningSound(1,0,Up_Sound);
               if(dnsig) WarningSound(1,0,Dn_Sound);
               }
               else
               if(i == 1 && AlertMode > 0)
               {         
               BoxAlert(upsig ," : BUY Signal, Open: "+DoubleToStr(Open[pos],Digits));  
               BoxAlert(dnsig ," : SELL Signal, Open: "+DoubleToStr(Open[pos],Digits));
               }
            }
         }
      }
   }
//----
   
   return(0);
}
//+------------------------------------------------------------------+
bool BoxAlert(bool cond,string text)   
{      
   string mess = " "+Symbol()+" "+TF + ":" + " " + IndicatorName + text;
   
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

void WarningSound(int num,int sec,string sound)
{
   int i = 0;     
     
   while(i < num) if(Pause(sec)) {PlaySound(sound); i++;}       	
}	         