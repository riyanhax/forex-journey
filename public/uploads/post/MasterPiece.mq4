//+------------------------------------------------------------------+
//|                                                  MasterPiece.mq4 |
//|                                                Copyright © 2011  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Roslan Rahmat"
#property link      "roslan@publicforex.net"
#define Name "MasterPiece"
#define Version "2.5"
#define INTERNET_FLAG_PRAGMA_NOCACHE    0x00000100 // Forces the request to be resolved by the origin server, even if a cached copy exists on the proxy.
#define INTERNET_FLAG_NO_CACHE_WRITE    0x04000000 // Does not add the returned entity to the cache. 
#define INTERNET_FLAG_RELOAD            0x80000000 // Forces a download of the requested file, object, or directory listing from the origin server, not from the cache.
#define INTERNET_FLAG_NO_COOKIES			 0x00080000 // Does not automatically add cookie headers to requests, and does not automatically add returned cookies to the cookie database.

int hSession_IEType;
int hSession_Direct;
int Internet_Open_Type_Preconfig = 0;
int Internet_Open_Type_Direct = 1;
int Internet_Open_Type_Proxy = 3;
int Buffer_LEN = 80;

#import "wininet.dll"
	int InternetOpenA(string sAgent,int	lAccessType,string sProxyName="",string sProxyBypass="",int lFlags=0);
	int InternetOpenUrlA(int hInternetSession,string sUrl,string sHeaders="",int lHeadersLength=0,int lFlags=0,int lContext=0);
	int InternetReadFile(int hFile,string sBuffer,int lNumBytesToRead,int& lNumberOfBytesRead[]);
	int InternetCloseHandle(int hInet);
#import

extern double  Lots=0.1; 
extern bool    UseMM=true;
extern int     RiskPercent=10; 
extern bool    HiddenSLTP=true;
extern double  TakeProfit=20;    
extern double  StopLoss=80; 
extern int     MagicNo=2011;
extern string  System="duit";
int CntBuy,CntSell,pos,Slippage=5;
double point,LotDigit,xpoint=1;   
string Status,Debug="",Remarks="MP",sUrl="";
bool ToBuy,ToSell;
int init() { 
   Comment(""); 
   point=Point; 
   if (Digits==3||Digits==5)  { point*=10; xpoint=10; } Slippage*=point; 
   double LotStep=NormalizeDouble(MarketInfo(Symbol(),MODE_LOTSTEP),2);
   if (LotStep==0.01) LotDigit=2; else if (LotStep==0.10) LotDigit=1; else LotDigit=0; 
   sUrl="http://publicforex.net/"+System+"/default.aspx?";
   return(0); 
}
int deinit() { Comment(""); return(0); }
int start() {
   int Ticket=-1,cntr=0,begin=0,index=0;CntBuy=0;CntSell=0;
   double op;
   string sData,dat[10];Status="Active Trading!";
   bool ToTrade=true;ToBuy=false;ToSell=false;
   double price=0;
   while(IsTradeContextBusy()) Sleep(1000);
   sData=GetSignal();
   while(true) {
      index=StringFind(sData,";",begin);
      if (index<0) break;
      dat[cntr]=StringSubstr(sData, begin, index-begin);
      begin=index+1;
      cntr++;
   }   
   RefreshRates();
   for(pos=OrdersTotal()-1;pos>=0;pos--) {
     OrderSelect(pos,SELECT_BY_POS,MODE_TRADES);
     if (OrderSymbol()==Symbol()&&OrderMagicNumber()==MagicNo) { 
         op=OrderOpenPrice();
         if (OrderType()==OP_BUY) { 
            CntBuy++;
            if (dat[0]=="-2") {
               OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,White); CntBuy--;
            }
            if (HiddenSLTP) {
               if ((op-Bid>StopLoss*point&&StopLoss>0)||(Bid-op>=TakeProfit*point&&TakeProfit>0)) {
                  OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,White); CntBuy--;
               }
            }
            if (!HiddenSLTP)
               if (OrderStopLoss()==0||OrderTakeProfit()==0) 
                  OrderModify(OrderTicket(),op,SL(op,OP_BUY),TP(op,OP_BUY),0,CLR_NONE);
         }
         if (OrderType()==OP_SELL) {
            CntSell++;
            if (dat[0]=="-3") {
               OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,White); CntSell--;
            }
            if (HiddenSLTP) {
               if ((Ask-op>StopLoss*point&&StopLoss>0)||(op-Ask>=TakeProfit*point&&TakeProfit>0)) {
                  OrderClose(OrderTicket(),OrderLots(),Ask,0,CLR_NONE); CntSell--;
               }
            }
            if (!HiddenSLTP)
               if (OrderStopLoss()==0||OrderTakeProfit()==0) 
                  OrderModify(OrderTicket(),op,SL(op,OP_SELL),TP(op,OP_SELL),0,CLR_NONE); 
        }
     }
   }
   price=NormalizeDouble(StrToDouble(dat[1]),Digits);
   if (dat[0]=="-1"||price==0) { ToTrade=false; Status="Waiting For Signal!"; }
   if (dat[2]!=" ") { ToTrade=false; Status=dat[2]; }
   if (StrToDouble(dat[0])==OP_BUY) ToBuy=true; 
   if (StrToDouble(dat[0])==OP_SELL) ToSell=true;       
   if (ToTrade) { 
      RefreshRates();
      if (ToBuy&&Ask<=price&&CntBuy<1) {
         Ticket=OrderSend(Symbol(),OP_BUY,Lots(),Ask,Slippage,0,0,Remarks,MagicNo,0,Blue); 
         if (Ticket>0) ToBuy=false; 
      }
      if (ToSell&&Bid>=price&&CntSell<1) {
         Ticket=OrderSend(Symbol(),OP_SELL,Lots(),Bid,Slippage,0,0,Remarks,MagicNo,0,Red);
         if (Ticket>0) ToSell=false; 
      }
   }
   Debug="\nSpread : "+DoubleToStr(NormalizeDouble(MarketInfo(Symbol(),MODE_SPREAD)/xpoint,1),1)+"\nSystem : "+System;
   Comment("\n"+Name+" "+Version+"\nAuthor : roslan@publicforex.net"+Debug+"\nStatus : "+Status);
   return(0);
} 
int hSession(bool Direct) {
	string InternetAgent;
	if (hSession_IEType == 0) {
		InternetAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Q312461)";
		hSession_IEType = InternetOpenA(InternetAgent, Internet_Open_Type_Preconfig, "0", "0", 0);
		hSession_Direct = InternetOpenA(InternetAgent, Internet_Open_Type_Direct, "0", "0", 0);
	}
	if (Direct) { return(hSession_Direct); }
	else { return(hSession_IEType); }
}
string GetSignal() {
   int hInternet,iResult,bytes,lReturn[]={1};
	string sBuffer="                                                                                                                                                                                                                                                               ";	// 255 spaces   
   string para1="0258257BE55CD591DA66B5CCD0F0147AA8AFA5008C272D8E2B524B01B0FD096A";
	string para2="E2B524B01B0FD096ACCD0F0147AA8AFA5008C272D80258257BE55CD591DA66B5";
	string para3="CCD0F0147AA8AFA50D096A0258257BE55CD591DA66B508C272D8E2B524B01B0F";
	string para4="96A0258257BE55CD591DA66B508C272D8E2B524B01B0FCCD0F0147AA8AFA50D0";
	string xUrl=sUrl+para1+"="+StringSubstr(Symbol(),0,6)+"&"+para2+"="+AccountNumber()+"&"+para3+"="+IsDemo()+"&"+para4+"="+Version;
	hInternet = InternetOpenUrlA(hSession(FALSE), xUrl, "0", 0, 
	  INTERNET_FLAG_NO_CACHE_WRITE | INTERNET_FLAG_PRAGMA_NOCACHE | INTERNET_FLAG_RELOAD | INTERNET_FLAG_NO_COOKIES, 0);					
   InternetReadFile(hInternet, sBuffer, Buffer_LEN, lReturn);
   InternetCloseHandle(hInternet);
   return(StringSubstr(sBuffer, 0, lReturn[0])); 
}
double Lots() {
   double MinLots=NormalizeDouble(MarketInfo(Symbol(),MODE_MINLOT),LotDigit);
   if (UseMM) Lots=NormalizeDouble(AccountFreeMargin()*RiskPercent/100000,LotDigit);
   if (Lots<MinLots) Lots=MinLots;    
   return(Lots);      
}
double SL(double op,int action) {
   if (StopLoss>0) {
      if (action==OP_BUY) return(op-StopLoss*point);
      if (action==OP_SELL) return(op+StopLoss*point);
   }
   return(0);
}
double TP(double op,int action) {
   if (TakeProfit>0) {
      if (action==OP_BUY) return(op+TakeProfit*point);
      if (action==OP_SELL) return(op-TakeProfit*point);
   }
   return(0);
}