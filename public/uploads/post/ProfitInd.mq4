//+----------------------------------------------------------------------+
//|                                                        ProfitInd.mq4 |
//|                                       Copyright � 2010, Mike Zhitnev |
//|                                               http://Forex-Robots.ru |
//| ******************************************************************** |
//| ������ ��������� ���������� �� ������� ���������� �������            |
//| �� ������ �������� ����. ��������� �������� �� �������� �� M1 �� H4. |
//| ******************************************************************** |
//| ������������ ��� ��� �������� � ���������� �� �����.                 |
//| ����������� �� ����� http://Forex-Robots.ru                          |
//| E-mail: admin@Forex-Robots.ru                                        |
//+----------------------------------------------------------------------+
#property copyright "Copyright � 2010, Mike Zhitnev"
#property link      "http://Forex-Robots.ru"

#property indicator_chart_window

extern color ProfitColor = Aqua;        // ���� ���������� ���������� ������
extern color LossColor = Red;           // ���� ���������� ��������� ������
extern color ZeroColor = White;         // ���� ���������� ������� ������
extern bool  EveryTickRefresh = false;  // ��������� �� ���������� �� ������� �������
                                        // ������ ���, ��� ������ �� ��������� � ������� ����� �������
                                        // (�� ��������� ������ ��� ��������� ����� �������) 
                                        
int LastTicket;  // ����� ���������� ������ � �������
int Delta = 20;  // ������� � ������ ����� ������������ ������ � ������������ ����� ��� (High-��������)

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {   
    LastTicket = -1;
    return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   for (int i=0; i<ObjectsTotal(); i++)    // ������ ��� ����� ��� ��������������� ��������
   {
     string name = "lbProfit" +  DoubleToStr( i, 0) ;
     if (ObjectFind(name)>=0) ObjectDelete(name);      
   }   
   return(0);
  }
  
//+------------------------------------------------------------------+
//| ��������� �������� ������� � ����������� �� �������� ����������� |
//+------------------------------------------------------------------+
int SetValueX10(int Value)
  {
    if (Point==0.00001)                      // �������� �������� ��� ������������ � (5) �������
      Value = MathRound(Value * 0.0001 / Point);   
    if (Point==0.001)                        // �������� �������� ��� ������������ � (3) �������
      Value = MathRound(Value * 0.01 / Point);            
    return (MathRound(Value));  
  }  

//+------------------------------------------------------------------+
//| ������� ����� ��� ��� day �� ��������� ������� Profit            |
//+------------------------------------------------------------------+
int SetLabel(int day, double Profit)
  {
    int Win=0; // �������                                                         
    string name = "lbProfit" +  DoubleToStr( day, 0) ;
    string TEXT = DoubleToStr( Profit, 2) + " " + AccountCurrency();
    int Error=ObjectFind(name);
    if (Error==-1) ObjectCreate(name, OBJ_TEXT, Win, 0,0);  // ���� �����-������ �� �������, �� �������� ����� �����
    datetime TIME;                                          
    if (day>0)                                                 
      TIME = iTime(Symbol(),PERIOD_D1,day) + 12*PERIOD_H1*60;  
    else
      TIME = TimeCurrent();           
    ObjectSet(name, OBJPROP_TIME1, TIME);      
    ObjectSet(name, OBJPROP_PRICE1, iHigh(Symbol(),PERIOD_D1,day) + SetValueX10(Delta)*Point);      
         
    // ��������� ���� �����
    int color_;                
    if (Profit>0)  color_=ProfitColor; 
    if (Profit<0)  color_=LossColor;
    if (Profit==0) color_=ZeroColor;        
    int FSize = 12;  // ������ ������ �� ���������
    switch(Period()) // ����������� ������ ������ � ����������� �� ����������
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
   
   if (OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY))  // ��������� ��������� ����� � �������, ����� �� ������
   {                                                                    // ������ ���� ������� ������� � �������� ������ ����
     int Ticket = OrderTicket();
     if (EveryTickRefresh==false && Ticket==LastTicket) return(0);  // ���� ��� ����� ������� � �������, �� �������
     LastTicket = Ticket;
   }
   
   int day = 0;        // ���� 
   double Profit = 0;  // ������ �� ���� day
         
   for (int i=OrdersHistoryTotal()-1; i>=0; i--)
    if (OrderSelect(i,SELECT_BY_POS,MODE_HISTORY) && OrderType()<=1)
    {                       
       double OProf = OrderProfit() + OrderSwap() + OrderCommission(); // �������� ������ ������
                     
       if (OrderCloseTime()>iTime(Symbol(),PERIOD_D1,day))   // ���� ����� �������� ������ � �������� ��� Day,
       {
         Profit = Profit + OProf;                            // �� ��������� ������ ������� ��� Day         
       }  
       else                                                  // � ��������� ������:        
       {         
         SetLabel(day, Profit);  // ����� �������� ���������� ������ ��� �������� ��� Day, ��������� �����
         Profit = OProf;         // �������� ������ ���        
         while (iTime(Symbol(),PERIOD_D1,day)>OrderCloseTime()) 
         {
           day++;                  // ������� ������� ���� ��� ��������� ��������� �����
           SetLabel(day, 0);       // ������� "0 USD" � ������������� ���, ����� �� ���� ��������
         }  
       }              
     }            
   return(0);
  }
//+------------------------------------------------------------------+