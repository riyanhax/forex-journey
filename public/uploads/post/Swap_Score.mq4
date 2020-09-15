//+------------------------------------------------------------------+
//|                                                   Swap_Score.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   double swap_score=0.0;
   int symbol_count=0;
   string sym_name;
   int iCount=SymbolsTotal(false); // true, the function returns the number of symbols selected in MarketWatch.
      for(int i=0; i<=iCount-1; i++){
         sym_name=SymbolName(i,false);// true, the symbol is taken from the list of symbols selected in MarketWatch.
         if(MarketInfo(sym_name,MODE_SWAPLONG)>0){
            symbol_count++;
            swap_score = swap_score + MarketInfo(sym_name,MODE_SWAPLONG);
         }
         if(MarketInfo(sym_name,MODE_SWAPSHORT)>0){
            symbol_count++;
            swap_score = swap_score + MarketInfo(sym_name,MODE_SWAPSHORT);
         }     
      }
      MessageBox("Tradable Symbols = " + symbol_count + " Swap Score = " + swap_score,"Swap Score",MB_OK);
  }
//+------------------------------------------------------------------+
