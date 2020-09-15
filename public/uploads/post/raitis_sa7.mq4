//+------------------------------------------------------------------+
//|                                                   raitis_sa3.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "samir arman Copyright 2012"
#property link      "samir_arman@yahoo.com"
extern double Lot1=0.1;
extern bool Auto.Lots=false;
extern double  MaxRisk = 0.01;     
extern int TakeProfit=50;
extern  int StopLoss=50;
extern int TrailingStop=0;
extern int BreakEven=0;
extern int  Buy=1;
extern int  sell=1;
extern bool Close.At.Next=true;
extern string Time_Start="00:00";
extern string Time_End="23:59"; 
extern int win_USD=60;
extern bool Multiplication=true;
extern string Multiplication_info = "0=1,2,3,4....    1=1,2,3,5,8....    2=1,2,4,8,16....    3=1,3,9,27....";
extern int Multiplication_Mode = 2;
extern int step=20;
extern int MagicNumber=88;
int T;
int movestopto=1;
 int TrailingStep=0;
double pt,buy,Sell;
color color_pofet,C;
string nam="Wait";
color Cl=GreenYellow;
int tag=0;

int init()
  {
if(Digits==5||Digits==4) 
{ 
pt=0.0001; 
} 
else{ 
pt=0.01; 
}
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
	Comment("");
	
ObjectsDeleteAll("HIGH12");
   ObjectsDeleteAll("Text High12");
   ObjectsDeleteAll("FE-b 100");
    ObjectsDeleteAll("Text  100");
   ObjectsDeleteAll("X01_ValueRGE14");
   ObjectsDeleteAll("X01_LabelRGE2");
   ObjectsDeleteAll("X01_ValueRGE3");
   ObjectsDeleteAll("X01_LabelRGE4");
     ObjectsDeleteAll("X01_ValueRGE4");
   ObjectsDeleteAll("X01_LabelRGE851");
    ObjectsDeleteAll("X01_ValueRGE85");
   ObjectsDeleteAll("X01_LabelRGE813");
     ObjectsDeleteAll("X01_ValueRGE83");
  
   ObjectsDeleteAll("sa1");
     ObjectsDeleteAll("sa2");
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {

  double hour=Hour()+Minute()/100.0;
  datetime start= StrToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " " + Time_Start);
  datetime end= StrToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " " + Time_End);
  bool time=(Time[0]>=start && Time[0]<=end); 
  bool end_time=(Time[0]>=end); 
  
  
double BUY_1=iCustom(Symbol(),0,"RaitisPriceChannel",0,1);
double SELL_1=iCustom(Symbol(),0,"RaitisPriceChannel",1,1);
double BUY_2=iCustom(Symbol(),0,"RaitisCyFilter",0,1);
double SELL_2=iCustom(Symbol(),0,"RaitisCyFilter",1,1);
double BUY_3=iCustom(Symbol(),0,"Fisher_Yur4ik_1",1,1);
double SELL_3=iCustom(Symbol(),0,"Fisher_Yur4ik_1",2,1);
double Zig=iCustom(Symbol(),0,"Zigzag",0,1);
double Zig123=iCustom(Symbol(),0,"ZigZag123",0,1);

double BB=ObjectGet("HIGH12",OBJPROP_PRICE1);
double SS=ObjectGet("FE-b 100",OBJPROP_PRICE1);



double mm=MathAbs(BB-Bid);
double nn=MathAbs(Ask-SS);





if(BUY_1<1000&&BUY_2<100&&BUY_3>0&&Ask>SS&&nn<70*pt){nam="BUY";Cl=Lime;}
//else if(BUY_1>100000||BUY_2>100||BUY_3<0){nam="Wait";Cl=GreenYellow;} 


if(SELL_1<1000&&SELL_2<100&&SELL_3<-0&&BB>Bid&&mm<70*pt){nam="SELL";Cl=Red;}//else {nam="Wait";Cl=SandyBrown;} 
//else if(SELL_1>100000||SELL_2>100||SELL_3>-0){nam="Wait";Cl=GreenYellow;} 



 if(tag!=Time[0])
               {
                if(BUY_1<1000&&BUY_2<100&&BUY_3>0&&Ask>SS&&nn<70*pt)// green going up
                   {
                    static datetime Time0;
                        if(Time0 != Time[0]){ Time0 = Time[0];Alert(Symbol()," ",Period(),"  ",nam); }tag=Time[0];
                   }
                    if(SELL_1<1000&&SELL_2<100&&SELL_3<-0&&BB>Bid&&mm<70*pt)// Red going up
                   {
                      if (Time0 != Time[0]){ Time0 = Time[0];Alert(Symbol()," ",Period(),"  ",nam); }tag=Time[0];
                   }   
                  }
    





if(time==true&&BUY_1<1000&&BUY_2<100&&BUY_3>0&&Ask>SS&&nn<70*pt&&ordestotal1()<Buy&&T!=Time[0]&&ordestotal1_2(OP_SELL)==0){  

   open(OP_BUY,Lots(MaxRisk),Ask,TakeProfit,StopLoss) ;
     T=Time[0];
      }
        

if(time==true&&SELL_1<1000&&SELL_2<100&&SELL_3<-0&&BB>Bid&&mm<70*pt&&ordestotal1sell()<sell&&T!=Time[0]&&ordestotal1_2(OP_BUY)==0){ 
    open(OP_SELL,Lots(MaxRisk),Bid,TakeProfit,StopLoss) ;
     T=Time[0];
  }


for(int m=0;m<OrdersTotal();m++){
  OrderSelect(m,SELECT_BY_POS,MODE_TRADES);
  if(OrderSymbol()==Symbol()&&OrderMagicNumber()== MagicNumber&&OrderType()==OP_BUY){
   double openprice=OrderOpenPrice();double lot=OrderLots();
   } 
 }

  
   
    for(int n=0;n<OrdersTotal();n++){
  OrderSelect(n,SELECT_BY_POS,MODE_TRADES);
  if(OrderSymbol()==Symbol()&&OrderMagicNumber()== MagicNumber&&OrderType()==OP_SELL){
   double openprice_sell=OrderOpenPrice();lot=OrderLots();
   } 
 }
 if(Multiplication==true){
 if(openprice-Ask>=step*pt&&ordestotal1_2(OP_BUY)>=1){
  open(OP_BUY,lot*Multiplication_Mode,Ask,TakeProfit,StopLoss) ;
  }
  if(Bid-openprice_sell>=step*pt&&ordestotal1_2(OP_SELL)>=1){
   open(OP_SELL,lot*Multiplication_Mode,Bid,TakeProfit,StopLoss) ;
    }
 
 }
 
 






if(TrailingStop>0)MoveTrailingStop();
   if(BreakEven>0)MoveBreakEven();





  if(pofet()>0)color_pofet=Lime;
if(pofet()<0)color_pofet=Red;
      
 
 
  double clo=iClose(Symbol(),PERIOD_D1,0);
 double clo2=iClose(Symbol(),PERIOD_M5,1);
  if(clo>=clo2)C=Lime;

  if(clo<=clo2)C=Red;
  
     ObjectCreate("X01_ValueRGE14", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("X01_ValueRGE14", "   " + DoubleToStr(Bid,Digits), 30, "", C);
   ObjectSet("X01_ValueRGE14", OBJPROP_CORNER,1);
   ObjectSet("X01_ValueRGE14", OBJPROP_XDISTANCE, 21);
   ObjectSet("X01_ValueRGE14", OBJPROP_YDISTANCE,10);
   





ObjectCreate("X01_LabelRGE2", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("X01_LabelRGE2", "AccountEquity", 12, "", White);
   ObjectSet("X01_LabelRGE2", OBJPROP_CORNER,1);
   ObjectSet("X01_LabelRGE2", OBJPROP_XDISTANCE,80);
   ObjectSet("X01_LabelRGE2", OBJPROP_YDISTANCE,60);
  
  ObjectCreate("X01_ValueRGE3", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("X01_ValueRGE3", " " + DoubleToStr(AccountEquity(), Point), 12, "", Lime);
   ObjectSet("X01_ValueRGE3", OBJPROP_CORNER,1);
   ObjectSet("X01_ValueRGE3", OBJPROP_XDISTANCE, 21);
   ObjectSet("X01_ValueRGE3", OBJPROP_YDISTANCE, 60);
   
   
  
 ObjectCreate("X01_LabelRGE4", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("X01_LabelRGE4", "Hour", 12, "", OrangeRed);
   ObjectSet("X01_LabelRGE4", OBJPROP_CORNER, 1);
   ObjectSet("X01_LabelRGE4", OBJPROP_XDISTANCE,80);
   ObjectSet("X01_LabelRGE4", OBJPROP_YDISTANCE,80);
  
  ObjectCreate("X01_ValueRGE4", OBJ_LABEL, 0, 0, 0);//
   ObjectSetText("X01_ValueRGE4", "   " + DoubleToStr(hour,TIME_MINUTES ), 12, "", Lime);
   ObjectSet("X01_ValueRGE4", OBJPROP_CORNER,1);
   ObjectSet("X01_ValueRGE4", OBJPROP_XDISTANCE, 21);
   ObjectSet("X01_ValueRGE4", OBJPROP_YDISTANCE,80);
   
     ObjectCreate("X01_LabelRGE851", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("X01_LabelRGE851", "pofet", 12, "", DodgerBlue);
   ObjectSet("X01_LabelRGE851", OBJPROP_CORNER,1);
   ObjectSet("X01_LabelRGE851", OBJPROP_XDISTANCE,80);
   ObjectSet("X01_LabelRGE851", OBJPROP_YDISTANCE, 100);
   
   ObjectCreate("X01_ValueRGE85", OBJ_LABEL, 0, 0, 0);
  ObjectSetText("X01_ValueRGE85", " " + DoubleToStr(pofet(), Point), 12, "", color_pofet);
   ObjectSet("X01_ValueRGE85", OBJPROP_CORNER,1);
   ObjectSet("X01_ValueRGE85", OBJPROP_XDISTANCE, 21);
   ObjectSet("X01_ValueRGE85", OBJPROP_YDISTANCE, 100);
   
  
   ObjectCreate("X01_LabelRGE813", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("X01_LabelRGE813", "open", 12, "", White);
   ObjectSet("X01_LabelRGE813", OBJPROP_CORNER,1);
   ObjectSet("X01_LabelRGE813", OBJPROP_XDISTANCE,80);
   ObjectSet("X01_LabelRGE813", OBJPROP_YDISTANCE, 120);
   
   ObjectCreate("X01_ValueRGE83", OBJ_LABEL, 0, 0, 0);
  ObjectSetText("X01_ValueRGE83",nam, 12, "", Cl);
   ObjectSet("X01_ValueRGE83", OBJPROP_CORNER,1);
   ObjectSet("X01_ValueRGE83", OBJPROP_XDISTANCE, 19);
   ObjectSet("X01_ValueRGE83", OBJPROP_YDISTANCE, 120);
   
   
 
   
   
    
 samir("sa1",0,10,20,"ÓãíÑãÍãÏÇÑãÇä",20,"",Lime);
 samir("sa2", 0, 40, 15,"ãäÊÏì ÈæÑÕÇÊ",20,"",Tomato);
  
  if(pofet()>=win_USD){closeordar(OP_SELL);closeordar(OP_BUY);}

  
  if(BUY_1<1000&&BUY_2<100&&BUY_3>0&&Ask>SS&&nn<70*pt&&Close.At.Next==true)closeordar(OP_SELL);

 if(SELL_1<1000&&SELL_2<100&&SELL_3<-0&&BB>Bid&&mm<70*pt&&Close.At.Next==true)closeordar(OP_BUY);
 
RefreshRates();


   return(0);
  }
//+------------------------------------------------------------------+

int open(int ty,double lot,double prc,int pof,int sll)
   {
     double sl=0,tp=0;
     color clr;
     bool modi;
     string T;double pr;
     if(ty==OP_BUY || ty==OP_BUYSTOP || ty==OP_BUYLIMIT)
        {
         if(sll>0){sl=prc-(sll*pt);}else{sl=0;}
         if(pof>0){tp=prc+(pof*pt);}else{tp=0;}
         clr=Green;
         T="Ask ";
         pr=NormalizeDouble(Ask,Digits);
        }
     if(ty==OP_SELL || ty==OP_SELLSTOP || ty==OP_SELLLIMIT)
       { 
         if(sll>0){sl=prc+(sll*pt);}else{sl=0;}
         if(pof>0){tp=prc-(pof*pt);}else{tp=0;}
         clr=Red;
         T="Bid";
         pr=NormalizeDouble(Bid,Digits);
       }     
         int tik=OrderSend(Symbol()
                ,ty
                ,lot
                ,NormalizeDouble(prc,Digits)
                ,10
                ,0
                ,0
                ,"samir"
                ,MagicNumber
                ,0
                ,clr);
          string t;
            if(ty==OP_BUY)t="BUY";if(ty==OP_SELL)t="SELL";if(ty==OP_BUYSTOP)t="BUY STOP";if(ty==OP_SELLSTOP)t="SELL STOP";if(ty==OP_BUYLIMIT)t="BUY LIMIT";if(ty==OP_SELLLIMIT)t="SELL LIMIT";
      if(tik>0)
         {
          if(tp>0 || sl>0)modi=OrderModify(tik,prc,NormalizeDouble(sl,Digits),NormalizeDouble(tp,Digits),0,CLR_NONE);   else modi=true;
          if(!modi){Print("Modify Err#= ",GetLastError(),"   ",Symbol()," ",Period(),"   Open Price= ",DoubleToStr(prc,Digits),"   SL= ",DoubleToStr(sl,Digits),"   Tp= ",DoubleToStr(tp,Digits));} 
           Print("Order Opened successfully   " ,"Type   ",t,"  LotSize   ",lot,"  Price   ",DoubleToStr(prc,Digits),"  TP   ",DoubleToStr(tp,Digits),"  SL   ",DoubleToStr(sl,Digits));
         }
         else
           {
            Print("OrderSend failed with error #",GetLastError(), " Type ",t,"   LotSize= ",lot,"   ",T,"Now= ",DoubleToStr(pr,Digits),"   Price= ",DoubleToStr(prc,Digits),"   TP= ",DoubleToStr(tp,Digits),"   SL= ",DoubleToStr(sl,Digits),"   Spread= ",MarketInfo(Symbol(),MODE_SPREAD));
           }
                //////
         return(tik);
   
}    
                void MoveTrailingStop()
{
   
   for(int cnt=0;cnt<OrdersTotal();cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol()&&OrderMagicNumber()==MagicNumber)
      {
         if(OrderType()==OP_BUY)
         {
            if(TrailingStop>0&&NormalizeDouble(Ask-TrailingStep*pt,Digits)>NormalizeDouble(OrderOpenPrice()+TrailingStop*pt,Digits))  
            {                 
               if((NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(Bid-TrailingStop*pt,Digits))||(OrderStopLoss()==0))
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid-TrailingStop*pt,Digits),OrderTakeProfit(),0,Blue);
                
               }
            }
         }
         else 
         {
            if(TrailingStop>0&&NormalizeDouble(Bid+TrailingStep*pt,Digits)<NormalizeDouble(OrderOpenPrice()-TrailingStop*pt,Digits))  
            {                 
               if((NormalizeDouble(OrderStopLoss(),Digits)>(NormalizeDouble(Ask+TrailingStop*pt,Digits)))||(OrderStopLoss()==0))
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask+TrailingStop*pt,Digits),OrderTakeProfit(),0,Red);
                
               }
            }
         }
      }
   }
}



void MoveBreakEven()
{
   int cnt,total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol()&&OrderMagicNumber()==MagicNumber)
      {
         if(OrderType()==OP_BUY)
         {
            if(BreakEven>0)
            {
               if(NormalizeDouble((Bid-OrderOpenPrice()),Digits)>BreakEven*pt)
               {
                  if(NormalizeDouble((OrderStopLoss()-OrderOpenPrice()),Digits)<0)
                  {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+movestopto*pt,Digits),OrderTakeProfit(),0,Blue);
                  
                  }
               }
            }
         }
         else
         {
            if(BreakEven>0)
            {
               if(NormalizeDouble((OrderOpenPrice()-Ask),Digits)>BreakEven*pt)
               {
                  if(NormalizeDouble((OrderOpenPrice()-OrderStopLoss()),Digits)<0)
                  {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-movestopto*pt,Digits),OrderTakeProfit(),0,Red);
               
                  }
               }
            }
         }
      }
   }
}
 int ordestotal1() 
{ 
int total=0; 
for(int a=0;a<OrdersTotal();a++){ 
OrderSelect(a,SELECT_BY_POS,MODE_TRADES); 
if(OrderSymbol()==Symbol()&&MagicNumber==OrderMagicNumber()&&OrderType()==OP_BUY){ 
total++; 
} 
} 
return(total); 
} 
///////////////////////////////////////////////////////////////////////////////
 int ordestotal1sell() 
{ 
int total=0; 
for(int a=0;a<OrdersTotal();a++){ 
OrderSelect(a,SELECT_BY_POS,MODE_TRADES); 
if(OrderSymbol()==Symbol()&&MagicNumber==OrderMagicNumber()&&OrderType()==OP_SELL){ 
total++; 
} 
} 
return(total); 
} 
/////////////////////////////////////////////////////////
 
   int ordestotal1_2(int type) 
{ 
int total_2=0; 
for(int b=0;b<OrdersTotal();b++){ 
OrderSelect(b,SELECT_BY_POS,MODE_TRADES); 
if(OrderSymbol()==Symbol()&&MagicNumber==OrderMagicNumber()&&OrderType()==type){ 
total_2++; 
} 
} 
return(total_2); 
} 


  double Lots(double risk)
   {
    double Lot;
    if(Auto.Lots)
       { 
        if(risk>1)risk=1;
        //_________________________________________________________________________________________
        double Min_Lot = MarketInfo(Symbol(), MODE_MINLOT);
        double Max_Lot = MarketInfo(Symbol(), MODE_MAXLOT);
        double lot_step= MarketInfo(Symbol(), MODE_LOTSTEP);
        Lot=NormalizeDouble(AccountBalance()*risk/100/10,2);
        Lot=NormalizeDouble(Lot,2);
        Lot=NormalizeDouble(Lot/lot_step,0)*lot_step;
        if (Lot < Min_Lot) Lot = Min_Lot; 
        if (Lot > Max_Lot) Lot = Max_Lot;
        //_________________________________________________________________________________________
       }
      else Lot=Lot1;
    return(Lot);
   }
   ////////////////////////////////////////////
      

 
  double pofet(){
 
 double pr;
 for(int p=0;p<OrdersTotal();p++){
 OrderSelect(p,SELECT_BY_POS,MODE_TRADES);
 
 pr=pr+OrderProfit();

 }return(pr);
 }
 ///////////////////////////////////////////////////// 
   void samir(string a_name_0, double a_corner_8, int a_y_16, int a_x_20, string a_text_24, int a_fontsize_32, string a_fontname_36, color a_color_44) {
   ObjectCreate(a_name_0, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(a_name_0, a_text_24, a_fontsize_32, a_fontname_36, a_color_44);
   ObjectSet(a_name_0, OBJPROP_CORNER, a_corner_8);
   ObjectSet(a_name_0, OBJPROP_XDISTANCE, a_x_20);
   ObjectSet(a_name_0, OBJPROP_YDISTANCE, a_y_16);
}

 
 
 void closeordar(int typer){
 for(int c=0;c<OrdersTotal();c++){
 OrderSelect(c,SELECT_BY_POS,MODE_TRADES);
 if(OrderMagicNumber()==MagicNumber&&OrderSymbol()==Symbol()&&OrderType()== typer){
 if(OrderType()==OP_BUY)OrderClose(OrderTicket(),OrderLots(),Bid,30);
 if(OrderType()==OP_SELL)OrderClose(OrderTicket(),OrderLots(),Ask,30);
 RefreshRates();
    }
   }
  }
  /////////////////////////////


