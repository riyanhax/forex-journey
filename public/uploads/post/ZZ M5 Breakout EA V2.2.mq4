 //+------------------------------------------------------------------+
 //|                                                                  |
 //|                                                                  |
 //|                                      www.arabictrader.com/vb     |
 //|                                                                  |
 //|                                          mrdollar.cs@gmail.com   |
 //+------------------------------------------------------------------+
 
#property copyright "MR.dollarEA"
#property link      "mrdollar.cs@gmail.com"

 extern int MaxMainOrders=50;       
 extern bool  UseTimeFilter = false;        
 extern int  StartHour = 7;            
 extern int  EndHour = 17; 

 extern int Min_Top_Bott_Diff=20;
 extern int Max_Top_Bott_Diff=40;
 extern double Multiplier=2;
 extern string zz="ZigZag Settings";
 extern int ExtDepth=12;
 extern int ExtDeviation=5;
 extern int ExtBackstep=3;
         
 extern string  MM = " Money Management";
 extern double  Lots = 0.1;                                           
 extern bool  UseMoneyManagement = false;                 
 extern int  RiskPercent = 10;                      
 
 
extern string S5=" Order Management";
extern bool UseDiffTakeProfit=false;
extern double TakeProfit_Percent=100;
extern int TakeProfit=0;

extern int TrailingStop=0;
extern int TrailingStep=0;

extern int BreakEven=0;
extern int movestopto=1;
 
 

 datetime Time0;
 double point;
 int digits,Q;
 extern int MagicNumber=2533; 
 bool DeleteFirstPending;                            
 int init()
{
 if(Digits==5||Digits==3)Q=10;
 else Q=1;

 if(Digits<4){point=0.01;digits=2;}
 else{point=0.0001;digits=4;}
return(0);
}

 //+------------------------------------------------------------------+
 //| FUNCTION DEFINITIONS    deinitialization function                |
 //+------------------------------------------------------------------+

 void deinit() {
    Comment("");
  }

 int orderscnt(int type,int magic){
 int cnt=0;
   for(int i =0;i<OrdersTotal();i++){
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
       if(OrderSymbol()==Symbol()&&OrderType()==type||type==-1&&OrderMagicNumber()==magic||magic==0&&OrderComment()=="MR.dollar EA"){
         cnt++;
       }
     }
   }
    return(cnt);
  }

 //+------------------------------------------------------------------+
 //| FUNCTION DEFINITIONS   Start function                            |
 //+------------------------------------------------------------------+

 int start()
   {
    Comment("Programmed by MR.dollar"+"\n"+"Idea Created by hamada_acc"+"\n"+"ãäÊÏì ÇáãÊÏÇæá ÇáÚÑÈí"+"\n"+"www.arabictrader.com/vb");
       if (UseTimeFilter){
       if(!((StartHour < EndHour && TimeHour(TimeCurrent()) >= StartHour && TimeHour(TimeCurrent()) < EndHour) || (StartHour > EndHour && TimeHour(TimeCurrent()) >= StartHour ||
               TimeHour(TimeCurrent()) < EndHour))){
           Comment("Non-Trading Hours!");
           return(0);
         }
       }
       //|---------trailing stop

   if(TrailingStop>0)MoveTrailingStop();
   if(BreakEven>0)MoveBreakEven();
   
       //////////////////////////////////////////////////
      
   if(UseMoneyManagement) Lots = LotManage();
   
   bool Signal;
   if(MathAbs(GetZigZag(4)-GetZigZag(3))>=Min_Top_Bott_Diff*point&&MathAbs(GetZigZag(4)-GetZigZag(3))<Max_Top_Bott_Diff*point
      &&MathMax(GetZigZag(1),GetZigZag(2))<MathMax(GetZigZag(3),GetZigZag(4))&&MathMin(GetZigZag(1),GetZigZag(2))>MathMin(GetZigZag(3),GetZigZag(4)))
    {
     Signal=true;
    }
    static int Num=0;      
    
    
   for(int i=0;i<OrdersTotal();i++){
    OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
    double Magic=OrderMagicNumber();
    if(OrderSymbol()==Symbol()/*&&OrderMagicNumber()-Num==MagicNumber*/){
     if(orderscnt(-1,Magic)==1||(orderscnt(OP_BUYSTOP,Magic)+orderscnt(OP_SELLSTOP,Magic)==1&&!DeleteFirstPending)){
      DeleteOrders(Magic);
      DeleteFirstPending=true;
     }
        
   if(orderscnt(OP_BUY,Magic)==1&&orderscnt(OP_SELLSTOP,Magic)==0){
    OrderSend(Symbol(),OP_SELLSTOP,LastOrderLots(OP_BUY,Magic)*Multiplier,NormalizeDouble(Order_Info(1,OP_SELLSTOP,"OP",Magic),Digits),3*Q,Order_Info(1,OP_SELLSTOP,"SL",Magic),Order_Info(1,OP_SELLSTOP,"TP",Magic),"MR.dollar EA",MagicNumber+Num,0,Red);
   }
  if(orderscnt(OP_SELL,Magic)==1&&orderscnt(OP_BUYSTOP,Magic)==0){
    OrderSend(Symbol(),OP_BUYSTOP,LastOrderLots(OP_SELL,Magic)*Multiplier,NormalizeDouble(Order_Info(0,OP_BUYSTOP,"OP",Magic),Digits),3*Q,Order_Info(0,OP_BUYSTOP,"SL",Magic),Order_Info(0,OP_BUYSTOP,"TP",Magic),"MR.dollar EA",MagicNumber+Num,0,Blue);
    }
  } 
 }
 if(orderscnt(-1,0)>Num)
   Num--;
    ////////////////////////////////
    double SL,TP; 
    if (Signal&&Time0!=Time[0]){
     if(Num<MaxMainOrders&&orderscnt(OP_BUYSTOP,0)+orderscnt(OP_SELLSTOP,0)==0){
        Num++;   
       
        double buyprice=MathMax(GetZigZag(3),GetZigZag(4));
        double sellprice=MathMin(GetZigZag(3),GetZigZag(4));
         SL=sellprice-3*point;
         if(TakeProfit==0){TP=0;}else{TP=buyprice+3*point+TakeProfit*point;}
         if(UseDiffTakeProfit)TP=buyprice+3*point+TakeProfit_Percent*(buyprice-sellprice)/100;  
         OrderSend(Symbol(),OP_BUYSTOP,Lots,NormalizeDouble(buyprice+3*point,Digits),3*Q,SL,TP,"MR.dollar EA",MagicNumber+Num,0,Blue);
         SL=buyprice+3*point;
         if(TakeProfit==0){TP=0;}else{TP=sellprice-3*point-TakeProfit*point;}
          if(UseDiffTakeProfit)TP=sellprice-3*point-TakeProfit_Percent*(buyprice-sellprice)/100;  
         OrderSend(Symbol(),OP_SELLSTOP,Lots,NormalizeDouble(sellprice-3*point,Digits),3*Q,SL,TP,"MR.dollar EA",MagicNumber+Num,0,Red);
         PlaySound("Alert.wav");
         DeleteFirstPending=false; 
      }
     }     
   }

double LastOrderLots(int type,int magic){
 for(int i=OrdersTotal()-1;i>=0;i--){
  OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
  if(OrderSymbol()==Symbol()&&OrderType()==type&&OrderMagicNumber()==magic){
   return(OrderLots());
  }
 }
return(0);
}   

double Order_Info(int type1,int type2,string info,int magic){
 for(int i=OrdersHistoryTotal()-1;i>=0;i--){
  OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
 if(OrderSymbol()==Symbol()&&OrderType()==type1||OrderType()==type2&&OrderMagicNumber()==magic){
  Print(OrderMagicNumber());
  
   if(info=="OP")return(OrderOpenPrice());
   if(info=="TP")return(OrderTakeProfit());
   if(info=="SL")return(OrderStopLoss());
  }
 }
return(0);
}

double GetZigZag(int shift){
 int num;
 for(int i=0;i<Bars;i++){
  double zz=iCustom(Symbol(),0,"ZigZag",ExtDepth,ExtDeviation,ExtBackstep,0,i);
  if(zz!=0)
    num++;
  if(num==shift)
    return(zz);
 }
return(0);
}
//+------------------------------------------------------------------+

void DeleteOrders(int magic)
 {
  for(int i=0;i<OrdersTotal();i++){
   OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
   if(OrderSymbol()==Symbol()&&OrderType()>OP_SELL&&OrderMagicNumber()==magic){
    OrderDelete(OrderTicket());
   }
  }
 }
 //+------------------------------------------------------------------+
 //| FUNCTION DEFINITIONS   TrailingStop                              |
 //+------------------------------------------------------------------+
    
    //|---------trailing stop

void MoveTrailingStop()
{
   int cnt,total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol()&&OrderComment()=="MR.dollar EA")
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



//|---------break even

void MoveBreakEven()
{
   int cnt,total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol()&&OrderComment()=="MR.dollar EA")
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

 //+------------------------------------------------------------------+
 //| FUNCTION DEFINITIONS   Money Managment                           |
 //+------------------------------------------------------------------+ 

 double LotManage()
  {
      double lot = MathCeil(AccountFreeMargin() *  RiskPercent / 1000) / 100; 
	  
	  if(lot<MarketInfo(Symbol(),MODE_MINLOT))lot=MarketInfo(Symbol(),MODE_MINLOT);
	  if(lot>MarketInfo(Symbol(),MODE_MAXLOT))lot=MarketInfo(Symbol(),MODE_MAXLOT);
	  
	   
	   return (lot);
  }

 //+---------------------------------------------------------------------------------+
 
   