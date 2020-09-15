//+------------------------------------------------------------------+
//|                                                         CCFp.mq4 |
//|                                              SemSemFX@rambler.ru |
//|              http://onix-trade.net/forum/index.php?showtopic=107 |
//+------------------------------------------------------------------+
#property copyright "SemSemFX@rambler.ru"
#property link      "http://onix-trade.net/forum/index.php?showtopic=107"

/*
   #property modify "Vinin"
   #property link   "vinin@mail.ru"
*/

#property indicator_separate_window
#property indicator_buffers 8
#property indicator_level1 0
#property indicator_color1 Green
#property indicator_color2 DarkBlue
#property indicator_color3 Red
#property indicator_color4 Chocolate
#property indicator_color5 Maroon
#property indicator_color6 DarkOrange
#property indicator_color7 Purple
#property indicator_color8 Teal


extern int MA_Method = 1;
extern int Price = 0;
extern int Fast = 3;
extern int Slow = 5;


double arrUSD[];
double arrEUR[];
double arrGBP[];
double arrCHF[];
double arrJPY[];
double arrAUD[];
double arrCAD[];
double arrNZD[];

string SymbolName[]={"EURUSD","GBPUSD","AUDUSD","NZDUSD","USDCAD","USDCHF","USDJPY"};
       
int    counted_bars;   

double EURUSD;
double GBPUSD;
double AUDUSD;
double NZDUSD;
double CADUSD;
double CHFUSD;
double JPYUSD;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   counted_bars=0;

   InitBuffer(0, arrUSD, "USD"); 
   InitBuffer(1, arrEUR, "EUR"); 
   InitBuffer(2, arrGBP, "GBP"); 
   InitBuffer(3, arrCHF, "CHF"); 
   InitBuffer(4, arrJPY, "JPY"); 
   InitBuffer(5, arrAUD, "AUD"); 
   InitBuffer(6, arrCAD, "CAD"); 
   InitBuffer(7, arrNZD, "NZD"); 

//----
   return(0);
  }
void InitBuffer(int Id, double Array[], string Name){
   int width = 1;
   if(StringFind(Symbol(), Name, 0)>=0) width = 2;
   SetIndexStyle(Id, DRAW_LINE, DRAW_LINE, width);
   SetIndexBuffer(Id, Array);
   SetIndexLabel(Id, Name); 
}
  
 
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   int k=1;
   switch(Period()) {
      case     1: k += 5;
      case     5: k += 3;
      case    15: k += 2;
      case    30: k += 2;
      case    60: k += 4;
      case   240: k += 6;
      case  1440: k += 4;
      case 10080: k += 4;
   } 

   int MinBars=CheckBars(k*MathMax(Slow,Fast));
   if (MinBars<=0) {counted_bars=0;return(0);}
   int limit=MinBars-counted_bars;
   if (counted_bars==0) {
      limit=MinBars-k*MathMax(Slow,Fast)-1;
   }

   for(int i = limit; i >=0; i--) {
      // Предварительный рассчет
      double EURUSD=ma("EURUSD", Slow, MA_Method, Price, i)/ma("EURUSD", Fast, MA_Method, Price, i);
      double GBPUSD=ma("GBPUSD", Slow, MA_Method, Price, i)/ma("GBPUSD", Fast, MA_Method, Price, i);
      double AUDUSD=ma("AUDUSD", Slow, MA_Method, Price, i)/ma("AUDUSD", Fast, MA_Method, Price, i);
      double NZDUSD=ma("NZDUSD", Slow, MA_Method, Price, i)/ma("NZDUSD", Fast, MA_Method, Price, i);
      
      double CADUSD=ma("USDCAD", Fast, MA_Method, Price, i)/ma("USDCAD", Slow, MA_Method, Price, i);
      double CHFUSD=ma("USDCHF", Fast, MA_Method, Price, i)/ma("USDCHF", Slow, MA_Method, Price, i);
      double JPYUSD=ma("USDJPY", Fast, MA_Method, Price, i)/ma("USDJPY", Slow, MA_Method, Price, i);
       
      double sum = EURUSD + GBPUSD + AUDUSD + NZDUSD + CHFUSD + CADUSD + JPYUSD;

      // рассчет валют
      arrUSD[i] = sum-7.0;
      arrEUR[i] = (sum-EURUSD+1.0)/EURUSD-7.0;
      arrGBP[i] = (sum-GBPUSD+1.0)/GBPUSD-7.0;
      arrAUD[i] = (sum-AUDUSD+1.0)/AUDUSD-7.0;
      arrNZD[i] = (sum-NZDUSD+1.0)/NZDUSD-7.0;
      arrCAD[i] = (sum-CADUSD+1.0)/CADUSD-7.0;
      arrCHF[i] = (sum-CHFUSD+1.0)/CHFUSD-7.0;
      arrJPY[i] = (sum-JPYUSD+1.0)/JPYUSD-7.0;
         
   }//end block for(int i=0; i<limit; i++)
   //----
   counted_bars=MinBars;
   return(0);
}
//+------------------------------------------------------------------+

int CheckBars(int Max){
   static bool check=true;
   static bool Error=false;
   if (Error) return(0);
   int Res=99999999999;
   int err=GetLastError();
   for (int i=0;i<7;i++){
      Res=MathMin(Res, iBars(SymbolName[i],0));
      if (Res<Max) { 
         Alert("Недостаточно истории "+SymbolName[i], " Period "+PeriodToStr()); 
         Error=true;
         check=false;
         return(0);}
      err=GetLastError();
      if (err==4066) {
         Alert("Идет загрузка истории "+SymbolName[i]," Period "+PeriodToStr()); 
         check=false;
         return(0);}
      if (err==4106) {
         Alert("Неизвестный символ "+SymbolName[i]," Period "+PeriodToStr()); 
         Error=true;
         check=false;
         return(0);}
   }
   if (!check){
      Alert("История закачана, можно продолжать работу"," Period "+PeriodToStr()); 
      check=true;
   }
   return(Res);
}

//+------------------------------------------------------------------+
//|  Subroutines                                                     |
//+------------------------------------------------------------------+
double ma(string sym, int per, int Mode, int Price, int i)
  {
   double res = 0;
   int k = 1;
   int tf = 0;
   int pos=iBarShift(NULL,0,Time[i]);
   switch(Period())
     {
       case     1: res += iMA(sym, tf, per*k, 0, Mode, Price, pos); k += 5;
       case     5: res += iMA(sym, tf, per*k, 0, Mode, Price, pos); k += 3;
       case    15: res += iMA(sym, tf, per*k, 0, Mode, Price, pos); k += 2;
       case    30: res += iMA(sym, tf, per*k, 0, Mode, Price, pos); k += 2;
       case    60: res += iMA(sym, tf, per*k, 0, Mode, Price, pos); k += 4;
       case   240: res += iMA(sym, tf, per*k, 0, Mode, Price, pos); k += 6;
       case  1440: res += iMA(sym, tf, per*k, 0, Mode, Price, pos); k += 4;
       case 10080: res += iMA(sym, tf, per*k, 0, Mode, Price, pos); k += 4;
       case 43200: res += iMA(sym, tf, per*k, 0, Mode, Price, pos); 
     } 
   return(res);
  }   


string PeriodToStr(){
   switch (Period()) {
      case     1: return("M1");
      case     5: return("M5");
      case    15: return("M15");
      case    30: return("M30");
      case    60: return("H1");
      case   240: return("H4");
      case  1440: return("D1");
      case 10080: return("W1");
      case 43200: return("MN1");
   }
   return("");
}