//+------------------------------------------------------------------+
//|                                               VoltyChoppy_v1.mq4 |
//|                                  Copyright © 2006, Forex-TSD.com |
//|                         Written by IgorAD,igorad2003@yahoo.co.uk |   
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |                                      
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Forex-TSD.com "
#property link      "http://www.forex-tsd.com/"

#property indicator_separate_window
#property indicator_minimum -0.05
#property indicator_maximum 1.05
#property indicator_buffers 8

//---- input parameters
extern int     Length      = 10;
extern double  Kv          = 4.0;
//extern double  Kd          = 1.1;
extern int     NumBars     = 1000; 
//---- buffers
double UpBuffer1[];
double UpBuffer2[];
double UpBuffer3[];
double UpBuffer4[];

double DnBuffer1[];
double DnBuffer2[];
double DnBuffer3[];
double DnBuffer4[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   
//---- 
   SetIndexStyle(0,DRAW_HISTOGRAM,0,3,MediumBlue);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,3,DodgerBlue);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,3,LightBlue);
   SetIndexStyle(3,DRAW_HISTOGRAM,0,3,Aqua);
   
   SetIndexStyle(4,DRAW_HISTOGRAM,0,3,Crimson);
   SetIndexStyle(5,DRAW_HISTOGRAM,0,3,Tomato);
   SetIndexStyle(6,DRAW_HISTOGRAM,0,3,Orange);
   SetIndexStyle(7,DRAW_HISTOGRAM,0,3,Yellow);
   
   SetIndexBuffer(0,UpBuffer1);
   SetIndexBuffer(1,UpBuffer2);
   SetIndexBuffer(2,UpBuffer3);
   SetIndexBuffer(3,UpBuffer4);
   
   SetIndexBuffer(4,DnBuffer1);
   SetIndexBuffer(5,DnBuffer2);
   SetIndexBuffer(6,DnBuffer3);
   SetIndexBuffer(7,DnBuffer4);
   
//---- 
   string short_name="VoltyChoppy";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"Strong UpTrend");
   SetIndexLabel(1,"Retrace UpTrend");   
   SetIndexLabel(2,"Choppy UpTrend");
   SetIndexLabel(3,"Be ready to change UpTrend");
   
   SetIndexLabel(4,"Strong DownTrend");
   SetIndexLabel(5,"Retrace DownTrend");   
   SetIndexLabel(6,"Choppy DownTrend");
   SetIndexLabel(7,"Be ready to change DownTrend"); 
//----
   
   SetIndexDrawBegin(0,Length);
   SetIndexDrawBegin(1,Length);
   SetIndexDrawBegin(2,Length);
   SetIndexDrawBegin(3,Length);
   SetIndexDrawBegin(4,Length);
   SetIndexDrawBegin(5,Length);
   SetIndexDrawBegin(6,Length);
   SetIndexDrawBegin(7,Length);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| VoltyChoppy_v1                                                  |
//+------------------------------------------------------------------+
int start()
  {
   double smin,smax,smin1,smax1,
          rmin,rmax,rmin1,rmax1,
          cmin,cmax,cmin1,cmax1,
          bmin,bmax,bmin1,bmax1;
   int    i, strend, rtrend, ctrend, btrend;       
         
//----
   if(NumBars<=Length) return(0);
//---- initial zero
      for(i=Bars;i>=0;i--) 
      {
      UpBuffer1[i]=0.0;
      UpBuffer2[i]=0.0;
      UpBuffer3[i]=0.0;
      UpBuffer4[i]=0.0;
      
      DnBuffer1[i]=0.0;
      DnBuffer2[i]=0.0;
      DnBuffer3[i]=0.0;
      DnBuffer4[i]=0.0;
      }
//----
   double Kd = MathPow(Kv,1.0/3.0); 
      
   for(i=NumBars - Length -1;i>=0;i--) 
   {	 
   smin  = Close[i] - Kv*iATR(NULL,0,Length,i);
   smax  = Close[i] + Kv*iATR(NULL,0,Length,i);
   
   rmin  = Close[i] - Kv*iATR(NULL,0,Length,i)/Kd;
   rmax  = Close[i] + Kv*iATR(NULL,0,Length,i)/Kd;
   
   cmin  = Close[i] - Kv*iATR(NULL,0,Length,i)/(Kd*Kd);
   cmax  = Close[i] + Kv*iATR(NULL,0,Length,i)/(Kd*Kd);
   
   bmin  = Close[i] - Kv*iATR(NULL,0,Length,i)/(Kd*Kd*Kd);
   bmax  = Close[i] + Kv*iATR(NULL,0,Length,i)/(Kd*Kd*Kd);
   
   if ( Close[i] > smax1 ) strend = 1; 
   if ( Close[i] < smin1 ) strend =-1; 
   
   if ( strend > 0 && smin < smin1 ) smin = smin1;
   if ( strend < 0 && smax > smax1 ) smax = smax1;
     
   if ( Close[i] > rmax1 ) rtrend = 1; 
   if ( Close[i] < rmin1 ) rtrend =-1; 
   
   if ( rtrend > 0 && rmin < rmin1 ) rmin = rmin1;
   if ( rtrend < 0 && rmax > rmax1 ) rmax = rmax1;
   
   
   if ( Close[i] > cmax1 ) ctrend = 1; 
   if ( Close[i] < cmin1 ) ctrend =-1; 
   
   if ( ctrend > 0 && cmin < cmin1 ) cmin = cmin1;
   if ( ctrend < 0 && cmax > cmax1 ) cmax = cmax1;
   
   if ( Close[i] > bmax1 ) btrend = 1; 
   if ( Close[i] < bmin1 ) btrend =-1; 
   
   if ( btrend > 0 && bmin < bmin1 ) bmin = bmin1;
   if ( btrend < 0 && bmax > bmax1 ) bmax = bmax1;
      
   if ( strend  > 0 )
   {
    UpBuffer1[i] = 1.0;UpBuffer2[i] = 0.0;UpBuffer3[i] = 0.0;UpBuffer4[i] = 0.0;
    DnBuffer1[i] = 0.0;DnBuffer2[i] = 0.0;DnBuffer3[i] = 0.0;DnBuffer4[i] = 0.0;
   
   if ( btrend < 0 )
   {UpBuffer1[i] = 0.0;UpBuffer2[i] = 1.0;UpBuffer3[i] = 0.0;UpBuffer4[i] = 0.0;
    DnBuffer1[i] = 0.0;DnBuffer2[i] = 0.0;DnBuffer3[i] = 0.0;DnBuffer4[i] = 0.0;}
   
   if ( ctrend < 0 )
   {UpBuffer1[i] = 0.0;UpBuffer2[i] = 0.0;UpBuffer3[i] = 1.0;UpBuffer4[i] = 0.0;
    DnBuffer1[i] = 0.0;DnBuffer2[i] = 0.0;DnBuffer3[i] = 0.0;DnBuffer4[i] = 0.0;}
    
   if ( rtrend < 0 )
   {UpBuffer1[i] = 0.0;UpBuffer2[i] = 0.0;UpBuffer3[i] = 0.0;UpBuffer4[i] = 1.0;
    DnBuffer1[i] = 0.0;DnBuffer2[i] = 0.0;DnBuffer3[i] = 0.0;DnBuffer4[i] = 0.0;}
   }
    
   if ( strend < 0 ) 
   {
    UpBuffer1[i] = 0.0;UpBuffer2[i] = 0.0;UpBuffer3[i] = 0.0;UpBuffer4[i] = 0.0;
    DnBuffer1[i] = 1.0;DnBuffer2[i] = 0.0;DnBuffer3[i] = 0.0;DnBuffer4[i] = 0.0;
   
   if ( btrend > 0 )    
   {UpBuffer1[i] = 0.0;UpBuffer2[i] = 0.0;UpBuffer3[i] = 0.0;UpBuffer4[i] = 0.0;
    DnBuffer1[i] = 0.0;DnBuffer2[i] = 1.0;DnBuffer3[i] = 0.0;DnBuffer4[i] = 0.0;}
   
   if ( ctrend > 0 )  
   {UpBuffer1[i] = 0.0;UpBuffer2[i] = 0.0;UpBuffer3[i] = 0.0;UpBuffer4[i] = 0.0;
    DnBuffer1[i] = 0.0;DnBuffer2[i] = 0.0;DnBuffer3[i] = 1.0;DnBuffer4[i] = 0.0;}
      
   if ( rtrend > 0 )
   {UpBuffer1[i] = 0.0;UpBuffer2[i] = 0.0;UpBuffer3[i] = 0.0;UpBuffer4[i] = 0.0;
    DnBuffer1[i] = 0.0;DnBuffer2[i] = 0.0;DnBuffer3[i] = 0.0;DnBuffer4[i] = 1.0;}
   }
   
   smin1 = smin; smax1 = smax;
   rmin1 = rmin; rmax1 = rmax;
   cmin1 = cmin; cmax1 = cmax;
   bmin1 = bmin; bmax1 = bmax;
   
   
   }
   
   


//----
   return(0);
  }
//+------------------------------------------------------------------+