//+------------------------------------------------------------------+
//|                                                 Mahmoud_Fibbo.mq4|
//|          Copyright 2020, mahmoudbaram@gmail.com (+1-978-390-0277)|
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Mahmoud_Fibbo"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
//--- input parameters
input bool SendTrades = True;

input string comment1 = "******Money Management******";
input double standard_lot_size = 0.01;    //standard lot size

input string comment3 = "******Entry/Exit Filter******";
// Trailing stop indicator/ stoploss pips
input double pips_dist = 10; //pip dis for open position
input double takeproft = 18; // take profit

input string comment4 = "******OTHER******";
input string ea_comment = "Mahmoud";
input int    magic_num = 88888;

ENUM_TIMEFRAMES      period=PERIOD_CURRENT;  // timeframe
ENUM_APPLIED_PRICE   price_type=PRICE_CLOSE;
int                  line_mode=MODE_MAIN;

int digits;
double points;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   digits = (int) MarketInfo(_Symbol, MODE_DIGITS);
   points = MarketInfo(_Symbol, MODE_POINT);
   if(digits == 3 || digits == 5)
     {
      points *=10;
     }

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
    GenerateSignal(Symbol());
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GenerateSignal(string symbol)
  {
   int buynum_pos,
       sellnum_pos,
       ticket = -1,
       buycounter = 0,
       sellcounter = 0
       ;
   double tp =0.0;
   bool  buytpmod = false,
         selltpmod = false
   ;      
   static int reset;
   if(Hour()==0 && reset ==1)
     {
      reset = 0;
     }
   if(Hour()!=0)
      reset = 1;
      
   buynum_pos = OpenTradesForMNandPairTypeSymbol(symbol, ea_comment, OP_BUY);
   sellnum_pos = OpenTradesForMNandPairTypeSymbol(symbol, ea_comment, OP_SELL);
   if(buynum_pos == 0 && SendTrades)
     {
         RefreshRates();
         ticket = OrderSend(symbol, OP_BUY, standard_lot_size, Ask, 1, 0.0, Ask + takeproft*points, ea_comment, magic_num);
     }
   if(sellnum_pos == 0 && SendTrades)
     {
         RefreshRates();
         ticket = OrderSend(symbol, OP_SELL, standard_lot_size, Bid, 1, 0.0, Bid - takeproft*points, ea_comment, magic_num);
     }  
   for(int i = OrdersTotal() - 1; i>=0; i--){
      if(OrderSelect(i, SELECT_BY_POS,MODE_TRADES)){
         if(OrderSymbol() == symbol && OrderType() == OP_BUY && OrderComment() == ea_comment){
            if(Ask <= OrderOpenPrice() - pips_dist*points){
               RefreshRates();
               ticket = OrderSend(symbol, OP_BUY, standard_lot_size*fib_seq(buynum_pos), Ask, 1, 0.0, Ask + takeproft*points, ea_comment, magic_num);
               buytpmod = True;
            }
            break;
         }
      }
   }
   if(buytpmod){
      for(int i = OrdersTotal() - 1; i>=0; i--){
         if(OrderSelect(i, SELECT_BY_POS,MODE_TRADES)){
            if(OrderSymbol() == symbol && OrderType() == OP_BUY && OrderComment() == ea_comment){
               if(buycounter == 0){
                  tp = OrderTakeProfit();
                  buycounter +=1;
               }else{
                  RefreshRates();
                  ticket = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss() ,tp, 0);
                  buytpmod = False;
               }   
            }
         }
      }
   }
   for(int i = OrdersTotal() - 1; i>=0; i--){
      if(OrderSelect(i, SELECT_BY_POS,MODE_TRADES)){
         if(OrderSymbol() == symbol && OrderType() == OP_SELL && OrderComment() == ea_comment){
            if(Bid >= OrderOpenPrice() + pips_dist*points){
               RefreshRates();
               ticket = OrderSend(symbol, OP_SELL, standard_lot_size*fib_seq(sellnum_pos), Bid, 1, 0.0, Bid - takeproft*points, ea_comment, magic_num);
               selltpmod = True;
            }
            break;
         }
      }
   }
   if(selltpmod){
      for(int i = OrdersTotal() - 1; i>=0; i--){
         if(OrderSelect(i, SELECT_BY_POS,MODE_TRADES)){
            if(OrderSymbol() == symbol && OrderType() == OP_SELL && OrderComment() == ea_comment){
               if(sellcounter == 0){
                  tp = OrderTakeProfit();
                  sellcounter +=1;
               }else{
                  RefreshRates();
                  ticket = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss() ,tp, 0);
                  selltpmod = False;
               }   
            }
         }
      }
   }
   
  }
//+------------------------------------------------------------------+


int OpenTradesForMNandPairTypeSymbol(string sOrderSymbol, string comment, int type)
{
int icnt, itotal, retval;

retval=0;
itotal=OrdersTotal();

   for(icnt=0;icnt<itotal;icnt++) // for loop
     {
      if(OrderSelect(icnt, SELECT_BY_POS, MODE_TRADES)){
       // check for opened position, symbol & MagicNumber
       if (OrderSymbol()== sOrderSymbol && OrderComment() == comment && OrderType() == type)
        {
          //if (OrderMagicNumber()==iMN) 
            //{
              retval++;
            //}       
        } // sOrderSymbol
     } // for loop
      }
   return(retval);
}

int fib_seq(int num_pos){
   int fib0 = 0, fib1 = 1;
   int fibn = 0;
   int counter = 0;
   while(counter < num_pos+1){
      fibn = fib1 + fib0;
      fib0 = fib1;
      fib1 = fibn;
      counter +=1;
   }
   return(fibn);   
}