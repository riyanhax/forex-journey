//+------------------------------------------------------------------+
//|                                         VoltyChannel_Stop_v2.mq4 |
//|                                Copyright © 2007, TrendLaboratory |
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |
//|                                   E-mail: igorad2003@yahoo.co.uk |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, TrendLaboratory"
#property link      "http://finance.groups.yahoo.com/group/TrendLaboratory"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_color4 Red
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1
//---- input parameters
extern int     Price       = 0; //Applied Price: 0-C,1-O,2-H,3-L,4-Median,5-Typical,6-Weighted
extern int     JMALength   = 50; //MA's Period 
extern int     ATR_Length  = 10; //ATR's Period
extern double  Kv          = 4; //Volatility's Factor or Multiplier
extern double  MoneyRisk   = 1; //Offset Factor 
extern int     AlertMode   = 1; //0-alert off,1-on
extern int     VisualMode  = 1; //0-lines,1-dots 
extern double  Phase       = 0;
//---- indicator buffers
double UpBuffer[];
double DnBuffer[];
double UpSignal[];
double DnSignal[];
double smin[];
double smax[];
double trend[];

bool   UpTrendAlert=false, DownTrendAlert=false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
  int init()
  {
   string short_name;
//---- indicator line
   IndicatorBuffers(7);
   SetIndexBuffer(0,UpBuffer);
   SetIndexBuffer(1,DnBuffer);
   SetIndexBuffer(2,UpSignal);
   SetIndexBuffer(3,DnSignal);
   SetIndexBuffer(4,smin);
   SetIndexBuffer(5,smax);
   SetIndexBuffer(6,trend);
   
      if(VisualMode==0)
      {
      SetIndexStyle(0,DRAW_LINE);
      SetIndexStyle(1,DRAW_LINE);
      }
      else
      {
      SetIndexStyle(0,DRAW_ARROW);
      SetIndexStyle(1,DRAW_ARROW);
      SetIndexArrow(0,159);
      SetIndexArrow(1,159);
      }
   
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(2,108);
   SetIndexArrow(3,108);
//---- name for DataWindow and indicator subwindow label
   short_name="VoltyChannel_Stop("+JMALength+","+ATR_Length+","+DoubleToStr(Kv,3)+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"UpTrend");
   SetIndexLabel(1,"DnTrend");
   SetIndexLabel(2,"UpSignal");
   SetIndexLabel(3,"DnSignal");
//----
   SetIndexDrawBegin(0,JMALength+ATR_Length);
   SetIndexDrawBegin(1,JMALength+ATR_Length);
   SetIndexDrawBegin(2,JMALength+ATR_Length);
   SetIndexDrawBegin(3,JMALength+ATR_Length);

//----
   return(0);
  }

//+------------------------------------------------------------------+
//| VoltyChannel_Stop_2                                              |
//+------------------------------------------------------------------+
int start()
  {
   
   int shift,limit, counted_bars=IndicatorCounted();
   
   if ( counted_bars > 0 )  limit=Bars-counted_bars;
   if ( counted_bars < 0 )  return(0);
   if ( counted_bars ==0 )  limit=Bars-JMALength-1; 
     
	for(shift=limit;shift>=0;shift--) 
   {	
      if(Price==2 || Price==3)
      {
      double bprice = iSmooth(iMA(NULL,0,1,0,MODE_SMA,PRICE_HIGH,shift),JMALength,Phase,shift,0);
      double sprice = iSmooth(iMA(NULL,0,1,0,MODE_SMA,PRICE_LOW, shift),JMALength,Phase,shift,10);
      }
      else
      {
      bprice = iSmooth(iMA(NULL,0,1,0,MODE_SMA,Price,shift),JMALength,Phase,shift,0);
      sprice = iSmooth(iMA(NULL,0,1,0,MODE_SMA,Price,shift),JMALength,Phase,shift,10);
      }
       
   smin[shift] = sprice - Kv*iATR(NULL,0,ATR_Length,shift); 
	smax[shift] = bprice + Kv*iATR(NULL,0,ATR_Length,shift);
	
   trend[shift]=trend[shift+1];
   if ( bprice > smax[shift+1] ) trend[shift] =  1;
   if ( sprice < smin[shift+1] ) trend[shift] = -1;
	
      if ( trend[shift] >0 ) 
	   {
	   if( smin[shift] < smin[shift+1]) smin[shift] = smin[shift+1];
	   UpBuffer[shift] = smin[shift] - (MoneyRisk - 1)*iATR(NULL,0,ATR_Length,shift);
	   if( UpBuffer[shift] < UpBuffer[shift+1] && UpBuffer[shift+1]!=EMPTY_VALUE) UpBuffer[shift] = UpBuffer[shift+1];
	   if(trend[shift+1] != trend[shift]) UpSignal[shift] = UpBuffer[shift];
	   else UpSignal[shift] = EMPTY_VALUE;
	   DnBuffer[shift] = EMPTY_VALUE;
	   DnSignal[shift] = EMPTY_VALUE;
	   }
	   else
	   if ( trend[shift] <0 ) 
	   {
	   if( smax[shift]>smax[shift+1]) smax[shift] = smax[shift+1];
	   DnBuffer[shift] = smax[shift] + (MoneyRisk - 1)*iATR(NULL,0,ATR_Length,shift);
	   if( DnBuffer[shift] > DnBuffer[shift+1]) DnBuffer[shift] = DnBuffer[shift+1];
	   if(trend[shift+1] != trend[shift]) DnSignal[shift] = DnBuffer[shift];
	   else DnSignal[shift] = EMPTY_VALUE;
	   UpBuffer[shift] = EMPTY_VALUE;
	   UpSignal[shift] = EMPTY_VALUE;
	   }
   }
//----------   
   string Message;
   
   if ( trend[2]<0 && trend[1]>0 && Volume[0]>1 && !UpTrendAlert)
	{
	Message = " "+Symbol()+" M"+Period()+": Signal for BUY";
	if ( AlertMode>0 ) Alert (Message); 
	UpTrendAlert=true; DownTrendAlert=false;
	} 
	 	  
	if ( trend[2]>0 && trend[1]<0 && Volume[0]>1 && !DownTrendAlert)
	{
	Message = " "+Symbol()+" M"+Period()+": Signal for SELL";
	if ( AlertMode>0 ) Alert (Message); 
	DownTrendAlert=true; UpTrendAlert=false;
	} 	         
//----	
   return(0);	
}


double wrk[][20];

#define bsmax  5
#define bsmin  6
#define volty  7
#define vsum   8
#define avolty 9

//
//
//
//
//

double iSmooth(double price, double length, double phase, int i, int s=0)
{
   if (length <=1) return(price);
   if (ArrayRange(wrk,0) != Bars) ArrayResize(wrk,Bars);
   
   int r = Bars-i-1; 
      if (r==0) { for(int k=0; k<7; k++) wrk[r][k+s]=price; for(; k<10; k++) wrk[r][k+s]=0; return(price); }

   //
   //
   //
   //
   //
   
      double len1   = MathMax(MathLog(MathSqrt(0.5*(length-1)))/MathLog(2.0)+2.0,0);
      double pow1   = MathMax(len1-2.0,0.5);
      double del1   = price - wrk[r-1][bsmax+s];
      double del2   = price - wrk[r-1][bsmin+s];
      double div    = 1.0/(10.0+10.0*(MathMin(MathMax(length-10,0),100))/100);
      int    forBar = MathMin(r,10);
	
         wrk[r][volty+s] = 0;
               if(MathAbs(del1) > MathAbs(del2)) wrk[r][volty+s] = MathAbs(del1); 
               if(MathAbs(del1) < MathAbs(del2)) wrk[r][volty+s] = MathAbs(del2); 
         wrk[r][vsum+s] =	wrk[r-1][vsum+s] + (wrk[r][volty+s]-wrk[r-forBar][volty+s])*div;
         
         //
         //
         //
         //
         //
   
         wrk[r][avolty+s] = wrk[r-1][avolty+s]+(2.0/(MathMax(4.0*length,30)+1.0))*(wrk[r][vsum+s]-wrk[r-1][avolty+s]);
            if (wrk[r][avolty+s] > 0)
               double dVolty = wrk[r][volty+s]/wrk[r][avolty+s]; else dVolty = 0;   
	               if (dVolty > MathPow(len1,1.0/pow1)) dVolty = MathPow(len1,1.0/pow1);
                  if (dVolty < 1)                      dVolty = 1.0;

      //
      //
      //
      //
      //
	        
   	double pow2 = MathPow(dVolty, pow1);
      double len2 = MathSqrt(0.5*(length-1))*len1;
      double Kv   = MathPow(len2/(len2+1), MathSqrt(pow2));

         if (del1 > 0) wrk[r][bsmax+s] = price; else wrk[r][bsmax+s] = price - Kv*del1;
         if (del2 < 0) wrk[r][bsmin+s] = price; else wrk[r][bsmin+s] = price - Kv*del2;
	
   //
   //
   //
   //
   //
      
      double R     = MathMax(MathMin(phase,100),-100)/100.0 + 1.5;
      double beta  = 0.45*(length-1)/(0.45*(length-1)+2);
      double alpha = MathPow(beta,pow2);

         wrk[r][0+s] = price + alpha*(wrk[r-1][0+s]-price);
         wrk[r][1+s] = (price - wrk[r][0+s])*(1-beta) + beta*wrk[r-1][1+s];
         wrk[r][2+s] = (wrk[r][0+s] + R*wrk[r][1+s]);
         wrk[r][3+s] = (wrk[r][2+s] - wrk[r-1][4+s])*MathPow((1-alpha),2) + MathPow(alpha,2)*wrk[r-1][3+s];
         wrk[r][4+s] = (wrk[r-1][4+s] + wrk[r][3+s]); 

   //
   //
   //
   //
   //

   return(wrk[r][4+s]);
}

