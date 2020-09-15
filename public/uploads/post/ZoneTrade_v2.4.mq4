//+------------------------------------------------------------------+
//|                                               ZoneTrade_v2.4.mq4 |
//|                                                           Duke3D |
//|                                             duke3datomic@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Duke3D"
#property link      "duke3datomic@mail.ru"

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Gray
#property indicator_color4 Gray
#property indicator_color5 Green
#property indicator_color6 Red
#property indicator_color7 Gray
#property indicator_color8 Gray

#property indicator_width1 3
#property indicator_width2 3
#property indicator_width3 3
#property indicator_width4 3
#property indicator_width5 1
#property indicator_width6 1
#property indicator_width7 1
#property indicator_width8 1

extern color GreenZone        = Green;          // Цвет зелённой зоны
extern color RedZone          = Red;            // Цвет красной зоны
extern color GreyZone         = Gray;           // Цвет серой зоны
double AC_0;
double AC_1;
double AO_0;
double AO_1;
string name;
extern int BodyWidth          = 3;              // Ширина тела свечи
extern int ShadowWidth        = 1;              // Ширина тени свечи
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
double ExtMapBuffer8[];
//----

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM, 0, BodyWidth, GreenZone);
   SetIndexBuffer(0, ExtMapBuffer1);

   SetIndexStyle(1,DRAW_HISTOGRAM, 0, BodyWidth, RedZone);
   SetIndexBuffer(1, ExtMapBuffer2);
   
   SetIndexStyle(2,DRAW_HISTOGRAM, 0, BodyWidth, GreyZone);
   SetIndexBuffer(2, ExtMapBuffer3);

   SetIndexStyle(3,DRAW_HISTOGRAM, 0, BodyWidth, GreyZone);
   SetIndexBuffer(3, ExtMapBuffer4);

   SetIndexStyle(4,DRAW_HISTOGRAM, 0, ShadowWidth, GreenZone);
   SetIndexBuffer(4, ExtMapBuffer5);
   
   SetIndexStyle(5,DRAW_HISTOGRAM, 0, ShadowWidth, RedZone);
   SetIndexBuffer(5, ExtMapBuffer6);

   SetIndexStyle(6,DRAW_HISTOGRAM, 0, ShadowWidth, GreyZone);
   SetIndexBuffer(6, ExtMapBuffer7);
   
   SetIndexStyle(7,DRAW_HISTOGRAM, 0, ShadowWidth, GreyZone);
   SetIndexBuffer(7, ExtMapBuffer8);
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   int i, limit;
   double ZTOpen, ZTHigh, ZTLow, ZTClose;
 
   if(counted_bars > 0) counted_bars--;
   i = Bars - counted_bars - 1;
   
   while(i>=0)
      {
      ZTOpen  = Open[i];
      ZTHigh  = High[i];
      ZTLow   = Low[i];
      ZTClose = Close[i];
//===================================================================================================================      
      if(IndAC(i)==1 && IndAO(i)==1)            // Зелёная зона 
        {
        if(Open[i]>Close[i])                    // bear
          {
           ExtMapBuffer1[i] = ZTOpen;
           ExtMapBuffer2[i] = ZTClose;
          }
        if(Open[i]<Close[i])                    // bull
          {
           ExtMapBuffer1[i] = ZTClose;
           ExtMapBuffer2[i] = ZTOpen;
          }
        ExtMapBuffer5[i] = ZTHigh;
        ExtMapBuffer6[i] = ZTLow;
        } 
//===================================================================================================================  
      if(IndAC(i)==2 && IndAO(i)==2)            // Красная зона 
        {
        if(Open[i]>Close[i])                    // bear
          {
           ExtMapBuffer1[i] = ZTClose;
           ExtMapBuffer2[i] = ZTOpen;
          }
        if(Open[i]<Close[i])                    // bull
          {
           ExtMapBuffer1[i] = ZTOpen;
           ExtMapBuffer2[i] = ZTClose;
          }
        ExtMapBuffer5[i] = ZTLow;
        ExtMapBuffer6[i] = ZTHigh;
        } 
//===================================================================================================================
      if(IndAC(i)==1 && IndAO(i)==2)            // Серая зона
        {
        if(Open[i]>Close[i])                    // bear
          {
           ExtMapBuffer3[i] = ZTOpen;
           ExtMapBuffer4[i] = ZTClose;
          }
        if(Open[i]<Close[i])                    // bull
          {
           ExtMapBuffer3[i] = ZTClose;
           ExtMapBuffer4[i] = ZTOpen;
          }
        ExtMapBuffer7[i] = ZTHigh;
        ExtMapBuffer8[i] = ZTLow;
        }
//===================================================================================================================
      if(IndAC(i)==2 && IndAO(i)==1)            // Серая зона
        {
        if(Open[i]>Close[i])                    // bear
          {
           ExtMapBuffer3[i] = ZTClose;
           ExtMapBuffer4[i] = ZTOpen;
          }
        if(Open[i]<Close[i])                    // bull
          {
           ExtMapBuffer3[i] = ZTOpen;
           ExtMapBuffer4[i] = ZTClose;
          }
        ExtMapBuffer7[i] = ZTLow;
        ExtMapBuffer8[i] = ZTHigh;
        }
      i--;
      }
//===================================================================================================================     
  return(0);
  }
//===================================================================================================================     
int IndAC(int Shift)
   {
   int DirectionAC;
   AC_0 = iAC(Symbol(),0,Shift);
   AC_1 = iAC(Symbol(),0,Shift+1);
   if(AC_0>AC_1) {DirectionAC = 1;}               // Зелёный бар
   if(AC_0<AC_1) {DirectionAC = 2;}               // Красный бар
   return(DirectionAC);
   }
//===================================================================================================================     
int IndAO(int Shift)
   {
   int DirectionAO;
   AO_0 = iAO(Symbol(),0,Shift);
   AO_1 = iAO(Symbol(),0,Shift+1);
   if(AO_0>AO_1) {DirectionAO = 1;}               // Зелёный бар
   if(AO_0<AO_1) {DirectionAO = 2;}               // Красный бар
   return(DirectionAO);
   }
//===================================================================================================================     
   