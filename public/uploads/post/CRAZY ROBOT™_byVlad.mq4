//+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
//|                                                 CRAZY ROBOT™.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#property copyright "Copyright © 2011 SOLAR™"
#property link      "http://www.metaquotes.net"
#property description "PUBLIC VERSION"
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#import "shell32.dll"
   int ShellExecuteA(int a0, string a1, string a2, string a3, string a4, int a5);
#import
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#property strict
enum fn{Off,On};
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
extern fn            NewBarOpen = TRUE;
extern fn                   Buy = TRUE;    // При FALSE новые ордера на покупку открываться не будут, усредняющие ордера (колена) - будут
extern fn                  Sell = TRUE;    // При FALSE новые ордера на продажу открываться не будут, усредняющие ордера (колена) - будут
extern double       LotExponent = 1.8;     // На сколько умножать лот при выставлении следующего колена (напримет: первый лот 0.1, серия: 0.16, 0.26, 0.43 ...
extern double           LockExp = 1.8;     // На сколько умножать общий лот серии
extern double TakeProfitExponent= 1.0;     // На сколько умножать TakeProfit при выставлении следующего колена
extern double              slip = 3.0;     // На сколько может отличаться цена в случае, если ДЦ запросит реквоты (в последний момент немного поменяет цену)
extern double              Lots = 0.01;    // Размер лота для начала торгов
extern int           lotdecimal = 2;       // Сколько знаков после запятой в лоте расчитывать 0- стандартные лоты (1), 1- минилоты (0.1), 2- микро (0.01)
extern double       TakeProfit1 = 10.0;    // Размер тейкпрофита
extern double       TakeProfit2 = 4.0;     // Тейкпрофит основной серии, когда уже выставлен лок
extern double           Pipstep = 12.0;    // Шаг между выставлением новых колен
extern double   PipStepExponent = 1.3;     // На сколько увеличивается следующий шаг
extern int            MaxTrades = 10;      // Вместо колена под этим номером выставиться лок т.е. (если установлено значение 4- четыре колена + пятое будет лок)
extern int          MagicNumber = 123456;  // Волшебное число (помогает советнику отличить свои сделки от чужих)
extern int               PerMFI = 4;       // Настройка идикатора
extern int              RSI_Per = 16;      // Настройка идикатора
extern double        RsiMinimum = 50.0;    // Настройка идикатора
extern double        RsiMaximum = 50.0;    // Настройка идикатора
extern fn         UseEquityStop = FALSE;   // Закрытие всех сделок при просадке средств
extern double   TotalEquityRisk = 20.0;    // Максимальная величина просадки средств от баланса
extern fn       UseTrailingStop = FALSE;   // Включение/Выключение трейлинг стопа
extern double        TrailStart = 30.0;    // Величина трейлинг стопа
extern double         TrailStop = 20.0;    // Шаг трейлинг стопа
extern fn            UseTimeOut = FALSE;   // Использовать таймаут (закрывать сделки, если они "висят" слишком долго)
extern double MaxTradeOpenHours = 48.0;    // Время таймаута сделок в часах (через сколько закрывать зависшие сделки)
extern double          Reinvest = 7.0;     // Реинвестирование в процентах от депозита (при Reinvest = 0 советник работает фиксированным лотом)
extern fn       UseOneAccount = False;     // Использовать только на одном торговом счёте
extern int      NumberAccount = 0101001;   // Номер торгового счёта
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int x;

double Gd_240;
double Gd_248;
int Gi_256 = 2;
double G_pips_260 = 500.0;
double Gd_268;
double Gd_276;
double Gd_unused_284;
double Gd_unused_292;
double Gd_300;
double Gd_308;
double Gd_316;
double Gd_324;
double Gd_332;
double Gd_340;
bool Gi_348;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

extern string EAName = "SOLAR™";

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int Gi_360 = 0;
int G_price_364;
int Gi_368 = 0;
double Gd_372;
double G_pips_380;
int G_pos_388 = 0;
int Gi_392;
double Gd_396 = 0.0;
bool Gi_404 = FALSE;
bool Gi_408 = FALSE;
bool Gi_412 = FALSE;
int Gi_416;
bool Gi_420 = FALSE;
double Gd_424;
double Gd_432;
string G_str_concat_440 = "";
double Gd_448 = 0.0;
bool Gi_456 = FALSE;
int G_datetime_460 = -1;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int init() {

///////////////////////////////////////////////////////////////////////////////
//
   if (UseOneAccount && AccountNumber()!=NumberAccount) {
      Comment("Работа на счёте: "+(string)+AccountNumber()+"  ЗАПРЕЩЕНА ! ! !");
      return (0);
   }  else Comment("");
//   
///////////////////////////////////////////////////////////////////////////////

   Gd_340 = MarketInfo(Symbol(), MODE_SPREAD) * Point;
   G_str_concat_440 = StringConcatenate(WindowExpertName(), "_", MagicNumber, "_");
   Gd_448 = f0_9(G_str_concat_440 + "b_error");
   G_datetime_460 = (int) f0_9(G_str_concat_440 + "gv_last");
   return (0);
}
	  			 					    			 			  				 	    			  	   		    	  					 					      					 	   			   		 			   	 	    	 	 					 	   	       	 			  					     	 		
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void f0_15() {
   string name_20;
   string Lsa_0[] = {"_1_1", "_1_2", "_1_3", "__1", "__2", "__3", "__4", "__balance", "profit_0", "profit_0_", "profit_1", "profit_1_", "profit_2", "profit_2_", "profit_4"};
   int Li_12 = ObjectsTotal() - 1;
   int Li_16 = ArraySize(Lsa_0) - 1;
   for (int Li_4 = Li_12; Li_4 >= 0; Li_4--) {
      name_20 = ObjectName(Li_4);
      if (ObjectFind(name_20) != -1) {
         for (int Li_8 = Li_16; Li_8 >= 0; Li_8--) {
            if (name_20 == Lsa_0[Li_8]) {
               ObjectDelete(name_20);
               break;
            }
         }
      }
   }
}
			 	 	 	    				  		  	    		 	 		 	 							 		 	 	    	 	 	    			 	  	  						  	 	       		   		 	 			  	  									 					  			 	    			  	 	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int deinit() {
   f0_1(G_str_concat_440 + "b_error", Gd_448);
   f0_1(G_str_concat_440 + "gv_last", G_datetime_460);
   f0_15();
   ObjectDelete("profit_5");
   ObjectDelete("name");
   return (0);
}
		  	  		 	  	  	 			 	   	 			  	  	   		 		    			  			   	 		 	 	 				 				  	 		 			  	  	 	   	 		 			 	 	 		 			   	 							  	 		 	 	   		
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int f0_1(string A_var_name_0, double Ad_8) {
   if (IsTesting() == FALSE) {
      if (GlobalVariableSet(A_var_name_0, Ad_8) > 0) return (1);
      return (0);
   }
   return (0);
}
	 	 			 		    				 			 	 	  	  	  	 					 						   	 	  			 		    		    		 		 				 	     	    	  			   		   		 		 			 		  			   	 	 		    		 		 	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double f0_9(string A_var_name_0) {
   if (IsTesting() == FALSE)
      if (GlobalVariableCheck(A_var_name_0)) return (GlobalVariableGet(A_var_name_0));
   return (0);
}
	  			   			   	 		 									 			  			 	    		 		 	  		  	 				 	     	  		 	  	 		   	 				    		    		  						    	  		   	 	    				 	    	   
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int start() {

///////////////////////////////////////////////////////////////////////////////
//
   if (UseOneAccount && AccountNumber()!=NumberAccount) {
      Comment("Работа на счёте: "+(string)+AccountNumber()+"  ЗАПРЕЩЕНА ! ! !");
      return (0);
   }  else Comment("");
//   
///////////////////////////////////////////////////////////////////////////////
   
   double iclose_44;
   double iclose_52;

   Stempel();
   
   Gi_392 = f0_20();
   Gd_240 = MaxTrades;
   f0_17();
   f0_2();
   
   if (Gi_392 >= MaxTrades - 1 && Gi_392 >= 1) Gd_248 = TakeProfit2;
   else Gd_248 = TakeProfit1;
   double imfi_4 = iMFI(NULL, 0, PerMFI, 1);
   double imfi_12 = iMFI(NULL, 0, PerMFI, 0);
   double irsi_20 = iRSI(NULL, 0, RSI_Per, PRICE_CLOSE, 0);
   double icci_28 = iCCI(NULL, 0, 55, PRICE_CLOSE, 0);
   G_pips_380 = NormalizeDouble(Pipstep * MathPow(PipStepExponent, Gi_368), 0);
   if (UseTrailingStop && Gi_392 < MaxTrades) f0_23((int)TrailStart, (int)TrailStop, Gd_300);
   if (UseTimeOut) {
      if (TimeCurrent() >= G_price_364) {
         f0_6();
         Print("Closed All due to TimeOut");
      }
   }
   double Ld_36 = f0_8();
   if (UseEquityStop) {
      if (Ld_36 < 0.0 && MathAbs(Ld_36) > TotalEquityRisk / 100.0 * f0_13()) {
         f0_6();
         Print("Closed All due to Stop Out");
         Gi_420 = FALSE;
      }
   }
   if (Gi_392 > MaxTrades) {
      if (Ld_36 > 100.0 * f0_4()) {
         f0_6();
         Print("Closed All due to Lock Profit");
         Gi_420 = FALSE;
      }
   }
   if (Gi_392 > Gd_240 && LockExp == 1.0) {
      Gd_268 = 0;
      for (G_pos_388 = OrdersTotal() - 1; G_pos_388 >= 0; G_pos_388--) {
        x = OrderSelect(G_pos_388, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderTakeProfit() > 0.0) x = OrderModify(OrderTicket(), NormalizeDouble(OrderOpenPrice(), Digits), NormalizeDouble(OrderStopLoss(), Digits), NormalizeDouble(Gd_268, Digits), 0, Yellow);
      }
   }
   if (NewBarOpen) {
      if (Gi_360 == Time[0]) return (0);
      Gi_360 =(int) Time[0];
   }
   if (Gi_392 == 0) Gi_348 = FALSE;
   for (G_pos_388 = OrdersTotal() - 1; G_pos_388 >= 0; G_pos_388--) {
      x = OrderSelect(G_pos_388, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_BUY) {
            Gi_408 = TRUE;
            Gi_412 = FALSE;
            break;
         }
      }
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_SELL) {
            Gi_408 = FALSE;
            Gi_412 = TRUE;
            break;
         }
      }
   }
   if (Gi_392 > 0 && Gi_392 <= MaxTrades) {
      RefreshRates();
      Gd_324 = f0_3();
      Gd_332 = f0_10();
      if (Gi_392 >= Gd_240) imfi_4 = 10;
      if (NewBarOpen) {
         if (Gi_408 && Gd_324 - Ask >= G_pips_380 * Point && imfi_4 < 20.0) Gi_404 = TRUE;
      } else
         if (Gi_408 && Gd_324 - Ask >= G_pips_380 * Point) Gi_404 = TRUE;
      if (Gi_392 >= Gd_240) imfi_4 = 90;
      if (NewBarOpen) {
         if (Gi_412 && Bid - Gd_332 >= G_pips_380 * Point && imfi_4 > 80.0) Gi_404 = TRUE;
      } else
         if (Gi_412 && Bid - Gd_332 >= G_pips_380 * Point) Gi_404 = TRUE;
   }
   if (Gi_392 < 1) {
      Gi_412 = FALSE;
      Gi_408 = FALSE;
      Gi_404 = TRUE;
      Gd_276 = AccountEquity();
   }
   if (Gi_404) {
      Gd_324 = f0_3();
      Gd_332 = f0_10();
      if (Gi_412) {
         Gi_368 = Gi_392;
         Gd_372 = NormalizeDouble(f0_4() * MathPow(LotExponent, Gi_368), lotdecimal);
         RefreshRates();
         if (Gd_240 == Gi_392) {
            Gi_416 = f0_18(0, NormalizeDouble(f0_19() * LockExp, lotdecimal), NormalizeDouble(Ask, Digits), (int)slip, NormalizeDouble(Bid, Digits), 0, 0, EAName + "-" + IntegerToString(Gi_368), MagicNumber,
               0, Blue);
         } else Gi_416 = f0_18(1, Gd_372, NormalizeDouble(Bid, Digits), (int)slip, NormalizeDouble(Ask, Digits), 0, 0, EAName + "-" + IntegerToString(Gi_368), MagicNumber, 0, HotPink);
         if (Gi_416 < 0) {
            Print("Error: ", GetLastError());
            return (0);
         }
         Gd_332 = f0_10();
         Gi_404 = FALSE;
         Gi_420 = TRUE;
      } else {
         if (Gi_408) {
            Gi_368 = Gi_392;
            Gd_372 = NormalizeDouble(f0_4() * MathPow(LotExponent, Gi_368), lotdecimal);
            if (Gd_240 == Gi_392) {
               Gi_416 = f0_18(1, NormalizeDouble(f0_19() * LockExp, lotdecimal), NormalizeDouble(Bid, Digits), (int)slip, NormalizeDouble(Ask, Digits), 0, 0, EAName + "-" + IntegerToString(Gi_368), MagicNumber,
                  0, HotPink);
            } else Gi_416 = f0_18(0, Gd_372, NormalizeDouble(Ask, Digits), (int)slip, NormalizeDouble(Bid, Digits), 0, 0, EAName + "-" + IntegerToString(Gi_368), MagicNumber, 0, Blue);
            if (Gi_416 < 0) {
               Print("Error: ", GetLastError());
               return (0);
            }
            Gd_324 = f0_3();
            Gi_404 = FALSE;
            Gi_420 = TRUE;
         }
      }
   }
   if (Gi_404 && Gi_392 < 1) {
      iclose_44 = iClose(Symbol(), 0, Gi_256);
      iclose_52 = iClose(Symbol(), 0, 0);
      Gd_308 = NormalizeDouble(Bid, Digits);
      Gd_316 = NormalizeDouble(Ask, Digits);
      if ((!Gi_412) && !Gi_408) {
         Gi_368 = Gi_392;
         Gd_372 = NormalizeDouble(f0_4() * MathPow(LotExponent, Gi_368), lotdecimal);
         if (Sell) {
            if (iclose_44 > iclose_52 && imfi_12 > 20.0 && irsi_20 < RsiMinimum && icci_28 > -100.0) {
               Gi_416 = f0_18(1, Gd_372, Gd_308, (int)slip, Gd_308, 0, 0, EAName + "-" + IntegerToString(Gi_368), MagicNumber, 0, HotPink);
               if (Gi_416 < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               Gd_332 = f0_10();
               Gi_420 = TRUE;
            }
         }
         if (Buy) {
            if (iclose_44 < iclose_52 && imfi_12 < 80.0 && irsi_20 > RsiMaximum && icci_28 < 100.0) {
               Gi_416 = f0_18(0, Gd_372, Gd_316, (int)slip, Gd_316, 0, 0, EAName + "-" + IntegerToString(Gi_368), MagicNumber, 0, Blue);
               if (Gi_416 < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               Gd_324 = f0_3();
               Gi_420 = TRUE;
            }
         }
         if (Gi_416 > 0) G_price_364 =(int) NormalizeDouble(TimeCurrent() + 60.0 * (60.0 * MaxTradeOpenHours),2);
         Gi_404 = FALSE;
      }
   }
   Gi_392 = f0_20();
   Gd_300 = 0;
   double Ld_60 = 0;
   for (G_pos_388 = OrdersTotal() - 1; G_pos_388 >= 0; G_pos_388--) {
      x = OrderSelect(G_pos_388, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
            Gd_300 += OrderOpenPrice() * OrderLots();
            Ld_60 += OrderLots();
            if (Gi_392 <= MaxTrades && OrderTakeProfit() == 0.0) Gi_420 = TRUE;
         }
      }
   }
   if (Gi_392 > 0) Gd_300 = NormalizeDouble(Gd_300 / Ld_60, Digits);
   if (Gi_420) {
      for (G_pos_388 = OrdersTotal() - 1; G_pos_388 >= 0; G_pos_388--) {
         x = OrderSelect(G_pos_388, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) {
               Gd_268 = Gd_300 + Gd_248 * Point * MathPow(TakeProfitExponent, Gi_392);
               Gd_unused_284 = Gd_268;
               Gd_396 = Gd_300 - G_pips_260 * Point;
               Gi_348 = TRUE;
            }
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_SELL) {
               Gd_268 = Gd_300 - Gd_248 * Point;
               Gd_unused_292 = Gd_268;
               Gd_396 = Gd_300 + G_pips_260 * Point;
               Gi_348 = TRUE;
            }
         }
      }
   }
   if (Gi_420 && f0_20() <= MaxTrades) {
      if (Gi_348 == TRUE) {
         for (G_pos_388 = OrdersTotal() - 1; G_pos_388 >= 0; G_pos_388--) {
            x = OrderSelect(G_pos_388, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) x = OrderModify(OrderTicket(), NormalizeDouble(Gd_300, Digits), NormalizeDouble(OrderStopLoss(), Digits), NormalizeDouble(Gd_268, Digits), 0, Yellow);
            Gi_420 = FALSE;
         }
      }
   }
   return (0);
}
	   				 		   	  					  			 	   	   			    				 	 		 	 	 	  		 		  	   	 				 	  			   				   				 	      	 		     		 	 	  		  	    		 		  	 			 
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double f0_19() {
   double Ld_ret_0 = 0;
   for (int pos_8 = OrdersTotal() - 1; pos_8 >= 0; pos_8--) {
      x = OrderSelect(pos_8, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) Ld_ret_0 += OrderLots();
   }
   return (Ld_ret_0);
}
	      				 		  				  	  		  		         	  	      			 				    		   									 	  								 		 		 	 	 				 	 	   	 	  	 	     	 				     		   		  		
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int f0_20() {
   int count_0 = 0;
   for (int pos_4 = OrdersTotal() - 1; pos_4 >= 0; pos_4--) {
      x = OrderSelect(pos_4, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) count_0++;
   }
   return (count_0);
}
		    	 	 	 					 		   	  	  	 	 	    				 	  		 				   	        	 			  	 		 				 				    	 			    			 				    			 	 			 	 	 	  		       	 		 	 	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void f0_6() {
   for (int pos_0 = OrdersTotal() - 1; pos_0 >= 0; pos_0--) {
      x = OrderSelect(pos_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) x = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), (int)slip, Blue);
            if (OrderType() == OP_SELL) x = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), (int)slip, Red);
         }
         Sleep(1000);
      }
   }
}
		  	   	 	  	 		 			 		  	 				 	  	  			 		  	 			  	 	   	 	  	 	 		 	 				 		 		 		   	  	     	 						 	 				 			 	 	 				 		  	 	  	 	    	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int f0_18(int Ai_0, double A_lots_4, double A_price_12, int A_slippage_20, double Ad_24, int Ai_32, int Ai_36, string A_comment_40, int A_magic_48, int A_datetime_52, color A_color_56) {
   int ticket_60 = 0;
   int error_64 = 0;
   int count_68 = 0;
   int Li_72 = 100;
   switch (Ai_0) {
   case 2:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_BUYLIMIT, A_lots_4, A_price_12, A_slippage_20, f0_16(Ad_24, Ai_32), f0_21(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0/* NO_ERROR */) break;
         if (!((error_64 == 4/* SERVER_BUSY */ || error_64 == 137/* BROKER_BUSY */ || error_64 == 146/* TRADE_CONTEXT_BUSY */ || error_64 == 136/* OFF_QUOTES */))) break;
         Sleep(1000);
      }
      break;
   case 4:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_BUYSTOP, A_lots_4, A_price_12, A_slippage_20, f0_16(Ad_24, Ai_32), f0_21(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0/* NO_ERROR */) break;
         if (!((error_64 == 4/* SERVER_BUSY */ || error_64 == 137/* BROKER_BUSY */ || error_64 == 146/* TRADE_CONTEXT_BUSY */ || error_64 == 136/* OFF_QUOTES */))) break;
         Sleep(5000);
      }
      break;
   case 0:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         RefreshRates();
         if (AccountFreeMarginCheck(Symbol(), OP_BUY, A_lots_4) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) {
            Gi_456 = TRUE;
            Gd_448 = AccountBalance();
         }
         ticket_60 = OrderSend(Symbol(), OP_BUY, A_lots_4, NormalizeDouble(Ask, Digits), A_slippage_20, f0_16(NormalizeDouble(Bid, Digits), Ai_32), f0_21(NormalizeDouble(Ask,
            Digits), Ai_36), A_comment_40, A_magic_48, A_datetime_52, A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0/* NO_ERROR */) break;
         if (!((error_64 == 4/* SERVER_BUSY */ || error_64 == 137/* BROKER_BUSY */ || error_64 == 146/* TRADE_CONTEXT_BUSY */ || error_64 == 136/* OFF_QUOTES */))) break;
         Sleep(5000);
      }
      break;
   case 3:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_SELLLIMIT, A_lots_4, A_price_12, A_slippage_20, f0_0(Ad_24, Ai_32), f0_7(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0/* NO_ERROR */) break;
         if (!((error_64 == 4/* SERVER_BUSY */ || error_64 == 137/* BROKER_BUSY */ || error_64 == 146/* TRADE_CONTEXT_BUSY */ || error_64 == 136/* OFF_QUOTES */))) break;
         Sleep(5000);
      }
      break;
   case 5:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_SELLSTOP, A_lots_4, A_price_12, A_slippage_20, f0_0(Ad_24, Ai_32), f0_7(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0/* NO_ERROR */) break;
         if (!((error_64 == 4/* SERVER_BUSY */ || error_64 == 137/* BROKER_BUSY */ || error_64 == 146/* TRADE_CONTEXT_BUSY */ || error_64 == 136/* OFF_QUOTES */))) break;
         Sleep(5000);
      }
      break;
   case 1:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         if (AccountFreeMarginCheck(Symbol(), OP_SELL, A_lots_4) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) {
            Gi_456 = TRUE;
            Gd_448 = AccountBalance();
         }
         ticket_60 = OrderSend(Symbol(), OP_SELL, A_lots_4, NormalizeDouble(Bid, Digits), A_slippage_20, f0_0(NormalizeDouble(Ask, Digits), Ai_32), f0_7(NormalizeDouble(Bid,
            Digits), Ai_36), A_comment_40, A_magic_48, A_datetime_52, A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0/* NO_ERROR */) break;
         if (!((error_64 == 4/* SERVER_BUSY */ || error_64 == 137/* BROKER_BUSY */ || error_64 == 146/* TRADE_CONTEXT_BUSY */ || error_64 == 136/* OFF_QUOTES */))) break;
         Sleep(5000);
      }
   }
   return (ticket_60);
}
			  	 	    	      	 		 	     	 			  	   			 	  		 					  	  								 		   	       		 			   	  		 			 	  	   		  			    				  		 		  									 	 
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double f0_16(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 - Ai_8 * Point);
}
		 			    		   	  	 					 			 				 			 	 	  		 				  		    				 		    	   	 	  	  	   	 	 		    	     		 							 	  	  			  	 	  	 				 		   	   
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double f0_0(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 + Ai_8 * Point);
}
	 		  		 	 				  	      		 	 	  	 		  	   	   	 	   	  	 			   		 	 		 	 	   		  	  		 			 								 		     	      	  		 	 	  	 	  		   		 	 	 		 
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double f0_21(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 + Ai_8 * Point);
}
		  	   	 	  	 		 			 		  	 				 	  	  			 		  	 			  	 	   	 	  	 	 		 	 				 		 		 		   	  	     	 						 	 				 			 	 	 				 		  	 	  	 	    	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double f0_7(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 - Ai_8 * Point);
}
	    	   		 	  	 			 						   			    	 	   	 	 		 					  	   		 	  		 	  			   	 				 	 			 	   		 		 		  	  			   	   		  	  	      		 	  			   
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double f0_8() {
   double Ld_ret_0 = 0;
   for (G_pos_388 = OrdersTotal() - 1; G_pos_388 >= 0; G_pos_388--) {
      x = OrderSelect(G_pos_388, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) Ld_ret_0 += OrderProfit();
   }
   return (Ld_ret_0);
}
		  				  	   	   				  	 	 	   		  			  	 				 				 	 	    		 			 	   	  			 	   		   		 	   			  	     		 		   	 		 	 		 		  	 	  		 			 	 			 
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void f0_23(int Ai_0, int Ai_4, double A_price_8) {
   int Li_16;
   double order_stoploss_20;
   double price_28;
   if (Ai_4 != 0) {
      for (int pos_36 = OrdersTotal() - 1; pos_36 >= 0; pos_36--) {
         if (OrderSelect(pos_36, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
            if (OrderSymbol() == Symbol() || OrderMagicNumber() == MagicNumber) {
               if (OrderType() == OP_BUY) {
                  Li_16 =(int) NormalizeDouble((Bid - A_price_8) / Point, 0);
                  if (Li_16 < Ai_0) continue;
                  order_stoploss_20 = OrderStopLoss();
                  price_28 = Bid - Ai_4 * Point;
                  if (order_stoploss_20 == 0.0 || (order_stoploss_20 != 0.0 && price_28 > order_stoploss_20)) x = OrderModify(OrderTicket(), A_price_8, price_28, OrderTakeProfit(), 0, Aqua);
               }
               if (OrderType() == OP_SELL) {
                  Li_16 =(int) NormalizeDouble((A_price_8 - Ask) / Point, 0);
                  if (Li_16 < Ai_0) continue;
                  order_stoploss_20 = OrderStopLoss();
                  price_28 = Ask + Ai_4 * Point;
                  if (order_stoploss_20 == 0.0 || (order_stoploss_20 != 0.0 && price_28 < order_stoploss_20)) x = OrderModify(OrderTicket(), A_price_8, price_28, OrderTakeProfit(), 0, Red);
               }
            }
            Sleep(1000);
         }
      }
   }
}
		 	   	  				    	   	 	 		 		 		 	     	      			 	 		   	  				  				  	  	    	 					 				 		   			  			  	  	   	  		   			 	 	  				  	  	 
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double f0_13() {
   if (f0_20() == 0) Gd_424 = AccountEquity();
   if (Gd_424 < Gd_432) Gd_424 = Gd_432;
   else Gd_424 = AccountEquity();
   Gd_432 = AccountEquity();
   return (Gd_424);
}
	  		 						 		 			 	    					     		 	 	   	 	   	    			 		  	     	 				 			 			  	 	 			 			 	   	  	 			   	   			     		 		  		  	      			
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double f0_3() {
   double order_open_price_0 = 0.0;
   int ticket_8;
   double Ld_unused_12 = 0;
   int ticket_20 = 0;
   for (int pos_24 = OrdersTotal() - 1; pos_24 >= 0; pos_24--) {
      x = OrderSelect(pos_24, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_BUY) {
         ticket_8 = OrderTicket();
         if (ticket_8 > ticket_20) {
            order_open_price_0 = OrderOpenPrice();
            Ld_unused_12 = order_open_price_0;
            ticket_20 = ticket_8;
         }
      }
   }
   return (order_open_price_0);
}
					   	  	 	 		   	 		   					 				  				 	  	 	    	 	 			 	  		  		 	   		 		    		    	 	    	  					 		 					 		 	 		 			 					 	  		     	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double f0_10() {

string nameobj = "profit_5";

   double order_open_price_0=0.0;
   int ticket_8;
   double Ld_unused_12 = 0;
   int ticket_20 = 0;
   for (int pos_24 = OrdersTotal() - 1; pos_24 >= 0; pos_24--) {
      x = OrderSelect(pos_24, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL) {
         ticket_8 = OrderTicket();
         if (ticket_8 > ticket_20) {
            order_open_price_0 = OrderOpenPrice();
            Ld_unused_12 = order_open_price_0;
            ticket_20 = ticket_8;
         }
      }
   }
   return (order_open_price_0);
}
		 	 	 		 			   	 	  		   		  	  	 	 	  		   	   		 					  	 			 	  	 			 	     	 	 	 		  			  	    	 	 				 		 		       	    				 	 			 	  		 		
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double f0_4() {
   double Ld_ret_24;
   double Ld_0 = MarketInfo(Symbol(), MODE_MINLOT);
   double Ld_8 = MarketInfo(Symbol(), MODE_MAXLOT);
   double Ld_16 = AccountBalance();
   if (Reinvest != 0.0) {
      Ld_ret_24 = NormalizeDouble(Ld_16 * Reinvest / 1000.0 / 100.0, 2);
      if (Ld_ret_24 < Ld_0) Ld_ret_24 = Ld_0;
      if (Ld_ret_24 > Ld_8) Ld_ret_24 = Ld_8;
   } else Ld_ret_24 = Lots;
   return (Ld_ret_24);
}
		 			  	 		   		 	 				  			 		 	 			 			  		 	 		  		 	  				  	    	 	 	 	  		 	   	   		          												  	  	 	  	 	 		 				  	   	  	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void f0_17() {
   color color_64;
   double Ld_0 = f0_14(0);
   string Ls_8 = "__";
   string name_16 = Ls_8 + "1";
   if (ObjectFind(name_16) == -1) {
      ObjectCreate(name_16, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name_16, OBJPROP_CORNER, 0);
      ObjectSet(name_16, OBJPROP_XDISTANCE, 10);
      ObjectSet(name_16, OBJPROP_YDISTANCE, 15);
   }
   string name_24 = "profit_0";
   string name_32 = "profit_1";
   string name_40 = "profit_2";
   string Ls_unused_48 = "profit_3";
   string name_56 = "profit_4";
   string nameobj = "profit_5";
   
   ObjectSetText(name_16, "Заработано сегодня...................", 10, "Verdana", SteelBlue);
   if (ObjectFind(name_24) == -1) {
      ObjectCreate(name_24, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name_24, OBJPROP_CORNER, 0);
      ObjectSet(name_24, OBJPROP_XDISTANCE, 250);
      ObjectSet(name_24, OBJPROP_YDISTANCE, 15);
   }
   if (Ld_0 > 0.0) color_64 = Orange;
   else {
      if (Ld_0 < 0.0) color_64 = Red;
      else color_64 = Gray;
   }
   ObjectSetText(name_24, DoubleToStr(Ld_0, 2), 10, "Verdana", color_64);
   Ld_0 = f0_14(1);
   name_16 = Ls_8 + "2";
   if (ObjectFind(name_16) == -1) {
      ObjectCreate(name_16, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name_16, OBJPROP_CORNER, 0);
      ObjectSet(name_16, OBJPROP_XDISTANCE, 10);
      ObjectSet(name_16, OBJPROP_YDISTANCE, 30);
   }
   ObjectSetText(name_16, "Заработано вчера......................", 10, "Verdana", SteelBlue);
   if (ObjectFind(name_32) == -1) {
      ObjectCreate(name_32, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name_32, OBJPROP_CORNER, 0);
      ObjectSet(name_32, OBJPROP_XDISTANCE, 250);
      ObjectSet(name_32, OBJPROP_YDISTANCE, 30);
   }
   if (Ld_0 > 0.0) color_64 = Orange;
   else {
      if (Ld_0 < 0.0) color_64 = Red;
      else color_64 = Gray;
   }
   ObjectSetText(name_32, DoubleToStr(Ld_0, 2), 10, "Verdana", color_64);
   Ld_0 = f0_14(2);
   name_16 = Ls_8 + "3";
   if (ObjectFind(name_16) == -1) {
      ObjectCreate(name_16, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name_16, OBJPROP_CORNER, 0);
      ObjectSet(name_16, OBJPROP_XDISTANCE, 10);
      ObjectSet(name_16, OBJPROP_YDISTANCE, 45);
   }
   ObjectSetText(name_16, "Заработано позавчера................", 10, "Verdana", SteelBlue);
   if (ObjectFind(name_40) == -1) {
      ObjectCreate(name_40, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name_40, OBJPROP_CORNER, 0);
      ObjectSet(name_40, OBJPROP_XDISTANCE, 250);
      ObjectSet(name_40, OBJPROP_YDISTANCE, 45);
   }
   if (Ld_0 > 0.0) color_64 = Orange;
   else {
      if (Ld_0 < 0.0) color_64 = Red;
      else color_64 = Gray;
   }
   ObjectSetText(name_40, DoubleToStr(Ld_0, 2), 10, "Verdana", color_64);
   name_16 = Ls_8 + "4";
   double Ld_68 = AccountEquity();
   double Ld_76 = AccountBalance();
   if (ObjectFind(name_16) == -1) {
      ObjectCreate(name_16, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name_16, OBJPROP_CORNER, 0);
      ObjectSet(name_16, OBJPROP_XDISTANCE, 10);
      ObjectSet(name_16, OBJPROP_YDISTANCE, 60);
   }
   ObjectSetText(name_16, "Заработано за все время: ..........", 10, "Verdana", SteelBlue);
   color_64 = Orange;
   if (ObjectFind(name_56) == -1) {
      ObjectCreate(name_56, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name_56, OBJPROP_CORNER, 0);
      ObjectSet(name_56, OBJPROP_XDISTANCE, 250);
      ObjectSet(name_56, OBJPROP_YDISTANCE, 60);
   }
   ObjectSetText(name_56, DoubleToStr(f0_22(), 2), 10, "Georgia", color_64);

				 	     		  	     				  	  						 	 	 		  	 			  			   		 		 			 	 	        	    	 	 	  		   	 	 	 		 	 	 			 		    				   	  			 		 			 		   
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if (ObjectFind(nameobj) == -1) {
      ObjectCreate(nameobj, OBJ_LABEL, 0, 0, 0);
      ObjectSet(nameobj, OBJPROP_CORNER, 0);
      ObjectSet(nameobj, OBJPROP_XDISTANCE, 10);
      ObjectSet(nameobj, OBJPROP_YDISTANCE, 83);
      
   }
   
   ObjectSetText(nameobj, "Баланс: " + DoubleToStr(AccountBalance(), 2), 10, "Georgia", SeaGreen);
   
}


double f0_14(int Ai_0) {
   double Ld_ret_4 = 0;
   for (int pos_12 = 0; pos_12 < OrdersHistoryTotal(); pos_12++) {
      if (!(OrderSelect(pos_12, SELECT_BY_POS, MODE_HISTORY))) break;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderCloseTime() >= iTime(Symbol(), PERIOD_D1, Ai_0) && OrderCloseTime() < iTime(Symbol(), PERIOD_D1, Ai_0) + 86400) Ld_ret_4 = Ld_ret_4 + OrderProfit() + OrderCommission() + OrderSwap();
   }
   return (Ld_ret_4);
}
			 		         	   						   	 					 		 	 					 			 	 		   	 			 				  	    		  	   	  	 	       	 		  		 	  				 				  						 	  		 			 				 	   
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double f0_22() {
   double Ld_ret_0 = 0.0;
   int Li_8 = OrdersHistoryTotal() - 1;
   for (int pos_12 = Li_8; pos_12 >= 0; pos_12--) {
      if (OrderSelect(pos_12, SELECT_BY_POS, MODE_HISTORY)) {
         if (OrderSymbol() == Symbol())
            if (OrderMagicNumber() == MagicNumber) Ld_ret_0 += OrderProfit() + OrderCommission() + OrderSwap();
      }
   }
   return (Ld_ret_0);
}
	 	  	 	 	  	    	 	 		 		    	 	 	  	    		 	  	  					 		  				 			 		 	 	     	 		 				  	  						 	      		   		    	 		  		  	  				 				 	 
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void f0_2() {
   string Ls_0;
   string name_8;
   string Ls_unused_16;
   if (Gd_448 < 0.0) Gi_456 = TRUE;
   if (Gi_456) {
      Ls_0 = "__";
      name_8 = Ls_0 + "balance";
      if (NormalizeDouble(AccountBalance(), 4) > NormalizeDouble(Gd_448, 4)) {
         Gi_456 = FALSE;
         Gd_448 = -1;
         if (ObjectFind(name_8) != -1) ObjectDelete(name_8);
      } else {
         if (ObjectFind(name_8) == -1) {
            ObjectCreate(name_8, OBJ_LABEL, 0, 0, 0);
            ObjectSet(name_8, OBJPROP_CORNER, 0);
            ObjectSet(name_8, OBJPROP_XDISTANCE, 10);
            ObjectSet(name_8, OBJPROP_YDISTANCE, 105);
         }
         Ls_unused_16 = "profit_0_1";
         ObjectSetText(name_8, "Просадка имеет критическое значение ! ! !", 11, "Verdana", Olive);
      }
   }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void Stempel() {

   string name = "name";
   
   ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(name, " SOLAR™", 24, "Lucida Handwriting", SeaGreen);
   ObjectSet(name, OBJPROP_CORNER, 2);
   ObjectSet(name, OBJPROP_XDISTANCE, 0);
   ObjectSet(name, OBJPROP_YDISTANCE, 7);
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
// * end * end * end * end * end * end * end * end * end * end * end * end * end * end * end* end * end *
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		 	 		     		    		   	   		  			 	 	  				 	 		 	   	  	 	  					 	 	   				    	 	 		    				 		 	   	  	    						 						 	 		 	  					  		 
