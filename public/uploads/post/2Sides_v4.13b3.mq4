#property copyright "Qimer"

extern string tx1="Общие настройки советника";
extern bool Info=true;
extern color MainInfoBack=LightGray;
extern color MainInfo=Black;
extern color BuyInfoBack=LightGray;
extern color BuyInfo=Black;
extern color SellInfoBack=LightGray;
extern color SellInfo=Black;
extern bool ShowZeroLevels=true;
extern bool UseVTP=true;
extern bool ManualTrade=false;
extern bool DynamicTP=true;
extern bool UseNewBar=true;
extern bool ZTP=false;
extern int ZTP_order=6;
extern int DaysBuffer=2;
extern int magicbuy=0;
extern int magicsell=0;
extern int magiclock=999;
extern color BuyColor=Blue;
extern color SellColor=Red;
extern string tx2="Настройки системы LOT";
extern bool LOT=true;
extern int nOrder=5;
extern int LO_TP=5;
extern int LO_Tral_Start=3;
extern int LO_Tral_Size=5;
extern int ProfitPercent=15;
extern color LOTColor=Purple;
extern string tx3="Время работы советника";
extern int StartHour=21;
extern int EndHour=4;
extern string tx4="Настройки MoneyManagement";
extern bool UseMM=true;
extern bool UseEquity=true;
extern double min_lot=0.1;
extern int MaxTrades=6;
extern int UseMoney=50;
extern int SL_Level=40;
extern bool DrawdownStop=false;
extern string tx5="Основные настройки";
extern bool CurrencyProfit=false;
extern double Profit=1.0;
extern int TP1=8;
extern int TP=8;
extern int TPstep=2;
extern int Tral_Start=5;
extern int Tral_Size=5;
extern color TralColor=Yellow;
extern int step=30;
extern double Step_coef=1;
extern double mult=2;
extern int slippage=3;
extern string tx6="Принудительное закрытие серий";
extern bool buyclose=false;
extern bool sellclose=false;
extern string tx7="Настройки индикатора Stochastic";
extern int StochTime=5;
extern int per_K=10;
extern int per_D=3;
extern int slow=3;
extern int S_Mode=0;
extern int S_Price=0;
extern int zoneBUY=15;
extern int zoneSELL=85;

int cnt,cu,dig,close_buy,close_sell,LO_close_buy,LO_close_sell;
double lotsbuy,lotssell,openpricebuy,openpricesell,lotsbuy2,lotssell2,lastlotbuy,lastlotsell,tpb,tps,mtpb,mtps,ztpb,ztps,LO_mtpb,LO_mtps,smbuy,smsell;
color col,colB,colS,LO_colB,LO_colS;
string txt1,txt2,txt3,txt4,txtVTP,txtLOT;
datetime NewBar_B,NewBar_S;

//====================================================================================================================== 
int init() 
   {
   }
int deinit() 
   {
   if (!IsTesting())
      {
      Comment("");
      ObjectDelete("SellTP"); ObjectDelete("BuyTP");
      ObjectDelete("SellZeroLevel"); ObjectDelete("BuyZeroLevel");
      ObjectDelete("SellLOT"); ObjectDelete("BuyLOT");
      ObjectDelete("Lable1"); ObjectDelete("Lable2"); ObjectDelete("Lable3");
      ObjectDelete("y_MainInfoBack1"); ObjectDelete("y_MainInfoBack2"); ObjectDelete("y_MainInfoBack3");
      ObjectDelete("z_MainInfo_1"); ObjectDelete("z_MainInfo_2"); ObjectDelete("z_MainInfo_3"); ObjectDelete("z_MainInfo_4"); ObjectDelete("z_MainInfo_5"); ObjectDelete("z_MainInfo_6"); ObjectDelete("z_MainInfo_7"); 
      ObjectDelete("z_BuyInfo_1");  ObjectDelete("z_BuyInfo_2");  ObjectDelete("z_BuyInfo_3");  ObjectDelete("z_BuyInfo_4");  ObjectDelete("z_BuyInfo_5");  ObjectDelete("z_BuyInfo_6");  ObjectDelete("z_BuyInfo_7"); 
      ObjectDelete("z_SellInfo_1"); ObjectDelete("z_SellInfo_2"); ObjectDelete("z_SellInfo_3"); ObjectDelete("z_SellInfo_4"); ObjectDelete("z_SellInfo_5"); ObjectDelete("z_SellInfo_6"); ObjectDelete("z_SellInfo_7"); 
      }
   }
                                                 int start() {
  
   double profitbuy=0;
   double profitsell=0;
   double TV=MarketInfo(Symbol(),MODE_TICKVALUE);
   double LOTStep = MarketInfo(Symbol(),MODE_LOTSTEP);
   double minLot = MarketInfo(Symbol(),MODE_MINLOT);
   double maxLot = MarketInfo(Symbol(),MODE_MAXLOT);
   double spread = MarketInfo(Symbol(),MODE_SPREAD);
   if (Digits==4 || Digits==2) cu=1; else cu=10;   // множитель для разных типов счетов 4/2 и 5/3
   if (LOTStep==0.01)dig=2;
   if (LOTStep==0.1) dig=1;
   int tral=Tral_Size*cu;
   int LO_tral=LO_Tral_Size*cu;
   int totb=Total_B();
   int tots=Total_S();
   double TPsell,TPbuy;
   smbuy=0;smsell=0;
   double LOtps=0,LOtpb=0;
   if (totb==0) {tpb=0; mtpb=0;LO_mtpb=0;ztpb=0;}
   if (tots==0) {tps=0; mtps=0;LO_mtps=0;ztps=0;}
   if (totb==1) TPbuy=TP1*cu; else TPbuy=TP*cu;
   if (tots==1) TPsell=TP1*cu; else TPsell=TP*cu;
   if (DynamicTP) 
      {
      TPbuy+=(totb-1)*TPstep*cu; 
      TPsell+=(tots-1)*TPstep*cu;
      }
   if (ZTP)
      {
      if (totb>=ZTP_order) TPbuy=0;
      if (tots>=ZTP_order) TPsell=0;
      }
   if (!UseMM && min_lot<minLot)
      {
      if (!IsTesting()) Alert("min_lot меньше возможного на данном счете");
      else Print("min_lot меньше возможного на данном счете");
      Sleep(3000);
      return(0);
      }

//==================================================== Вход по стохастику ==============================================
  
   if(totb==0 && time())
      { 
      if (Stochastic("buy") && !buyclose && !ManualTrade)
         {
         if (UseMM) 
            {
            lotsbuy=MM(mult,UseMoney,MaxTrades,step);
            if (lotsbuy<minLot) {TradeStop(); return(0);}
            }
         else lotsbuy=min_lot;
         RefreshRates();
         OrderSend(Symbol(),OP_BUY,NormalizeDouble(lotsbuy,dig),NormalizeDouble(Ask,Digits),slippage*cu,0,0,"1-й ордер Buy, "+magicbuy,magicbuy,0,BuyColor); NewBar_B=Time[0];
         }
      }

  if(tots==0 && time())
      {
      if (Stochastic("sell") && !sellclose && !ManualTrade)
         {
         if (UseMM) 
            {
            lotssell=MM(mult,UseMoney,MaxTrades,step);
            if (lotssell<minLot) {TradeStop(); return(0);}
            }
         else lotssell=min_lot;
         RefreshRates();
         OrderSend(Symbol(),OP_SELL,NormalizeDouble(lotssell,dig),NormalizeDouble(Bid,Digits),slippage*cu,0,0,"1-й ордер Sell, "+magicsell,magicsell,0,SellColor); NewBar_S=Time[0];
         }
      }

//======================================== Модуль обработки 2-х последних ордеров ======================================

if (LOT)
   {
   int LastOrdersBuy=0,LastOrdersSell=0;
   double LastOrdersBuyLots=0,LastOrdersBuyProfit=0,LastOrdersSellLots=0,LastOrdersSellProfit=0;

   for (cnt=OrdersTotal()-1;cnt>=0;cnt--)
      {
      if (OrderSelect(cnt,SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol())
         {
         if (OrderType() == OP_BUY && OrderMagicNumber()==magicbuy && totb>2 && LastOrdersBuy<2)
            {
            LastOrdersBuy++; 
            LastOrdersBuyLots+=OrderLots(); 
            LastOrdersBuyProfit+=OrderProfit()+OrderCommission()+OrderSwap();
            }
         if (OrderType() == OP_SELL && OrderMagicNumber()==magicsell && tots>2 && LastOrdersSell<2)
            {
            LastOrdersSell++; 
            LastOrdersSellLots+=OrderLots(); 
            LastOrdersSellProfit+=OrderProfit()+OrderCommission()+OrderSwap();
            }
         }
      }

//================================================= Расчет накопленного профита ========================================  
 
   int TimeB,TimeS,j;
   for (j=0;j<OrdersTotal();j++)
      {
      if (OrderSelect(j,SELECT_BY_POS,MODE_TRADES))
         {
         if (totb>0 && OrderMagicNumber()==magicbuy && OrderType()==OP_BUY && (OrderOpenTime()<TimeB || TimeB==0)) TimeB=OrderOpenTime();
         if (tots>0 && OrderMagicNumber()==magicsell && OrderType()==OP_SELL && (OrderOpenTime()<TimeS || TimeS==0)) TimeS=OrderOpenTime();
         }
      }
   
   int k=OrdersHistoryTotal()-1;
   double ProfitBuyN,ProfitSellN;
   double BalanceBuy=AccountBalance(),BalanceSell=AccountBalance();
   while(true)
      {
      if (!OrderSelect(k,SELECT_BY_POS,MODE_HISTORY)) break;
      if (OrderOpenTime()>TimeB) BalanceBuy-=OrderProfit();
      if (OrderOpenTime()>TimeS) BalanceSell-=OrderProfit();
      
      if (OrderSymbol()==Symbol())
         {
         if (OrderMagicNumber()==magicbuy && OrderType()==OP_BUY && totb>0 && OrderOpenTime()>TimeB) ProfitBuyN+=OrderProfit()+OrderSwap()+OrderCommission();
         if (OrderMagicNumber()==magicsell && OrderType()==OP_SELL && tots>0 && OrderOpenTime()>TimeS) ProfitSellN+=OrderProfit()+OrderSwap()+OrderCommission();
         }
      if ( (OrderOpenTime()<TimeB || totb==0) && (OrderOpenTime()<TimeS || tots==0) ) break;
      k--;
      }
   
//======================================================================================================================

   if (BalanceBuy>0) {double ProfitBuy=NormalizeDouble(ProfitBuyN/BalanceBuy*100,1);}
   if (BalanceSell>0) {double ProfitSell=NormalizeDouble(ProfitSellN/BalanceSell*100,1);}
   
   if (tots>=nOrder) LOtps = NormalizeDouble(Ask-((0-LastOrdersSellProfit)/(LastOrdersSellLots*TV)+(LO_TP+TPstep*(tots-1))*cu)*Point,Digits);
   if (totb>=nOrder) LOtpb = NormalizeDouble(Bid+((0-LastOrdersBuyProfit)/(LastOrdersBuyLots*TV)+(LO_TP+TPstep*(totb-1))*cu)*Point,Digits);
   if (LastOrdersBuyProfit<0)LO_mtpb=LOtpb;
   if (LastOrdersSellProfit<0)LO_mtps=LOtps;
   
//========================================== трейлинг 2х последних ордеров =============================================
      {
      if (totb>=nOrder && Bid>=LOtpb+(LO_Tral_Start)*cu*Point) LO_close_buy=1;      // при выходе цены за линию ТП меняем значение переменной   
      if (tots>=nOrder && Ask<=LOtps-(LO_Tral_Start)*cu*Point) LO_close_sell=1;     // на 1, которая считается триггером для включения трала
      if (LO_close_buy==1) LO_colB=LOTColor; else LO_colB=BuyColor;                 // и перекрашиваем линию ТП
      if (LO_close_sell==1) LO_colS=LOTColor; else LO_colS=SellColor;              

      if (totb>=nOrder && LO_colB==LOTColor)
         {
         if (Bid<=NormalizeDouble(LO_mtpb,Digits)){LO_close_buy=0;LO_mtpb=0;CloseLastOrdersBuy();}
         else if (LO_mtpb<(Bid-LO_tral*Point)) LO_mtpb=NormalizeDouble(Bid-LO_tral*Point,Digits);
         }
      if (tots>=nOrder && LO_colS==LOTColor)
         {
         if (Ask>=NormalizeDouble(LO_mtps,Digits)){LO_close_sell=0;LO_mtps=0;CloseLastOrdersSell();}
         else if (LO_mtps>(Ask+LO_tral*Point)) LO_mtps=NormalizeDouble(Ask+LO_tral*Point,Digits);
         }
      }
   }
//====================================================================================================================== 

  if(totb>0)
  {
    
  for (cnt=0;cnt<OrdersTotal();cnt++)
    {
    if (OrderSelect(cnt,SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderMagicNumber()==magicbuy) 
      {
      smbuy+=OrderLots();openpricebuy = OrderOpenPrice();lastlotbuy = OrderLots(); profitbuy+=OrderProfit()+OrderCommission()+OrderSwap();
      }
    }
   
   if (LOT && (ProfitBuyN+profitbuy)>=BalanceBuy*ProfitPercent/100) {closeBUYorders();}
   
   if (CurrencyProfit) 
      {
      double PrPB=BalanceBuy*Profit/100;
      tpb = NormalizeDouble(Bid+((0-(profitbuy-PrPB))/(smbuy*TV))*Point,Digits);
      }
   else tpb = NormalizeDouble(Bid+((0-profitbuy)/(smbuy*TV)+TPbuy)*Point,Digits);
   if (profitbuy<0)mtpb=tpb;
   ztpb = tpb-TPbuy*Point;



  
        if ((UseNewBar && NewBar_B!=Time[0]) || !UseNewBar) if(Ask<=openpricebuy-MathFloor(step*MathPow(Step_coef,totb-1)*cu)*Point && totb<MaxTrades)
          {

          lotsbuy2=lastlotbuy*mult; NewBar_B=Time[0];
            
            if (AccountFreeMarginCheck(Symbol(),OP_BUY,lotsbuy2)>0)
            {
            RefreshRates();
            OrderSend(Symbol(),OP_BUY,NormalizeDouble(lotsbuy2,dig),NormalizeDouble(Ask,Digits),slippage*cu,0,0,Total_B()+1+"-й ордер Buy, "+magicbuy,magicbuy,0,BuyColor);
            }
            
          }
      
   }

//======================================================================================================================

  if(tots>0)
  {

  for (cnt=0;cnt<OrdersTotal();cnt++)
    {
    if (OrderSelect(cnt,SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && OrderType() == OP_SELL && OrderMagicNumber()==magicsell)
      {
      smsell+=OrderLots();openpricesell = OrderOpenPrice();lastlotsell = OrderLots(); profitsell+=OrderProfit()+OrderCommission()+OrderSwap();
      }     
    }

   if (LOT && (ProfitSellN+profitsell)>=BalanceSell*ProfitPercent/100) {closeSELLorders();}

   if (CurrencyProfit) 
      {
      double PrPS=BalanceSell*Profit/100;
      tps = NormalizeDouble(Ask-((0-(profitsell-PrPS))/(smsell*TV))*Point,Digits);
      }
   else tps = NormalizeDouble(Ask-((0-profitsell)/(smsell*TV)+TPsell)*Point,Digits);
   if (profitsell<0)mtps=tps;
   ztps = tps+TPsell*Point;


        if ((UseNewBar && NewBar_S!=Time[0]) || !UseNewBar) if(Bid>=openpricesell+MathFloor(step*MathPow(Step_coef,tots-1)*cu)*Point && tots<MaxTrades)
          {
          lotssell2=lastlotsell*mult; NewBar_S=Time[0];
         
            if (AccountFreeMarginCheck(Symbol(),OP_SELL,lotssell2)>0)
            {
            RefreshRates();
            OrderSend(Symbol(),OP_SELL,NormalizeDouble(lotssell2,dig),NormalizeDouble(Bid,Digits),slippage*cu,0,0,Total_S()+1+"-й ордер Sell, "+magicsell,magicsell,0,SellColor);
            }

          }
      
   }

//====================================== модуль выставления ТейкПрофита ================================================
if (!UseVTP) {
for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--)

    {
    if (!OrderSelect(cnt,SELECT_BY_POS, MODE_TRADES)) continue;
    if (OrderSymbol() != Symbol()) continue;

    if (OrderType() == OP_BUY && OrderMagicNumber()==magicbuy) 
      {
      if (MathAbs((OrderTakeProfit()-tpb)/Point)>cu) 
      OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(tpb,Digits),0);

      }
    if (OrderType() == OP_SELL && OrderMagicNumber()==magicsell) 
      {
      if (MathAbs((OrderTakeProfit()-tps)/Point)>cu)
      OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(tps,Digits),0);            

      }
    }
}

//======================================================================================================================
if (UseVTP)                                                       // В режиме VTP
   {
   if (totb>0 && Bid>=tpb+(Tral_Start)*cu*Point) close_buy=1;     // при выходе цены за линию ТП меняем значение переменной   
   if (tots>0 && Ask<=tps-(Tral_Start)*cu*Point) close_sell=1;    // на 1, которая считается триггером для включения трала
   if (close_buy==1) colB=TralColor; else colB=BuyColor;          // и перекрашиваем линию ТП
   if (close_sell==1) colS=TralColor; else colS=SellColor;        

   if (totb>0 && colB==TralColor)
      {
      if (Bid<=NormalizeDouble(mtpb,Digits)){closeBUYorders(); close_buy=0;}
      else if (mtpb<(Bid-tral*Point)) mtpb=NormalizeDouble(Bid-tral*Point,Digits);
      }
   if (tots>0 && colS==TralColor)
      {
      if (Ask>=NormalizeDouble(mtps,Digits)){closeSELLorders(); close_sell=0;}
      else if (mtps>(Ask+tral*Point)) mtps=NormalizeDouble(Ask+tral*Point,Digits);
      }
   }

//======================================================================================================================

if (buyclose && Total_B()!=0)closeBUYorders();
if (sellclose && Total_S()!=0)closeSELLorders();
if (profitbuy+profitsell<0) double dd=MathAbs(profitbuy+profitsell)/(AccountEquity()-(profitbuy+profitsell))*100;
if (DrawdownStop && dd>=SL_Level) 
   {
   if (Total_B()>0) closeBUYorders(); 
   if (Total_S()>0) closeSELLorders();
   }

//======================================================================================================================
if(!IsTesting() || IsVisualMode())
   {
   if(!Info)
      {
      ObjectDelete("Lable1"); ObjectDelete("Lable2"); ObjectDelete("Lable3");
      ObjectDelete("y_MainInfoBack1"); ObjectDelete("y_MainInfoBack2"); ObjectDelete("y_MainInfoBack3");
      ObjectDelete("z_MainInfo_1"); ObjectDelete("z_MainInfo_2"); ObjectDelete("z_MainInfo_3"); ObjectDelete("z_MainInfo_4"); ObjectDelete("z_MainInfo_5"); ObjectDelete("z_MainInfo_6"); ObjectDelete("z_MainInfo_7"); 
      ObjectDelete("z_BuyInfo_1");  ObjectDelete("z_BuyInfo_2");  ObjectDelete("z_BuyInfo_3");  ObjectDelete("z_BuyInfo_4");  ObjectDelete("z_BuyInfo_5");  ObjectDelete("z_BuyInfo_6");  ObjectDelete("z_BuyInfo_7"); 
      ObjectDelete("z_SellInfo_1"); ObjectDelete("z_SellInfo_2"); ObjectDelete("z_SellInfo_3"); ObjectDelete("z_SellInfo_4"); ObjectDelete("z_SellInfo_5"); ObjectDelete("z_SellInfo_6"); ObjectDelete("z_SellInfo_7"); 
      }
   else
      { //изменение цвета при уменьшении "СРЕДСТВА" относительно "БАЛАНС"
      int Balans = NormalizeDouble( AccountBalance(),0);
      int Sredstva = NormalizeDouble(AccountEquity(),0);  
      if (Sredstva >= Balans/6*5) col = DodgerBlue; 
      if (Sredstva >= Balans/6*4 && Sredstva < Balans/6*5)col = DeepSkyBlue;
      if (Sredstva >= Balans/6*3 && Sredstva < Balans/6*4)col = Gold;
      if (Sredstva >= Balans/6*2 && Sredstva < Balans/6*3)col = OrangeRed;
      if (Sredstva >= Balans/6   && Sredstva < Balans/6*2)col = Crimson;
      if (Sredstva <  Balans/5                           )col = Red;
      //------------------------- 

      ObjectCreate("Lable1",OBJ_LABEL,0,0,1.0);
         ObjectSet("Lable1", OBJPROP_CORNER, 3);
         ObjectSet("Lable1", OBJPROP_XDISTANCE, 10);
         ObjectSet("Lable1", OBJPROP_YDISTANCE, 51);
         txt1=(DoubleToStr(AccountBalance(), 0));
         ObjectSetText("Lable1","БАЛАНС     "+txt1+"",12,"Times New Roman",DodgerBlue);
         //-------------------------   

      ObjectCreate("Lable2",OBJ_LABEL,0,0,1.0);
         ObjectSet("Lable2", OBJPROP_CORNER, 3);
         ObjectSet("Lable2", OBJPROP_XDISTANCE, 10);
         ObjectSet("Lable2", OBJPROP_YDISTANCE, 31);
         txt2=(DoubleToStr(AccountEquity(), 0));
         ObjectSetText("Lable2","СРЕДСТВА     "+txt2+"",12,"Times New Roman",col);
         //-------------------------   

      ObjectCreate("Lable3",OBJ_LABEL,0,0,1.0);
         ObjectSet("Lable3", OBJPROP_CORNER, 3);
         ObjectSet("Lable3", OBJPROP_XDISTANCE, 10);
         ObjectSet("Lable3", OBJPROP_YDISTANCE, 11);
         txt4=DoubleToStr(dd,1)+"%";
         ObjectSetText("Lable3","ПРОСАДКА     "+txt4+"",12,"Times New Roman",Green);
   
      string spips; 
      int pips;
      double stopout_balance=AccountBalance()*AccountStopoutLevel()/100;
      if (MathAbs(smbuy-smsell)>0) pips=NormalizeDouble((AccountEquity()-stopout_balance)/MathAbs(smbuy-smsell)/TV,0);
      if (smbuy>smsell) spips="До слива "+pips+" пунктов вниз";
      if (smbuy<smsell) spips="До слива "+pips+" пунктов вверх";
      if (smbuy==smsell) {if (smbuy==0) spips="Нет ордеров"; else spips="Лок";}
      if (UseVTP) txtVTP="Режим VTP вкл. "; 
             else txtVTP="Режим VTP выкл.";
      if (LOT)    txtLOT="Режим LOT вкл. "; 
             else txtLOT="Режим LOT выкл.";
  
      int x1,y1,x2,y2,x3,y3;
      if (ObjectFind("y_MainInfoBack1")==-1) Text("y_MainInfoBack1","gggg",58,"Webdings",0,0,MainInfoBack);
      if (ObjectFind("y_MainInfoBack2")==-1) Text("y_MainInfoBack2","gggg",58,"Webdings",320,0,BuyInfoBack);
      if (ObjectFind("y_MainInfoBack3")==-1) Text("y_MainInfoBack3","gggg",58,"Webdings",640,0,SellInfoBack);

      x1 =ObjectGet("y_MainInfoBack1",OBJPROP_XDISTANCE);
      y1 =ObjectGet("y_MainInfoBack1",OBJPROP_YDISTANCE);
      x2 =ObjectGet("y_MainInfoBack2",OBJPROP_XDISTANCE);
      y2 =ObjectGet("y_MainInfoBack2",OBJPROP_YDISTANCE);
      x3 =ObjectGet("y_MainInfoBack3",OBJPROP_XDISTANCE);
      y3 =ObjectGet("y_MainInfoBack3",OBJPROP_YDISTANCE);
   
      Text("z_MainInfo_1",txtVTP,9,"Arial Black",x1+20,y1+6,MainInfo);
      Text("z_MainInfo_2",txtLOT,9,"Arial Black",x1+165,y1+6,MainInfo);
      Text("z_MainInfo_3","мин.лот:  "+DoubleToStr(minLot,2),9,"Arial Black",x1+20,y1+21,MainInfo);
      Text("z_MainInfo_4","макс.лот:  "+DoubleToStr(maxLot,0),9,"Arial Black",x1+165,y1+21,MainInfo);
      Text("z_MainInfo_5","спред:  "+DoubleToStr(spread,0)+"п",9,"Arial Black",x1+20,y1+36,MainInfo);
      Text("z_MainInfo_6","плечо:  1:"+DoubleToStr(AccountLeverage(),0),9,"Arial Black",x1+165,y1+36,MainInfo);
      Text("z_MainInfo_7",spips,9,"Arial Black",x1+20,y1+51,MainInfo);
   
      Text("z_BuyInfo_1","BUY",9,"Arial Black",x2+130,y2+6,BuyInfo);
      Text("z_BuyInfo_2","Ордеров:  "+DoubleToStr(Total_B(),0),9,"Arial Black",x2+20,y2+21,BuyInfo);
      Text("z_BuyInfo_3","Объем:  "+DoubleToStr(smbuy,2),9,"Arial Black",x2+165,y2+21,BuyInfo);
      Text("z_BuyInfo_4","Ур.TP:  "+DoubleToStr(tpb,Digits),9,"Arial Black",x2+20,y2+36,BuyInfo);
      Text("z_BuyInfo_5","Ур.LOTP:  "+DoubleToStr(LOtpb,Digits),9,"Arial Black",x2+165,y2+36,BuyInfo);
      Text("z_BuyInfo_6","Профит:  "+DoubleToStr(profitbuy,2),9,"Arial Black",x2+20,y2+51,BuyInfo);
      if (LOT) Text("z_BuyInfo_7","Нак.профит:  "+DoubleToStr(ProfitBuy,1)+"%",9,"Arial Black",x2+165,y2+51,BuyInfo);
   
      Text("z_SellInfo_1","SELL",9,"Arial Black",x3+125,y3+6,SellInfo);
      Text("z_SellInfo_2","Ордеров:  "+DoubleToStr(Total_S(),0),9,"Arial Black",x3+20,y3+21,SellInfo);
      Text("z_SellInfo_3","Объем:  "+DoubleToStr(smsell,2),9,"Arial Black",x3+165,y3+21,SellInfo);
      Text("z_SellInfo_4","Ур.TP:  "+DoubleToStr(tps,Digits),9,"Arial Black",x3+20,y3+36,SellInfo);
      Text("z_SellInfo_5","Ур.LOTP:  "+DoubleToStr(LOtps,Digits),9,"Arial Black",x3+165,y3+36,SellInfo);
      Text("z_SellInfo_6","Профит:  "+DoubleToStr(profitsell,2),9,"Arial Black",x3+20,y3+51,SellInfo);
      if (LOT) Text("z_SellInfo_7","Нак.профит:  "+DoubleToStr(ProfitSell,1)+"%",9,"Arial Black",x3+165,y3+51,SellInfo);
      }
   }
//======================================================================================================================
   
if (!IsTesting()) 
   {
   for (int i=ObjectsTotal()-1;i>=0;i--)
      {
      string ObName=ObjectName(i);
      if (ObjectGet(ObName,OBJPROP_TIME1)>0 && ObjectGet(ObName,OBJPROP_TIME1)<(Time[0]-DaysBuffer*86400)) ObjectDelete(ObName);     // удаление устаревших объектов
      }
   }
   
if (!IsTesting() || IsVisualMode()) 
   {
   ObjectDelete("SellTP");
   ObjectDelete("BuyTP");
   ObjectDelete("SellZeroLevel");
   ObjectDelete("BuyZeroLevel");
   ObjectDelete("SellLOT");
   ObjectDelete("BuyLOT");
   
   if (UseVTP) 
      {
      ObjectCreate("SellTP",OBJ_HLINE, 0, 0,mtps-spread*Point);
      ObjectSet("SellTP", OBJPROP_COLOR, colS);
      ObjectSet("SellTP", OBJPROP_WIDTH, 2);
      ObjectSet("SellTP", OBJPROP_RAY, False);
  
      ObjectCreate("BuyTP",OBJ_HLINE, 0, 0,mtpb);
      ObjectSet("BuyTP", OBJPROP_COLOR, colB);
      ObjectSet("BuyTP", OBJPROP_WIDTH, 2);
      ObjectSet("BuyTP", OBJPROP_RAY, False);
      }

   if (LOT) 
      {
      ObjectCreate("SellLOT",OBJ_HLINE, 0, 0,LO_mtps-spread*Point);
      ObjectSet("SellLOT", OBJPROP_COLOR, LO_colS);
      ObjectSet("SellLOT", OBJPROP_WIDTH, 3);
      ObjectSet("SellLOT", OBJPROP_RAY, False);

      ObjectCreate("BuyLOT",OBJ_HLINE, 0, 0,LO_mtpb);
      ObjectSet("BuyLOT", OBJPROP_COLOR, LO_colB);
      ObjectSet("BuyLOT", OBJPROP_WIDTH, 3);
      ObjectSet("BuyLOT", OBJPROP_RAY, False);
      }

   if (ShowZeroLevels) 
      {
      ObjectCreate("SellZeroLevel",OBJ_HLINE, 0, 0,ztps-spread*Point);
      ObjectSet("SellZeroLevel", OBJPROP_COLOR, SellColor);
      ObjectSet("SellZeroLevel", OBJPROP_WIDTH, 0);
      ObjectSet("SellZeroLevel", OBJPROP_RAY, False);

      ObjectCreate("BuyZeroLevel",OBJ_HLINE, 0, 0,ztpb);
      ObjectSet("BuyZeroLevel", OBJPROP_COLOR, BuyColor);
      ObjectSet("BuyZeroLevel", OBJPROP_WIDTH, 0);
      ObjectSet("BuyZeroLevel", OBJPROP_RAY, False);
      }
   }

return(0);
}  

//====================================================== Функции =======================================================

                                bool time()
 {
   if (StartHour<EndHour) 
      {if (Hour()>=StartHour && Hour()<EndHour) return(true); else return(false);}
   if (StartHour>EndHour) 
      {if (Hour()>=EndHour && Hour()<StartHour) return(false); else return(true);}
 }
//======================================================================================================================
                                int Total_B()                   
 {
   int j,r;
   for (r=0;r<OrdersTotal();r++) {
     if(OrderSelect(r,SELECT_BY_POS,MODE_TRADES) && OrderSymbol() == Symbol() && OrderType()==OP_BUY  && OrderMagicNumber()==magicbuy) j++;
   }   
 return(j); 
 }
//======================================================================================================================
                                int Total_S()
{
   int d,n;
   for (n=0;n<OrdersTotal();n++) {
     if(OrderSelect(n,SELECT_BY_POS,MODE_TRADES)  && OrderSymbol() == Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==magicsell) d++;
   }    
 return(d);
  }     

//======================================================================================================================

                                 bool Stochastic (string SMode)
{
   double sM0 = iStochastic(Symbol(),StochTime,per_K,per_D,slow,S_Mode,S_Price,MODE_MAIN,0);
   double sM1 = iStochastic(Symbol(),StochTime,per_K,per_D,slow,S_Mode,S_Price,MODE_MAIN,1);
   double sS0 = iStochastic(Symbol(),StochTime,per_K,per_D,slow,S_Mode,S_Price,MODE_SIGNAL,0);
   double sS1 = iStochastic(Symbol(),StochTime,per_K,per_D,slow,S_Mode,S_Price,MODE_SIGNAL,1);
   if (SMode=="buy" && sS0<zoneBUY && sM0<zoneBUY && sM1<sS1 && sM0>=sS0) return(true);
   if (SMode=="sell" && sS0>zoneSELL && sM0>zoneSELL && sM1>sS1 && sM0<=sS0) return(true);
   return(false);
}


//======================================================================================================================

                                    void closeBUYorders()
{
   int SellTicket,t;
   while(true) 
      {
      t=OrderSend(Symbol(),OP_SELL,NormalizeDouble(smbuy,dig),NormalizeDouble(Bid,Digits),slippage*cu,0,0,"лок-ордер для Buy, "+magiclock,magiclock,0,BuyColor);
      while(IsTradeContextBusy()) Sleep(100);
      if (t>0) break;
      }
   while(Total_B()>0)
      {
      for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) 
         {
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES) && OrderSymbol() == Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==magiclock) {SellTicket=OrderTicket(); break;}
         }
      for (cnt=OrdersTotal()-1;cnt>=0;cnt--)
         {
         if (OrderSelect(cnt,SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderMagicNumber()==magicbuy)
            {
            OrderCloseBy(OrderTicket(),SellTicket,BuyColor); 
            while(IsTradeContextBusy()) Sleep(100);
            break;
            }
         }
      }
}

//======================================================================================================================
                                    void closeSELLorders()
{
   int BuyTicket,t;
   while(true) 
      {
      t=OrderSend(Symbol(),OP_BUY,NormalizeDouble(smsell,dig),NormalizeDouble(Ask,Digits),slippage*cu,0,0,"лок-ордер для Sell, "+magiclock,magiclock,0,SellColor);
      while(IsTradeContextBusy()) Sleep(100);
      if (t>0) break;
      }
   while(Total_S()>0)
      {
      for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) 
         {
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES) && OrderSymbol() == Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==magiclock) {BuyTicket=OrderTicket(); break;}
         }
      for (cnt=OrdersTotal()-1;cnt>=0;cnt--)
         {
         if (OrderSelect(cnt,SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && OrderType() == OP_SELL && OrderMagicNumber()==magicsell)
            {
            OrderCloseBy(OrderTicket(),BuyTicket,SellColor);
            while(IsTradeContextBusy()) Sleep(100);
            break;
            }
         }
      }
}

//======================================================================================================================
                                    double CloseLastOrdersBuy()
{
   int cntb=0,ticket[3],t;
   double lot;
   bool chb=false;

   for (cnt=OrdersTotal()-1;cnt>=0;cnt--)
      {
      if (OrderSelect(cnt,SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderMagicNumber()==magicbuy)
         {
         cntb++; lot+=OrderLots();
         ticket[cntb]=OrderTicket();
         if (cntb==2) break;
         }
      }
   
   while(true)
      {
      while(IsTradeContextBusy()) Sleep(100);
      RefreshRates();
      t=OrderSend(Symbol(),OP_SELL,NormalizeDouble(lot,dig),NormalizeDouble(Bid,Digits),slippage*cu,0,0,"лок-ордер для Buy, "+magiclock,magiclock,0,BuyColor);
      if (t>0) break;
      }

   while(!chb)
      {
      chb=OrderCloseBy(ticket[1],t,BuyColor);
      while(IsTradeContextBusy()) Sleep(100);
      }
   chb=false;
   
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) 
      {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES) && OrderSymbol() == Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==magiclock) {t=OrderTicket(); break;}
      }
   while(!chb)
      {
      chb=OrderCloseBy(ticket[2],t,BuyColor);
      while(IsTradeContextBusy()) Sleep(100);
      }

   return(0);
}

//======================================================================================================================
                                    double CloseLastOrdersSell()
{
   int cnts=0,ticket[3],t;
   double lot;
   bool chs=false;

   for (cnt=OrdersTotal()-1;cnt>=0;cnt--)
      {
      if (OrderSelect(cnt,SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && OrderType() == OP_SELL && OrderMagicNumber()==magicsell)
         {
         cnts++; lot+=OrderLots();
         ticket[cnts]=OrderTicket();
         if (cnts==2) break;
         }
      }
   
   while(t==0) 
      {
      while(IsTradeContextBusy()) Sleep(100);
      RefreshRates();
      t=OrderSend(Symbol(),OP_BUY,NormalizeDouble(lot,dig),NormalizeDouble(Ask,Digits),slippage*cu,0,0,"лок-ордер для Sell, "+magiclock,magiclock,0,SellColor);
      if (t>0) break;
      }

   while(!chs)
      {
      chs=OrderCloseBy(ticket[1],t,SellColor);
      while(IsTradeContextBusy()) Sleep(100);
      }
   chs=false;
   
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) 
      {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES) && OrderSymbol() == Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==magiclock) {t=OrderTicket(); break;}
      }

   while(!chs)
      {
      chs=OrderCloseBy(ticket[2],t,SellColor);
      while(IsTradeContextBusy()) Sleep(100);
      }

   return(0);
}


//====================================================== блок ММ =======================================================
   double MM(double mult1, int UM, int MaxTrades1,int step1) 
      {
      double trade_vol=1;
      double sum_vol=1;
      double MaxDrawdown;
      double maxLot=MarketInfo(Symbol(),MODE_MAXLOT);
      double minLot=MarketInfo(Symbol(),MODE_MINLOT);
      double margin=MarketInfo(Symbol(),MODE_MARGINREQUIRED);
      double    TV1=MarketInfo(Symbol(),MODE_TICKVALUE);
      int cnt2,cnt3;
      double marginsum,points;
      
      for (cnt2=MaxTrades1; cnt2>=1;cnt2--) 
         {
         points=0;
         for (cnt3=MaxTrades1-cnt2; cnt3<MaxTrades1; cnt3++)
            {
            points+=NormalizeDouble(step*MathPow(Step_coef,cnt3),0);
            }
         MaxDrawdown+=trade_vol*(points*cu)*TV1;                                      // расчет максимальной просадки при объеме 1-го ордера в 1.00 лот
         sum_vol+=trade_vol;
         trade_vol*=mult1;

         }
      marginsum=margin*sum_vol;
      double depo;
      if (UseEquity) depo=AccountEquity(); else depo=AccountBalance();
      double lot=NormalizeDouble(((depo+AccountCredit())*UM/100)/(MaxDrawdown+marginsum),dig);  // расчет максимального объема для 1-го ордера серии
      
      if (lot*sum_vol>maxLot) lot=NormalizeDouble(maxLot/sum_vol,dig);                    // проверка на максимально возможный объем 1-го ордера серии
      return(lot);
      }

//======================================================================================================================

                        void TradeStop()
   {
   int cnt2,cnt3;
   double trade_vol=1,points;
   double sum_vol=1;
   double MaxDrawdown,marginsum;
   double minLot=MarketInfo(Symbol(),MODE_MINLOT);
   double margin=MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   double    TV1=MarketInfo(Symbol(),MODE_TICKVALUE);
   
      for (cnt2=MaxTrades; cnt2>=1;cnt2--)
         {
         points=0;
         for (cnt3=MaxTrades-cnt2; cnt3<MaxTrades; cnt3++)
            {
            points+=NormalizeDouble(step*MathPow(Step_coef,cnt3),0);
            }
         MaxDrawdown+=trade_vol*(points*cu)*TV1;
         sum_vol+=trade_vol;
         trade_vol*=mult;
         }
      marginsum=margin*sum_vol;
   double deposit=minLot*(MaxDrawdown+marginsum)/UseMoney*100;
   if (!IsTesting()) Alert("Недостаточно средств, необходимо ",deposit," ед.");
   if (IsTesting()) Print(lotsbuy," Недостаточно средств, необходимо ",deposit," ед."); 
   }

//======================================================================================================================

                  void Text(string name, string text, int size, string font, int xd, int yd, color colT)
{
   int w=WindowFind("2SS"); if (w==-1) w=0;
   if (ObjectFind("y_MainInfoBack1")!=w) ObjectDelete("y_MainInfoBack1");
   if (ObjectFind("y_MainInfoBack2")!=w) ObjectDelete("y_MainInfoBack2");
   if (ObjectFind("y_MainInfoBack3")!=w) ObjectDelete("y_MainInfoBack3");
   if (ObjectFind(name)==0 && w!=0) ObjectDelete(name);
   ObjectCreate(name, OBJ_LABEL, w,0,0);
   ObjectSetText(name, text, size, font);
   ObjectSet(name, OBJPROP_XDISTANCE, xd);
   ObjectSet(name, OBJPROP_YDISTANCE, yd);      
   ObjectSet(name, OBJPROP_COLOR, colT);
   ObjectSet(name, OBJPROP_BACK, false);

}