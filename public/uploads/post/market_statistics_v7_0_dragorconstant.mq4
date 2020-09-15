//+------------------------------------------------------------------+
//|                        Market_Statistics_v7_0_DragOrConstant.mq4 |
//|                                     Copyright © 2009, Akif TOKUZ |
//|                                             akifusenet@gmail.com |
//| Drag It modification by Brooky-Indicators.com
//| Volume histogram implementation is based on Vadim Shumilov       |
//| (DrShumiloff)'s VolumesHist2.3 indicator. Other concepts are     |
//| inspired from Jperl's `Trading With Market Statistics` thread on |
//| Traders Laboratory.                                              |
//|                                                                  |
//| History:                                                         |
//| 17.01.2010: v5.0=>Sliding window for days back instead of fixed  |
//| starting date(calculate starting from x day back, starting date  |
//| is updated automatically in real-time)                           |
//| 17.01.2010: v4.2=>Small Bugfix [zero division possibility ]      |
//|                 =>When time period change call deinit and init   |
//| 09.09.2009: v4.1=>Small bugfix [delete startDate correct prefix] |
//| 09.09.2009: v4=>Instead of fixed start date now we have a        |
//|               =>relative startdate like 2 days back at 22:00     |
//| 02.09.2009: v3=>Calculation done only at the start of a new bar  |
//|               =>implementation is corrected                      |
//|               =>histogram defaulted 50 bar sd3show made true     |
//| 10.08.2009: v2=>End date added.SD2Show defaulted to true         |
//|               =>Show/disable options added for every line        |
//| 06.08.2009: v1=>Initial release                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Akif TOKUZ"
#property link      "akifusenet@gmail.com"

#property indicator_chart_window

#property indicator_buffers 8

#property indicator_color1 Orange      //PVP
#property indicator_width1 2

#property indicator_color2 Aqua        //VWAP
#property indicator_width2 2

#property indicator_color3 Yellow       //SD1Pos
#property indicator_width3 1
#property indicator_style3 2

#property indicator_color4 White         //SD1Neg
#property indicator_width4 1
#property indicator_style4 2

#property indicator_color5 Yellow//SD2Pos
#property indicator_width5 1
#property indicator_style5 2

#property indicator_color6 White     //SD2Neg
#property indicator_width6 1
#property indicator_style6 2

#property indicator_color7 Yellow   //SD2Pos
#property indicator_width7 1
#property indicator_style7 2

#property indicator_color8 White   //SD2Neg
#property indicator_width8 1
#property indicator_style8 2


//---- input parameters
extern int     InstanceOnChart = 1;
extern string  label="Market_Statistics_1";

extern bool    SetAtDaysBack = false;
extern double  daysBack=1;



extern bool    UseManualDrag=false;//true 
extern int     PastDisplayClearanceBars = 200;

extern bool    SetAtConstantBars = true;
extern int     ConstantBars = 240;

extern int     HistogramAmplitude = 120;
extern bool    Show_SD1 = true;
extern bool    Show_SD2 = true;
extern bool    Show_SD3 = true;
extern bool    Show_Histogram = true;//false
extern bool    Show_PVP = true;
extern bool    Show_VWAP = true;
extern color HistoColor = C'49,49,49';
//---- buffers
double PVP[];
double VWAP[];
double SD1Pos[];
double SD1Neg[];
double SD2Pos[];
double SD2Neg[];
double SD3Pos[];
double SD3Neg[];

double Hist[]; // drawn specifically

string   OBJECT_PREFIX;
double   OpenTime = 0;  // To check if we have a new bar
int      Bars_Back = 0; // Shows the starting bar for given date
int      items;         // numbers of items inside volume histogram
double   SD;            // standart deviation


// Finds the bar number for the given date
int FindStartIndex()
{
  if (Bars>=Bars_Back) return(Bars_Back);  
  return(0);
} 


int init()
{
   OBJECT_PREFIX = label+"_VolumeHistogram_"+InstanceOnChart + DoubleToStr(Time[FindStartIndex()],0)+"_" ;
   
//---- indicators
   IndicatorBuffers(8);
   
   if (Show_PVP==true) SetIndexStyle(0,DRAW_LINE);
   else  SetIndexStyle(0,DRAW_NONE);
   SetIndexLabel(0,"PVP");      
   SetIndexBuffer(0,PVP);
   SetIndexEmptyValue(0,0.0);
   
   if (Show_VWAP==true) SetIndexStyle(1,DRAW_LINE);
   else  SetIndexStyle(1,DRAW_NONE);
   SetIndexLabel(1,"VWAP");      
   SetIndexBuffer(1,VWAP);
   SetIndexEmptyValue(1,0.0);
   
   if (Show_SD1==true) SetIndexStyle(2,DRAW_LINE);
   else  SetIndexStyle(2,DRAW_NONE);
   SetIndexLabel(2,"SD1Pos");      
   SetIndexBuffer(2,SD1Pos);
   SetIndexEmptyValue(2,0.0);
   
   if (Show_SD1==true) SetIndexStyle(3,DRAW_LINE);
   else  SetIndexStyle(3,DRAW_NONE);
   SetIndexLabel(3,"SD1Neg");      
   SetIndexBuffer(3,SD1Neg);
   SetIndexEmptyValue(3,0.0);
   
   if (Show_SD2==true) SetIndexStyle(4,DRAW_LINE);
   else  SetIndexStyle(4,DRAW_NONE);
   SetIndexLabel(4,"SD2Pos");      
   SetIndexBuffer(4,SD2Pos);
   SetIndexEmptyValue(4,0.0);
   
   if (Show_SD2==true) SetIndexStyle(5,DRAW_LINE);
   else  SetIndexStyle(5,DRAW_NONE);
   SetIndexLabel(5,"SD2Neg");      
   SetIndexBuffer(5,SD2Neg);
   SetIndexEmptyValue(5,0.0);
   
   if (Show_SD3==true) SetIndexStyle(6,DRAW_LINE);
   else  SetIndexStyle(6,DRAW_NONE);
   SetIndexLabel(6,"SD3Pos");      
   SetIndexBuffer(6,SD3Pos);
   SetIndexEmptyValue(6,0.0);
   
   if (Show_SD3==true) SetIndexStyle(7,DRAW_LINE);
   else  SetIndexStyle(7,DRAW_NONE);
   SetIndexLabel(7,"SD3Neg");      
   SetIndexBuffer(7,SD3Neg);
   SetIndexEmptyValue(7,0.0);
   
   string short_name="Market_Statistics";
   IndicatorShortName(short_name);
   
   
      if(ObjectFind(label+"Starting_Time"+InstanceOnChart)==0 && UseManualDrag)
      { 

       Bars_Back= iBarShift(NULL,0,ObjectGet(label+"Starting_Time"+InstanceOnChart, OBJPROP_TIME1));
       //WindowRedraw();
       
      }  
 
      if(SetAtDaysBack)
      {
      Bars_Back=1440*daysBack/Period();
      }


      if(SetAtConstantBars)
      {
      Bars_Back=ConstantBars;
      }
      
         
   return(0);
}


// Delete all objects with given prefix
void ObDeleteObjectsByPrefix(string Prefix)
{
   int L = StringLen(Prefix);
   int i = 0; 
   while(i < ObjectsTotal())
   {
       string ObjName = ObjectName(i);
       if(StringSubstr(ObjName, 0, L) != Prefix) 
       { 
           i++; 
           continue;
       }
       ObjectDelete(ObjName);
   }
}
  



//---------------------------------------------------------+
  
int start()
{

   double TotalVolume=0;
   double TotalPV=0;
   int n;
    
   int limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
   
   
   limit=iBarShift(NULL,0,ObjectGet(label+"Starting_Time"+InstanceOnChart, OBJPROP_TIME1));
   
   
   //for(int e=limit; e<Bars-limit; e++)
   
   for(int e=limit; e<limit+PastDisplayClearanceBars; e++)
  // for(int e=limit; e>=iBarShift(NULL,0,ObjectGet(label+"Starting_Time", OBJPROP_TIME1)); e--)
   {
         PVP[e]=EMPTY_VALUE;
         VWAP[e]=EMPTY_VALUE;
         SD1Pos[e]=EMPTY_VALUE;
         SD1Neg[e]=EMPTY_VALUE;
         SD2Pos[e]=EMPTY_VALUE;
         SD2Neg[e]=EMPTY_VALUE;
         SD3Pos[e]=EMPTY_VALUE;
         SD3Neg[e]=EMPTY_VALUE;
         
   }
   
   
   OpenTime = Time[0];
   
      if(ObjectFind(label+"Starting_Time"+InstanceOnChart)==0 && SetAtConstantBars)
      { 
       Bars_Back= iBarShift(NULL,0,Time[ConstantBars]);
       ObjectMove(label+"Starting_Time"+InstanceOnChart, 0, Time[Bars_Back], Close[Bars_Back]);

       
      }
   
      if(ObjectFind(label+"Starting_Time"+InstanceOnChart)!=0 && UseManualDrag)
      { 
       Bars_Back=240;
      } 
   
      if(ObjectFind(label+"Starting_Time"+InstanceOnChart)==0 && UseManualDrag)
      { 
       Bars_Back= iBarShift(NULL,0,ObjectGet(label+"Starting_Time"+InstanceOnChart, OBJPROP_TIME1));
      }
      
      
      if(ObjectFind(label+"Starting_Time"+InstanceOnChart)==0 && SetAtDaysBack)//!UseManualDrag
      {
      Bars_Back=FindStartIndex();
      }
      

         if(ObjectFind(label+"Starting_Time"+InstanceOnChart)!=0)
         {
          //Bars_Back=FindStartIndex();
            if (Bars_Back!=0)
            { 
          
               ObjectCreate(label+"Starting_Time"+InstanceOnChart, OBJ_VLINE, 0, Time[Bars_Back], 0);
               ObjectSet(label+"Starting_Time"+InstanceOnChart, OBJPROP_TIME1, Time[Bars_Back]);
               ObjectSet(label+"Starting_Time"+InstanceOnChart, OBJPROP_COLOR, Red); 
               ObjectSet(label+"Starting_Time"+InstanceOnChart, OBJPROP_WIDTH, 2);     
      
            }
         }      
      
      
   if (OpenTime == Time[0])
   {
     
   



      
       /*  
      
      
      
      //---------------------
     // if(ObjectFind(label+"Starting_Time")!=0)
      
      //---------------------
      }*/
      
      if (Bars_Back+1<=Bars)
      {
         PVP[Bars_Back+1]=EMPTY_VALUE;
         VWAP[Bars_Back+1]=EMPTY_VALUE;
         SD1Pos[Bars_Back+1]=EMPTY_VALUE;
         SD1Neg[Bars_Back+1]=EMPTY_VALUE;
         SD2Pos[Bars_Back+1]=EMPTY_VALUE;
         SD2Neg[Bars_Back+1]=EMPTY_VALUE;
         SD3Pos[Bars_Back+1]=EMPTY_VALUE;
         SD3Neg[Bars_Back+1]=EMPTY_VALUE;      
      }
      
      OpenTime = Time[0];
      //Comment(Bars_Back);
                           
      double max = High[iHighest( NULL , 0, MODE_HIGH, Bars_Back, 0)];
      double min =  Low[ iLowest( NULL , 0, MODE_LOW,  Bars_Back, 0)];
      items = MathRound((max - min) / Point);

      ArrayResize(Hist, items);
      ArrayInitialize(Hist, 0);

      TotalVolume=0;
      TotalPV=0;
      for (int i = Bars_Back; i >= 1; i--)
      {         

         double t1 = Low[i], t2 = Open[i], t3 = Close[i], t4 = High[i];
         if (t2 > t3) {t3 = Open[i]; t2 = Close[i];}
         double totalRange = 2*(t4 - t1) - t3 + t2;         

         if (totalRange != 0.0)
         {
            for (double Price_i = t1; Price_i <= t4; Price_i += Point)
            {
               n = MathRound((Price_i - min) / Point);

               if (t1 <= Price_i && Price_i <  t2)
               {
                  Hist[n] += MathRound(Volume[i]*2*(t2-t1)/totalRange);
               }
               if (t2 <= Price_i && Price_i <= t3)
               {
                  Hist[n] += MathRound(Volume[i]*(t3-t2)/totalRange);
               }
               if (t3 <  Price_i && Price_i <= t4)
               {
                  Hist[n] += MathRound(Volume[i]*2*(t4-t3)/totalRange);
               }
            }//for
         }else
         {
            // Check if all values are equal to each other
            n = MathRound((t3 - min) / Point);
            Hist[n] += Volume[i];                     
         }//if


         // use H+L+C/3 as average price
         TotalPV+=Volume[i]*((Low[i]+High[i]+Close[i])/3);
         TotalVolume+=Volume[i];                          
      
         if (i==Bars_Back) PVP[i]=Close[i];        
         else PVP[i]=min+ArrayMaximum(Hist)*Point;

         if (i==Bars_Back) VWAP[i]=Close[i];        
         else{ 
            if (TotalVolume!=0) VWAP[i]=TotalPV/TotalVolume;
         }
 

         SD=0;         
         for (int k = Bars_Back; k >= i; k--)
         {
            double avg=(High[k]+Close[k]+Low[k])/3;
            double diff=avg-VWAP[i];
            if (TotalVolume!=0) SD+=(Volume[k]/TotalVolume)*(diff*diff); 
          }
          SD=MathSqrt(SD);
          SD1Pos[i]=VWAP[i]+SD;
          SD1Neg[i]=VWAP[i]-SD;
          SD2Pos[i]=SD1Pos[i]+SD;
          SD2Neg[i]=SD1Neg[i]-SD;
          SD3Pos[i]=SD2Pos[i]+SD;
          SD3Neg[i]=SD2Neg[i]-SD;
          
      }//for BARS BACK
      
      ObDeleteObjectsByPrefix(OBJECT_PREFIX);
            if(ObjectFind(label+"Starting_Time"+InstanceOnChart)==0 && UseManualDrag)
      { 

       Bars_Back= iBarShift(NULL,0,ObjectGet(label+"Starting_Time"+InstanceOnChart, OBJPROP_TIME1),false);
       
       
      }
      
      if (Show_Histogram)
      {
      OBJECT_PREFIX = label+"_VolumeHistogram_"+InstanceOnChart + DoubleToStr(Time[Bars_Back],0)+"_" ;
      int MaxVolume = Hist[ArrayMaximum(Hist)];      
      int multiplier;        
      for (i = 0; i <= items; i++)
      {

      
         // Protection if we have less bar than amplitude yet      
         if (Bars_Back<HistogramAmplitude) multiplier=Bars_Back;
         else multiplier=HistogramAmplitude;                  
         
         if (MaxVolume != 0) Hist[i] = MathRound(multiplier * Hist[i] / MaxVolume );
         
         if (Hist[i] > 0)
         {
            int time_i = Bars_Back-Hist[i];
            if (time_i>=0)
            {
               ObjectCreate(OBJECT_PREFIX+i, OBJ_RECTANGLE, 0, Time[Bars_Back], min + i*Point, Time[time_i], min + (i+1)*Point);
               ObjectSet(OBJECT_PREFIX+i, OBJPROP_STYLE, DRAW_HISTOGRAM);
               ObjectSet(OBJECT_PREFIX+i, OBJPROP_COLOR, HistoColor);
               ObjectSet(OBJECT_PREFIX+i, OBJPROP_BACK, true);               
            }//if
         } //if        
      }//for
      
      }//if show histogram
   }//MAIN IF BAR START

   
   return(0);
}

int deinit()
{
   ObDeleteObjectsByPrefix(OBJECT_PREFIX);
   ObjectDelete(label+"Starting_Time"+InstanceOnChart);
   Comment("");
   return(0);
}