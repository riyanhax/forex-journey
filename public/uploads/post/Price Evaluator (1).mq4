//+------------------------------------------------------------------+
//|                                              Price Evaluator.mq4 |
//|                    Copyright © 2007-2016, Tradingsystemforex.com |
//|                              http://www.tradingsystemforex.com/  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007-2016, Tradingsystemforex.com"
#property link "http://www.tradingsystemforex.com/"

#property  indicator_chart_window

int CountBars=20000;

double total;
int count;

double point=0.0001;
double minlots=0.1;
double maxlots=0.1;
double lotstep=0.1;
int dg;
double factorpoint;

datetime newbar;
double spread;
datetime Newbar;
double Total;
double Total2;
double Total3;
int counttotal;
double average;
double average2;
double pClose;

datetime timegmt;
int gmthour;  
int lasttime;

//+------------------------------------------------------------------+

int init(){

   if(Digits<=3)dg=2;else dg=4;
   if(Digits<=3)point=0.01;
   
   if(Digits==5){dg=4;point=0.0001;factorpoint=10;}
   if(Digits==4){dg=4;point=0.0001;factorpoint=1;}
   if(Digits==3){dg=2;point=0.01;factorpoint=10;}
   if(Digits==2){dg=2;point=0.01;factorpoint=1;}
   if(Digits==1){dg=1;point=0.1;factorpoint=1;}
   
   spread=(Ask-Bid)/point;

   return(0);
}

int deinit(){
   GlobalVariablesDeleteAll();
   Comment("");
 return(0);
}

//+------------------------------------------------------------------+

int start(){
   timegmt=TimeGMT();
   gmthour=StringToDouble(StringSubstr(TimeToStr(timegmt),11,2));
   
   if(Bars < 100){IndicatorShortName("Bars less than 100"); return(0);}

   total=0;
   count=0;

   //int i=CountBars;

   if(pClose!=Close[0]){
      Total+=(Ask-Bid)/point;
      if(lasttime!=0)Total2+=(TimeCurrent()-lasttime);
      if(lasttime!=0 && (TimeCurrent()-lasttime)>=5)Total3+=(TimeCurrent()-lasttime);
      counttotal+=1;
      pClose=Close[0];
      lasttime=TimeCurrent();
   }

   if(Newbar!=iTime(NULL,60,0)){
      
      if(counttotal>1){
         average=NormalizeDouble(Total/counttotal,1);
         average2=NormalizeDouble(Total2/counttotal,1);
         //Print(Symbol()+", Av Spread, "+DoubleToString(TimeHour(TimeCurrent()),0)+":"+DoubleToString(TimeMinute(TimeCurrent()),0)+" "+DoubleToString(average,1));
      }
      Total=0;
      Total2=0;
      
      if(gmthour==0){GlobalVariableSet(Symbol()+"s23",average);GlobalVariableSet(Symbol()+"t23",average2);GlobalVariableSet(Symbol()+"f23",Total3);GlobalVariableSet(Symbol()+"tck23",counttotal);}
      if(gmthour==1){GlobalVariableSet(Symbol()+"s0",average);GlobalVariableSet(Symbol()+"t0",average2);GlobalVariableSet(Symbol()+"f0",Total3);GlobalVariableSet(Symbol()+"tck0",counttotal);}
      if(gmthour==2){GlobalVariableSet(Symbol()+"s1",average);GlobalVariableSet(Symbol()+"t1",average2);GlobalVariableSet(Symbol()+"f1",Total3);GlobalVariableSet(Symbol()+"tck1",counttotal);}
      if(gmthour==3){GlobalVariableSet(Symbol()+"s2",average);GlobalVariableSet(Symbol()+"t2",average2);GlobalVariableSet(Symbol()+"f2",Total3);GlobalVariableSet(Symbol()+"tck2",counttotal);}
      if(gmthour==4){GlobalVariableSet(Symbol()+"s3",average);GlobalVariableSet(Symbol()+"t3",average2);GlobalVariableSet(Symbol()+"f3",Total3);GlobalVariableSet(Symbol()+"tck3",counttotal);}
      if(gmthour==5){GlobalVariableSet(Symbol()+"s4",average);GlobalVariableSet(Symbol()+"t4",average2);GlobalVariableSet(Symbol()+"f4",Total3);GlobalVariableSet(Symbol()+"tck4",counttotal);}
      if(gmthour==6){GlobalVariableSet(Symbol()+"s5",average);GlobalVariableSet(Symbol()+"t5",average2);GlobalVariableSet(Symbol()+"f5",Total3);GlobalVariableSet(Symbol()+"tck5",counttotal);}
      if(gmthour==7){GlobalVariableSet(Symbol()+"s6",average);GlobalVariableSet(Symbol()+"t6",average2);GlobalVariableSet(Symbol()+"f6",Total3);GlobalVariableSet(Symbol()+"tck6",counttotal);}
      if(gmthour==8){GlobalVariableSet(Symbol()+"s7",average);GlobalVariableSet(Symbol()+"t7",average2);GlobalVariableSet(Symbol()+"f7",Total3);GlobalVariableSet(Symbol()+"tck7",counttotal);}
      if(gmthour==9){GlobalVariableSet(Symbol()+"s8",average);GlobalVariableSet(Symbol()+"t8",average2);GlobalVariableSet(Symbol()+"f8",Total3);GlobalVariableSet(Symbol()+"tck8",counttotal);}
      if(gmthour==10){GlobalVariableSet(Symbol()+"s9",average);GlobalVariableSet(Symbol()+"t9",average2);GlobalVariableSet(Symbol()+"f9",Total3);GlobalVariableSet(Symbol()+"tck9",counttotal);}
      if(gmthour==11){GlobalVariableSet(Symbol()+"s10",average);GlobalVariableSet(Symbol()+"t10",average2);GlobalVariableSet(Symbol()+"f10",Total3);GlobalVariableSet(Symbol()+"tck10",counttotal);}
      if(gmthour==12){GlobalVariableSet(Symbol()+"s11",average);GlobalVariableSet(Symbol()+"t11",average2);GlobalVariableSet(Symbol()+"f11",Total3);GlobalVariableSet(Symbol()+"tck11",counttotal);}
      if(gmthour==13){GlobalVariableSet(Symbol()+"s12",average);GlobalVariableSet(Symbol()+"t12",average2);GlobalVariableSet(Symbol()+"f12",Total3);GlobalVariableSet(Symbol()+"tck12",counttotal);}
      if(gmthour==14){GlobalVariableSet(Symbol()+"s13",average);GlobalVariableSet(Symbol()+"t13",average2);GlobalVariableSet(Symbol()+"f13",Total3);GlobalVariableSet(Symbol()+"tck13",counttotal);}
      if(gmthour==15){GlobalVariableSet(Symbol()+"s14",average);GlobalVariableSet(Symbol()+"t14",average2);GlobalVariableSet(Symbol()+"f14",Total3);GlobalVariableSet(Symbol()+"tck14",counttotal);}
      if(gmthour==16){GlobalVariableSet(Symbol()+"s15",average);GlobalVariableSet(Symbol()+"t15",average2);GlobalVariableSet(Symbol()+"f15",Total3);GlobalVariableSet(Symbol()+"tck15",counttotal);}
      if(gmthour==17){GlobalVariableSet(Symbol()+"s16",average);GlobalVariableSet(Symbol()+"t16",average2);GlobalVariableSet(Symbol()+"f16",Total3);GlobalVariableSet(Symbol()+"tck16",counttotal);}
      if(gmthour==18){GlobalVariableSet(Symbol()+"s17",average);GlobalVariableSet(Symbol()+"t17",average2);GlobalVariableSet(Symbol()+"f17",Total3);GlobalVariableSet(Symbol()+"tck17",counttotal);}
      if(gmthour==19){GlobalVariableSet(Symbol()+"s18",average);GlobalVariableSet(Symbol()+"t18",average2);GlobalVariableSet(Symbol()+"f18",Total3);GlobalVariableSet(Symbol()+"tck18",counttotal);}
      if(gmthour==20){GlobalVariableSet(Symbol()+"s19",average);GlobalVariableSet(Symbol()+"t19",average2);GlobalVariableSet(Symbol()+"f19",Total3);GlobalVariableSet(Symbol()+"tck19",counttotal);}
      if(gmthour==21){GlobalVariableSet(Symbol()+"s20",average);GlobalVariableSet(Symbol()+"t20",average2);GlobalVariableSet(Symbol()+"f20",Total3);GlobalVariableSet(Symbol()+"tck20",counttotal);}
      if(gmthour==22){GlobalVariableSet(Symbol()+"s21",average);GlobalVariableSet(Symbol()+"t21",average2);GlobalVariableSet(Symbol()+"f21",Total3);GlobalVariableSet(Symbol()+"tck21",counttotal);}
      if(gmthour==23){GlobalVariableSet(Symbol()+"s22",average);GlobalVariableSet(Symbol()+"t22",average2);GlobalVariableSet(Symbol()+"f22",Total3);GlobalVariableSet(Symbol()+"tck22",counttotal);}
   
      Total3=0;
      counttotal=0;
      
      Print("Spread : "
      +", s0 "+GlobalVariableGet(Symbol()+"s0")+", s1 "+GlobalVariableGet(Symbol()+"s1")+", s2 "+GlobalVariableGet(Symbol()+"s2")+", s3 "+GlobalVariableGet(Symbol()+"s3")
      +", s4 "+GlobalVariableGet(Symbol()+"s4")+", s5 "+GlobalVariableGet(Symbol()+"s5")+", s6 "+GlobalVariableGet(Symbol()+"s6")+", s7 "+GlobalVariableGet(Symbol()+"s7")
      +", s8 "+GlobalVariableGet(Symbol()+"s8")+", s9 "+GlobalVariableGet(Symbol()+"s9")+", s10 "+GlobalVariableGet(Symbol()+"s10")+", s11 "+GlobalVariableGet(Symbol()+"s11")
      +", s12 "+GlobalVariableGet(Symbol()+"s12")+", s13 "+GlobalVariableGet(Symbol()+"s13")+", s14 "+GlobalVariableGet(Symbol()+"s14")+", s15 "+GlobalVariableGet(Symbol()+"s15")
      +", s16 "+GlobalVariableGet(Symbol()+"s16")+", s17 "+GlobalVariableGet(Symbol()+"s17")+", s18 "+GlobalVariableGet(Symbol()+"s18")+", s19 "+GlobalVariableGet(Symbol()+"s19")
      +", s20 "+GlobalVariableGet(Symbol()+"s20")+", s21 "+GlobalVariableGet(Symbol()+"s21")+", s22 "+GlobalVariableGet(Symbol()+"s22")+", s23 "+GlobalVariableGet(Symbol()+"s23"));
      
      Print("Time : "
      +", t0 "+GlobalVariableGet(Symbol()+"t0")+", t1 "+GlobalVariableGet(Symbol()+"t1")+", t2 "+GlobalVariableGet(Symbol()+"t2")+", t3 "+GlobalVariableGet(Symbol()+"t3")
      +", t4 "+GlobalVariableGet(Symbol()+"t4")+", t5 "+GlobalVariableGet(Symbol()+"t5")+", t6 "+GlobalVariableGet(Symbol()+"t6")+", t7 "+GlobalVariableGet(Symbol()+"t7")
      +", t8 "+GlobalVariableGet(Symbol()+"t8")+", t9 "+GlobalVariableGet(Symbol()+"t9")+", t10 "+GlobalVariableGet(Symbol()+"t10")+", t11 "+GlobalVariableGet(Symbol()+"t11")
      +", t12 "+GlobalVariableGet(Symbol()+"t12")+", t13 "+GlobalVariableGet(Symbol()+"t13")+", t14 "+GlobalVariableGet(Symbol()+"t14")+", t15 "+GlobalVariableGet(Symbol()+"t15")
      +", t16 "+GlobalVariableGet(Symbol()+"t16")+", t17 "+GlobalVariableGet(Symbol()+"t17")+", t18 "+GlobalVariableGet(Symbol()+"t18")+", t19 "+GlobalVariableGet(Symbol()+"t19")
      +", t20 "+GlobalVariableGet(Symbol()+"t20")+", t21 "+GlobalVariableGet(Symbol()+"t21")+", t22 "+GlobalVariableGet(Symbol()+"t22")+", t23 "+GlobalVariableGet(Symbol()+"t23"));
      
      Print("Freeze : "
      +", f0 "+GlobalVariableGet(Symbol()+"f0")+", f1 "+GlobalVariableGet(Symbol()+"f1")+", f2 "+GlobalVariableGet(Symbol()+"f2")+", f3 "+GlobalVariableGet(Symbol()+"f3")
      +", f4 "+GlobalVariableGet(Symbol()+"f4")+", f5 "+GlobalVariableGet(Symbol()+"f5")+", f6 "+GlobalVariableGet(Symbol()+"f6")+", f7 "+GlobalVariableGet(Symbol()+"f7")
      +", f8 "+GlobalVariableGet(Symbol()+"f8")+", f9 "+GlobalVariableGet(Symbol()+"f9")+", f10 "+GlobalVariableGet(Symbol()+"f10")+", f11 "+GlobalVariableGet(Symbol()+"f11")
      +", f12 "+GlobalVariableGet(Symbol()+"f12")+", f13 "+GlobalVariableGet(Symbol()+"f13")+", f14 "+GlobalVariableGet(Symbol()+"f14")+", f15 "+GlobalVariableGet(Symbol()+"f15")
      +", f16 "+GlobalVariableGet(Symbol()+"f16")+", f17 "+GlobalVariableGet(Symbol()+"f17")+", f18 "+GlobalVariableGet(Symbol()+"f18")+", f19 "+GlobalVariableGet(Symbol()+"f19")
      +", f20 "+GlobalVariableGet(Symbol()+"f20")+", f21 "+GlobalVariableGet(Symbol()+"f21")+", f22 "+GlobalVariableGet(Symbol()+"f22")+", f23 "+GlobalVariableGet(Symbol()+"f23"));
      
      Print("Ticks : "
      +", tck0 "+GlobalVariableGet(Symbol()+"tck0")+", tck1 "+GlobalVariableGet(Symbol()+"tck1")+", tck2 "+GlobalVariableGet(Symbol()+"tck2")+", tck3 "+GlobalVariableGet(Symbol()+"tck3")
      +", tck4 "+GlobalVariableGet(Symbol()+"tck4")+", tck5 "+GlobalVariableGet(Symbol()+"tck5")+", tck6 "+GlobalVariableGet(Symbol()+"tck6")+", tck7 "+GlobalVariableGet(Symbol()+"tck7")
      +", tck8 "+GlobalVariableGet(Symbol()+"tck8")+", tck9 "+GlobalVariableGet(Symbol()+"tck9")+", tck10 "+GlobalVariableGet(Symbol()+"tck10")+", tck11 "+GlobalVariableGet(Symbol()+"tck11")
      +", tck12 "+GlobalVariableGet(Symbol()+"tck12")+", tck13 "+GlobalVariableGet(Symbol()+"tck13")+", tck14 "+GlobalVariableGet(Symbol()+"tck14")+", tck15 "+GlobalVariableGet(Symbol()+"tck15")
      +", tck16 "+GlobalVariableGet(Symbol()+"tck16")+", tck17 "+GlobalVariableGet(Symbol()+"tck17")+", tck18 "+GlobalVariableGet(Symbol()+"tck18")+", tck19 "+GlobalVariableGet(Symbol()+"tck19")
      +", tck20 "+GlobalVariableGet(Symbol()+"tck20")+", tck21 "+GlobalVariableGet(Symbol()+"tck21")+", tck22 "+GlobalVariableGet(Symbol()+"tck22")+", tck23 "+GlobalVariableGet(Symbol()+"tck23"));
      
      Newbar=iTime(NULL,60,0);
   }

   if(counttotal!=0)Comment(
   "\n GMT hour "+gmthour,
   "\n\n Last close "+pClose,
   "\n Total "+Total+" (pips)",
   "\n Spread average "+DoubleToString(Total/counttotal,1)+" (pips)",
   "\n\n Last time "+lasttime,
   "\n Total2 "+Total2+" (seconds)",
   "\n Time average "+DoubleToString(Total2/counttotal,1)+" (seconds)",
   "\n\n Freeze "+Total3+" (seconds)",
   "\n\n Ticks "+counttotal+" (ticks)"
   );

   return(0);
}