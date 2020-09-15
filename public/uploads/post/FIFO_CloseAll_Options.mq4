//+------------------------------------------------------------------+
//|                                                FIFO_CloseAll.mq4 |
//|                                      Copyright 2017, nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, nicholishen"
#property link      "https://www.forexfactory.com/nicholishen"
#property version   "1.00"
#property strict
#property script_show_inputs
#include <Arrays\List.mqh>
#include <stdlib.mqh>

class Order : public CObject
{
public:
   int ticket;
   datetime open_time;
   Order(int ticket_number,datetime ticket_open_time)
   {
      ticket = ticket_number;
      open_time = ticket_open_time;
   }
   int Compare(const CObject *node,const int mode=0)const override
   {
      Order *other = (Order*)node;
      if(mode==1)
      {
         if(this.open_time>other.open_time)return 1;
         if(this.open_time<other.open_time)return -1;
      }
      else
      { 
         if(this.ticket>other.ticket)return 1;
         if(this.ticket<other.ticket)return -1;
      }
      return 0;
   }
};

enum MODE_SYMBOLS
{
   SYMBOLS_ALL, //All Symbols
   SYMBOLS_THIS //Chart Symbol Only
};

enum MODE_ORDER_TYPE
{
   ORDERS_ALL,//Close all order types
   ORDERS_POSITIONS,//Close only open positions
   ORDERS_PENDING//Close only pending orders
};

//--- input parameters
input MODE_SYMBOLS    Mode_Symbols= SYMBOLS_ALL;//Which Symbol?
input MODE_ORDER_TYPE Mode_Orders = ORDERS_ALL;//Which Order Type?
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
//---
   CList list;
   for(int i=OrdersTotal();i>=0;i--)
      if(OrderSelect(i,SELECT_BY_POS)&&(Mode_Symbols==SYMBOLS_ALL || OrderSymbol()==_Symbol))
         list.Add(new Order(OrderTicket(),OrderOpenTime()));

   list.Sort(1); // by time
   list.Sort(0); // then by ticket number
   
   for(Order *order = list.GetFirstNode();order!=NULL;order=order.Next())
   {
      if(OrderSelect(order.ticket,SELECT_BY_TICKET))
      {
         if(OrderType()>1 && (Mode_Orders==ORDERS_ALL || Mode_Orders==ORDERS_PENDING))
         {
            if(!OrderDelete(order.ticket))
               Print("OrderDeleteError: ",ErrorDescription(GetLastError()));
            continue;
         }
         else
         if(OrderType()<2 &&(Mode_Orders==ORDERS_ALL || Mode_Orders==ORDERS_POSITIONS))
         {
            MqlTick tick;
            SymbolInfoTick(OrderSymbol(),tick);
            double price = OrderType()==OP_BUY?tick.bid:tick.ask;
            if(!OrderClose(OrderTicket(),OrderLots(),price,10))
               Print("OrderCloseError: ",ErrorDescription(GetLastError()));   
            continue;     
         }
      }
      else
         Print("OrderSelectError: ",ErrorDescription(GetLastError()));
   }
}
//+------------------------------------------------------------------+
