//+------------------------------------------------------------------+
//|                                                Fracktal_Grid.mq4 |
//|                                                           AVMOHR |
//+------------------------------------------------------------------+
#property copyright "AVMOHR"
#property link      ""
extern string rem="������ �� ���������� � ��";
extern int Vertikal_shift=3;
extern string rem1=" ��������� ������";
extern int StopLoss=15;
extern int TakeProfit=50;
extern int Trailing=15;
extern bool Use_Spread=true;
extern string rem3="�������� ���������";
extern double Lots=0.2;
extern string rem31="���� ���=0, �� ������� �������� �� ��������";
extern double Percent=10;
extern string rem2="����� ������";
extern int Magik=112233;
extern string rem4="����������� ������� �� �������";
extern int History=5;
extern string rem5="������� ��� ������ � �������";
extern bool Close_Friday=true;
extern string rem6="����� �� ��� �������� � �������";
extern int Time_Stop=23;

double Fraktal_Prise_Up[];
double Fraktal_Prise_Down[];
datetime Time_Open_order=0;
datetime Time_Fraktal=0;
bool Init_refresh=false;
bool Work=true;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
Open_history_orders();
Init_refresh=true;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
 Order_Close_Time();  
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
if (Close_Friday == true)
  if ( DayOfWeek() >= 5 && Hour() >= Time_Stop) { Order_Close_Time(); return(0); }

  if  (Init_refresh == false)  { Open_history_orders(); Init_refresh=true; }
  Find_orders();
  double Open_Prise;
  int Direct_order=0;
  Fraktal_prise_real(Direct_order, Open_Prise);
  if (Direct_order == 1 && Time_Open_order != Time_Fraktal ) { Open_Buy(Open_Prise); Time_Open_order = Time_Fraktal; }
  if (Direct_order == -1 && Time_Open_order != Time_Fraktal ) { Open_Sell(Open_Prise); Time_Open_order = Time_Fraktal; }
//----
   return(0);
  }
//+------------------------------------------------------------------+


//----------------------------------------------------------------------
//  ������� ������� ������� ����
//----------------------------------------------------------------------
double Lot_Refresh() 
  {
   double New_Lot;
   double One_Lot=MarketInfo(Symbol(),MODE_MARGINREQUIRED);   //   ������ ��������� �������, ����������� ��� �������� 1 ���� �� �������
   double Min_Lot=MarketInfo(Symbol(),MODE_MINLOT);
   double Step   =MarketInfo(Symbol(),MODE_LOTSTEP);
   double Free   =AccountFreeMargin();
//-----------------------------------------------------------------
   if (Lots > 0)                                 // ���� ������ ����..
     {
      double Money=Lots*One_Lot;
      if(Money<=AccountFreeMargin())
         New_Lot=Lots;
      else                                     // ���� �� ������� �������
         New_Lot=MathFloor(Free/One_Lot/Step)*Step;
     }
   else                                        // ���� ���� �� ������
     {
      if (Percent > 100) Percent=100;
      if (Percent <=0 ) Percent=0.01;
      if (Percent==0) New_Lot=Min_Lot;
      else
         New_Lot=MathFloor(Free*Percent/100/One_Lot/Step)*Step;
     }

   if (New_Lot < Min_Lot)                     // ���� ������ �����������
      New_Lot=Min_Lot;
   if (New_Lot*One_Lot > AccountFreeMargin()) // �� ������� ����..
     {
      Alert("�� ������� ������� �� �������� ������");
      return(0);
     }
   return(New_Lot);
  }

//----------------------------------------------------------------------
//  ������� ������� ������
//----------------------------------------------------------------------
void Stop_Profit(int Direct, double &SL, double &TP, double Prise_ord)
{ 
  int Min_Stop=MarketInfo(Symbol(), MODE_STOPLEVEL);
   if (SL !=0 && SL < Min_Stop ) SL=Min_Stop;          //  ���� ������� ������ ������ �����������, �� ������ ���������� ����������
   if (TP !=0 && TP < Min_Stop ) TP=Min_Stop;
  double Spread=MarketInfo(Symbol(), MODE_SPREAD);
  if ( Use_Spread == false ) Spread=0;
  if ( Direct >= 1 ) //  ���� ������ �� �������
   { 
     if (SL !=0 )      SL = Prise_ord-(SL-Spread)*Point;      else SL=0;
     if (TP !=0 )      TP = Prise_ord+(TP+Spread)*Point;      else TP=0;
   }
  if ( Direct <= -1 ) //  ���� ������ �� �������
   {
     if (SL !=0)       SL = Prise_ord+(SL-Spread)*Point;      else SL=0;
     if (TP !=0)       TP = Prise_ord-(TP+Spread)*Point;      else TP=0;
   }
 SL= NormalizeDouble(SL,Digits);      // ����������� �������� ������ 
 TP= NormalizeDouble(TP,Digits);      // ����������� �������� ������ 
}


//----------------------------------------------------------------------
//  ������� ������ �������� ��������� �� �������
//----------------------------------------------------------------------
void History_find(double &Up[], double &Down[] )
{
   int i=0;
   int History_bar=0;
   while (i<=History)   //   ����� ��������� �������� ������� ���������
   {
     double F_Up=iFractals(NULL,0,MODE_UPPER,History_bar);
     if (F_Up != 0 ) 
      { 
        ArrayResize(Up, i+1);
        Up[i]=F_Up;
        i++;
      }
    History_bar++; 
   }
    i=0;
    History_bar=0;
   while (i<=History)   //   ����� ��������� �������� ������ ���������
   {
     double F_Down=iFractals(NULL,0,MODE_LOWER,History_bar);
     if (F_Down != 0 ) 
      { 
        ArrayResize(Down, i+1);
        Down[i]=F_Down;
        i++;
      }
    History_bar++; 
   }
}

//----------------------------------------------------------------------
//  ������� ������ �������� ���������� ��������
//----------------------------------------------------------------------
void Fraktal_prise_real(int &Direct, double &Open_Prise)
{
 int i=0;
 int History_bar=0;
  while (i < 1)
   {
     double F_Up=iFractals(NULL,0,MODE_UPPER,History_bar);
     double F_Down=iFractals(NULL,0,MODE_LOWER,History_bar);
     if ( F_Up !=0) 
       {
        Open_Prise = F_Up; 
        Time_Fraktal=Time[History_bar];
        Direct=1;
        i++;
       }
     if ( F_Down != 0 ) 
       {
        Open_Prise = F_Down; 
        Time_Fraktal=Time[History_bar];
        Direct=-1;
        i++;
       }
      History_bar++; 
   }
}

//----------------------------------------------------------------------
//  ������� ������� ���������� ������ �� ������������ ���������
//----------------------------------------------------------------------
void Open_history_orders()
{
 History_find(Fraktal_Prise_Up, Fraktal_Prise_Down);
 double Prise=iClose(NULL,0,0);
 double freez=MarketInfo(NULL,MODE_FREEZELEVEL);
 for (int i = History-1; i >= 0; i--)
  {
   if ( Prise < (Fraktal_Prise_Up[i]-freez*Point))   { Open_Buy(Fraktal_Prise_Up[i]); Time_Open_order=Time[i]; }
   if ( Prise > (Fraktal_Prise_Down[i]+freez*Point)) { Open_Sell(Fraktal_Prise_Down[i]); Time_Open_order=Time[i]; }
  }
   Init_refresh=true;
}

//----------------------------------------------------------------------
//  ������� ������� ���������� ����� ���
//----------------------------------------------------------------------
void Open_Buy(double Prise_order)
{
  double Lt=Lot_Refresh();
  double SL=StopLoss;
  double TP=TakeProfit;
  Prise_order=Prise_order+Vertikal_shift*Point;
  Stop_Profit(1, SL, TP, Prise_order);
  while(true)
  {
   int Ticket=OrderSend(Symbol(),OP_BUYSTOP,Lt,Prise_order,5,SL,TP,"Fraktal_Grid order",Magik);
   if (Ticket !=0) break;
  }
}

//----------------------------------------------------------------------
//  ������� ������� ���������� ����� ����
//----------------------------------------------------------------------
void Open_Sell(double Prise_order)
{
  double Lt=Lot_Refresh();
  double SL=StopLoss;
  double TP=TakeProfit;
  Prise_order=Prise_order-Vertikal_shift*Point;
  Stop_Profit(-1, SL, TP, Prise_order);
  while(true)
  {
   int Ticket=OrderSend(Symbol(),OP_SELLSTOP,Lt,Prise_order,5,SL,TP,"Fraktal_Grid order",Magik);
   if (Ticket !=0) break;
  }
}

//----------------------------------------------------------------------
//  ������� �������������
//----------------------------------------------------------------------
void Trayling(int tik)             
{
      if ( OrderSelect(tik, SELECT_BY_TICKET) == false ) return;
      if( OrderType()==OP_BUY && OrderMagicNumber()==Magik )  
        {
            if(Trailing>0)  
              {                 
               if(Bid-OrderOpenPrice()>Point*Trailing)
                 {
                  if(OrderStopLoss()<Bid-Point*Trailing)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Trailing*Point,OrderTakeProfit(),0,Green);
                     return(0);
                    }
                 }
              }
         }
        if( OrderType()==OP_SELL && OrderMagicNumber()==Magik )  
           {
            if(Trailing>0)  
              {                 
               if((OrderOpenPrice()-Ask)>(Point*Trailing))
                 {
                  if((OrderStopLoss()>(Ask+Point*Trailing)) || (OrderStopLoss()==0))
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*Trailing,OrderTakeProfit(),0,Red);
                     return(0);
                    }
                 }
              }
           }
return;
}

//----------------------------------------------------------------------
//  ������� �������� ������� � ���� ��������
//----------------------------------------------------------------------
void Find_orders()
{
   for(int i=0; i<=OrdersTotal(); i++)          // ���� �������� �����
  {
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true) // ���� ���� ���������
        {                                       // ������ �������:
          if (OrderSymbol()!=Symbol())continue;      // �� ��� ���. �������
          if (OrderMagicNumber()!=Magik)continue;  
          int Ticket=OrderTicket();
        }
      Trayling(Ticket);
    }
}

//----------------------------------------------------------------------
//  ������� �������� ������� � �������
//----------------------------------------------------------------------
void Order_Close_Time()
{
  for(int i=0; i<=OrdersTotal(); i++)          // ���� �������� �����
  {
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true) // ���� ���� ���������
        {                                       // ������ �������:
          if (OrderSymbol()!=Symbol())continue;      // �� ��� ���. �������
          if (OrderMagicNumber()!=Magik)continue;  
          int Ticket=OrderTicket();
          double Lot_Close=OrderLots();
          double Open_Prise=OrderOpenPrice();
          if (OrderType() > 1 ) 
          {
          OrderDelete(Ticket);
          Print("������� ������� ����� ",Ticket,"   ",GetLastError());
          }
        }
    }
Init_refresh=false;
Work = false;
}