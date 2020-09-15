
extern double Lots = 0.01;
extern double днкъ_део =0.25;
extern int TakeProfit =500;
extern int Stop_Loss = 22;
extern double TrailingStopLoss = 18 ;
extern int TrailingStep = 5 ;
extern double TrailingStop = 0.33 ;
extern double Utral= 200;
extern double Max_Lot =1000;
extern double Klot =2;
extern int Pforse =13;
extern double UForce =0.04;
extern double TimeStop =60;
extern double TIME =30;
extern double SPREAD =19;
extern double STOP_level =20;
extern int slip =10;
extern bool DELETE = false;
extern bool ATR = true;
extern bool OP_STOP = true;
extern bool modif = true;
bool Usa_Trailing = true;
extern int BUY=1;
extern int SELL=1;
extern int MagicNumber = 7578;


int deinit(){
   ObjectDelete("Liverage");
   ObjectDelete("Spead");
   ObjectDelete("StopLevel");
   ObjectDelete("BALANSE");
   ObjectDelete("EQUITY");
   return(0);
}
int start() {
ObjectCreate("Liverage", OBJ_LABEL, 0, 0, 0, 0, 0);
    ObjectSet("Liverage", OBJPROP_CORNER, 2);
    ObjectSet("Liverage", OBJPROP_YDISTANCE, 15);
    ObjectSet("Liverage", OBJPROP_XDISTANCE, 10);
ObjectSetText("Liverage", "Liverage " + AccountLeverage(), 8, "Tahoma", Yellow); 
    ObjectCreate("Spead", OBJ_LABEL, 0, 0, 0, 0, 0);
    ObjectSet("Spead", OBJPROP_CORNER, 2);
    ObjectSet("Spead", OBJPROP_YDISTANCE, 30);
    ObjectSet("Spead", OBJPROP_XDISTANCE, 10);
ObjectSetText("Spead", "Spead " + DoubleToStr((Ask - Bid) / Point, 0), 8, "Tahoma",Yellow );  
if((Ask - Bid)/Point>SPREAD)ObjectSet("Spead", OBJPROP_COLOR, Red);
    ObjectCreate("StopLevel", OBJ_LABEL, 0, 0, 0, 0, 0);
    ObjectSet("StopLevel", OBJPROP_CORNER, 2);
    ObjectSet("StopLevel", OBJPROP_YDISTANCE, 45);
    ObjectSet("StopLevel", OBJPROP_XDISTANCE, 10);
ObjectSetText("StopLevel", "StopLevel " + DoubleToStr(MarketInfo(Symbol(), MODE_STOPLEVEL),0), 8, "Tahoma",Yellow );
if(MarketInfo(Symbol(), MODE_STOPLEVEL)>STOP_level)ObjectSet("StopLevel", OBJPROP_COLOR, Red);  
    ObjectCreate("BALANSE", OBJ_LABEL, 0, 0, 0, 0, 0);
    ObjectSet("BALANSE", OBJPROP_CORNER, 2);
    ObjectSet("BALANSE", OBJPROP_YDISTANCE, 60);
    ObjectSet("BALANSE", OBJPROP_XDISTANCE, 10);
ObjectSetText("BALANSE", "BALANSE " + DoubleToStr(AccountBalance(),2), 8, "Tahoma",Aqua );  
if(MarketInfo(Symbol(), MODE_STOPLEVEL)>STOP_level)ObjectSet("StopLevel", OBJPROP_COLOR, Red);  
    ObjectCreate("EQUITY", OBJ_LABEL, 0, 0, 0, 0, 0);
    ObjectSet("EQUITY", OBJPROP_CORNER, 2);
    ObjectSet("EQUITY", OBJPROP_YDISTANCE, 75);
    ObjectSet("EQUITY", OBJPROP_XDISTANCE, 10);
ObjectSetText("EQUITY", "EQUITY " + DoubleToStr(AccountEquity(),2),12, "Tahoma",Lime );
if(AccountEquity()<AccountBalance())ObjectSet("EQUITY", OBJPROP_COLOR, Red); 
if(AccountEquity()>AccountBalance())ObjectSet("EQUITY", OBJPROP_COLOR, Aqua);

   int U=0,R=1,ZB=0,ZS=0;
   double DL=0,x,y,MG,Min_Lot,Lotti,T=0,T1=0,K=1,HN,LN,J=1,B=0,S=0;

//..........................................................
    for(int q = 0; q < OrdersTotal(); q++)
   {
    
    if(!OrderSelect(q, SELECT_BY_POS, MODE_TRADES)) continue;
    if(OrderSymbol() != Symbol()) continue;
    if(OrderMagicNumber() != MagicNumber) continue;    
    if(OrderType()==OP_BUY&&OrderStopLoss()>OrderOpenPrice())T=1;
    if(OrderType()==OP_SELL&&OrderStopLoss()<OrderOpenPrice())T1=1;
    if(DELETE == true&&OrderType()==OP_BUYSTOP&&T1==1)OrderDelete(OrderTicket(),CLR_NONE);
    if(DELETE == true&&OrderType()==OP_SELLSTOP&&T==1)OrderDelete(OrderTicket(),CLR_NONE);
    if (OrderType() == OP_BUY&&OrderStopLoss()<OrderOpenPrice()&&Bid<=OrderStopLoss()+Point)PlaySound("stops.wav");
    if (OrderType() == OP_SELL&&OrderStopLoss()>OrderOpenPrice()&&Ask>=OrderStopLoss()-Point)PlaySound("stops.wav");  
    //........................................................................................
    if (modif==true)   
    {    
    if (OrderType() == OP_BUY)x=OrderStopLoss();
    if (OrderType() == OP_SELL)y=OrderStopLoss();
    if (OrderType() == OP_SELLSTOP&&T==1&&OrderOpenPrice()<x||OrderOpenPrice()<Bid-Stop_Loss*Point)
    OrderModify(OrderTicket(),Bid-Stop_Loss*Point,Ask,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
    if (OrderType() == OP_BUYSTOP&&T1==1&&OrderOpenPrice()>y||OrderOpenPrice()>Ask+Stop_Loss*Point)
    OrderModify(OrderTicket(),Ask+Stop_Loss*Point,Bid,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
    }
 //....................................................................          
     if(OrdersTotal() > 0)
     {
      if(OrderType() == OP_SELL&&OrderOpenPrice()-Ask>=Utral*Point)
      {
        if(TrailingStop> 0)
        {
          if(OrderOpenPrice() - Ask > Utral*Point)
          {            
            if(OrderStopLoss() > Ask + (OrderOpenPrice()*TrailingStop-Ask*TrailingStop) )
            {           
              OrderModify(OrderTicket(), OrderOpenPrice(), Ask + OrderOpenPrice()*TrailingStop-Ask*TrailingStop,
               OrderTakeProfit(),OrderMagicNumber(), CLR_NONE);
               return(0);
            }
          }
        }
      }
      else
        if(OrderType() == OP_BUY&&Bid-OrderOpenPrice()>=Utral*Point)
        {
          if(TrailingStop > 0)         
          {
            if(Bid - OrderOpenPrice() > Utral*Point)
            {
              if(OrderStopLoss() < Bid - (Bid - OrderOpenPrice())*TrailingStop)
              {
                OrderModify(OrderTicket(), OrderOpenPrice(), Bid - Bid*TrailingStop + OrderOpenPrice()*TrailingStop ,
                  OrderTakeProfit() ,OrderMagicNumber(), CLR_NONE);
                  return(0);
              }
            }
          }
        }
      }    
   }
//........................................................................................
//........................................................................   
//........................................................................................
        int m;
        if(Lots>0)
        {
        if(AccountFreeMargin()>AccountMargin())MG=AccountFreeMargin();
        if(AccountFreeMargin()<AccountMargin())MG=0;
        Min_Lot = MarketInfo(Symbol(), MODE_MINLOT);
              
        if(днкъ_део>0)
        {
          m=MG/MarketInfo (Symbol(), MODE_MARGINREQUIRED)*днкъ_део/Min_Lot;
          Lotti = m*Min_Lot;

        if(MG==0)Lotti =0;
        if(MG>0&&Lotti < Min_Lot)
        Lotti =Min_Lot;     
        
        if(MG>0&&Lotti > MarketInfo (Symbol(), MODE_MAXLOT))
        Lotti = MarketInfo (Symbol(), MODE_MAXLOT);     
        
        if(MG>0&&Lotti > Max_Lot)
        Lotti =Max_Lot;       
        }
        }
        if(днкъ_део==0)Lotti= Lots;

   // Orari per Tradare ----------------------------------

   if(R==1)      
   {
   bool Sto_Operando;
 
   double Media_Prezzo = iMA(NULL,1, 1, 0, 1, PRICE_MEDIAN, 0);
   double Media_Prezzo_2 = iMA(NULL,1, 1, 0, 1, PRICE_CLOSE, 0);
   double Media_Prezzo_3 = iMA(NULL,1, 1, 0, 1, PRICE_CLOSE, 1);
   double F=iForce(NULL,1,1,0,0,0);
   double F1=iForce(NULL,1,1,0,0,1);
   double WP=iWPR(NULL,1,1,0);
   double WP1=iWPR(NULL,1,1,1);

   double df2 = iForce(NULL,1,Pforse,0,0,0);
   double df3 = iForce(NULL,1,Pforse,0,0,1);
   double df4 = iForce(NULL,1,Pforse,0,0,2); 
   double df5 = iForce(NULL,1,Pforse,0,0,3);
   double df6 = iForce(NULL,1,Pforse,0,0,4); 
   double df7 = iForce(NULL,1,Pforse,0,0,5);  
           
   if (df2<-UForce||df3<-UForce||df4<-UForce||df5<-UForce||df6<-UForce||df7<-UForce)B=1; 
   if (df2>UForce||df3>UForce||df4>UForce||df5>UForce||df6>UForce||df7>UForce)S=1; 
   
   if (OrdersTotal() < 1) ObjectDelete("OrderStopline");
   double Lotti_da_Usare;
   if (Lotti_da_Usare < Lotti) Lotti_da_Usare = Lotti;   
   if (Lotti_da_Usare > MarketInfo(Symbol(), MODE_MAXLOT)) Lotti_da_Usare = MarketInfo(Symbol(), MODE_MAXLOT);
   if (Lotti_da_Usare < MarketInfo(Symbol(), MODE_MINLOT)) Lotti_da_Usare = MarketInfo(Symbol(), MODE_MINLOT);
   if(Klot * Lotti_da_Usare>MarketInfo (Symbol(), MODE_MAXLOT))Klot=1;
   
   double Spread = MarketInfo(Symbol(), MODE_SPREAD) * Point;
   int Stop_Level = MarketInfo(Symbol(), MODE_STOPLEVEL);
   if (Stop_Level < Stop_Loss) Stop_Level = Stop_Loss;
   if (Stop_Level > Stop_Loss) Lotti_da_Usare = NormalizeDouble(Lotti_da_Usare / 2.0, 2);
   int Ordini_Aperti = 0; 
   int Ordini_Totali = OrdersTotal();
   for (Ordini_Aperti = 0; Ordini_Aperti <= Ordini_Totali; Ordini_Aperti++) {
      OrderSelect(Ordini_Aperti, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) Sto_Operando = TRUE;
   }
   if (Usa_Trailing) {
      TrailingPositions(TrailingStopLoss, TrailingStep, MagicNumber);
   }
 
   if(SPREAD*Point<Ask-Bid){R=0;J=0;}
   if(STOP_level<MarketInfo(Symbol(), MODE_STOPLEVEL))R=0;
    
   if(OrderType()==OP_BUY&&OrderStopLoss()==0||R==0&&OrderMagicNumber()==MagicNumber&&Bid<OrderOpenPrice()-Stop_Loss*Point-MarketInfo(Symbol(), MODE_SPREAD)*Point)
   OrderClose(OrderTicket(),OrderLots(),Bid,slip,CLR_NONE);
   if(OrderType()==OP_SELL&&OrderStopLoss()==0||R==0&&OrderMagicNumber()==MagicNumber&&Ask>OrderOpenPrice()+Stop_Loss*Point+MarketInfo(Symbol(), MODE_SPREAD)*Point)
   OrderClose(OrderTicket(),OrderLots(),Ask,slip,CLR_NONE);
   
             
//......................................................................................
   if(днкъ_део==0)Lotti_da_Usare = Lots ;
   if(TimeStop>0&&TimeCurrent()-OrderOpenTime()>TimeStop)U=1;
   if(Sto_Operando == FALSE)U=1;
   if(OrdersTotal()==0)U=1; 

   if (U==1)
      {
         if (BUY==1&&ZB==0&&R==1&&Media_Prezzo_3 < Media_Prezzo_2 && Media_Prezzo_2 > Media_Prezzo &&B==1  
         &&F>0&&F1<0&&WP>-50&&WP1<-50)
         {
         OrderSend(Symbol(), OP_BUY, Lotti_da_Usare,Ask, slip,Bid - Stop_Loss * Point ,Ask+TakeProfit * Point, "", MagicNumber, 0, Green);
         if(OP_STOP==true)OrderSend(Symbol(), OP_SELLSTOP,Klot * Lotti_da_Usare, Bid-Stop_Loss * Point, slip,Ask ,Bid-Stop_Loss * Point-TakeProfit * Point, "", MagicNumber,TimeCurrent()+TIME*60, Red);
         PlaySound("alert2.wav");
         return(0);
         }
         if (SELL==1&&ZS==0&&R==1&&Media_Prezzo_3 > Media_Prezzo_2 && Media_Prezzo_2 < Media_Prezzo &&S==1 
        &&F<0&&F1>0&&WP<-50&&WP1>-50)
         {
         OrderSend(Symbol(), OP_SELL, Lotti_da_Usare,Bid, slip,Ask + Stop_Loss * Point,Bid-TakeProfit * Point, "", MagicNumber, 0, Red);
         if(OP_STOP==true)OrderSend(Symbol(), OP_BUYSTOP, Klot * Lotti_da_Usare, Ask+ Stop_Loss * Point, slip,Bid ,Ask+ Stop_Loss * Point+TakeProfit * Point, "", MagicNumber, TimeCurrent()+TIME*60, Green);  
         PlaySound("alert.wav");
         return(0);
        }
     }
   return (0);
  }
}


void TrailingPositions(int trailingStopLoss, int trailingStep, int magicNumber) {
   double bid = 0;
   double ask = 0;
   double X=1;

   for (int i = 0; i < OrdersTotal(); i++) {
      if (!(OrderSelect(i, SELECT_BY_POS)) || OrderSymbol() != Symbol() || OrderMagicNumber() != magicNumber) {
         continue;
      }
      
      bid = MarketInfo(OrderSymbol(), MODE_BID);
      ask = MarketInfo(OrderSymbol(), MODE_ASK);
      
      
      if (OrderType() == OP_BUY&&Bid-OrderOpenPrice()<Utral*Point) {
         if (bid - OrderOpenPrice() > X*trailingStopLoss * Point) {
            if (OrderStopLoss() < bid - (X*trailingStopLoss + trailingStep - 1) * Point || OrderStopLoss() == 0) {
               OrderModify(OrderTicket(), OrderOpenPrice(), bid - X*trailingStopLoss * Point, OrderTakeProfit(), OrderExpiration());
               PlaySound("ok.wav");
            }
         }
      } else if (OrderType() == OP_SELL&&OrderOpenPrice()-Ask<Utral*Point) {
         if (OrderOpenPrice() - ask > X*trailingStopLoss * Point) {
            if (OrderStopLoss() > ask + (X*trailingStopLoss + trailingStep - 1) * Point || OrderStopLoss() == 0) {            
               OrderModify(OrderTicket(), OrderOpenPrice(), ask + X*trailingStopLoss * Point, OrderTakeProfit(), OrderExpiration());
               PlaySound("ok.wav");
            }
         }
      }
   }

}

 
 
 