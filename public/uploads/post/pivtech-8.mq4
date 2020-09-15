//+------------------------------------------------------------------+
//+                    Code generated using StrategyTune ver. 1.0.41 |
//+------------------------------------------------------------------+
#define __STRATEGY_MAGIC 2130065017

//Extern variables
extern double _stop_loss_A = 600;
extern double _take__profit_A = 100;
extern double _Max_open_trades_A = 25;
extern double _shiftback = 10;
extern double _MA_input = 100;
extern double _Max_frequency_mins_A = 240;
extern double _stop_loss_B = 2000;
extern double _take_profit_B = 400;
extern double _Maxopentrades_B = 25;
extern double _Max_frequency_mins_B = 120;
extern double _Lot_size_B = 0.8;
extern double _Lot_size_A = 0.8;

//Declaration
double _High;
double _low;
double _close;
double _Moving_Average;
double _Point;
double _H1_open;
double _H_plus_L;
bool _Ma_test;
double _x0;
double _H__plus_L_plus_C;
double _Pivot_Point;
double _2P;
double _pivot_plus_0pips;
double _pivot_minus_0pips;
bool _Compare;
double _Resistance_1;
double _Support1;
bool _Compare_4;
bool _Buy_and_close_sell_triggers;
bool _Compare_2;
bool _Compare_3;
bool _Sell_and_Close_buy_triggers;
bool _Buy;
bool _Sell;
bool _Close_All_Short_Trades;
bool _Close_All_Long_Trades;
bool _Buy_1;
bool _Sell_1;

int init() {

    return(0);
}

int start() {

    //Step 1
    _High = iHigh( Symbol(), 1440, _shiftback );
    _low = iLow( Symbol(), 1440, _shiftback );
    _close = iClose( Symbol(), 1440, _shiftback );
    _Moving_Average = iMA( Symbol(), 0, _MA_input, 0, 1, 0, 0 );
    _Point = Point;
    _H1_open = iOpen( Symbol(), 60, 0 );

    //Step 2
    _H_plus_L = _High + _low;
    _Ma_test = _H1_open >= _Moving_Average;
    _x0 = _Point * 0;

    //Step 3
    _H__plus_L_plus_C = _H_plus_L + _close;

    //Step 4
    _Pivot_Point = _H__plus_L_plus_C / 3;

    //Step 5
    _2P = 2 * _Pivot_Point;
    _pivot_plus_0pips = _Pivot_Point + _x0;
    _pivot_minus_0pips = _Pivot_Point - _x0;

    //Step 6
    _Compare = _H1_open >= _pivot_plus_0pips;
    _Resistance_1 = _2P - _low;
    _Support1 = _2P - _High;
    _Compare_4 = _H1_open <= _pivot_minus_0pips;

    //Step 7
    _Buy_and_close_sell_triggers = _Ma_test && _Compare;
    _Compare_2 = _H1_open >= _Resistance_1;
    _Compare_3 = _H1_open <= _Support1;
    _Sell_and_Close_buy_triggers = !_Ma_test && _Compare_4;

    //Step 8
    if( _Buy_and_close_sell_triggers ) _Buy = Buy( 111111, _Lot_size_A, _stop_loss_A, _take__profit_A, 5, _Max_open_trades_A, _Max_frequency_mins_A );
    if( _Sell_and_Close_buy_triggers ) _Sell = Sell( 222222, _Lot_size_A, _stop_loss_A, _take__profit_A, 5, _Max_open_trades_A, _Max_frequency_mins_A );
    if( _Buy_and_close_sell_triggers ) _Close_All_Short_Trades = Close_All_Short_Trades( 222222 );
    if( _Sell_and_Close_buy_triggers ) _Close_All_Long_Trades = Close_All_Long_Trades( 111111 );
    if( _Compare_2 ) _Buy_1 = Buy( 333333, _Lot_size_B, _stop_loss_B, _take_profit_B, 5, _Maxopentrades_B, _Max_frequency_mins_B );
    if( _Compare_3 ) _Sell_1 = Sell( 444444, _Lot_size_B, _stop_loss_B, _take_profit_B, 5, _Maxopentrades_B, _Max_frequency_mins_B );

    return(0);
}

// Helper functions
///---------------------------------- FxPro Library ----------------------------------

//Library version 1.9.34

#define PCT_PRECISION 2
#define CASH_PRECISION 2
#define LOTS_PRECISION 2

string fxAlgo_name = "FxQuant";
int fxLastTradeType=0;
datetime fxTradeInhibit_Time = D'1970.01.01 00:00';

void fxPrint(string s){ Print(fxAlgo_name + "(FxProLib): " + s );}

int fxGenerateMagic(int magicIndex) {return(__STRATEGY_MAGIC + magicIndex);}

bool fxOrderNonValid(int magicIndex){
   if( OrderMagicNumber() != fxGenerateMagic(magicIndex) || OrderSymbol() != Symbol() ) return(true);   
   return(false);
}

int Number_of_Open_Trades (int MagicIndex) {
   int res = 0;   
 for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i, SELECT_BY_POS) == false) continue;
      if(fxOrderNonValid(MagicIndex)) continue;   
      res ++;    
   }   
   return (res);
}

double Total_Open_Lots (int MagicIndex) {  

   double res = 0;   
   for(int i=OrdersTotal()-1;i>=0;i--)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) continue;
      if(fxOrderNonValid(MagicIndex)) continue;   
      res += OrderLots();      
   }   
   
   return (NormalizeDouble(res,LOTS_PRECISION));
}

double Net_Open_Lots (int MagicIndex) {

   double res = 0;  
 
   for(int i=OrdersTotal()-1; i >= 0; i--) {
      if( OrderSelect(i, SELECT_BY_POS) == false ) continue;
      if( fxOrderNonValid(MagicIndex) ) continue; 
      
      int type = OrderType();
      switch( type ){
         case OP_BUY       :  res += OrderLots(); break;
         case OP_SELL      :  res -= OrderLots(); break;      
      }     
   }      
   return (res);
}

double Lots_Balance_Ratio (int MagicIndex)
{
   return(NormalizeDouble(Total_Open_Lots(MagicIndex)/AccountBalance()*100,PCT_PRECISION));
}

double Net_Lots_Balance_Ratio (int MagicIndex)
{
   return(NormalizeDouble(Net_Open_Lots(MagicIndex)/AccountBalance()*100,PCT_PRECISION));
}

int Current_Exposure_Direction (int MagicIndex) {   
   double netVolLots = Net_Open_Lots(MagicIndex);   
   if (netVolLots > 0) return (1);
   if (netVolLots < 0) return (-1);
   return(0);
}

bool Close_All_Trades(int MagicIndex) {

 int total = OrdersTotal();
 for(int i=total-1;i>=0;i--)
 {
   OrderSelect(i, SELECT_BY_POS);
   if(fxOrderNonValid(MagicIndex)) continue;
   int type   = OrderType();

   bool result = true;
   int ticket = OrderTicket();

   switch(type) {
     //Close opened long positions
     case OP_BUY       :  result = OrderClose(ticket, OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red ); break;
     //Close opened short positions
     case OP_SELL      :  result = OrderClose(ticket, OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red ); break;
   }

   if(result == false) {
     //Alert("Order " , OrderTicket() , " failed to close. Error:" , GetLastError() );
     Sleep(0);
   }   
     
 } 
 
 return(result);
}

bool Close_All_Long_Trades(int MagicIndex) {
//Print("CloseByType " + type);
 int total = OrdersTotal();
 for(int i=total-1;i>=0;i--)
 {
   OrderSelect(i, SELECT_BY_POS);
   if(fxOrderNonValid(MagicIndex)) continue;
   int type   = OrderType();

   bool result = true;

   switch(type)
   {
     //Close opened long positions
     case OP_BUY       : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red ); break;

     //Close opened short positions
     //case OP_SELL      : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red );

   }

   if(result == false)
   {
     //Alert("Order " , OrderTicket() , " failed to close. Error:" , GetLastError() );
     Sleep(0);
   } 
 }
 return(result);
}

bool Close_All_Short_Trades(int MagicIndex) {
//Print("CloseByType " + type);
 int total = OrdersTotal();
 for(int i=total-1;i>=0;i--)
 {
   OrderSelect(i, SELECT_BY_POS);
   if(fxOrderNonValid(MagicIndex)) continue;
   int type   = OrderType();

   bool result = true;

   switch(type)
   {
     //Close opened long positions
     //case OP_BUY       : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
     //                    break;

     //Close opened short positions
     case OP_SELL      : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red ); break;

   }

   if(result == false)
   {
     //Alert("Order " , OrderTicket() , " failed to close. Error:" , GetLastError() );
     Sleep(0);
   } 
 }
 return(result);
}
//+------------------------------------------------------------------+
//| Sell                                                             |
//+------------------------------------------------------------------+
bool Sell(int MagicIndex, double Lots, double StopLossPoints, int TakeProfitPoints, int Slippage, int MaxOpenTrades, int MaxFrequencyMins){

   double SL = 0, TP = 0;
	RefreshRates();
	
	double point = Point;

   if(MaxOpenTrades > 0 && Number_of_Open_Trades(MagicIndex) >= MaxOpenTrades) {
      fxPrint("Max number of orders open reached: " + MaxOpenTrades);
      return(false);
   }
   
   if(MaxFrequencyMins  > 0 && fxLastTradeType == OP_SELL && fxTradeInhibit_Time > TimeLocal() ) {
      fxPrint("Sell Trade inhibited till " + TimeToStr(fxTradeInhibit_Time));
      return (false);
	}	
	
   if (StopLossPoints > 0) SL = Bid + StopLossPoints* point;
   if (TakeProfitPoints > 0) TP = Bid - TakeProfitPoints* point;

   double _lots = Lots;//LotsOptimized(Lots);   
   
   RefreshRates();
	int result = OrderSend(Symbol(), OP_SELL, _lots, Bid, Slippage, SL, TP, fxAlgo_name, fxGenerateMagic(MagicIndex));

	if (result == -1){
	    fxPrint("Failed to Sell: " + Last_Error_Text());
	   return(false); 
	} 
	
	fxLastTradeType = OP_SELL;
   fxTradeInhibit_Time = TimeLocal() + 60 * MaxFrequencyMins; 
   return(true);	
}
//+------------------------------------------------------------------+
//| Buy                                                              |
//+------------------------------------------------------------------+
bool Buy(int MagicIndex, double Lots, double StopLossPoints, int TakeProfitPoints, int Slippage, int MaxOpenTrades, int MaxFrequencyMins){

	double SL = 0, TP = 0;
	RefreshRates();
	
	double point = Point;

   if(MaxOpenTrades > 0 && Number_of_Open_Trades(MagicIndex) >= MaxOpenTrades) {
      fxPrint("Max number of orders open reached: " + MaxOpenTrades);
      return(false);
   }
   
   if(MaxFrequencyMins > 0 && fxLastTradeType == OP_SELL && fxTradeInhibit_Time > TimeLocal() ) {
      fxPrint("Sell Trade inhibited till " + TimeToStr(fxTradeInhibit_Time));
      return (false);
	}	

   if (StopLossPoints > 0) SL = Ask - StopLossPoints*point;
   if (TakeProfitPoints > 0) TP = Ask + TakeProfitPoints*point;
   
   double _lots = Lots;//LotsOptimized(Lots);
   RefreshRates();
	int result = OrderSend(Symbol(), OP_BUY, _lots, Ask, Slippage, SL, TP, fxAlgo_name, fxGenerateMagic(MagicIndex));
	
	if (result == -1){
		fxPrint("Failed to Buy: " + Last_Error_Text());
	   return(false); 
	}
	
	fxLastTradeType = OP_SELL;
   fxTradeInhibit_Time = TimeLocal() + 60 * MaxFrequencyMins; 
   return(true); 
}


bool Simple_Trailing_Stop(int MagicIndex, int TrailingStopPoints) {
   
   double Pnl_points=0;
   
   double price, sl, tp;
   double point = MarketInfo(OrderSymbol(),MODE_POINT);
   int stopLevel  = MarketInfo(Symbol(),MODE_STOPLEVEL);  
   int cmd; 
   
   if(TrailingStopPoints<stopLevel) return (false);
   
   bool result = true;
   
   double newSl;

   int total = OrdersTotal();
      for(int i=total-1;i>=0;i--){
      if (OrderSelect(i, SELECT_BY_POS) == false) continue;
      if(fxOrderNonValid(MagicIndex) == true) continue;
      
      cmd = OrderType();      
      sl = NormalizeDouble(OrderStopLoss(),Digits);
      tp = OrderTakeProfit();
       
      if (OrderType() == OP_BUY)
      {
         price = MarketInfo(OrderSymbol(),MODE_BID);
         newSl = NormalizeDouble(price - TrailingStopPoints * point, Digits);    
         if(((tp - price)/point) < stopLevel) continue;         
         if(((price - newSl)/point) < stopLevel)continue;         
         Pnl_points = (price - OrderOpenPrice())/point; 
         if ( Pnl_points < TrailingStopPoints ) continue;          
         if (sl >= newSl) continue;       
         
         if(OrderModify(OrderTicket(), OrderOpenPrice(), newSl, tp, 0) == false)
         {
            fxPrint("Error: Failed to modify trade. Ticket = " + OrderTicket() + " reason: " + Last_Error_Text());
            result = false;
         }
      }  
      else if (OrderType() == OP_SELL)
      {
         price = MarketInfo(OrderSymbol(),MODE_ASK);
         newSl = NormalizeDouble(price+ TrailingStopPoints * point, Digits);
         if(((price - tp)/point) < stopLevel) continue;
         if(((newSl - price)/point) < stopLevel) continue;      
         Pnl_points = (OrderOpenPrice() - price)/point;
         if (Pnl_points < TrailingStopPoints) continue; //If profit is greater or equal to the desired Trailing Stop value         
         if (sl <= newSl && sl != 0) continue; //If the current stop-loss is below the desired trailing stop level
         
         if(OrderModify(OrderTicket(), OrderOpenPrice(), newSl, tp, 0) == false)
         {
            fxPrint("Error: Failed to modify trade. Ticket = " + OrderTicket() + " reason: " + Last_Error_Text());
            result = false;
         }         
       }      
   }   
   return(result);
}

bool EMA_Trailing_Stop (int MagicIndex, int EmaPeriod, int EmaShift) {

   double ma = iMA(NULL, 0, EmaPeriod, EmaShift, MODE_EMA, PRICE_CLOSE, 0);
   
   ma = NormalizeDouble(ma,Digits);
   
   double price, sl, tp;
   double point = MarketInfo(OrderSymbol(),MODE_POINT);
   int stopLevel = MarketInfo(Symbol(),MODE_STOPLEVEL);
   int cmd; 
   
   bool result = true;
   
   for (int pos = 0; pos < OrdersTotal(); pos++) {
      if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
      if(fxOrderNonValid(MagicIndex) == true) continue;
       
      cmd = OrderType();      
      sl = NormalizeDouble(OrderStopLoss(),Digits);
      tp = OrderTakeProfit();
       
      if (cmd == OP_BUY) {   
         price = MarketInfo(OrderSymbol(),MODE_BID);
         if(((tp - price)/point) < stopLevel) continue;
         if(((price - ma)/point) < point) continue;   
         if (sl >= ma) continue;
         
         if(OrderModify(OrderTicket(), OrderOpenPrice(), ma, tp, 0) == false)
         {
            fxPrint("Error: Failed to modify trade. Ticket = " + OrderTicket() + " reason: " + Last_Error_Text());
            result = false;
         }
      } else if (cmd == OP_SELL) {       
         price = MarketInfo(OrderSymbol(),MODE_ASK);
         if(((price - tp)/point) < stopLevel) continue;
         if(((ma - price)/point) < stopLevel) continue; 
         if (sl <= ma && sl != 0) continue;
         
         if(OrderModify(OrderTicket(), OrderOpenPrice(), ma, OrderTakeProfit(), 0) == false)
         {
            fxPrint("Error: Failed to modify trade. Ticket = " + OrderTicket() + " reason: " + Last_Error_Text());
            result = false;
         } 
      }
   }//end of for     
   return(result); 
}


bool Dual_Ema_Trailing_Stop (int MagicIndex, int FastEmaPeriod,int SlowEmaPeriod, int FastEmaShift, int SlowEmaShift) {

   if(FastEmaPeriod == SlowEmaPeriod ) return(false);

   double fastMA0 = iMA(NULL, 0, FastEmaPeriod,FastEmaShift, MODE_EMA, PRICE_CLOSE, 0);
   double slowMA0 = iMA(NULL, 0, SlowEmaPeriod,SlowEmaShift, MODE_EMA, PRICE_CLOSE, 0);
   
   fastMA0 = NormalizeDouble(fastMA0,Digits);
   slowMA0 = NormalizeDouble(slowMA0,Digits);
   
   double price, sl, tp;
   double point = MarketInfo(OrderSymbol(),MODE_POINT);
   int stopLevel = MarketInfo(Symbol(),MODE_STOPLEVEL);
   int cmd;     
   bool result = true;
   
   for (int pos = 0; pos < OrdersTotal(); pos++) {
      if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
      if(fxOrderNonValid(MagicIndex) == true) continue;
         
      cmd = OrderType();      
      sl = NormalizeDouble(OrderStopLoss(),Digits);
      tp = OrderTakeProfit();
         
      if (cmd == OP_BUY) {       
        
        price = MarketInfo(OrderSymbol(),MODE_BID);
        if(((tp - price)/point) < stopLevel) continue;
        if(((price - fastMA0)/point) < stopLevel) continue;
        if (sl > slowMA0 && fastMA0 < slowMA0 && sl != 0) continue; //If the current stop-loss is below the desired trailing stop level
        if (sl >= fastMA0) continue;
            
        if(OrderModify(OrderTicket(), OrderOpenPrice(), fastMA0, tp, 0) == false)
        {
           fxPrint("Error: Failed to modify trade. Ticket = " + OrderTicket() + " reason: " + Last_Error_Text());
           result = false;
        } 
           
      } else if (cmd == OP_SELL) { 
         price = MarketInfo(OrderSymbol(),MODE_ASK);
         if(((price - tp)/point) < stopLevel) continue;
         if(((fastMA0 - price)/point) < stopLevel) continue;
         if (sl < slowMA0 && fastMA0 > slowMA0) continue;//If the current stop-loss is below the desired trailing stop level
         if (sl <= fastMA0 && sl != 0) continue;
         
         if(OrderModify(OrderTicket(), OrderOpenPrice(), fastMA0, tp, 0) == false)
         {
            fxPrint("Error: Failed to modify trade. Ticket = " + OrderTicket() + " reason: " + Last_Error_Text());
            result = false;
         } 
      }      
   }  
   return(result); 
}
///===============================================================================================================================================================
bool Trade_Exists (int MagicIndex) {

  int total = OrdersTotal();  
  if(total == 0) return (false);  
  for(int i=total-1;i>=0;i--){
    if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) continue;//can't select the trade
    if(fxOrderNonValid(MagicIndex) == true) continue;
    return (true);
  }//end of for
  
  return(false);  
}  
///===============================================================================================================================================================
double Capital_at_Risk (int MagicIndex){
   
   int total = OrdersTotal();  
   if(total == 0) return (0); 
   
   int cmd, slPoints;
   double sl,open,lots; 
   double tickValue = MarketInfo(Symbol(),MODE_TICKVALUE);
   double res = 0;
   
   for(int i=total-1;i>=0;i--){  
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) continue;//can't select the trade
      if(fxOrderNonValid(MagicIndex) == true) continue;     
      sl = OrderStopLoss();
      if(sl == 0) return(AccountBalance());
      open = OrderOpenPrice();
      cmd = OrderType();
      lots = OrderLots();
      
      if(cmd == OP_BUY) {
         slPoints = (open - sl)/Point;
      }else if(cmd == OP_SELL){
         slPoints = (sl - open)/Point;         
      }
      
      res += lots*tickValue*slPoints;
      
      return (NormalizeDouble(res,CASH_PRECISION));
  }//end of for
}

///===============================================================================================================================================================
double Exposure_for_Magic (int MagicIndex){

   int total = OrdersTotal();  
   if(total == 0) return (0);

   double valueAtRisk = 0;
   int cmd;
   int slPoints;
   double sl;
   double point = Point;
   double tickValue;
   
   for(int i=total-1;i>=0;i--){
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) continue;//can't select the trade
      if(OrderMagicNumber() != fxGenerateMagic(MagicIndex)) continue;
      cmd = OrderType();
      sl = OrderStopLoss();
      if(sl == 0) return(100.00);
      
      tickValue = MarketInfo(OrderSymbol(),MODE_TICKVALUE);
         
      if(cmd == OP_BUY) {         
         slPoints = (OrderOpenPrice() - OrderStopLoss())/point;     
      }else if (cmd == OP_SELL){      
         slPoints = (OrderStopLoss() - OrderOpenPrice())/point;      
      }       
      valueAtRisk += slPoints*tickValue*OrderLots();                
   }   
   return(NormalizeDouble(valueAtRisk/AccountBalance()*100,PCT_PRECISION));
}
///===============================================================================================================================================================
double Exposure_for_Account (){

   int total = OrdersTotal();  
   if(total == 0) return (0);

   double valueAtRisk = 0;
   int cmd;
   int slPoints;
   double sl;
   double point = Point;
   double tickValue;
   
   for(int i=total-1;i>=0;i--){
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) continue;//can't select the trade
      cmd = OrderType();
      sl = OrderStopLoss();
      if(sl == 0) return(100.00);
      
      tickValue = MarketInfo(OrderSymbol(),MODE_TICKVALUE);
         
      if(cmd == OP_BUY) {         
         slPoints = (OrderOpenPrice() - OrderStopLoss())/point;     
      }else if (cmd == OP_SELL){      
         slPoints = (OrderStopLoss() - OrderOpenPrice())/point;      
      }       
      valueAtRisk += slPoints*tickValue*OrderLots();                
   }   
   return(NormalizeDouble(valueAtRisk/AccountBalance()*100,PCT_PRECISION));
}
///===============================================================================================================================================================
double fxVarLotsSlPoints (int MagicIndex, string symbol, int slPoints, double riskPct, double maxEaVar, double maxAccVar){

    double eaRiskAlloc = MathMin(maxEaVar - Exposure_for_Magic(MagicIndex) , maxAccVar - Exposure_for_Account());
    double riskAlloc = MathMin(riskPct, eaRiskAlloc);
    double tickValue = MarketInfo(symbol,MODE_TICKVALUE);
    double valueAllocation = AccountBalance()*riskAlloc/100;    
    return (NormalizeDouble(valueAllocation/slPoints*tickValue,LOTS_PRECISION));
}

///===============================================================================================================================================================
bool Sell_with_MM (int MagicIndex, double StopLossPoints, double TakeProfitPoints, int Slippage, double RiskPerTrade, double RiskPerMagic, double RiskPerAccount) {
   
   double open, sl = 0, tp = 0; 
   double point = Point;  
   double lots = fxVarLotsSlPoints(MagicIndex,Symbol(),StopLossPoints,RiskPerTrade,RiskPerMagic,RiskPerAccount);   
     
   if(lots < MarketInfo(Symbol(),MODE_MINLOT)) {
      fxPrint("Sell order error: insufficient capital");
      return(false);
   }
   
   if(IsTradeContextBusy()){   
      fxPrint("Sell order error: TradeContext is busy");
      return(false);
   }
   
   open = MarketInfo(Symbol(), MODE_BID);
 
   if (StopLossPoints > 0) sl = open + StopLossPoints * point;
   if (TakeProfitPoints > 0) tp = open - TakeProfitPoints * point;
      
	int result = OrderSend(Symbol(), OP_SELL, lots, open, Slippage, sl, tp, fxAlgo_name, fxGenerateMagic(MagicIndex));

	if (result == -1){
	    fxPrint("Failed to Sell: " + Last_Error_Text());
	   return(false); 
	}
	
   return(true);	
}
///===============================================================================================================================================================
bool Buy_with_MM (int MagicIndex, double StopLossPoints, double TakeProfitPoints, int Slippage, double RiskPerTrade, double RiskPerMagic, double RiskPerAccount) {
   
   double open, sl = 0, tp = 0;   
   double point = Point;   
   double lots = fxVarLotsSlPoints(MagicIndex,Symbol(),StopLossPoints,RiskPerTrade,RiskPerMagic,RiskPerAccount);  
   
   if(lots < MarketInfo(Symbol(),MODE_MINLOT)) {
      fxPrint("Sell order error: insufficient capital");
      return(false);
   }
   
   if(IsTradeContextBusy()){   
      fxPrint("Sell order error: TradeContext is busy");
      return(false);
   }
   
   open = MarketInfo(Symbol(), MODE_ASK);
   
   if (StopLossPoints > 0) sl = open - StopLossPoints *  point;
   if (TakeProfitPoints > 0) tp = open + TakeProfitPoints * point;
      
	int result = OrderSend(Symbol(), OP_BUY, lots, open, Slippage, sl, tp, fxAlgo_name, fxGenerateMagic(MagicIndex));

	if (result == -1){
		fxPrint("Failed to Buy: " + Last_Error_Text());
	   return(false); 
	}

   return(true);
}
///===============================================================================================================================================================
string Last_Error_Text () {
   
   switch (GetLastError()) {
      case 0:     return ("");
      case 1:     return ("no error");         
      case 2:     return ("common error");         
      case 3:     return ("invalid trade parameters");         
      case 4:     return ("trade server is busy");       
      case 5:     return ("old version of the client terminal");         
      case 6:     return ("no connection with trade server");         
      case 7:     return ("not enough rights");         
      case 8:     return ("too frequent requests");         
      case 9:     return ("malfunctional trade operation (never returned error)");         
      case 64:    return ("account disabled");         
      case 65:    return ("invalid account");         
      case 128:   return ("trade timeout");         
      case 129:   return ("invalid price");         
      case 130:   return ("invalid stops");         
      case 131:   return ("invalid trade volume");         
      case 132:   return ("market is closed");         
      case 133:   return ("trade is disabled");         
      case 134:   return ("not enough money");         
      case 135:   return ("price changed");         
      case 136:   return ("off quotes");         
      case 137:   return ("broker is busy (never returned error)");         
      case 138:   return ("requote");         
      case 139:   return ("order is locked");         
      case 140:   return ("long positions only allowed");         
      case 141:   return ("too many requests");         
      case 145:   return ("modification denied because order too close to market");         
      case 146:   return ("trade context is busy");         
      case 147:   return ("expirations are denied by broker");         
      case 148:   return ("amount of open and pending orders has reached the limit");         
      case 4000:  return ("no error (never generated code)");         
      case 4001:  return ("wrong function pointer");         
      case 4002:  return ("array index is out of range");         
      case 4003:  return ("no memory for function call stack");         
      case 4004:  return ("recursive stack overflow");         
      case 4005:  return ("not enough stack for parameter");         
      case 4006:  return ("no memory for parameter string");         
      case 4007:  return ("no memory for temp string");         
      case 4008:  return ("not initialized string");         
      case 4009:  return ("not initialized string in array");         
      case 4010:  return ("no memory for array\' string");         
      case 4011:  return ("too long string");         
      case 4012:  return ("remainder from zero divide");         
      case 4013:  return ("zero divide");         
      case 4014:  return ("unknown command");         
      case 4015:  return ("wrong jump (never generated error)");         
      case 4016:  return ("not initialized array");         
      case 4017:  return ("dll calls are not allowed");         
      case 4018:  return ("cannot load library");         
      case 4019:  return ("cannot call function");         
      case 4020:  return ("expert function calls are not allowed");         
      case 4021:  return ("not enough memory for temp string returned from function");         
      case 4022:  return ("system is busy (never generated error)");         
      case 4050:  return ("invalid function parameters count");         
      case 4051:  return ("invalid function parameter value");         
      case 4052:  return ("string function internal error");         
      case 4053:  return ("some array error");         
      case 4054:  return ("incorrect series array using");         
      case 4055:  return ("custom indicator error");         
      case 4056:  return ("arrays are incompatible");         
      case 4057:  return ("global variables processing error");         
      case 4058:  return ("global variable not found");         
      case 4059:  return ("function is not allowed in testing mode");         
      case 4060:  return ("function is not confirmed");         
      case 4061:  return ("send mail error");         
      case 4062:  return ("string parameter expected");         
      case 4063:  return ("integer parameter expected");         
      case 4064:  return ("double parameter expected");         
      case 4065:  return ("array as parameter expected");         
      case 4066:  return ("requested history data in update state");         
      case 4099:  return ("end of file");         
      case 4100:  return ("some file error");         
      case 4101:  return ("wrong file name");         
      case 4102:  return ("too many opened files");         
      case 4103:  return ("cannot open file");         
      case 4104:  return ("incompatible access to a file");         
      case 4105:  return ("no order selected");         
      case 4106:  return ("unknown symbol");         
      case 4107:  return ("invalid price parameter for trade function");         
      case 4108:  return ("invalid ticket");         
      case 4109:  return ("trade is not allowed in the expert properties");
      case 4110:  return ("longs are not allowed in the expert properties");
      case 4111:  return ("shorts are not allowed in the expert properties");
      case 4200:  return ("object is already exist");
      case 4201:  return ("unknown object property");
      case 4202:  return ("object is not exist");
      case 4203:  return ("unknown object type");
      case 4204:  return ("no object name");
      case 4205:  return ("object coordinates error");
      case 4206:  return ("no specified subwindow");
      case 4207:  return ("some object error");
      default  :  return ("unknown error");
   }
}

