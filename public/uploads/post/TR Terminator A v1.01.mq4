//+------------------------------------------------------------------+ 
//|                                             Terminator v2.02.mq4 | 
//+------------------------------------------------------------------+
//|                                             Terminator v2.02.mq4 |
//|          Copyright © 2005,2006 Alejandro Galindo and Tom Maneval |
//|                                              http://elCactus.com |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2005,2006 Alejandro Galindo and Tom Maneval"
#property link      "http://elCactus.com"


extern bool reverse=false;           // If one the decision to go long/short will be reversed
extern int magic=666;                // Magic number for the orders placed
extern int manual=0;                 // If set to one then it will not open trades automatically

extern string moneymanagement="Money Management";

extern double lots=0.1;              // We start with this lots number
extern double lotincrement=1.618;    // We increase each lot position by this factor (Fibo default 1.618)
extern double lotsaddition=0.04;      // Lots to add to the previous lots if number of orders over stoplevel
extern double minlot=0.1;            // minimum lots size
extern double maxlot=100;            // maximum lots size
extern int lotdigits=2;              // Lot precision (to the right of decimal pt)allowed by your trade server.
                                     // If your broker only allows 0.1 lots and not 0.15 lots for example, leave this setting as 1
extern int mm=0;                     // If one the lots size will increase based on accountorders size
extern double risk=0.1;              // Risk to calculate the lots size (only if mm is enabled)
extern int allsymbolsprotect=0;      // If one will check profit from all symbols, if zero only this symbol
extern int accountordersisnormal=1;  // Zero if accountorders is not mini/micro, one if it is a mini/micro
extern int secureprofit=200;         // If profit made is bigger than secureprofit we close the orders
extern int accountordersprotection=1;// If one the accountorders protection will be enabled, 0 is disabled
extern int orderstoprotect=3;        // This number subtracted from maxorders is the number of open orders to enable the accountorders protection.
                                     // Example: (maxorders=10) minus (orderstoprotect=3)=7 orders need to be open before accountorders protection is enabled.

extern string ordersmanagement="Order Management";

extern int maxorders=40;             // Maximum number of orders to open
extern int pips=6;                   // Distance in pips from one order to another
extern bool autopips=true;           // Automated pips distance between orders
extern double autopipspercent1=40;   // First percentage of maxorders for autopips 1
extern double autopipspercent2=25;   // Second percentage of maxorders for autopips 2
extern double autopipspercent3=25;   // Third percentage of maxorders for autopips 3
extern double autopipspercent4=10;   // Fourth percentage of maxorders for autopips 4
extern int autopips1=6;              // auto pips for the first percentage of orders
extern int autopips2=8;              // auto pips for the second percentage of orders
extern int autopips3=10;             // auto pips for the third percentage of orders
extern int autopips4=15;             // auto pips for the fourth percentage of orders
extern int stoplevel=6;              // If total number of orders over stoplevel, we use lotsaddition instead of lotincrement
extern int stoploss=0;               // Stoploss
extern int takeprofit=35;            // Profit goal for the first orders opened
extern int takeprofit7th=35;         // Profit goal for the seventh order opened
extern int takeprofit8th=35;         // Profit goal for the eighth order opened
extern int takeprofit9th=38;         // Profit goal for the nineth order opened
extern int takeprofit10th=42;        // Profit goal for the tenth order opened
extern int takeprofit11th=45;        // Profit goal from the eleventh order opened
extern int tpincrement=5;            // Tpincrement to use for the takeprofit from 11th position
extern int trailingstop=0;           // Pips to trail the stoploss

extern string entrylogics="Entry Logics";

extern int macdast=14;
extern int macdslow=26;
extern int macdsma=9;

//int accountnumber=1622887;

int openorders=0,cnt=0;
int slippage=3;
double sl=0,tp=0;
double buyprice=0,sellprice=0;
double lotsi=0,mylotsi=0;
int mode=0,myordertype=0;
bool continueopening=True;
double lastprice=0;
int previousopenorders=0;
double profit=0;
int lastticket=0,lasttype=0;
double lastcloseprice=0,lastlots=0;
double pivot=0;
double pipvalue=0;
bool reversed=False;
string text="";
double tmp=0;
double itmph=0;
double itmpl=0;
int magic2;

int dg,mt;
double pt;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+

int init(){
   dg=Digits;
   if(Digits==3 || Digits==5){pt=Point*10;mt=10;}else{pt=Point;mt=1;}
   if(magic==666)magic2=999;
   if(magic==999)magic2=666;
   return(0);
}

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+

int deinit(){
   return(0);
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+

int start(){
   //if(AccountNumber()!=accountnumber)return(0);
   if(accountordersisnormal==1){
	   if(mm!=0){lotsi=MathCeil(AccountBalance()*risk/10000);}
		else{lotsi=lots;}
   }else{
   if(mm!=0){lotsi=MathCeil(AccountBalance()*risk/10000)/10;}
		else{lotsi=lots;}
   }
   if(autopips){
      if(countorders(magic)>=0)pips=autopips1;
      if(countorders(magic)>NormalizeDouble(maxorders*autopipspercent1*0.01,0))pips=autopips2;
      if(countorders(magic)>NormalizeDouble(maxorders*(autopipspercent1+autopipspercent2)*0.01,0))pips=autopips3;
      if(countorders(magic)>NormalizeDouble(maxorders*(autopipspercent1+autopipspercent2+autopipspercent3)*0.01,0))pips=autopips4;
   }
   openorders=0;
   for(cnt=0;cnt<OrdersTotal();cnt++){
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
	   if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic){
	  	   openorders++;
	   }
   }
   double pipvalue=MarketInfo(Symbol(),MODE_TICKVALUE);
   if(pipvalue==0){pipvalue=5;}
   if(previousopenorders>openorders){
      for(cnt=OrdersTotal()-1;cnt>=0;cnt--){
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
	  	   mode=OrderType();
		   if((OrderSymbol()==Symbol() && OrderMagicNumber()==magic) || allsymbolsprotect==1){
			   if(mode==OP_BUY){OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slippage*mt,Blue);}
			   if(mode==OP_SELL){OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slippage*mt,Red);}
			   return(0);
		   }
	   }
   }
   previousopenorders=openorders;
   if(openorders>=maxorders){
      continueopening=False;
   }else{
	   continueopening=True;
   }
   if(lastprice==0){
	   for(cnt=0;cnt<OrdersTotal();cnt++){	
	      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
		   mode=OrderType();
		   if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic){
			   lastprice=OrderOpenPrice();
			   if(mode==OP_BUY){myordertype=2;}
			   if(mode==OP_SELL){myordertype=1;}
		   }
	   }
   }
   if(openorders<1 && manual==0){
      myordertype=openordersbasedonmacd();
      if(reverse==true){
	  	   if(myordertype==1){myordertype=2;}
         else{if(myordertype==2){myordertype=1;}}
	   }
      if(count(OP_BUY,magic2)>1 && myordertype==2)myordertype=1;
      if(count(OP_SELL,magic2)>1 && myordertype==1)myordertype=2;
   }
   
   if(countorders(magic)>6)takeprofit=takeprofit7th;
   if(countorders(magic)>7)takeprofit=takeprofit8th;
   if(countorders(magic)>8)takeprofit=takeprofit9th;
   if(countorders(magic)>9)takeprofit=takeprofit10th;
   if(countorders(magic)>10)takeprofit=takeprofit11th+((countorders(magic)-10)*tpincrement);

   cnt=OrdersTotal();
   while(cnt>=0){
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
	   if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic){
         Print("Ticket ",OrderTicket()," modified.");
	  	   if(OrderType()==OP_SELL){
            if(trailingstop>0){
               if((OrderOpenPrice()-Ask)>=(trailingstop*pt+pips*pt)){
                  if(OrderStopLoss()>(Ask+pt*trailingstop) || OrderStopLoss()==0){
                     OrderModify(OrderTicket(),OrderOpenPrice(),Ask+pt*trailingstop,OrderClosePrice()-takeprofit*pt-trailingstop*pt,0,Purple);
	  					   return(0);
	  				   }
	  			   }
			   }
	  	   }
	  	   if(OrderType()==OP_BUY){
	  		   if(trailingstop>0){
			      if((Bid-OrderOpenPrice())>=(trailingstop*pt+pips*pt)){
					   if(OrderStopLoss()<(Bid-pt*trailingstop)){
                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-pt*trailingstop,OrderClosePrice()+takeprofit*pt+trailingstop*pt,0,Yellow);
                     return(0);
					   }
  				   }
			   }
	  	   }
   	}
      cnt--;
   }
   if(openorders>=(maxorders-orderstoprotect) && accountordersprotection==1){
	   profit=0;
      lastticket=0;
	   lasttype=0;
	   lastcloseprice=0;
	   lastlots=0;	
	   for(cnt=0;cnt<OrdersTotal();cnt++){
	      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
		   if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic){
			   lastticket=OrderTicket();
			   if(OrderType()==OP_BUY){lasttype=OP_BUY;}
			   if(OrderType()==OP_SELL){lasttype=OP_SELL;}
			   lastcloseprice=OrderClosePrice();
			   lastlots=OrderLots();
			   if(lasttype==OP_BUY){
				   if(OrderClosePrice()<OrderOpenPrice())
					{profit=profit-(OrderOpenPrice()-OrderClosePrice())*OrderLots()/pt;}
				   if(OrderClosePrice()>OrderOpenPrice())
					{profit=profit+(OrderClosePrice()-OrderOpenPrice())*OrderLots()/pt;}
			   }
			   if(lasttype==OP_SELL){
				   if(OrderClosePrice()>OrderOpenPrice())
					{profit=profit-(OrderClosePrice()-OrderOpenPrice())*OrderLots()/pt;}
				   if(OrderClosePrice()<OrderOpenPrice())
					{profit=profit+(OrderOpenPrice()-OrderClosePrice())*OrderLots()/pt;}
			   }
	  	   }
	   }
	   profit=profit*pipvalue;
	   if(allsymbolsprotect==1){tmp=AccountBalance();}
	   else{tmp=secureprofit;}
	   if(profit>=tmp){
	      OrderClose(lastticket,lastlots,lastcloseprice,slippage*mt,Yellow);		 
		   continueopening=False;
		   return(0);
	   }
   }
   if(!IsTesting()){
	   if(myordertype==3){text="No conditions to open trades";}
	   else{text="                         ";}
	   Comment("lastprice=",lastprice," Previous open orders=",previousopenorders,"\nContinue opening=",continueopening," OrderType=",myordertype,"\nlots=",lotsi,"\n",text);
   }
   double lastlotsSize=0;
   int cnt=0;

   for(cnt=0;cnt<OrdersTotal();cnt++){
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderCloseTime()==0) {
         lastlotsSize=OrderLots();
      }
   }
   if(myordertype==1 && continueopening){	
	   if((Bid-lastprice)>=pips*pt || openorders<1){
		   sellprice=Bid;
		   lastprice=0;
		   if(takeprofit==0){tp=0;}
		   else{tp=sellprice-takeprofit*pt;}
		   if(stoploss==0){sl=0;}
         else{sl=sellprice+stoploss*pt;}
		   if(openorders!=0){
			   mylotsi=lotsi;
			   if(countorders(magic)<=stoplevel){
			      for(cnt=1;cnt<=openorders;cnt++){
				      mylotsi=NormalizeDouble(mylotsi*lotincrement,lotdigits);
			      }
			   }
			   else{mylotsi=NormalizeDouble(lastlotsSize+lotsaddition,lotdigits);}
		   }else{mylotsi=lotsi;}
		   if(mylotsi<minlot)mylotsi=minlot;
		   if(mylotsi>maxlot)mylotsi=maxlot;
		   OrderSend(Symbol(),OP_SELL,mylotsi,sellprice,slippage*mt,sl,tp,"Terminator"+magic,magic,0,Red);
		   return(0);
	   }
   }
   if(myordertype==2 && continueopening){
	   if((lastprice-Ask)>=pips*pt || openorders<1){
		   buyprice=Ask;
		   lastprice=0;
		   if(takeprofit==0){tp=0;}
		   else{tp=buyprice+takeprofit*pt;}	
		   if(stoploss==0){sl=0;}
		   else{sl=buyprice-stoploss*pt;}
		   if(openorders!=0){
			   mylotsi=lotsi;
			   if(countorders(magic)<=stoplevel){
			      for(cnt=1;cnt<=openorders;cnt++){
				      mylotsi=NormalizeDouble(mylotsi*lotincrement,lotdigits);
			      }
			   }
			   else{mylotsi=NormalizeDouble(lastlotsSize+lotsaddition,lotdigits);}
		   }else{mylotsi=lotsi;}
		   if(mylotsi<minlot)mylotsi=minlot;
		   if(mylotsi>maxlot)mylotsi=maxlot;
		   OrderSend(Symbol(),OP_BUY,mylotsi,buyprice,slippage*mt,sl,tp,"Terminator"+magic,magic,0,Blue);
		   return(0);
	   }
   }
   return(0);
}
   
int openordersbasedonmacd(){
   int myordertype=3;
	if(iMACD(NULL,0,macdast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,0)>iMACD(NULL,0,macdast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,1)){myordertype=2;}
	if(iMACD(NULL,0,macdast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,0)<iMACD(NULL,0,macdast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,1)){myordertype=1;}
	return(myordertype);
}

int countorders(int magic){
   int _countord;
   _countord=0;
   for(int i=0;i<OrdersTotal();i++){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol()){
         if(((OrderMagicNumber()==magic)||magic==0))_countord++;
      }
   }
   return(_countord);
}

int count(int Type,int magic){
   int _countord;
   _countord=0;
   for(int i=0;i<OrdersTotal();i++){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderType()==Type){
         if(((OrderMagicNumber()==magic)||magic==0))_countord++;
      }
   }
   return(_countord);
}