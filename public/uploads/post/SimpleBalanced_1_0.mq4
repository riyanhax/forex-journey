   
   
   //Simple Balanced strategy
   //http://forex-strategies-revealed.com/trading-strategy-basicbalanced
   //to eur/usd
   
   extern double TP = 10;  //pip
   extern double SL = 10;  //pip
   extern double lot = 1;
   
   //signals
   string ema, rsi, sto;
   
   
   
   int init(){
      TP /= (10*10*10*10);
      SL /= (10*10*10*10);
   }
   
   int start(){
      getsignals();
      if (OrdersTotal() == 0){
         if (rsi == "buy" && sto == "buy" && ema == "buy"){
            //OrderSend(Symbol(), OP_BUY,  lot, Ask, 3, Ask-SL, Ask+TP, NULL, 0, NULL, LimeGreen);
            OrderSend(Symbol(), OP_BUY,  lot, Ask, 3, NULL, NULL, NULL, 0, NULL, LimeGreen);
         }
         if (rsi == "sell" && sto == "sell" && ema == "sell"){
            //OrderSend(Symbol(), OP_SELL, lot, Bid, 3, Ask+SL, Ask-TP, NULL, 0, NULL, Red);
            OrderSend(Symbol(), OP_SELL, lot, Bid, 3, NULL, NULL, NULL, 0, NULL, Red);
         }
      }
      
      //close
      if (OrdersTotal() > 0){
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         if (OrderType() == OP_BUY && ema == "sell"){
            OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrNONE);
         }
         if (OrderType() == OP_SELL && ema == "buy"){
            OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrNONE);
         }
      }
      
      
      Comment("rsi: " + rsi + ", ema: " + ema + ", sto: " + sto);
   }
   
   int getsignals(){
      //Stochastic
      double sto_m = (iStochastic(NULL,0,14,3,3,MODE_SMA,0,MODE_MAIN,1) + iStochastic(NULL,0,14,3,3,MODE_SMA,0,MODE_SIGNAL,1))/2;
      if (sto_m < 50 && sto_m > 20){
         sto = "sell";
      } else if (sto_m > 50 && sto_m < 80){
         sto = "buy";
      } else {
         sto = "";
      }
      //EMA
      if (iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,1) > iMA(NULL,0,10,0,MODE_EMA,PRICE_CLOSE,1)){
         ema = "buy";
      } else {
         ema = "sell";
      }
      //RSI
      if (iRSI(NULL,0,14,PRICE_CLOSE,1) > 50){
         rsi = "buy";
      } else {
         rsi = "sell";
      }
   }