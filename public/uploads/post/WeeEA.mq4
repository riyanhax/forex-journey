//+------------------------------------------------------------------+
//|                                                   weekendEA.mq4 V1.2 |
//|                                                       2011 by monty |
//+------------------------------------------------------------------+
	extern int     Magic = 166972;
	extern string OrdComment = "weeEA";
	extern double  TP = 1000;
	extern double  SL = 10;
	extern double  Lot = 0.01;
	extern int     SlipPage = 3;
	extern double    Distance=12;
	extern string Part1 = "1-2 min before broker close connection on fridays";
	extern int TradeStartHour = 21;
	extern int TradeStartMinutes = 58;
	extern string Part2 = "close orders after broker opening time on sundays";
	extern int TradeCloseHour = 22;
	extern int TradeCloseMinutes = 2;
	double Points;
	double PipValue = 0.0001; // 4 & 5 digit broker
	double	MyAsk;
	double	MyBid;
	int expireMinutes = 15; // security feature to expire orders if close by broker fails
	string msg;

// 4 or 5 Digit Broker Account Recognition
void HandleDigits()
 {
    // Automatically Adjusts to Full-Pip and Sub-Pip Accounts
    if (Digits == 4 || Digits == 2) 
     {
       SlipPage = SlipPage;
       Points = Point;
     }
  
   if (Digits == 5 || Digits == 3) 
     {     
       SlipPage = SlipPage*10;
       Points = Point*10;
     } 
 }

int init() {
   if (Digits < 4) Points = 0.01; // 2 & 3 digit broker currency 
   MyAsk = Ask + Distance * Points;
	MyBid = Bid - Distance * Points;  
   Display_stats();
   return (0);
}
 
	int deinit() { Comment(""); return (0); }

	int start()
	{
   int ticket;
	int nOrders=0;
	int pos;
	HandleDigits();

	MyAsk = Ask + Distance * Points;
	MyBid = Bid - Distance * Points;  

	int i=0;
	if ((((DayOfWeek()==0) && (Hour()==TradeCloseHour) && (Minute()>=TradeCloseMinutes) && (OrderMagicNumber()==Magic  && OrderSymbol() == Symbol()))))
	{
	for(i=OrdersTotal()-1; i>=0; i--)
	{
	OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
	if(OrderType()==OP_BUY)
	{
	OrderClose(OrderTicket(),OrderLots(),Bid,SlipPage,Green);
	continue;
	}
	if(OrderType()==OP_SELL)
	{
	OrderClose(OrderTicket(),OrderLots(),Ask,SlipPage,Red);
	continue;
	}
	if (OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT || OrderType()==OP_BUYSTOP || OrderType()==OP_BUYLIMIT)
	{
	OrderDelete(OrderTicket());
	}
	}
	return(0);
	}

	datetime cTime = TimeCurrent();
	int sTime = StrToTime(TradeStartHour + ":" + TradeStartMinutes);
	datetime eTime = 60*expireMinutes;
	int expire = eTime + CurTime() + 48 * 3600;

	for(pos = OrdersTotal()-1; pos >= 0 ; pos--) if (
	OrderSelect(pos, SELECT_BY_POS) 
	&&  OrderMagicNumber()  == Magic
	&&  OrderSymbol()       == Symbol()
	){
	nOrders++;
	}

   if (DayOfWeek()==5 && Hour()>=TradeStartHour && Minute()>=TradeStartMinutes && nOrders == 0)
	{
	ticket = OrderSend(Symbol(),OP_SELLSTOP,Lot,MyBid,SlipPage,MyAsk-(SL)*Points,MyBid-(TP)*Points,OrdComment,Magic,expire,Red);
	ticket=OrderSend(Symbol(),OP_BUYSTOP,Lot,MyAsk,SlipPage,MyBid-(SL)*Points,MyAsk+(TP)*Points,OrdComment,Magic,expire,Green);
	if(ticket>0)
	{
	if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("order opened : ",OrderOpenPrice());
	}
	else Print("Error opening order : ",GetLastError()); 
	}
	
   Display_stats();
   
   return(0);
}

void Display_stats()
{
     msg = "";
      msg = msg
       + "\n WeekendEA"
       + "\n ___________________\n"
       + "\n Server Time: " + TimeToStr(TimeCurrent(), TIME_MINUTES) 
       + "\n Trade Start Time: " + TradeStartHour + ":" + TradeStartMinutes
       + "\n"
       + "\n MyAsk = " + DoubleToStr(MyAsk,Digits)
       + "\n MyBid = " + DoubleToStr(MyBid,Digits);
       //+ "\n BuySL = " + DoubleToStr(( MyAsk - StopLoss * PipValue ),Digits)
       //+ "\n BuYTP= " + DoubleToStr(( MyAsk + TakeProfit * PipValue ),Digits)
       //+ "\n SellSL = " + DoubleToStr(( MyBid + StopLoss * PipValue ),Digits) 
       //+ "\n SellTP= " + DoubleToStr(( MyBid - TakeProfit * PipValue ),Digits);
      Comment(msg);
}  