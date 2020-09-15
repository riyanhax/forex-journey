//+------------------------------------------------------------------+
//|                                                     EA_9_bar.mq4 |
//|                                         Copyright 2015, BranLY_76|
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      ""
#property version   "1.01"
#property strict

sinput int        updateFrequency = 2;    // Update frequency of ea in seconds
sinput double     lotSize = 0.1;          // Lot size
sinput int        contraMultiplier = 2;   // Lot multiply for contra trade
sinput int        magicNumber = 12346;    // Magic number for trades of this ea
sinput int        _slippage = 5;          // Allowed slippage
sinput int        takeProfit = 10;        // Take profit value in pips
sinput int        slopLoss = 10;          // Stop Loss value in pips
sinput int        compareHour = 9;        // Fill in Frankfurt open time for your broker


double MyPoint;

double MyDigits;
double MyMultiplier;
double pBid;
double pAsk;
string _pair;
                       
static datetime newBar;
datetime check_9;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   newBar = 0;
   

      _pair = Symbol();


   
      MyDigits = MarketInfo(_pair,MODE_DIGITS);
      MyPoint = MarketInfo(_pair,MODE_POINT);
      if( MyDigits == 3 || MyDigits == 5 ) MyPoint = MyPoint * 10;
      MyMultiplier = 1.0 / MyPoint;


//--- create timer
   EventSetTimer(updateFrequency);
      
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
//---
   if (newBar != iTime(_pair, PERIOD_H1,0))
   {
      newBar = iTime(_pair, PERIOD_H1,0);
      //check for FO o'clock
      int hour = Hour();
      if (hour == compareHour)
      {

            int upCounter = 0;
            int downCounter = 0;
            if (iClose(_pair, PERIOD_H1,3) > iOpen(_pair, PERIOD_H1,3))
            {
               upCounter++;
            }
            if (iClose(_pair, PERIOD_H1,3) < iOpen(_pair, PERIOD_H1,3))
            {
               downCounter++;
            }
            
            if (iClose(_pair, PERIOD_H1,2) > iOpen(_pair, PERIOD_H1,2))
            {
               upCounter++;
            }
            if (iClose(_pair, PERIOD_H1,2) < iOpen(_pair, PERIOD_H1,2))
            {
               downCounter++;
            }
            
            if (iClose(_pair, PERIOD_H1,1) > iOpen(_pair, PERIOD_H1,1))
            {
               upCounter++;
            }
            if (iClose(_pair, PERIOD_H1,1) < iOpen(_pair, PERIOD_H1,1))
            {
               downCounter++;
            }
            
            if ((upCounter + downCounter) == 3)
            {
               if (upCounter > 1)
               {
                  // set buy order
                  int ticket_Buy = OrderSendReliable(_pair, OP_BUY, lotSize, 
                        MarketInfo(_pair, MODE_BID),_slippage, 0.0, 0.0, magicNumber, "BUY: " , 0, clrNONE);
                  if (ticket_Buy > 0)
                  {
                     // set TP and SL
                     Sleep(200);
                     OrderSelect(ticket_Buy, SELECT_BY_TICKET);
                     double TP = OrderOpenPrice() + takeProfit / MyMultiplier;
                     double SL = OrderOpenPrice() - takeProfit / MyMultiplier;
                     bool _ok = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(SL, (int)MarketInfo(_pair, 
                                    MODE_DIGITS)), NormalizeDouble(TP, (int)MarketInfo(_pair, 
                                    MODE_DIGITS)), 0, clrNONE);
                    
                     if (_ok)
                     {
                        // set pending sell order
                        int ticket_SellStop = OrderSendReliable(_pair, OP_SELLSTOP, lotSize * contraMultiplier , 
                           NormalizeDouble(SL, (int)MarketInfo(_pair,MODE_DIGITS)),_slippage, 
                           0.0, 0.0, magicNumber+1, IntegerToString(ticket_Buy), 0, clrNONE);
                     
                     }
                  }
               }
               else
               {
                  // set buy order
                  int ticket_Sell = OrderSendReliable(_pair, OP_SELL, lotSize, 
                        MarketInfo(_pair, MODE_BID),_slippage, 0.0, 0.0, magicNumber, "SELL: " , 0, clrNONE);
                  if (ticket_Sell > 0)
                  {
                     // set TP and SL
                     Sleep(200);
                     OrderSelect(ticket_Sell, SELECT_BY_TICKET);
                     double TP = OrderOpenPrice() - takeProfit / MyMultiplier;
                     double SL = OrderOpenPrice() + takeProfit / MyMultiplier;
                     bool _ok = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(SL, (int)MarketInfo(_pair, 
                                    MODE_DIGITS)), NormalizeDouble(TP, (int)MarketInfo(_pair, 
                                    MODE_DIGITS)), 0, clrNONE);
                     
                     if (_ok)
                     {
                        // set pending order
                        int ticket_BuyStop = OrderSendReliable(_pair, OP_BUYSTOP, lotSize * contraMultiplier, 
                           NormalizeDouble(SL, (int)MarketInfo(_pair,MODE_DIGITS)), _slippage, 
                           0.0, 0.0, magicNumber+1, IntegerToString(ticket_Sell), 0, clrNONE);
                     }
                  }
               }
            }
      }
   }
   
   checkTrades();
   
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
//---
   
}
//+------------------------------------------------------------------+


/* -------------------------------------------------------------------
	OrderSendReliable
	ordersend reliable
	simplex: modified logging
	------------------------------------------------------------------- */
int OrderSendReliable(string symbol,
                      int cmd,
                      double volume,
                      double price,
                      int slippage,
                      double stoploss,
                      double takeprofit,
                      int _magicNumber,
                      string comment = "",
                      datetime expiration = 0,
                      color arrow_color = clrNONE
							) {
   int ticket;
   int err;
   double _volume;
   //int arrayIndex = getPairDataIndex(symbol);
	//string printPrefix = eaLog(__FUNCTION__, "");

   while (true) {
      if (IsStopped()) {
         Alert(" Trading is stopped!");
         return(-1);
      }
      RefreshRates();
      if (cmd == OP_BUY) {
         price = MarketInfo(symbol, MODE_BID);
      }
      if (cmd == OP_SELL) {
         price = MarketInfo(symbol, MODE_ASK);
      }

      //Alert("in order send: " + NormalizeDouble(price, (int)MarketInfo(Symbol(), MODE_DIGITS)));
      if (!IsTradeContextBusy()) {
         ticket = OrderSend(symbol,
                            cmd,
                            volume,
                            NormalizeDouble(price, (int)MarketInfo(symbol, MODE_DIGITS)),
                            slippage,
                            NormalizeDouble(stoploss, (int)MarketInfo(symbol, MODE_DIGITS)),
                            NormalizeDouble(takeprofit, (int)MarketInfo(symbol, MODE_DIGITS)),
                            comment,
                            _magicNumber,
                            expiration,
                            arrow_color);
         if (ticket > 0) {
				//printPrefix = printPrefix + ticket2String(ticket);
            //Print(printPrefix + "opened.");
            return(ticket); 						// normal exit
         }

         err = GetLastError();
         Print(err);
         if (IsTemporaryError(err)) {
         Print(err);
            //Print(printPrefix + "Temporary Error: " + IntToStr(err) + " " + ErrorDescription(err) + ". Waiting.");
			}
         else {
            Print(err);
            //Print(printPrefix + "Permanent Error: " + IntToStr(err) + " " + ErrorDescription(err) + ". Giving up.");
            return(-1);
         }
      }
      else {
         //Print(printPrefix + "Must wait for trade context.");
		}

      Sleep(MathRand() / 10);
   }
   return (false);
}


/* -------------------------------------------------------------------
	IsTemporaryError
	Is the error temporary (does it make sense to wait).
	------------------------------------------------------------------- */
bool IsTemporaryError(int error) {
   return(error == ERR_NO_ERROR ||
          error == ERR_COMMON_ERROR ||
          error == ERR_SERVER_BUSY ||
          error == ERR_NO_CONNECTION ||
          error == ERR_MARKET_CLOSED ||
          error == ERR_PRICE_CHANGED ||
          error == ERR_INVALID_PRICE ||  //happens sometimes
          error == ERR_OFF_QUOTES ||
          error == ERR_BROKER_BUSY ||
          error == ERR_REQUOTE ||
          error == ERR_TRADE_TIMEOUT ||
          error == ERR_TRADE_CONTEXT_BUSY);
}

void checkTrades()
{

   RefreshRates();
   int nbrOfTrades = OrdersTotal();
   
   for (int u = 0; u < nbrOfTrades; u++)
   {
      OrderSelect(u, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() == magicNumber + 1)
      {
         if (OrderType() == OP_BUY)
         {
            // check TP and SL, original trade is a loss
            setSLandTP(OrderTicket());
         }
         
         if (OrderType() == OP_SELL)
         {
            // check TP and SL, original trade is a loss
            setSLandTP(OrderTicket());
         }
         
         if (OrderType() == OP_BUYSTOP)
         {
            // check for delete
            int ticket = OrderTicket();
            int ticketNumber = StringToInteger(OrderComment());
            bool check = OrderSelect(ticketNumber,SELECT_BY_TICKET);
            if (OrderCloseTime() > OrderOpenTime())
            {
               OrderDelete(ticket, clrNONE);
            }
         }
         if (OrderType() == OP_SELLSTOP)
         {
            // check for delete
            int ticket = OrderTicket();
            int ticketNumber = StringToInteger(OrderComment());
            bool check = OrderSelect(ticketNumber,SELECT_BY_TICKET);
            if (OrderCloseTime() > OrderOpenTime())
            {
               OrderDelete(ticket, clrNONE);
            }
         }
      } 
   }
}

void setSLandTP( int _ticket)
{
   
   double myMultiplier, SL, TP, slNew, tpNew, op;
   
   
   OrderSelect(_ticket, SELECT_BY_TICKET);      // select active order
   op = OrderOpenPrice();
   int _orderType = OrderType();
   int parentTicket = StringToInteger(OrderComment());
   
   // select closed trade
   OrderSelect(parentTicket, SELECT_BY_TICKET);
   SL = OrderStopLoss();
   TP = OrderTakeProfit();
   
   
   if (_orderType == OP_BUY)
   {
      tpNew = op + takeProfit / MyMultiplier;
      slNew = op - takeProfit / (MyMultiplier * 2.0);
      bool _ok = OrderModify(_ticket, op, NormalizeDouble(slNew, (int)MarketInfo(OrderSymbol(), 
                                    MODE_DIGITS)), NormalizeDouble(tpNew, (int)MarketInfo(OrderSymbol(), 
                                    MODE_DIGITS)), 0, clrNONE);
   }
   
   if (_orderType == OP_SELL)
   {
      tpNew = op - takeProfit / MyMultiplier;
      slNew = op + takeProfit / (MyMultiplier * 2.0);
      bool _ok = OrderModify(_ticket, op, NormalizeDouble(slNew, (int)MarketInfo(OrderSymbol(), 
                                    MODE_DIGITS)), NormalizeDouble(tpNew, (int)MarketInfo(OrderSymbol(), 
                                    MODE_DIGITS)), 0, clrNONE);
   }
}