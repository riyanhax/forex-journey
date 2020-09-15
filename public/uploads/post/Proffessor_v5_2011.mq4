//+------------------------------------------------------------------+
//|                                           Proffessor_v5_2011.mq4 |
//|                      Copyright � 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+

#property copyright "Copyright � 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#include <WinUser32.mqh>
extern bool manual =false;   //���� ������, �� ������ ����� �������
extern double lot=0.01;
extern int znak=5;            //���� 5, �� ������������ ��������
extern int MAX_Lines       = 5;     //������������ ����������� ���������� ������� ������� �����������  
extern double klot           = 1;      //����������� ��������� ����� ��� �������� �� ����  
extern double pluslot      =0.01;      //����������� ������� ���� ��� �������� �� ����
extern int plusDelta     =0;        //����������� ���������� ���������� ����� ����������� ��������
                                    //���� �������� �������������, �� ���������� ����������� �� ������ ���-�� �������
extern int variant  =2; //������� ��� ������� ������
                        //0 - �������� ����� � ������������ ����
                        //1 - �������� ����� � ������������� ����
                        //2 - ������������ �� ���������� ADX
extern double Delta1       =800;     //������ ������ �� ���� ��� ��������� ������
extern int Delta           = 600;        //���������� ����� ����������� ��������  
extern int tral               =8;//�������� ���� � ������� ��� ������� ������
extern int step               =2;//��� ��������� � �������
extern int Profit             =80;//������ � ������� ��� ����� �������
extern double f            =40;  //�������� ������� ����� �� ADX
extern double bar        = 2;   //����� �� ����� ADX
extern double timeframe  = 1;  //��������� ��� ���������� ADX 0-�������,1-1������, 2-5�����, 3-15�����, 4-30�����, 5-1���
                             //6-4����, 7-����, 8-������, 9-�����
extern int magic           = 12345; 
extern int StartHour=0;       //��� ������ ������ ���������
extern int EndHour=24;     //��� ��������� ������ ���������
extern int pop=3;//���������� ������� ������� �����
bool ticket, closed;
double Lots;
int x,q,i,own,trals;
bool trade=false;
double iflet,ibuy,isell;
int _timeframe;
int init() {
      Comment("ProfessorSoft_v3_real_2011");
      return (0);
  
}

int deinit() {
      Comment("");
      return (0);
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----

if(timeframe==1)_timeframe=1;
else if(timeframe==0)_timeframe=0;
else if(timeframe==2)_timeframe=5;
else if(timeframe==3)_timeframe=15;
else if(timeframe==4)_timeframe=30;
else if(timeframe==5)_timeframe=60;
else if(timeframe==6)_timeframe=240;
else if(timeframe==7)_timeframe=1440;
else if(timeframe==8)_timeframe=10080;
else _timeframe=43200;

if(OrdersTotal()==0 && time()==true)
{
if(manual==true)
{
bool flet,buy;
   int a=MessageBox("������� �� ��� �������� ����� ��� ��� ��� ��������","����� ���������",MB_YESNOCANCEL);
if(a==IDYES) flet=true;
if(a==IDNO) flet=false;
if(a==IDCANCEL) return(0);
 int b=MessageBox("������� �� ����� ������ ��� ��� ����� �������","����� ���������",MB_YESNOCANCEL);
if(b==IDYES) buy=true;
if(b==IDNO) buy=false;
if(b==IDCANCEL) return(0);
   if(flet==true && buy==true)//������� ��� ������� � ����������� �����
      {
               Lots=lot;
               ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,0,"",magic,0,Blue);
                if(ticket==-1)return(0);
               if(variant==2)OrderSend(Symbol(),OP_BUYLIMIT,Lots,Ask-Delta1*Point,3,0,0,"",magic,0,Blue);
               else if (variant==1) OrderSend(Symbol(),OP_SELLSTOP,NormalizeDouble(Lots*klot,2)+pluslot,Bid-Delta1*Point,3,0,0,"",magic,0,Red);
               else  OrderSend(Symbol(),OP_SELLSTOP,Lots,Bid-Delta1*Point,3,0,0,"",magic,0,Red);
                for(x=1;x<=MAX_Lines;x++)
               {
                Lots=NormalizeDouble(Lots*klot,2)+pluslot;
                  OrderSend(Symbol(),OP_BUYLIMIT,Lots,Ask-(Delta1+x*NormalizeDouble(Delta+plusDelta*x/2,0))*Point,3,0,0,"",magic,0,Blue);
                  OrderSend(Symbol(),OP_SELLLIMIT,Lots,Bid+x*NormalizeDouble(Delta+plusDelta*x/2,0)*Point,3,0,0,"",magic,0,Red);     
               }
      
      
      }
      else if(flet==true && buy==false)//������� ��� ������� � ����������� �����
      {
                  Lots=lot;
                  ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,0,"",magic,0,Red); 
                   if(ticket==-1)return(0);
                   if(variant==2) OrderSend(Symbol(),OP_SELLLIMIT,Lots,Bid+Delta1*Point,3,0,0,"",magic,0,Red);
                   else if (variant==1) OrderSend(Symbol(),OP_BUYSTOP,NormalizeDouble(Lots*klot,2)+pluslot,Ask+Delta1*Point,3,0,0,"",magic,0,Blue);
                  else  OrderSend(Symbol(),OP_BUYSTOP,Lots,Ask+Delta1*Point,3,0,0,"",magic,0,Blue);
                 
                    for(x=1;x<=MAX_Lines;x++)
                  {
                     Lots=NormalizeDouble(Lots*klot,2)+pluslot;
                     OrderSend(Symbol(),OP_BUYLIMIT,Lots,Ask-x*NormalizeDouble(Delta+plusDelta*x/2,0)*Point,3,0,0,"",magic,0,Blue);
                     OrderSend(Symbol(),OP_SELLLIMIT,Lots,Bid+(Delta1+x*NormalizeDouble(Delta+plusDelta*x/2,0))*Point,3,0,0,"",magic,0,Red);     
                  }
      }
       else if(flet==false && buy==true)//������� ��� ������� � ����������� ������
      {
                   Lots=lot;
                   ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,0,"",magic,0,Blue);
                    if(ticket==-1)return(0);
                     if(variant==2)  OrderSend(Symbol(),OP_SELLSTOP,Lots,Bid-Delta1*Point,3,0,0,"",magic,0,Red);
                   else if (variant==1) OrderSend(Symbol(),OP_SELLSTOP,NormalizeDouble(Lots*klot,2)+pluslot,Bid-Delta1*Point,3,0,0,"",magic,0,Red);
                  else  OrderSend(Symbol(),OP_SELLSTOP,Lots,Bid-Delta1*Point,3,0,0,"",magic,0,Red);
                  
       
                    for(x=1;x<=MAX_Lines;x++)
                   {
                    Lots=NormalizeDouble(Lots*klot,2)+pluslot;
                      OrderSend(Symbol(),OP_SELLSTOP,Lots,Bid-(Delta1+x*NormalizeDouble(Delta+plusDelta*x/2,0))*Point,3,0,0,"",magic,0,Blue);
                      OrderSend(Symbol(),OP_BUYSTOP,Lots,Ask+x*NormalizeDouble(Delta+plusDelta*x/2,0)*Point,3,0,0,"",magic,0,Red);     
                   }
      }
       else if(flet==false && buy==false)//������� ��� ������� � ����������� ������
      {
                  Lots=lot;
                  ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,0,"",magic,0,Red); 
                   if(ticket==-1)return(0);
                    if(variant==2)  OrderSend(Symbol(),OP_BUYSTOP,Lots,Ask+Delta1*Point,3,0,0,"",magic,0,Blue);
                   else if (variant==1)OrderSend(Symbol(),OP_BUYSTOP,NormalizeDouble(Lots*klot,2)+pluslot,Ask+Delta1*Point,3,0,0,"",magic,0,Blue);
                  else OrderSend(Symbol(),OP_BUYSTOP,Lots,Ask+Delta1*Point,3,0,0,"",magic,0,Blue);
                 
                    for(x=1;x<=MAX_Lines;x++)
                  {
                     Lots=NormalizeDouble(Lots*klot,2)+pluslot;
                     OrderSend(Symbol(),OP_SELLSTOP,Lots,Bid-x*NormalizeDouble(Delta+plusDelta*x/2,0)*Point,3,0,0,"",magic,0,Blue);
                     OrderSend(Symbol(),OP_BUYSTOP,Lots,Ask+(Delta1+x*NormalizeDouble(Delta+plusDelta*x/2,0))*Point,3,0,0,"",magic,0,Red);     
                  }
      }
      else return(0);
      }



   else
   {
   ticket=-1;
    iflet=iADX( Symbol(), _timeframe, 14, PRICE_CLOSE,MODE_MAIN, bar); 
    ibuy=iADX( Symbol(), _timeframe, 14, PRICE_CLOSE,MODE_PLUSDI, bar); 
    isell=iADX(  Symbol(), _timeframe, 14, PRICE_CLOSE,MODE_MINUSDI, bar); 
      
      if(iflet<f && ibuy>isell)//������� ��� ������� � ����������� �����
      {
               Lots=lot;
               ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,0,"",magic,0,Blue);
                if(ticket==-1)return(0);
               if(variant==2)OrderSend(Symbol(),OP_BUYLIMIT,Lots,Ask-Delta1*Point,3,0,0,"",magic,0,Blue);
               else if (variant==1) OrderSend(Symbol(),OP_SELLSTOP,NormalizeDouble(Lots*klot,2)+pluslot,Bid-Delta1*Point,3,0,0,"",magic,0,Red);
               else  OrderSend(Symbol(),OP_SELLSTOP,Lots,Bid-Delta1*Point,3,0,0,"",magic,0,Red);
       
                for(x=1;x<=MAX_Lines;x++)
               {
                Lots=NormalizeDouble(Lots*klot,2)+pluslot;
                  OrderSend(Symbol(),OP_BUYLIMIT,Lots,Ask-(Delta1+x*NormalizeDouble(Delta+plusDelta*x/2,0))*Point,3,0,0,"",magic,0,Blue);
                  OrderSend(Symbol(),OP_SELLLIMIT,Lots,Bid+x*NormalizeDouble(Delta+plusDelta*x/2,0)*Point,3,0,0,"",magic,0,Red);     
               }
      
      
      }
      else if(iflet<f && ibuy<isell)//������� ��� ������� � ����������� �����
      {
                  Lots=lot;
                  ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,0,"",magic,0,Red); 
                   if(ticket==-1)return(0);
                 if(variant==2) OrderSend(Symbol(),OP_SELLLIMIT,Lots,Bid+Delta1*Point,3,0,0,"",magic,0,Red);
                   else if (variant==1) OrderSend(Symbol(),OP_BUYSTOP,NormalizeDouble(Lots*klot,2)+pluslot,Ask+Delta1*Point,3,0,0,"",magic,0,Blue);
                  else  OrderSend(Symbol(),OP_BUYSTOP,Lots,Ask+Delta1*Point,3,0,0,"",magic,0,Blue);
                    for(x=1;x<=MAX_Lines;x++)
                  {
                     Lots=NormalizeDouble(Lots*klot,2)+pluslot;
                     OrderSend(Symbol(),OP_BUYLIMIT,Lots,Ask-x*NormalizeDouble(Delta+plusDelta*x/2,0)*Point,3,0,0,"",magic,0,Blue);
                     OrderSend(Symbol(),OP_SELLLIMIT,Lots,Bid+(Delta1+x*NormalizeDouble(Delta+plusDelta*x/2,0))*Point,3,0,0,"",magic,0,Red);     
                  }
      }
       else if(iflet>f && ibuy>isell)//������� ��� ������� � ����������� ������
      {
                   Lots=lot;
                   ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,0,"",magic,0,Blue);
                    if(ticket==-1)return(0);
                  if(variant==2)  OrderSend(Symbol(),OP_SELLSTOP,Lots,Bid-Delta1*Point,3,0,0,"",magic,0,Red);
                   else if (variant==1) OrderSend(Symbol(),OP_SELLSTOP,NormalizeDouble(Lots*klot,2)+pluslot,Bid-Delta1*Point,3,0,0,"",magic,0,Red);
                  else  OrderSend(Symbol(),OP_SELLSTOP,Lots,Bid-Delta1*Point,3,0,0,"",magic,0,Red);
       
                    for(x=1;x<=MAX_Lines;x++)
                   {
                    Lots=NormalizeDouble(Lots*klot,2)+pluslot;
                      OrderSend(Symbol(),OP_SELLSTOP,Lots,Bid-(Delta1+x*NormalizeDouble(Delta+plusDelta*x/2,0))*Point,3,0,0,"",magic,0,Blue);
                      OrderSend(Symbol(),OP_BUYSTOP,Lots,Ask+x*NormalizeDouble(Delta+plusDelta*x/2,0)*Point,3,0,0,"",magic,0,Red);     
                   }
      }
       else if(iflet>f && ibuy<isell)//������� ��� ������� � ����������� ������
      {
                  Lots=lot;
                  ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,0,"",magic,0,Red); 
                   if(ticket==-1)return(0);
                  if(variant==2)  OrderSend(Symbol(),OP_BUYSTOP,Lots,Ask+Delta1*Point,3,0,0,"",magic,0,Blue);
                   else if (variant==1)OrderSend(Symbol(),OP_BUYSTOP,NormalizeDouble(Lots*klot,2)+pluslot,Ask+Delta1*Point,3,0,0,"",magic,0,Blue);
                  else OrderSend(Symbol(),OP_BUYSTOP,Lots,Ask+Delta1*Point,3,0,0,"",magic,0,Blue);
                    for(x=1;x<=MAX_Lines;x++)
                  {
                     Lots=NormalizeDouble(Lots*klot,2)+pluslot;
                     OrderSend(Symbol(),OP_SELLSTOP,Lots,Bid-x*NormalizeDouble(Delta+plusDelta*x/2,0)*Point,3,0,0,"",magic,0,Blue);
                     OrderSend(Symbol(),OP_BUYSTOP,Lots,Ask+(Delta1+x*NormalizeDouble(Delta+plusDelta*x/2,0))*Point,3,0,0,"",magic,0,Red);     
                  }
      }
      else return(0);
     
   }
  }
  
      
      if(OrdersTotal()>0)
    {
     Comment("          Balance  ",AccountBalance(),"\n          Equity  ",AccountEquity(),"\n          Profit  ",OrdersProfit());
      own=0;
         for (i=OrdersTotal()-1;i>=0;i--)
         {
            OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
            if(OrderType()<2)own=own+1;
         }
         if (own==0)
         {
           for (i=OrdersTotal()-1;i>=0;i--)
           {          
                     for(q=0;q<pop;q++)
                     {
                     closed=false;
                     closed=OrderDelete(OrderTicket());
                     if(closed==true)q=pop;
                     }
           }  
         }
        if(own>1)
        {
          
          int k=0,u=0;
          int pipsZero=0;
          double pipsPrice=0;
           for (i=OrdersTotal()-1;i>=0;i--)
         {
            OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
            if(OrderStopLoss()!=0 || OrderTakeProfit()!=0)u=u+1;
         }
         if(u==own)return(0);
          for (i=OrdersTotal()-1;i>=0;i--)
         {
            OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
            if(OrderType()==OP_BUY) k=k+OrderLots()/lot;
            if(OrderType()==OP_SELL)k=k-OrderLots()/lot;
         }
 //        Print("����������� ����� ",k);
        pipsPrice=k*lot/0.1;
 //       Print("���� ������ ",pipsPrice);
        if(znak==5)pipsZero=10*(-NormalizeDouble(OrdersProfit()/pipsPrice,0));
        else pipsZero=(-NormalizeDouble(OrdersProfit()/pipsPrice,0)); 
  //      Print("������� �� ����", pipsZero);
        if(pipsPrice>0)
        {
         for (i=OrdersTotal()-1;i>=0;i--)
         {
            OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
            if(OrderType()==OP_BUY)  OrderModify(OrderTicket(), OrderOpenPrice(), 0,Bid+pipsZero*Point+Profit*Point, 0, Blue);
           // Print ("TP ��� ������ ",OrderTicket()," ����� ",Bid+pipsZero*Point);
            if(OrderType()==OP_SELL) OrderModify(OrderTicket(), OrderOpenPrice(), Ask+pipsZero*Point+Profit*Point,0, 0, Red);
           // Print ("SL ��� ������ ",OrderTicket()," ����� ",Ask+pipsZero*Point);  
         }
        }
        if(pipsPrice<0)
        {
         for (i=OrdersTotal()-1;i>=0;i--)
         {
            OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
            if(OrderType()==OP_BUY)  OrderModify(OrderTicket(), OrderOpenPrice(), Bid+pipsZero*Point-Profit*Point,0, 0, Blue); 
           // Print ("SL ��� ������ buy",OrderTicket()," ����� ",Bid-pipsZero*Point);  
            if(OrderType()==OP_SELL) OrderModify(OrderTicket(), OrderOpenPrice(), 0,Ask+pipsZero*Point-Profit*Point, 0, Red);  
            // Print ("TP ��� ������ sell ",OrderTicket()," ����� ",Ask-pipsZero*Point);
         }
        }
        } 
         
         
       
      if(OrdersProfit()>=tral*lot*10)
      {
         
         if(own==1)
         {
                  for (i=OrdersTotal()-1;i>=0;i--)
                  {
                     OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
                     if(OrderType()<2 && OrderProfit()>=tral*OrderLots()*10)TrailPositions();   
                  }
         }
        
            
            Sleep(1000);
            if(OrderType()>1 ) 
             for(q=0;q<pop;q++)
                  {
                  closed=false;
                  closed=OrderDelete(OrderTicket());
                  if(closed==true)q=pop;
                  }          
      }
    }
   
   
//----
   return(0);
  }
  
//+------------------------------------------------------------------+

   bool time()
 {
   if (StartHour<EndHour) 
      {if (Hour()>=StartHour && Hour()<EndHour) return(true); else return(false);}
   if (StartHour>EndHour) 
      {if (Hour()>=EndHour && Hour()<StartHour) return(false); else return(true);}
 }
 
double OrdersProfit()
{
   
  double rezultSymb=0;
  string SMB=Symbol();
  int i;
  for (i=OrdersTotal()-1;i>=0;i--)
   {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
     {
      if(OrderSymbol()!= SMB) continue;
      if(OrderType()==OP_BUY || OrderType()==OP_SELL)
       {
        rezultSymb+=OrderProfit();
       } 
     }
   }
  return(rezultSymb);


}

 void TrailPositions() // ������� �������� ����
{
  int Orders = OrdersTotal();
  for (int i=0; i<Orders; i++) {
    if (!(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))) continue;
    if (OrderSymbol() != Symbol()) continue;
        
     if (OrderType() == OP_BUY )  {
      if (Bid-OrderOpenPrice() > tral*Point) {
        if (OrderStopLoss() < Bid-(tral+step-1)*Point) {
          OrderModify(OrderTicket(), OrderOpenPrice(), Bid-tral*Point,
                                                     OrderTakeProfit(), 0, Blue);
        }      }    }
    if (OrderType() == OP_SELL)  {
      if (OrderOpenPrice()-Ask >tral*Point) {
        if (OrderStopLoss() > Ask+(tral+step-1)*Point 
                                                       || OrderStopLoss() == 0) {
          OrderModify(OrderTicket(), OrderOpenPrice(), Ask+tral*Point,
                                                      OrderTakeProfit(), 0, Blue);
          }   }    }   }  }
          

