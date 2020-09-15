//+------------------------------------------------------------------+
//|                                                       ZigZag.mq4 |
//|                   Copyright 2006-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "2006-2014, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property strict

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1  Red
//---- indicator parameters
input int InpDepth=12;     // Depth
input int InpDeviation=5;  // Deviation
input int InpBackstep=3;   // Backstep
extern bool SoundAlert=true;
extern bool PopupAlert=true;
//---- indicator buffers
double ExtZigzagBuffer[];
double ExtHighBuffer[];
double ExtLowBuffer[];
//--- globals
int    ExtLevel=3; // recounting's depth of extremums
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int k=0,k2=0,k3=0,k4=0;
int ii=0,i2=0,i3=0,i4=0;
int lastvali=0,lastval2i=0,lastval3i=0,lastval4i=0;
double preval=0;
double lastval=0,lastval2=0,lastval3=0,lastval4=0;
datetime newbar;

int OnInit()
  {
   if(InpBackstep>=InpDepth)
     {
      Print("Backstep cannot be greater or equal to Depth");
      return(INIT_FAILED);
     }
//--- 2 additional buffers
   IndicatorBuffers(3);
//---- drawing settings
   SetIndexStyle(0,DRAW_SECTION);
//---- indicator buffers
   SetIndexBuffer(0,ExtZigzagBuffer);
   SetIndexBuffer(1,ExtHighBuffer);
   SetIndexBuffer(2,ExtLowBuffer);
   SetIndexEmptyValue(0,0.0);
//---- indicator short name
   IndicatorShortName("ZigZag("+string(InpDepth)+","+string(InpDeviation)+","+string(InpBackstep)+")");
//---- initialization done
   return(INIT_SUCCEEDED);
  }
  
  void OnDeinit(const int reason){
      /*for(i2=0; i2<2; i2+=2){
         ObjectDelete("h1"+IntegerToString(i2));
      }*/
      for(i2=0; i2<2; i2+=2){
         ObjectDelete("h2"+IntegerToString(i2));
      }
      for(i2=0; i2<2; i2+=2){
         ObjectDelete("h3"+IntegerToString(i2));
      }
      return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
  {
   int    i,limit,counterZ,whatlookfor=0;
   int    back,pos,lasthighpos=0,lastlowpos=0;
   double extremum;
   double curlow=0.0,curhigh=0.0,lasthigh=0.0,lastlow=0.0;
//--- check for history and inputs
   if(rates_total<InpDepth || InpBackstep>=InpDepth)
      return(0);
//--- first calculations
   if(prev_calculated==0)
      limit=InitializeAll();
   else 
     {
      //--- find first extremum in the depth ExtLevel or 100 last bars
      i=counterZ=0;
      while(counterZ<ExtLevel && i<100)
        {
         if(ExtZigzagBuffer[i]!=0.0)
            counterZ++;
         i++;
        }
      //--- no extremum found - recounting all from begin
      if(counterZ==0)
         limit=InitializeAll();
      else
        {
         //--- set start position to found extremum position
         limit=i-1;
         //--- what kind of extremum?
         if(ExtLowBuffer[i]!=0.0) 
           {
            //--- low extremum
            curlow=ExtLowBuffer[i];
            //--- will look for the next high extremum
            whatlookfor=1;
           }
         else
           {
            //--- high extremum
            curhigh=ExtHighBuffer[i];
            //--- will look for the next low extremum
            whatlookfor=-1;
           }
         //--- clear the rest data
         for(i=limit-1; i>=0; i--)  
           {
            ExtZigzagBuffer[i]=0.0;  
            ExtLowBuffer[i]=0.0;
            ExtHighBuffer[i]=0.0;
           }
        }
     }
//--- main loop      
   for(i=limit; i>=0; i--)
     {
      //--- find lowest low in depth of bars
      extremum=low[iLowest(NULL,0,MODE_LOW,InpDepth,i)];
      //--- this lowest has been found previously
      if(extremum==lastlow)
         extremum=0.0;
      else 
        { 
         //--- new last low
         lastlow=extremum; 
         //--- discard extremum if current low is too high
         if(low[i]-extremum>InpDeviation*Point)
            extremum=0.0;
         else
           {
            //--- clear previous extremums in backstep bars
            for(back=1; back<=InpBackstep; back++)
              {
               pos=i+back;
               if(ExtLowBuffer[pos]!=0 && ExtLowBuffer[pos]>extremum)
                  ExtLowBuffer[pos]=0.0; 
              }
           }
        } 
      //--- found extremum is current low
      if(low[i]==extremum)
         ExtLowBuffer[i]=extremum;
      else
         ExtLowBuffer[i]=0.0;
      //--- find highest high in depth of bars
      extremum=high[iHighest(NULL,0,MODE_HIGH,InpDepth,i)];
      //--- this highest has been found previously
      if(extremum==lasthigh)
         extremum=0.0;
      else 
        {
         //--- new last high
         lasthigh=extremum;
         //--- discard extremum if current high is too low
         if(extremum-high[i]>InpDeviation*Point)
            extremum=0.0;
         else
           {
            //--- clear previous extremums in backstep bars
            for(back=1; back<=InpBackstep; back++)
              {
               pos=i+back;
               if(ExtHighBuffer[pos]!=0 && ExtHighBuffer[pos]<extremum)
                  ExtHighBuffer[pos]=0.0; 
              } 
           }
        }
      //--- found extremum is current high
      if(high[i]==extremum)
         ExtHighBuffer[i]=extremum;
      else
         ExtHighBuffer[i]=0.0;
     }
//--- final cutting 
   if(whatlookfor==0)
     {
      lastlow=0.0;
      lasthigh=0.0;  
     }
   else
     {
      lastlow=curlow;
      lasthigh=curhigh;
     }
   for(i=limit; i>=0; i--)
     {
      switch(whatlookfor)
        {
         case 0: // look for peak or lawn 
            if(lastlow==0.0 && lasthigh==0.0)
              {
               if(ExtHighBuffer[i]!=0.0)
                 {
                  lasthigh=High[i];
                  lasthighpos=i;
                  whatlookfor=-1;
                  ExtZigzagBuffer[i]=lasthigh;
                 }
               if(ExtLowBuffer[i]!=0.0)
                 {
                  lastlow=Low[i];
                  lastlowpos=i;
                  whatlookfor=1;
                  ExtZigzagBuffer[i]=lastlow;
                 }
              }
             break;  
         case 1: // look for peak
            if(ExtLowBuffer[i]!=0.0 && ExtLowBuffer[i]<lastlow && ExtHighBuffer[i]==0.0)
              {
               ExtZigzagBuffer[lastlowpos]=0.0;
               lastlowpos=i;
               lastlow=ExtLowBuffer[i];
               ExtZigzagBuffer[i]=lastlow;
              }
            if(ExtHighBuffer[i]!=0.0 && ExtLowBuffer[i]==0.0)
              {
               lasthigh=ExtHighBuffer[i];
               lasthighpos=i;
               ExtZigzagBuffer[i]=lasthigh;
               whatlookfor=-1;
              }   
            break;               
         case -1: // look for lawn
            if(ExtHighBuffer[i]!=0.0 && ExtHighBuffer[i]>lasthigh && ExtLowBuffer[i]==0.0)
              {
               ExtZigzagBuffer[lasthighpos]=0.0;
               lasthighpos=i;
               lasthigh=ExtHighBuffer[i];
               ExtZigzagBuffer[i]=lasthigh;
              }
            if(ExtLowBuffer[i]!=0.0 && ExtHighBuffer[i]==0.0)
              {
               lastlow=ExtLowBuffer[i];
               lastlowpos=i;
               ExtZigzagBuffer[i]=lastlow;
               whatlookfor=1;
              }   
            break;               
        }
     }
     
     lastval=0;
     lastvali=0;
     for(k=0;k<=1000;k++){
      if(lastval!=0)break;
      if(iCustom(NULL,0,"ZigZag",InpDepth,InpDeviation,InpBackstep,0,k)!=EMPTY_VALUE){
         lastval=iCustom(NULL,0,"ZigZag",InpDepth,InpDeviation,InpBackstep,0,k);
         lastvali=k;
      }
     }
     
     lastval2=0;
     lastval2i=0;
     for(k2=lastvali+1;k2<=lastvali+1000;k2++){
      if(lastval2!=0)break;
      if(iCustom(NULL,0,"ZigZag",InpDepth,InpDeviation,InpBackstep,0,k2)!=EMPTY_VALUE){
         lastval2=iCustom(NULL,0,"ZigZag",InpDepth,InpDeviation,InpBackstep,0,k2);
         lastval2i=k2;
      }
     }
     
     lastval3=0;
     lastval3i=0;
     for(k3=lastval2i+1;k3<=lastval2i+1000;k3++){
      if(lastval3!=0)break;
      if(iCustom(NULL,0,"ZigZag",InpDepth,InpDeviation,InpBackstep,0,k3)!=EMPTY_VALUE){
         lastval3=iCustom(NULL,0,"ZigZag",InpDepth,InpDeviation,InpBackstep,0,k3);
         lastval3i=k3;
      }
     }
     
     lastval4=0;
     lastval4i=0;
     for(k4=lastval3i+1;k4<=lastval3i+1000;k4++){
      if(lastval4!=0)break;
      if(iCustom(NULL,0,"ZigZag",InpDepth,InpDeviation,InpBackstep,0,k4)!=EMPTY_VALUE){
         lastval4=iCustom(NULL,0,"ZigZag",InpDepth,InpDeviation,InpBackstep,0,k4);
         lastval4i=k4;
      }
     }
     
     //if(preval==0)preval=lastval;
     
     /*for(i2=0;i2<2;i2+=2){
      ObjectDelete("h1"+IntegerToString(i2));
      ObjectCreate("h1"+IntegerToString(i2),OBJ_HLINE,0,0,lastval2);
      ObjectSet("h1"+IntegerToString(i2),OBJPROP_COLOR,Magenta);
      ObjectSet("h1"+IntegerToString(i2),OBJPROP_WIDTH,1);
      ObjectSet("h1"+IntegerToString(i2),OBJPROP_STYLE,1);
      ObjectSet("h1"+IntegerToString(i2),OBJPROP_RAY,False);
      }*/
      
      for(i3=0;i3<2;i3+=2){
      ObjectDelete("h2"+IntegerToString(i3));
      ObjectCreate("h2"+IntegerToString(i3),OBJ_HLINE,0,0,lastval2);
      ObjectSet("h2"+IntegerToString(i3),OBJPROP_COLOR,Magenta);
      ObjectSet("h2"+IntegerToString(i3),OBJPROP_WIDTH,2);
      ObjectSet("h2"+IntegerToString(i3),OBJPROP_STYLE,0);
      ObjectSet("h2"+IntegerToString(i3),OBJPROP_RAY,False);
      }
      
      for(i4=0;i4<2;i4+=2){
      ObjectDelete("h3"+IntegerToString(i4));
      ObjectCreate("h3"+IntegerToString(i4),OBJ_HLINE,0,0,lastval3);
      ObjectSet("h3"+IntegerToString(i4),OBJPROP_COLOR,Magenta);
      ObjectSet("h3"+IntegerToString(i4),OBJPROP_WIDTH,2);
      ObjectSet("h3"+IntegerToString(i4),OBJPROP_STYLE,0);
      ObjectSet("h3"+IntegerToString(i4),OBJPROP_RAY,False);
      }
      
      //if(iTime(NULL,0,0)!=newbar){
         /*if(lastval!=preval){
            if(PopupAlert==true)Alert(Symbol()+" New ZigZag value");
            if(SoundAlert==true)PlaySound("Alert.wav");
         }
         
         preval=lastval;*/
         
      //}
      
      if(iTime(NULL,0,0)!=newbar){
         if(
         (Open[1]<=lastval2 && Close[1]>lastval2) || (Open[1]>=lastval2 && Close[1]<lastval2)
         || (Open[1]<=lastval3 && Close[1]>lastval3) || (Open[1]>=lastval3 && Close[1]<lastval3)
         //|| (Open[1]<=lastval4 && Close[1]>lastval4) || (Open[1]>=lastval4 && Close[1]<lastval4)
         ){
         
            if(PopupAlert==true)Alert(Symbol()+" Cross");
            if(SoundAlert==true)PlaySound("Alert.wav");
            
         }
         newbar=iTime(NULL,0,0);
      }
     
//--- done
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int InitializeAll()
  {
   ArrayInitialize(ExtZigzagBuffer,0.0);
   ArrayInitialize(ExtHighBuffer,0.0);
   ArrayInitialize(ExtLowBuffer,0.0);
//--- first counting position
   return(Bars-InpDepth);
  }
//+------------------------------------------------------------------+