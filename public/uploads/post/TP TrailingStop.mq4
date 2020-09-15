 //+------------------------------------------------------------------+
 //|                                                                  |
 //|                                                                  |
 //|                                      www.worldwide-invest.cog    |
 //|                                                                  |
 //|                                                                  |
 //+------------------------------------------------------------------+
 
 #property copyright "TP TrailingStop"
 #property link      "Wwi"
 

extern string S4="  Classic Order Management";
extern bool ModifyAllOrders=false;
extern bool HideSL=false;
extern int StopLoss=0;
extern bool HideTP=false;
extern int TakeProfit=0;

extern string S10=" Classic Trailing Stop";
extern int TrailingStop=0;
extern int TrailingStep=0;


extern string S6="  Orders BreakEven ";
extern int BreakEven=0;
extern int movestopto=1;
extern int BreakEven2=0;
extern int movestopto2=0;




 double point;
 int digits,i,D;
                            
 int init()
{
    if(Digits==5||Digits==3){ D=10;}
    else{D=1;}
    if(Digits<4)
   {
      point=0.01;
      digits=2;
   }
   else
   {
      point=0.0001;
      digits=4;
   }
return(0);
}

 //+------------------------------------------------------------------+
 //| FUNCTION DEFINITIONS    deinitialization function                |
 //+------------------------------------------------------------------+

 void deinit() {
    Comment("");
  }

 
 //+------------------------------------------------------------------+
 //| FUNCTION DEFINITIONS   Start function                            |
 //+------------------------------------------------------------------+

 int start()
   {
   double SL,TP; 
 
 /////////////////////////////////////////
   
   
   Comment("Programmed by MR.dollar"+"\n"+"ãäÊÏì ÇáãÊÏÇæá ÇáÚÑÈí"+"\n"+"www.arabictrader.com/vb");
    
       //|---------trailing stop

   if(TrailingStop>0)MoveTrailingStop();
   if(BreakEven>0)MoveBreakEven();
   if(BreakEven2>0)MoveBreakEven2();
   
       //////////////////////////////////////////////////
     
       
        if(HideSL&&StopLoss>0)
   {
      CloseBuyOrdersHiddenSL();CloseSellOrdersHiddenSL();
   }
   if(HideTP&&TakeProfit>0)
   {
      CloseBuyOrdersHiddenTP();CloseSellOrdersHiddenTP();
   }
      
   ////////////////////////////////////////////////////
      
       
    
   for(int cnt=OrdersTotal();cnt>=0;cnt--)
    {
    
     OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
     double type=OrderType();double stop=OrderStopLoss();double open=OrderOpenPrice();
     int tick=OrderTicket();double profit=OrderTakeProfit();
     if(OrderSymbol()==Symbol()||ModifyAllOrders==true){
     if(StopLoss!=0||TakeProfit!=0){
     if(type==OP_BUY&&(HideSL==false||HideTP==false)){
     if(StopLoss!=0&&HideSL==false){SL=open-StopLoss*point;}
     if(TakeProfit!=0&&HideTP==false){TP=open+TakeProfit*point;}
     if(stop!=SL||profit!=TP){
     OrderModify(tick,open,SL,TP,0,Blue);
      }}
      if(type==OP_SELL&&(HideSL==false||HideTP==false)){
       if(StopLoss!=0&&HideSL==false){SL=open+StopLoss*point;}
        if(TakeProfit!=0&&HideTP==false){TP=open-TakeProfit*point;}
        if(stop!=SL||profit!=TP){
        OrderModify(tick,open,SL,TP,0,Red);
        }  }} } }   
    
  
    }
   

//+------------------------------------------------------------------+

int CloseBuyOrdersHiddenTP()
{
  int total=OrdersTotal();

  for (int cnt=total;cnt>=0;cnt--)
  {
    OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
    if(OrderSymbol()==Symbol())
    {
      if(OrderType()==OP_BUY&&Bid>(OrderOpenPrice()+TakeProfit*point))
      {
        OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),3*D);
      }
    }
  }
  return(0);
}
void CloseBuyOrdersHiddenSL()
{
  int total=OrdersTotal();

  for (int cnt=total;cnt>=0;cnt--)
  {
    OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
    if(OrderSymbol()==Symbol())
    {
      if(OrderType()==OP_BUY&&Bid<(OrderOpenPrice()-StopLoss*point))
      {
        OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),3*D);
      }
    }
  }
}

void CloseSellOrdersHiddenTP()
{
  int total=OrdersTotal();

  for(int cnt=total;cnt>=0;cnt--)
  {
    OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
    if(OrderSymbol()==Symbol())
    {
      if(OrderType()==OP_SELL&&Ask<(OrderOpenPrice()-TakeProfit*point))
      {
        OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),3*D);
      }
    }
  }
}

void CloseSellOrdersHiddenSL()
{
  int total=OrdersTotal();

  for(int cnt=total;cnt>=0;cnt--)
  {
    OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
    if(OrderSymbol()==Symbol())
    {
      if(OrderType()==OP_SELL&&Ask>(OrderOpenPrice()+StopLoss*point))
      {
        OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),3*D);
      }
    }
  }
}
 //+------------------------------------------------------------------+
 //| FUNCTION DEFINITIONS   TrailingStop                              |
 //+------------------------------------------------------------------+
  
void MoveBreakEven()
{
   int cnt,total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol())
      {
         if(OrderType()==OP_BUY)
         {
            if(BreakEven>0)
            {
               if(NormalizeDouble((Bid-OrderOpenPrice()),digits)>BreakEven*point)
               {
                  if(NormalizeDouble((OrderStopLoss()-OrderOpenPrice()),digits)<0)
                  {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+movestopto*point,digits),OrderTakeProfit(),0,Blue);
                     
                  }
               }
            }
         }
         else
         {
            if(BreakEven>0)
            {
               if(NormalizeDouble((OrderOpenPrice()-Ask),digits)>BreakEven*point)
               {
                  if(NormalizeDouble((OrderOpenPrice()-OrderStopLoss()),digits)<0)
                  {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-movestopto*point,digits),OrderTakeProfit(),0,Red);
                    
                  }
               }
            }
         }
      }
   }
}
void MoveBreakEven2()
{
   int cnt,total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol())
      {
         if(OrderType()==OP_BUY)
         {
            if(BreakEven2>0)
            {
               if(NormalizeDouble((Bid-OrderOpenPrice()),digits)>BreakEven2*point)
               {
                  if(NormalizeDouble((OrderStopLoss()-OrderOpenPrice()),digits)<0)
                  {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+movestopto2*point,digits),OrderTakeProfit(),0,Blue);
                  
                  }
               }
            }
         }
         else
         {
            if(BreakEven2>0)
            {
               if(NormalizeDouble((OrderOpenPrice()-Ask),digits)>BreakEven2*point)
               {
                  if(NormalizeDouble((OrderOpenPrice()-OrderStopLoss()),digits)<0)
                  {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-movestopto2*point,digits),OrderTakeProfit(),0,Red);
                    
                  }
               }
            }
         }
      }
   }
}
void MoveTrailingStop()
{
   int cnt,total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol())
      {
         if(OrderType()==OP_BUY)
         {
            if(TrailingStop>0&&NormalizeDouble(Ask-TrailingStep*point,digits)>NormalizeDouble(OrderOpenPrice()+TrailingStop*point,digits))  
            {                 
               if((NormalizeDouble(OrderStopLoss(),digits)<NormalizeDouble(Bid-TrailingStop*point,digits))||(OrderStopLoss()==0))
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid-TrailingStop*point,digits),OrderTakeProfit(),0,Blue);
                 
               }
            }
         }
         else 
         {
            if(TrailingStop>0&&NormalizeDouble(Bid+TrailingStep*point,digits)<NormalizeDouble(OrderOpenPrice()-TrailingStop*point,digits))  
            {                 
               if((NormalizeDouble(OrderStopLoss(),digits)>(NormalizeDouble(Ask+TrailingStop*point,digits)))||(OrderStopLoss()==0))
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask+TrailingStop*point,digits),OrderTakeProfit(),0,Red);
                 
               }
            }
         }
      }
   }
}
 //+---------------------------------------------------------------------------------+ 