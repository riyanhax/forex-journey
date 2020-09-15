
#property copyright "vcapsis"
#property link "vcapsis"
#property indicator_chart_window

//---- input parameters

int nDigits;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
if(Symbol()=="GBPJPY" || Symbol()=="EURJPY" || Symbol()=="USDJPY" || Symbol()=="GOLD")  nDigits = 3;
   else nDigits = 5;

   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
  ObjectDelete("1RSIobj");
  ObjectDelete("1TitleObj");
  ObjectDelete("1RSI1");
  ObjectDelete("1RSI2");
  ObjectDelete("1RSI3");
  ObjectDelete("1RSI4");
  ObjectDelete("1RSI5");
  return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   //----
   
   int RSI1=0, RSI2=0, RSI3=0, RSI4=0, RSI5=0;
   
// Define the objects     
   ObjectCreate("1RSIobj",OBJ_LABEL,0,0,0);
   ObjectCreate("1Titleobj",OBJ_LABEL,0,0,0);

  
// Set the upper right corner to display   
   ObjectSet("1RSIobj",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSet("1Titleobj",OBJPROP_CORNER,CORNER_RIGHT_UPPER);

 
   
// Display the 2 titles   
   ObjectSet("1Titleobj",OBJPROP_XDISTANCE,53);
   ObjectSet("1Titleobj",OBJPROP_YDISTANCE,10);
   ObjectSetText("1Titleobj","1H 30m 15m 5m 1m" ,12,"Courier",White);
   
   ObjectSet("1RSIobj",OBJPROP_XDISTANCE,200);
   ObjectSet("1RSIobj",OBJPROP_YDISTANCE,60);
   ObjectSetText("1RSIobj","RSI PRV ",12,"Courier",White);
   
     
 
   

//  LONG DAILY TRENDS  
      // 1st trend indicator EMA(10) vs Current price
        RSI1=Lime;
    if (iRSI(NULL,PERIOD_H1,55,PRICE_CLOSE,1) < 50)
        RSI1=Red; 
  
       RSI2=Lime;
    if (iRSI(NULL,PERIOD_M30,55,PRICE_CLOSE,1) < 50)
        RSI2=Red; 
        
       RSI3=Lime;
    if (iRSI(NULL,PERIOD_M15,55,PRICE_CLOSE,1) < 50)
        RSI3=Red;        

        RSI4=Lime;
    if (iRSI(NULL,PERIOD_M5,55,PRICE_CLOSE,1) < 50)
        RSI4=Red;  
        
       RSI5=Lime;
    if (iRSI(NULL,PERIOD_M1,55,PRICE_CLOSE,1) < 50)
        RSI5=Red;       
 
   
    
// Display boxes 
   ObjectCreate("1RSI1",OBJ_LABEL,0,0,0); 
   ObjectSet("1RSI1",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSet("1RSI1",OBJPROP_XDISTANCE,170);
   ObjectSet("1RSI1",OBJPROP_YDISTANCE,13);
   ObjectSetText("1RSI1","-",70,"Tahoma Narrow",RSI1);
   
   ObjectCreate("1RSI2",OBJ_LABEL,0,0,0); 
   ObjectSet("1RSI2",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSet("1RSI2",OBJPROP_XDISTANCE,140);
   ObjectSet("1RSI2",OBJPROP_YDISTANCE,13);
   ObjectSetText("1RSI2","-",70,"Tahoma Narrow",RSI2);
   
   ObjectCreate("1RSI3",OBJ_LABEL,0,0,0); 
   ObjectSet("1RSI3",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSet("1RSI3",OBJPROP_XDISTANCE,110);
   ObjectSet("1RSI3",OBJPROP_YDISTANCE,13);
   ObjectSetText("1RSI3","-",70,"Tahoma Narrow",RSI3);
   
   ObjectCreate("1RSI4",OBJ_LABEL,0,0,0); 
   ObjectSet("1RSI4",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSet("1RSI4",OBJPROP_XDISTANCE,80);
   ObjectSet("1RSI4",OBJPROP_YDISTANCE,13);
   ObjectSetText("1RSI4","-",70,"Tahoma Narrow",RSI4);
   
   ObjectCreate("1RSI5",OBJ_LABEL,0,0,0); 
   ObjectSet("1RSI5",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSet("1RSI5",OBJPROP_XDISTANCE,50);
   ObjectSet("1RSI5",OBJPROP_YDISTANCE,13);
   ObjectSetText("1RSI5","-",70,"Tahoma Narrow",RSI5);
   return(0);
  }  
   
   
   
  