//+----------------------------------------------------------------------+
//|                                                        ProfitInd.mq4 |
//|                                       Copyright © 2010, Mike Zhitnev |
//|                                               http://Forex-Robots.ru |
//| ******************************************************************** |
//| Данный индикатор отображает на графике полученную прибыль            |
//| за каждый торговый день. Корректно работает на периодах от M1 до H4. |
//| ******************************************************************** |
//| Разрабатываю для Вас эксперты и индикаторы на заказ.                 |
//| Подробности на сайте http://Forex-Robots.ru                          |
//| E-mail: admin@Forex-Robots.ru                                        |
//+----------------------------------------------------------------------+
#property copyright "Copyright © 2010, Mike Zhitnev"
#property link      "http://Forex-Robots.ru"

#property indicator_chart_window

extern color ProfitColor = Aqua;        // цвет результата прибыльной сделки
extern color LossColor = Red;           // цвет результата убыточной сделки
extern color ZeroColor = White;         // цвет результата нулевой сделки
extern bool  AllSymbols = true;         // Если TRUE - то выводятся сделки по всем инструментам, FALSE - по текущему инструменту                                
                                        
int HTickets;    // Всего ордеров в истории
int Delta = 20;  // Разница в высоте между отображаемой меткой и максимальной ценой дня (High-значение)
datetime LastTime;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {   
    ClearAllObjects(); // удалим возможные оставшиеся объекты
    LastTime = 0;
    HTickets=0;
    return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
    ClearAllObjects();
    return(0);
  }

//+------------------------------------------------------------------+
//| удаляет все объекты Индикатора с графика                         |
//+------------------------------------------------------------------+
void ClearAllObjects()
  {
   for (int i=0; i<ObjectsTotal(); i++)    // удалим все метки при деинициализации эксперта
   {
     string name = "lbProfit" +  DoubleToStr( i, 0) ;
     if (ObjectFind(name)>=0) ObjectDelete(name);      
   }     
  }

  
//+------------------------------------------------------------------+
//| множитель значения пунктов в зависимости от точности инструмента |
//+------------------------------------------------------------------+
int SetValueX10(int Value)
  {
    if (Point==0.00001)                      // Вычислим значение для инструментов с (5) знаками
      Value = MathRound(Value * 0.0001 / Point);   
    if (Point==0.001)                        // Вычислим значение для инструментов с (3) знаками
      Value = MathRound(Value * 0.01 / Point);            
    return (MathRound(Value));  
  }  

//+------------------------------------------------------------------+
//| Выводит метку для дня day со значением профита Profit            |
//+------------------------------------------------------------------+
int SetLabel(int day, double Profit)
  {
    int Win=0; // текущее                                                         
    string name = "lbProfit" +  DoubleToStr( day, 0) ;
    if (AllSymbols) // если выбраны все символы, то выводим тип валюты
      string EXT = AccountCurrency(); 
    else            // иначе выводим тип валютной пары
      EXT = Symbol();  
    string TEXT = DoubleToStr( Profit, 2) + " " + EXT;
    int Error=ObjectFind(name);
    if (Error==-1) ObjectCreate(name, OBJ_TEXT, Win, 0,0);  // Если метка-объект не найдена, то создадим новую метку
    datetime TIME;                                          
    if (day>0)                                                 
      TIME = iTime(Symbol(),PERIOD_D1,day) + 12*PERIOD_H1*60;  
    else
      TIME = TimeCurrent();           
    ObjectSet(name, OBJPROP_TIME1, TIME);      
    ObjectSet(name, OBJPROP_PRICE1, iHigh(Symbol(),PERIOD_D1,day) + SetValueX10(Delta)*Point);      
         
    // установим цвет метки
    int color_;                
    if (Profit>0)  color_=ProfitColor; 
    if (Profit<0)  color_=LossColor;
    if (Profit==0) color_=ZeroColor;        
    int FSize = 12;  // размер шрифта по умолчанию
    switch(Period()) // переключаем размер шрифта в зависимости от таймфрейма
    {
      case PERIOD_M1: 
        FSize = 20; break;
      case PERIOD_M5: 
        FSize = 18; break;
      case PERIOD_M15: 
        FSize = 12; break;
      case PERIOD_M30: 
        FSize = 12; break;
      case PERIOD_H1: 
        FSize = 10; break;
      default: 
        FSize = 10; break;
     }       
     ObjectSetText(name,TEXT,FSize,"Arial",color_);     
  }  
  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {      
 
   // проверяем кол-во ордеров в истории, чтобы не читать данные всех ордеров истории с приходом нового тика
   // однако, пересчитываем все ордера после прихода каждой новой минутки
   if (HTickets==OrdersHistoryTotal() && LastTime==iTime(Symbol(),PERIOD_M1,0)) return(0);
   HTickets = OrdersHistoryTotal();
   LastTime = iTime(Symbol(),PERIOD_M1,0);
   
   int day = 0;        // день 
   double Profit = 0;  // профит за день day
         
   for (int i=OrdersHistoryTotal()-1; i>=0; i--)
    if (OrderSelect(i,SELECT_BY_POS,MODE_HISTORY) && OrderType()<=1 && (AllSymbols==false || (AllSymbols==true && OrderSymbol()==Symbol() )))
    {                       
       double OProf = OrderProfit() + OrderSwap() + OrderCommission(); // Вычислим профит ордера
                     
       if (OrderCloseTime()>iTime(Symbol(),PERIOD_D1,day))   // Если время закрытия ордера в пределах дня Day,
       {
         Profit = Profit + OProf;                            // то суммируем профит ордеров дня Day         
       }  
       else                                                  // В противном случае:        
       {         
         SetLabel(day, Profit);  // Время закрытия очередного ордера вне границах дня Day, установим метку
         Profit = OProf;         // Запомним профит дня        
         while (iTime(Symbol(),PERIOD_D1,day)>OrderCloseTime()) 
         {
           day++;                  // Смещаем счетчик дней для установки следующей метки
           SetLabel(day, 0);       // Выводим "0 USD" в промежуточные дни, когда не было торговли
         }  
       }              
     }            
   return(0);
  }
//+------------------------------------------------------------------+