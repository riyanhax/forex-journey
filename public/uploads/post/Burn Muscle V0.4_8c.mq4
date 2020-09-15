//+------------------------------------------------------------------+
//|                                         BURN Muscle v0.4.mq4     |
//|                                         Copyright © 2011, BondV  |
//|                                         http://                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, narod"
#property link      "bvgcgm@gmail.com"
//#include "BurnInfo.mq4"
/*//+----------------------------------------------------------------+


*///+----------------------------------------------------------------+
 bool TradeBySessions = True;    // True - торговля по сессиям; False - по индикаторам
 string s1 = " ----- Сессия 1 ------ ";
 bool Session1     = True;     // 
extern int  TimeSession1 = 0;       //начало первой сессии
 int  DeltaPrice1  = 5;      //отступ от цены открытия сессии
extern int  TakeProfit1  = 10;     //если= 0, то нет 
 int  StopLoss1    = 0;
 int Reverse1     = True;  // False - выставляются ордера BuyStop и SellStop. True - BuyLimit и SellLimit

//+------------------------------------------------------------------+
 string s2 = " ----- Сессия 2 ------ ";
 bool Session2     = True;     // 
extern int  TimeSession2 = 1;       //начало второй сессии
 int  DeltaPrice2  = 5;      //отступ от цены открытия сессии
extern int  TakeProfit2  = 10;     //если= 0, то нет 
 int  StopLoss2    = 0;
 int Reverse2     = True;  // False - выставляются ордера BuyStop и SellStop. True - BuyLimit и SellLimit

//+------------------------------------------------------------------+
 string s3 = " ----- Сессия 3 ------ ";
 bool Session3     = True;     // 
extern int  TimeSession3 = 2;      //начало третьей сессии
 int  DeltaPrice3  = 5;      //отступ от цены открытия сессии
extern int  TakeProfit3  = 11;     //если= 0, то нет 
 int  StopLoss3    = 0;
 int Reverse3     = True;  // False - выставляются ордера BuyStop и SellStop. True - BuyLimit и SellLimit

//+------------------------------------------------------------------+
 string s4 = " ----- Сессия 4 ------ ";
 bool Session4     = True;     // 
extern int  TimeSession4 = 3;       //начало 4 сессии
 int  DeltaPrice4  = 5;      //отступ от цены открытия сессии
extern int  TakeProfit4  = 10;     //если= 0, то нет 
 int  StopLoss4    = 0;
 int Reverse4     = True;  // False - выставляются ордера BuyStop и SellStop. True - BuyLimit и SellLimit

//+------------------------------------------------------------------+
 string s5 = " ----- Сессия 5 ------ ";
 bool Session5     = True;     // 
extern int  TimeSession5 = 4;       //начало 5 сессии
 int  DeltaPrice5  = 5;      //отступ от цены открытия сессии
extern int  TakeProfit5  = 12;     //если= 0, то нет 
 int  StopLoss5    = 0;
 int  Reverse5   = True;  // False - выставляются ордера BuyStop и SellStop. True - BuyLimit и SellLimit

//+------------------------------------------------------------------+
 string s6 = " ----- Сессия 6 ------ ";
 bool Session6     = True;     // 
extern int  TimeSession6 = 5;       //начало 6 сессии
 int  DeltaPrice6  = 5;      //отступ от цены открытия сессии
extern int  TakeProfit6  = 10;     //если= 0, то нет 
 int  StopLoss6    = 0;
 int Reverse6     = True;  // False - выставляются ордера BuyStop и SellStop. True - BuyLimit и SellLimit

//+------------------------------------------------------------------+
 string s7 = " ----- Сессия 7 ------ ";
 bool Session7     = True;     // 
extern int  TimeSession7 = 22;       //начало 7 сессии
 int  DeltaPrice7  = 5;      //отступ от цены открытия сессии
extern int  TakeProfit7  = 15;     //если= 0, то нет 
 int  StopLoss7    = 0;
 int Reverse7     = True;  // False - выставляются ордера BuyStop и SellStop. True - BuyLimit и SellLimit

//+------------------------------------------------------------------+
 string s8 = " ----- Сессия 8 ------ ";
 bool Session8     = True;     // 
extern int  TimeSession8 = 23;       //начало 8 сессии
 int  DeltaPrice8  = 5;      //отступ от цены открытия сессии
extern int  TakeProfit8  = 12;     //если= 0, то нет 
 int  StopLoss8    = 0;
 int Reverse8     = True;  // False - выставляются ордера BuyStop и SellStop. True - BuyLimit и SellLimit

//+------------------------------------------------------------------+
extern string sTP           = " ---- Параметры Торговли ---- ";
 bool   balance        = False;    // Использовать фиксировный огрничитель баланса
 double freebalance    = 0;  // Количство огрничения блананса при balance = true
extern double ReservDepo     = 0;       //резервирует % от баланса при balance = false
extern double LotMax         = 1000.0;    //максимальный объем лота
extern double GeneralLot     = 0;   // если=0, то выставляется как % от фактического баланса
extern double GeneralPercent = 0.99;   // работает если GeneralLot = 0
extern double KM = 200;     // коэффициент увеличения лота (Multiplier)
extern int LotKM       = 6;       // выставлять после этого ордера c KM
 bool ViewZone = False; // Рисовать Зону 0
extern int Zone0 = 38; // Зона запрета на открытие ордеров с KM. Если 0, то запрета нет
extern int DistanceKM = 120; // Минимальное расстояние между открытыми ордерами с KM за пределами зоны 0. Если 0, то не используется
 int Magic        = 123321;

 string sProgress = "Метод увеличения лота для коэффициента KM. Значения 0 - 3";
 string sProgr1   = "0 - Не использовать; 1 - Геометрическая прогрессия; 2 - Арифметическая; 3 - Фибоначчи";
 int ProgressWay   = 0;  // Метод прогрессии для KM1
//extern int ProgressWay2   = 0;  // Метод прогрессии для KM2
 bool DeletePending = False;  // True - Если ордер открылся, то удалять противоположный отложник
//+------------------------------------------------------------------+
 int    Slippage       = 3;
 string sFilters     = " --- Фильтры и ограничения ---";
 string AboutDistance  = "Минимальная дистанция между ордерами в пунктах; если 0 - фильтр отключен. Фильтр не позволяет открыться ордеру, если он ближе FDistance пунктов к открытому.";
 int FDistance         = 0;  // минимальная дистанция между ордерами в пунктах; если 0 - фильтр отключен 
 string sCP = "Закрыть все ордера, если суммарный профит равен или больше этого значения; если 0, то не учитывается";
 double CloseProfit  = 0;    // закрыть все ордера, если суммарный профит равен или больше этого значения; если 0, то не учитывается
 string sPP = "True - частично закрываем ордер (Фиксируем прибыль) если профит достиг 50% от потенциальной прибыли";
 bool PartialProfit = false; // Частично закрывать профитные ордера
 string AboutxDrop = "Просадка в процентах, после чего закрывать самый просевший ордер; если 0 - просадка не котролируется";
 int xDrop          = 0;  // просадка в процентах после чего закрывать ордер  если 0 просадка не котролируется
 bool PointDrop = false;
 int PartialDrop       = 4;  // Самый просевший ордер закрывается частично по 1/4; диапазон 1 - 5; 1 - закрывается полностью.
//---- Ограничения по количеству ордеров и по размеру лота ----
//---- Добавил LotStop и возможность обрезать лоты до LotCir (Trade = true) либо не выставлять ордера (Trade = false).
//---- Если LotStop = 0, торгуем без ограничений.
 string AboutLotStop = "Ограничение по количеству открываемых ордеров; если 0 - ограничений нет";
  int LotStop       = 0;        //после этого ордера выставлять LotCir  
 string AboutTrade = "При LotStop > 0: True - открываем ордера лотом LotCir; False - не выставляем ордера";
 bool Trade            = true;
  double LotCir        = 0;      //объем лота-обрезателя :)
 int    TimeExpiration  = 120;     //время закрытия ордеров в минутах если 0, то до конца дня

//-------------------------------- Trailing
 string sTrailing        = " ---- Trailing ---- ";
 int    TrailingStop     = 0;      //если= 0, то нет тралла
 int    TrailingStart    = 0;      //начала тралла от 0 профита
 int    DeltaTrailing    = 0;       //минимальное кол-во пунктов для перемещения

 string sCompens = " ---- Настройки компенсирующего ордера ---- ";
 string sCT  = "Условия открытия компенсирующих ордеров";
 string sCT1 = "0 - Не выставлять; 1 - Stochastic Oscillator; 2 - Williams Percent Range; 3 - Сетка Stop-ордеров; 4 - По времени";
 int ChokeType = 0;
 int ChokeDD = 20;   // % просадки, при которой начинает работать компенсатор
 int ChokeTP = 50;  // Take Profit
 int ChokeSL = 0;   // Stop Loss
 int ChokeLotPercent = 0; // Процент от суммы лотов просевших ордеров
 double ChokeKM = 100;  // Коэффициент увеличения лота 
 int ChokePW = 0;       // Метод прогрессии для ChokeKM
 int ChokeTrailStop = 0;   // Trailing Stop
 int ChokeTrailStep = 0;   // Trailing Step
 int ChokeMagic = 123321;  // Магик для сетки
 string sStoch = "-1- Параметры Stochastic Oscillator ----";
 int Stoch.K = 8;    // Период(количество баров) для вычисления линии %K.
 int Stoch.D = 3;    // Период усреднения для вычисления линии %D.
 int Stoch.Slowing = 3;  // Значение замедления
// Метод усреднения. Может быть любым из значений методов скользящего среднего (Moving Average):
// MODE_SMA 0 Простое скользящее среднее 
// MODE_EMA 1 Экспоненциальное скользящее среднее 
// MODE_SMMA 2 Сглаженное скользящее среднее 
// MODE_LWMA 3 Линейно-взвешенное скользящее среднее 
 int Stoch.Method = 2;   
// Параметр выбора цен для расчета. Может быть одной из следующих величин: 0 - Low/High или 1 - Close/Close.
 int Stoch.PF = 0; 
 string sWPR = "-2- Параметры Williams Percent Range ----";
 string sWPRTF = "ТФ: 1 - 1M, 2 - 5M, 3 - 15M, 4 - 30M, 5 - 1H";
 int WPRTF = 4;
 int WPR1 = 13;
 int WPR2 = 80;
 int WPR3 = 210;
 int WPR4 = 420;
 string sChain = "-3- Параметры сетки Stop-ордеров ----";
 int ChainOrders = 5;   // Количество ордеров в сетке
 int ChainStep = 30;    // Расстояние между ордерами в пунктах
 int ChainMinProfit = 100;  // Минимальное значение профита в пунктах, при котором выводить ордер в безубыток;
 int ChainNoLoss = 20;     // Уровень в пунктах, на котором нужно ставить SL при достижении значения ChainMinProfit
// ChainTraling = True (1) - ордера сетки будут выводиться в безубыток по параметрам трала: ChokeTrailStop и ChokeTrailStep
// False (0) - по параметрам ChainMinProfit и ChainNoLoss
 bool ChainTrailing = False;  

 string sChokeByTime = "-4- Параметры компенсатора по времени ----";
 int ChokeTradeTime = 22;   // Время открытия компенсатора
 bool ChokeReverse = False; // Ордер того же направления (False) или противоположного (True)
 int ChokeRepetition = 3;   // Количество повторений (суток), если просадка не снизилась
int ChokeRepet;

bool ChainExists = False;     // True - сетка установлена
int ChainOrderCount = 0;      // Количество ордеров в сетке
int ChainOrderTicket;         // Тикет работающего ордера сетки  
double ChainProfit = 0,       // Профит сетки
       ChainGenlProfit;       // Общий профит всех сеток
datetime ChainTime, OldChainTime;           // Время установки сетки

 string sInfo = " ----- Статистическая информация ----- ";
 bool dohod     = false;
 bool ShowInfo  = True;
 color  WevesColor = White;
// --- End extern --------------------------------------------------------

bool   LimitBuy  = true;                  //разрешить выставлять ордера
bool   LimitSell = true;                  //разрешить выставлять ордера
bool   Reverse   = False;  // False - выставляются ордера BuyStop и SellStop. True - BuyLimit и SellLimit


double MAXLOT, MinLot, NULLPb, NULLPs, Lots_New, Lots, Percent, DeltaPriceUP, DeltaPriceDN, TakeProfit, StopLoss;
double KM1, LotN, resdepo, pr1, Points, OpenPrice, BuyPrice, SellPrice, SL, TP;
int dDayS, dDayB, brh[24], OkrLOT, STOPLEVEL, error, HourT, slp, TrailStop, TrailStart, TrailDelta;
double OldBuyPrice, OldSellPrice, Free, FreeBuy, FreeSell, MB, MS;
datetime TimeBarBay, TimeBarSell, expiration, StartBarTime;
//  Чтобы не открывались ордера-дубликаты. [0] = 1 - массив заполнен, 0 - очищен.
bool SessFlags[9];  // Флаг открытия ордера в определенную сессию. 1 - сегодня ордер открывался, 0 - нет.
// arrInfo[0] - количество открытых Buy ордеров
// arrInfo[1] - количество открытых Sell ордеров
// arrInfo[2] - сумма лотов открытых Buy ордеров
// arrInfo[3] - сумма лотов открытых Sell ордеров
// arrInfo[4] - суммарный профит открытых Buy ордеров
// arrInfo[5] - суммарный профит открытых Sell ордеров
// arrInfo[6] - максимальный лот из открытых Buy ордеров
// arrInfo[7] - максимальный лот из открытых Sell ордеров
// arrInfo[8] - цена безубытка для всех открытых Buy ордеров
// arrInfo[9] - цена безубытка для всех открытых Sell ордеров
double arrInfoOrders[10];
// Сигнал индикаторов. Значения: 0 - нет сигнала; 1 - Buy; 2 - Sell
int iSignal = 0;
bool ChokeExists = False;  // Признак наличия компенсирующего ордера
int ChokeTik = -1; // Тикет компенсирующего ордера
int ChokeLoseNum = 0, WPRpos = 0;
double PrevChokeLot;

// Массив свойств ордера
// BurnOrd[0] - Флаг. Массив инициализирован или нет
// BurnOrd[1] - Тикет ордера
// BurnOrd[2] - Флаг. Тип ордера изменен
// BurnOrd[3] - Тип ордера
// BurnOrd[4] -
int BurnOrdBuy[5], BurnOrdSell[5], ChainOrdBuy[5], ChainOrdSell[5];
// ------------------------------------------------------------------------

double GetInfoData(double &DrawDown, double &ResDepo, double &UsedMoney, double &FreeMoney)
{
  double result, pr1, resdepo, dd, free, used;

   dd = (AccountBalance()-AccountEquity())*100/AccountBalance();
   if(balance) used = freebalance; 
   else used = NormalizeDouble(((AccountFreeMargin()/100)*(100-ReservDepo)),2);
   pr1 = AccountBalance()/100;  // 1% от баланса
   resdepo = NormalizeDouble(pr1*ReservDepo,2);  // зарезервированные ср-ва
   free = AccountFreeMargin()-resdepo;

   DrawDown = dd;
   ResDepo = resdepo;
   UsedMoney = used;
   FreeMoney = free;
   
   return(result);
}

bool DrawLabel(string Name, int Corner, int x, int y)
{
  if (ObjectFind(Name) == -1)
    if (!ObjectCreate(Name, OBJ_LABEL, 0, 0, 0)) return(false);
  if (!ObjectSet(Name, OBJPROP_CORNER, Corner)) return(false);      
  if (!ObjectSet(Name, OBJPROP_XDISTANCE, x)) return(false); 
  if (!ObjectSet(Name, OBJPROP_YDISTANCE, y)) return(false);  

  return(true);
}

// Очистка массива флагов- признаков открытия ордеров в определенную сессию
// [0] - зарезервирован, признак заполнен (1) или очищен (0) массив
// [1..8] - для флагов сессий
void ClearSessFlags()
{
  for (int i = 0; i < 7; i++){
    SessFlags[i] = false;
  }
}

void Check5DigitsForInit()
{
   switch (Digits) {
     case 3:
     case 5:
       slp = Slippage * 10;
       TrailStop  = TrailingStop * 10;    
       TrailStart = TrailingStart * 10;     
       TrailDelta = DeltaTrailing * 10;   
       Zone0 = Zone0 * 10;
       DistanceKM = DistanceKM * 10;
       FDistance *= 10;
       ChokeTP *= 10;
       ChokeSL *= 10;
       ChainStep *= 10;
       ChokeTrailStop *= 10;   // Trailing Stop
       ChokeTrailStep *= 10;   // Trailing Step
       ChainMinProfit *= 10;
       ChainNoLoss *= 10;
     break;
     default:
       slp = Slippage;  
       TrailStop  = TrailingStop;    
       TrailStart = TrailingStart;     
       TrailDelta = DeltaTrailing;   
     break;
   }
}

//+------------------------------------------------------------------+
int init() {
  string h;
  ChokeTik = -1;

  Comment(" ");
  ObjectsDeleteAll();
  ClearSessFlags();
  
   Points = MarketInfo (Symbol(), MODE_POINT); 
   MinLot = MarketInfo(Symbol(),MODE_MINLOT);
   if (MinLot==0.01) OkrLOT = 2;
   if (MinLot >0.01) OkrLOT = 1;
   if (MinLot >0.1 ) OkrLOT = 0;

   Check5DigitsForInit();

   KM1 = KM;
   LotN = LotKM;
   Lots = GeneralLot;
   Percent = GeneralPercent;
   if (ChokeLotPercent < 1) ChokeLotPercent = 1;
   if (ChokeLotPercent > 100) ChokeLotPercent = 100;

   if (PartialDrop < 1) PartialDrop = 1;
   if (PartialDrop > 5) PartialDrop = 5;
   ChainExists = FindChainInit(ChainOrderTicket);
   ChokeExists = False;
   ChokeRepet = ChokeRepetition;

   if (IsTesting() && !IsVisualMode()) ShowInfo = False;
   if (ShowInfo) ShowInfoInit();
   return(0);
  } 
//+------------------------------------------------------------------+
int deinit(){
//  Comment("");
//  if (IsTesting() && IsVisualMode()) return(0);
//  ObjectsDeleteAll();
//  return(0);
}
//+------------------------------------------------------------------+

void ShowInfoInit()
{
   int x = 10, dx = 0, y = 15, dy = 12;
   
   DrawLabel("AccInfo", 1, x, y);  y += 15;
   DrawLabel("СЕССИИ", 1, x, y);  y += dy;
   DrawLabel("БАЛАНС", 1, x, y);  y += dy;
   DrawLabel("Используемый БАЛАНС", 1, x, y);   y += dy;
   DrawLabel("РЕЗЕРВ", 1, x, y);   y += dy;
   DrawLabel("СВОБОДНО", 1, x, y);  y += dy;
   DrawLabel("СВОБОДНО BUY", 1, x, y);  y += dy;
   DrawLabel("СВОБОДНО SELL", 1, x, y);  y += dy;
   DrawLabel("ChainProfit", 1, x, y); y += dy;
   DrawLabel("ПРОСАДКА", 1, x, y);
   
   WindowRedraw();
   
   return;
}

// Вывод торговой информации - ЛЕГЕНДА
void ShowBurnInfo()
{
   int spread = MarketInfo(Symbol(), MODE_SPREAD);
   double dd, DepoReserve, UsedMoney, FreeMoney;
   color TextColor;
   string str;
   
   str = StringConcatenate("Плечо: ", DoubleToStr(AccountLeverage(), 0), ", Спрэд: ", DoubleToStr(spread, 0));
   ObjectSetText("AccInfo", str, 9, "Arial", Aqua);
   
   str = StringConcatenate("СЕССИИ:  ", TimeSession1, " | ", TimeSession2, " | ", TimeSession3, " | ", TimeSession4, " | ",
            TimeSession5, " | ", TimeSession6, " | ", TimeSession7, " | ", TimeSession8);
   ObjectSetText("СЕССИИ", str, 9,"Arial",WevesColor);

   str = StringConcatenate("  БАЛАНС: ", DoubleToStr(AccountBalance(), 2));
   ObjectSetText("БАЛАНС", str,8,"Arial",WevesColor);
   
   GetInfoData(dd, DepoReserve, UsedMoney, FreeMoney);

   str = StringConcatenate("  Используемый БАЛАНС: ", DoubleToStr(UsedMoney, 2));
   ObjectSetText("Используемый БАЛАНС", str,8,"Arial",WevesColor);
   
   str = StringConcatenate("РЕЗЕРВ: ", DoubleToStr(DepoReserve, 2), " (", DoubleToStr(ReservDepo, 2), " %)");
   ObjectSetText("РЕЗЕРВ", str, 8,"Arial",WevesColor);
   
   str = StringConcatenate("  СВОБОДНО: ", DoubleToStr(FreeMoney, 2));
   ObjectSetText("СВОБОДНО", str,8,"Arial",WevesColor);
   
   if (FreeBuy < 0)
     TextColor = Red; 
   else 
     TextColor = White;
   str = StringConcatenate("  СВОБОДНО для BUY: ", DoubleToStr(FreeBuy, 2));
   ObjectSetText("СВОБОДНО BUY", str,8,"Arial",TextColor);
   
   if (FreeSell < 0)
     TextColor=Red; 
   else 
     TextColor=White;
   str = StringConcatenate("  СВОБОДНО для SELL: ", DoubleToStr(FreeSell, 2));
   ObjectSetText("СВОБОДНО SELL", str,8,"Arial",TextColor);
   
   str = StringConcatenate("  СЕТКА: Ордеров: ", ChainOrderCount, ",  ДОХОД: ", DoubleToStr(ChainProfit, 2));
   ObjectSetText("ChainProfit", str,8,"Arial",WevesColor);
   
   str = StringConcatenate("  ПРОСАДКА: ", DoubleToStr(dd, 2), " %");
   ObjectSetText("ПРОСАДКА", str, 10,"Fixedsys",Yellow);

   return;
}

bool Lot() 
{
  string Symb =Symbol(); 
  double One_Lot=MarketInfo(Symb,MODE_MARGINREQUIRED);
  double Min_Lot=MarketInfo(Symb,MODE_MINLOT);
  double Step =MarketInfo(Symb,MODE_LOTSTEP);
  double lMax;
  
  if(balance)Free=freebalance; else Free=NormalizeDouble(((AccountFreeMargin()/100)*(100-ReservDepo)),2);
   FreeBuy = Free/2 + MB;
   FreeSell = Free/2 + MS;
   
   if (FreeBuy < 0)
     if (ChainProfit > 0) FreeBuy += ChainProfit;
   if (FreeBuy < 0) LimitBuy = false;
   else LimitBuy = true;
   if (FreeSell < 0)
     if (ChainProfit > 0) FreeSell += ChainProfit;
   if (FreeSell < 0) LimitSell = false;
   else LimitSell = true;
//   Comment("Free = ", DoubleToStr(Free, 2), ", FreeBuy = ", DoubleToStr(FreeBuy, 2), ", LimitBuy = ", DoubleToStr(LimitBuy, 0),
//      ", FreeSell = ", DoubleToStr(FreeSell, 2), ", LimitSell = ", DoubleToStr(LimitSell, 0));
  lMax = Free/One_Lot - Min_Lot;
  if (Lots > 0) 
  { 
    double Money = Lots*One_Lot; 
     if(Money <= Free) 
      Lots_New = Lots; 
     else 
      Lots_New = lMax;
  }
  else 
  { 
     if (Percent > 100) Percent=100; 
     if (Percent==0) 
       Lots_New=Min_Lot; 
     else 
       Lots_New = lMax/100 * Percent;
  }
  if (Lots_New < Min_Lot) 
    Lots_New=Min_Lot; 
  Lots_New = NormalizeDouble(Lots_New, 2);      
         if (Lots_New*One_Lot > Free) 
          { 
            return(false); 
          }
return(true); 
} 
//+------------------------------------------------------------------+


int start()
{
  int i, SessionNum = 0, SessionCount = 8;
  double dd;
   
   StartBarTime=iTime(NULL,60,0);
   HourT=Hour();
   
  LimitBuy  = true;                  //разрешить выставлять ордера
  LimitSell = true;                  //разрешить выставлять ордера
  TakeProfit = 0.0;
  StopLoss = 0.0;

   STOPLEVEL=MarketInfo(Symbol(),MODE_STOPLEVEL);
   if(STOPLEVEL<1) STOPLEVEL=1;

   Lot();
   

   if (IsTesting() && !IsVisualMode()) { dohod = False; ShowInfo = False; }
   if(dohod){   
     int x = 10, y = 30, dy = 15;
     DrawLabel("доходB", 0, x, y);  y += dy;
     DrawLabel("доходS", 0, x, y);  
   }
   if (ShowInfo) ShowBurnInfo();
   
   if (ChokeExists && Hour() != ChokeTradeTime)
     ChokeExists = False;
   if (!TradeBySessions) {
      ChokeTik = TradeChoke(ChokeType);
      ChokeTrailing();
//      TraillingOrders();
// ----- Drop -----  
   dd = (AccountBalance()-AccountEquity())*100/AccountBalance();
   if(xDrop != 0 && dd > xDrop){
     Print("Достигла просадка в ",dd," %");
     closemax();    
   }

// ----------------   
      return;
   }
   if ((Session1 && Session2 && TimeSession1 >= TimeSession2) || (Session2 && Session3 && TimeSession2 >= TimeSession3)
    || (Session3 && Session4 && TimeSession3 >= TimeSession4) || (Session4 && Session5 && TimeSession4 >= TimeSession5)
    || (Session5 && Session6 && TimeSession5 >= TimeSession6) || (Session6 && Session7 && TimeSession6 >= TimeSession7)
    || (Session7 && Session8 && TimeSession7 >= TimeSession8))
   {
     Comment("Нет последовательности сессий. ","\n","Исправте время начала сессии.");
     Print("Нет последовательности сессий. Исправте время начала сессии.");
     return;
   }
   
// --- Если ордер открылся, то удаляем противоположный отложник ---  
   if (DeletePending && OrderPropChanged(BurnOrdBuy)) {
      DelOrderByProp(BurnOrdSell);
   }
   if (DeletePending && OrderPropChanged(BurnOrdSell)) {
      DelOrderByProp(BurnOrdBuy);
   }
// ----------------------------------------------------------------   

   SessionNum = GetSessionNumber();
   if (SessionNum > 0) {
     SetParamForSession(SessionNum);   
     error = TradeCurrentSession(SessionNum);
   }  

   if (OrdersTotal() > 1) {
      double GeneralProfit = GetProfit();
      if (CloseProfit > 0 && GeneralProfit >= CloseProfit){
        Print("GeneralProfit = ", DoubleToStr(GeneralProfit, 2), ", CloseProfit = ", DoubleToStr(CloseProfit, 2), ". Закрываем все ордера");
        CloseAllOrders(); 
        return;
      }  
      if (PartialProfit) PartialCloseProfit();
      if (ChokeType > 0)
        ChokeTik = TradeChoke(ChokeType);
      ChokeTrailing();  
      ChanceSLTP();
   }
// ----- Drop -----  
   dd = (AccountBalance()-AccountEquity())*100/AccountBalance();
   if(xDrop != 0 && dd > xDrop){
     Print("Достигла просадка в ",dd," %");
     closemax();    
   }

// ----------------   

   
   return(0);
}

int GetSessionNumber()
{
   int res = 0;
   bool condition = false;
   
   if (Session1) {
     if (Session2) condition = (HourT>=TimeSession1 && HourT<TimeSession2);
     else condition = (HourT>=TimeSession1 && HourT <= 23);
     if(condition) return(1);
   }
   if (Session2) {
     if (Session3) condition = (HourT>=TimeSession2 && HourT<TimeSession3);
     else condition = (HourT>=TimeSession2 && HourT <= 23);
     if(condition) return(2);
   }
   if (Session3) {
     if (Session4) condition = (HourT>=TimeSession3 && HourT<TimeSession4);
     else condition = (HourT>=TimeSession3 && HourT <= 23);
     if(condition) return(3);
   }  
   if (Session4) {
     if (Session5) condition = (HourT>=TimeSession4 && HourT<TimeSession5);
     else condition = (HourT>=TimeSession4 && HourT <= 23);
     if(condition) return(4);
   }  
   if (Session5) {
     if (Session6) condition = (HourT>=TimeSession5 && HourT<TimeSession6);
     else condition = (HourT>=TimeSession5 && HourT <= 23);
     if(condition) return(5);
   }  
   if (Session6) {
     if (Session7) condition = (HourT>=TimeSession6 && HourT<TimeSession7);
     else condition = (HourT>=TimeSession6 && HourT <= 23);
     if(condition) return(6);
   }  
   if (Session7) {
     if (Session8) condition = (HourT>=TimeSession7 && HourT<TimeSession8);
     else condition = (HourT>=TimeSession7 && HourT <= 23);
     if(condition) return(7);
   }  
   if (Session8) {
     if(HourT>=TimeSession8 && HourT <= 23)
       return(8);
   }    
   return(res);
}

void SetParamForSession(int Session)
{
//  if (Session < 1) return;
     switch (Session) {
       case 1:
           DeltaPriceUP = DeltaPrice1;      
           DeltaPriceDN = DeltaPrice1;      
           TakeProfit = TakeProfit1;      
           StopLoss = StopLoss1;
           Reverse = Reverse1;
       break;
       case 2:
           DeltaPriceUP=DeltaPrice2;      
           DeltaPriceDN=DeltaPrice2;      
           TakeProfit=TakeProfit2;      
           StopLoss = StopLoss2;
           Reverse = Reverse2;
       break;
       case 3:
           DeltaPriceUP=DeltaPrice3;      
           DeltaPriceDN=DeltaPrice3;      
           TakeProfit=TakeProfit3;       
           StopLoss = StopLoss3;
           Reverse = Reverse3;
       break;
       case 4:
           DeltaPriceUP=DeltaPrice4;      
           DeltaPriceDN=DeltaPrice4;      
           TakeProfit=TakeProfit4;      
           StopLoss = StopLoss4;
           Reverse = Reverse4;
       break;
       case 5:
           DeltaPriceUP=DeltaPrice5;      
           DeltaPriceDN=DeltaPrice5;      
           TakeProfit=TakeProfit5;       
           StopLoss = StopLoss5;
           Reverse = Reverse5;
       break;
       case 6:
           DeltaPriceUP=DeltaPrice6;      
           DeltaPriceDN=DeltaPrice6;      
           TakeProfit=TakeProfit6;      
           StopLoss = StopLoss6;
           Reverse = Reverse6;
       break;
       case 7:
           DeltaPriceUP=DeltaPrice7;      
           DeltaPriceDN=DeltaPrice7;      
           TakeProfit=TakeProfit7;      
           StopLoss = StopLoss7;
           Reverse = Reverse7;
       break;
       case 8:
           DeltaPriceUP=DeltaPrice8;      
           DeltaPriceDN=DeltaPrice8;      
           TakeProfit=TakeProfit8;      
           StopLoss = StopLoss8;
           Reverse = Reverse8;
       break;
     }
     Check5DigitsForStart();
}

void Check5DigitsForStart()
{
     switch (Digits) {
       case 3:
       case 5:
         DeltaPriceUP = DeltaPriceUP * 10;      
         DeltaPriceDN = DeltaPriceDN * 10;      
         TakeProfit = TakeProfit * 10;
         StopLoss = StopLoss * 10;      
       break;
     }
}

void GetPrice(double &buy, double &sell, bool Reverse)
{
  double dUP = DeltaPriceUP*Points;
  double dDN = DeltaPriceDN*Points;
  if (Reverse) {
    buy  = NormalizeDouble(OpenPrice - dUP, Digits);
    sell = NormalizeDouble(OpenPrice + dDN, Digits);
  }
  else {
    buy  = NormalizeDouble(OpenPrice + dUP, Digits); 
    sell = NormalizeDouble(OpenPrice - dDN, Digits); 
  }
}

int TradeCurrentSession(int SessionNumber)
{
  int err = 0;
  
   if (TimeBarBay!=StartBarTime || TimeBarSell!=StartBarTime)
   {
//    RefreshRates();
      OpenPrice = NormalizeDouble(iOpen(NULL,60,0),Digits);
      
     switch (SessionNumber){
       case 1:
      if (HourT==TimeSession1 && Session1) 
      {
         if (TimeExpiration==0) expiration = StrToTime(StringConcatenate(Day(),".",Month(),".",Year()," ",TimeSession2,":00:00")); 
         else expiration = TimeCurrent()+TimeExpiration*60;
         GetPrice(BuyPrice, SellPrice, Reverse);
      }
       break;
       case 2:
      if (HourT==TimeSession2 && Session2) 
      {
         if (TimeExpiration==0) expiration = StrToTime(StringConcatenate(Day(),".",Month(),".",Year()," ",TimeSession3,":00:00")); 
         else expiration = TimeCurrent()+TimeExpiration*60;
         GetPrice(BuyPrice, SellPrice, Reverse);
      }
       break;
       case 3:
      if (HourT==TimeSession3 && Session3) 
      {
         if (TimeExpiration==0) expiration = StrToTime(StringConcatenate(Day()+1,".",Month(),".",Year()," ",TimeSession4,":00:00")); 
         else expiration = TimeCurrent()+TimeExpiration*60;
         GetPrice(BuyPrice, SellPrice, Reverse);
      }
       break;
       case 4:
      if (HourT==TimeSession4 && Session4) 
      {
         if (TimeExpiration==0) expiration = StrToTime(StringConcatenate(Day(),".",Month(),".",Year()," ",TimeSession5,":00:00")); 
         else expiration = TimeCurrent()+TimeExpiration*60;
         GetPrice(BuyPrice, SellPrice, Reverse);
      }
       break;
       case 5:
      if (HourT==TimeSession5 && Session5) 
      {
         if (TimeExpiration==0) expiration = StrToTime(StringConcatenate(Day(),".",Month(),".",Year()," ",TimeSession6,":00:00")); 
         else expiration = TimeCurrent()+TimeExpiration*60;
         GetPrice(BuyPrice, SellPrice, Reverse);
      }
       break;
       case 6:
      if (HourT==TimeSession6 && Session6) 
      {
         if (TimeExpiration==0) expiration = StrToTime(StringConcatenate(Day()+1,".",Month(),".",Year()," ",TimeSession7,":00:00")); 
         else expiration = TimeCurrent()+TimeExpiration*60;
         GetPrice(BuyPrice, SellPrice, Reverse);
      }
       break;
       case 7:
      if (HourT==TimeSession7 && Session7) 
      {
         if (TimeExpiration==0) expiration = StrToTime(StringConcatenate(Day()+1,".",Month(),".",Year()," ",TimeSession8,":00:00")); 
         else expiration = TimeCurrent()+TimeExpiration*60;
         GetPrice(BuyPrice, SellPrice, Reverse);
      }
       break;
       case 8:
      if (HourT==TimeSession8 && Session8) 
      {
         if (TimeExpiration==0) expiration = StrToTime(StringConcatenate(Day()+1,".",Month(),".",Year()," ",TimeSession1,":00:00")); 
         else expiration = TimeCurrent()+TimeExpiration*60;
         GetPrice(BuyPrice, SellPrice, Reverse);
      }
       break;
     }
      
      err = BurnTrade(SessionNumber);
   }

  return (err);
}

int BurnTrade(int SessionNumber)
{
  int OT, err = 0;
  double OOP;
  datetime tb,ts,OOT;

  if(!Lot()) return;
  for (int i=0; i<OrdersTotal(); i++)
  {
    if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      if (Magic==OrderMagicNumber() && OrderSymbol()==Symbol())
      {
        OOP = NormalizeDouble(OrderOpenPrice(),Digits);
        OOT = OrderOpenTime();
        OT = OrderType();
        if (OT==OP_BUY || OT==OP_BUYLIMIT || OT==OP_BUYSTOP) 
        {
          if (tb<OOT){
            OldBuyPrice=OOP;
            tb = OOT;
          }  
        }
        if (OT==OP_SELL || OT==OP_SELLLIMIT || OT==OP_SELLSTOP) 
        {
          if (ts<OOT){
            OldSellPrice=OOP;
            ts = OOT;
          }  
        }
      }
  }
//----
  switch (SessionNumber){
    case 1:
      if (HourT==TimeSession1 && Session1) {
        err = OpenOrders(Reverse);
      }  
    break;
    case 2:
      if (HourT==TimeSession2 && Session2) {
        err = OpenOrders(Reverse);
      }  
    break;
    case 3:
      if (HourT==TimeSession3 && Session3) {
        err = OpenOrders(Reverse);
      }  
    break;
    case 4:
      if (HourT==TimeSession4 && Session4) {
        err = OpenOrders(Reverse);
      }  
    break;
    case 5:
      if (HourT==TimeSession5 && Session5) {
        err = OpenOrders(Reverse);
      }  
    break;
    case 6:
      if (HourT==TimeSession6 && Session6) {
        err = OpenOrders(Reverse);
      }  
    break;
    case 7:
      if (HourT==TimeSession7 && Session7) {
        err = OpenOrders(Reverse);
      }  
    break;
    case 8:
      if (HourT==TimeSession8 && Session8) {
        err = OpenOrders(Reverse);
      }  
    break;
  }
  return(err);
}

int VerifySendOrder(string symbol, int cmd, double volume, double price, int slippage, double stoploss, double takeprofit,
   string comment, int magic=0, datetime expiration=0, color arrow_color=CLR_NONE)
{
  int tik = -1;
  
  if (volume > 0.0) {
    while (!IsTradeAllowed()){
      Sleep(5000);
      RefreshRates();
    }  
    tik = OrderSend(symbol, cmd, volume, price, slippage, stoploss, takeprofit, comment, magic, expiration, arrow_color);
    if (tik == -1) {
      tik = OrderSend(symbol, cmd, volume, price, slippage, 0, 0, comment, magic, expiration, arrow_color);
      if (tik == -1)
        Print("Error ", comment, ": ", GetLastError(),",  ", symbol, ",  Lot: ", volume, ",  Ask: ", Ask, ",  Price: ",
          price, ",  SL: ", stoploss, ",  TP: ", takeprofit, ",  expiration: ",TimeToStr(expiration, TIME_DATE|TIME_MINUTES));
      else 
        OrderModify(tik, price, stoploss, takeprofit, expiration, arrow_color); 
    }
  }    
  return (tik);
}

bool SetOrderProp(int &arrOrdProp[5], int ticket)
{
   ArrayInitialize(arrOrdProp, 0);
   if (ticket < 1) return(false);
   if (!OrderSelect(ticket, SELECT_BY_TICKET)) return(false);
   arrOrdProp[0] = true;
   arrOrdProp[1] = ticket;
   arrOrdProp[2] = false;
   arrOrdProp[3] = OrderType();
   return(true);
}   

bool OrderPropChanged(int &arrOrdProp[5])
{
   int ot, ticket = arrOrdProp[1];
   bool res = false;
   
   if (arrOrdProp[0] == false || ticket < 1) return(res);
   if (!OrderSelect(ticket, SELECT_BY_TICKET)) return(res);
   if (OrderCloseTime() > 0) { ArrayInitialize(arrOrdProp, 0); return(res); }
   arrOrdProp[0] = true;
   ot = OrderType();
   if (ot != arrOrdProp[3]) {
      arrOrdProp[3] = ot;
      arrOrdProp[2] = true;
      res = true;
   }
   return(res);
}

bool DelOrderByProp(int &arrOrdProp[5])
{
   int ot, ticket = arrOrdProp[1];
   bool res = true;
   
   if (arrOrdProp[0] == false || ticket < 1) return(res);
   if (!OrderSelect(ticket, SELECT_BY_TICKET)) return(res);
   if (OrderCloseTime() > 0) { ArrayInitialize(arrOrdProp, 0); return(res); }
   ot = OrderType();
   if (ot != OP_BUY && ot != OP_SELL) {
      res = OrderDelete(ticket);
      ArrayInitialize(arrOrdProp, 0);
   }
   return(res);
}

int OpenOrders(bool reverse)
{
  int tick = 0;
  double lot;
  
  if (TimeBarBay!=StartBarTime && BuyPrice!=OldBuyPrice)
  {
    lot = LOT(1);
    BuyPrice = ZoneControl(true, BuyPrice, OldBuyPrice);
    if (TakeProfit > STOPLEVEL) TP = BuyPrice + TakeProfit * Point; else TP = 0.0;
    TP = NormalizeDouble(TP, Digits);
    if (StopLoss > STOPLEVEL)   SL = BuyPrice - StopLoss   * Point; else SL = 0.0;
    SL = NormalizeDouble(SL, Digits);
    if (LimitBuy) { 
      if (FilterForTrade(OP_BUY, FDistance)) {
        if (reverse) {
          tick = VerifySendOrder(Symbol(), OP_BUYLIMIT, lot, BuyPrice, slp, SL, TP, "BUYLIMIT BLD", Magic, expiration, Blue);
        }  
        else {      
          tick = VerifySendOrder(Symbol(), OP_BUYSTOP, lot,BuyPrice,slp,SL,TP,"BUYSTOP BLD",Magic,expiration,Blue);
        }
        SetOrderProp(BurnOrdBuy, tick);
      }
    }  
    if (tick != -1) TimeBarBay = StartBarTime;
  }  
  if (TimeBarSell!=StartBarTime && SellPrice!=OldSellPrice)
  {
    tick = 0;
    lot = LOT(-1);
    SellPrice = ZoneControl(false, SellPrice, OldSellPrice);
    if (TakeProfit > STOPLEVEL) TP = SellPrice - TakeProfit * Point; else TP = 0.0;
    TP = NormalizeDouble(TP, Digits);
    if (StopLoss > STOPLEVEL)   SL = SellPrice + StopLoss   * Point; else SL = 0.0;
    SL = NormalizeDouble(SL, Digits);
    if (LimitSell) {
      if (FilterForTrade(OP_SELL, FDistance)) {    
        if (reverse) {
          tick = VerifySendOrder(Symbol(),OP_SELLLIMIT, lot,SellPrice,slp,SL,TP,"SELLLIMIT BLD",Magic,expiration,Red );
        }
        else {
          tick = VerifySendOrder(Symbol(),OP_SELLSTOP, lot,SellPrice,slp,SL,TP,"SELLSTOP BLD",Magic,expiration,Red );
        }
        SetOrderProp(BurnOrdSell, tick);
      }
    }
    if (tick != -1) TimeBarSell = StartBarTime;
  }     
  return(tick);
}

bool FilterForTrade(int type, int Distance)
{
  int OT;
  double OOP, d, p = 0;
  bool res = true;
  
  if (Distance == 0) return(res);
  d = NormalizeDouble(Distance * Point, Digits);
  for (int i=0; i<OrdersTotal(); i++)
  {
    if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
    if (Magic==OrderMagicNumber() && OrderSymbol()==Symbol())
    {
      OT = OrderType();
      switch (type) {
        case OP_BUY:
          if (OT==OP_BUY || OT==OP_BUYLIMIT || OT==OP_BUYSTOP) 
          {
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);
            p = MathAbs((BuyPrice - OOP));
            if (p < d) res = false;
          }
        break;
        case OP_SELL:
          if (OT==OP_SELL || OT==OP_SELLLIMIT || OT==OP_SELLSTOP) 
          {
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);
            p = MathAbs((SellPrice - OOP));
            if (p < d) res = false;
          }
        break;
      }
      if (!res) break;   
    }
  }
  return(res);
}

void DrawZone(bool BuyOrder, double priceUP, double priceDN)
{
  string LineObj, TextObj;
  double textcoord;
  color LineColor, TextColor;
  
  if (BuyOrder) {
    LineObj = "BuyLineObj";
    LineColor = Blue;
  }
  else {
    LineObj = "SellLineObj";
    LineColor = Red;
  }
  textcoord = priceUP - (priceUP - priceDN)/2.5;
  if (ObjectFind(LineObj + "1") == -1)
    if (!ObjectCreate(LineObj + "1", OBJ_HLINE, 0, 0, priceUP)) return;
  ObjectSet(LineObj + "1", OBJPROP_PRICE1, priceUP);      
  ObjectSet(LineObj + "1", OBJPROP_WIDTH, 2); 
  ObjectSet(LineObj + "1", OBJPROP_COLOR, LineColor);  

  if (ObjectFind(LineObj + "2") == -1)
    if (!ObjectCreate(LineObj + "2", OBJ_HLINE, 0, 0, priceDN)) return;
  ObjectSet(LineObj + "2", OBJPROP_PRICE1, priceDN);      
  ObjectSet(LineObj + "2", OBJPROP_WIDTH, 2); 
  ObjectSet(LineObj + "2", OBJPROP_COLOR, LineColor);  
  
  if (BuyOrder) {
    TextObj = "BuyTextObj";
    TextColor = Blue;
  }
  else {
    TextObj = "SellTextObj";
    TextColor = Red;
  }
  if (ObjectFind(TextObj) == -1)
    if (!ObjectCreate(TextObj, OBJ_TEXT, 0, Time[0], textcoord)) return;
  ObjectSet(TextObj, OBJPROP_TIME1, Time[0]);      
  ObjectSet(TextObj, OBJPROP_PRICE1, textcoord);      
  ObjectSetText(TextObj, "Zone 0", 12, "Arial", TextColor);

}

double ZoneControl(bool BuyOrder, double NewPrice, double OldPrice)
{
  double dKM, ZoneUP, ZoneDN, z, res;
  bool term;
  
  if (Zone0 <= 0 || DistanceKM <= 0) {
    ZoneUP = 0;
    ZoneDN = 0;
    return (NewPrice);
  }
  res = NewPrice;
  dKM = DistanceKM*Points;
  z = Zone0*Points;
  ZoneUP = OldPrice + z/2;
  ZoneDN = OldPrice - z/2;
  
  GetInfoOrders(arrInfoOrders);
//  Comment("Zone0: ", ZoneUP, ", ", ZoneDN, ", b = ", arrInfoOrders[0], ", s = ", arrInfoOrders[1]);
  term = (NewPrice >= ZoneDN && NewPrice <= ZoneUP);
  if (Reverse) {
    if (BuyOrder) {
      if (arrInfoOrders[0] > LotKM && term) {
        res = NormalizeDouble(ZoneDN - dKM, Digits);
      }
    }
    else {
      if (arrInfoOrders[1] > LotKM && term) {
        res = NormalizeDouble(ZoneUP + dKM, Digits);
      }
    }
  }
  else {
    if (BuyOrder) {
      if (arrInfoOrders[0] > LotKM && term) {
        res = NormalizeDouble(ZoneUP + dKM, Digits);
      }
    }
    else {  
      if (arrInfoOrders[1] > LotKM && term) {
        res = NormalizeDouble(ZoneDN - dKM, Digits);
      }
    }
  }
  if (ViewZone)  DrawZone(BuyOrder, ZoneUP, ZoneDN);
  NewPrice = res;
  return (res);
}

// Функция возвращает следующую информацию:
// arrInfo[0] - количество открытых Buy ордеров
// arrInfo[1] - количество открытых Sell ордеров
// arrInfo[2] - сумма лотов открытых Buy ордеров
// arrInfo[3] - сумма лотов открытых Sell ордеров
// arrInfo[4] - суммарный профит открытых Buy ордеров
// arrInfo[5] - суммарный профит открытых Sell ордеров
// arrInfo[6] - максимальный лот из открытых Buy ордеров
// arrInfo[7] - максимальный лот из открытых Sell ордеров
// arrInfo[8] - цена безубытка для всех открытых Buy ордеров
// arrInfo[9] - цена безубытка для всех открытых Sell ордеров
void GetInfoOrders(double &arrInfo[])
{
  double b, s, lot, lot_b, lot_s, price, price_b, price_s;
  double MargaBuy, MargaSell, maxBuy, maxSell;
  
//  ArrayInitialize(arrInfo, 0);
   for (int i=0; i<OrdersTotal(); i++) {
     if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
     if (OrderSymbol() != Symbol()) continue;
     if (Magic != OrderMagicNumber() && OrderMagicNumber() != ChokeMagic) continue; 
       price = OrderOpenPrice();
       lot   = OrderLots();
       if (OrderType()==OP_BUY) {
         MargaBuy+=OrderProfit();
         price_b = price_b+price*lot; b++;  lot_b=lot_b+lot;
         if (maxBuy < lot) maxBuy = lot;
       }
       if (OrderType()==OP_SELL) {
         MargaSell+=OrderProfit();
         price_s = price_s+price*lot; s++;  lot_s=lot_s+lot;
         if (maxSell < lot) maxSell = lot;
       }
   }  
   arrInfo[0] = b;
   arrInfo[1] = s;
   arrInfo[2] = lot_b;
   arrInfo[3] = lot_s;
   arrInfo[4] = MargaBuy;
   arrInfo[5] = MargaSell;
   arrInfo[6] = maxBuy;
   arrInfo[7] = maxSell;
   if (lot_b > 0) arrInfo[8] = NormalizeDouble(price_b/lot_b, Digits);
   else arrInfo[8] = 0;
   if (lot_s > 0) arrInfo[9] = NormalizeDouble(price_s/lot_s, Digits);
   else arrInfo[9] = 0;
   return;
}

//+------------------------------------------------------------------+
//|                                           Уровень безубыточности |
//|                              Copyright © 2010, Khlistov Vladimir |
//|                                         http://cmillion.narod.ru |
//+------------------------------------------------------------------+
double GetProfit()
{ 
   int b,s;
   double  MargaSell,MargaBuy,price,price_b,price_s,lot,lot_s,lot_b, res;
   color TextColor;

  GetInfoOrders(arrInfoOrders);
  b = arrInfoOrders[0];
  s = arrInfoOrders[1];
  lot_b = arrInfoOrders[2];
  lot_s = arrInfoOrders[3];
  MargaBuy = arrInfoOrders[4];
  MargaSell = arrInfoOrders[5];
  NULLPb = arrInfoOrders[8];
  NULLPs = arrInfoOrders[9];
    
   MB = MargaBuy;
   MS = MargaSell;
   res = MB + MS;
   ObjectDelete("NULLPb");
   if (b!=0) {
      ObjectCreate("NULLPb",OBJ_ARROW,0,Time[0],NULLPb,0,0,0,0);                     
      ObjectSet   ("NULLPb",OBJPROP_ARROWCODE,6);
      ObjectSet   ("NULLPb",OBJPROP_COLOR, Blue);
   }
   ObjectDelete("NULLPs");
   if (s!=0) {
      ObjectCreate("NULLPs",OBJ_ARROW,0,Time[0],NULLPs,0,0,0,0);                     
      ObjectSet   ("NULLPs",OBJPROP_ARROWCODE,6);
      ObjectSet   ("NULLPs",OBJPROP_COLOR, Red);
   }
   if (IsTesting() && !IsVisualMode()) dohod = False;
   if (dohod) {
     if (MargaBuy < 0) TextColor=Red; else TextColor=LawnGreen;
     string str = StringConcatenate("BUY  ордеров = ",b,",  лот = ",DoubleToStr(lot_b,OkrLOT),",  доход = ",DoubleToStr(MargaBuy ,2));
     ObjectSetText("доходB", str, 9, "Arial", TextColor);
     if (MargaSell < 0) TextColor=Red; else TextColor=LawnGreen;
     str = StringConcatenate("SELL ордеров = ",s,",  лот = ",DoubleToStr(lot_s,OkrLOT),",  доход = ",DoubleToStr(MargaSell,2));
     ObjectSetText("доходS", str, 9, "Arial", TextColor);
   }
   return(res);
}

// Получение числа из последовательности Фибоначчи по порядковому номеру
int GetFibo(int x)
{
  int i, n1 = 0, n2 = 1, res = 1;
  
  for (i = 2; i <= x; i++) {
    res = n2 + n1; n1 = n2; n2 = res;
  }
  return(res);
}

// Рассчет коэффициента умножения лота.
double GetMultiplier(double Koeff, int Method, int i, int j)
{
  double res;
  int y, z;
  
  if (Koeff < 0) Koeff = 0;
  if (i < j) y = 1;
  else y = i - j + 1;
  switch (Method) {
    case 0:  
    // Нет прогрессии
      res = Koeff;
    break;
    case 1:  
    // Геометрическая прогрессия
       res = MathPow(Koeff, y);
    break;
    case 2: 
    // Арифметическая прогрессия
      res = Koeff * y;
    break;
    case 3: 
    // Прогрессия в последовательности Фибоначчи
      res = Koeff * GetFibo(y);
    break;
  }
  return(res);
}

//+------------------------------------------------------------------+
//|                                                 Определение лота |
//|                              Copyright © 2010, Khlistov Vladimir |
//|                                         http://cmillion.narod.ru |
//+------------------------------------------------------------------+
double LOT(int tip)
{  
  double lot, k;
  double Step = MarketInfo(Symbol(),MODE_LOTSTEP);
  
   lot = Lots_New;
   int b = 0, s = 0;
   for (int i = 0; i < OrdersTotal(); i++) {  
      if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      if (Magic==OrderMagicNumber() && OrderSymbol()==Symbol()) {  
        if (OrderType()==OP_BUY ) {
          b++;
        }
        if (OrderType()==OP_SELL) { 
          s++;
        }
      }
   }
   double pw1 = ProgressWay;
   if (tip== 1) 
   {
      if (b >= LotN) 
      {
          k = GetMultiplier(KM1, pw1, b, LotN);
          if (k < 1) k = 1; 
          lot = Lots_New * k;
      }
      if (LotStop > 0 && b >= LotStop)  
        if (Trade) lot=LotCir;
        else LimitBuy = false;    
              
   }
   if (tip==-1) 
   {
      if (s >= LotN) 
      {
          k = GetMultiplier(KM1, pw1, s, LotN);
          if (k < 1) k = 1; 
          lot = Lots_New * k;
      }
      if (LotStop > 0 && s >= LotStop)  
        if (Trade) lot = LotCir;
        else LimitSell = false;     
   }
   //--------------- проверка лотов
   pr1 = NormalizeDouble(AccountBalance()/100,2);  // 1% от баланса
   resdepo = NormalizeDouble(pr1*ReservDepo,2);  // зарезервированные ср-ва
   MAXLOT = NormalizeDouble((AccountFreeMargin()-resdepo)/MarketInfo(Symbol(),MODE_MARGINREQUIRED)-MinLot,OkrLOT);
   if (MAXLOT<0) MAXLOT=0;
   if (MAXLOT>MarketInfo(Symbol(),MODE_MAXLOT)) MAXLOT=MarketInfo(Symbol(),MODE_MAXLOT);
   if (lot>LotMax) lot = LotMax; 
   if (lot>MAXLOT) lot = MAXLOT;
   if (lot<MinLot) lot = MinLot;
   if (MAXLOT<MinLot) lot = 0;
   lot = NormalizeDouble(lot, 2);
   return(lot);
}


//+------------------------------------------------------------------+
//|                                               перемещение стопов |
//|                              Copyright © 2011, Khlistov Vladimir |
//|                                         http://cmillion.narod.ru |
//+------------------------------------------------------------------+
void ChanceSLTP()//перенос CЛ и ТП
{  
   int tip,Ticket;
   double OSL,OOP,OTP;
   double TPb,SLb,TPs,SLs;
   if (!TradeBySessions) { TakeProfit = ChokeTP; StopLoss = ChokeSL; }
   if (NULLPb > 0) TPb = NormalizeDouble(NULLPb + Point * TakeProfit,Digits);
   SLb = NormalizeDouble(Bid - Point * TrailStop,Digits);
   if (NULLPs > 0) TPs = NormalizeDouble(NULLPs - Point * TakeProfit,Digits);
   SLs = NormalizeDouble(Ask + Point * TrailStop,Digits);
   for (int i=0; i<OrdersTotal(); i++) 
   {  if (OrderSelect(i, SELECT_BY_POS))
      {  tip = OrderType();
         if (OrderSymbol()==Symbol() && (Magic==OrderMagicNumber()/* || OrderMagicNumber() == ChokeMagic*/))
         {
            OSL   = NormalizeDouble(OrderStopLoss(),Digits);
            OTP   = NormalizeDouble(OrderTakeProfit(),Digits);
            OOP   = OrderOpenPrice();
            Ticket = OrderTicket();
            if (tip==OP_BUY)             
            {
               if (TPb == 0) TPb = OTP;
               if (TPb<=Ask+STOPLEVEL*Point || OTP==0) TPb=OTP;
               if (SLb>=Bid-STOPLEVEL*Point) SLb=OSL;
               if (SLb<NULLPb+TrailStart*Point)  SLb=OSL;
               if (SLb<OSL+TrailDelta*Point)  SLb=OSL;
               if (OTP==TPb && OSL==SLb) continue;
               while (!IsTradeAllowed()){
                 Sleep(5000);
                 RefreshRates();
               }  
               if (!OrderModify(Ticket,OOP,SLb,TPb,0,White)) 
                  Print("Ошибка OrderModify Buy ",OSL," -> ",SLb,"  ",OTP," -> ",TPb,"  ",GetLastError());
            }                                         
            if (tip==OP_SELL)        
            {
               if (TPs == 0) TPs = OTP;
               if (TPs>=Bid-STOPLEVEL*Point || OTP==0) TPs=OTP;
               if (SLs<=Ask+STOPLEVEL*Point) SLs=OSL;
               if (SLs>NULLPs-TrailStart*Point)  SLs=OSL;
               if (SLs>OSL-TrailDelta*Point && OSL!=0)  SLs=OSL;
               if (OTP==TPs && OSL==SLs)  continue;
               while (!IsTradeAllowed()){
                 Sleep(5000);
                 RefreshRates();
               }  
               if (!OrderModify(Ticket,OOP,SLs,TPs,0,White)) 
                  Print("Ошибка OrderModify Sell",OSL," -> ",SLs,"  ",OTP," -> ",TPs,"  ",GetLastError());
            } 
         }
      }
   }
}

//+------------------------------------------------------------------+     

// Закрываем самый просевший ордер
// Закрываем частично, по 1/4 лота 
void closemax()
{
  double lot, CloseLots, profit=0, op, points = 0;
  int tik = -1, i, pd, err = 0, ot;

  for(i = 0; i < OrdersTotal(); i++) {  
    if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)||OrderSymbol() !=Symbol() ) continue; 
    if(OrderMagicNumber()==Magic/* || OrderMagicNumber() == ChokeMagic*/){
      if (PointDrop){
//        ot = OrderType();
        op = MathAbs(OrderProfit()/OrderLots());
        if (points < op){
          points = op;
          tik = OrderTicket();
        }
      }
      else {
        if (OrderProfit() < profit) {
          profit=OrderProfit();
          tik=OrderTicket();
        }
      }        
    }
  }
                  
  if(tik < 0) return;
    OrderSelect(tik,SELECT_BY_TICKET,MODE_TRADES);
    CloseLots = OrderLots();
    ot = OrderType();
    pd = PartialDrop;
    if (CloseLots > MinLot){
        for (i = 1; i <= PartialDrop; i++) {
          err = 0;
          lot = NormalizeDouble(CloseLots / pd, 2);  
          if (PointDrop)
            Print ("Попытка ", i, " закрыть самый убыточный ордер: #", tik, " в ", DoubleToStr(points, 0), " пунктов ЛОТОМ: ", lot);
          else  
            Print ("Попытка ", i, " закрыть самый убыточный ордер: #", tik, " с убытком ", DoubleToStr(profit, 2), " ЛОТОМ: ", lot);
          while (!IsTradeAllowed()) Sleep(5000);
          RefreshRates();
          if (ot==OP_BUY ) {
            if (OrderClose (tik, lot, NormalizeDouble(Bid,Digits),slp))
              break;  // Успешное закрытие, выходим
          }   
          if (ot==OP_SELL) {
            if (OrderClose (tik, lot, NormalizeDouble(Ask,Digits),slp))
              break;  // Успешное закрытие, выходим
          }
          pd--;   
        }
    }
    else {
      if (PointDrop)
        Print ("Закрываем самый убыточный ордер: #", tik, " в ", DoubleToStr(points, 0), " пунктов ЛОТОМ: ", CloseLots);
      else  
        Print ("Закрываем самый убыточный ордер: #", tik, " с убытком ", DoubleToStr(profit, 2), " ЛОТОМ: ", CloseLots);
      while (!IsTradeAllowed()) Sleep(5000);
      RefreshRates();
      if (ot==OP_BUY ) OrderClose (tik, CloseLots,NormalizeDouble(Bid,Digits),slp);
      if (ot==OP_SELL) OrderClose (tik, CloseLots,NormalizeDouble(Ask,Digits),slp);
    }
}

void CloseAllOrders() {
  int tik = -1, ot;
  double lots, price;
  for (int i = 0; i < OrdersTotal() ; i++) {
    if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES) || OrderSymbol() !=Symbol() ) continue; 
    if (OrderMagicNumber() != Magic && OrderMagicNumber() != ChokeMagic) continue;
    tik = OrderTicket();
    ot = OrderType();
    lots = OrderLots();
    if(ot == OP_BUY || ot == OP_SELL) {
      if (ot == OP_BUY ) price = NormalizeDouble(Bid, Digits);
      else price = NormalizeDouble(Ask, Digits);
      if (OrderClose(tik, lots, price, slp)){
//      Sleep(1000);
        i--;
      }
    }    
  }  
  return;
}

void PartialCloseProfit()
{
  double lot, CloseLots, profit=0, pp, points = 0;
  int tik = -1, i, div = 2, err = 0, ot;

  for(i = 0; i < OrdersTotal(); i++) {  
    if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES) || OrderSymbol() != Symbol()) continue; 
    if(OrderMagicNumber() != Magic/* && OrderMagicNumber() != ChokeMagic*/) continue;
    ot = OrderType();
    lot = OrderLots();
    pp = MathAbs(OrderTakeProfit() - OrderOpenPrice())/Point*lot;
    profit = OrderProfit();
    if (profit >= pp/div) {
       tik = OrderTicket();
       CloseLots = NormalizeDouble(lot/div, 2);
       if (CloseLots > MinLot*5) {
          while (!IsTradeAllowed()) {
            Sleep(5000);
            RefreshRates();
          }
          Print ("Попытка закрыть ордер: #", tik, " с прибылью: ", DoubleToStr(profit/div, 2), " ЛОТОМ: ", CloseLots);
          if (ot==OP_BUY ) {
            OrderClose(tik, CloseLots, NormalizeDouble(Bid,Digits),slp);
          //    break;  // Успешное закрытие, выходим
          }   
          if (ot==OP_SELL) {
            OrderClose(tik, CloseLots, NormalizeDouble(Ask,Digits),slp);
          //    break;  // Успешное закрытие, выходим
          }
       }
       else {
         while (!IsTradeAllowed()) {
           Sleep(5000);
           RefreshRates();
         }  
         Print ("Закрываем ордер: #", tik, " с прибылью: ", DoubleToStr(profit, 2), " ЛОТОМ: ", lot);
         if (ot==OP_BUY ) OrderClose (tik, lot, NormalizeDouble(Bid,Digits),slp);
         if (ot==OP_SELL) OrderClose (tik, lot, NormalizeDouble(Ask,Digits),slp);
                  
      }
    }  
  }

}

bool BurnOrderClose(int tic, double lots = 0)
{
  int ot;
  
  if (!OrderSelect(tic, SELECT_BY_TICKET)) return(True);
  if (OrderCloseTime() != 0) return(True);
  ot = OrderType();
  if (lots == 0) lots = OrderLots();
  if (ot==OP_BUY )
    if (OrderClose (tic, lots, NormalizeDouble(Bid, Digits), slp))
      return(True);
  if (ot==OP_SELL) 
    if (OrderClose (tic, lots, NormalizeDouble(Ask, Digits), slp))
      return(True);
  return(False);
}

double GetChokeLot()
{
  string Symb =Symbol(); 
  double One_Lot = MarketInfo(Symb,MODE_MARGINREQUIRED);
  double Min_Lot = MarketInfo(Symb,MODE_MINLOT);
  double Step = MarketInfo(Symb,MODE_LOTSTEP);
  double lMax, Lots_New;
  
  if (balance) Free = freebalance; 
  else Free = NormalizeDouble(((AccountFreeMargin()/100)*(100-ReservDepo)),2);
  lMax = Free/One_Lot - Min_Lot;
  if (Lots > 0) 
  { 
    double Money=Lots*One_Lot; 
     if(Money<=Free) 
      Lots_New=Lots; 
     else 
      Lots_New = lMax;
  }
  else 
  { 
     if (Percent > 100) Percent = 100; 
     if (Percent == 0) 
       Lots_New=Min_Lot; 
     else 
       Lots_New = lMax/100 * Percent;
  }
  if (KM > 0)
    Lots_New = Lots_New * KM;
  if (Lots_New < Min_Lot) Lots_New = Min_Lot; 
  if (Lots_New > lMax) Lots_New = lMax;
  Lots_New = NormalizeDouble(Lots_New, 2);      
  return (Lots_New);  
}

int TradeChoke(int type)
{
   int res = -1, sig, ot, op, PowSig;
   double dd, lots, lotsB, lotsS, price, sl, tp, ctp = ChokeTP; 
 
   switch (type) {
      case 1:     // Торуем по стохастику
         sig = GetSignalStoch();
      break;
      case 2:     // Торгуем по WPR
         sig = GetSignalWPR();
      break;
      case 3:     // Выставляем сетку Stop-ордеров
         ChainControl();
         return(res);
      break;
      case 4:
         if (!ChokeExists && ChokeRepet > 0 && Hour() == ChokeTradeTime)
           res = ChokeByTime();  
         return(res);
      break;
      default:
         sig = 0;
         return(res);
      break;
   }  
   switch (sig) {
      case 1:
         Comment("Signal BUY"); 
         if (OrderSelect(ChokeTik, SELECT_BY_TICKET)) {
           if (OrderCloseTime() != 0) { ChokeTik = -1; break; }
           ot = OrderType();
           op = OrderProfit();
           if (ot == OP_SELL) {
             if (op >= 0) {
               Print("Signal BUY! Close Choke SELL #", ChokeTik, ", profit = ", op);
               if (BurnOrderClose(ChokeTik)) { ChokeTik = -1; PrevChokeLot = 0; ChokeLoseNum--; }
             }
           }
         }
      break;
      case 2:
         Comment("Signal SELL"); 
         if (OrderSelect(ChokeTik, SELECT_BY_TICKET)) {
           if (OrderCloseTime() != 0) { ChokeTik = -1; break; }
           ot = OrderType();
           op = OrderProfit();
           if (ot == OP_BUY) {
             if (op >= 0) {
               Print("Signal SELL! Close Choke BUY #", ChokeTik, ", profit = ", op);
               if (BurnOrderClose(ChokeTik)) { ChokeTik = -1; PrevChokeLot = 0; ChokeLoseNum--; }
             }  
           }
         }
      break;
      default:
         Comment(""); 
      break;
   }
   
   if (TradeBySessions) {
     dd = (AccountBalance()-AccountEquity())*100/AccountBalance();
     if (dd < ChokeDD) return(ChokeTik);
   }  
   if (OrderSelect(ChokeTik, SELECT_BY_TICKET))
     if (OrderCloseTime() == 0) return(ChokeTik);
     else {
       if (OrderProfit() < 0) {
         PrevChokeLot = OrderLots(); ChokeLoseNum++; 
         ChokeTik = -1;
         Sleep(100000);
         RefreshRates();
         return(ChokeTik);
       }
       else { PrevChokeLot = 0; ChokeLoseNum--; }
       ChokeTik = -1;
     }  
     
   if (sig > 0) {
     Lot();
     double lotMin = MarketInfo(Symbol(),MODE_MINLOT);
     if (TradeBySessions) {
       GetInfoOrders(arrInfoOrders);
       lotsB = arrInfoOrders[2]; // сумма лотов открытых Buy ордеров
       lotsS = arrInfoOrders[3]; // сумма лотов открытых Sell ордеров
     }
     else {
         lots = GetChokeLot();
     }  
   }  
   switch (sig) {
    
      case 1:
      
         if (TradeBySessions) {
  //          LotMax = MarketInfo(Symbol(), MODE_MAXLOT);
  //          lotMin = MarketInfo(Symbol(), MODE_MINLOT);
            lots = NormalizeDouble(lotsS*ChokeLotPercent/100, 2);
            lots = lots * ChokeKM;
            if (lots < lotMin) lots = lotMin;
            if (lots > LotMax) lots = LotMax;
         }   
         price = NormalizeDouble(Ask, Digits);
         if (ChokeTP > 0) tp = NormalizeDouble(Ask + ctp * Point, Digits);
         else tp = 0.0;
         if (ChokeSL > 0) sl = NormalizeDouble(Bid - ChokeSL * Point, Digits);
         else sl = 0.0;
    //     if (lots < 0) lots = lotMin;
         
         Print("Открываем Choke BUY лотом - ", lots);
         res = VerifySendOrder(Symbol(),OP_BUY, lots, price, slp, sl, tp, "Choke Buy", ChokeMagic, 0, Blue);
//         if (res > -1) sig = 0;
      break;
      case 2:
         if (TradeBySessions) {
   //        LotMax = MarketInfo(Symbol(), MODE_MAXLOT);
  //         lotMin = MarketInfo(Symbol(), MODE_MINLOT);
           lots = NormalizeDouble(lotsB*ChokeLotPercent/100, 2);
           lots = lots * ChokeKM;
           if (lots < lotMin) lots = lotMin;
           if (lots > LotMax) lots = LotMax;
         }  
         price = NormalizeDouble(Bid, Digits);
         if (ChokeTP > 0) tp = NormalizeDouble(Bid - ctp * Point, Digits);
         else tp = 0.0;
         if (ChokeSL > 0) sl = NormalizeDouble(Ask + ChokeSL * Point, Digits);
         else sl = 0.0;
         Print("Открываем Choke SELL лотом - ", lots);
         res = VerifySendOrder(Symbol(),OP_SELL, lots, price, slp, sl, tp, "Choke Sell", ChokeMagic, 0, Red);
//         if (res > -1) sig = 0;
      break;
   }
   return(res);
}

// Функция выдает сигнал по индикатору Стохастик Осциллятор на Buy (значение 1), на Sell (2) либо 0 - нет сигнала
int GetSignalStoch()
{
   int res = 0, TF = PERIOD_H1;
   int St_min = 20;                  // Миним.  уровень стохастика
   int St_max = 80;                  // Максим. уровень стохастика 
   double st_main0, st_main1, st_signal0, st_signal1;
   
   st_main0 = iStochastic(NULL, TF, Stoch.K, Stoch.D, Stoch.Slowing, Stoch.Method, Stoch.PF, MODE_MAIN, 0);
   st_main1 = iStochastic(NULL, TF, Stoch.K, Stoch.D, Stoch.Slowing, Stoch.Method, Stoch.PF, MODE_MAIN, 1);
   st_signal0 = iStochastic(NULL, TF, Stoch.K, Stoch.D, Stoch.Slowing, Stoch.Method, Stoch.PF, MODE_SIGNAL, 0);
   st_signal1 = iStochastic(NULL, TF, Stoch.K, Stoch.D, Stoch.Slowing, Stoch.Method, Stoch.PF, MODE_SIGNAL, 1);
   
   if ((st_signal1 <= St_min && st_signal0 > St_min) && (st_main0 > st_main1 && st_main0 > st_signal0))
     res = 1;  // Сигнал на Buy
   else
   if ((st_signal1 >= St_max && st_signal0 < St_max) && (st_main0 < st_main1 && st_main0 < st_signal0))
       res = 2;   // Сигнал на Sell
       
   return(res);
}

int GetSignalWPR()
{
   int res = 0, ZoneBuy = -80, ZoneSell = -20, TF = PERIOD_M30;
   double wpr1[5], wpr2[5], wpr3[5], wpr4[5], wpr5[5];
   bool pattern1, pattern2, pattern3, pattern4;

   switch (WPRTF) {
      case 1: TF = PERIOD_M1; break;
      case 2: TF = PERIOD_M5; break;
      case 3: TF = PERIOD_M15; break;
      case 4: TF = PERIOD_M30; break;
      case 5: TF = PERIOD_H1; break;
      default: TF = PERIOD_M30; break;
   }

// Быстрый WPR(14) для ТФ M1

   wpr1[0] = iWPR(NULL, TF, WPR1, 0);
   wpr1[1] = iWPR(NULL, TF, WPR1, 1);
   wpr1[2] = iWPR(NULL, TF, WPR1, 2);
   wpr1[3] = iWPR(NULL, TF, WPR1, 3);
   wpr1[4] = iWPR(NULL, TF, WPR1, 4);

// Быстрый WPR(70) для ТФ M5
   
   wpr2[0] = iWPR(NULL, TF, WPR2, 0);
   wpr2[1] = iWPR(NULL, TF, WPR2, 1);
   wpr2[2] = iWPR(NULL, TF, WPR2, 2);
   wpr2[3] = iWPR(NULL, TF, WPR2, 3);
   wpr2[4] = iWPR(NULL, TF, WPR2, 4);

// Медленный WPR(210) для ТФ M15
   
   wpr3[0] = iWPR(NULL, TF, WPR3, 0);
   wpr3[1] = iWPR(NULL, TF, WPR3, 1);
   wpr3[2] = iWPR(NULL, TF, WPR3, 2);
   wpr3[3] = iWPR(NULL, TF, WPR3, 3);
   wpr3[4] = iWPR(NULL, TF, WPR3, 4);

// Медленный WPR(420) для ТФ M30 либо WPR(840) для ТФ H1
   
   wpr4[0] = iWPR(NULL, TF, WPR4, 0);
   wpr4[1] = iWPR(NULL, TF, WPR4, 1);
   wpr4[2] = iWPR(NULL, TF, WPR4, 2);
   wpr4[3] = iWPR(NULL, TF, WPR4, 3);
   wpr4[4] = iWPR(NULL, TF, WPR4, 4);
   
// Паттерн Веер в зоне Buy. Очень сильный сигнал на Buy
// Возможно, разворот тренда
   pattern1 = ((wpr1[2] <= ZoneBuy && wpr1[4] >= wpr1[3] && wpr1[3] >= wpr1[2]  && wpr1[2] < wpr1[1] && wpr1[1] < wpr1[0] && wpr1[0] > ZoneBuy) && 
               (wpr2[2] <= ZoneBuy && wpr2[4] >= wpr2[3] && wpr2[3] >= wpr2[2]  && wpr2[2] < wpr2[1] && wpr2[1] < wpr2[0] && wpr2[0] > ZoneBuy) &&
               (wpr3[2] <= ZoneBuy && wpr3[4] >= wpr3[3] && wpr3[3] >= wpr3[2]  && wpr3[2] < wpr3[1] && wpr3[1] < wpr3[0] && wpr3[0] > ZoneBuy) &&
               (wpr4[2] <= ZoneBuy && wpr4[4] >= wpr4[3] && wpr4[3] >= wpr4[2]  && wpr4[2] < wpr4[1] && wpr4[1] < wpr4[0]/* && wpr4[0] > ZoneBuy*/));

   if (pattern1) return(1);  // Сигнал на Buy

// Сигнал на Buy - доливка
// Быстрая пробила тяжелую снизу
   pattern2 = ((wpr4[0] < -50 && wpr4[2] <= wpr4[1] && wpr4[0] > wpr4[1]) && 
               (wpr1[1] <= wpr4[0] && wpr1[0] > wpr4[0]));  
   if (pattern2) return(1); // Сигнал на Buy          
               
// Сигнал на Buy - доливка
   if (WPRpos == 0 && wpr1[0] < ZoneBuy) {
      WPRpos = -1; return(0); // Быстрая зашла в зону перекупленности. Нужно подтверждение сигнала.
   }
   else if (WPRpos == -1 && wpr1[0] > ZoneBuy) {
      WPRpos = 0;    // Быстрая вышла из зоны. Проверяем сигнал.
   pattern3 = ((wpr4[0] > -100 + 70 && wpr4[0] >= wpr4[1]) && (wpr3[0] > -100 + 50 && wpr3[0] >= wpr3[1]) && 
               (wpr2[0] > -100 + 40 && wpr2[0] > wpr2[1]));   
      if (pattern3) return(1); // Сигнал на Buy
   }

// Сигнал на Buy - доливка
   pattern4 = ((wpr4[0] > -100 + 70 && wpr4[0] > wpr4[1] && wpr4[1] > wpr4[2]) && (wpr3[0] > -100 + 50 && wpr3[0] > wpr3[1] && wpr3[1] > wpr3[2]) && 
               (wpr2[0] > -100 + 40 && wpr2[0] > wpr2[1] && wpr2[1] > wpr3[2]) && (wpr1[2] <= -100 + 30 && wpr1[1] > wpr1[2] && wpr1[0] > wpr1[1]));   
   if (pattern4) return(1); // Сигнал на Buy

// Паттерн Веер в зоне Sell. Очень сильный сигнал на Sell
   pattern1 = ((wpr1[2] >= ZoneSell && wpr1[4] <= wpr1[3] && wpr1[3] <= wpr1[2]  && wpr1[2] > wpr1[1] && wpr1[1] > wpr1[0] && wpr1[0] < ZoneSell) && 
               (wpr2[2] >= ZoneSell && wpr2[4] <= wpr2[3] && wpr2[3] <= wpr2[2]  && wpr2[2] > wpr2[1] && wpr2[1] > wpr2[0] && wpr2[0] < ZoneSell) &&
               (wpr3[2] >= ZoneSell && wpr3[4] <= wpr3[3] && wpr3[3] <= wpr3[2]  && wpr3[2] > wpr3[1] && wpr3[1] > wpr3[0] && wpr3[0] < ZoneSell) &&
               (wpr4[2] >= ZoneSell && wpr4[4] <= wpr4[3] && wpr4[3] <= wpr4[2]  && wpr4[2] > wpr4[1] && wpr4[1] > wpr4[0]/* && wpr4[0] < ZoneSell*/));
   if (pattern1) return(2);  // Сигнал на Sell

// Сигнал на Sell - доливка
// Быстрая пробила тяжелую сверху
   pattern2 = ((wpr4[0] > -50 && wpr4[2] <= wpr4[1] && wpr4[0] < wpr4[1]) && 
               (wpr1[1] >= wpr4[0] && wpr1[0] < wpr4[0]));  
   if (pattern2) return(2);  // Сигнал на Sell           
               
// Сигнал на Sell - доливка
   if (WPRpos == 0 && wpr1[0] > ZoneSell) {
      WPRpos = 1; return(0); // Быстрая зашла в зону перепроданности. Нужно подтверждение сигнала.
   }
   else if (WPRpos == 1 && wpr1[0] < ZoneSell) {
      WPRpos = 0;    // Быстрая вышла из зоны. Проверяем сигнал.
   pattern3 = ((wpr4[0] < -70 && wpr4[0] <= wpr4[1]) && (wpr3[0] < -50 && wpr3[0] <= wpr3[1]) && 
               (wpr2[0] < -40 && wpr2[0] < wpr2[1])/* && 
               (wpr1[1] >= ZoneSell && wpr1[0] < ZoneSell && wpr1[0] < wpr1[1])*/);   
      if (pattern3) return(2);  // Сигнал на Sell
   }            
                                  
// Сигнал на Sell - доливка
   pattern4 = ((wpr4[0] < -70 && wpr4[0] < wpr4[1] && wpr4[1] < wpr4[2]) && (wpr3[0] < -50 && wpr3[0] < wpr3[1] && wpr3[1] < wpr3[2]) && 
               (wpr2[0] < -40 && wpr2[0] < wpr2[1] && wpr2[1] < wpr3[2]) && (wpr1[2] >= -30 && wpr1[1] < wpr1[2] && wpr1[0] < wpr1[1]));   
   if (pattern4) return(2); // Сигнал на Sell

   return(res);
}

int GetChokeSignalAndLot(double &lots)
{
   string Symb = Symbol();
   double slb, sls, pb, ps, lotsB, lotsS, lMax, Free;
   int sig = 0;

  double One_Lot = MarketInfo(Symb,MODE_MARGINREQUIRED);
  double Min_Lot = MarketInfo(Symb,MODE_MINLOT);
  double Spread = MarketInfo(Symb, MODE_SPREAD);
  double Step = MarketInfo(Symb,MODE_LOTSTEP);
  
  if (ReservDepo > 0)
    Free = NormalizeDouble(((AccountFreeMargin()/100)*ReservDepo),2);
  else Free = AccountFreeMargin();  
  lMax = Free/One_Lot - Min_Lot;

   GetInfoOrders(arrInfoOrders);
   slb = arrInfoOrders[2];
   sls = arrInfoOrders[3];
   pb = arrInfoOrders[4];
   ps = arrInfoOrders[5];
   if (pb >= 0 && ps >= 0) {
     sig = 0; return(sig);
   }  
   else
     if (pb < ps) sig = 1;
     else sig = 2;
   if (ChokeLotPercent < 1) ChokeLotPercent = 1;
   switch (sig) {
     case 1:
       if (slb == 0) slb = Min_Lot;
       lots = NormalizeDouble(slb*ChokeLotPercent/100, 2);
     break;
     case 2:
       if (sls == 0) sls = Min_Lot;
       lots = NormalizeDouble(sls*ChokeLotPercent/100, 2);
     break;
   }
//   double k = GetMultiplier(ChokeKM, ChokePW, 1, 1);
   lots = lots * ChokeKM;// * k;
   if (lots < Min_Lot) lots = Min_Lot; 
   if (lots > lMax) lots = lMax;
   if (lots > LotMax) lots = LotMax;
   lots = NormalizeDouble(lots, 2);      
   
   return(sig);
}

void ChokeTrailing()
{
   int i, ot;
   double sl, ts = ChokeTrailStop*Point, step = ChokeTrailStep*Point;
   
   if (ChokeTrailStop < 10) return;
   for (i = 0; i < OrdersTotal(); i++) {
      if (!OrderSelect(i, SELECT_BY_POS)) continue;
      if (OrderSymbol() !=Symbol()) continue; 
      if (OrderMagicNumber() != ChokeMagic) continue;
      ot = OrderType();
      switch (ot) {
         case OP_BUY:
            sl = OrderStopLoss();
            if (Bid - OrderOpenPrice() > ts)
               if (sl < Bid - (ts + step)) {
                  sl = NormalizeDouble(Bid - ts, Digits);
                  OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), 0);
               }   
         break;
         case OP_SELL:
            sl = OrderStopLoss();
            if (OrderOpenPrice() - Ask > ts)
               if (sl > Ask + (ts + step) || sl == 0) {
                  sl = NormalizeDouble(Ask + ts, Digits);
                  OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), 0);
               }   
         break;
      }
   }
   return;
}

bool FindChain(int &TicketCurrentOrder)
{
   int i, ot, Ticket, Count;
   
   Count = 0;
   Ticket = -1;
   for (i = 0; i < OrdersTotal(); i++) {
      if (!OrderSelect(i, SELECT_BY_POS)) continue;
      if (OrderSymbol()!= Symbol()) continue;
      if (OrderMagicNumber() != ChokeMagic) continue;
      Count++;
      ot = OrderType();
      if (ot == OP_BUY || ot == OP_SELL)
        Ticket = OrderTicket();
   }
   TicketCurrentOrder = Ticket;
   ChainOrderCount = Count;
   if (ChainOrderCount > 0) return(True);
   else return(False);
}

bool FindChainInit(int &TicketCurrentOrder)
{
   int i, ot, Ticket, Count;
   datetime oot;
   
   Count = 0;
   Ticket = -1;
   OldChainTime = TimeCurrent();
   for (i = 0; i < OrdersTotal(); i++) {
      if (!OrderSelect(i, SELECT_BY_POS)) continue;
      if (OrderSymbol()!= Symbol()) continue;
      if (OrderMagicNumber() != ChokeMagic) continue;
      oot = OrderOpenTime();
      if (oot < OldChainTime) OldChainTime = oot;
      Count++;
      ot = OrderType();
      if (ot == OP_BUY || ot == OP_SELL)
        Ticket = OrderTicket();
   }
   TicketCurrentOrder = Ticket;
   ChainOrderCount = Count;
   if (ChainOrderCount > 0) return(True);
   else return(False);
}

void ChainControl()
{
  double op, pp, dd, chp;
  bool term;
  
//  if (!ChainExists)
  ChainExists = FindChain(ChainOrderTicket);
  chp = GetChainProfit();
  /*if (chp != 0)*/ ChainProfit = chp;
  if (ChainExists) {
    if (ChainOrderTicket > -1) {
      if (OrderSelect(ChainOrderTicket, SELECT_BY_TICKET)) {
        op = OrderProfit();
//        pp = op/OrderLots();
        if (OrderCloseTime() == 0) {    
          ChainProfit += OrderProfit();
//          if (ChokeSL > 0) term = (pp < -(ChokeSL*0.25));
//          else term = (pp < -50);
//          if (term && ChainOrderCount > 1) ChainDelete();
        }  
        else {
          if (op < 0 && ChainOrderCount >= 1) ChainDelete();
        }
      }
    }
    else {
      ChainModify();
      if (TradeBySessions) {
         dd = (AccountBalance()-AccountEquity())*100/AccountBalance();
         if (dd < ChokeDD) ChainDelete();
      }
    }  
  }
  else {
     if (TradeBySessions) {
       dd = (AccountBalance()-AccountEquity())*100/AccountBalance();
       if (dd < ChokeDD) return;
     }  
    chp = GetChainProfit();
    if (chp != 0) ChainProfit = chp;
    Print("Previous Chain Profit = ", ChainProfit);
    ChainExists = SetChainOrders();
  }  
  if (ChainExists) {
    if (ChainTrailing) ChokeTrailing();
    else ChainNoLoss();
  }
  return;
}

void ChainModify()
{
   int i, nb, ns, ot, Ticket;
   int Spread = MarketInfo(Symbol(), MODE_SPREAD);
   double oop, prevoop = 0, NewPrice, sl, tp, ask = Ask, bid = Bid;
   double delta = ChainStep*Point, dp = 5*Point;
   
   for (i = 0; i < OrdersTotal() ; i++) {
      if (!OrderSelect(i, SELECT_BY_POS)) continue;
      if (OrderSymbol()!= Symbol()) continue;
      if (OrderMagicNumber() != ChokeMagic) continue;
      ot = OrderType();
      switch (ot) {
         case OP_BUYSTOP:
            Ticket = OrderTicket();
            oop = OrderOpenPrice();
            nb++;
//            NewPrice = Ask + delta;
            if (oop - ask > delta*nb + dp) {
               NewPrice = NormalizeDouble(ask + delta*nb, Digits);
               if (ChokeTP > 0) tp = NormalizeDouble(NewPrice + ChokeTP*Point, Digits);
               else tp = 0.0;
               if (ChokeSL > 0) sl = NormalizeDouble(NewPrice - (/*Spread + */ChokeSL)*Point, Digits);
               else sl = 0.0;
//            delta += delta;
               if (oop == NewPrice && tp == OrderTakeProfit() && sl == OrderStopLoss())  break;
               if (OrderModify(Ticket, NewPrice, sl, tp, 0)) {
               }
               else {
                  Print("Chain Modify ERROR: ", GetLastError(), ", Order #", Ticket, ", NewPrice: ", NewPrice, ", SL: ", sl, ", TP: ", tp);
                  break;
               }
            }  
         break;
         case OP_SELLSTOP:
            Ticket = OrderTicket();
            oop = OrderOpenPrice();
            ns++;
//            NewPrice = Bid - delta;
            if (bid - oop > delta*ns + dp) {
               NewPrice = NormalizeDouble(bid - delta*ns, Digits);
               if (ChokeTP > 0) tp = NormalizeDouble(NewPrice - ChokeTP*Point, Digits);
               else tp = 0.0;
               if (ChokeSL > 0) sl = NormalizeDouble(NewPrice + (/*Spread + */ChokeSL)*Point, Digits);
               else sl = 0.0;
//         delta += delta;
               if (oop == NewPrice && tp == OrderTakeProfit() && sl == OrderStopLoss()) break;
               if (OrderModify(Ticket, NewPrice, sl, tp, 0)) {
               }
               else {
                  Print("Chain Modify ERROR: ", GetLastError(), ", Order #", Ticket, ", NewPrice: ", NewPrice, ", SL: ", sl, ", TP: ", tp);
                  break;
               }  
            }
         break;
      }
   }
   return;
}
/*
double GetChainOrderProfit(int Ticket)
{
   if (!OrderSelect(Ticket, SELECT_BY_TICKET)) return(0);
   return(OrderProfit());
}
*/
// Выставляем сетку Stop-ордеров
bool SetChainOrders()
{
   int i, tik, err = 0, ChainType = 0, TF = PERIOD_M30;
   double k, price, tp = ChokeTP, sl = ChokeSL;
   string symb = Symbol();
   double pb, ps, lotsB, lotsS, lots, lotMin = MarketInfo(symb, MODE_MINLOT);
   int Spread = MarketInfo(symb, MODE_SPREAD);
   
   switch (WPRTF) {
      case 1: TF = PERIOD_M1; break;
      case 2: TF = PERIOD_M5; break;
      case 3: TF = PERIOD_M15; break;
      case 4: TF = PERIOD_M30; break;
      case 5: TF = PERIOD_H1; break;
      default: TF = PERIOD_M30; break;
   }

     if (TradeBySessions) {
       GetInfoOrders(arrInfoOrders);
       double slb = arrInfoOrders[2];
       double sls = arrInfoOrders[3];
       pb = arrInfoOrders[4];
       ps = arrInfoOrders[5];
       if (pb >= 0 && ps >= 0) {
         ChainType = 0; return(False);
       }  
       else
         if (pb < ps) ChainType = 1;
         else ChainType = 2;
       switch (ChainType) {
       case 1:
         lots = NormalizeDouble(slb*ChokeLotPercent/100, 2);
       break;
       case 2:
         lots = NormalizeDouble(sls*ChokeLotPercent/100, 2);
       break;
       }
       if (lots < lotMin) lots = lotMin;
       if (lots > LotMax) lots = LotMax;
     }
     else {
       double ma1_0 = iMA(symb, TF, 5, 0, MODE_LWMA, PRICE_TYPICAL, 0);
       double ma1_1 = iMA(symb, TF, 5, 0, MODE_LWMA, PRICE_TYPICAL, 1);
       double ma1_2 = iMA(symb, TF, 5, 0, MODE_LWMA, PRICE_TYPICAL, 2);
       double ma2_0 = iMA(symb, TF, 13, 0, MODE_LWMA, PRICE_TYPICAL, 0);
       double ma2_1 = iMA(symb, TF, 13, 0, MODE_LWMA, PRICE_TYPICAL, 1);
       double ma2_2 = iMA(symb, TF, 13, 0, MODE_LWMA, PRICE_TYPICAL, 2);
       if (((ma1_2 >= ma2_2 || ma1_2 < ma2_2) && ma1_1 < ma2_2) && (ma1_2 >= ma1_2 && ma1_2 > ma1_0)) ChainType = 1;
       if (((ma1_2 <= ma2_2 || ma1_2 > ma2_2) && ma1_1 > ma2_2) && (ma1_2 <= ma1_2 && ma1_2 < ma1_0)) ChainType = 2;
       lots = GetChokeLot();
     }  
   if (ChainType > 0) {
     OldChainTime = ChainTime;
     ChainTime = TimeCurrent();  
   }
   for (i = 1; i <= ChainOrders; i++) {
     switch (ChainType) {
     case 1:
       k = GetMultiplier(ChokeKM, ChokePW, i, 2);
       lotsS = NormalizeDouble(lots*k, Digits);
       if (lotsS < lotMin) lotsS = lotMin;
       if (lotsS > LotMax) lotsS = LotMax;
       Print("Выставляем сетку SELL. Chain SellStop #", i);
       price = NormalizeDouble(Bid - ChainStep*i*Point, Digits);
       if (ChokeTP > 0.0) tp = NormalizeDouble(price - ChokeTP*Point, Digits);
       else tp = 0.0;
       if (ChokeSL > 0.0) sl = NormalizeDouble(price + (Spread + ChokeSL)*Point, Digits);
       else sl = 0.0;
       tik = VerifySendOrder(Symbol(), OP_SELLSTOP, lotsS, price, slp, sl, tp,"Chain SELLSTOP #" + i, ChokeMagic, 0, Red);
     break;
     case 2:
       k = GetMultiplier(ChokeKM, ChokePW, i, 2);
       lotsB = NormalizeDouble(lots*k, Digits);
       if (lotsB < lotMin) lotsB = lotMin;
       if (lotsB > LotMax) lotsB = LotMax;
       Print("Выставляем сетку BUY. Chain BuyStop #", i);
       price = NormalizeDouble(Ask + ChainStep*i*Point, Digits);
       if (ChokeTP > 0.0) tp = NormalizeDouble(price + ChokeTP*Point, Digits);
       else tp = 0.0;
       if (ChokeSL > 0.0) sl = NormalizeDouble(price - (Spread + ChokeSL)*Point, Digits);
       else sl = 0.0;
       tik = VerifySendOrder(Symbol(), OP_BUYSTOP, lotsB, price, slp, sl, tp,"Chain BUYSTOP #" + i, ChokeMagic, 0, Blue);
     break; 
     }
     if (err == -1) err++; 
     RefreshRates();
   }
   if (err > 0) { 
     ChainDelete(); 
     return(False); 
   }
   return(True);
}

void ChainDelete()
{
   int i, ot, Ticket;
   
   Print("Удаляем сетку.");
   for (i = 0; i < OrdersTotal(); i++) {
      if (!OrderSelect(i, SELECT_BY_POS)) continue;
      if (OrderSymbol()!= Symbol()) continue;
      if (OrderMagicNumber() != ChokeMagic) continue;
      ot = OrderType();
      if(ot != OP_BUY && ot != OP_SELL) {
         Ticket = OrderTicket();
         if (!OrderDelete(Ticket)) {
            if(GetLastError()==6) { Alert("ChainDelete Error: Нет связи"); break; }
            if(GetLastError()==132) { Alert("ChainDelete Error: Рынок закрыт"); break; }
         }
         else {
            Print("Chain SellStop #", Ticket, " Deleted.");
            i--;
            ChainOrderCount--;
         }
      }
   }
   if (ChainOrderCount <= 0) { 
      ChainOrderCount = 0;
      ChainOrderTicket = -1;
//      ChainTime = 0;
//      ChainExists = False;
   }  
   return;
}

double GetChainProfit()
{
   int i, ot, Ticket;
   double profit = 0;
   datetime ctm;
   
   for (i = 0; i < OrdersTotal()/*HistoryTotal()*/; i++) {
      if (!OrderSelect(i, SELECT_BY_POS/*, MODE_HISTORY*/)) continue;
      if (OrderSymbol()!= Symbol()) continue;
      if (OrderMagicNumber() != ChokeMagic) continue;
      ot = OrderType();
      if(ot == OP_BUY || ot == OP_SELL) {
         Ticket = OrderTicket();
         ctm = OrderCloseTime();
//         if ((TimeCurrent() - ctm)/3600 <= 12)   // Считаем профит сетки за 12 часов
         if (ctm > 0 && ctm >= OldChainTime)
           profit += OrderProfit();
      }
   }
   return(profit);
}

void ChainNoLoss()
{
   int i, ot;
   double sl, noloss = ChainNoLoss*Point, minprof = ChainMinProfit*Point;
   
   if (ChainMinProfit <= ChainNoLoss || ChainMinProfit < 1 || ChainNoLoss < 1) return;
   for (i = 0; i < OrdersTotal(); i++) {
      if (!OrderSelect(i, SELECT_BY_POS)) continue;
      if (OrderSymbol() != Symbol()) continue; 
      if (OrderMagicNumber() != ChokeMagic) continue;
      ot = OrderType();
      switch (ot) {
         case OP_BUY:
            if (Bid -  OrderOpenPrice() >=  minprof) {
               if (OrderOpenPrice() > OrderStopLoss()) {
                  sl = NormalizeDouble(OrderOpenPrice() + noloss, Digits);
                  OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), 0);
               }   
            }   
         break;
         case OP_SELL:
            if (OrderOpenPrice() - Ask >=  minprof) {
               if (OrderOpenPrice() < OrderStopLoss() || OrderStopLoss() == 0) {
                  sl = NormalizeDouble(OrderOpenPrice() - noloss, Digits);
                  OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), 0);
               }   
            }   
         break;
      }
   }

   return;
}



         
int ChokeByTime()
{
   int res = -1, sig = 0;
   double dd, lots, price, sl, tp, ctp = ChokeTP; 
   double LotMax,lotMin,lotsS;
   
   if (TradeBySessions) {
   
     dd = (AccountBalance()-AccountEquity())*100/AccountBalance();
     if (dd < ChokeDD) return(res);
   }  
   sig = GetChokeSignalAndLot(lots);
   if (ChokeReverse) 
      switch(sig) {
         case 1: sig = 2;  break;
         case 2: sig = 1;  break;
      }
   switch(sig) {
      case 1:
          if (TradeBySessions) {
 //           LotMax = MarketInfo(Symbol(), MODE_MAXLOT);
 //           lotMin = MarketInfo(Symbol(), MODE_MINLOT);
            lots = NormalizeDouble(lotsS*ChokeLotPercent/100, 2);
            lots = lots * ChokeKM;
            if (lots < lotMin) lots = lotMin;
            if (lots > LotMax) lots = LotMax;
         }   
         price = NormalizeDouble(Ask, Digits);
         if (ChokeTP > 0) tp = NormalizeDouble(Ask + ctp * Point, Digits);
         else tp = 0.0;
         if (ChokeSL > 0) sl = NormalizeDouble(Bid - ChokeSL * Point, Digits);
         else sl = 0.0;
         Print("Открываем Choke BUY лотом - ", lots);
         res = VerifySendOrder(Symbol(),OP_BUY, lots, price, slp, sl, tp, "Choke Buy", ChokeMagic, 0, Blue);
      break;
      case 2:
       if (TradeBySessions) {
            LotMax = MarketInfo(Symbol(), MODE_MAXLOT);
 //           lotMin = MarketInfo(Symbol(), MODE_MINLOT);
 //           lots = NormalizeDouble(lotsS*ChokeLotPercent/100, 2);
            lots = lots * ChokeKM;
            if (lots < lotMin) lots = lotMin;
            if (lots > LotMax) lots = LotMax;
         }   
         price = NormalizeDouble(Bid, Digits);
         if (ChokeTP > 0) tp = NormalizeDouble(Bid - ctp * Point, Digits);
         else tp = 0.0;
         if (ChokeSL > 0) sl = NormalizeDouble(Ask + ChokeSL * Point, Digits);
         else sl = 0.0;
         Print("Открываем Choke SELL лотом - ", lots);
         res = VerifySendOrder(Symbol(),OP_SELL, lots, price, slp, sl, tp, "Choke Sell", ChokeMagic, 0, Red);
      break;
   }   
   if (res > 0) { ChokeExists = True; ChokeRepet--; }
   return(res);
   
}