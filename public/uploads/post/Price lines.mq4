
 #property copyright "eevviill"
 #property link      "http://volli7.blogspot.com/"
 #property version   "1.0"
 //#property icon "\\Files\\evi.ico"
 #property strict
 #property indicator_chart_window

 #property indicator_buffers 0




extern color line_color_buy = clrLime;
extern color line_color_sell = clrRed;
extern int  lines_width = 3;
extern ENUM_LINE_STYLE lines_style = STYLE_SOLID;
extern string identif = "lines_ddra_1";



/////////////////////////////////////////////////////////////////
 int OnInit()
  {
  EventSetTimer(1);

 string name_delete;
 for(int i=ObjectsTotal()-1;i>=0;i--)
 {
 name_delete=ObjectName(i);
 if(StringFind(name_delete,identif)!=-1) ObjectDelete(name_delete);
 }


   return(INIT_SUCCEEDED);
  }


//////////////////////////////////////////////////////////////
 void OnDeinit(const int reason)
 {
 string name_delete;
 for(int i=ObjectsTotal()-1;i>=0;i--)
 {
 name_delete=ObjectName(i);
 if(StringFind(name_delete,identif)!=-1) ObjectDelete(name_delete);
 }

 }


/////////////////////////////////////////////////////////////
void OnTimer()
{
//draw line+set price
int type=-1;
 for (int i=OrdersTotal()-1; i>=0; i--)
 {
   if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
   if(OrderSymbol()!=Symbol()) continue;
     type=OrderType();
    
   if(type==OP_BUY || type==OP_BUYSTOP || type==OP_BUYLIMIT)     drawLine_f(OrderTicket(),1,OrderOpenPrice(),"OP");
   if(type==OP_SELL || type==OP_SELLSTOP || OP_SELLLIMIT)     drawLine_f(OrderTicket(),-1,OrderOpenPrice(),"OP");
 }


//del line if no order
string name_delete;
 for(int i=ObjectsTotal()-1;i>=0;i--)
 {
 name_delete=ObjectName(i);
 if(StringFind(name_delete,identif)!=-1 && no_order_f(int(name_delete))) ObjectDelete(name_delete);
 }
 


}

//////////////////////////////////////////////////////////////////
 int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],const double &high[],
                const double &low[],const double &close[],const long &tick_volume[],const long &volume[],const int &spread[])
  {


   return(rates_total);
  }
  
  
//funcs  
////////////////////////////////////////////////////////////
void drawLine_f(int ticket,int way,double price,string add)
{
   string name = string(ticket)+identif+"lines"+add;

   

      if(ObjectFind(0,name)==-1) 
      {
      ObjectCreate(0,name,OBJ_HLINE,0,0,price);
         ObjectSetInteger(0,name,OBJPROP_WIDTH,lines_width);
         ObjectSetInteger(0,name,OBJPROP_STYLE,lines_style);
         ObjectSetInteger(0,name,OBJPROP_BACK,true);
         ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false); 
         ObjectSetInteger(0,name,OBJPROP_SELECTED,false); 
         ObjectSetInteger(0,name,OBJPROP_HIDDEN,true); 
         ObjectSetInteger(0,name,OBJPROP_ZORDER,false);
         
         if (way==1) ObjectSetInteger(0,name,OBJPROP_COLOR,line_color_buy);
         else  
         if(way==-1) ObjectSetInteger(0,name,OBJPROP_COLOR,line_color_sell);
       }
      ObjectSetDouble(0,name,OBJPROP_PRICE,price);
         
}

//////////////////////////////////////////////////////////
bool no_order_f(int tick)
{
bool no_ord=true;

 for (int i=OrdersTotal()-1; i>=0; i--)
 {
   if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
    
    if(OrderTicket()==tick) 
    {
    no_ord=false;
    break;
    }
  
 }
 

return(no_ord);
}

