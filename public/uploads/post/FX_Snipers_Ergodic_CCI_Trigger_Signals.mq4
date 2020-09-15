//+----------------------------------------------------------------+
//|                  FX_Snipers_Ergodic_CCI_TriggerTSI Signals.mq4 |
//|                             modified by Linuxser for Forex-TSD |
//+----------------------------------------------------------------+
#property copyright ""
#property link      ""

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_width1 1
#property indicator_width2 1
#property indicator_color1 Yellow
#property indicator_color2 Magenta
//---- input parameters

extern int pq      =  2;
extern int pr      = 10;
extern int ps      =  5;
extern int trigger =  3;
//---- buffers
double bufferUp[];
double bufferDo[];
double bufferTr[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   IndicatorBuffers(3);
   SetIndexBuffer(0,bufferUp);SetIndexStyle(0,DRAW_ARROW); SetIndexArrow(0,108); SetIndexLabel(0,"UpArrow");
   SetIndexBuffer(1,bufferDo);SetIndexStyle(1,DRAW_ARROW); SetIndexArrow(1,108); SetIndexLabel(1,"DownArrow");
   SetIndexBuffer(2,bufferTr);
   return(0);
}
int deinit()
{
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int limit;
   int counted_bars=IndicatorCounted();

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
           limit=Bars-counted_bars;
   
   //
   //
   //
   //
   //
   
   for(int i=limit; i >= 0; i--) 
   {
      bufferUp[i] = EMPTY_VALUE;
      bufferDo[i] = EMPTY_VALUE;
      bufferTr[i] = bufferTr[i+1];
         double curErgodic  = iCustom(NULL,0,"FX_Snipers_Ergodic_CCI_Trigger",pq,pr,ps,trigger,1,i);
         double curSignal   = iCustom(NULL,0,"FX_Snipers_Ergodic_CCI_Trigger",pq,pr,ps,trigger,0,i);

         //
         //
         //
         //
         //
            
         if (curErgodic>curSignal) bufferTr[i] = -1;
         if (curErgodic<curSignal) bufferTr[i] =  1;
         if (bufferTr[i]!=bufferTr[i+1])
            if (bufferTr[i]==-1) bufferDo[i]=High[i]+iATR(NULL,0,20,i);
            else                 bufferUp[i]= Low[i]-iATR(NULL,0,20,i);
    }
   return(0);
}  

