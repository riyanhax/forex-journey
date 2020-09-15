//+------------------------------------------------------------------+
//|                                         HedgeAccountCloseAll.mq4 |
//|                                      Copyright 2017, nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, nicholishen"
#property link      "https://www.forexfactory.com/nicholishen"
#property version   "1.00"
#property strict

#include <Arrays\ArrayObj.mqh>
#include <stdlib.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OpenTradeSymbol : public CObject
{
protected:
   string m_symbol;
public:
   OpenTradeSymbol(string symbol):m_symbol(symbol){}
   double Size()const 
   {
      double net_size=0.0;
      for(int i=OrdersTotal()-1;i>=0;i--)
      {
         if(OrderSelect(i,SELECT_BY_POS)&&OrderSymbol()==m_symbol)
         {
            if(OrderType()==OP_BUY)
               net_size+=OrderLots();
            else
            if(OrderType()==OP_SELL)
               net_size-=OrderLots();
         }  
      } 
      return net_size;  
   }
   string Symbol()   { return m_symbol;}
   int Compare(const CObject *node,const int mode=0)const override
   {
      OpenTradeSymbol* other = (OpenTradeSymbol*)node;
      if(fabs(this.Size())>fabs(other.Size()))return -1;
      if(fabs(this.Size())<fabs(other.Size()))return 1;
      return 0;
   }
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PendingOrder : public CObject
{
protected:
   int m_ticket;
public:
   PendingOrder(int ticket):m_ticket(ticket){}
   int Ticket(){return m_ticket;}
   int Points()const
   {
      if(!OrderSelect(m_ticket,SELECT_BY_TICKET))
         return 0;
      double _point = SymbolInfoDouble(OrderSymbol(),SYMBOL_POINT);
      double bid = SymbolInfoDouble(OrderSymbol(),SYMBOL_BID);
      return int(fabs(OrderOpenPrice()-bid));
   }
   int Compare(const CObject *node,const int mode=0)const override
   {
      PendingOrder* other = (PendingOrder*)node;
      if(fabs(this.Points())>fabs(other.Points()))return 1;
      if(fabs(this.Points())<fabs(other.Points()))return -1;
      return 0;
   }
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TradeManager : public CArrayObj
{
public:
   OpenTradeSymbol* operator[](int i){return At(i);}
   void HedgeAll()
   {
      int num_open = 0;
      ulong ms = GetTickCount();
      for(int i=OrdersTotal()-1;i>=0;i--)
      {
         if(OrderSelect(i,SELECT_BY_POS)&&OrderType()<2)
         {
            num_open++;
            bool found = false;
            for(int j=0;j<Total();j++)
            {   
               if(this[j].Symbol()==OrderSymbol())
               {
                  found=true;
                  break;     
               }
            }
            if(!found)
            {
               Add(new OpenTradeSymbol(OrderSymbol()));
            }
         }
      }
      Sort();
      int attempts = 0;
      bool is_hedged = false;
      int num_symbols = Total();
      while(!is_hedged&&!IsStopped()&&attempts<3)
      {
         attempts++;
         for(int i=0;i<Total();i++)
         {
            double size = NormalizeDouble(this[i].Size(),2);
            string symbol = this[i].Symbol();
            if(size > 0.0)
            {
               double price = SymbolInfoDouble(symbol,SYMBOL_BID);
               if(OrderSend(symbol,OP_SELL,size,price,0,0,0)<0)
                  Print("HedgeOrderError: ",ErrorDescription(GetLastError()));
            }
            else
            if(size < 0.0)
            {
               double price = SymbolInfoDouble(symbol,SYMBOL_ASK);
               if(OrderSend(symbol,OP_BUY,fabs(size),price,0,0,0)<0)
                  Print("HedgeOrderError: ",ErrorDescription(GetLastError()));
            }
         }
         is_hedged=IsHedged();
      } 
      ms = GetTickCount()-ms;
      if(is_hedged)
      {
         Alert(string(num_open)+" trades on "+string(num_symbols)+" symbols closed in "+string(ms)+" ms. Order reconciliation will happen after any pending orders are closed.");
      }
   }
   void CloseByHedge()
   {
      for(int s=0;s<Total();s++)
      {
         string symbol = this[s].Symbol();
         for(int i=OrdersTotal()-1;i>0&&!IsStopped();i--)
         {
            if(OrderSelect(i,SELECT_BY_POS)
               && OrderSymbol()==symbol 
               && OrderType()<2 
               //&& (!m_locked_magic || OrderMagicNumber() == MAGIC)
               )
            {
               int type = OrderType();
               int ticket = OrderTicket();
               for(int j=i-1;OrderSelect(j,SELECT_BY_POS);j--)
               {
                  if(OrderSymbol()==symbol 
                     && OrderType()<2 
                     && OrderType()!=type 
                     //&& (!m_locked_magic || OrderMagicNumber() == MAGIC)
                     )
                  {
                     if(!OrderCloseBy(OrderTicket(),ticket))
                        Print("OrderCLoseByError: ",ErrorDescription(GetLastError()));
                     i=OrdersTotal();
                     break; 
                  }
               }
            }
         }   
      }
   }
   void ClosePending()
   {
      int attempts = 0;
      while(!IsStopped()&&!AllPendingClosed()&&attempts<3)
      {
         CArrayObj list;
         for(int i=OrdersTotal();i>=0;i--)
         {
            if(OrderSelect(i,SELECT_BY_POS)&&OrderType()>=2)
               list.Add(new PendingOrder(OrderTicket()));
         }
         list.Sort();
         int i=0;
         for(PendingOrder *ord=list.At(i);ord!=NULL;ord=list.At(++i))
         {
            if(!OrderDelete(ord.Ticket()))
               Print("OrderDeleteError: ",ErrorDescription(GetLastError()));   
         }
         attempts++;
      }
   }
protected:
   bool  IsHedged()
   {
      for(int i=0;i<Total();i++)
         if(NormalizeDouble(this[i].Size(),2)!=0.0)
            return false;
      return true;
   }
   bool  AllPendingClosed()
   {
      for(int i=OrdersTotal();i>=0;i--)
         if(OrderSelect(i,SELECT_BY_POS)&&OrderType()>=2)
            return false;
      return true;
   }
};
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   TradeManager trades;
   trades.HedgeAll();
   trades.ClosePending();
   trades.CloseByHedge();
}
//+------------------------------------------------------------------+
