//+------------------------------------------------------------------+
//|                                                   Alpha_v1.2.mq4 |
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
extern double  alpha                   =0.04;
extern int     SSALag                  =  25;
extern int     SSANumberOfComputations =   2;
extern int     SSANumberOfBars         = 300;
extern int     FirstBar                = 300; 
extern int     WarningMode             =   0;   // Sound Warning switch(0-off,1-on) 
extern int     AlertMode               =   0;   // Sound Alert switch (0-off,1-on)



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
   SetIndexDrawBegin(0,10);
   SetIndexDrawBegin(1,10);
   //---- indicator buffers mapping
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);

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

   short_name="Alpha["+TF+"]("+DoubleToStr(alpha,2)+","+SSALag+","+SSANumberOfComputations+")";
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
   if(Bars<=10) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
   int pos=Bars-ExtCountedBars-1;
   
   while(pos>=0)
   {
   
      //if(pos<=FirstBar)
      //{ 
   
      double Hi = iCustom(NULL,0,"SSA end-pointed",PRICE_HIGH,SSALag,SSANumberOfComputations,SSANumberOfBars,FirstBar,0,pos);
      double Lo = iCustom(NULL,0,"SSA end-pointed",PRICE_LOW ,SSALag,SSANumberOfComputations,SSANumberOfBars,FirstBar,0,pos);
   
      if(ExtMapBuffer3[pos]==0)ExtMapBuffer3[pos]=Lo;
      if(ExtMapBuffer4[pos]==0)ExtMapBuffer4[pos]=Hi;
      
      if(ExtMapBuffer3[pos+1]!=0)ExtMapBuffer3[pos]=((1-alpha)*ExtMapBuffer3[pos+1])+(alpha*Lo);
      if(ExtMapBuffer4[pos+1]!=0)ExtMapBuffer4[pos]=((1-alpha)*ExtMapBuffer4[pos+1])+(alpha*Hi); 

      if(Hi<ExtMapBuffer4[pos] && Lo<ExtMapBuffer3[pos]) ExtMapBuffer1[pos]=Hi; else ExtMapBuffer1[pos]=EMPTY_VALUE; 
      if(Lo>ExtMapBuffer3[pos] && Hi>ExtMapBuffer4[pos]) ExtMapBuffer2[pos]=Lo; else ExtMapBuffer2[pos]=EMPTY_VALUE;
 	   
      if ((AlertMode > 0 || WarningMode > 0) && pos == 0) 
	   {
         for(int i=0;i<2;i++)
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
      //}
   }     
   
   pos--;
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