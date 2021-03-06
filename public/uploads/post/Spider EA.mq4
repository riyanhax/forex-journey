/*
   Generated by EX4-TO-MQ4 decompiler LITE V4.0.409.1q [-]
   Website: https://purebeam.biz
   E-mail : purebeam@gmail.com
*/
extern string ID = "Fill this out with your ID";
extern int TakeProfit = 30;
extern int Step = 10;
extern int Slippage = 3;
extern int Period_back = 300;
extern bool MoneyManagement = TRUE;
extern double Risklevel = 33.0;
extern double FixLots = 0.1;
extern int Maxlayer = 100;
extern bool HedgeOn = FALSE;
extern double HedgeLotMultiplier = 1.0;
extern int HedgeFromLayer = 24;
extern int HedgeCloseStrategy = 2;
extern int HedgeCloseLayer = 13;
extern bool InformationBoardVisible = TRUE;
extern string Language_Options = "<== 1: English, 2: Hungarian ==>";
extern int Language = 1;

int start() {
   int li_0;
   int li_12;
   int li_16;
   int li_20;
   int li_24;
   string ls_44;
   double ld_132;
   string ls_68 = AccountNumber();
   string ls_76 = "";
   for (int li_8 = 0; li_8 < StringLen(ls_68); li_8 += 2) {
      if (li_8 < StringLen(ls_68) - 1) ls_76 = ls_76 + (StrToInteger(StringSubstr(ls_68, li_8, 1)) * StrToInteger(StringSubstr(ls_68, li_8 + 1, 1)));
      if (li_8 == StringLen(ls_68) - 1) ls_76 = ls_76 + StrToInteger(StringSubstr(ls_68, li_8, 1));
   }
   ls_76 = 19 * StrToInteger(ls_76);
   if (Digits == 3 || Digits == 5) {
      li_12 = 10 * TakeProfit;
      li_16 = 10 * Step;
      li_20 = 10 * Slippage;
   }
   if (Digits == 4) {
      li_12 = TakeProfit;
      li_16 = Step;
      li_20 = Slippage;
   }
   if (NormalizeDouble(MarketInfo(Symbol(), MODE_LOTSTEP), 2) == 0.01) li_24 = 2;
   if (NormalizeDouble(MarketInfo(Symbol(), MODE_LOTSTEP), 2) == 0.1) li_24 = 1;
   if (MoneyManagement == TRUE) ld_132 = NormalizeDouble(AccountBalance() / 10000000.0 * Risklevel, li_24);
   else ld_132 = NormalizeDouble(FixLots, li_24);
   double ld_140 = NormalizeDouble(ld_132 * HedgeLotMultiplier, li_24);
   if (ld_132 < MarketInfo(Symbol(), MODE_MINLOT)) {
      if (Language == 1) {
         ls_44 = ls_44 
         + "\nCalculated lot size is too low. Please increase risk or switch to fix lot or increase account balance.";
      }
      if (Language == 2) ls_44 = "\nT?l alacsony lot m?ret. N?veld meg a Risklevel ?rt?k?t vagy v?lts fix lotra vagy n?veld a sz?mla egyenleget.";
   }
   if (ld_140 < MarketInfo(Symbol(), MODE_MINLOT) && HedgeOn == TRUE) {
      if (Language == 1) {
         ls_44 = ls_44 
         + "\nCalculated HEDGE lot size is too low. You should turn hedge function off or increase hedge lot multiplier.";
      }
      if (Language == 2) {
         ls_44 = ls_44 
         + "\nA HEDGE lot m?ret t?l alacsony. Kapcsold ki a hedge funkci?t vagy n?vrld a HedgeLotMultiplier ?rt?k?t.";
      }
   }
   double ld_116 = 0;
   for (li_8 = 1; li_8 <= Period_back; li_8++) ld_116 += Close[li_8];
   double ld_124 = ld_116 / Period_back;
   string ls_52 = "Spider";
   string ls_60 = "Sp_Hedge";
   int li_28 = 0;
   int li_32 = 0;
   int li_36 = 0;
   int li_40 = 0;
   double ld_84 = 0;
   double ld_100 = 0;
   double ld_92 = 0;
   double ld_108 = 0;
   double ld_180 = 0;
   double ld_196 = 0;
   double ld_188 = 0;
   double ld_204 = 0;
   double ld_148 = 0;
   double ld_156 = 0;
   double ld_164 = 0;
   double ld_172 = 0;
   for (li_8 = 0; li_8 <= OrdersTotal(); li_8++) {
      OrderSelect(li_8, SELECT_BY_POS);
      if (OrderType() == OP_SELL && OrderComment() == ls_52) {
         li_28++;
         ld_84 += OrderOpenPrice();
         if (ld_148 == 0.0) ld_148 = OrderOpenPrice();
         else
            if (OrderOpenPrice() > ld_148) ld_148 = OrderOpenPrice();
      }
      if (OrderType() == OP_BUY && OrderComment() == ls_52) {
         li_32++;
         ld_100 += OrderOpenPrice();
         if (ld_156 == 0.0) ld_156 = OrderOpenPrice();
         else
            if (OrderOpenPrice() < ld_156) ld_156 = OrderOpenPrice();
      }
      if (OrderType() == OP_SELL && OrderComment() == ls_60) {
         li_36++;
         ld_180 += OrderOpenPrice();
         if (ld_164 == 0.0) ld_164 = OrderOpenPrice();
         else
            if (OrderOpenPrice() > ld_164) ld_164 = OrderOpenPrice();
      }
      if (OrderType() == OP_BUY && OrderComment() == ls_60) {
         li_40++;
         ld_196 += OrderOpenPrice();
         if (ld_172 == 0.0) {
            ld_172 = OrderOpenPrice();
            continue;
         }
         if (OrderOpenPrice() < ld_172) ld_172 = OrderOpenPrice();
      }
   }
   if (li_28 > 0) ld_92 = ld_84 / li_28;
   if (li_36 > 0) ld_188 = ld_180 / li_36;
   if (li_28 > Maxlayer) {
      ld_84 = 0;
      for (li_8 = 0; li_8 <= OrdersTotal(); li_8++) {
         OrderSelect(li_8, SELECT_BY_POS);
         if (OrderType() == OP_SELL && OrderComment() == ls_52 && OrderMagicNumber() >= li_28 - (Maxlayer - 1)) ld_84 += OrderOpenPrice();
      }
      ld_92 = ld_84 / Maxlayer;
   }
   if (li_32 > 0) ld_108 = ld_100 / li_32;
   if (li_40 > 0) ld_204 = ld_196 / li_40;
   if (li_32 > Maxlayer) {
      ld_100 = 0;
      for (li_8 = 0; li_8 <= OrdersTotal(); li_8++) {
         OrderSelect(li_8, SELECT_BY_POS);
         if (OrderType() == OP_BUY && OrderComment() == ls_52 && OrderMagicNumber() >= li_32 - (Maxlayer - 1)) ld_100 += OrderOpenPrice();
      }
      ld_108 = ld_100 / Maxlayer;
   }
   if (InformationBoardVisible == TRUE) {
      if (Language == 1) {
         ls_44 = ls_44 
            + "\nNumber of sell trades: " + li_28 + "(" + li_40 + ")" 
         + "\nNumber of buy trades: " + li_32 + "(" + li_36 + ")";
         ls_44 = ls_44 
            + "\n\nProfit target (by trades): " + TakeProfit 
         + "\nStep distance to open new position: " + Step;
         if (li_28 > 0) {
            ls_44 = ls_44 
            + "\n\nAverage price sell order: " + StringSubstr(DoubleToStr(ld_92, 8), 0, 6);
         }
         if (li_28 > 0) {
            ls_44 = ls_44 
            + "\nTarget price sell order: " + StringSubstr(DoubleToStr(ld_92 - Point * li_12, 8), 0, 6);
         }
         if (li_32 > 0) {
            ls_44 = ls_44 
            + "\n\nAverage price buy order: " + StringSubstr(DoubleToStr(ld_108, 8), 0, 6);
         }
         if (li_32 > 0) {
            ls_44 = ls_44 
            + "\n\nTarget price buy order: " + StringSubstr(DoubleToStr(ld_108 + Point * li_12, 8), 0, 6);
         }
         ls_44 = ls_44 
         + "\n\nReference price (MA(" + Period_back + ")): " + StringSubstr(DoubleToStr(NormalizeDouble(ld_124, Digits), 8), 0, 6);
         if (MoneyManagement == TRUE) {
            ls_44 = ls_44 
            + "\nMoney Management: True";
         } else {
            ls_44 = ls_44 
            + "\nMoney Management: False";
         }
      }
      if (Language == 2) {
         ls_44 = ls_44 
            + "\nSell trade-ek sz?ma: " + li_28 + "(" + li_40 + ")" 
         + "\nBuy trade-ek sz?ma: " + li_32 + "(" + li_36 + ")";
         ls_44 = ls_44 
            + "\n\nProfit c?l (poz?ci?nk?nt): " + TakeProfit 
         + "\nL?p?sk?z ?j poz?ci? nyit?s?hoz: " + Step;
         if (li_28 > 0) {
            ls_44 = ls_44 
            + "\n\n?tlag?r sell order: " + StringSubstr(DoubleToStr(ld_92, 8), 0, 6);
         }
         if (li_28 > 0) {
            ls_44 = ls_44 
            + "\nC?l?r sell order: " + StringSubstr(DoubleToStr(ld_92 - Point * li_12, 8), 0, 6);
         }
         if (li_32 > 0) {
            ls_44 = ls_44 
            + "\n\n?tlag?r buy order: " + StringSubstr(DoubleToStr(ld_108, 8), 0, 6);
         }
         if (li_32 > 0) {
            ls_44 = ls_44 
            + "\n\nC?l?r buy order: " + StringSubstr(DoubleToStr(ld_108 + Point * li_12, 8), 0, 6);
         }
         ls_44 = ls_44 
         + "\n\nReferencia ?rfolyam (MA(" + Period_back + ")): " + StringSubstr(DoubleToStr(NormalizeDouble(ld_124, Digits), 8), 0, 6);
         if (MoneyManagement == TRUE) {
            ls_44 = ls_44 
            + "\nMoney Management: Igen";
         } else {
            ls_44 = ls_44 
            + "\nMoney Management: Nem";
         }
      }
      Comment(ls_44);
   }
   for (li_8 = 0; li_8 <= OrdersTotal(); li_8++) {
      OrderSelect(li_8, SELECT_BY_POS);
      if (OrderType() == OP_SELL && OrderComment() == ls_52 && OrderTakeProfit() != NormalizeDouble(ld_92 - Point * li_12, Digits) && OrderMagicNumber() >= li_28 - (Maxlayer - 1)) OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(0, Digits), NormalizeDouble(ld_92 - Point * li_12, Digits), 0, Green);
      if (OrderType() == OP_BUY && OrderComment() == ls_52 && OrderTakeProfit() != NormalizeDouble(ld_108 + Point * li_12, Digits) && OrderMagicNumber() >= li_32 - (Maxlayer - 1)) OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(0, Digits), NormalizeDouble(ld_108 + Point * li_12, Digits), 0, Green);
      if (HedgeOn == TRUE) {
         if (HedgeCloseStrategy == 1) {
            OrderSelect(li_8, SELECT_BY_POS);
            if (OrderType() == OP_SELL && OrderComment() == ls_60 && OrderStopLoss() != NormalizeDouble(ld_108 + Point * li_12, Digits)) OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(ld_108 + Point * li_12, Digits), NormalizeDouble(0, Digits), 0, Green);
            if (OrderType() == OP_BUY && OrderComment() == ls_60 && OrderStopLoss() != NormalizeDouble(ld_92 - Point * li_12, Digits)) OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(ld_92 - Point * li_12, Digits), NormalizeDouble(0, Digits), 0, Green);
         }
         if (HedgeCloseStrategy == 2) {
            OrderSelect(li_8, SELECT_BY_POS);
            if (OrderType() == OP_SELL && OrderComment() == ls_60 && OrderStopLoss() != NormalizeDouble(ld_108 + Point * li_12, Digits) && li_36 < HedgeCloseLayer) OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(ld_108 + Point * li_12, Digits), NormalizeDouble(0, Digits), 0, Green);
            if (OrderType() == OP_SELL && OrderComment() == ls_60 && OrderStopLoss() != NormalizeDouble(ld_188, Digits) && li_36 >= HedgeCloseLayer) OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(ld_188, Digits), NormalizeDouble(0, Digits), 0, Green);
            if (OrderType() == OP_BUY && OrderComment() == ls_60 && OrderStopLoss() != NormalizeDouble(ld_92 - Point * li_12, Digits) && li_40 < HedgeCloseLayer) OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(ld_92 - Point * li_12, Digits), NormalizeDouble(0, Digits), 0, Green);
            if (OrderType() == OP_BUY && OrderComment() == ls_60 && OrderStopLoss() != NormalizeDouble(ld_204, Digits) && li_40 >= HedgeCloseLayer) OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(ld_204, Digits), NormalizeDouble(0, Digits), 0, Green);
         }
      }
   }
   if (li_28 == 0) {
      if (Bid - NormalizeDouble(ld_124, Digits) > Point * li_16) li_0 = OrderSend(Symbol(), OP_SELL, ld_132, Bid, li_20, 0, 0, ls_52, 0, 0, Green);
   } else {
      if (Bid - ld_148 > Point * li_16) li_0 = OrderSend(Symbol(), OP_SELL, ld_132, Bid, li_20, 0, 0, ls_52, li_28 + 1, 0, Green);
      if (HedgeOn == TRUE && li_28 - li_40 - HedgeFromLayer > 0 && li_40 == 0) li_0 = OrderSend(Symbol(), OP_BUY, ld_140, Ask, li_20, 0, 0, ls_60, li_40 + 1, 0, Green);
      else
         if (HedgeOn == TRUE && li_28 - li_40 - HedgeFromLayer > 0 && Ask - ld_172 > Point * li_16) li_0 = OrderSend(Symbol(), OP_BUY, ld_140, Ask, li_20, 0, 0, ls_60, li_40 + 1, 0, Green);
   }
   if (li_32 == 0) {
      if (NormalizeDouble(ld_124, Digits) - Ask > Point * li_16) li_0 = OrderSend(Symbol(), OP_BUY, ld_132, Ask, li_20, 0, 0, ls_52, 0, 0, Green);
   } else {
      if (ld_156 - Ask > Point * li_16) li_0 = OrderSend(Symbol(), OP_BUY, ld_132, Ask, li_20, 0, 0, ls_52, li_32 + 1, 0, Green);
      if (HedgeOn == TRUE && li_32 - li_36 - HedgeFromLayer > 0 && li_36 == 0) li_0 = OrderSend(Symbol(), OP_SELL, ld_140, Bid, li_20, 0, 0, ls_60, li_36 + 1, 0, Green);
      else
         if (HedgeOn == TRUE && li_32 - li_36 - HedgeFromLayer > 0 && ld_164 - Bid > Point * li_16) li_0 = OrderSend(Symbol(), OP_SELL, ld_140, Bid, li_20, 0, 0, ls_60, li_36 + 1, 0, Green);
   }
   if (HedgeOn == TRUE && AccountEquity() > AccountBalance() && li_36 > 0 || li_40 > 0) {
      for (li_8 = 0; li_8 <= OrdersTotal() - 1; li_8++) {
         OrderSelect(li_8, SELECT_BY_POS);
         if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), Ask, li_20, Red);
         if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, li_20, Red);
      }
   }
   return (0);
}