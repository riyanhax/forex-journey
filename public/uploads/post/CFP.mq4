//+------------------------------------------------------------------+
//|                                                          CFP.mq4 |
//|                                              SemSemFX@rambler.ru |
//|              http://onix-trade.net/forum/index.php?showtopic=107 |
//+------------------------------------------------------------------+
#property copyright "SemSemFX@rambler.ru"
#property link      "http://onix-trade.net/forum/index.php?showtopic=107"
//----
string Indicator_Name = "CFP";
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Violet
//----
extern int MA_Method = 3;
extern int Price = 6;
extern int Fast = 3;
extern int Slow = 5;
extern bool USD = 1;
extern bool EUR = 1;
extern bool GBP = 1;
extern bool CHF = 1;
extern bool JPY = 1;
extern bool AUD = 1;
extern bool CAD = 1;
extern bool NZD = 1;
extern int Bars.Count = 0;

//----
double OUT[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicatrs
   IndicatorShortName(Indicator_Name + " (" + Symbol() + ")");
   SetIndexStyle(0, DRAW_LINE, DRAW_LINE, 1, Violet);
   SetIndexBuffer(0, OUT);
   SetIndexLabel(0, Symbol()); 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   double arrUSD, arrEUR, arrGBP, arrCHF, arrJPY, arrAUD, arrCAD, arrNZD;
   int limit;
   if (IndicatorCounted()<0) return(-1);
  limit=Bars-IndicatorCounted();
  if (Bars.Count>0 && limit>Bars.Count) limit=Bars.Count;
//---- основной цикл
   for(int i = 0; i < limit; i++)
     {
       // Предварительный рассчет
       if(EUR)
         {
           double EURUSD_Fast = ma("EURUSD", Fast, MA_Method, Price, i);
           double EURUSD_Slow = ma("EURUSD", Slow, MA_Method, Price, i);
           if(!EURUSD_Fast || !EURUSD_Slow)
               break;
         }
       if(GBP)
         {
           double GBPUSD_Fast = ma("GBPUSD", Fast, MA_Method, Price, i);
           double GBPUSD_Slow = ma("GBPUSD", Slow, MA_Method, Price, i);
           if(!GBPUSD_Fast || !GBPUSD_Slow)
               break;
         }
       if(AUD)
         {
           double AUDUSD_Fast = ma("AUDUSD", Fast, MA_Method, Price, i);
           double AUDUSD_Slow = ma("AUDUSD", Slow, MA_Method, Price, i);
           if(!AUDUSD_Fast || !AUDUSD_Slow)
               break;
         }
       if(NZD)
         {
           double NZDUSD_Fast = ma("NZDUSD", Fast, MA_Method, Price, i);
           double NZDUSD_Slow=ma("NZDUSD", Slow, MA_Method, Price, i);
           if(!NZDUSD_Fast || !NZDUSD_Slow)
               break;
         }
       if(CAD)
         {
           double USDCAD_Fast = ma("USDCAD", Fast, MA_Method, Price, i);
           double USDCAD_Slow = ma("USDCAD", Slow, MA_Method, Price, i);
           if(!USDCAD_Fast || !USDCAD_Slow)
               break;
         }
       if(CHF)
         {
           double USDCHF_Fast = ma("USDCHF", Fast, MA_Method, Price, i);
           double USDCHF_Slow = ma("USDCHF", Slow, MA_Method, Price, i);
           if(!USDCHF_Fast || !USDCHF_Slow)
               break;
         }
       if(JPY)
         {
           double USDJPY_Fast = ma("USDJPY", Fast, MA_Method, Price, i);
           double USDJPY_Slow = ma("USDJPY", Slow, MA_Method, Price, i);
           if(!USDJPY_Fast || !USDJPY_Slow)
               break;
         }
       // рассчет валют
       if(USD)
         {
           arrUSD = 0;
           if(EUR) 
               arrUSD += EURUSD_Slow / EURUSD_Fast - 1;
           if(GBP) 
               arrUSD += GBPUSD_Slow / GBPUSD_Fast - 1;
           if(AUD) 
               arrUSD += AUDUSD_Slow / AUDUSD_Fast - 1;
           if(NZD) 
               arrUSD += NZDUSD_Slow / NZDUSD_Fast - 1;
           if(CHF) 
               arrUSD += USDCHF_Fast / USDCHF_Slow - 1;
           if(CAD) 
               arrUSD += USDCAD_Fast / USDCAD_Slow - 1;
           if(JPY) 
               arrUSD += USDJPY_Fast / USDJPY_Slow - 1;
         }// end if USD
       if(EUR)
         {
           arrEUR = 0;
           if(USD) 
               arrEUR += EURUSD_Fast / EURUSD_Slow - 1;
           if(GBP) 
               arrEUR += (EURUSD_Fast / GBPUSD_Fast) / 
                         (EURUSD_Slow / GBPUSD_Slow) - 1;
           if(AUD) 
               arrEUR += (EURUSD_Fast / AUDUSD_Fast) / 
                         (EURUSD_Slow / AUDUSD_Slow) - 1;
           if(NZD) 
               arrEUR += (EURUSD_Fast / NZDUSD_Fast) / 
                         (EURUSD_Slow / NZDUSD_Slow) - 1;
           if(CHF) 
               arrEUR += (EURUSD_Fast*USDCHF_Fast) / 
                         (EURUSD_Slow*USDCHF_Slow) - 1;
           if(CAD) 
               arrEUR += (EURUSD_Fast*USDCAD_Fast) / 
                         (EURUSD_Slow*USDCAD_Slow) - 1;
           if(JPY) 
               arrEUR += (EURUSD_Fast*USDJPY_Fast) / 
                         (EURUSD_Slow*USDJPY_Slow) - 1;
         }// end if EUR
         
       if(GBP)
         {
           arrGBP = 0;
           if(USD) 
               arrGBP += GBPUSD_Fast/GBPUSD_Slow-1;
           if(EUR) 
               arrGBP += (EURUSD_Slow / GBPUSD_Slow) / 
                         (EURUSD_Fast / GBPUSD_Fast) - 1;
           if(AUD) 
               arrGBP += (GBPUSD_Fast / AUDUSD_Fast) / 
                         (GBPUSD_Slow / AUDUSD_Slow) - 1;
           if(NZD) 
               arrGBP += (GBPUSD_Fast / NZDUSD_Fast) / 
                         (GBPUSD_Slow / NZDUSD_Slow) - 1;
           if(CHF) 
               arrGBP += (GBPUSD_Fast*USDCHF_Fast) / 
                         (GBPUSD_Slow*USDCHF_Slow) - 1;
           if(CAD) 
               arrGBP += (GBPUSD_Fast*USDCAD_Fast) / 
                         (GBPUSD_Slow*USDCAD_Slow) - 1;
           if(JPY) 
               arrGBP += (GBPUSD_Fast*USDJPY_Fast) / 
                         (GBPUSD_Slow*USDJPY_Slow) - 1;
         }// end if GBP
       if(AUD)
         {
           arrAUD = 0;
           if(USD) 
               arrAUD += AUDUSD_Fast / AUDUSD_Slow - 1;
           if(EUR) 
               arrAUD += (EURUSD_Slow / AUDUSD_Slow) / 
               (EURUSD_Fast / AUDUSD_Fast) - 1;
           if(GBP) 
               arrAUD += (GBPUSD_Slow / AUDUSD_Slow) / 
               (GBPUSD_Fast / AUDUSD_Fast) - 1;
           if(NZD) 
               arrAUD += (AUDUSD_Fast / NZDUSD_Fast) / 
               (AUDUSD_Slow / NZDUSD_Slow) - 1;
           if(CHF) 
               arrAUD += (AUDUSD_Fast*USDCHF_Fast) / 
               (AUDUSD_Slow*USDCHF_Slow) - 1;
           if(CAD) 
               arrAUD += (AUDUSD_Fast*USDCAD_Fast) / 
               (AUDUSD_Slow*USDCAD_Slow) - 1;
           if(JPY) 
               arrAUD += (AUDUSD_Fast*USDJPY_Fast) / 
               (AUDUSD_Slow*USDJPY_Slow) - 1;
         }// end if AUD
       if(NZD)
         {
           arrNZD = 0;
           if(USD) 
               arrNZD += NZDUSD_Fast / NZDUSD_Slow - 1;
           if(EUR) 
               arrNZD += (EURUSD_Slow / NZDUSD_Slow) / 
                         (EURUSD_Fast / NZDUSD_Fast) - 1;
           if(GBP) 
               arrNZD += (GBPUSD_Slow / NZDUSD_Slow) / 
                         (GBPUSD_Fast / NZDUSD_Fast) - 1;
           if(AUD) 
               arrNZD += (AUDUSD_Slow / NZDUSD_Slow) / 
                         (AUDUSD_Fast / NZDUSD_Fast) - 1;
           if(CHF) 
               arrNZD += (NZDUSD_Fast*USDCHF_Fast) / 
                         (NZDUSD_Slow*USDCHF_Slow) - 1;
           if(CAD) 
               arrNZD += (NZDUSD_Fast*USDCAD_Fast) / 
                         (NZDUSD_Slow*USDCAD_Slow) - 1;
           if(JPY) 
               arrNZD += (NZDUSD_Fast*USDJPY_Fast) / 
                         (NZDUSD_Slow*USDJPY_Slow) - 1;
         }// end if NZD
       if(CAD)
         {
           arrCAD = 0;
           if(USD) 
               arrCAD += USDCAD_Slow / USDCAD_Fast - 1;
           if(EUR) 
               arrCAD += (EURUSD_Slow*USDCAD_Slow) / 
                         (EURUSD_Fast*USDCAD_Fast) - 1;
           if(GBP) 
               arrCAD += (GBPUSD_Slow*USDCAD_Slow) / 
                         (GBPUSD_Fast*USDCAD_Fast) - 1;
           if(AUD) 
               arrCAD += (AUDUSD_Slow*USDCAD_Slow) / 
                         (AUDUSD_Fast*USDCAD_Fast) - 1;
           if(NZD) 
               arrCAD += (NZDUSD_Slow*USDCAD_Slow) / 
                         (NZDUSD_Fast*USDCAD_Fast) - 1;
           if(CHF) 
               arrCAD += (USDCHF_Fast / USDCAD_Fast) / 
                         (USDCHF_Slow/USDCAD_Slow) - 1;
           if(JPY) 
               arrCAD += (USDJPY_Fast / USDCAD_Fast) / 
                         (USDJPY_Slow/USDCAD_Slow) - 1;
         }// end if CAD
       if(CHF)
         {
           arrCHF = 0;
           if(USD) 
               arrCHF += USDCHF_Slow / USDCHF_Fast - 1;
           if(EUR) 
               arrCHF += (EURUSD_Slow*USDCHF_Slow) / 
                         (EURUSD_Fast*USDCHF_Fast) - 1;
           if(GBP) 
               arrCHF += (GBPUSD_Slow*USDCHF_Slow) / 
                         (GBPUSD_Fast*USDCHF_Fast) - 1;
           if(AUD) 
               arrCHF += (AUDUSD_Slow*USDCHF_Slow) / 
                         (AUDUSD_Fast*USDCHF_Fast) - 1;
           if(NZD) 
               arrCHF += (NZDUSD_Slow*USDCHF_Slow) / 
                         (NZDUSD_Fast*USDCHF_Fast) - 1;
           if(CAD) 
               arrCHF += (USDCHF_Slow/USDCAD_Slow) / 
                         (USDCHF_Fast/USDCAD_Fast) - 1;
           if(JPY) 
               arrCHF += (USDJPY_Fast/USDCHF_Fast) / 
                         (USDJPY_Slow/USDCHF_Slow) - 1;
         }// end if CHF
       if(JPY)
         {
           arrJPY = 0;
           if(USD) 
               arrJPY += USDJPY_Slow / USDJPY_Fast - 1;
           if(EUR) 
               arrJPY += (EURUSD_Slow*USDJPY_Slow) / 
                         (EURUSD_Fast*USDJPY_Fast) - 1;
           if(GBP) 
               arrJPY += (GBPUSD_Slow*USDJPY_Slow) / 
                         (GBPUSD_Fast*USDJPY_Fast) - 1;
           if(AUD) 
               arrJPY += (AUDUSD_Slow*USDJPY_Slow) / 
                         (AUDUSD_Fast*USDJPY_Fast) - 1;
           if(NZD) 
               arrJPY += (NZDUSD_Slow*USDJPY_Slow) / 
                         (NZDUSD_Fast*USDJPY_Fast) - 1;
           if(CAD) 
               arrJPY += (USDJPY_Slow / USDCAD_Slow) / 
                         (USDJPY_Fast / USDCAD_Fast) - 1;
           if(CHF) 
               arrJPY += (USDJPY_Slow / USDCHF_Slow) / 
                         (USDJPY_Fast / USDCHF_Fast) - 1;
         }// end if JPY
       OUT[i] = 0;
       if(0 == StringFind(Symbol(), "USD", 0))
           OUT[i] += arrUSD;
       if(3 == StringFind(Symbol(), "USD", 0))
           OUT[i] -= arrUSD;
       if(0 == StringFind(Symbol(), "EUR", 0))
           OUT[i] += arrEUR;
       if(0 == StringFind(Symbol(), "GBP", 0))
           OUT[i] += arrGBP;
       if(3 == StringFind(Symbol(), "GBP", 0))
           OUT[i] -= arrGBP;
       if(0 == StringFind(Symbol(), "CHF", 0))
           OUT[i] += arrCHF;
       if(3 == StringFind(Symbol(), "CHF", 0))
           OUT[i] -= arrCHF;
       if(3 == StringFind(Symbol(), "JPY", 0))
           OUT[i] -= arrJPY;
       if(0 == StringFind(Symbol(), "CAD", 0))
           OUT[i] += arrCAD;
       if(3 == StringFind(Symbol(), "CAD", 0))
           OUT[i] -= arrCAD;
       if(0 == StringFind(Symbol(), "AUD", 0))
           OUT[i] += arrAUD;
       if(3 == StringFind(Symbol(), "AUD", 0))
           OUT[i] -= arrAUD;
       if(0 == StringFind(Symbol(), "NZD", 0))
           OUT[i] += arrNZD;
       if(3 == StringFind(Symbol(), "NZD", 0))
           OUT[i] -= arrNZD;
     }//end block for(int i=0; i<limit; i++)
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|  Subroutine                                                      |
//+------------------------------------------------------------------+
double ma(string sym, int per, int Mode, int Price, int i)
  {
   double res = 0;
   int k = 1;
   int ma_shift = 0;
   int tf = 0;
   switch(Period())
     {
       case 1:     res += iMA(sym, tf, per*k, ma_shift, Mode, Price,i); 
                   k += 5;
       case 5:     res += iMA(sym, tf, per*k, ma_shift, Mode, Price,i); 
                   k += 3;
       case 15:    res += iMA(sym, tf, per*k, ma_shift, Mode, Price,i); 
                   k += 2;
       case 30:    res += iMA(sym, tf, per*k, ma_shift, Mode, Price,i); 
                   k += 2;
       case 60:    res += iMA(sym, tf, per*k, ma_shift, Mode, Price,i); 
                   k += 4;
       case 240:   res += iMA(sym, tf, per*k, ma_shift, Mode, Price,i); 
                   k += 6;
       case 1440:  res += iMA(sym, tf, per*k, ma_shift, Mode, Price,i); 
                   k += 4;
       case 10080: res += iMA(sym, tf, per*k, ma_shift, Mode, Price,i); 
                   k += 4;
       case 43200: res += iMA(sym, tf, per*k, ma_shift, Mode, Price,i); 
     }
   return(res);
  }   
//+------------------------------------------------------------------+


