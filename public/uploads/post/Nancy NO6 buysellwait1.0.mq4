

#property copyright "Copyright@laydy81淘宝外汇EA研发第一店"
#property link      "http://shop57605532.taobao.com"

//=========================版本信息修改记录====================================
/*
1.首版日期：        版本V2012
2.修订1日期：       版本：

*/

extern double lot=0.1;
extern int TP=20;
extern int SL=35;
extern int shift=1;
extern bool Email=true;
extern int SL_add_pips=100;
extern int changeLiner = 1;
extern int Gup=4;


int slippage=3;
string com="";
int j=1;
int t=1;
int magic=2012;
int Oticket=-1;
int Sb=2;
int Ss=2;

int init()
{
   if (Digits == 5 || Digits == 3) j = 10;
   ObjectCreate("logo1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("logo1"," EA智能交易系统", 16, "宋体",White);
   ObjectSet("logo1", OBJPROP_XDISTANCE, 300);
   ObjectSet("logo1", OBJPROP_YDISTANCE, 20);
  return(0);
}


int deinit()
{
  ObjectDelete("logo1");
  return(0);
}


int start()
{
  if (Digits == 5 || Digits == 3) j = 10;
  
   double up = iCustom(NULL,0,"buysellwait",Email,SL_add_pips,changeLiner,Gup,2,shift);
   double dw = iCustom(NULL,0,"buysellwait",Email,SL_add_pips,changeLiner,Gup,3,shift);
   if((up>0 && up<3000)||(up>0 && up!=EMPTY_VALUE)){Sb=0;}
    else Sb=2;
   if((dw>0 && dw<3000)||(dw>0&&dw!=EMPTY_VALUE)){Ss=1;}   
    else Ss=2;

  

  if(Sb==0){OpenOrder(0);}
  if(Ss==1){OpenOrder(1);}
  
  MoveStopLossN();

  return(0);
}


int OpenOrder(int a)
{
  if(a==0&&CheckOrders(0) ==0&&t!=Time[0])
   {  
     Oticket=-1;
     Oticket = OrderSend(Symbol(), OP_BUY, lot, Ask, slippage*j,0, 0, com, magic, 0, Green);  
         if (Oticket > 0)
         {
           if (OrderSelect(Oticket, SELECT_BY_TICKET, MODE_TRADES))
            {
              double OSL1=OrderOpenPrice()-SL*Point*j; double OTP1=OrderOpenPrice()+TP*Point*j;
              if(SL==0){OSL1=0;}if(TP==0){OTP1=0;}
              Print("BUY order opened : ", OrderOpenPrice());
              OrderModify(OrderTicket(),0,OSL1,OTP1,0,Orange);
              t=Time[0];
            }
         }
         else
          {
              Print("Error opening BUY order : ", GetLastError());
              return (False);
          }
   } 
  //--------------------------------------------------------------------------- 
  if(a==1&&CheckOrders(1) ==0&&t!=Time[0])
   {  
     Oticket=-1;
     Oticket=OrderSend(Symbol(), OP_SELL, lot, Bid, slippage*j, 0, 0, com, magic, 0, Red);
      if (Oticket > 0)
       {
         if (OrderSelect(Oticket, SELECT_BY_TICKET, MODE_TRADES))
          {
            double OSL2=OrderOpenPrice()+SL*Point*j; double OTP2=OrderOpenPrice()-TP*Point*j;
            if(SL==0){OSL2=0;}if(TP==0){OTP2=0;}
            Print("SELL order opened : ", OrderOpenPrice());
            OrderModify(OrderTicket(),0,OSL2,OTP2,0,Orange);
            t=Time[0];
          }
       }
      else
       {
         Print("Error opening SELL order : ", GetLastError());
         return (False);
       }
   }         
  return(0);
}

int CheckOrders(int type) 
   {
   int ordercnt = 0;
   for (int i = 0; i<OrdersTotal(); i++) 
      {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderType() == type&& OrderMagicNumber() == magic) 
      ordercnt++;
      }
   return (ordercnt);
   }

//-------------------------------------------

extern bool 移动止损N开关=true;
extern int 移损启动点M=10;
extern int N=0;
//-----------------------------------------------------
void MoveStopLossN()
{
   int j=1;if(Digits==3||Digits==5||Digits==2){j=10;}
   int MoveStar=移损启动点M; 
   for(int cnt=0;cnt<OrdersTotal();cnt++)  
     {
       OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
       if(OrderType() <= OP_SELL && OrderSymbol() == Symbol()&&移动止损N开关==true) 
         {
           
           if(OrderType() == OP_BUY)
             {  int  n1=MathFloor(((Bid - OrderOpenPrice())/Point)/((MoveStar-N)*j));
               if(MoveStar> 0) 
                 {
                   if(Bid - OrderOpenPrice() > Point*j* MoveStar*n1) 
                     {
                       if((OrderStopLoss() < (OrderOpenPrice() + Point*j* (MoveStar-N)*(n1-1)))||OrderStopLoss()==0)
                         { if(n1>0)
                           {
                            OrderModify(OrderTicket(), OrderOpenPrice(),
                            OrderOpenPrice() + Point*j* (MoveStar-N)*(n1-1),
                            OrderTakeProfit(), 0, Green);
                            return (0);
                           }
                         }
                     }
                 }
             } 
           
           if(OrderType() == OP_SELL)
            { int n2= MathFloor(((OrderOpenPrice() - Ask)/Point)/((MoveStar-N)*j));          
              if(MoveStar> 0) 
               {
                 if((OrderOpenPrice() - Ask) > (Point*j*MoveStar*n2)) 
                   {  
                     
                     if((OrderStopLoss() > (OrderOpenPrice() -Point*j*(MoveStar-N)*(n2-1)))||OrderStopLoss()==0) 
                       { 
                         if(n2>0)
                         {
                           OrderModify(OrderTicket(), OrderOpenPrice(),
                           OrderOpenPrice() -Point*j*(MoveStar-N)*(n2-1),
                           OrderTakeProfit(), 0, Red);
                           return (0);
                         }
                       }
                   }
               }
            }
         }
     }
  return (0);
}



